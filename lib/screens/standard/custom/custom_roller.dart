import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutterdiceroller/screens/standard/standard_dice/dice_rolls.dart';

import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import 'custom_rolls.dart';

class CustomRoller extends StatefulWidget {
  CustomRoller({Key key}) : super(key: key);

  @override
  _CustomRollerState createState() => _CustomRollerState();
}

class _CustomRollerState extends State<CustomRoller> {
  TextEditingController _controller = TextEditingController();

  var items = Map<String, dynamic>();
  var initialItems = Map<String, dynamic>();
  var finalItems = Map<String, dynamic>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final customRolls = Provider.of<CustomRolls>(context, listen: false);
    finalItems = customRolls.items;
    items = new Map<String, dynamic>.from(customRolls.items);
    initialItems = new Map<String, dynamic>.from(customRolls.items);
    super.didChangeDependencies();
  }

  void filterSearchResults(String query, var customRolls) {
    var dummySearchList = Map<String, String>();

    for (String key in initialItems.keys) {
      dummySearchList[key] = initialItems[key].keys.elementAt(0);
    }

    if (query.isNotEmpty) {
      var dummyListData = Map<String, dynamic>();
      for (String key in dummySearchList.keys) {
        if (key.toLowerCase().contains(query.toLowerCase()) ||
            dummySearchList[key].toLowerCase().contains(query.toLowerCase())) {
          dummyListData[key] = initialItems[key];
        }
        else {
        }
      }
      setState(() {
        items.clear();
        for (var item in dummyListData.keys) {
          items[item] = dummyListData[item];
        }
      });
      return;
    }
    else {
      setState(() {
        items.clear();
        for (var key in initialItems.keys)
          items[key] = initialItems[key];
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final customRolls = Provider.of<CustomRolls>(context);
    final diceRolls = Provider.of<DiceRolls>(context);
    // initialItems = new Map<String, dynamic>.from(customRolls.items);
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Material(color: Color(0xFF202020), child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: customRolls.rows,
                    )
                  ),
                ],
              )
            ))
          ),
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF202020), Color(0xFF2c2c2c)]
                )
            ),
            child: Row(
            children: <Widget>[
              Container(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                      icon: diceRolls.getMute ? Icon(Icons.volume_off) : Icon(Icons.volume_up),
                      onPressed: () {
                        setState(() {
                          diceRolls.changeMute();
                          customRolls.changeMute();
                        });
                      }
                  )
              ),
              Expanded(
                  child: Container(
                      child: AutoSizeText(
                        customRolls.currentName,
                        style: TextStyle(fontSize: 20.0, color: Colors.cyan),
                        textAlign: TextAlign.left,
                        maxLines: 3,
                      )
                  )
              ),
              Expanded(
                  child: Padding(
                      padding: new EdgeInsets.only(right: 8.0),
                      child: Container(
                        child: AutoSizeText(
                          customRolls.currentResult,
                          style: TextStyle(fontSize: 25.0, color: Colors.cyanAccent),
                          textAlign: TextAlign.right,
                          maxLines: 1,
                        )
                      )
                  )
              ),
            ],
          )
          ),
          Material(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                filterSearchResults(value, customRolls);
              },
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: "Search",
                hintText: "Spell",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0))
                )
              )
            )
          )),
          Expanded(
            flex: 3,
            child: Material(child: ListView.separated(
              shrinkWrap: true,
              itemCount: items.length+1,
              separatorBuilder: (BuildContext context, int index) => new Divider(),
              itemBuilder: (context, index) {
                if (index < items.length) {
                  String key = items.keys.elementAt(index);
                  var value = items[key];
                  return Dismissible(
                    key: Key(key),
                    child: ListTile(
                        title: Text(key),
                        subtitle: Text(value.values.elementAt(0)),
                        trailing: Text(value.keys.elementAt(0)),
                        onTap: () {
                          customRolls.setCurrentName(key);
                          customRolls.setCurrentRoll(value.values.elementAt(0));
                          customRolls.setCurrentType(value.keys.elementAt(0));
                          customRolls.doRoll();
                          setState(() {
                            diceRolls.allInfoTime.add(Tuple4(
                                customRolls.currentName,
                                customRolls.currentRoll,
                                customRolls.currentResult,
                                new List<Expanded>.from(customRolls.rows)));
                            diceRolls.allInfo.add(Tuple4(
                                customRolls.currentName,
                                customRolls.currentRoll,
                                customRolls.currentResult,
                                new List<Expanded>.from(customRolls.rows)));
                          });
                        }
                    ),
                    onDismissed: (direction) {
                      setState(() {
                        finalItems.remove(key);
                        initialItems.remove(key);
                        items.remove(key);
                        customRolls.removeItem();
                      });
                      // Show a snackbar. This snackbar could also contain "Undo" actions.
                      /*Scaffold
                          .of(context)
                          .showSnackBar(SnackBar(content: Text(
                          "$key dismissed"), duration: Duration(seconds: 1)));*/
                    },
                  );
                }
                else {
                  return ListTile();
                }
              }
            ))
          )
        ],
      )
    );
  }
}