import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutterdiceroller/screens/standard/standard_dice/dice_rolls.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'custom_rolls.dart';

class CustomCard extends StatefulWidget {
  CustomCard({Key key,  this.keyString, this.value, this.color}) : super(key: key);

  final String keyString;
  final dynamic value;
  final Color color;

  String get title => keyString;

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {

  bool _validate = false;
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  Future<String> _getInputDialogCustom(BuildContext context, var customRolls) async {
    return showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add a Custom Roll'),
            content: SingleChildScrollView(
              child: ListBody(
                  children: <Widget>[
                      Form(
                          key: _formKey,
                          child: TextFormField(
                              maxLength: 100,
                              controller: _controller,
                              autofocus: true,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(labelText: 'Name'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Value can't be empty";
                                }
                                return null;
                              },
                              onFieldSubmitted: (text) {
                                if (_formKey.currentState.validate()) {
                                  customRolls.setCurrentName(_controller.text);
                                  Navigator.of(context).pushReplacementNamed(
                                      '/dice_custom');
                                }
                              }
                          ),
                      )
                  ]
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text('Input Dice'),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      customRolls.setCurrentName(_controller.text);
                      Navigator.of(context).pushReplacementNamed(
                          '/dice_custom');
                    }
                  },
              )
            ],
          );
        }
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customRolls = Provider.of<CustomRolls>(context);
    final diceRolls = Provider.of<DiceRolls>(context);
      return widget.keyString != "null" ? Card(
          color: widget.color,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: customRolls.swap ? Colors.transparent : Colors.white,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(4.0)
          ),
          child: InkWell(
              // splashColor: Colors.deepPurple,
              onTap: () {
                if (customRolls.swap) {
                  customRolls.setCurrentName(widget.keyString);
                  customRolls.setCurrentRoll(widget.value.values.elementAt(0));
                  customRolls.doRoll(diceRolls.volume);
                  setState(() {
                    diceRolls.allInfoTime.add(Tuple5(
                        customRolls.currentName,
                        customRolls.currentRoll,
                        customRolls.currentResult,
                        customRolls.currentResultInt.toString(),
                        new List<Expanded>.from(customRolls.rows)));
                    diceRolls.allInfo.add(Tuple5(
                        customRolls.currentName,
                        customRolls.currentRoll,
                        customRolls.currentResult,
                        customRolls.currentResultInt.toString(),
                        new List<Expanded>.from(customRolls.rows)));
                  });
                }
                else {
                  showDialog(
                      context: context,
                      child: AlertDialog(
                        title: const Text ('Pick a color'),
                        content: SingleChildScrollView(
                            child: BlockPicker(
                              pickerColor: widget.color,
                              onColorChanged: (value) => customRolls.confirmColor(value, widget.keyString),
                            )
                        ),
                        actions: [
                          FlatButton(
                            child: const Text('Delete'),
                            onPressed: () {
                              customRolls.removeItem(widget.keyString);
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: const Text('Edit'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              var info = customRolls.getInfo(widget.value.values.elementAt(0));
                              diceRolls.setInfo(info);
                              customRolls.setInfo(widget.keyString, info);
                              Navigator.of(context).pushNamed('/dice_custom');
                            },
                          ),
                          FlatButton(
                              child: const Text('Ok'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              }
                          )
                        ],
                      )
                  );
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      height: 35,
                      width: 70,
                      alignment: Alignment.center,
                      child: AutoSizeText(
                          widget.keyString,
                          maxLines: 2,
                          minFontSize: 3.0,
                          textAlign: TextAlign.center,
                      )
                  ),
                  Container(
                      height: 35,
                      width: 70,
                      alignment: Alignment.center,
                      child: AutoSizeText(
                          widget.value.values.elementAt(0),
                          maxLines: 2,
                          minFontSize: 5.0,
                          textAlign: TextAlign.center,
                      )
                  )
                ],
              )
          )
        ) : Card(
        color: widget.color,
        child: InkWell(
            onTap: () => _getInputDialogCustom(context, customRolls),
            onLongPress: () => _getInputDialogCustom(context, customRolls),
            child: Container(
                height: 70,
                width: 70,
                child: Icon(Icons.add)
            )
        )
      );
  }
}