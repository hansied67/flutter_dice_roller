import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutterdiceroller/global_widgets/auto_text.dart';
import 'package:provider/provider.dart';

import 'dice_rolls.dart';

class DiceDisplay extends StatefulWidget {
  final List<int> standardDice = [4, 6, 8, 10, 12, 20, 100];
  final int sides;
  int index;
  final rng = new Random();
  int _roll;
  Center _rollDisplay;

  DiceDisplay({this.sides, this.index}) {
    _roll = rng.nextInt(sides) + 1;
    double gradientPercent = _roll / sides;
    if (_roll != 1 && _roll != sides)
      _rollDisplay = Center(child: AutoText(_roll.toString(), 50.0, Colors.white, true));
    else if (_roll == 1)
      _rollDisplay = Center(child: AutoText(_roll.toString(), 50.0, Colors.red, true));
    else
      _rollDisplay = Center(child: AutoText(_roll.toString(), 50.0, Colors.green, true));
  }

  int get getRoll => _roll;
  Center get getRollDisplay => _rollDisplay;

  @override
  _DiceDisplayState createState() => _DiceDisplayState();
}

class _DiceDisplayState extends State<DiceDisplay>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final diceRolls = Provider.of<DiceRolls>(context);
    return Expanded(

      child: GestureDetector(
        onTap: () async {
          diceRolls.decDie(widget.sides, widget.index);
        },
        child: Stack(
          children: <Widget> [
            widget.standardDice.contains(widget.sides) ? Center(
              child: FractionallySizedBox(
                heightFactor: 0.8,
                widthFactor: 0.8,
                child: Image(
                  image: AssetImage('assets/dice_images/d' + widget.sides.toString() + '.png'),
                )
              )
            ) : Center(child: FractionallySizedBox(
              heightFactor: 0.8,
              widthFactor: 0.8,
              child: Image(
                image: AssetImage('assets/dice_images/d2_blank.png'),
              )
            )),
            widget.getRollDisplay
          ]
        )
      )
    );
  }
}
