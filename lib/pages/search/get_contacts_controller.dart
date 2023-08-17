import 'package:dartz/dartz.dart';
import 'package:fluffychat/app_state/failure.dart';
import 'package:fluffychat/app_state/success.dart';

import 'package:fluffychat/app_state/success_converter.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/di/global/get_it_initializer.dart';
import 'package:fluffychat/domain/app_state/contact/get_contacts_state.dart';
import 'package:fluffychat/domain/usecase/get_contacts_interactor.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GetContactsController {
  SuccessConverter converter;
  GetContactsController(this.converter);

  final _getContactsInteractor = getIt.get<GetContactsInteractor>();
  final contactsNotifier = ValueNotifier<Either<Failure, Success>>(
    const Right(GetContactsInitial()),
  );
  final refreshController = RefreshController();
  bool _isLoadMore = false;
  Success? _lastSuccess;

  void fetch({
    required String keyword,
    int limit = AppConfig.fetchContactsLimit,
  }) {
    _getContactsInteractor
        .execute(keyword: keyword, offset: 0, limit: limit)
        .listen((event) {
      contactsNotifier.value = event.map((success) {
        _lastSuccess = success;
        return converter.convert(success);
      });
      refreshController.refreshCompleted();
    });
  }

  void loadMore({
    int limit = AppConfig.fetchContactsLimit,
  }) {
    if (_isLoadMore ||
        _lastSuccess == null ||
        _lastSuccess is! GetContactsSuccess) {
      refreshController.loadComplete();
      return;
    }
    final success = _lastSuccess as GetContactsSuccess;
    if (success.isEnd) {
      refreshController.loadComplete();
      return;
    }
    _isLoadMore = true;
    _getContactsInteractor
        .execute(
      keyword: success.keyword,
      offset: success.offset,
      limit: limit,
    )
        .listen(
      (event) {
        _isLoadMore = false;
        refreshController.loadComplete();
        contactsNotifier.value = event.map(
          (newSuccess) {
            final expandedSuccess = newSuccess is GetContactsSuccess
                ? success.addMore(newSuccess)
                : success;
            _lastSuccess = expandedSuccess;
            return converter.convert(expandedSuccess);
          },
        );
      },
    );
  }

  void dispose() {
    contactsNotifier.dispose();
  }
}