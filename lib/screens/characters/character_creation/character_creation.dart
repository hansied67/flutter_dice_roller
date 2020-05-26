import 'dart:math';

import 'package:flutter/material.dart';

class CharacterCreation extends ChangeNotifier {
  final rng = new Random();

  bool _didRoll = false;

  Map<String, dynamic> _statsDict = {
    "Strength": [0, [0, 0, 0, 0], true],
    "Dexterity": [0, [0, 0, 0, 0], true],
    "Constitution": [0, [0, 0, 0, 0], true],
    "Intelligence": [0, [0, 0, 0, 0], true],
    "Wisdom": [0, [0, 0, 0, 0], true],
    "Charisma": [0, [0, 0, 0, 0], true]
  };

  Map<String, dynamic> _statsManual = {
    "Strength": 0,
    "Dexterity": 0,
    "Constitution": 0,
    "Intelligence": 0,
    "Wisdom": 0,
    "Charisma": 0,
  };

  void roll() {
    for (var key in _statsDict.keys) {
      List<int> rolls = _statsDict[key][1];
      for (int i = 0; i < _statsDict[key][1].length; i++) {
        rolls[i] = rng.nextInt(6) + 1;
      }
      rolls.sort((b, a) => a.compareTo(b));
      int minimum = rolls.reduce(min);
      _statsDict[key][0] = rolls.reduce((a, b) => a + b) - minimum;
      _statsDict[key][2] = false;
    }
    _didRoll = true;
    notifyListeners();
  }

  void reRoll(String stat) {
    List<int> rolls = _statsDict[stat][1];
    for (int i = 0; i < _statsDict[stat][1].length; i++) {
      rolls[i] = rng.nextInt(6) + 1;
    }
    rolls.sort((b, a) => a.compareTo(b));
    int minimum = rolls.reduce(min);
    _statsDict[stat][0] = rolls.reduce((a, b) => a + b) - minimum;
    _statsDict[stat][2] = true;
    notifyListeners();
  }

  void inputStat(String stat, int value) {
    _statsManual[stat] = value;
    print(_statsManual);
  }

  void clear() {
    for (var key in _statsDict.keys) {
      _statsDict[key][0] = 0;
      _statsDict[key][1] = [0, 0, 0, 0];
      _statsDict[key][2] = true;
      _didRoll = false;
      _statsManual[key] = 0;
    }
  }

  Map<String, dynamic> get statsDict => _statsDict;
  bool get didRoll => _didRoll;
}