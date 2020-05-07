import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutterdiceroller/global_widgets/auto_text.dart';
import 'package:flutterdiceroller/screens/standard/custom/custom_rolls.dart';
import 'package:provider/provider.dart';

import 'dice_button.dart';
import 'dice_rolls.dart';
import 'mod_box.dart';

class DiceRoller extends StatefulWidget {
  List<DiceButton> buttons = List<DiceButton>();

  List<AudioPlayer> audioPlayers = new List<AudioPlayer>();

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
          child: Column(
              children: diceRolls.getRows
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
                  child: Text(
                    "Total: " + diceRolls.getTotalRolls.toString(),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: 25.0
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
              children: diceRolls.getDiceButtons.length != 0 ?
                  diceRolls.getDiceButtons.sublist(0, 4) : [Container()]
          ),
        ),
        Expanded(
          flex: 3,
          child: Row(
              children: diceRolls.getDiceButtons.length != 0 ?
              diceRolls.getDiceButtons.sublist(4, 8) : [Container()]
          ),
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
                      onPressed: () async {
                        diceRolls.rollAll();

                        for (var player in widget.audioPlayers) {
                          await player.stop();
                        }

                        int count = 0;
                        if (!diceRolls.getMute) {
                          for (int key in diceRolls.getDiceCounts.keys) {
                            if (diceRolls.getDiceCounts[key] == 1) {
                              widget.audioPlayers.add(await diceRolls
                                  .getDiceButtons[count].playSound());
                            }
                            else if (diceRolls.getDiceCounts[key] > 1) {
                              widget.audioPlayers.add(await diceRolls
                                  .getDiceButtons[count].playMultiple());
                            }
                            count++;
                          }
                        }
                        else
                          print(diceRolls.getDiceCounts);
                      }
                  )
              )),
            ],
          )
        )
      ],
    );
  }
}