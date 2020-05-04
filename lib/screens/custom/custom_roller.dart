import 'package:flutter/material.dart';

class CustomRoller extends StatefulWidget {
  CustomRoller({Key key}) : super(key: key);

  @override
  _CustomRollerState createState() => _CustomRollerState();
}

class _CustomRollerState extends State<CustomRoller> {
  TextEditingController _controller = TextEditingController();

  final duplicateItems = List<String>.generate(20, (i) => "Item $i");
  var items = List<String>();

  @override
  void initState() {
    items.addAll(duplicateItems);
    super.initState();
  }

  void filterSearchResults(String query) {
    List<String> dummySearchList = List<String>();
    dummySearchList.addAll(duplicateItems);

    if (query.isNotEmpty) {
      List<String> dummyListData = List<String>();
      for (String item in dummySearchList) {
        if (item.contains(query)) {
          dummyListData.add(item);
        }
      }
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    }
    else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text("ass", style: TextStyle(fontSize: 25.0))
                  )
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                      child: Text("hole", style: TextStyle(fontSize: 25.0))
                  )
                )
              ],
            )
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                filterSearchResults(value);
              },
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Search",
                hintText: "Sorceries",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0))
                )
              )
            )
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${items[index]}'),
                );
              }
            )
          )
        ],
      )
    );
  }
}