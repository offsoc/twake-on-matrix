import 'package:dartz/dartz.dart';
import 'package:fluffychat/app_state/failure.dart';
import 'package:fluffychat/app_state/success.dart';
import 'package:fluffychat/pages/new_private_chat/widget/external_contact_widget.dart';
import 'package:fluffychat/presentation/model/presentation_contact.dart';
import 'package:flutter/material.dart';

import 'package:fluffychat/domain/app_state/contact/get_contacts_state.dart';
import 'package:fluffychat/pages/new_group/selected_contacts_map_change_notifier.dart';
import 'package:fluffychat/pages/new_private_chat/widget/expansion_contact_list_tile.dart';
import 'package:fluffychat/pages/new_private_chat/widget/loading_contact_widget.dart';
import 'package:fluffychat/pages/new_private_chat/widget/no_contacts_found.dart';
import 'package:fluffychat/presentation/model/presentation_contact_success.dart';

class ContactsSelectionList extends StatelessWidget {
  final SelectedContactsMapChangeNotifier selectedContactsMapNotifier;
  final ValueNotifier<Either<Failure, Success>> contactsNotifier;
  final Function() onSelectedContact;
  final Function(BuildContext, PresentationContact)? onSelectedExternalContact;
  final List<String> disabledContacts;

  const ContactsSelectionList({
    Key? key,
    required this.contactsNotifier,
    required this.selectedContactsMapNotifier,
    required this.onSelectedContact,
    this.onSelectedExternalContact,
    this.disabledContacts = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: contactsNotifier,
      builder: (context, value, child) => value.fold(
        (failure) => Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: NoContactsFound(
            keyword: failure is GetContactsFailure ? failure.keyword : '',
          ),
        ),
        (success) {
          if (success is PresentationExternalContactSuccess) {
            return Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ExternalContactWidget(
                    contact: success.contact,
                    onTap: () {
                      onSelectedExternalContact?.call(context, success.contact);
                    },
                  )
                ],
              ),
            );
          }
          if (success is! PresentationContactsSuccess) {
            return const LoadingContactWidget();
          }

          if (success.keyword.isNotEmpty && success.data.isEmpty) {
            return Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: NoContactsFound(
                keyword: success.keyword,
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: success.data.length,
            itemBuilder: (context, index) {
              final contactNotifier = selectedContactsMapNotifier
                  .getNotifierAtContact(success.data[index]);
              final disabled = disabledContacts.contains(
                success.data[index].matrixId,
              );
              return InkWell(
                key: ValueKey(success.data[index].matrixId),
                onTap: disabled
                    ? null
                    : () {
                        selectedContactsMapNotifier.onContactTileTap(
                          context,
                          success.data[index],
                        );
                      },
                borderRadius: BorderRadius.circular(16.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 8.0,
                      right: 16,
                      top: index == 0 ? 12 : 0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ExpansionContactListTile(
                            contact: success.data[index],
                          ),
                        ),
                        ValueListenableBuilder<bool>(
                          valueListenable: contactNotifier,
                          builder: (context, isCurrentSelected, child) {
                            return Checkbox(
                              value: disabled || contactNotifier.value,
                              onChanged: disabled
                                  ? null
                                  : (newValue) {
                                      selectedContactsMapNotifier
                                          .onContactTileTap(
                                        context,
                                        success.data[index],
                                      );
                                      onSelectedContact();
                                    },
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
