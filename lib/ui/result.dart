import 'package:flutter/material.dart';
import 'package:quiz_india/services/colors.dart';
import 'package:quiz_india/widgets/widgets.dart';

class Results extends StatefulWidget {
  final int correct, incorrect, total;
  Results(
      {@required this.correct, @required this.incorrect, @required this.total});
  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  int correct;
  String message;
  String image;
  List<String> images = [
    "assets/images/trophy.png",
    "assets/images/unhappy.png",
    "assets/images/like.png",
  ];
  @override
  void initState() {
    if (widget.correct < 25) {
      message = "You Should Try Hard..";
      image = images[1];
    } else if (widget.correct < 90) {
      message = "Well done!Keep it up..";
      image = images[2];
    } else {
      message = "Congratulations.You completed the quiz";
      image = images[0];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: appBar(context),
          backgroundColor: primaryColor,
          elevation: 0.0,
          brightness: Brightness.light,
        ),
        body: Container(
          decoration: myBoxDecoration1(context),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Container(
                    child: Image.asset(
                      image,
                      height: 200,
                      width: 200,
                    ),
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: darkAccentColor,
                    border: Border.all(
                      color: Colors.black,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        " Correct Answers: ${widget.correct}"
                        " \n Incorrect Answers: ${widget.incorrect}"
                        "\n Total Questions: ${widget.total}"
                        "\n Score: ${(widget.correct / widget.total * 100).toInt()}%",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        )),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  "Thank you for playing quiz",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 18,
                ),
                FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  label: Text(
                    "Return Home",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                  ),
                  backgroundColor: darkAccentColor,
                ),
              ],
            ),
          ),
        ));
  }
}
