

// Splash Event
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/local/constant.dart';
import '../../../data/local/shared_pref.dart';

abstract class SplashEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CheckVerificationStatus extends SplashEvent {}

// Splash State
abstract class SplashState extends Equatable {
  @override
  List<Object> get props => [];
}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashVerified extends SplashState {}

class SplashNotVerified extends SplashState {}

// Splash Bloc
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final SharedPreferencesHelper _pref;

  SplashBloc(this._pref) : super(SplashInitial()) {
    on<CheckVerificationStatus>((event, emit) async {
      emit(SplashLoading());
      await Future.delayed(const Duration(seconds: 1));
      var isVerified = _pref.getBool(Constants.isVerified);
      if (isVerified == null || !isVerified) {
        emit(SplashNotVerified());
      } else {
        emit(SplashVerified());
      }
    });
  }
}
