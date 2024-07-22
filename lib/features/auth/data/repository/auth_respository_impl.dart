import 'package:blog_app_clean_arch/core/error/exception.dart';
import 'package:blog_app_clean_arch/core/error/failure.dart';
import 'package:blog_app_clean_arch/features/auth/data/sources/auth_remote_data_source.dart';
import 'package:blog_app_clean_arch/core/entities/user.dart';
import 'package:blog_app_clean_arch/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class AuthRespositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRespositoryImpl(this.authRemoteDataSource);

  @override
  Future<Either<Failure, User>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _getUser(
        () async => await authRemoteDataSource.loginWithEmailAndPassword(
              email: email,
              password: password,
            ));
  }

  @override
  Future<Either<Failure, User>> signupWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return _getUser(
        () async => await authRemoteDataSource.signupWithEmailAndPassword(
              name: name,
              email: email,
              password: password,
            ));
  }

// a function which will be return a function becuase the return type of both functions is same
  Future<Either<Failure, User>> _getUser(Future<User> Function() fn) async {
    try {
      User user = await fn();
      return right(user); // success no error
    } on supabase.AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final user = await authRemoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failure('User is not logged in'));
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
