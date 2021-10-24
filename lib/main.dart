import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test2/bloc/authentication/authentication_bloc.dart';
import 'package:flutter_test2/repositories/userRepository.dart';
import 'package:flutter_test2/ui/pages/home.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final UserRepository _userRepository = UserRepository();

  Bloc.observer = Bloc.observer;

  runApp(
      BlocProvider(
        create: (context) => AuthenticationBloc(userRepository: _userRepository) ..add(AppStarted()),
     child: Home(userRepository: _userRepository)));
}