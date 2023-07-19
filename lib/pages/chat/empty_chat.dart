
import 'package:fluffychat/domain/app_state/direct_chat/create_direct_chat_loading.dart';
import 'package:fluffychat/domain/app_state/direct_chat/create_direct_chat_success.dart';
import 'package:fluffychat/domain/usecase/create_direct_chat_interactor.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/empty_chat_view.dart';
import 'package:fluffychat/presentation/mixin/image_picker_mixin.dart';
import 'package:fluffychat/presentation/mixin/send_files_mixin.dart';
import 'package:fluffychat/presentation/model/presentation_contact.dart';
import 'package:fluffychat/presentation/model/presentation_contact_constant.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fluffychat/di/global/get_it_initializer.dart';
import 'package:fluffychat/utils/network_connection_service.dart';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:linagora_design_flutter/images_picker/images_picker.dart' hide ImagePicker;
import 'package:matrix/matrix.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:vrouter/vrouter.dart';

typedef OnRoomCreatedSuccess = FutureOr<void> Function(Room room)?;
typedef OnRoomCreatedFailed = FutureOr<void> Function()?;

class EmptyChat extends StatefulWidget {

  const EmptyChat({super.key});

  @override
  State<StatefulWidget> createState() => EmptyChatController();
  
}

class EmptyChatController extends State<EmptyChat> with ImagePickerMixin, SendFilesMixin {
  final createDirectChatInteractor = getIt.get<CreateDirectChatInteractor>();

  late PresentationContact? presentationContact = presentationContact = PresentationContact(
    email: VRouter.of(context).queryParameters[PresentationContactConstant.email] ?? '',
    displayName: VRouter.of(context).queryParameters[PresentationContactConstant.displayName],
    matrixId: VRouter.of(context).queryParameters[PresentationContactConstant.receiverId]
  );

  final NetworkConnectionService networkConnectionService = getIt.get<NetworkConnectionService>();

  final AutoScrollController scrollController = AutoScrollController();
  final AutoScrollController forwardListController = AutoScrollController();

  FocusNode inputFocus = FocusNode();

  bool showScrollDownButton = false;

  String inputText = '';

  bool showEmojiPicker = false;

  EmojiPickerType emojiPickerType = EmojiPickerType.keyboard;

  void _updateScrollController() {
    if (!mounted) {
      return;
    }
    if (!scrollController.hasClients) return;
    if (scrollController.position.pixels > 0 && showScrollDownButton == false) {
      setState(() => showScrollDownButton = true);
    } else if (scrollController.position.pixels == 0 &&
        showScrollDownButton == true) {
      setState(() => showScrollDownButton = false);
    }
  }

  List<IndexedAssetEntity> sortedSelectedAssets = [];

  @override
  Future<void> sendImages({Room? room, List<IndexedAssetEntity>? assets}) {
    sortedSelectedAssets = imagePickerController.sortedSelectedAssets;
    return _createRoom(onRoomCreatedSuccess: (room) {
      super.sendImages(room: room, assets: sortedSelectedAssets);
    });
  }

  @override
  void initState() {
    scrollController.addListener(_updateScrollController);
    inputFocus.addListener(_inputFocusListener);
    listenToSelectionInImagePicker();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    sendController.dispose();
    forwardListController.dispose();
    inputFocus.removeListener(_inputFocusListener);
    super.dispose();
  }

  TextEditingController sendController = TextEditingController();

  void setActiveClient(Client c) => setState(() {
    Matrix.of(context).setActiveClient(c);
  });

  Future<void> sendText({
    OnRoomCreatedSuccess onRoomCreatedSuccess, 
    OnRoomCreatedFailed onCreateRoomFailed,
  }) async {
    scrollDown();
    sendController.value = TextEditingValue(
      text: sendController.value.text,
      selection: const TextSelection.collapsed(offset: 0),
    );
    
    _createRoom(
      onRoomCreatedSuccess: (room) {
        onRoomCreatedSuccess?.call(room);
        room.sendTextEvent(
          sendController.text,
        );
      },
      onRoomCreatedFailed: onCreateRoomFailed
    );
  }

  Future<void> _createRoom({
    OnRoomCreatedSuccess onRoomCreatedSuccess,
    OnRoomCreatedFailed onRoomCreatedFailed,
  }) async {
    createDirectChatInteractor.execute(
      contactMxId: presentationContact!.matrixId!, 
      client: Matrix.of(context).client
    ).listen((event) {
      event.fold(
        (failure) {
          onRoomCreatedFailed?.call();
          Logs().d("_createRoom: $failure");
          VRouter.of(context).pop();
        },
        (success) {
          if (success is CreateDirectChatLoading) {
            showDialog(
              useRootNavigator: false,
              context: context, builder: (context) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            });
          } else if (success is CreateDirectChatSuccess) {
            final room = Matrix.of(context).client.getRoomById(success.roomId);
            if (room != null) {
              VRouter.of(context).pop();
              onRoomCreatedSuccess?.call(room);
              VRouter.of(context).toSegments(
                ['rooms', room.id],
                isReplacement: true,
              );
            }
          }
        }
      );
    });
  }

  void emojiPickerAction() {
    if (showEmojiPicker) {
      inputFocus.requestFocus();
    } else {
      inputFocus.unfocus();
    }
    emojiPickerType = EmojiPickerType.keyboard;
    setState(() => showEmojiPicker = !showEmojiPicker);
  }

  void _inputFocusListener() {
    if (showEmojiPicker && inputFocus.hasFocus) {
      emojiPickerType = EmojiPickerType.keyboard;
      if (mounted) {
        setState(() => showEmojiPicker = false);
      }
    }
  }

  void scrollDown() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(0);
    }
  }

  void onEmojiBottomSheetSelected(_, Emoji? emoji) {
    typeEmoji(emoji);
    onInputBarChanged(sendController.text);
  }

  void typeEmoji(Emoji? emoji) {
    if (emoji == null) return;
    final text = sendController.text;
    final selection = sendController.selection;
    final newText = sendController.text.isEmpty
        ? emoji.emoji
        : text.replaceRange(selection.start, selection.end, emoji.emoji);
    sendController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        // don't forget an UTF-8 combined emoji might have a length > 1
        offset: selection.baseOffset + emoji.emoji.length,
      ),
    );
  }

  void emojiPickerBackspace() {
    sendController
      ..text = sendController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
        TextPosition(offset: sendController.text.length),
      );
  }

  void onInputBarSubmitted(_) {
    sendText(
      onCreateRoomFailed: () {
        Fluttertoast.showToast(msg: 'Create room failed');
        FocusScope.of(context).requestFocus(inputFocus);
      }
    );
    
  }

  void onInputBarChanged(String text) {
    setState(() => inputText = text);
  }

  @override
  Widget build(BuildContext context) => EmptyChatView(this);
}