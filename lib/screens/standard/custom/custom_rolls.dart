import 'package:flutter/material.dart';
import 'package:flutterdiceroller/screens/standard/standard_dice/dice_button.dart';
import 'package:flutterdiceroller/screens/standard/standard_dice/dice_display.dart';
import 'package:flutterdiceroller/screens/standard/standard_dice/dice_rolls.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'dart:math';

class CustomRolls extends ChangeNotifier {
  final diceRolls = DiceRolls();
  final regExpCount = new RegExp(r"(\d+)(?=d)");
  final regExpSides = new RegExp(r"(d)(\d+)");
  final regExpMinus = new RegExp(r"(\-)");
  final regExpPlus = new RegExp(r"(\+)");
  final regExpMod = new RegExp(r"(\d+)(?!.*\d)");

  final rng = new Random();
  final _rowSize = 5;
  List<Expanded> _rows = List<Expanded>();

  var _items = Map<String, dynamic>();
  String _currentName = "";
  String _currentType = "";
  String _currentRoll = "";
  String _currentResult = "";

  List<int> _allRolls = List<int>();
  List<DiceDisplay> _diceDisplays = List<DiceDisplay>();

  int _custom = 2;
  bool _mute = false;

  CustomRolls() {
    getItems();
    notifyListeners();
  }

  void changeMute() {
    _mute = !_mute;
  }

  void doRoll() {
    /* Regexp stuff */
    var counts = regExpCount.allMatches(_currentRoll).map((m) => m[0]).toList();
    var sides = regExpSides.allMatches(_currentRoll).map((m) => m[0]).toList();

    print("counts: $counts");
    print("sides: $sides");

    for (int i = 0; i < sides.length; i++) {
      sides[i] = sides[i].substring(1, sides[i].length);
    }

    var isNegMod = regExpMinus.hasMatch(_currentRoll);
    var pluses = regExpPlus.allMatches(_currentRoll).map((m) => m[0]).toList();
    var mod = sides.length == pluses.length ?
        regExpMod.stringMatch(_currentRoll) :
        "0";
    if (isNegMod) {
      mod = (int.parse(regExpMod.stringMatch(_currentRoll)) * -1).toString();
    }
    /* /Regexp stuff */

    _allRolls.clear();
    _diceDisplays.clear();
    int counter = 0;

    /* rolls */
    for (int i=0; i<counts.length; i++) {
      for (int num = 0; num<int.parse(counts[i]); num++) {
        _diceDisplays.add(DiceDisplay(
          sides: int.parse(sides[i]),
          index: counter,
        ));
        _allRolls.add(_diceDisplays[counter].getRoll);
        counter++;
      }
    }
    print(_allRolls);
    _currentResult = (_allRolls.reduce((a, b) => a + b)).toString();
    int temp = int.parse(_currentResult);
    if (isNegMod) {
      _currentResult += "$mod";
    }
    else if (mod != "0") {
      _currentResult += "+$mod";
    }
    if (mod != "0") {
      _currentResult += "=${temp + int.parse(mod)}";
    }
    /* /rolls */
    setRows();

    /* play sounds */
    if (!_mute) {
      var soundMap = Map<int, int>();
      for (var dice in _diceDisplays) {
        var _sides = dice.getSides;
        if (soundMap.keys.contains(_sides))
          soundMap[_sides]++;
        else
          soundMap[_sides] = 1;
      }
      for (int key in soundMap.keys) {
        DiceButton _button;
        if ([4, 6, 8, 10, 12, 20].contains(sides))
          _button = new DiceButton(sides: key, isCustom: false);
        else
          _button = new DiceButton(sides: key, isCustom: true);
        if (soundMap[key] == 1)
          _button.playSound();
        else
          _button.playMultiple();
      }
    }
    /* /play sounds */

    notifyListeners();
  }

  void setRows() {
    int rowCount = _diceDisplays.length ~/ _rowSize + 1;
    _rows.clear();

    int i;
    for (i=0; i<rowCount - 1; i++) {
      _rows.add((Expanded(flex: 1, child: Row(children: _diceDisplays.sublist(i*_rowSize, (i+1)*_rowSize)))));
    }
    if (i*_rowSize - _diceDisplays.length != 0)
      _rows.add((Expanded(flex: 1, child: Row(children: _diceDisplays.sublist(i*_rowSize, _diceDisplays.length)))));
  }

  void getItems() async {
    var prefs = await SharedPreferences.getInstance();
    _items = (json.decode(prefs.getString('CustomSet')));
    notifyListeners();
  }

  void addItem(String name, Map<String, dynamic> info) async {
    var prefs = await SharedPreferences.getInstance();

    _items[name] = info;
    await prefs.setString('CustomSet', json.encode(_items));
    notifyListeners();
  }

  void removeItem() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('CustomSet', json.encode(_items));
    notifyListeners();
  }

  void clear() {
    _currentName = "";
    _currentType = "";
    _currentRoll = "";
    _currentResult = "";
    _allRolls.clear();
    _diceDisplays.clear();
    _rows.clear();
  }

  void setCurrentName(String name) { _currentName = name; notifyListeners(); }
  void setCurrentType(String type) { _currentType = type; notifyListeners(); }
  void setCurrentRoll(String roll) { _currentRoll = roll; notifyListeners(); }

  Map<String, dynamic> get items => _items;

  String get currentName => _currentName;
  String get currentType => _currentType;
  String get currentRoll => _currentRoll;
  String get currentResult => _currentResult;
  List<DiceDisplay> get diceDisplays => _diceDisplays;
  List<Expanded> get rows => _rows;

  int get getCustom => _custom;
}