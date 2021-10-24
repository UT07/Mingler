import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test2/repositories/userRepository.dart';
import 'package:flutter_test2/ui/validators.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'signup_event.dart';

part 'signup_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  UserRepository _userRepository;

  SignUpBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(SignUpState.empty());

  SignUpState get initialState => SignUpState.empty();


  /// patch job fix that is not guaranteed to work
  @override
  Stream<Transition< SignUpEvent, SignUpState >> transformEvents(
      Stream< SignUpEvent > events, transitionFn){
    final nonDebounceStream = events.where((event) {
      return (event is! EmailChanged || event is! PasswordChanged);
    });

    final debounceStream = events.where((event) {
      return (event is EmailChanged || event is PasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));

    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event,) async* {

    if (event is EmailChanged){
      yield* _mapEmailChangedToState(event.email);
    }
    else if (event is PasswordChanged){
      yield* _mapPasswordChangedToState(event.password);
    }
    else if(event is SignUpWithCredentialsPressed){
      yield* _mapSignUpWithCredentialsPressedToState(
          email: event.email,
          password: event.password
      );
    }
  }

  // check if email is valid
  Stream<SignUpState> _mapEmailChangedToState(String email) async*{
    yield state.update(isEmailValid: Validators.isValidEmail(email));
  }

  // check if password is valid
  Stream <SignUpState> _mapPasswordChangedToState(String password) async* {
    yield state.update(isPasswordValid: Validators.isValidPassword(password));
  }

  Stream<SignUpState> _mapSignUpWithCredentialsPressedToState({
    String email,
    String password,
  }) async* {
    yield SignUpState.loading();

    try {
      await _userRepository.signUpWithEmail(email, password);

      yield SignUpState.success();
    }
    catch (_){
      SignUpState.failure();
    }
  }
}
