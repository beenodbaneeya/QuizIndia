import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:logger/logger.dart';
import 'package:quiz_india/services/database.dart';
import 'package:quiz_india/ui/play_quiz2.dart';

class TabBarPage extends StatefulWidget {
  final String quizId;
  TabBarPage(this.quizId);
  @override
  _TabBarPageState createState() => _TabBarPageState();
}

class _TabBarPageState extends State<TabBarPage> {
  Stream quizStream;
  DatabaseService databaseService = new DatabaseService();
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> logOut() async {
    FirebaseUser user = auth.signOut() as FirebaseUser;
  }

  Widget quizList() {
    return Container(
      child: StreamBuilder(
        stream: quizStream,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? Container()
              : SizedBox(
                  height: 400,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        return QuizTile(
                          imgUrl:
                              snapshot.data.documents[index].get("quizImgUrl"),
                          desc: snapshot.data.documents[index].get("quizDesc"),
                          title:
                              snapshot.data.documents[index].get("quizTitle"),
                          quizid: snapshot.data.documents[index].get("quizId"),
                          quizListId:
                              snapshot.data.documents[index].get("quizListId"),
                        );
                      }),
                );
        },
      ),
    );
  }

  Logger lgr = Logger();
  @override
  void initState() {
    databaseService.getQuizesDataForTabBar(widget.quizId).then((val) {
      setState(() {
        quizStream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: quizList(),
    );
  }
}

class QuizTile extends StatelessWidget {
  final String imgUrl;
  final String title;
  final String desc;
  final String quizid;
  final String quizListId;

  QuizTile({
    @required this.imgUrl,
    @required this.title,
    @required this.desc,
    @required this.quizid,
    @required this.quizListId,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlayQuiz2(quizid, quizListId),
            ),
          );
        },
        child: Container(
          height: 200,
          width: 200,
          padding: EdgeInsets.only(left: 26.0, right: 26.0, top: 10.0),
          child: Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: CachedNetworkImage(
                  imageUrl: imgUrl,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: Colors.black26,
                ),
                alignment: Alignment.center,
                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(title,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
