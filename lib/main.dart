import 'package:flutter/material.dart';
import 'package:flutterdiceroller/screens/standard/settings/settings_screen.dart';
import 'dart:io' show Platform;
import 'package:provider/provider.dart';

import 'package:flutterdiceroller/screens/standard/standard_screen.dart';
import 'package:flutterdiceroller/screens/standard/standard_dice/dice_rolls.dart';

import 'global_variables.dart';

void main() {
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => DiceRolls()),
          ChangeNotifierProvider(create: (context) => GlobalVariables()),
        ],
        child: MyApp())
      );
}

class MyApp extends StatelessWidget {
  // This widget is the root of the application.

  @override
  Widget build(BuildContext context) {
    final globalVariables = Provider.of<GlobalVariables>(context);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.teal,
        accentColor: Color(0xe5bf6bff),
        brightness: Brightness.dark,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
        platform: globalVariables.isAndroid ? TargetPlatform.android : TargetPlatform.iOS
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => MyHomePage(title: 'Flutter Demo Home Page'),
        '/dice': (context) => StandardScreen(),
        '/settings': (context) => SettingsScreen()
      }
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    final globalVariables = Provider.of<GlobalVariables>(context);
    final diceRolls = Provider.of<DiceRolls>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // diceRolls.setDiceButtons();
          Navigator.pushReplacementNamed(context, '/dice');
        },
        child: globalVariables.isAndroid ? Icon(Icons.arrow_forward) : Icon(Icons.arrow_forward_ios)
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
