import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fluffychat/data/network/dio_client.dart';
import 'package:fluffychat/data/network/interceptor/authorization_interceptor.dart';
import 'package:fluffychat/data/network/interceptor/dynamic_url_interceptor.dart';
import 'package:fluffychat/di/base_di.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

class NetworkDI extends BaseDI {

  static const tomServerUrlInterceptorName = 'tomServerDynamicUrlInterceptor';
  static const tomServerDioName = 'tomServerDioName';
  static const tomDioClientName = 'tomServerDioClientName';

  static const identityServerUrlInterceptorName = 'identityDynamicUrlInterceptor';
  static const identityServerDioName = 'identityServerName';
  static const identityDioClientName = 'identityServerDioClientName';

  static const homeServerUrlInterceptorName = 'homeDynamicUrlInterceptor';
  static const homeServerDioName = 'homeServerName';
  static const homeDioClientName = 'homeServerDioClientName';

  static const acceptHeaderDefault = 'application/json';
  static const contentTypeHeaderDefault = 'application/json';

  @override
  void setUp(GetIt get) {
    _bindBaseOption(get);
    _bindInterceptor(get);
    _bindDio(get);
  }

  void _bindBaseOption(GetIt get) {
    final headers = {
      HttpHeaders.acceptHeader: acceptHeaderDefault,
      HttpHeaders.contentTypeHeader: contentTypeHeaderDefault
    };

    get.registerLazySingleton<BaseOptions>(() => BaseOptions(headers: headers));
  }

  void _bindInterceptor(GetIt get) {
    get.registerLazySingleton(
      () => DynamicUrlInterceptors(),
      instanceName: tomServerUrlInterceptorName,
    );
    get.registerLazySingleton(
      () => DynamicUrlInterceptors(),
      instanceName: identityServerUrlInterceptorName,
    );

    get.registerLazySingleton(
      () => DynamicUrlInterceptors(),
      instanceName: homeServerUrlInterceptorName,
    );

    get.registerLazySingleton(
      () => AuthorizationInterceptor(),
    );
  }

  void _bindDio(GetIt get) {
    _bindDioForTomServer(get);
    _bindDioForIdentityServer(get);
    _bindDioForHomeServer(get);
  }

  void _bindDioForTomServer(GetIt get) {
    final dio = Dio(get.get<BaseOptions>());
    dio.interceptors.add(get.get<DynamicUrlInterceptors>(instanceName: tomServerUrlInterceptorName));
    dio.interceptors.add(get.get<AuthorizationInterceptor>());
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    }
    get.registerLazySingleton<Dio>(() => dio, instanceName: tomServerDioName);
    get.registerLazySingleton<DioClient>(
      () => DioClient(get.get<Dio>(instanceName: tomServerDioName)),
      instanceName: tomDioClientName,
    );
  }

  void _bindDioForIdentityServer(GetIt get) {
    final dio = Dio(get.get<BaseOptions>());
    dio.interceptors.add(get.get<DynamicUrlInterceptors>(instanceName: identityServerUrlInterceptorName));
    dio.interceptors.add(get.get<AuthorizationInterceptor>());
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    }
    get.registerLazySingleton<Dio>(() => dio, instanceName: identityServerDioName);
    get.registerLazySingleton<DioClient>(
      () => DioClient(get.get<Dio>(instanceName: identityServerDioName)),
      instanceName: identityDioClientName,
    );
  }

  void _bindDioForHomeServer(GetIt get) {
    final dio = Dio(get.get<BaseOptions>());
    dio.interceptors.add(get.get<DynamicUrlInterceptors>(instanceName: homeServerUrlInterceptorName));
    dio.interceptors.add(get.get<AuthorizationInterceptor>());
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    }
    get.registerLazySingleton<Dio>(() => dio, instanceName: homeServerDioName);
    get.registerLazySingleton<DioClient>(
      () => DioClient(get.get<Dio>(instanceName: homeServerDioName)),
      instanceName: homeDioClientName,
    );
  }
}