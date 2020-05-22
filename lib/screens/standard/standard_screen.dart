import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutterdiceroller/screens/standard/standard_dice/dice_rolls.dart';
import '../../global_variables.dart';
import 'standard_dice/dice_roller.dart';
import 'package:flutterdiceroller/screens/standard/custom/custom_roller.dart';
import 'package:flutterdiceroller/screens/standard/custom/custom_rolls.dart';


class StandardScreen extends StatefulWidget {
  StandardScreen({Key key, this.page}) : super(key: key);

  final int page;

  @override
  _StandardScreenState createState() => _StandardScreenState();
}

class _StandardScreenState extends State<StandardScreen> with TickerProviderStateMixin {
  final Map<Tab, dynamic> myTabs = {
    new Tab(text: "Dice Roller"): DiceRoller(),
    new Tab(text: "Custom Roller"): CustomRoller()
  };
  TabController _tabController;
  int _sides = 0, _currentIndex;

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
                      maxLength: 9,
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

  void _onHamburger(String value, BuildContext context, var diceRolls) {
    switch (value) {
      case 'Settings':
        Navigator.pushNamed(context, '/settings');
        break;
      case 'Custom Die':
        _getInputDialog(context, diceRolls);
        diceRolls.setDiceButtons();
        break;
      case 'Roll History':
        Navigator.pushNamed(context, '/history');
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: widget.page, vsync: this, length: myTabs.length);
    _tabController.addListener(_handleTabSelection);
    _currentIndex = widget.page;
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentIndex = _tabController.index;
      });
    }
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
        bottom: new TabBar(
          controller: _tabController,
          tabs: myTabs.keys.toList(),
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String value) {_onHamburger(value, context, diceRolls);},
            itemBuilder: (BuildContext context) {
              return {'Settings','Custom Die','Roll History'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
    }
          )
        ],
      ),
      /*bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        backgroundColor: Color(0xFF202020),
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
      ),*/
      body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: <Widget>[
              DiceRoller(),
              CustomRoller(),
          ]
      ),
      floatingActionButton: _currentIndex == 1 ? Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
                heroTag: "btn1",
                onPressed: () {
                  customRolls.setSwapButton();
                },
                child: customRolls.swap ?
                    Icon(Icons.rotate_right) :
                    Icon(Icons.edit),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
            ),
          ]
      ) : Container()
    );
  }
}