import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiz_india/services/colors.dart';

class OptionTile extends StatefulWidget {
  final String option, description, correctAnswer, optionSelected;
  bool isAnswered;

  OptionTile(
      {@required this.optionSelected,
      @required this.correctAnswer,
      @required this.description,
      @required this.option,
      @required this.isAnswered});

  @override
  _OptionTileState createState() => _OptionTileState();
}

class _OptionTileState extends State<OptionTile> {
  var color;

  @override
  Widget build(BuildContext context) {
    color = primaryColor;

    if (widget.isAnswered) {
      if (widget.description == widget.optionSelected) {
        color = darkAccentColor;
      }
      if (widget.optionSelected.isNotEmpty) {
        if (widget.correctAnswer == widget.description) {
          color = Colors.green;
        }
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: SingleChildScrollView(
        //for the problem of renderflex error
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                    border: Border.all(color: color, width: 1.4),
                    borderRadius: BorderRadius.circular(30)),
                alignment: Alignment.center,
                child: Text(
                  "${widget.option}",
                  style: TextStyle(
                    color: color,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              flex: 8,
              child: Text(
                widget.description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  background: Paint()
                    ..strokeWidth = 20.0
                    ..color = color
                    ..style = PaintingStyle.stroke
                    ..strokeJoin = StrokeJoin.round,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
