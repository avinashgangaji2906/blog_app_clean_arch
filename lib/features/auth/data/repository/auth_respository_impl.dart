import 'package:blog_app_clean_arch/core/constants/constants.dart';
import 'package:blog_app_clean_arch/core/error/exception.dart';
import 'package:blog_app_clean_arch/core/error/failure.dart';
import 'package:blog_app_clean_arch/core/network/internet_checker.dart';
import 'package:blog_app_clean_arch/features/auth/data/models/user_model.dart';
import 'package:blog_app_clean_arch/features/auth/data/sources/auth_remote_data_source.dart';
import 'package:blog_app_clean_arch/core/entities/user.dart';
import 'package:blog_app_clean_arch/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRespositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final InternetChecker internetChecker;

  AuthRespositoryImpl(this.authRemoteDataSource, this.internetChecker);

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
      // if no internet logic
      if (!await (internetChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }
      User user = await fn();
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      // if no internet logic
      if (!await (internetChecker.isConnected)) {
        final session = authRemoteDataSource.currentUserSession;
        if (session == null) {
          return left(Failure('User is not logged in'));
        } else {
          return right(UserModel(
              id: session.user.id, name: '', email: session.user.email ?? ''));
        }
      }
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
