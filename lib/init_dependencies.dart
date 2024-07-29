import 'package:blog_app_clean_arch/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app_clean_arch/core/network/internet_checker.dart';
import 'package:blog_app_clean_arch/core/secrets/app_secrets.dart';
import 'package:blog_app_clean_arch/features/auth/data/repository/auth_respository_impl.dart';
import 'package:blog_app_clean_arch/features/auth/data/sources/auth_remote_data_source.dart';
import 'package:blog_app_clean_arch/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app_clean_arch/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app_clean_arch/features/auth/domain/usecases/user_login.dart';
import 'package:blog_app_clean_arch/features/auth/domain/usecases/user_signup.dart';
import 'package:blog_app_clean_arch/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app_clean_arch/features/blog/data/repositories/blog_repository_impl.dart';
import 'package:blog_app_clean_arch/features/blog/data/sources/blog_local_data_source.dart';
import 'package:blog_app_clean_arch/features/blog/data/sources/blog_remote_data_source.dart';
import 'package:blog_app_clean_arch/features/blog/domain/repositories/blog_repositories.dart';
import 'package:blog_app_clean_arch/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app_clean_arch/features/blog/domain/usecases/upload_blog.dart';
import 'package:blog_app_clean_arch/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'init_dependencies_main.dart';  // only part 
