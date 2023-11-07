import 'package:fluffychat/domain/app_state/room/chat_get_pinned_events_state.dart';
import 'package:fluffychat/pages/chat/chat_pinned_events/pinned_events_style.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:matrix/matrix.dart';
import 'package:matrix_link_text/link_text.dart';

import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/utils/url_launcher.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class PinnedEventsView extends StatelessWidget {
  final ChatController controller;

  const PinnedEventsView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pinnedEventIds = controller.room!.pinnedEventIds;

    if (pinnedEventIds.isEmpty) {
      return const SizedBox();
    }

    return ValueListenableBuilder(
      valueListenable:
          controller.pinnedEventsController.getPinnedMessageNotifier,
      builder: (context, value, child) {
        return value.fold(
          (failure) => child!,
          (success) {
            switch (success.runtimeType) {
              case ChatGetPinnedEventsSuccess:
                final data = success as ChatGetPinnedEventsSuccess;
                return Material(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: InkWell(
                    onTap: () => controller.pinnedEventsController
                        .jumpToPinnedMessageAction(
                      data.pinnedEvents,
                      scrollToEventId: (eventId) =>
                          controller.scrollToEventId(eventId),
                    ),
                    child: Container(
                      margin: PinnedEventsStyle.marginPinnedEventsWidget,
                      height: PinnedEventsStyle.maxHeight,
                      child: Row(
                        children: [
                          ValueListenableBuilder(
                            valueListenable: controller.pinnedEventsController
                                .isCurrentPinnedEventNotifier,
                            builder: (context, currentEvent, child) {
                              if (currentEvent == null) return child!;
                              return Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width:
                                          PinnedEventsStyle.maxWidthIndicator,
                                      child: ListView.separated(
                                        controller: controller
                                            .pinnedEventsController
                                            .pinnedMessageScrollController,
                                        shrinkWrap: true,
                                        itemBuilder: (_, index) {
                                          final isCurrentPinnedEvent =
                                              controller.pinnedEventsController
                                                  .isCurrentPinnedEvent(
                                            data.pinnedEvents[index]!,
                                          );
                                          return _PinnedEventsIndicator(
                                            currentEvent: currentEvent,
                                            scrollController: controller
                                                .pinnedEventsController
                                                .pinnedMessageScrollController,
                                            color: LinagoraSysColors.material()
                                                .secondary
                                                .withOpacity(
                                                  isCurrentPinnedEvent
                                                      ? 1
                                                      : 0.48,
                                                ),
                                            index: index,
                                            height: PinnedEventsStyle
                                                .calcHeightIndicator(
                                              data.pinnedEvents.length,
                                            ),
                                          );
                                        },
                                        separatorBuilder: (_, __) {
                                          return const SizedBox(height: 1);
                                        },
                                        itemCount: data.pinnedEvents.length,
                                      ),
                                    ),
                                    _PinnedEventsContentWidget(
                                      countPinnedEvents: controller
                                          .pinnedEventsController
                                          .currentIndexOfPinnedMessage(
                                        data.pinnedEvents.reversed.toList(),
                                      ),
                                      currentEvent: currentEvent,
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: const SizedBox(),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Icon(
                              Icons.list,
                              size: PinnedEventsStyle.iconListSize,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              default:
                return child!;
            }
          },
        );
      },
      child: const SizedBox(),
    );
  }
}

class _PinnedEventsIndicator extends StatelessWidget {
  final Event currentEvent;
  final AutoScrollController scrollController;
  final Color color;
  final int index;
  final double height;

  const _PinnedEventsIndicator({
    required this.currentEvent,
    required this.scrollController,
    required this.color,
    required this.index,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return AutoScrollTag(
      key: ValueKey(
        currentEvent.eventId,
      ),
      index: index,
      controller: scrollController,
      child: Container(
        width: PinnedEventsStyle.maxWidthIndicator,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }
}

class _PinnedEventsContentWidget extends StatelessWidget {
  final int countPinnedEvents;
  final Event currentEvent;

  const _PinnedEventsContentWidget({
    required this.countPinnedEvents,
    required this.currentEvent,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: PinnedEventsStyle.paddingContentPinned,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              L10n.of(context)!.countPinnedMessage(countPinnedEvents),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: LinagoraSysColors.material().secondary,
                  ),
            ),
            FutureBuilder<String>(
              future: currentEvent.calcLocalizedBody(
                MatrixLocals(L10n.of(context)!),
                withSenderNamePrefix: false,
                hideReply: true,
              ),
              builder: (context, snapshot) {
                return LinkText(
                  text: snapshot.data ??
                      currentEvent.calcLocalizedBodyFallback(
                        MatrixLocals(L10n.of(context)!),
                        withSenderNamePrefix: false,
                        hideReply: true,
                      ),
                  maxLines: 1,
                  textStyle: LinagoraTextStyle.material().bodyMedium3.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurfaceVariant,
                        overflow: TextOverflow.ellipsis,
                        decoration: currentEvent.redacted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                  linkStyle: LinagoraTextStyle.material().bodyMedium3.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurfaceVariant,
                        decoration: TextDecoration.underline,
                        decorationColor:
                            Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  onLinkTap: (url) => UrlLauncher(
                    context,
                    url.toString(),
                  ).launchUrl(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
