import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'character_creation.dart';

class StatChoice extends StatefulWidget {
  StatChoice({Key key, this.stat, this.parent}) : super(key: key);

  final String stat;
  final parent;
  int _choice = 0;

  int get choice => _choice;

  @override
  _StatChoiceState createState() => _StatChoiceState();
}

class _StatChoiceState extends State<StatChoice> {

  var _buttons = new List<Widget>();
  var isSelected = [false, false, false, false, false, false];
  var selectionIndex = -1;

  @override void didChangeDependencies() {
    _buttons.clear();
    final characterCreation = Provider.of<CharacterCreation>(context);
    for (var roll in characterCreation.stats) {
      _buttons.add(Text(roll.toString()));
    }
    super.didChangeDependencies();
  }

  @override void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final characterCreation = Provider.of<CharacterCreation>(context);

    if (characterCreation.statSelection[widget.stat] != -1) {
      isSelected[characterCreation.statSelection[widget.stat]] = true;
      selectionIndex = characterCreation.statSelection[widget.stat];
    }

    var isDupe = false;
    for (var stat in characterCreation.statSelection.keys) {
      if (characterCreation.statSelection[stat] == selectionIndex && stat != widget.stat)
        isDupe = true;
    }

    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            children: [
                Text(widget.stat.toString()),
                ToggleButtons(
                    children: _buttons,
                    isSelected: isSelected,
                    selectedColor: isDupe ? Colors.red : Theme.of(context).buttonColor,
                    onPressed: (int index) {
                      setState(() {
                        if (isSelected[index] == false) {
                          for (int i = 0; i < isSelected.length; i++) {
                            isSelected[i] = false;
                          }
                          isSelected[index] = true;
                          characterCreation.selectStat(widget.stat, index);
                        }
                        else {
                          isSelected[index] = false;
                          characterCreation.resetStat(widget.stat, index);
                        }
                        selectionIndex = index;
                        widget._choice = index;
                      });

                      final selections = new Map.from(characterCreation.statSelection).values.toList().toSet();
                      selections.removeWhere((item) => item == -1);
                      if (selections.length == characterCreation.statSelection.length) {
                        setState(() {
                          characterCreation.setPage(2, true);
                        });
                      }
                      else {
                        setState(() {
                          characterCreation.setPage(2, false);
                        });
                      }
                    },
                )
            ]
        )
    );
  }
}