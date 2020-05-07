import 'package:flutter/material.dart';
import 'package:flutterdiceroller/screens/standard/standard_dice/mod_box.dart';
import 'package:provider/provider.dart';

import 'package:flutterdiceroller/global_widgets/auto_text.dart';
import 'package:flutterdiceroller/screens/standard/standard_dice/dice_rolls.dart';
import 'package:flutterdiceroller/screens/standard/custom/custom_rolls.dart';

class DiceRollerCustom extends StatefulWidget {
  DiceRollerCustom({Key key}) : super(key: key);

  @override
  _DiceRollerCustomState createState() => _DiceRollerCustomState();
}

class _DiceRollerCustomState extends State<DiceRollerCustom> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final diceRolls = Provider.of<DiceRolls>(context, listen: false);
      diceRolls.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final customRolls = Provider.of<CustomRolls>(context);
    final diceRolls = Provider.of<DiceRolls>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("${customRolls.currentType}: ${customRolls.currentName}"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 7,
            child: Row(
                children: diceRolls.diceButtonsDisplay,
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    child: IconButton(
                      icon: diceRolls.getMute ? Icon(Icons.volume_off) : Icon(Icons.volume_up),
                      onPressed: () {
                        setState(() {
                          diceRolls.changeMute();
                        });
                      },
                    )
                  )
                ),
                Expanded(
                    flex: 6,
                    child: Container(
                        alignment: Alignment.centerRight,
                        padding: new EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                            "Roll: " + diceRolls.currentDice,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 15.0
                            )
                        )
                    )
                )
              ]
            )
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: diceRolls.getDiceButtons.sublist(0,4)
            )
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: diceRolls.getDiceButtons.sublist(4,8)
            )
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(flex: 2, child: Padding(
                  padding: new EdgeInsets.all(7.5),
                  child: RaisedButton(
                    child: AutoText("Clear", 20.0),
                    onPressed: () {
                      diceRolls.clear();
                    },
                  )
                )),
                Expanded(flex: 3,child: ModBox()),
                Expanded(flex: 2, child: Padding(
                    padding: new EdgeInsets.all(7.5),
                    child: RaisedButton(
                        child: AutoText("Confirm", 20.0),
                        onPressed: () async {
                          setState(() {
                            customRolls.setCurrentRoll(diceRolls.currentDice);
                            customRolls.addItem(customRolls.currentName, {customRolls.currentType: customRolls.currentRoll});
                            diceRolls.clearAll();
                          });
                          Navigator.of(context).pushReplacementNamed('/dice_1');
                        }
                    )
                )),
              ],
            )
          )
        ]
      )
    );
  }
}