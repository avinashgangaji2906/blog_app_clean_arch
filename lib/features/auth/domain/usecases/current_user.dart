import 'package:blog_app_clean_arch/core/error/failure.dart';
import 'package:blog_app_clean_arch/core/usecase/usercase.dart';
import 'package:blog_app_clean_arch/core/entities/user.dart';
import 'package:blog_app_clean_arch/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class CurrentUser implements UseCase<User, NoParams> {
  final AuthRepository authRepository;

  CurrentUser(this.authRepository);

  @override
  Future<Either<Failure, User>> call(NoParams param) async {
    return await authRepository.getCurrentUser();
  }
}
