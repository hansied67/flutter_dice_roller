import 'package:flutter/material.dart';
import 'package:flutterdiceroller/global_widgets/auto_text.dart';
import 'package:flutterdiceroller/screens/standard/custom/custom_rolls.dart';
import 'package:flutterdiceroller/screens/standard/standard_dice/dice_rolls.dart';
import 'package:provider/provider.dart';


class DiceButtonDisplay extends StatefulWidget {

  int _num, _sides;
  bool _isCustom;

  DiceButtonDisplay({int num, int sides, bool isCustom}) {
    _num = num;
    _sides = sides;
    _isCustom = isCustom;
  }

  int get getNum => _num;
  int get getSides => _sides;
  bool get getIsCustom => _isCustom;

  @override
  _DiceButtonDisplayState createState() => _DiceButtonDisplayState();
}

class _DiceButtonDisplayState extends State<DiceButtonDisplay> {
  @override
  Widget build(BuildContext context) {
    final diceRolls = Provider.of<DiceRolls>(context);
    return Expanded(
        flex: 1,
        child: GestureDetector(
            onTap: () async {
              print('a');
              if (!widget._isCustom) {
                diceRolls.onTapDec(widget);
              }
              else {
                diceRolls.onTapDec(DiceButtonDisplay(num: widget._num, sides: diceRolls.getCustom, isCustom: true));
              }
            },
            onLongPress: () async {

            },
            child: Stack(children: <Widget> [
              Center(
                  child: FractionallySizedBox(
                      heightFactor: 0.8,
                      widthFactor: 0.8,
                      child: Image(
                        image: widget._isCustom ? AssetImage('assets/dice_images/d2.png') :
                        AssetImage('assets/dice_images/d' + widget._sides.toString() + '.png'),
                      )
                  )
              ),
              !(widget._isCustom) ? Center(child: AutoText(diceRolls.getDiceCounts[widget._sides].toString()
                  + "d" + widget._sides.toString(), 25.0, Colors.white, true)) :
              Center(child: AutoText(diceRolls.getDiceCounts[diceRolls.getCustom].toString()
                  + "d" + diceRolls.getCustom.toString(), 25.0, Colors.white, true)),
            ])
        )
    );
  }
}