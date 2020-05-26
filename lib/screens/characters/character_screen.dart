import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';

import '../../global_variables.dart';

class CharacterScreen extends StatefulWidget {
  CharacterScreen({Key key}) : super(key: key);

  @override
  _CharacterScreenState createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  var _cards = new List<Card>();

  void getCards(BuildContext context) {
    _cards.clear();
    _cards.add(Card(
      color: ThemeData.dark().cardColor.withAlpha(200),
      child: InkWell(
        child: Container(
          height: 70,
          width: 70,
          child: Icon(Icons.add)
        ),
        onTap: () {
          Navigator.pushNamed(context, '/character_creation');
        }
      )
    ));
  }

  @override
  void didChangeDependencies() {
    getCards(context);
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    final globalVariables = Provider.of<GlobalVariables>(context);

    void _onReorder(int oldIndex, int newIndex) {
      setState(() {
        Card row = _cards.removeAt(oldIndex);
        _cards.insert(newIndex, row);
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text("Characters")),
        drawer: new Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                  height: 125,
                ),
                Container(
                    child: ListTile(
                        title: Text("Dice Roller"),
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/dice');
                        },
                        trailing: globalVariables.isAndroid ? Icon(Icons.arrow_forward) :
                        Icon(Icons.arrow_forward_ios)
                    )
                ),
                Container(color: Theme.of(context).accentColor, child: ListTile(
                    title: Text("Character"),
                    onTap: () {
                      // you're already on this page!
                    },
                )),
                ListTile(
                    title: Text("DM Tools"),
                    onTap: () {
                      // TODO: go to DM tools screen (PushReplacementNamed)
                    },
                    trailing: globalVariables.isAndroid ? Icon(Icons.arrow_forward) :
                    Icon(Icons.arrow_forward_ios)
                )

              ],
            )
        ),
      body: ReorderableWrap(
        spacing: 8.0,
        runSpacing: 4.0,
        alignment: WrapAlignment.center,
        padding: const EdgeInsets.all(8),
        children: _cards,
        onReorder: _onReorder,
      )
    );
  }
}