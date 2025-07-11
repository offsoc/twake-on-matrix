import 'package:fluffychat/di/global/get_it_initializer.dart';
import 'package:fluffychat/pages/chat/events/html_message.dart';
import 'package:fluffychat/utils/responsive/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart' hide Visibility;

class FormattedTextWidget extends StatelessWidget {
  final Event event;
  final double fontSize;
  final TextStyle? linkStyle;

  const FormattedTextWidget({
    super.key,
    required this.event,
    required this.fontSize,
    this.linkStyle,
  });

  @override
  Widget build(BuildContext context) {
    final responsiveUtils = getIt.get<ResponsiveUtils>();
    var html = event.formattedText;

    if (event.messageType == MessageTypes.Emote) {
      html = '* $html';
    }
    final bigEmotes =
        event.onlyEmotes && event.numberEmotes > 0 && event.numberEmotes <= 10;

    if (responsiveUtils.isMobile(context)) {
      return HtmlMessage(
        html: html,
        defaultTextStyle: Theme.of(context).textTheme.bodyLarge,
        linkStyle: linkStyle,
        room: event.room,
        emoteSize: bigEmotes ? fontSize * 3 : fontSize * 1.5,
      );
    }

    return SelectionArea(
      child: HtmlMessage(
        html: html,
        defaultTextStyle: Theme.of(context).textTheme.bodyLarge,
        linkStyle: linkStyle,
        room: event.room,
        emoteSize: bigEmotes ? fontSize * 3 : fontSize * 1.5,
      ),
    );
  }
}
