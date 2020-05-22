import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';
import 'dart:math';

import 'dice_button.dart';
import 'dice_display.dart';
import 'package:flutterdiceroller/global_variables.dart';
import 'package:flutterdiceroller/screens/standard/custom/custom_rolls.dart';
import 'package:flutterdiceroller/screens/standard/custom/dice_button_display.dart';

class DiceRolls extends ChangeNotifier {
  final globalVariables = GlobalVariables();
  final _rowSize = 5;

  int _mod = 0;
  int _custom = 2;
  bool _mute = false;
  String _sortSelection = "Time";
  String _sortBy = "Ascending";
  
  String _currentDie = "";
  String _currentDice = "";
  int _totalRolls = 0;
  String _totalRollsString = "";
  List<int> _allRolls = List<int>();
  Map<int, int> _diceCounts = {4: 0, 6: 0, 8: 0, 10: 0, 12: 0, 20: 0, 100: 0};
  var _allInfo = List<Tuple5<String, String, String, String, List<Expanded>>>();
  var _allInfoTime = List<Tuple5<String, String, String, String, List<Expanded>>>();
  var _historyInfo = Tuple3<String, String, List<Expanded>>("", "", List<Expanded>());

  List<DiceButton> _diceButtons = List<DiceButton>();

  List<DiceDisplay> _diceDisplays = List<DiceDisplay>();

  List<DiceButtonDisplay> _diceButtonsDisplay = List<DiceButtonDisplay>();
  List<Expanded> _rows = List<Expanded>();  // rows of DiceDisplay

  List<AudioPlayer> audioPlayers = new List<AudioPlayer>();

  var rng = new Random();

  DiceRolls() {
    setDiceButtons();
    getMuteFile();
  }

