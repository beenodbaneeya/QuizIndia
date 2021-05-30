import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:quiz_india/services/colors.dart';
import 'package:quiz_india/services/database.dart';
import 'package:quiz_india/ui/play_quiz1.dart';
import 'package:quiz_india/widgets/widgets.dart';

class WeeklyQuiz extends StatefulWidget {
  @override
  _WeeklyQuizState createState() => _WeeklyQuizState();
}

class _WeeklyQuizState extends State<WeeklyQuiz> {
  Stream quizStream;
  DatabaseService databaseService = new DatabaseService();

  @override
  void initState() {
    databaseService.getWeeklyQuizesData().then((val) {
      setState(() {
        quizStream = val;
      });
    });
    super.initState();
  }

  Widget quizList() {
    return Container(
      margin: EdgeInsets.only(left: 24, top: 6, right: 24),
      child: StreamBuilder(
        stream: quizStream,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? Container()
              : ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return QuizTile(
                      imgUrl: snapshot.data.documents[index].get("quizImgUrl"),
                      desc: snapshot.data.documents[index].get("quizDesc"),
                      title: snapshot.data.documents[index].get("quizTitle"),
                      quizid: snapshot.data.documents[index].get("quizId"),
                    );
                  });
        },
      ),
    );
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
      body: quizList(),
    );
  }
}

class QuizTile extends StatelessWidget {
  final String imgUrl;
  final String title;
  final String desc;
  final String quizid;

  QuizTile({
    @required this.imgUrl,
    @required this.title,
    @required this.desc,
    @required this.quizid,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          final snackBar = SnackBar(
            content: Text("We will provide weekly quiz soon.Thank You!"),
            backgroundColor: primaryColor,
            duration: Duration(milliseconds: 900),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
//          Navigator.push(
//            context,
//            MaterialPageRoute(
//              builder: (context) => PlayQuiz1(quizid),
//            ),
//          );
        },
        child: Card(
          margin: EdgeInsets.fromLTRB(4.0, 16.0, 4.0, 0),
          elevation: 15,
          child: Container(
            height: 180,
            child: Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: CachedNetworkImage(
                    imageUrl: imgUrl,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                ),
//                ClipRRect(
//                    borderRadius: BorderRadius.circular(4.0),
//                    child: Image.network(
//                      imgUrl,
//                      width: MediaQuery.of(context).size.width,
//                      fit: BoxFit.cover,
//                    )),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    color: Colors.black26,
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(title,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800)),
                      SizedBox(
                        height: 6,
                      ),
                      Text(desc,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600))
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
