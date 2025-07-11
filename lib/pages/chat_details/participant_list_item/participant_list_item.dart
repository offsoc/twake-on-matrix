import 'package:fluffychat/config/default_power_level_member.dart';
import 'package:fluffychat/di/global/get_it_initializer.dart';
import 'package:fluffychat/pages/chat_details/participant_list_item/participant_list_item_style.dart';
import 'package:fluffychat/pages/profile_info/profile_info_body/profile_info_body.dart';
import 'package:fluffychat/pages/profile_info/profile_info_page.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/responsive/responsive_utils.dart';
import 'package:fluffychat/utils/user_extension.dart';
import 'package:fluffychat/widgets/avatar/avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:matrix/matrix.dart';

class ParticipantListItem extends StatelessWidget {
  final User member;

  final VoidCallback? onUpdatedMembers;

  const ParticipantListItem(
    this.member, {
    super.key,
    this.onUpdatedMembers,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: member.membership == Membership.join ? 1 : 0.5,
      child: TwakeInkWell(
        onTap: () async => await _onItemTap(context),
        child: TwakeListItem(
          height: 72,
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Avatar(
                mxContent: member.avatarUrl,
                name: member.calcDisplayname(),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            member.calcDisplayname(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: LinagoraTextStyle.material()
                                .bodyMedium2
                                .copyWith(
                                  color: LinagoraSysColors.material().onSurface,
                                ),
                          ),
                        ),
                        if (member.getDefaultPowerLevelMember.powerLevel >=
                            DefaultPowerLevelMember.owner.powerLevel) ...[
                          Text(
                            member.getDefaultPowerLevelMember
                                .displayName(context),
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color:
                                      LinagoraRefColors.material().tertiary[30],
                                ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      member.id,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: LinagoraRefColors.material().tertiary[30],
                          ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _onItemTap(BuildContext context) async {
    final responsive = getIt.get<ResponsiveUtils>();

    if (responsive.isMobile(context)) {
      await _openDialogInvite(context);
    } else {
      await _openProfileDialog(context);
    }
  }

  Future _openDialogInvite(BuildContext context) async {
    if (PlatformInfos.isMobile) {
      Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (ctx) => ProfileInfoPage(
            roomId: member.room.id,
            userId: member.id,
            onUpdatedMembers: onUpdatedMembers,
          ),
        ),
      );
      return;
    }
    await showDialog(
      context: context,
      barrierDismissible: false,
      useSafeArea: false,
      useRootNavigator: !PlatformInfos.isMobile,
      builder: (dialogContext) {
        return ProfileInfoPage(
          roomId: member.room.id,
          userId: member.id,
          onUpdatedMembers: onUpdatedMembers,
          onNewChatOpen: () {
            Navigator.of(dialogContext).pop();
          },
        );
      },
    );
  }

  Future _openProfileDialog(BuildContext context) => showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          backgroundColor: LinagoraRefColors.material().primary[100],
          surfaceTintColor: Colors.transparent,
          content: SizedBox(
            width: ParticipantListItemStyle.fixedDialogWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: ParticipantListItemStyle.closeButtonPadding,
                        child: IconButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          icon: const Icon(Icons.close),
                        ),
                      ),
                    ),
                    ProfileInfoBody(
                      user: member,
                      onNewChatOpen: () {
                        Navigator.of(dialogContext).pop();
                      },
                      onUpdatedMembers: onUpdatedMembers,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
