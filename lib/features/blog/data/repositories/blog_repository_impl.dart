import 'dart:io';

import 'package:blog_app_clean_arch/core/error/exception.dart';
import 'package:blog_app_clean_arch/core/error/failure.dart';
import 'package:blog_app_clean_arch/features/blog/data/models/blog_model.dart';
import 'package:blog_app_clean_arch/features/blog/data/sources/blog_remote_data_source.dart';
import 'package:blog_app_clean_arch/features/blog/domain/entities/blog.dart';
import 'package:blog_app_clean_arch/features/blog/domain/repositories/blog_repositories.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  BlogRepositoryImpl(this.blogRemoteDataSource);

  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String posterId,
    required String title,
    required String content,
    required List<String> topics,
  }) async {
    try {
      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
        updatedAt: DateTime.now(),
      );
      // storing image to storage first and get image mage url
      final imageurl = await blogRemoteDataSource.uploadBlogImage(
          blogModel: blogModel, image: image);
      blogModel = blogModel.copyWith(imageUrl: imageurl);
      // storing the blog with image na dblog data
      final uploadedBlog = await blogRemoteDataSource.uploadBlog(blogModel);
      return right(uploadedBlog);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
