import 'package:blog_app_clean_arch/core/error/failure.dart';
import 'package:blog_app_clean_arch/core/usecase/usercase.dart';
import 'package:blog_app_clean_arch/core/entities/user.dart';
import 'package:blog_app_clean_arch/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignUp implements UseCase<User, UserSignUpParams> {
  final AuthRepository authRepository;

  UserSignUp(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UserSignUpParams param) async {
    return await authRepository.signupWithEmailAndPassword(
      name: param.name,
      email: param.email,
      password: param.password,
    );
  }
}

// in the above class we need to provide three params so created a class for accessing al of them
class UserSignUpParams {
  final String name;
  final String email;
  final String password;
  UserSignUpParams({
    required this.name,
    required this.email,
    required this.password,
  });
}
