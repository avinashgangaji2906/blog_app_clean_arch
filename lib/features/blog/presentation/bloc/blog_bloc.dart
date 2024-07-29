import 'dart:io';

import 'package:blog_app_clean_arch/core/usecase/usercase.dart';
import 'package:blog_app_clean_arch/features/blog/domain/entities/blog.dart';
import 'package:blog_app_clean_arch/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app_clean_arch/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;
  BlogBloc({required UploadBlog uploadBlog, required GetAllBlogs getAllBlogs})
      : _uploadBlog = uploadBlog,
        _getAllBlogs = getAllBlogs,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) => BlogLoading());
    on<BlogUploadEvent>(_onBlogUpload);
    on<BlogGetAllBlogsEvent>(_onGetAllBlogs);
  }

  void _onBlogUpload(BlogUploadEvent event, Emitter<BlogState> emit) async {
    final res = await _uploadBlog(
      UploadBlogParams(
        posterId: event.posterId,
        title: event.title,
        content: event.content,
        topics: event.topics,
        imageUrl: event.imageUrl,
      ),
    );
    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (blog) => emit(BlogUploadSuccess()),
    );
  }

  void _onGetAllBlogs(BlogGetAllBlogsEvent event, Emitter emit) async {
    final res = await _getAllBlogs(NoParams());
    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (blogs) => emit(BlogDisplaySuccess(blogs)),
    );
  }
}
