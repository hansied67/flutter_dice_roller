import 'dart:math';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutterdiceroller/global_widgets/auto_text.dart';
import 'package:flutterdiceroller/screens/standard/custom/custom_rolls.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';

import 'dice_roller.dart';
import 'dice_rolls.dart';
import 'mod_box.dart';

class DiceButton extends StatefulWidget {

  final List<String> d4Sounds = [
    'd4long.ogg', 'd4Single.ogg', 'd4single_1.ogg',
    'd4single_2.ogg', 'd4single_3.ogg'];
  final List<String> d6Sounds = [
    'd6long.ogg', 'd6Single.ogg', 'd6single_1.ogg',
    'd6single_2.ogg', 'd6single_3.ogg'];
  final List<String> d8Sounds = [
    'd8long.ogg', 'd8Single.ogg', 'd8single_1.ogg',
    'd8single_2.ogg', 'd8single_3.ogg'];
  final List<String> d10Sounds = [
    'd10long.ogg', 'd10Single.ogg', 'd10single_1.ogg',
    'd10single_2.ogg', 'd10single_3.ogg'];
  final List<String> d12Sounds = [
    'd12long.ogg', 'd12Single.ogg', 'd12single_1.ogg',
    'd12single_2.ogg', 'd12single_3.ogg'];
  final List<String> d20Sounds = [
    'd20Big.ogg', 'd20biglong.ogg', 'd20single_2.ogg', 'd20Small.ogg',
    'd20small_1.ogg', 'd20smalllong.ogg'];

  final String d4Multiple = "d4Multiple.ogg";
  final String d6Multiple = "d6Multiple.ogg";
  final String d8Multiple = "d8Multiple.ogg";
  final String d10Multiple = "d10Multiple.ogg";
  final String d12Multiple = "d12Multiple.ogg";
  final String d20Multiple = "d20Multiple.ogg";

  final cache = AudioCache(prefix: 'sounds/');
  var player = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  
  final rng = new Random();
  List<Widget> buttonContents = List<Widget>();

  int _sides;
  bool _isCustom;

  Future<AudioPlayer> playSound() async {
    if (_sides == 4)
      player = await cache.play(d4Sounds[rng.nextInt(d4Sounds.length)]);
    else if (_sides == 6)
      player = await cache.play(d6Sounds[rng.nextInt(d6Sounds.length)]);
    else if (_sides == 8)
      player = await cache.play(d8Sounds[rng.nextInt(d8Sounds.length)]);
    else if (_sides == 10)
      player = await cache.play(d10Sounds[rng.nextInt(d10Sounds.length)]);
    else if (_sides == 12)
      player = await cache.play(d12Sounds[rng.nextInt(d12Sounds.length)]);
    else
      player = await cache.play(d20Sounds[rng.nextInt(d20Sounds.length)]);
    return player;
  }

  Future<AudioPlayer> playMultiple() async {
    if (_sides == 4)
      player = await cache.play(d4Multiple);
    else if (_sides == 6)
      player = await cache.play(d6Multiple);
    else if (_sides == 8)
      player = await cache.play(d8Multiple);
    else if (_sides == 10)
      player = await cache.play(d10Multiple);
    else if (_sides == 12)
      player = await cache.play(d12Multiple);
    else
      player = await cache.play(d20Multiple);
    return player;
  }

  DiceButton({int sides, bool isCustom}) {
    if (sides == 4) {
      cache.loadAll(d4Sounds);
      cache.load(d4Multiple);
    }
    if (sides == 6) {
      cache.loadAll(d6Sounds);
      cache.load(d6Multiple);
    }
    if (sides == 8) {
      cache.loadAll(d8Sounds);
      cache.load(d8Multiple);
    }
    if (sides == 10) {
      cache.loadAll(d10Sounds);
      cache.load(d10Multiple);
    }
    if (sides == 12) {
      cache.loadAll(d12Sounds);
      cache.load(d12Multiple);
    }
    else {
      cache.loadAll(d20Sounds);
      cache.load(d20Multiple);
    }
    _sides = sides;
    _isCustom = isCustom;
  }

  int get getSides => _sides;
  bool get getIsCustom => _isCustom;

  Future<String> _getInputDialog(BuildContext context, var diceRolls, var customRolls) async {
    // final diceRolls = Provider.of<DiceRolls>(context);
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit current custom roll'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  maxLength: 9,
                  onSubmitted: Navigator.of(context).pop,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  decoration: new InputDecoration(
                    labelText: 'Custom Roll Sides', hintText: '2'),
                    onChanged: (value) {
                      customRolls.diceDisplays.clear();
                      try {
                        _sides = int.parse(value);
                        if (_sides < 1) {
                          _sides = 1;
                        }
                        else if (_sides > 999999999) {
                          _sides = 999999999;
                        }
                      } on Exception {
                        _sides = 1;
                      }
                      if ([4, 6, 8, 10, 12, 20, 100].contains(_sides))
                        _sides = 1;
                      diceRolls.changeCustom(_sides);
                    },
                  )
                )
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () async {
                Navigator.of(context).pop();
              }
            )
          ],
        );
      }
    );
  }


  @override
  _DiceButtonState createState() => _DiceButtonState();
}

class _DiceButtonState extends State<DiceButton> {
  @override
  Widget build(BuildContext context) {
    final diceRolls = Provider.of<DiceRolls>(context);
    final customRolls = Provider.of<CustomRolls>(context);
    return Expanded(
        flex: 1,
        child: InkWell(
          splashColor: Color(0xFF2a2a2a),
          onTap: () async {
            if (!widget._isCustom) {
              diceRolls.onTap(widget);
            }
            else
              diceRolls.onTap(DiceButton(sides: diceRolls.getCustom, isCustom: true));
          },
          onLongPress: () async {
            if (widget._isCustom)
              widget._getInputDialog(context, diceRolls, customRolls);
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