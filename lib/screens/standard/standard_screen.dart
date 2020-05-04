import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutterdiceroller/screens/standard/standard_dice/dice_rolls.dart';
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

  List<Widget> _screens = <Widget>[
    DiceRoller(),
    Text('Index 1'),
  ];

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
    return Scaffold(
      drawer: new Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text("Screens"),
            ),
            ListTile(
              title: Text("Dice Roller"),
              onTap: () {
                // you're already on this page!
              }
            ),
            ListTile(
                title: Text("Character"),
                onTap: () {
                  // TODO: go to character screen
                }
            ),
            ListTile(
                title: Text("DM Tools"),
                onTap: () {
                  // TODO: go to DM tools screen
                }
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
      body: PageView(
        controller: _controller,
        onPageChanged: (newPage) {
          setState(() {
            this._page = newPage;
          });
        },
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        onTap: (index) {
          this._controller.animateToPage(
              index,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut
          );
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('0'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.ac_unit),
            title: Text('1'),
          )
        ],
        selectedItemColor: Colors.purple[800],
      ),
    );
  }
}