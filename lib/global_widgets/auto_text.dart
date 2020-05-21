import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class AutoText extends StatefulWidget {
  String _text;
  double _fontSize;
  Color _color;
  bool _outline;
  AutoText(String text, double fontSize, [Color color = Colors.white, bool outline = false]) {
    _text = text;
    _fontSize = fontSize;
    _color = color;
    _outline = outline;
  }

  @override
  _AutoTextState createState() => _AutoTextState();
}

class _AutoTextState extends State<AutoText> {
  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[
          /*AutoSizeText(
            widget._text,
            style: TextStyle(color: Colors.black, fontSize: widget._fontSize, fontWeight: FontWeight.w800),
            maxLines: 1,
          ),*/
          /*widget._outline ? Center(
            child: AutoSizeText(
              widget._text,
              style: TextStyle(fontSize: widget._fontSize+1, fontWeight: FontWeight.w300,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 3
                  ..color = Colors.black,
                ),
              maxLines: 1,
            ),
          ) : Container(),*/
          Center(
            child: AutoSizeText(
              widget._text,
              maxLines: 1,
              style: TextStyle(
                  fontSize: widget._fontSize,
                  color: widget._color,
                  shadows: widget._outline ? [
                    Shadow(
                      offset: Offset(-1.5, -1.5),
                      color: Colors.black,
                    ),
                    Shadow(
                      offset: Offset(1.5, -1.5),
                      color: Colors.black,
                    ),
                    Shadow(
                      offset: Offset(1.5, 1.5),
                      color: Colors.black,
                    ),
                    Shadow(
                      offset: Offset(-1.5, 1.5),
                      color: Colors.black,
                    ),
                  ] : null
              ),
            )
          )
        ]
    );
  }
}