import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutterdiceroller/global_widgets/auto_text.dart';
import 'package:flutterdiceroller/screens/standard/custom/custom_rolls.dart';
import 'package:provider/provider.dart';

import 'dice_button.dart';
import 'dice_rolls.dart';
import 'mod_box.dart';

class DiceRoller extends StatefulWidget {
  List<DiceButton> buttons = List<DiceButton>();

  @override
  _DiceRollerState createState() => _DiceRollerState();
}

class _DiceRollerState extends State<DiceRoller> {

  @override void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final diceRolls = Provider.of<DiceRolls>(context);
    final customRolls = Provider.of<CustomRolls>(context);

    return Column(
      children: <Widget>[
        Expanded(
          flex: 7,
          child: Container(
            color: Color(0xFF202020),
            child: Padding(
                padding: new EdgeInsets.all(8.0),
                child: Column(
                children: diceRolls.getRows.length != 0 ? diceRolls.getRows :
                    [Container()]
                )
            )
          )
        ),
        Expanded(
          flex: 2,
          child: Container(
              //color: Color(0xFF202020),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF202020), Color(0xFF2c2c2c)]
                  )
              ),
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
                          customRolls.changeMute();
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
                    child: AutoSizeText(
                      "Total: " + diceRolls.totalRollsString,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 25.0
                      ),
                      minFontSize: 5.0,
                    )
                  )
                )
              ]
            )
          )
        ),
        Expanded(
          flex: 3,
          child: Material(
              // color: Color(0xFF202020),
              child: Row(
              children: diceRolls.getDiceButtons.length != 0 ?
                  diceRolls.getDiceButtons.sublist(0, 4) : [Container()]
              )
          )
        ),
        Expanded(
            flex: 3,
            child: Material(
                // color: Color(0xFF202020),
                child: Row(
                    children: diceRolls.getDiceButtons.length != 0 ?
                    diceRolls.getDiceButtons.sublist(4, 8) : [Container()]
                )
            )
        ),
        Expanded(
          flex: 2,
          child: Material(
              // color: Color(0xFF202020),
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
                      onLongPress: () async {
                        diceRolls.clearAll();
                      }
                    )
                )),
                Expanded(flex: 3,child: ModBox()),
                Expanded(flex: 2, child: Padding(
                    padding: new EdgeInsets.all(7.5),
                    child: RaisedButton(
                        child: AutoText("Roll", 20.0),
                        onPressed: () {
                          diceRolls.rollAll();

                          try {
                            diceRolls.playDiceSounds();
                          } on Exception {
                            print('ass');
                          } catch (e) {
                            print('ass');
                          }
                        }
                    )
                )),
              ],
            )
          )
        )
      ],
    );
  }
}