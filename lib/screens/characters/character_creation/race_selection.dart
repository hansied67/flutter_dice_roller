import 'package:flutter/material.dart';
import 'package:flutterdiceroller/global_widgets/auto_text.dart';
import 'package:provider/provider.dart';

import '../../../global_variables.dart';
import 'character_creation.dart';

class RaceSelection extends StatefulWidget {
  RaceSelection({Key key,  this.controller}) {
    _isSelectedTotal = false;
  }

    final PageController controller;
    bool _isSelectedTotal;

    @override
    _RaceSelectionState createState() => _RaceSelectionState();

    bool get isSelected => _isSelectedTotal;
}

class _RaceSelectionState extends State<RaceSelection> {

  @override
  Widget build(BuildContext context) {
    final characterCreation = Provider.of<CharacterCreation>(context);
    final globalVariables = Provider.of<GlobalVariables>(context);
    return Column(
        children: [
          widget._isSelectedTotal ?
          Expanded(
            flex: 2,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    itemCount: characterCreation.raceInfo.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: globalVariables.isMobile ? const EdgeInsets.all(8.0) : const EdgeInsets.all(16.0),
                          child: characterCreation.raceInfo[index]
                      );
                    },
                )
            )
          ) : Container(),
          Expanded(flex: 2, child: GridView.builder(
          itemCount: characterCreation.races.length,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200.0,
          ),
          itemBuilder: (context, index) {
            return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                    color: !characterCreation.races.values.elementAt(index)[2] ? ThemeData.dark().cardColor : ThemeData.dark().buttonColor,
                    child: InkWell(
                        onTap: () {
                          characterCreation.setRace(characterCreation.races.keys.elementAt(index));
                          characterCreation.confirmRace(globalVariables);
                          setState(() {
                            widget._isSelectedTotal = true;
                          });
                        },
                        child: Stack(
                            children: [
                                Center(child: Image.network(characterCreation.races.values.elementAt(index)[1])),
                                Container(
                                  alignment: Alignment.topCenter,
                                  child: AutoText(characterCreation.races.keys.elementAt(index), 25.0, Colors.white, true),
                                ),
                            ]
                        )
                    )
                )
            );
          }
        ))]
    );
  }
}