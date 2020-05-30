import 'dart:math';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CharacterCreation extends ChangeNotifier {
  final rng = new Random();

  bool _didRoll = false;
  String _currentRace = "";

  var _info = List<Text>();

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

  Map<String, dynamic> _abilityBonuses = {
    "STR": 0,
    "DEX": 0,
    "CON": 0,
    "INT": 0,
    "WIS": 0,
    "CHA": 0,
  };

  Map<String, dynamic> _races = {
  "Dragonborn": ["https://www.dnd5eapi.co/api/races/dragonborn", "https://media-waterdeep.cursecdn.com/avatars/thumbnails/6/340/420/618/636272677995471928.png", false],
  "Dwarf": ["https://www.dnd5eapi.co/api/races/dwarf", "https://media-waterdeep.cursecdn.com/avatars/thumbnails/6/254/420/618/636271781394265550.png", false],
  "Elf": ["https://www.dnd5eapi.co/api/races/elf", "https://media-waterdeep.cursecdn.com/avatars/thumbnails/7/639/420/618/636287075350739045.png", false],
  "Gnome": ["https://www.dnd5eapi.co/api/races/gnome", "https://media-waterdeep.cursecdn.com/avatars/thumbnails/6/334/420/618/636272671553055253.png", false],
  "Half-Elf": ["https://www.dnd5eapi.co/api/races/half-elf", "https://media-waterdeep.cursecdn.com/avatars/thumbnails/6/481/420/618/636274618102950794.png", false],
  "Halfling": ["https://www.dnd5eapi.co/api/races/halfling", "https://media-waterdeep.cursecdn.com/avatars/thumbnails/6/256/420/618/636271789409776659.png", false],
  "Half-Orc": ["https://www.dnd5eapi.co/api/races/half-orc", "https://media-waterdeep.cursecdn.com/avatars/thumbnails/6/466/420/618/636274570630462055.png", false],
  "Human": ["https://www.dnd5eapi.co/api/races/human", "https://media-waterdeep.cursecdn.com/avatars/thumbnails/6/258/420/618/636271801914013762.png", false],
  "Tiefling": ["https://www.dnd5eapi.co/api/races/tiefling", "https://media-waterdeep.cursecdn.com/avatars/thumbnails/7/641/420/618/636287076637981942.png", false],
  "Custom": ["", "https://png2.cleanpng.com/sh/e46fbec8bdeefdab7cda8fe5a5c4b84c/L0KzQYq3UsA6N6V8hJH0aYP2gLBuTgF2baR5gdH3LX3kgry0gB9ueKZ5feQ2aXPyfsS0kP9zfJJnhNc2bnX3h7F5i71oepJ1RdpubICwg8fuTgBvb15ue9H3LXb1dba0hP94dp10edY2MkG2RX65Tf9vdJpzfZ8AY0XocoO8UBRjQGc3SJC9Mka5QYm4WME2PGo8SKsEMEe7SYq5TwBvbz==/kisspng-question-mark-computer-icons-portable-network-grap-help-svg-png-icon-free-download-2135-2-online-5c5eb253db8620.4266181815497099078992.png", false],
  };

  Map<String, dynamic> _startingProficiencies = Map<String, dynamic>();
  Map<String, dynamic> _traits = Map<String, dynamic>();
  Map<String, dynamic> _languages = Map<String, dynamic>();
  Map<String, dynamic> _descriptors = Map<String, dynamic>();

  void setRace(String race) {
    for (var raceTemp in _races.keys) {
      _races[raceTemp][2] = false;
    }
    _races[race][2] = true;
    _currentRace = race;
    notifyListeners();
  }

  void confirmRace() async {

    clearRace();

    String url = _races[_currentRace][0];
    print(url);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      String jsonString = response.body;
      var data = json.decode(jsonString);
      for (var bonus in data['ability_bonuses']) {
        _abilityBonuses[bonus['name']] += bonus['bonus'];
      }
      for (var proficiency in data['starting_proficiencies']) {
        _startingProficiencies[proficiency['name']] = "https://www.dnd5eapi.co" + proficiency['url'];
      }
      for (var trait in data['traits']) {
        _traits[trait['name']] = "https://www.dnd5eapi.co" + trait['url'];
      }
      for (var language in data['languages']) {
        _languages[language['name']] = "https://www.dnd5eapi.co" + language['url'];
      }
      _descriptors['size'] = data['size'];
      _descriptors['speed'] = data['speed'];
      _descriptors['vision'] = data['vision'];

      _info.add(Text(
        "Name, " + _currentRace
      ));

      String ability = "Ability Score Increase: ";
      for (var score in _abilityBonuses.keys) {
        if (_abilityBonuses[score] != 0) {
          ability += score + " +" + _abilityBonuses[score].toString() + " ";
        }
      }
      _info.add(Text(ability));

      _info.add(Text("Size: " + _descriptors['size']));
      _info.add(Text("Speed: " + _descriptors['speed'].toString()));

      String languages = "Languages: ";
      for (var language in _languages.keys) {
        languages += language + ", ";
      }
      _info.add(Text(languages.substring(0, languages.length-2)));

      String traits = "Traits: ";
      for (var trait in _traits.keys) {
        traits += trait + ", ";
      }
      if (traits != "Traits: ")
        _info.add(Text(traits.substring(0, traits.length-2)));
    }
    else {
      print("Can't connect");
    }
    notifyListeners();
  }

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

    for (var race in _races.keys) {
      _races[race][2] = false;
    }

    for (var bonus in _abilityBonuses.keys) {
      _abilityBonuses[bonus] = 0;
    }

    _descriptors.clear();
    _traits.clear();
    _languages.clear();
    _startingProficiencies.clear();
    _currentRace = "";
    _info.clear();
    notifyListeners();
  }

  void clearRace() {
    for (var bonus in _abilityBonuses.keys) {
      _abilityBonuses[bonus] = 0;
    }

    _descriptors.clear();
    _traits.clear();
    _languages.clear();
    _startingProficiencies.clear();
    _info.clear();
    notifyListeners();
  }

  Map<String, dynamic> get statsDict => _statsDict;
  Map<String, dynamic> get races => _races;
  bool get didRoll => _didRoll;
  String get currentRace => _currentRace;

  Map<String, dynamic> get abilityBonuses => _abilityBonuses;
  Map<String, dynamic> get descriptors => _descriptors;
  Map<String, dynamic> get traits => _traits;
  Map<String, dynamic> get languages => _languages;
  Map<String, dynamic> get startingProficiencies => _startingProficiencies;

  List<Text> get info => _info;
}