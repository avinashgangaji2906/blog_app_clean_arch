import 'dart:io';

import 'package:blog_app_clean_arch/core/constants/constants.dart';
import 'package:blog_app_clean_arch/core/error/exception.dart';
import 'package:blog_app_clean_arch/core/error/failure.dart';
import 'package:blog_app_clean_arch/core/network/internet_checker.dart';
import 'package:blog_app_clean_arch/features/blog/data/models/blog_model.dart';
import 'package:blog_app_clean_arch/features/blog/data/sources/blog_local_data_source.dart';
import 'package:blog_app_clean_arch/features/blog/data/sources/blog_remote_data_source.dart';
import 'package:blog_app_clean_arch/features/blog/domain/entities/blog.dart';
import 'package:blog_app_clean_arch/features/blog/domain/repositories/blog_repositories.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  final BlogLocalDataSource blogLocalDataSource;
  final InternetChecker internetChecker;
  BlogRepositoryImpl(this.blogRemoteDataSource, this.blogLocalDataSource,
      this.internetChecker);

  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String posterId,
    required String title,
    required String content,
    required List<String> topics,
  }) async {
    try {
      if (!await (internetChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }
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

  @override
  Future<Either<Failure, List<BlogModel>>> getAllBlogs() async {
    try {
      if (!await (internetChecker.isConnected)) {
        final blogs = blogLocalDataSource.loadBlogs();
        return right(blogs);
      }
      final blogs = await blogRemoteDataSource.getAllBlogs();
      blogLocalDataSource.uploadBlogs(
          blogs: blogs); // store blogs to local storage
      return right(blogs);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
