import 'package:blog_app_clean_arch/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app_clean_arch/core/usecase/usercase.dart';
import 'package:blog_app_clean_arch/core/entities/user.dart';
import 'package:blog_app_clean_arch/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app_clean_arch/features/auth/domain/usecases/user_login.dart';
import 'package:blog_app_clean_arch/features/auth/domain/usecases/user_signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
  })  : _userSignUp = userSignUp,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) =>
        emit(AuthLoding())); // default loader runs before any event runs
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthCurrentUser>(_userLoggedIn);
  }

  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    // use case
    final res = await _userSignUp(UserSignUpParams(
      name: event.name,
      email: event.email,
      password: event.password,
    ));
    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    // use case
    final res = await _userLogin(
        UserLoginParams(email: event.email, password: event.password));
    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _userLoggedIn(AuthCurrentUser event, Emitter<AuthState> emit) async {
    // use case
    final res = await _currentUser(NoParams());
    res.fold((failure) => emit(AuthFailure(failure.message)),
        (user) => _emitAuthSuccess(user, emit));
  }

// Updating user state based on aut state change
  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}
