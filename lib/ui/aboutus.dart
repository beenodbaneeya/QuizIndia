import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_india/services/colors.dart';
import 'package:quiz_india/widgets/widgets.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: appBar(context),
        backgroundColor: primaryColor,
        elevation: 0.0,
        brightness: Brightness.light,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: myBoxDecoration1(context),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Center(
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.only(left: 15, top: 30),
                  width: MediaQuery.of(context).size.width / 1.5,
                  height: MediaQuery.of(context).size.width / 1.5,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 3),
                    shape: BoxShape.circle,
                    color: Colors.white,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/globe.jpg'),
                    ),
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                elevation: 15,
                child: Container(
                  height: 175,
                  width: 275,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            "Let us build your knowledge.",
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
//                          const EdgeInsets.only(
//                              left: 8.0, bottom: 8.0, right: 8.0),
                          child: Text(
                            "Today, Quizes are interactive platforms where every people are not participating to take home a prize or get famous overnight, but to gain knowledge, seek opportunities to excel beyond academics and secure their future.",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 14.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Copyright @QuizIndia 2021",
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: darkAccentColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
