import 'package:flutter/material.dart';
import 'package:flutterdiceroller/screens/standard/custom/custom_rolls.dart';
import 'package:flutterdiceroller/screens/standard/standard_dice/dice_rolls.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with TickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    new Tab(text: "Dice Roller"),
    new Tab(text: "Characters"),
  ];

  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: myTabs.length);
  }

  @override
  Widget build(BuildContext context) {
    final diceRolls = Provider.of<DiceRolls>(context);
    final customRolls = Provider.of<CustomRolls>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
          bottom: new TabBar(
            controller: _controller,
            tabs: myTabs

          )
      ),
      body: TabBarView(
        controller: _controller,
        children: myTabs.map((Tab tab) {
          final String label = tab.text;
          return label == "Characters" ? Center(
            child: Text('$label', style: const TextStyle(fontSize: 36)),
          ) : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                  child: Text('Delete Custom Rolls'),
                  onPressed: () {
                    showDialog(
                      context: context,
                      child: AlertDialog(
                        title: const Text ('Delete all Custom Rolls?'),
                        actions: [
                          FlatButton(
                            child: const Text('No'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }
                          ),
                          FlatButton(
                            child: const Text('Yes'),
                            onPressed: () {
                              diceRolls.resetCustom();
                              customRolls.resetCustom();
                              Navigator.of(context).pop();
                            }
                          )
                        ]
                      )
                    );
                  }
              )
            ]
          );
        }).toList()
      ),

    );
  }
}