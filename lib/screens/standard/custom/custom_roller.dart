import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutterdiceroller/screens/standard/standard_dice/dice_rolls.dart';

import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';
import 'package:tuple/tuple.dart';

import 'custom_card.dart';
import 'custom_rolls.dart';

class CustomRoller extends StatefulWidget {
  CustomRoller({Key key}) : super(key: key);

  @override
  _CustomRollerState createState() => _CustomRollerState();
}

class _CustomRollerState extends State<CustomRoller> {
  TextEditingController _controller = TextEditingController();

  var items = Map<String, dynamic>();
  var colors = Map<String, dynamic>();
  var cards = List<Widget>();

  void getCards() {
    cards.clear();
    for (int i=0; i<items.length; i++) {
      setState(() {
        cards.add(CustomCard(
            keyString: items.keys.elementAt(i),
            value: items[items.keys.elementAt(i)],
            color: Color(colors[items.keys.elementAt(i)])
        ));
      });
    }
    setState(() {
      cards.add(ListTile());
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final customRolls = Provider.of<CustomRolls>(context, listen: false);
    items = customRolls.items;
    colors = customRolls.colors;
    getCards();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final customRolls = Provider.of<CustomRolls>(context);
    final diceRolls = Provider.of<DiceRolls>(context);

    void _onReorder(int oldIndex, int newIndex) {
      setState(() {
        CustomCard row = cards.removeAt(oldIndex);
        cards.insert(newIndex, row);
        customRolls.swapItems(oldIndex, newIndex);
      });
    }

    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Material(color: Color(0xFF202020), child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: customRolls.rows.length <= 20 ?
                        customRolls.rows : customRolls.rows.sublist(0, 20)
                    )
                  ),
                ],
              )
            ))
          ),
          Expanded(flex: 1, child: Container(
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
                child: Slider(
                    value: diceRolls.volume,
                    min: 0.0,
                    max: 1.0,
                    label: diceRolls.volume.toString(),
                    onChanged: (double newValue) {
                      diceRolls.setVolume(newValue);
                    }
                )
              ),
              Expanded(
                  child: Padding(
                      padding: new EdgeInsets.only(right: 8.0),
                      child: Container(
                        child: AutoSizeText(
                          customRolls.currentName + ": " + customRolls.currentResult,
                          style: TextStyle(fontSize: 25.0, color: Colors.cyanAccent),
                          textAlign: TextAlign.right,
                          maxLines: 1,
                        )
                      )
                  )
              ),
            ],
          )
          )),
          Expanded(
            flex: 5,
            child: ReorderableWrap(
              spacing: 8.0,
              runSpacing: 4.0,
              alignment: WrapAlignment.center,
              padding: const EdgeInsets.all(8),
              children: cards,
              onReorder: _onReorder,
            )
          )
          /*Expanded(
            flex: 5,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 100.0,
              ),
              shrinkWrap: true,
              itemCount: items.length+4,
              padding: const EdgeInsets.all(8.0),
              itemBuilder: (context, index) {
                if (index < items.length) {
                  String key = items.keys.elementAt(index);
                  var value = items[key];
                  Color color = Color(colors[key]);

                  return CustomCard(
                    keyString: key,
                    value: value,
                    color: color,
                  );
                }
                else return ListTile();
              }
            )
          )*/
        ],
      )
    );
  }
}