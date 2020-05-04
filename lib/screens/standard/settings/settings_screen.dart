import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with TickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    new Tab(text: "Dice Roller"),
    new Tab(text: "Characters"),
  ];

  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: myTabs.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
          bottom: new TabBar(
            controller: _controller,
            tabs: myTabs

          )
      ),
      body: TabBarView(
        controller: _controller,
        children: myTabs.map((Tab tab) {
          final String label = tab.text;
          return Center(
            child: Text('$label', style: const TextStyle(fontSize: 36)),
          );
        }).toList()
      ),

    );
  }
}