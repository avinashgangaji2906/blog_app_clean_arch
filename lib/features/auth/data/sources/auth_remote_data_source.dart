import 'package:blog_app_clean_arch/core/error/exception.dart';
import 'package:blog_app_clean_arch/features/auth/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;

  Future<UserModel> signupWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserModel?> getCurrentUserData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient; // dependency injection

  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel> loginWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final AuthResponse response =
          await supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
      );
      if (response.user == null) {
        throw ServerException(message: "User is null");
      }
      // converting raw data to model
      return UserModel.fromJson(response.user!.toJson())
        ..copyWith(email: currentUserSession!.user.email);
    } catch (e, stackTrace) {
      debugPrint("StackTrace :  ${stackTrace.toString()}");
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> signupWithEmailAndPassword(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final AuthResponse response = await supabaseClient.auth
          .signUp(password: password, email: email, data: {'name': name});
      if (response.user == null) {
        throw ServerException(message: "User is null");
      }
      // converting raw data to model
      return UserModel.fromJson(response.user!.toJson())
          .copyWith(email: currentUserSession!.user.email);
    } catch (e, stackTrace) {
      debugPrint("StackTrace :  ${stackTrace.toString()}");
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        final userData = await supabaseClient
            .from('profiles')
            .select()
            .eq('id', currentUserSession!.user.id);

        return UserModel.fromJson(userData.first)
            .copyWith(email: currentUserSession!.user.email);
      }
      return null;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
