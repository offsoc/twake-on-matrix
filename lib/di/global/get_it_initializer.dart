import 'dart:collection';
import 'package:fluffychat/data/datasource/recovery_words_data_source.dart';
import 'package:fluffychat/data/datasource/tom_configurations_datasource.dart';
import 'package:fluffychat/data/datasource/tom_contacts_datasource.dart';
import 'package:fluffychat/data/datasource_impl/contact/tom_contacts_datasource_impl.dart';
import 'package:fluffychat/data/datasource_impl/recovery_words_data_source_impl.dart';
import 'package:fluffychat/data/datasource_impl/tom_configurations_datasource_impl.dart';
import 'package:fluffychat/data/network/contact/tom_contact_api.dart';
import 'package:fluffychat/data/network/recovery_words/recovery_words_api.dart';
import 'package:fluffychat/data/repository/contact/tom_contact_repository_impl.dart';
import 'package:fluffychat/data/repository/recovery_words_repository_impl.dart';
import 'package:fluffychat/data/repository/tom_configurations_repository_impl.dart';
import 'package:fluffychat/di/global/hive_di.dart';
import 'package:fluffychat/di/global/network_connectivity_di.dart';
import 'package:fluffychat/di/global/network_di.dart';
import 'package:fluffychat/domain/repository/contact_repository.dart';
import 'package:fluffychat/domain/repository/recovery_words_repository.dart';
import 'package:fluffychat/domain/repository/tom_configurations_repository.dart';
import 'package:fluffychat/domain/usecase/create_direct_chat_interactor.dart';
import 'package:fluffychat/domain/usecase/download_file_for_preview_interactor.dart';
import 'package:fluffychat/domain/usecase/fetch_contacts_interactor.dart';
import 'package:fluffychat/domain/usecase/forward/forward_message_interactor.dart';
import 'package:fluffychat/domain/usecase/load_more_internal_contacts.dart';
import 'package:fluffychat/domain/usecase/lookup_contacts_interactor.dart';
import 'package:fluffychat/domain/usecase/room/create_new_group_chat_interactor.dart';
import 'package:fluffychat/domain/usecase/room/upload_content_interactor.dart';
import 'package:fluffychat/domain/usecase/send_file_interactor.dart';
import 'package:fluffychat/domain/usecase/send_image_interactor.dart';
import 'package:fluffychat/domain/usecase/send_images_interactor.dart';
import 'package:fluffychat/domain/usecases/get_recovery_words_interactor.dart';
import 'package:fluffychat/domain/usecases/save_recovery_words_interactor.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class GetItInitializer {
  static final GetItInitializer _singleton = GetItInitializer._internal();

  factory GetItInitializer() {
    return _singleton;
  }

  GetItInitializer._internal();

  void setUp() {
    bidingGlobal();
    bidingQueue();
    bidingAPI();
    bidingDatasource();
    bidingDatasourceImpl();
    bidingRepositories();
    bindingInteractor();
  }

  void bidingGlobal() {
    NetworkDI().bind();
    HiveDI().bind();
    NetworkConnectivityDI().bind();
  }

  void bidingQueue() {
    getIt.registerSingleton<Queue>(Queue());
  }

  void bidingAPI() {
    getIt.registerLazySingleton<RecoveryWordsAPI>(() => RecoveryWordsAPI());
    getIt.registerFactory<TomContactAPI>(() => TomContactAPI());
  }

  void bidingDatasource() {
    getIt.registerFactory<ToMConfigurationsDatasource>(() => HiveToMConfigurationDatasource());

  }

  void bidingDatasourceImpl() {
    getIt.registerLazySingleton<RecoveryWordsDataSource>(() => RecoveryWordsDataSourceImpl());
    getIt.registerFactory<TomContactsDatasource>(() => TomContactsDatasourceImpl());
  }

  void bidingRepositories() {
    getIt.registerFactory<ToMConfigurationsRepository>(() => ToMConfigurationsRepositoryImpl());
    getIt.registerLazySingleton<RecoveryWordsRepository>(() => RecoveryWordsRepositoryImpl());
    getIt.registerFactory<ContactRepository>(() => TomContactRepositoryImpl());
  }

  void bindingInteractor() {
    getIt.registerLazySingleton<GetRecoveryWordsInteractor>(() => GetRecoveryWordsInteractor());
    getIt.registerLazySingleton<SaveRecoveryWordsInteractor>(() => SaveRecoveryWordsInteractor());
    getIt.registerFactory<LookupContactsInteractor>(() => LookupContactsInteractor());
    getIt.registerFactory<FetchContactsInteractor>(() => FetchContactsInteractor());
    getIt.registerFactory<LoadMoreInternalContacts>(() => LoadMoreInternalContacts());
    getIt.registerSingleton<SendImageInteractor>(SendImageInteractor());
    getIt.registerSingleton<SendImagesInteractor>(SendImagesInteractor());
    getIt.registerSingleton<DownloadFileForPreviewInteractor>(DownloadFileForPreviewInteractor());
    getIt.registerSingleton<SendFileInteractor>(SendFileInteractor());
    getIt.registerSingleton<CreateNewGroupChatInteractor>(CreateNewGroupChatInteractor());
    getIt.registerSingleton<UploadContentInteractor>(UploadContentInteractor());
    getIt.registerSingleton<CreateDirectChatInteractor>(CreateDirectChatInteractor());
    getIt.registerSingleton<ForwardMessageInteractor>(ForwardMessageInteractor());
  }
}