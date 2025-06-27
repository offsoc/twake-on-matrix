import 'package:fluffychat/pages/chat_details/assign_roles_picker/assign_roles_picker.dart';
import 'package:fluffychat/pages/chat_list/chat_list_header_style.dart';
import 'package:fluffychat/widgets/app_bars/twake_app_bar.dart';
import 'package:fluffychat/widgets/context_menu_builder_ios_paste_without_permission.dart';
import 'package:fluffychat/widgets/twake_components/twake_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class AssignRolesPickerView extends StatelessWidget {
  final AssignRolesPickerController controller;

  const AssignRolesPickerView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LinagoraSysColors.material().onPrimary,
      resizeToAvoidBottomInset: false,
      appBar: TwakeAppBar(
        title: L10n.of(context)!.assignRoles,
        centerTitle: true,
        withDivider: true,
        context: context,
        enableLeftTitle: true,
        leading: TwakeIconButton(
          paddingAll: 8,
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () => Navigator.of(context).pop(),
          icon: Icons.arrow_back_ios,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: controller.textEditingController,
                contextMenuBuilder: mobileTwakeContextMenuBuilder,
                focusNode: controller.inputFocus,
                textInputAction: TextInputAction.search,
                autofocus: true,
                decoration: ChatListHeaderStyle.searchInputDecoration(
                  context,
                  prefixIconColor: LinagoraSysColors.material().tertiary,
                ).copyWith(
                  hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: LinagoraSysColors.material().tertiary,
                      ),
                  hintText: L10n.of(context)!.enterAnEmailAddress,
                  suffixIcon: ValueListenableBuilder(
                    valueListenable: controller.textEditingController,
                    builder: (context, value, child) => value.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              controller.textEditingController.clear();
                            },
                            icon: const Icon(Icons.close),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
            Container(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Text(
                L10n.of(context)!.memberOfTheGroup(
                  controller.members.length,
                ),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: LinagoraRefColors.material().neutral[40],
                    ),
              ),
            ),
            const SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}
