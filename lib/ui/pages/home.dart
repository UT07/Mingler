import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test2/bloc/authentication/authentication_bloc.dart';
import 'package:flutter_test2/repositories/userRepository.dart';
import 'package:flutter_test2/ui/pages/login.dart';
import 'package:flutter_test2/ui/pages/profile.dart';
import 'package:flutter_test2/ui/pages/splash.dart';
import 'package:flutter_test2/ui/widgets/tabs.dart';

// class Home extends StatefulWidget {
//   @override
//   _HomeState createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> {
//   AuthenticationBloc _authenticationBloc;
//
//   @override
//   void initState() {
//     _authenticationBloc = AuthenticationBloc(userRepository: _userRepository);
//
//     _authenticationBloc.add(AppStarted());
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => _authenticationBloc,
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: BlocBuilder(
//           bloc: _authenticationBloc,
//           builder: (BuildContext context, AuthenticationState state) {
//             if (state is Uninitialized) {
//               return Splash();
//             }
//             if (state is Authenticated) {
//               return Tabs();
//             }
//             if (state is AuthenticatedButNotSet) {
//               return Profile(
//                   userRepository: _userRepository, userId: state.userId);
//             }
//             if (state is unAuthenticated) {
//               return Login(
//                 userRepository: _userRepository,
//               );
//             } else
//               return Container();
//           },
//         ),
//       ),
//     );
//   }
// }

class Home extends StatelessWidget {
  final UserRepository _userRepository;

  Home({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Uninitialized) {
            return Splash();
          }
          if (state is Authenticated) {
            return Tabs(userId: state.userId,);
          }
          if (state is AuthenticatedButNotSet) {
            return Profile(
                userRepository: _userRepository, userId: state.userId);
          }
          if (state is unAuthenticated) {
            return Login(
              userRepository: _userRepository,
            );
          } else
            return Container();
        },
      ),
    );
  }
}
