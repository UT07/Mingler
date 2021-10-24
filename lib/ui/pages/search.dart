import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test2/bloc/search/search_bloc.dart';
import 'package:flutter_test2/models/user.dart';
import 'package:flutter_test2/repositories/searchRepository.dart';
import 'package:flutter_test2/ui/widgets/iconWidget.dart';
import 'package:flutter_test2/ui/widgets/profile.dart';
import 'package:flutter_test2/ui/widgets/userGender.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Search extends StatefulWidget {
  final String userId;

  const Search({this.userId});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final SearchRepository _searchRepository = SearchRepository();
  SearchBloc _searchBloc;
  User _user, _currentUser;
  int difference;

  getDifference(GeoPoint userLocation) async {
    Position position = await Geolocator.getCurrentPosition();
    double location = Geolocator.distanceBetween(userLocation.latitude,
        userLocation.longitude, position.latitude, position.longitude);

    difference = location.toInt();
  }

  @override
  void initState() {
    _searchBloc = SearchBloc(searchRepository: _searchRepository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocBuilder<SearchBloc, SearchState>(
      bloc: _searchBloc,
      builder: (context, state) {
        if (state is InitialSearchState) {
          _searchBloc.add(
            LoadUserEvent(userId: widget.userId),
          );
          return Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.blueGrey),
          ));
        }
        if (state is LoadingState) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.blueGrey),
            ),
          );
        }
        if (state is LoadUserState) {
          _user = state.user;
          _currentUser = state.currentUser;

          getDifference(_user.location);
          if (_user.location == null) {
            return Text(
              "No more profiles to show",
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            );
          } else
            return SingleChildScrollView(
                child: profileWidget(
                    padding: size.height * .035,
                    photoHeight: size.height * .824,
                    photoWidth: size.width * .95,
                    photo: _user.photo,
                    clipRadius: size.height * .02,
                    containerHeight: size.height * .3,
                    containerWidth: size.width * .9,
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * .02),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: size.height * .07,
                              ),
                              Row(
                                children: <Widget>[
                                  userGender(_user.gender),
                                  Expanded(
                                    child: Text(
                                      " " +
                                          _user.name +
                                          ", " +
                                          (DateTime.now().year -
                                                  _user.age.toDate().year)
                                              .toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: size.height * 0.05),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                  ),
                                  Text(
                                      difference != null
                                          ? ((difference / 1000) * .62137119224)
                                                  .floor()
                                                  .toString() +
                                              "miles away"
                                          : "away",
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                              SizedBox(
                                  height: size.height * .05,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      iconWidget(EvaIcons.flash, () {},
                                          size.height * .04, Colors.yellow),
                                      iconWidget(Icons.clear, () {
                                        _searchBloc.add(PassUserEvent(
                                            widget.userId, _user.uid));
                                      }, size.height * .08, Colors.blue),
                                      iconWidget(FontAwesomeIcons.solidHeart,
                                          () {
                                        _searchBloc.add(
                                          SelectUserEvent(
                                              name: _currentUser.name,
                                              photoUrl: _currentUser.photo,
                                              currentUserId: widget.userId,
                                              selectedUserId: _user.uid),
                                        );
                                      }, size.height * 0.06, Colors.red),
                                      iconWidget(EvaIcons.options2, () {},
                                          size.height * .04, Colors.white),
                                    ],
                                  ))
                            ]))));
        } else
          return Container();
      },
    );
  }
}
