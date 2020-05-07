import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutterdiceroller/screens/standard/standard_dice/dice_rolls.dart';
import '../../global_variables.dart';
import 'standard_dice/dice_roller.dart';
import 'package:flutterdiceroller/screens/standard/custom/custom_roller.dart';
import 'package:flutterdiceroller/screens/standard/custom/custom_rolls.dart';


class StandardScreen extends StatefulWidget {
  StandardScreen({Key key}) : super(key: key);

  @override
  _StandardScreenState createState() => _StandardScreenState();
}

class _StandardScreenState extends State<StandardScreen> {
  int _page = 0;
  PageController _controller = PageController(initialPage: 0, keepPage: true);
  int _sides = 0;
  bool _validate = false;

  Future<String> _getInputDialog(BuildContext context, var diceRolls) async {
    // final diceRolls = Provider.of<DiceRolls>(context);
    return showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit current custom roll'),
            content: new Row(
              children: <Widget>[
                new Expanded(
                    child: new TextField(
                      onSubmitted: Navigator.of(context).pop,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      decoration: new InputDecoration(
                          labelText: 'Custom Roll Sides', hintText: '2'),
                      onChanged: (value) async {
                        try {
                          _sides = int.parse(value);
                        } on Exception {
                          _sides = diceRolls.getCustom;
                        }
                        await diceRolls.changeCustom(_sides);
                        print(diceRolls.getCustom);
                      },
                    )
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text('Ok'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  }
              )
            ],
          );
        }
    );
  }

  Future<String> _getInputDialogCustom(BuildContext context, var customRolls) async {
    return showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add a Custom Roll'),
            content: SingleChildScrollView(
                child: ListBody(
                    children: <Widget>[
                      new TextField(
                        autofocus: true,
                        decoration: new InputDecoration(
                            labelText: 'Name', hintText: 'Potion of Healing',
                            errorText: _validate ? "Value Can't Be Empty" : null,
                        ),
                        onChanged: (value) async {
                          customRolls.setCurrentName(value);
                        },
                      ),
                      new TextField(
                        decoration: new InputDecoration(
                            labelText: 'Type', hintText: 'Spell'),
                        onChanged: (value) async {
                          customRolls.setCurrentType(value);
                        },
                      ),
                    ]
                ),
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text('Input Dice'),
                  onPressed: () async {
                    if (customRolls.currentName.isEmpty)
                      setState(() {
                        _validate = true;
                      });
                    else
                      Navigator.of(context).pushReplacementNamed('/dice_custom');
                  }
              )
            ],
          );
        }
    );
  }

  void _onHamburger(String value, BuildContext context, var diceRolls) {
    switch (value) {
      case 'Settings':
        Navigator.pushNamed(context, '/settings');
        break;
      case 'Custom Die':
        _getInputDialog(context, diceRolls);
        diceRolls.setDiceButtons();
        break;
    }
  }

  void pageChanged(int index) {
    setState(() {
      _page = index;
    });
  }

  void _onTapped(int index) {
    setState(() {
      _page = index;
      _controller.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  void initState() {
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
    final customRolls = Provider.of<CustomRolls>(context);
    return Scaffold(
      drawer: new Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 125,
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
                  // TODO: go to character screen (PushReplacementNamed)
                },
                trailing: globalVariables.isAndroid ? Icon(Icons.arrow_forward) :
                    Icon(Icons.arrow_forward_ios)
            ),
            ListTile(
                title: Text("DM Tools"),
                onTap: () {
                  // TODO: go to DM tools screen (PushReplacementNamed)
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
            onSelected: (String value) {_onHamburger(value, context, diceRolls);},
            itemBuilder: (BuildContext context) {
              return {'Settings','Custom Die'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
    }
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Standard Dice"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.accessibility_new),
            title: Text("Custom Dice"),
          )
        ],
        onTap: (index) => _onTapped(index)
      ),
      body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _controller,
          onPageChanged: (index) {
              pageChanged(index);
          },
          children: <Widget>[
              DiceRoller(),
              CustomRoller(),
          ]
      ),
      floatingActionButton: _page == 1 ? FloatingActionButton(
        onPressed: () {
          // TODO: go to custom input screen
          diceRolls.clear();
          _getInputDialogCustom(context, customRolls);
        },
        child: Icon(Icons.add),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
      ) : Container()
    );
  }
}