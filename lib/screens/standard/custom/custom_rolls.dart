import 'package:audioplayers/audioplayers.dart';
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
  var _colors = Map<String, dynamic>();
  String _currentName = "";
  String _currentType = "";
  String _currentRoll = "";
  String _currentResult = "";
  int _currentResultInt = 0;

  List<int> _allRolls = List<int>();
  List<DiceDisplay> _diceDisplays = List<DiceDisplay>();

  int _custom = 2;
  bool _mute = false;

  List<AudioPlayer> audioPlayers = new List<AudioPlayer>();

  bool _swap = true;

  CustomRolls() {
    getItems();

    getMuteFile();

    notifyListeners();
  }

  void changeMute() {
    _mute = !_mute;
    notifyListeners();
  }

  void doRoll() async {

    /* Regexp stuff */
    var counts = regExpCount.allMatches(_currentRoll).map((m) => m[0]).toList();
    var sides = regExpSides.allMatches(_currentRoll).map((m) => m[0]).toList();

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
          custom: true,
        ));
        _allRolls.add(_diceDisplays[counter].getRoll);
        counter++;
      }
    }
    _currentResult = (_allRolls.reduce((a, b) => a + b)).toString();
    _currentResultInt = int.parse(_currentResult);
    if (isNegMod) {
      _currentResult += "$mod";
    }
    else if (mod != "0") {
      _currentResult += "+$mod";
    }
    if (mod != "0") {
      _currentResult += "=${_currentResultInt + int.parse(mod)}";
      _currentResultInt += int.parse(mod);
    }
    /* /rolls */
    setRows();

    for (var player in audioPlayers) {
      await player.stop();
    }

    audioPlayers.clear();

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
          audioPlayers.add(await _button.playSound());
        else
          audioPlayers.add(await _button.playMultiple());
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
    notifyListeners();
  }

  void getItems() async {
    var prefs = await SharedPreferences.getInstance();
    _items = (json.decode(prefs.getString('CustomSet') ?? "{}"));
    _colors = (json.decode(prefs.getString('Colors') ?? "{}"));
    _items["null"] = "{}";
    _colors["null"] = ThemeData.dark().cardColor.withAlpha(200).value;
    for (var key in _items.keys) {
      if (!_colors.containsKey(key)) {
        _colors[key] = ThemeData.dark().cardColor.value;
      }
    }
    await prefs.setString('Colors', json.encode(_colors));
    notifyListeners();
  }

  void addItem(String name, Map<String, dynamic> info) async {
    var prefs = await SharedPreferences.getInstance();

    _items.remove("null");
    _items[name] = info;
    _items["null"] = "{}";
    _colors[name] = ThemeData.dark().cardColor.value;
    await prefs.setString('CustomSet', json.encode(_items));
    await prefs.setString('Colors', json.encode(_colors));
    notifyListeners();
  }

  void swapItems(int oldIndex, int newIndex) async {
    var prefs = await SharedPreferences.getInstance();

    var itemsList = _items.keys.toList();
    itemsList.remove("null"); // make last
    var tempItems = Map<String, dynamic>();

    var item;

    /* ensure null CustomCard is last */
    if (newIndex < itemsList.length) {
      item = itemsList.removeAt(oldIndex);
      itemsList.insert(newIndex, item);
    }
    else {
      item = itemsList.removeAt(oldIndex);
      itemsList.insert(newIndex-1, item);
    }
      //itemsList.insert(newIndex-1, item);

    for (var itemName in itemsList) {
      tempItems[itemName] = _items[itemName];
    }

    _items = tempItems;
    _items["null"] = "{}";
    await prefs.setString('CustomSet', json.encode(_items));
    notifyListeners();
  }

  void setSwapButton() {
    _swap = !_swap;
    notifyListeners();
  }

  void confirmColor(Color color, String keyString) async {
    var prefs = await SharedPreferences.getInstance();
    _colors[keyString] = color.value;
    await prefs.setString('Colors', json.encode(_colors));
    notifyListeners();
  }

  void removeItem(String name) async {
    var prefs = await SharedPreferences.getInstance();
    _items.remove(name);
    _colors.remove(name);
    await prefs.setString('CustomSet', json.encode(_items));
    await prefs.setString('Colors', json.encode(_colors));
    notifyListeners();
  }

  void getMuteFile() async {
    var prefs = await SharedPreferences.getInstance();
    _mute = prefs.getBool('Mute') ?? false;
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
    notifyListeners();
  }

  void resetCustom() async {
    var prefs = await SharedPreferences.getInstance();
    _items.clear();
    _items["null"] = "{}";
    _colors.clear();
    _colors["null"] = ThemeData.dark().cardColor.withAlpha(200).value;
    await prefs.setString('CustomSet', json.encode(_items));
    await prefs.setString('Colors', json.encode(_colors));

  }

  void setCurrentName(String name) { _currentName = name; notifyListeners(); }
  void setCurrentType(String type) { _currentType = type; notifyListeners(); }
  void setCurrentRoll(String roll) { _currentRoll = roll; notifyListeners(); }

  Map<String, dynamic> get items => _items;
  Map<String, dynamic> get colors => _colors;

  String get currentName => _currentName;
  String get currentType => _currentType;
  String get currentRoll => _currentRoll;
  String get currentResult => _currentResult;
  int get currentResultInt => _currentResultInt;
  List<DiceDisplay> get diceDisplays => _diceDisplays;
  List<Expanded> get rows => _rows;
  bool get swap => _swap;

  int get getCustom => _custom;
}