import 'package:fluffychat/pages/chat/events/message_reactions_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/avatar/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/mxc_image.dart';
import 'package:overflow_view/overflow_view.dart';

class MessageReactions extends StatelessWidget {
  final Event event;
  final Timeline timeline;

  const MessageReactions(this.event, this.timeline, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final allReactionEvents =
        event.aggregatedEvents(timeline, RelationshipTypes.reaction);
    final reactionMap = <String, _ReactionEntry>{};
    final client = Matrix.of(context).client;

    for (final e in allReactionEvents) {
      final key = e.content
          .tryGetMap<String, dynamic>('m.relates_to')
          ?.tryGet<String>('key');
      if (key != null) {
        if (!reactionMap.containsKey(key)) {
          reactionMap[key] = _ReactionEntry(
            key: key,
            count: 0,
            reacted: false,
            reactors: [],
          );
        }
        reactionMap[key]!.count++;
        reactionMap[key]!.reactors!.add(e.senderFromMemoryOrFallback);
        reactionMap[key]!.reacted |= e.senderId == e.room.client.userID;
      }
    }

    final reactionList = reactionMap.values.toList();
    reactionList.sort((a, b) => b.count - a.count > 0 ? 1 : -1);
    return ReactionsList(
      reactionList: reactionList, 
      allReactionEvents: allReactionEvents, 
      event: event, 
      client: client);
  }
}

class ReactionsList extends StatelessWidget {
  const ReactionsList({
    Key? key,
    required this.reactionList,
    required this.allReactionEvents,
    required this.event,
    required this.client,
  }) : super(key: key);

  final List<_ReactionEntry> reactionList;
  final Set<Event> allReactionEvents;
  final Event event;
  final Client client;

  @override
  Widget build(BuildContext context) {
    return OverflowView.flexible(
      spacing: 4.0,
      builder: (context, index) {
        return InkWell(
          child: Container(
            width: MessageReactionsStyle.moreReactionContainer,
            height: MessageReactionsStyle.moreReactionContainer,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border.all(color: MessageReactionsStyle.borderColor),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.only(top: 1.0, bottom: 4.0),
            child: Icon(
              Icons.more_horiz_rounded, 
              size: MessageReactionsStyle.moreReactionIconSize,),
          ),
        );
      },
      children: [
        ...reactionList
            .map(
              (r) => _Reaction(
                reactionKey: r.key,
                count: r.count,
                reacted: r.reacted,
                onTap: () {
                  if (r.reacted) {
                    final evt = allReactionEvents.firstWhereOrNull(
                      (e) =>
                          e.senderId == e.room.client.userID &&
                          e.content['m.relates_to']['key'] == r.key,
                    );
                    if (evt != null) {
                      showFutureLoadingDialog(
                        context: context,
                        future: () => evt.redactEvent(),
                      );
                    }
                  } else {
                    event.room.sendReaction(event.eventId, r.key!);
                  }
                },
                onLongPress: () async => await _AdaptableReactorsDialog(
                  client: client,
                  reactionEntry: r,
                ).show(context),
              ),
            )
            .toList(),
        if (allReactionEvents.any((e) => e.status.isSending))
          SizedBox(
            width: MessageReactionsStyle.loadingReactionSize,
            height: MessageReactionsStyle.loadingReactionSize,
            child: const Padding(
              padding: EdgeInsets.all(4.0),
              child: CircularProgressIndicator.adaptive(strokeWidth: 1),
            ),
          ),
      ],);
  }
}

class _Reaction extends StatelessWidget {
  final String? reactionKey;
  final int? count;
  final bool? reacted;
  final void Function()? onTap;
  final void Function()? onLongPress;

  const _Reaction({
    this.reactionKey,
    this.count,
    this.reacted,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surface;
    final fontSize = DefaultTextStyle.of(context).style.fontSize;
    Widget content;
    if (reactionKey!.startsWith('mxc://')) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          MxcImage(
            uri: Uri.parse(reactionKey!),
            width: 9999,
            height: fontSize,
          ),
          const SizedBox(width: 4),
          Text(
            count.toString(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: DefaultTextStyle.of(context).style.fontSize,
            ),
          ),
        ],
      );
    } else {
      var renderKey = Characters(reactionKey!);
      if (renderKey.length > 10) {
        renderKey = renderKey.getRange(0, 9) + Characters('…');
      }
      content = Text(
        '$renderKey',
        strutStyle: const StrutStyle(
          forceStrutHeight: true,
        ),
        style: TextStyle(
          fontSize: MessageReactionsStyle.renderKeyFontSize,
        ),
      );
    }
    return InkWell(
      onTap: () => onTap != null ? onTap!() : null,
      onLongPress: () => onLongPress != null ? onLongPress!() : null,
      borderRadius: BorderRadius.circular(AppConfig.borderRadius),
      child: Container(
        width: MessageReactionsStyle.reactionContainerWidth,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: MessageReactionsStyle.reactionBorderColor),
          borderRadius: BorderRadius.circular(MessageReactionsStyle.reactionBorderRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            content,
            const SizedBox(width: 4,),
            Text('$count', style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface
            )),
          ],
        ),
      ),
    );
  }
}

class _ReactionEntry {
  String? key;
  int count;
  bool reacted;
  List<User>? reactors;

  _ReactionEntry({
    this.key,
    required this.count,
    required this.reacted,
    this.reactors,
  });
}

class _AdaptableReactorsDialog extends StatelessWidget {
  final Client? client;
  final _ReactionEntry? reactionEntry;

  const _AdaptableReactorsDialog({
    Key? key,
    this.client,
    this.reactionEntry,
  }) : super(key: key);

  Future<bool?> show(BuildContext context) => PlatformInfos.isCupertinoStyle
      ? showCupertinoDialog(
          context: context,
          builder: (context) => this,
          barrierDismissible: true,
          useRootNavigator: false,
        )
      : showDialog(
          context: context,
          builder: (context) => this,
          barrierDismissible: true,
          useRootNavigator: false,
        );

  @override
  Widget build(BuildContext context) {
    final body = SingleChildScrollView(
      child: Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        alignment: WrapAlignment.center,
        children: <Widget>[
          for (var reactor in reactionEntry!.reactors!)
            Chip(
              avatar: Avatar(
                mxContent: reactor.avatarUrl,
                name: reactor.displayName,
                client: client,
              ),
              label: Text(reactor.displayName!),
            ),
        ],
      ),
    );

    final title = Center(child: Text(reactionEntry!.key!));

    return PlatformInfos.isCupertinoStyle
        ? CupertinoAlertDialog(
            title: title,
            content: body,
          )
        : AlertDialog(
            title: title,
            content: body,
          );
  }
}
