// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:blog_app_clean_arch/features/blog/domain/repositories/blog_repositories.dart';
import 'package:fpdart/fpdart.dart';

import 'package:blog_app_clean_arch/core/error/failure.dart';
import 'package:blog_app_clean_arch/core/usecase/usercase.dart';
import 'package:blog_app_clean_arch/features/blog/domain/entities/blog.dart';

class UploadBlog implements UseCase<Blog, UploadBlogParams> {
  final BlogRepository blogRepository;

  UploadBlog(this.blogRepository);
  @override
  Future<Either<Failure, Blog>> call(UploadBlogParams param) async {
    return await blogRepository.uploadBlog(
      image: param.imageUrl,
      posterId: param.posterId,
      title: param.title,
      content: param.content,
      topics: param.topics,
    );
  }
}

class UploadBlogParams {
  final String posterId;
  final String title;
  final String content;
  final List<String> topics;
  final File imageUrl;
  UploadBlogParams({
    required this.posterId,
    required this.title,
    required this.content,
    required this.topics,
    required this.imageUrl,
  });
}
