import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math';
import 'dart:io';

import 'dice_button.dart';
import 'dice_display.dart';

class DiceRolls extends ChangeNotifier {
  final _rowSize = 5;

  int _mod = 0;

  int _custom = 2;

  bool _mute = false;
  
  String _currentDie = "";
  String _currentDice = "";
  int _currentRoll = 0;
  int _totalRolls = 0;
  List<int> _allRolls = List<int>();
  Map<int, int> _diceCounts = {4: 0, 6: 0, 8: 0, 10: 0, 12: 0, 20: 0, 100: 0};

  List<DiceButton> _diceButtons = List<DiceButton>();

  List<DiceDisplay> _diceDisplays = List<DiceDisplay>();
  List<Expanded> _rows = List<Expanded>();  // rows of DiceDisplay

  var rng = new Random();

  DiceRolls() {
    setDiceButtons();
  }

  void setDiceButtons() async {
    changeCustom(await getCustomRoll());
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

  void changeMute() {
    _mute = !_mute;
    notifyListeners();
  }

  void changeMod(int change) {
    _mod += change;
    _totalRolls += change;
    notifyListeners();
  }

  void changeModText(int change) {
    _totalRolls -= _mod;
    _mod = change;
    _totalRolls += _mod;
    notifyListeners();
  }

  void changeCustom(int custom) {
    _diceCounts.remove(_diceCounts[_custom]);
    print(_diceCounts);
    _custom = custom;
    _diceCounts[_custom] = 0;
    notifyListeners();

  }

  void decDie(int sides, int index) {
    _diceCounts[sides]--;
    _totalRolls -= _diceDisplays.elementAt(index).getRoll;
    _diceDisplays.removeAt(index);
    for (int i=0; i<_diceDisplays.length; i++) {
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
    _diceCounts[button.getSides]++;

    _diceDisplays.add(
        DiceDisplay(sides: button.getSides, index: _diceDisplays.length));

    setRows();

    _allRolls.add(_diceDisplays[_diceDisplays.length - 1].getRoll);
    _totalRolls += _allRolls[_allRolls.length - 1];

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

    _totalRolls = 0;

    int count = 0;
    for (int key in _diceCounts.keys) {
      for (int i=0; i<_diceCounts[key]; i++) {
        _diceDisplays.add(DiceDisplay(sides: key, index: count));
        _allRolls.add(_diceDisplays[_diceDisplays.length-1].getRoll);
        _totalRolls += _diceDisplays[_diceDisplays.length-1].getRoll;
        count++;
      }
    }
    setRows();
    notifyListeners();
  }

  void clear() {
    _currentDie = "";
    _currentDice = "";
    _currentRoll = 0;
    _totalRolls = _mod;
    for (var key in _diceCounts.keys) { _diceCounts[key] = 0; }
    _diceDisplays.clear();
    _rows.clear();
    notifyListeners();
  }

  void clearAll() {
    _totalRolls = 0;
    _mod = 0;
    clear();
  }

  int get getCurrentRoll => _totalRolls;
  Map<int, int> get getDiceCounts => _diceCounts;
  List<DiceDisplay> get getDiceDisplays => _diceDisplays;
  List<DiceButton> get getDiceButtons => _diceButtons;
  List<Expanded> get getRows => _rows;
  int get getMod => _mod;
  int get getTotalRolls => _totalRolls;
  bool get getMute => _mute;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> _getLocalFile(String file) async {
    // get the path to the document directory.
    Directory directory = await getApplicationDocumentsDirectory();
    var varPath = join(directory.path, file);
    if (!await (File(varPath).exists())) {
      ByteData data = await rootBundle.load("assets/docs/$file");
      List<int> bytes = data.buffer.asUint8List(
          data.offsetInBytes, data.lengthInBytes);
      return await File(varPath).writeAsBytes(bytes);
    }
    else {
      return File(varPath);
    }
  }

  Future<int> getCustomRoll() async {
    final file = await _getLocalFile("custom_roll.txt");
    try {
      String contents = await file.readAsString();
      return int.parse(contents);
    } catch (e) {
      print(e);
      return 2;
    }
  }

  Future<File> writeCustomRoll(int custom) async {
    final file = await _getLocalFile("custom_roll.txt");
    try {

    } catch (e) {
      print(e);
    }
    return file.writeAsString('$custom');
  }


}