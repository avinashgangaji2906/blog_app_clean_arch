import 'dart:io';

import 'package:blog_app_clean_arch/core/error/exception.dart';
import 'package:blog_app_clean_arch/features/blog/data/models/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog(BlogModel blogModel);
  Future<String> uploadBlogImage(
      {required File image, required BlogModel blogModel});
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final SupabaseClient supabaseClient;
  BlogRemoteDataSourceImpl(this.supabaseClient);
  @override
  Future<BlogModel> uploadBlog(BlogModel blogModel) async {
    try {
      final blogdata = await supabaseClient
          .from('blogs')
          .insert(blogModel.toJson())
          .select();
      return BlogModel.fromJson(blogdata.first);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> uploadBlogImage(
      {required File image, required BlogModel blogModel}) async {
    try {
      await supabaseClient.storage
          .from('blog_images')
          .upload(blogModel.id, image);

      return supabaseClient.storage
          .from('blog_images')
          .getPublicUrl(blogModel.id); // get the image url from storage bucket
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
