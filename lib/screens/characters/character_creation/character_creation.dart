import 'dart:math';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CharacterCreation extends ChangeNotifier {
  final rng = new Random();

  bool _didRoll = false;
  String _currentRace = "";
  String _currentClass = "";
  int _hitDie = 0;

  var _raceInfo = List<Widget>();
  var _classInfo = List<Widget>();

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

  Map<String, dynamic> _classes = {
    "Barbarian": ["https://www.dnd5eapi.co/api/classes/barbarian", "https://www.aidedd.org/dnd-builder/images/class_barbare.png", false],
    "Bard": ["https://www.dnd5eapi.co/api/classes/bard", "https://www.aidedd.org/dnd-builder/images/class_barde.png", false],
    "Cleric": ["https://www.dnd5eapi.co/api/classes/cleric", "https://www.aidedd.org/dnd-builder/images/class_pretre.png", false],
    "Druid": ["https://www.dnd5eapi.co/api/classes/druid", "https://www.aidedd.org/dnd-builder/images/class_druide.png", false],
    "Fighter": ["https://www.dnd5eapi.co/api/classes/fighter", "https://www.aidedd.org/dnd-builder/images/class_guerrier.png", false],
    "Monk": ["https://www.dnd5eapi.co/api/classes/monk", "https://www.aidedd.org/dnd-builder/images/class_moine.png", false],
    "Paladin": ["https://www.dnd5eapi.co/api/classes/paladin", "https://www.aidedd.org/dnd-builder/images/class_paladin.png", false],
    "Ranger": ["https://www.dnd5eapi.co/api/classes/ranger", "https://www.aidedd.org/dnd-builder/images/class_rodeur.png", false],
    "Rogue": ["https://www.dnd5eapi.co/api/classes/rogue", "https://www.aidedd.org/dnd-builder/images/class_roublard.png", false],
    "Sorcerer": ["https://www.dnd5eapi.co/api/classes/sorcerer", "https://www.aidedd.org/dnd-builder/images/class_ensorceleur.png", false],
    "Warlock": ["https://www.dnd5eapi.co/api/classes/warlock", "https://www.aidedd.org/dnd-builder/images/class_sorcier.png", false],
    "Wizard": ["https://www.dnd5eapi.co/api/classes/wizard", "https://www.aidedd.org/dnd-builder/images/class_magicien.png", false],
    "Custom": ["", "https://png2.cleanpng.com/sh/e46fbec8bdeefdab7cda8fe5a5c4b84c/L0KzQYq3UsA6N6V8hJH0aYP2gLBuTgF2baR5gdH3LX3kgry0gB9ueKZ5feQ2aXPyfsS0kP9zfJJnhNc2bnX3h7F5i71oepJ1RdpubICwg8fuTgBvb15ue9H3LXb1dba0hP94dp10edY2MkG2RX65Tf9vdJpzfZ8AY0XocoO8UBRjQGc3SJC9Mka5QYm4WME2PGo8SKsEMEe7SYq5TwBvbz==/kisspng-question-mark-computer-icons-portable-network-grap-help-svg-png-icon-free-download-2135-2-online-5c5eb253db8620.4266181815497099078992.png", false],
  };

  Map<String, dynamic> _startingProficiencies = Map<String, dynamic>();
  Map<String, dynamic> _traits = Map<String, dynamic>();
  Map<String, dynamic> _languages = Map<String, dynamic>();
  Map<String, dynamic> _descriptors = Map<String, dynamic>();
  Map<String, dynamic> _proficiencies = Map<String, dynamic>();
  int _toolsCount = 0;
  Map<String, dynamic> _tools = Map<String, dynamic>();
  Map<String, dynamic> _savingThrows = Map<String, dynamic>();
  int _skillsCount = 0;
  Map<String, dynamic> _skills = Map<String, dynamic>();

  void setRace(String race) {
    for (var raceTemp in _races.keys) {
      _races[raceTemp][2] = false;
    }
    _races[race][2] = true;
    _currentRace = race;
    notifyListeners();
  }

  void confirmRace(var globalVariables) async {

    clearRace();

    String url = _races[_currentRace][0];
    print(url);
    var response;
    if (_currentRace != "Custom")
      response = await http.get(url);
    else
      response = await http.get('https://www.google.com');
    if (response.statusCode == 200 && _currentRace != "Custom") {
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

      _raceInfo.add(RichText(
        text: new TextSpan(
          children: <TextSpan> [
            new TextSpan(text: (_currentRace), style: new TextStyle(
                fontSize: globalVariables.isMobile ? 15.0 : 25.0,
                color: Colors.cyan, fontWeight: FontWeight.bold
            )),
            ]
        )
      ));

      String ability = "";
      for (var score in _abilityBonuses.keys) {
        if (_abilityBonuses[score] != 0) {
          ability += score + " +" + _abilityBonuses[score].toString() + " ";
        }
      }
      _raceInfo.add(AutoSizeText.rich(
          new TextSpan(
              children: <TextSpan> [
                new TextSpan(text: "Ability Score Increase: ", style: new TextStyle(
                    fontSize: globalVariables.isMobile ? 15.0 : 25.0,
                    color: Colors.cyan, fontWeight: FontWeight.bold
                )),
                new TextSpan(text: ability, style: new TextStyle(
                    fontSize: globalVariables.isMobile ? 15.0 : 25.0,
                    color: Colors.white
                )),
              ]
          )
      ));

      _raceInfo.add(AutoSizeText.rich(
          new TextSpan(
              children: <TextSpan> [
                new TextSpan(text: "Size: ", style: new TextStyle(
                    fontSize: globalVariables.isMobile ? 15.0 : 25.0,
                    color: Colors.cyan, fontWeight: FontWeight.bold
                )),
                new TextSpan(text: _descriptors['size'], style: new TextStyle(
                    fontSize: globalVariables.isMobile ? 15.0 : 25.0,
                    color: Colors.white
                )),
              ]
          )
      ));
      _raceInfo.add(AutoSizeText.rich(
          new TextSpan(
              children: <TextSpan> [
                new TextSpan(text: "Speed: ", style: new TextStyle(
                    fontSize: globalVariables.isMobile ? 15.0 : 25.0,
                    color: Colors.cyan, fontWeight: FontWeight.bold
                )),
                new TextSpan(text: _descriptors['speed'].toString(), style: new TextStyle(
                    fontSize: globalVariables.isMobile ? 15.0 : 25.0,
                    color: Colors.white
                )),
              ]
          )
      ));

      String languages = "";
      for (var language in _languages.keys) {
        languages += language + ", ";
      }
      _raceInfo.add(AutoSizeText.rich(
          new TextSpan(
              children: <TextSpan> [
                new TextSpan(text: "Languages: ", style: new TextStyle(
                    fontSize: globalVariables.isMobile ? 15.0 : 25.0,
                    color: Colors.cyan, fontWeight: FontWeight.bold
                )),
                _currentRace != "Human" ?
                  new TextSpan(text: languages.substring(0, languages.length-2), style: new TextStyle(
                      fontSize: globalVariables.isMobile ? 15.0 : 25.0,
                      color: Colors.white
                  )):
                  new TextSpan(text: "Common and one language of choice", style: new TextStyle(
                      fontSize: globalVariables.isMobile ? 15.0 : 25.0,
                      color: Colors.white
                  )),
              ]
          )
      ));

      String traits = "";
      for (var trait in _traits.keys) {
        traits += trait + ", ";
      }
      if (traits != "")
        _raceInfo.add(AutoSizeText.rich(
            new TextSpan(
                children: <TextSpan> [
                  new TextSpan(text: "Traits: ", style: new TextStyle(
                      fontSize: globalVariables.isMobile ? 15.0 : 25.0,
                      color: Colors.cyan, fontWeight: FontWeight.bold
                  )),
                  new TextSpan(text: traits.substring(0, traits.length-2), style: new TextStyle(
                      fontSize: globalVariables.isMobile ? 15.0 : 25.0,
                      color: Colors.white
                  )),
                ]
            )
        ));
      else {
        _raceInfo.add(AutoSizeText.rich(
            new TextSpan(
                children: <TextSpan> [
                  new TextSpan(text: "Traits: ", style: new TextStyle(
                      fontSize: globalVariables.isMobile ? 15.0 : 25.0,
                      color: Colors.cyan, fontWeight: FontWeight.bold
                  )),
                  new TextSpan(text: "0", style: new TextStyle(
                      fontSize: globalVariables.isMobile ? 15.0 : 25.0,
                      color: Colors.white
                  )),
                ]
            )
        ));
      }

    }
    else {
      print("Can't connect");
    }
    notifyListeners();
  }

  void setClass(String _class, var globalVariables) async {

    clearClass();

    _currentClass = _class;
    _classes[_class][2] = true;

    var url = _classes[_currentClass][0];
    print(url);
    var response;
    if (_currentClass != "Custom")
      response = await http.get(url);
    else
      response = await http.get('https://www.google.com');
    if (response.statusCode == 200 && _currentClass != "Custom") {
      String jsonString = response.body;
      var data = json.decode(jsonString);
      _hitDie = data['hit_die'];

      for (var proficiency in data['proficiencies']) {
        _proficiencies[proficiency['name']] = "https://www.dnd5eapi.co" + proficiency['url'];
      }

      try {
        if (data['proficiency_choices'][1] != null) {
          _toolsCount = data['proficiency_choices'][1]['choose'];
          for (var tool in data['proficiency_choices'][1]['from']) {
            _tools[tool['name']] = "https://www.dnd5eapi.co" + tool['url'];
          }
        }
      } catch(e) {
      }

      for (var savingThrow in data['saving_throws']) {
        _savingThrows[savingThrow['name']] = "https://www.dnd5eapi.co" + savingThrow['url'];
      }

      for (var skillChoice in data['proficiency_choices'][0]['from']) {
        _skills[skillChoice['name']] = "https://www.dnd5eapi.co" + skillChoice['url'];
      }
      _skillsCount = data['proficiency_choices'][0]['choose'];

      _classInfo.add(AutoSizeText.rich(
          new TextSpan(
              children: <TextSpan> [
                new TextSpan(text:_currentClass, style: new TextStyle(
                    fontSize: globalVariables.isMobile ? 15.0 : 25.0,
                    color: Colors.cyan, fontWeight: FontWeight.bold
                ))
              ]
          )
      ));

      _classInfo.add(AutoSizeText.rich(
          new TextSpan(
              children: <TextSpan> [
                new TextSpan(text: "Hit Die: ", style: new TextStyle(
                    fontSize: globalVariables.isMobile ? 15.0 : 25.0,
                    color: Colors.cyan, fontWeight: FontWeight.bold
                )),
                new TextSpan(text: _hitDie.toString(), style: new TextStyle(
                    fontSize: globalVariables.isMobile ? 15.0 : 25.0,
                    color: Colors.white
                )),
              ]
          )
      ));

      String proficiencies = "";
      for (var proficiency in _proficiencies.keys) {
        proficiencies += proficiency + ", ";
      }
      _classInfo.add(AutoSizeText.rich(
          new TextSpan(
              children: <TextSpan> [
                new TextSpan(text: "Proficiencies: ", style: new TextStyle(
                    fontSize: globalVariables.isMobile ? 15.0 : 25.0,
                    color: Colors.cyan, fontWeight: FontWeight.bold
                )),
                new TextSpan(text: proficiencies.substring(0, proficiencies.length-2), style: new TextStyle(
                    fontSize: globalVariables.isMobile ? 15.0 : 25.0,
                    color: Colors.white
                )),
              ]
          )
      ));

      String tools = "";
      if (_tools.isNotEmpty) {
        tools += _toolsCount.toString() + " from ";
      }
      for (var tool in _tools.keys) {
        tools += tool + ", ";
      }
      _classInfo.add(AutoSizeText.rich(
          new TextSpan(
              children: <TextSpan> [
                new TextSpan(text: "Tools: ", style: new TextStyle(
                    fontSize: globalVariables.isMobile ? 15.0 : 25.0,
                    color: Colors.cyan, fontWeight: FontWeight.bold
                )),
                tools != "" ?
                  new TextSpan(text: tools.substring(0, tools.length-2), style: new TextStyle(
                      fontSize: globalVariables.isMobile ? 15.0 : 25.0,
                      color: Colors.white
                  )) :
                  new TextSpan(text: "0", style: new TextStyle(
                      fontSize: globalVariables.isMobile ? 15.0 : 25.0,
                      color: Colors.white
                  )),
              ]
          )
      ));

      String savingThrows = "";
      for (var savingThrow in _savingThrows.keys) {
        savingThrows += savingThrow + ", ";
      }
      _classInfo.add(AutoSizeText.rich(
          new TextSpan(
              children: <TextSpan> [
                new TextSpan(text: "Saving Throws: ", style: new TextStyle(
                    fontSize: globalVariables.isMobile ? 15.0 : 25.0,
                    color: Colors.cyan, fontWeight: FontWeight.bold
                )),
                new TextSpan(text: savingThrows.substring(0, savingThrows.length-2), style: new TextStyle(
                    fontSize: globalVariables.isMobile ? 15.0 : 25.0,
                    color: Colors.white
                )),
              ]
          )
      ));

      String skills = _skillsCount.toString() + " from ";
      for (var skill in _skills.keys) {
        if (skill.substring(0, 7) != "Skill: ")
          skills += skill + ", ";
        else
          skills += skill.substring(7, skill.length) + ", ";
      }
      _classInfo.add(AutoSizeText.rich(
          new TextSpan(
              children: <TextSpan> [
                new TextSpan(text: "Skills: ", style: new TextStyle(
                    fontSize: globalVariables.isMobile ? 15.0 : 25.0,
                    color: Colors.cyan, fontWeight: FontWeight.bold
                )),
                new TextSpan(text: skills.substring(0, skills.length-2), style: new TextStyle(
                    fontSize: globalVariables.isMobile ? 15.0 : 25.0,
                    color: Colors.white
                )),
              ]
          )
      ));
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

    for (var _class in _classes.keys) {
      _classes[_class][2] = false;
    }

    for (var bonus in _abilityBonuses.keys) {
      _abilityBonuses[bonus] = 0;
    }

    _descriptors.clear();
    _traits.clear();
    _languages.clear();
    _startingProficiencies.clear();
    _currentRace = "";
    _currentClass = "";
    _raceInfo.clear();

    for (var _classTemp in _classes.keys) {
      _classes[_classTemp][2] = false;
    }
    _classInfo.clear();
    _proficiencies.clear();
    _tools.clear();
    _toolsCount = 0;
    _savingThrows.clear();
    _skills.clear();
    _skillsCount = 0;
    _currentClass = "";
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
    _raceInfo.clear();
    notifyListeners();
  }

  void clearClass() {
    for (var _classTemp in _classes.keys) {
      _classes[_classTemp][2] = false;
    }
    _classInfo.clear();
    _proficiencies.clear();
    _tools.clear();
    _toolsCount = 0;
    _savingThrows.clear();
    _skills.clear();
    _skillsCount = 0;
    _currentClass = "";
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
  Map<String, dynamic> get classes => _classes;

  List<Widget> get raceInfo => _raceInfo;
  List<Widget> get classInfo => _classInfo;
}