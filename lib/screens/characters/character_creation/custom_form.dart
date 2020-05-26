import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterdiceroller/screens/characters/character_creation/stat_roll_display.dart';
import 'package:provider/provider.dart';

import 'character_creation.dart';

class CustomForm extends StatefulWidget {
  CustomForm({Key key}) : super(key: key);

  @override
  _CustomFormState createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {

  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _class = TextEditingController();

  final _controllers = [TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController()];

  final _nodes = [FocusNode(), FocusNode(), FocusNode(), FocusNode(), FocusNode()];

  List<Widget> _stats = new List<Widget>();
  String _statChoice = "Roll New Stats";
  bool didRoll;

  void getStats(BuildContext context, var characterCreation) {
    _stats.clear();
    for (var stat in characterCreation.statsDict.keys) {
      _stats.add(StatRollDisplay(stat: stat));
    }
  if (!characterCreation.didRoll)
      _stats.add(Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlatButton(color: Theme.of(context).buttonColor,
              child: Text("Roll"),
              onPressed: () {
                for (var stat in _stats) {
                  if (stat is StatRollDisplay)
                    characterCreation.roll();
                }
              }
          )
        ]
    ));
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
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: TextFormField(
                  textAlign: TextAlign.center,
                  maxLength: 50,
                  controller: _name,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "You must input a name.";
                    }
                    return null;
                  },
                  onFieldSubmitted: (text) {
                    if (_formKey.currentState.validate()) {
                      print("name");
                    }
                  }
                )
              ),
              Flexible(
                child: TextFormField(
                  textAlign: TextAlign.center,
                  maxLength: 30,
                  controller: _class,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: 'Class',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "You must input a class.";
                    }
                    return null;
                  },
                  onFieldSubmitted: (text) {
                    if (_formKey.currentState.validate()) {
                      print("class");
                    }
                  }
                )
              )
            ]
          ),
          RadioListTile(
            title: Text("Roll New Stats"),
            value: "Roll New Stats",
            groupValue: _statChoice,
            onChanged: (value) {
              setState(() {
                _statChoice = value;
              });
            }
          ),
          RadioListTile(
            title: Text("Manual Stats Entry"),
            value: "ManualStats Entry",
            groupValue: _statChoice,
            onChanged: (value) {
              setState(() {
                _statChoice = value;
              });
            }
          ),
          _statChoice == "Roll New Stats" ? Column(
            children: _stats
          ) : Column(
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
                  Expanded(flex: 2, child: Container()),
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
                    Expanded(flex: 2, child: Container()),
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
                    Expanded(flex: 2, child: Container()),
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
                    Expanded(flex: 2, child: Container()),
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
                    Expanded(flex: 2, child: Container()),
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
                            if (_formKey.currentState.validate()) {
                              var temp = [0, 0, 0, 0, 0, 0];
                              for (int i=0; i<_controllers.length; i++) {
                                temp[i] = int.parse(_controllers[i].text);
                              }
                              print(temp);
                            }
                          },
                        )
                    )),
                    Expanded(flex: 2, child: Container()),
                  ]
              ),
            ]
          )
        ]
      )
    );
  }
}