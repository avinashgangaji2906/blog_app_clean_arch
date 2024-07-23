import 'package:blog_app_clean_arch/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app_clean_arch/core/secrets/app_secrets.dart';
import 'package:blog_app_clean_arch/features/auth/data/repository/auth_respository_impl.dart';
import 'package:blog_app_clean_arch/features/auth/data/sources/auth_remote_data_source.dart';
import 'package:blog_app_clean_arch/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app_clean_arch/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app_clean_arch/features/auth/domain/usecases/user_login.dart';
import 'package:blog_app_clean_arch/features/auth/domain/usecases/user_signup.dart';
import 'package:blog_app_clean_arch/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app_clean_arch/features/blog/data/repositories/blog_repository_impl.dart';
import 'package:blog_app_clean_arch/features/blog/data/sources/blog_remote_data_source.dart';
import 'package:blog_app_clean_arch/features/blog/domain/repositories/blog_repositories.dart';
import 'package:blog_app_clean_arch/features/blog/domain/usecases/upload_blog.dart';
import 'package:blog_app_clean_arch/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supaBaseUrl,
    anonKey: AppSecrets.supaBaseToken,
  );

//  create and return same instance every time it accessed
  serviceLocator.registerLazySingleton(
    () => supabase.client,
  );

  // register core
  serviceLocator.registerLazySingleton(
    () => AppUserCubit(),
  );
}

void _initAuth() {
  // create and return new instance every time it accessed
  serviceLocator
    // Register DataSource
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        serviceLocator<SupabaseClient>(),
      ),
    )
    // Register Repository
    ..registerFactory<AuthRepository>(
      () => AuthRespositoryImpl(
        serviceLocator(),
      ),
    )
    // Register Usecase
    ..registerFactory(
      () => UserSignUp(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserLogin(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => CurrentUser(
        serviceLocator(),
      ),
    )

// Register Bloc : bloc should be instantiated only once as its state should be persisted - LazySingleton
    ..registerLazySingleton(
      () => AuthBloc(
          userSignUp: serviceLocator(),
          userLogin: serviceLocator(),
          currentUser: serviceLocator(),
          appUserCubit: serviceLocator()),
    );
}

void _initBlog() {
  serviceLocator
    // Datasource
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    // Repository
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        serviceLocator(),
      ),
    )
    // Usecase
    ..registerFactory(
      () => UploadBlog(
        serviceLocator(),
      ),
    )
    // bloc
    ..registerLazySingleton(
      () => BlogBloc(
        uploadBlog: serviceLocator(),
      ),
    );
}
