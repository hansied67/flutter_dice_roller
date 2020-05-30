import 'package:flutter/material.dart';
import 'package:flutterdiceroller/screens/characters/character_creation/race_selection.dart';
import 'package:provider/provider.dart';

import '../../../global_variables.dart';
import 'custom_form.dart';
import 'character_creation.dart';

class CharacterCreationScreen extends StatefulWidget {
  CharacterCreationScreen({Key key}) : super(key: key);

  @override
  _CharacterCreationScreenState createState() =>
      _CharacterCreationScreenState();
}

class _CharacterCreationScreenState extends State<CharacterCreationScreen> {

  var _controller;
  var _pages;
  var _page = 0;

  @override void initState() {
    super.initState();
    _controller = PageController(initialPage: _page);
    _pages = [RaceSelection(controller: _controller), CustomForm(controller: _controller)];
  }

  @override void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final characterCreation = Provider.of<CharacterCreation>(context);
    return WillPopScope(
        onWillPop: () async {
          characterCreation.clear();
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text("Create a new Character"),
            ),
            body: PageView(
              controller: _controller,
              children: _pages
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                      heroTag: "previous",
                      backgroundColor: _page == 0 ? Colors.grey : Theme.of(context).floatingActionButtonTheme.backgroundColor,
                      onPressed: () {
                        if (_page != 0) {
                          setState(() {
                            _page -= 1;
                          });
                        }
                        _controller.animateToPage(
                          _page,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Icon(Icons.keyboard_arrow_left)
                  )
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                        heroTag: "next",
                        backgroundColor: _page == 1 ? Colors.grey : Theme.of(context).floatingActionButtonTheme.backgroundColor,
                        onPressed: () {
                          if (_page != 1) {
                            if (_page == 0 && _pages[_page].isSelected) {
                              //if (characterCreation.currentRace != "Custom")
                                //characterCreation.confirmRace();
                              setState(() {
                                _page += 1;
                              });
                            }
                          }
                          _controller.animateToPage(
                            _page,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Icon(Icons.keyboard_arrow_right)
                    )
                ),
              ]
            )
          )
    );
  }
}