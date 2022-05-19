import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {

final Function? toggle;
  SignIn({this.toggle});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _authService = AuthService();
  final _fomrKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email ='';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
        backgroundColor: Colors.brown[100],
        appBar: AppBar(
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          title: Text('Sign in to Brew Crew'),
          actions: [
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text("Register"),
              onPressed: () {
                widget.toggle!();
              },
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _fomrKey,
            child: Column(
              children: [
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Email'),
                  validator: (val) => val!.isEmpty ? "Enter an email" : null,
                  onChanged: (mail) {
                    setState(() {
                      email = mail;
                    });
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Password'),
                  validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                  obscureText: true,
                  onChanged: (pass) {
                    setState(() {
                      password = pass;
                    });
                  },
                ),
                SizedBox(height: 20.0),
                RaisedButton(
                  color: Colors.pink[400],
                  child: Text(
                    'Sign in',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_fomrKey.currentState!.validate()){
                      setState(() {
                        loading = true;
                      });
                      dynamic result = await _authService.signInWithEmailAndPassword(email, password);
                      if(result == null) {
                        setState(() {
                          error = 'COULD NOT SIGN IN WITH THOSE CREDENTIALS';
                          loading = false;
                        });
                      } 
                    }
                  },
                ),
                SizedBox(height: 12.0),
                Text (
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                )
              ],
            ),
            )
        ),
    );
  }
}