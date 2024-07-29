import 'dart:io';

import 'package:blog_app_clean_arch/core/error/failure.dart';
import 'package:blog_app_clean_arch/features/blog/data/models/blog_model.dart';
import 'package:blog_app_clean_arch/features/blog/domain/entities/blog.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class BlogRepository {
  Future<Either<Failure, Blog>> uploadBlog(
      {required File image,
      required String posterId,
      required String title,
      required String content,
      required List<String> topics});

  Future<Either<Failure, List<BlogModel>>> getAllBlogs();
}
