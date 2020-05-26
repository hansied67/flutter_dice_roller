import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../global_variables.dart';
import 'custom_form.dart';
import 'character_creation.dart';

class CharacterCreationScreen extends StatefulWidget {
  CharacterCreationScreen({Key key}) : super(key: key);

  @override
  _CharacterCreationScreenState createState() =>
      _CharacterCreationScreenState();
}

class _CharacterCreationScreenState extends State<CharacterCreationScreen> {
  @override
  Widget build(BuildContext context) {
    final characterCreation = Provider.of<CharacterCreation>(context);
    return WillPopScope(
        onWillPop: () async {
          characterCreation.clear();
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text("Create a new Character"),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  CustomForm(),
                ]
              )
            )
          )
    );
  }
}