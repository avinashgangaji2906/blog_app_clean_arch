import 'package:blog_app_clean_arch/core/error/failure.dart';
import 'package:blog_app_clean_arch/core/usecase/usercase.dart';
import 'package:blog_app_clean_arch/features/blog/domain/entities/blog.dart';
import 'package:blog_app_clean_arch/features/blog/domain/repositories/blog_repositories.dart';
import 'package:fpdart/fpdart.dart';

class GetAllBlogs implements UseCase<List<Blog>, NoParams> {
  final BlogRepository blogRepository;

  GetAllBlogs(this.blogRepository);
  @override
  Future<Either<Failure, List<Blog>>> call(NoParams param) {
    return blogRepository.getAllBlogs();
  }
}
