import 'package:blog_app_clean_arch/core/error/failure.dart';
import 'package:blog_app_clean_arch/core/usecase/usercase.dart';
import 'package:blog_app_clean_arch/core/entities/user.dart';
import 'package:blog_app_clean_arch/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserLogin implements UseCase<User, UserLoginParams> {
  final AuthRepository authRepository;

  UserLogin(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UserLoginParams param) async {
    return await authRepository.loginWithEmailAndPassword(
      email: param.email,
      password: param.password,
    );
  }
}

class UserLoginParams {
  final String email;
  final String password;

  UserLoginParams({required this.email, required this.password});
}
