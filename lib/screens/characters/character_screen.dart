import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';

import '../../global_variables.dart';
import 'character_creation/character_creation.dart';

class CharacterScreen extends StatefulWidget {
  CharacterScreen({Key key}) : super(key: key);

  @override
  _CharacterScreenState createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  var _cards = new List<Card>();

  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  void getCards(BuildContext context, var characterCreation) {
    _cards.clear();
    _cards.add(Card(
      color: ThemeData.dark().cardColor.withAlpha(200),
      child: InkWell(
        child: Container(
          height: 100,
          width: 100,
          child: Icon(Icons.add)
        ),
        onTap: () {
          showDialog(
            context: context,
            child: AlertDialog(
              title: const Text("Input Character Name"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        maxLength: 100,
                        controller: _controller,
                        autofocus: true,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(labelText: "Name"),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Value can't be empty";
                          }
                          return null;
                        },
                        onFieldSubmitted: (text) {
                          if (_formKey.currentState.validate()) {
                            characterCreation.setName(text);
                            characterCreation.roll();
                            Navigator.pushNamed(context, '/character_creation');
                          }
                        }
                      )
                    )
                  ]
                )
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      characterCreation.setName(_controller.text);
                      characterCreation.roll();
                      Navigator.pushNamed(context, '/character_creation');
                    }
                  }
                )
              ]
            )
          );
        }
      )
    ));
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
  void didChangeDependencies() {
    final characterCreation = Provider.of<CharacterCreation>(context);
    getCards(context, characterCreation);
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