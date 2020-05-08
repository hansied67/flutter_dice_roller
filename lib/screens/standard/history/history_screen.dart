import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutterdiceroller/screens/standard/standard_dice/dice_rolls.dart';
import 'package:tuple/tuple.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({Key key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String dropdownValue = "Time";
  String ascendingDescending = "Descending";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final diceRolls = Provider.of<DiceRolls>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Roll History"),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Column(
                children: diceRolls.historyInfo.item3,
              )
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: AutoSizeText(
                          diceRolls.historyInfo.item1,
                          style: TextStyle(fontSize: 20.0, color: Colors.cyan),
                          textAlign: TextAlign.left,
                          maxLines: 3,
                        )
                      )
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: AutoSizeText(
                          diceRolls.historyInfo.item2,
                          style: TextStyle(fontSize: 25.0, color: Colors.cyanAccent),
                          textAlign: TextAlign.right,
                          maxLines: 1,
                        )
                      )
                    )
                  ],
                )
              )
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: <Widget> [
                    Expanded(
                        flex: 3,
                        child: Container(
                            alignment: Alignment.centerRight,
                            child: DropdownButton<String>(
                              value: ascendingDescending,
                              icon: ascendingDescending == "Descending" ?
                              Icon(Icons.arrow_downward) :Icon(Icons.arrow_upward),
                              iconSize: 24,
                              isExpanded: true,
                              underline: Container(
                                height: 1,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  ascendingDescending = newValue;
                                });
                              },
                              items: <String>['Descending', 'Ascending']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )
                        )
                    ),
                    Expanded(
                      flex: 3,
                      child: Container()
                    ),
                    Expanded(
                        flex: 2,
                        child: Container(
                            alignment: Alignment.centerRight,
                            child: DropdownButton<String>(
                              value: diceRolls.sortSelection,
                              icon: Icon(Icons.sort),
                              iconSize: 24,
                              isExpanded: true,
                              underline: Container(
                                height: 1,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  dropdownValue = newValue;
                                });
                                diceRolls.sort(dropdownValue);
                              },
                              items: <String>['Time', 'Roll', 'Result']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )
                        )
                    ),
                  ]
                )
              )
            ),
            Expanded(
              flex: 9,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: diceRolls.allInfo.length+1,
                itemBuilder: (context, index) {
                  if (index < diceRolls.allInfo.length) {
                    var info = diceRolls.allInfo[index];
                    return ListTile(
                        title: AutoSizeText(
                          info.item1,
                          maxLines: 1,
                        ),
                        subtitle: AutoSizeText(
                          info.item2,
                          maxLines: 2,
                        ),
                        trailing: AutoSizeText(
                          info.item3,
                          maxLines: 1,
                        ),
                        onTap: () {
                          diceRolls.setHistoryInfo(info);
                        }
                    );
                  }
                  else {
                    return ListTile();
                  }
                }
              )
            )
          ]
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            diceRolls.clearAllInfo();
          },
          label: Text("Clear"),
          icon: Icon(Icons.close),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
        )
      );
  }
}