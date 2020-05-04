import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutterdiceroller/screens/standard/standard_dice/dice_rolls.dart';
import '../../global_variables.dart';
import 'standard_dice/dice_roller.dart';


class StandardScreen extends StatefulWidget {
  StandardScreen({Key key}) : super(key: key);

  @override
  _StandardScreenState createState() => _StandardScreenState();
}

class _StandardScreenState extends State<StandardScreen> {

  int _page = 0;
  PageController _controller;
  int _sides = 0;

  void _onHamburger(String value) {
    switch (value) {
      case 'Settings':
        Navigator.pushNamed(context, '/settings');
        break;
    }
  }

  @override
  void initState() {
    _controller = PageController(initialPage: _page);
    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final diceRolls = Provider.of<DiceRolls>(context);
    final globalVariables = Provider.of<GlobalVariables>(context);
    return Scaffold(
      drawer: new Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 100,
              child: DrawerHeader(
                child: Text("Screens"),
              )
            ),
            Container(
              color: Theme.of(context).accentColor,
              child: ListTile(
                title: Text("Dice Roller"),
                onTap: () {
                  // you're already on this page!
                }
              )
            ),
            ListTile(
                title: Text("Character"),
                onTap: () {
                  // TODO: go to character screen
                },
                trailing: globalVariables.isAndroid ? Icon(Icons.arrow_forward) :
                    Icon(Icons.arrow_forward_ios)
            ),
            ListTile(
                title: Text("DM Tools"),
                onTap: () {
                  // TODO: go to DM tools screen
                },
                trailing: globalVariables.isAndroid ? Icon(Icons.arrow_forward) :
                    Icon(Icons.arrow_forward_ios)
            )

          ],
        )
      ),
      appBar: AppBar(
        title: Text("Dice Roller"),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _onHamburger,
            itemBuilder: (BuildContext context) {
              return {'Settings',}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
    }
          )
        ],
      ),
      body: DiceRoller(),
    );
  }
}