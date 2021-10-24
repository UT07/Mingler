import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test2/repositories/userRepository.dart';
import 'package:flutter_test2/ui/validators.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;

  LoginBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(LoginState.empty());

  LoginState get initialState => LoginState.empty();


  /// patch job fix that is not guaranteed to work
  @override
  Stream<Transition< LoginEvent, LoginState >> transformEvents(
      Stream< LoginEvent > events, transitionFn){
  // Stream<LoginState> transformEvents(Stream<LoginEvent> events,
  //     Stream<LoginState> Function(LoginEvent event) next,) {
    final nonDebounceStream = events.where((event) {
      return (event is! EmailChanged || event is! PasswordChanged);
    });

    final debounceStream = events.where((event) {
      return (event is EmailChanged || event is PasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));

    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event,) async* {

    if (event is EmailChanged){
      yield* _mapEmailChangedToState(event.email);
    }
    else if (event is PasswordChanged){
      yield* _mapPasswordChangedToState(event.password);
    }
    else if(event is LoginWithCredentialsPressed){
      yield* _mapLoginWithCredentialsPressedToState(
        email: event.email,
        password: event.password
      );
    }
  }

  // check if email is valid
  Stream<LoginState> _mapEmailChangedToState(String email) async*{
    yield state.update(isEmailValid: Validators.isValidEmail(email));
  }

  // check if password is valid
  Stream <LoginState> _mapPasswordChangedToState(String password) async* {
    yield state.update(isEmailValid: Validators.isValidPassword(password));
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState({
  String email,
    String password,
}) async* {
    yield LoginState.loading();

    try {
      await _userRepository.signInWithEmail(email, password);

      yield LoginState.success();
    }
    catch (_){
      LoginState.failure();
    }
  }
}
