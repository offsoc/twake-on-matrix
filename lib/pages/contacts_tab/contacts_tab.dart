import 'package:fluffychat/di/global/get_it_initializer.dart';
import 'package:fluffychat/mixin/comparable_presentation_contact_mixin.dart';
import 'package:fluffychat/pages/contacts_tab/contacts_tab_view.dart';
import 'package:fluffychat/presentation/model/presentation_contact.dart';
import 'package:fluffychat/presentation/model/presentation_contact_constant.dart';
import 'package:fluffychat/utils/responsive/responsive_utils.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluffychat/pages/new_private_chat/fetch_contacts_controller.dart';
import 'package:fluffychat/pages/new_private_chat/search_contacts_controller.dart';
import 'package:dartz/dartz.dart' hide State;
import 'package:fluffychat/app_state/failure.dart';
import 'package:fluffychat/domain/app_state/contact/get_contacts_success.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';
import 'package:rxdart/rxdart.dart';

class ContactsTab extends StatefulWidget {
  const ContactsTab({super.key});

  @override
  State<StatefulWidget> createState() => ContactsTabController();
}

class ContactsTabController extends State<ContactsTab>
    with ComparablePresentationContactMixin {
  final searchContactsController = SearchContactsController();
  final fetchContactsController = FetchContactsController();
  final responsive = getIt.get<ResponsiveUtils>();
  final contactsStreamController =
      BehaviorSubject<Either<Failure, GetContactsSuccess>>();

  @override
  initState() {
    searchContactsController.init();
    _listenFocusTextEditing();
    listenContactsStartList();
    listenSearchContacts();
    super.initState();
    fetchContactsController.fetchCurrentTomContacts();
    fetchContactsController.listenForScrollChanged(
      fetchContactsController: fetchContactsController,
    );
    searchContactsController.onSearchKeywordChanged = (searchKey) {
      disableLoadMoreInSearch();
    };
  }

  void disableLoadMoreInSearch() {
    fetchContactsController.allowLoadMore =
        searchContactsController.searchKeyword.isEmpty;
  }

  void listenContactsStartList() {
    fetchContactsController.streamController.stream.listen((event) {
      Logs().d('NewPrivateChatController::fetchContacts() - event: $event');
      contactsStreamController.add(event);
    });
  }

  void listenSearchContacts() {
    searchContactsController.lookupStreamController.stream.listen((event) {
      Logs().d(
        'NewPrivateChatController::_fetchRemoteContacts() - event: $event',
      );
      contactsStreamController.add(event);
    });
  }

  void _listenFocusTextEditing() {
    searchContactsController.searchFocusNode.addListener(() {
      searchContactsController.isSearchModeNotifier.value =
          searchContactsController.searchFocusNode.hasFocus;
    });
  }

  void onContactTap({
    required BuildContext context,
    required String path,
    required PresentationContact contact,
  }) {
    final roomId =
        Matrix.of(context).client.getDirectChatFromUserId(contact.matrixId!);
    if (roomId == null) {
      goToDraftChat(
        context: context,
        path: path,
        contact: contact,
      );
    } else {
      showFutureLoadingDialog(
        context: context,
        future: () async {
          if (contact.matrixId != null && contact.matrixId!.isNotEmpty) {
            context.go('/$path/$roomId');
          }
        },
      );
    }
  }

  void goToDraftChat({
    required BuildContext context,
    required String path,
    required PresentationContact contact,
  }) {
    if (contact.matrixId != Matrix.of(context).client.userID) {
      Router.neglect(
        context,
        () => context.go(
          '/$path/draftChat',
          extra: {
            PresentationContactConstant.receiverId: contact.matrixId ?? '',
            PresentationContactConstant.email: contact.email ?? '',
            PresentationContactConstant.displayName: contact.displayName ?? '',
            PresentationContactConstant.status: '',
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    searchContactsController.dispose();
    fetchContactsController.dispose();
    contactsStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      ContactsTabView(contactsController: this);
}