  void resetCustom() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _diceCounts.remove(_custom);
    _custom = 2;
    _diceCounts[_custom] = 0;
    await prefs.setInt('custom', _custom);
    notifyListeners();
  }

  void setDiceButtons() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _custom = (prefs.getInt('custom') ?? 2);
    _diceCounts[_custom] = 0;

    for (var i in [4, 6, 8, 10, 12, 20, 100]) {
      _diceButtons.add(DiceButton(
          sides: i,
          isCustom: false
      ));
    }
    _diceButtons.add(DiceButton(
        sides: _custom,
        isCustom: true
    ));
    notifyListeners();
  }

  void changeMute() async {
    _mute = !_mute;
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Mute', _mute);
    notifyListeners();
  }

  void changeMod(int change) {
    bool small = _mod > -9999999;
    bool big = _mod < 99999999;
    if ((big || change < 0) && (small || change > 0)) {
      var temp = _mod;
      if (temp < 0) temp = -temp;
      _mod += change;

      if (_mod > 0)
        _totalRollsString = _totalRolls.toString() + "+" + _mod.toString() +
            "=" + (_totalRolls+_mod).toString();
      else if (_mod < 0)
        _totalRollsString = _totalRolls.toString() + "-" + (_mod*-1).toString() +
            "=" + (_totalRolls+_mod).toString();
      else
        _totalRollsString = _totalRolls.toString();

      // _totalRolls += change;
      if (_currentDice.length - 2 > 0) {
        if (_currentDice[_currentDice.length - (temp.toString().length+1)] == '+' ||
            _currentDice[_currentDice.length - (temp.toString().length+1)] == '-')
          _currentDice = _currentDice.substring(0, _currentDice.length - (temp.toString().length+1));
      }
      if (_mod > 0 && _currentDice.length != 0) {
        _currentDice += "+$_mod";
      }
      else if (_mod < 0 && _currentDice.length != 0) {
        _currentDice += "-${_mod * -1}";
      }
        // _currentDice += _mod.toString();
      notifyListeners();
    }
  }

  void changeModText(int change) {
    // _totalRolls -= _mod;
    var temp = _mod;
    if (temp < 0) temp = -temp;
    _mod = change;

    if (_mod > 0)
      _totalRollsString = _totalRolls.toString() + "+" + _mod.toString() +
          "=" + (_totalRolls+_mod).toString();
    else if (_mod < 0)
      _totalRollsString = _totalRolls.toString() + "-" + (_mod*-1).toString() +
          "=" + (_totalRolls+_mod).toString();
    else
      _totalRollsString = _totalRolls.toString();

    // _totalRolls += _mod;
    if (_currentDice.length - 2 > 0) {
      if (_currentDice[_currentDice.length - (temp.toString().length+1)] == '+' ||
          _currentDice[_currentDice.length - (temp.toString().length+1)] == '-')
        _currentDice = _currentDice.substring(0, _currentDice.length - (temp.toString().length+1));
    }
    if (_mod > 0 && _currentDice.length != 0) {
      _currentDice += "+$_mod";
    }
    else if (_mod < 0 && _currentDice.length != 0) {
      _currentDice += "-${_mod*-1}";
    }
    notifyListeners();
  }

  void changeCustom(int custom) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _diceCounts.remove(_diceCounts[_custom]);
    _custom = custom;
    await prefs.setInt('custom', _custom);
    _diceCounts[_custom] = 0;

    notifyListeners();
  }

  void decDie(int sides, int index, bool custom, var customRolls) {
    _allRolls.removeAt(index);
    if (_diceCounts[sides] != null)
      _diceCounts[sides]--;
    _totalRolls -= _diceDisplays
        .elementAt(index)
        .getRoll;
    _diceDisplays.removeAt(index);
    for (int i = 0; i < _diceDisplays.length; i++) {
      if (_diceDisplays[i].index > index)
        _diceDisplays[i].index--;
    }
    setRows();
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

  void onTap(DiceButton button) {
    if ((_allRolls.length < 40 || globalVariables.isMobile == false)) {
      if (!_mute)
        button.playSound();
      _diceCounts[button.getSides]++;

      _diceDisplays.add(
          DiceDisplay(sides: button.getSides, index: _diceDisplays.length));

      setRows();

      _allRolls.add(_diceDisplays[_diceDisplays.length - 1].getRoll);
      _totalRolls += _allRolls[_allRolls.length - 1];

      if (_mod > 0)
        _totalRollsString = _totalRolls.toString() + "+" + _mod.toString() +
            "=" + (_totalRolls+_mod).toString();
      else if (_mod < 0)
        _totalRollsString = _totalRolls.toString() + "-" + (_mod*-1).toString() +
            "=" + (_totalRolls+_mod).toString();
      else
        _totalRollsString = _totalRolls.toString();

      _currentDice = "";
      for (var key in _diceCounts.keys) {
        if (key == -1)
          _currentDie = "d?";
        else
          _currentDie = "d" + key.toString();
        if (_diceCounts[key] != 0)
          if (_currentDice == "")
            _currentDice += _diceCounts[key].toString() + _currentDie;
          else
            _currentDice += "+" + _diceCounts[key].toString() + _currentDie;
      }

      _diceButtonsDisplay.clear();
      for (int key in _diceCounts.keys) {
        var _isCustom = ![4, 6, 8, 10, 12, 20, 100].contains(key);
        if (_diceCounts[key] > 0) {
          _diceButtonsDisplay.add(DiceButtonDisplay(
              num: _diceCounts[key],
              sides: key,
              isCustom: _isCustom
          ));
        }
      }

      if (_mod > 0) {
        _currentDice += "+$_mod";
      }
      else if (_mod < 0) {
        _currentDice += "-${_mod * -1}";
      }

      notifyListeners();
    }
  }

  void onTapDec(DiceButtonDisplay button) {
    _diceCounts[button.getSides]--;
    _diceButtonsDisplay.clear();
    for (int key in _diceCounts.keys) {
      var _isCustom = ![4, 6, 8, 10, 12, 20, 100].contains(key);
      if (_diceCounts[key] > 0) {
        _diceButtonsDisplay.add(DiceButtonDisplay(
            num: _diceCounts[key],
            sides: key,
            isCustom: _isCustom
        ));
      }
    }
    _currentDice = "";
    for (var key in _diceCounts.keys) {
      if (key == -1)
        _currentDie = "d?";
      else
        _currentDie = "d" + key.toString();
      if (_diceCounts[key] != 0)
        if (_currentDice == "")
          _currentDice += _diceCounts[key].toString() + _currentDie;
        else
          _currentDice += " + " + _diceCounts[key].toString() + _currentDie;
    }
    notifyListeners();
  }

  void rollAll() {

    _allRolls.clear();
    _diceDisplays.clear();

    _currentDice = "";
    _totalRolls = 0;

    int count = 0;
    for (int key in _diceCounts.keys) {
      if (_diceCounts[key] != 0)
        if (_currentDice == "")
          _currentDice += "${_diceCounts[key]}d$key";
        else
          _currentDice += "+${_diceCounts[key]}d$key";
      for (int i=0; i<_diceCounts[key]; i++) {
        _diceDisplays.add(DiceDisplay(sides: key, index: count));
        _allRolls.add(_diceDisplays[_diceDisplays.length-1].getRoll);
        _totalRolls += _diceDisplays[_diceDisplays.length-1].getRoll;
        count++;
      }
    }

    if (_mod > 0)
      _currentDice += "+$_mod";
    else if (_mod < 0)
      _currentDice += "-$_mod";

    if (_mod != 0)
      _totalRollsString = _totalRolls.toString() + "+" + _mod.toString() +
          "=" + (_totalRolls+_mod).toString();
    else
      _totalRollsString = _totalRolls.toString();
    _totalRolls += _mod;

    setRows();

    _allInfoTime.add(Tuple5("Roll", _currentDice, _totalRollsString, _totalRolls.toString(), new List<Expanded>.from(_rows)));
    _allInfo.add(Tuple5("Roll", _currentDice, _totalRollsString, _totalRolls.toString(), new List<Expanded>.from(_rows)));

    notifyListeners();
  }

  void clear() {
    _currentDie = "";
    _currentDice = "";
    _totalRolls = _mod;
    _allRolls.clear();
    for (var key in _diceCounts.keys) { _diceCounts[key] = 0; }
    _diceDisplays.clear();
    _rows.clear();
    _diceButtonsDisplay.clear();
    notifyListeners();
  }

  void clearAll() {
    _totalRolls = 0;
    _mod = 0;
    _totalRollsString = "";
    clear();
  }

  void setHistoryInfo(Tuple5<String, String, String, String, List<Expanded>> info) {
    _historyInfo = Tuple3(info.item1, info.item3.toString(), info.item5);
    notifyListeners();
  }

  void clearAllInfo() {
    _allInfo.clear();
    _allInfoTime.clear();
    _historyInfo = Tuple3("", "", List<Expanded>());
    notifyListeners();
  }

  void sortBy(String method, {bool shouldUpdate: true}) {
    _sortBy = method;
    sort(_sortSelection, shouldUpdate: shouldUpdate);
  }

  void sort(String method, {bool shouldUpdate: true}) {
    _sortSelection = method;
    if (method == "Time") {
      _allInfo = new List<Tuple5<String, String, String, String, List<Expanded>>>.from(_allInfoTime);
    }
    if (method == "Roll") {
      _allInfo.sort((a, b) => a.item2.length.compareTo(b.item2.length));
    }
    if (method == "Result") {
      _allInfo.sort((a, b) => int.parse(a.item4).compareTo(int.parse(b.item4)));
    }

    if (_sortBy == "Descending")
      _allInfo = _allInfo.reversed.toList();

    if (shouldUpdate) notifyListeners();
  }

  void getMuteFile() async {
    var prefs = await SharedPreferences.getInstance();
    _mute = prefs.getBool('Mute') ?? false;
    notifyListeners();
  }

  void playDiceSounds() async {
    for (var player in audioPlayers) {
      await player.stop();
    }
    audioPlayers.clear();
    int count = 0;
    if (!_mute) {
      for (int key in _diceCounts.keys) {
        if ([4, 6, 8, 10, 12, 20, 100].contains(key)) {
          if (_diceCounts[key] == 1) {
            audioPlayers.add(await _diceButtons[count].playSound());
          }
          else if (_diceCounts[key] > 1) {
            audioPlayers.add(await _diceButtons[count].playMultiple());
          }
        }
        else {
          if (_diceCounts[key] == 1) {
            audioPlayers.add(await DiceButton(isCustom: true).playSound());
          }
          else if (_diceCounts[key] > 1) {
            audioPlayers.add(await DiceButton(isCustom: true).playMultiple());
          }
        }
        count++;
      }
    }
  }

  int get getCurrentRoll => _totalRolls;
  Map<int, int> get getDiceCounts => _diceCounts;
  List<DiceDisplay> get getDiceDisplays => _diceDisplays;
  List<DiceButton> get getDiceButtons => _diceButtons;
  List<Expanded> get getRows => _rows;
  int get getMod => _mod;
  int get getTotalRolls => _totalRolls;
  bool get getMute => _mute;
  int get getCustom => _custom;
  String get currentDice => _currentDice;
  List<DiceButtonDisplay> get diceButtonsDisplay => _diceButtonsDisplay;
  List<Tuple5<String, String, String, String, List<Expanded>>> get allInfo => _allInfo;
  List<Tuple5<String, String, String, String, List<Expanded>>> get allInfoTime => _allInfoTime;
  Tuple3<String, String, List<Expanded>> get historyInfo => _historyInfo;
  String get sortSelection => _sortSelection;
  String get ascendingDescending => _sortBy;
  String get totalRollsString => _totalRollsString;
}