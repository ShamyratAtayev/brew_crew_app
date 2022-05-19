import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4']; 

  // form values
  String? _currentName;
  String? _currentSugars;
  int? _currentStrength;


  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User?>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user?.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {

          UserData? iserData = snapshot.data;

          return Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'Update your brew settings.',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  initialValue: iserData?.name,
                  decoration: textInputDecoration.copyWith(hintText: 'Name'),                  
                  validator: (val) => val!.isEmpty ? "Enter a name" : null,
                  onChanged: (val) => _currentName = val,
                ),
                SizedBox(height: 20.0),
                // dropdown
                DropdownButtonFormField(
                  decoration: textInputDecoration,
                  value: _currentSugars ?? iserData?.sugars,
                  items: sugars.map((sugar) {
                    return DropdownMenuItem(
                      value: sugar,
                      child: Text('$sugar sugars'),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _currentSugars = val.toString();
                    });
                  },
                ),
                // slider
                Slider(
                  min: 100,
                  max: 900,
                  divisions: 8,
                  onChanged: (val) => setState(() {
                    _currentStrength = val.round();
                  }),
                  value: double.parse((_currentStrength ?? iserData?.strength).toString()),
                  activeColor: Colors.brown[_currentStrength ?? int.parse((iserData?.strength).toString())],
                  inactiveColor: Colors.brown[_currentStrength ?? int.parse((iserData?.strength).toString())],
                ),
                RaisedButton(
                  color: Colors.pink[400],
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_currentSugars == null){
                      _currentSugars = iserData?.sugars;
                    } 
                    if (_currentName == null){
                      _currentName = iserData?.name;
                    }
                    if (_currentStrength == null){
                      _currentStrength = iserData?.strength;
                    }
                    if (_formKey.currentState!.validate())
                    {
                      await DatabaseService(uid: user?.uid).updateUserData(
                        _currentSugars.toString(),
                        _currentName.toString(), 
                        _currentStrength!.toInt()
                        );
                        Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          );
        } else {
          return Loading() ;
        }
        
      }
    );
  }
}