

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/datasource/remote/dio/dio_client.dart';
import 'data/datasource/remote/dio/logging_interceptor.dart';
import 'data/repository/api_integration_demo_repo.dart';
import 'provider/api_test_provider_demo.dart';

GetIt sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => DioClient('', sl(), loggingInterceptor: sl(), sharedPreferences: sl()));

  // Repository
  // sl.registerLazySingleton(() => SplashRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(() => ApiIntegrationDemoRepo(dioClient: sl()));


  // Provider

  // sl.registerFactory(() => SplashProvider(splashRepo: sl()));
  sl.registerFactory(() => APIIntegrationDemoProvider(apiIntegrationDemoRepo: sl()));


  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
}
