import 'package:brew_crew/screens/authenticate/sign_in.dart';

class User {

  final String uid;

  User({required this.uid});

}

class UserData {

  final String? uid;
  final String? name;
  final String? sugars;
  final int? strength;

  UserData({ this.uid, this.name, this.sugars, this.strength });

}