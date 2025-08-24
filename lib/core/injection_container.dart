import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../data/datasources/cart_local_data_source.dart';
import '../data/datasources/order_remote_data_source.dart';
import '../data/datasources/user_remote_data_source.dart';
import '../data/repositories/restaurant_repository_impl.dart';
import '../data/repositories/menu_repository_impl.dart';
import '../data/repositories/cart_repository_impl.dart';
import '../data/repositories/order_repository_impl.dart';
import '../data/repositories/address_repository_impl.dart';
import '../domain/repositories/restaurant_repository.dart';
import '../domain/repositories/menu_repository.dart';
import '../domain/repositories/cart_repository.dart';
import '../domain/repositories/order_repository.dart';
import '../domain/repositories/address_repository.dart';
import '../presentation/bloc/restaurant/restaurant_bloc.dart';
import '../presentation/bloc/menu/menu_bloc.dart';
import '../presentation/bloc/cart/cart_bloc.dart';
import '../presentation/bloc/order/order_bloc.dart';
import '../presentation/bloc/checkout/checkout_bloc.dart';
import '../presentation/bloc/profile/profile_bloc.dart';
import '../presentation/bloc/search/search_bloc.dart';
import '../presentation/bloc/address/address_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External services
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    ),
  ));
  sl.registerLazySingleton(() => http.Client());

  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Data sources
  sl.registerLazySingleton<CartLocalDataSource>(
    () => CartLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSourceImpl(firestore: sl()),
  );
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(firestore: sl()),
  );

  // Repositories
  sl.registerLazySingleton<RestaurantRepository>(
    () => RestaurantRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<MenuRepository>(
    () => MenuRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(remote: sl()),
  );
  sl.registerLazySingleton<AddressRepository>(
    () => AddressRepositoryImpl(sl()),
  );

  // BLoCs
  sl.registerFactory(() => RestaurantBloc(repository: sl()));
  sl.registerFactory(() => MenuBloc(repository: sl()));
  sl.registerFactory(() => CartBloc(repository: sl()));
  sl.registerFactory(() => OrderBloc(repository: sl()));
  sl.registerFactory(
    () => CheckoutBloc(orderRepo: sl(), orderBloc: sl()),
  );
  sl.registerFactory(
    () => ProfileBloc(remote: sl()),
  );
  sl.registerFactory(
    () => SearchBloc(
      restaurantRepository: sl(),
      menuRepository: sl(),
      prefs: sl(),
    ),
  );
  sl.registerFactory(() => AddressBloc(addressRepository: sl()));
}
