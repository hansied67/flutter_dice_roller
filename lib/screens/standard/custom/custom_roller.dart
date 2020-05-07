import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:provider/provider.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final customRolls = Provider.of<CustomRolls>(context, listen: false);
      finalItems = customRolls.items;
      items = new Map<String, dynamic>.from(customRolls.items);
      initialItems = new Map<String, dynamic>.from(customRolls.items);
    });
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
    initialItems = new Map<String, dynamic>.from(customRolls.items);
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  // TODO: Row display
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: customRolls.rows,
                    )
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            alignment: Alignment.topRight,
                            child: Text(customRolls.currentName, style: TextStyle(fontSize: 15.0, color: Colors.cyan), textAlign: TextAlign.right)
                          )
                        ),
                        Expanded(
                            child: Container(
                                alignment: Alignment.bottomRight,
                                child: Text(customRolls.currentResult, style: TextStyle(fontSize: 25.0, color: Colors.cyanAccent))
                            )
                        ),
                      ]
                    )
                  ),
                ],
              )
            )
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                filterSearchResults(value, customRolls);
              },
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Search",
                hintText: "Spell",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0))
                )
              )
            )
          ),
          Expanded(
            flex: 2,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
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
                    Scaffold
                        .of(context)
                        .showSnackBar(SnackBar(content: Text("$key dismissed")));
                  },
                );
              }
            )
          )
        ],
      )
    );
  }
}