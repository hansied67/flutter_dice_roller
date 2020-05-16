import 'package:flutter/material.dart';
import 'package:flutterdiceroller/global_widgets/auto_text.dart';
import 'package:provider/provider.dart';

import 'dice_rolls.dart';

class ModBox extends StatefulWidget {
  Future<String> _getInputDialog(BuildContext context, var diceRolls) async {
    return showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Change the modifier'),
            content: new Row(
              children: <Widget>[
                new Expanded(
                    child: new TextField(
                      onSubmitted: Navigator.of(context).pop,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      decoration: new InputDecoration(
                          labelText: 'Modifier:', hintText: diceRolls.getMod.toString()),
                      onChanged: (value) {
                        try {
                          diceRolls.changeModText(int.parse(value));
                        } on Exception {
                          diceRolls.changeModText(0);
                        }
                      },
                    )
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text('Ok'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  }
              )
            ],
          );
        }
    );
  }

  @override
  _ModBoxState createState() => _ModBoxState();
}

class _ModBoxState extends State<ModBox> {
  @override
  Widget build(BuildContext context) {
    final diceRolls = Provider.of<DiceRolls>(context);
    return Stack(
      children: <Widget> [
        Padding(
          padding: new EdgeInsets.only(left: 15.0),
          child: Container(
            alignment: Alignment.centerLeft,
            child: Icon(Icons.remove, color: Colors.red)
          )
        ),
        Padding(
            padding: new EdgeInsets.only(right: 15.0),
          child: Container(
            alignment: Alignment.centerRight,
            child: Icon(Icons.add, color: Colors.green)
          )
        ),
        Padding(
          padding: new EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                  child: Container(
                    // color: Color(0x9b5bf6bff),
                      child: InkWell(
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(8.0),
                            bottomLeft: const Radius.circular(8.0)
                          ),
                          splashColor: Colors.red,
                          // behavior: HitTestBehavior.opaque,
                          onTap: () async {
                            diceRolls.changeMod(-1);
                          },
                          onLongPress: () async {
                            widget._getInputDialog(context, diceRolls);
                          },
                          // child: Icon(Icons.remove)
                      ),
                      decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(8.0),
                            bottomLeft: const Radius.circular(8.0),
                          ),
                          border: Border.all(
                            color: Colors.red,
                          )
                      )
                  )
              ),
              Expanded(
                  child: Container(
                    // color: Color(0x9b5bf6bff),
                      child: InkWell(
                        borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(8.0),
                          bottomLeft: const Radius.circular(8.0)
                        ),
                        splashColor: Colors.green,
                          onTap: () async {
                            diceRolls.changeMod(1);
                          },
                          onLongPress: () async {
                            widget._getInputDialog(context, diceRolls);
                          },
                          // child: Icon(Icons.add)
                      ),
                      decoration: new BoxDecoration(
                          // color: Color(0x9b5bf6bff),
                          borderRadius: new BorderRadius.only(
                            topRight: const Radius.circular(8.0),
                            bottomRight: const Radius.circular(8.0),
                          ),
                          border: Border.all(
                            color: Colors.green,
                          )
                      )
                  )
              ),
            ]
          )
        ),
        Center(
            child: GestureDetector(
              onTap: () async {
                widget._getInputDialog(context, diceRolls);
              },
              onLongPress: () async {
                widget._getInputDialog(context, diceRolls);
              },
              child: AutoText(diceRolls.getMod.toString(), 25.0, Colors.white, true)
            )
        ),
      ]
    );
  }
}