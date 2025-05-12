import 'package:book_shelf/src/core/network/api_client.dart';
import 'package:book_shelf/src/core/system/auth_local.dart';
import 'package:book_shelf/src/features/auth/data/api/auth_api.dart';
import 'package:book_shelf/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:book_shelf/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:book_shelf/src/features/auth/presentations/blocs/bloc/auth_cubit.dart';
import 'package:book_shelf/src/features/auth/presentations/screens/login_screen.dart';
import 'package:book_shelf/src/features/books/data/api/book_api.dart';
import 'package:book_shelf/src/features/books/data/repositories/book_repository_impl.dart';
import 'package:book_shelf/src/features/books/domain/repositories/book_repository.dart';
import 'package:book_shelf/src/features/books/presentations/blocs/bloc/book_cubit.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies({required GlobalKey<NavigatorState> navigatorKey}) async {
  // API Client
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(onUnauthorized: () {
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    }),
  );

  getIt.registerFactory<AuthLocal>(
    () => AuthLocal(),
  );



  //! API
  getIt.registerFactory<AuthApi>(
    () => AuthApi(getIt<ApiClient>()),
  );

  getIt.registerFactory<BookApi>(
    () => BookApi(getIt<ApiClient>()),
  );



  //! Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthApi>()),
  );

  getIt.registerLazySingleton<BookRepository>(
    () => BookRepositoryImpl(getIt<BookApi>()),
  );



  //! Blocs
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(getIt<AuthRepository>()),
  );

  getIt.registerFactory<BookCubit>(
    () => BookCubit(getIt<BookRepository>()),
  );

  // getIt.registerFactory<LogoutCubit>(
  //   () => LogoutCubit(authRepository: getIt<AuthRepository>()),
  // );

  // getIt.registerFactoryParam<UserProfileBloc, UserResponse?, SbuData?>(
  //   (param1, param2) => UserProfileBloc(
  //     userProfileRepository: getIt<UserProfileRepository>(),
  //     user: param1,
  //     sbuData: param2
  //   ),
  // );
}
