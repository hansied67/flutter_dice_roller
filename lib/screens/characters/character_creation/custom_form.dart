import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterdiceroller/screens/characters/character_creation/stat_choice.dart';
import 'package:flutterdiceroller/screens/characters/character_creation/stat_roll_display.dart';
import 'package:provider/provider.dart';

import 'character_creation.dart';

class CustomForm extends StatefulWidget {
  CustomForm({Key key, this.controller}) : super(key: key);

  final formKey = GlobalKey<FormState>();

  bool _isSelected = false;
  final controller;

  void setSelected(bool selection) {
    _isSelected = selection;
  }

  bool get isSelected => _isSelected;
  GlobalKey<FormState> get getController => formKey;

  @override
  _CustomFormState createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {

  final _name = TextEditingController();
  final _class = TextEditingController();

  final _controllers = [TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController()];

  final _nodes = [FocusNode(), FocusNode(), FocusNode(), FocusNode(), FocusNode()];

  List<Widget> _stats = new List<Widget>();
  List<Widget> _statsChoice = new List<Widget>();
  String _statChoice = "Roll New Stats";

  void getStats(BuildContext context, var characterCreation) {
    _stats.clear();
    _statsChoice.clear();
    for (var stat in characterCreation.statsDict.keys) {
      _stats.add(StatRollDisplay(key: ValueKey(stat), stat: stat));
      _statsChoice.add(StatChoice(stat: stat, parent: widget));
    }
  }

  @override void didChangeDependencies() {
    final characterCreation = Provider.of<CharacterCreation>(context);
    getStats(context, characterCreation);
    super.didChangeDependencies();
  }

  @override void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _class.dispose();

    for (var controller in _controllers) {
      controller.dispose();
    }

    for (var node in _nodes) {
      node.dispose();
    }

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final characterCreation = Provider.of<CharacterCreation>(context);

    return SingleChildScrollView(child: Padding(padding: const EdgeInsets.all(8.0), child: Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RadioListTile(
            title: Text("Roll New Stats"),
            value: "Roll New Stats",
            groupValue: _statChoice,
            onChanged: (value) {
              _statChoice = value;
              characterCreation.setPage(2, false);
              final selections = new Map.from(characterCreation.statSelection).values.toList().toSet();
              selections.removeWhere((item) => item == -1);
              if (selections.length == characterCreation.statSelection.length) {
                characterCreation.setPage(2, true);
              }
            }
          ),
          RadioListTile(
            title: Text("Manual Stats Entry"),
            value: "Manual Stats Entry",
            groupValue: _statChoice,
            onChanged: (value) {
              this.setState(() {
                _statChoice = value;
                characterCreation.setPage(2, true);
              });
            }
          ),
          _statChoice == "Roll New Stats" ? Column(
            children: _stats + _statsChoice + [Container(height: 75)]
          )
            : Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Expanded(flex: 3, child: Text("Strength")),
                  Expanded(flex: 1, child: Container(
                    height: 40,
                    child: TextFormField(
                      controller: _controllers[0],
                      autofocus: true,
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.number,
                      inputFormatters: [LengthLimitingTextInputFormatter(2)],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        var num = int.tryParse(value);
                        if (value.isEmpty) {
                          return "NA";
                        }
                        if (num == null) {
                          return "NA";
                        }
                        else if(num > 18) {
                          return "<=18";
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) {
                        _nodes[0].requestFocus();
                      },
                    )
                  )),
                ]
              ),
              Row(
                  children: [
                    Expanded(flex: 3, child: Text("Dexterity")),
                    Expanded(flex: 1, child: Container(
                        height: 40,
                        child: TextFormField(
                          controller: _controllers[1],
                          focusNode: _nodes[0],
                          autofocus: true,
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          inputFormatters: [LengthLimitingTextInputFormatter(2)],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            var num = int.tryParse(value);
                            if (value.isEmpty) {
                              return "NA";
                            }
                            if (num == null) {
                              return "NA";
                            }
                            else if(num > 18) {
                              return "<=18";
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            _nodes[1].requestFocus();
                          },
                        )
                    )),
                  ]
              ),
              Row(
                  children: [
                    Expanded(flex: 3, child: Text("Constitution")),
                    Expanded(flex: 1, child: Container(
                        height: 40,
                        child: TextFormField(
                          controller: _controllers[2],
                          focusNode: _nodes[1],
                          autofocus: true,
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          inputFormatters: [LengthLimitingTextInputFormatter(2)],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            var num = int.tryParse(value);
                            if (value.isEmpty) {
                              return "NA";
                            }
                            if (num == null) {
                              return "NA";
                            }
                            else if(num > 18) {
                              return "<=18";
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            _nodes[2].requestFocus();
                          },
                        )
                    )),
                  ]
              ),
              Row(
                  children: [
                    Expanded(flex: 3, child: Text("Intelligence")),
                    Expanded(flex: 1, child: Container(
                        height: 40,
                        child: TextFormField(
                          controller: _controllers[3],
                          focusNode: _nodes[2],
                          autofocus: true,
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          inputFormatters: [LengthLimitingTextInputFormatter(2)],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            var num = int.tryParse(value);
                            if (value.isEmpty) {
                              return "NA";
                            }
                            if (num == null) {
                              return "NA";
                            }
                            else if(num > 18) {
                              return "<=18";
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            _nodes[3].requestFocus();
                          },
                        )
                    )),
                  ]
              ),
              Row(
                  children: [
                    Expanded(flex: 3, child: Text("Wisdom")),
                    Expanded(flex: 1, child: Container(
                        height: 40,
                        child: TextFormField(
                          controller: _controllers[4],
                          focusNode: _nodes[3],
                          autofocus: true,
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          inputFormatters: [LengthLimitingTextInputFormatter(2)],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            var num = int.tryParse(value);
                            if (value.isEmpty) {
                              return "NA";
                            }
                            if (num == null) {
                              return "NA";
                            }
                            else if(num > 18) {
                              return "<=18";
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            _nodes[4].requestFocus();
                          },
                        )
                    )),
                  ]
              ),
              Row(
                  children: [
                    Expanded(flex: 3, child: Text("Charisma")),
                    Expanded(flex: 1, child: Container(
                        height: 40,
                        child: TextFormField(
                          controller: _controllers[5],
                          focusNode: _nodes[4],
                          autofocus: true,
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          inputFormatters: [LengthLimitingTextInputFormatter(2)],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            var num = int.tryParse(value);
                            if (value.isEmpty) {
                              return "NA";
                            }
                            if (num == null) {
                              return "NA";
                            }
                            else if(num > 18) {
                              return "<=18";
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            if (widget.formKey.currentState.validate()) {
                              var temp = [0, 0, 0, 0, 0, 0];
                              for (int i=0; i<_controllers.length; i++) {
                                temp[i] = int.parse(_controllers[i].text);
                              }
                              print(temp);
                            }
                          },
                        )
                    )),
                  ]
              ),
            ]
          )
        ]
      )
    )));
  }
}