import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutterdiceroller/global_widgets/auto_text.dart';

import 'character_creation.dart';

class StatRollDisplay extends StatefulWidget {
  StatRollDisplay({Key key, this.stat}) : super(key: key);

  final String stat;

  @override
  _StatRollDisplayState createState() => _StatRollDisplayState();
}

class _StatRollDisplayState extends State<StatRollDisplay> {

  final rng = new Random();

  var _diceDisplays = new List<Widget>();
  bool _isButtonDisabled;

  void _setDisplays(var characterCreation) {
    bool removedMin = false;
    _diceDisplays.clear();
    List<int> rolls = characterCreation.statsDict[widget.stat][1];
    for (int i=0; i<rolls.length; i++) {
      int minimum = rolls.reduce(min);
      if (i != 3) {
        _diceDisplays.add(Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                height: 20,
                width: 20,
                child: Stack(
                    children: [
                      Center(
                          child: Image(
                            image: AssetImage('assets/dice_images/d6.png'),
                          )
                      ),
                      Center(
                        child: AutoText(
                            rolls[i].toString(), 50.0, Colors.white, true),
                      )
                    ]
                )
            )
        ));
      }
      else {
        removedMin = true;
        _diceDisplays.add(Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                height: 20,
                width: 20,
                child: Stack(
                    children: [
                      Center(
                          child: Image(
                            image: AssetImage('assets/dice_images/d6_grey.png'),
                          )
                      ),
                      Center(
                        child: AutoText(
                            rolls[i].toString(), 50.0, Colors.grey, true),
                      )
                    ]
                )
            )
        ));
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final characterCreation = Provider.of<CharacterCreation>(context);
    _setDisplays(characterCreation);
    _isButtonDisabled = characterCreation.statsDict[widget.stat][2];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final characterCreation = Provider.of<CharacterCreation>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Text(widget.stat),
        ),
        Expanded(
          flex: 4,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: _diceDisplays,
          )
        ),
        Expanded(
          flex: 1,
          child: Text(characterCreation.statsDict[widget.stat][0].toString())
        ),
        Expanded(
          flex: 1,
          child: Container(
            height: 20,
            width: 20,
            child: FlatButton(
              child: Icon(Icons.rotate_right),
              onPressed: _isButtonDisabled ? null : () => characterCreation.reRoll(widget.stat)
            )
          )
        )
      ]
    );
  }
}