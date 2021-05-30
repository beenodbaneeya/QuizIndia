import 'package:audioplayers/audio_cache.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:foldable_sidebar/foldable_sidebar.dart';
import 'package:quiz_india/services/colors.dart';
import 'package:quiz_india/services/database.dart';
import 'package:quiz_india/ui/play_quiz2.dart';
import 'package:quiz_india/widgets/widgets.dart';

class QuizListForViewQuizPage extends StatefulWidget {
  final String quizId;
  QuizListForViewQuizPage(this.quizId);
  @override
  _QuizListForViewQuizPageState createState() =>
      _QuizListForViewQuizPageState();
}

class _QuizListForViewQuizPageState extends State<QuizListForViewQuizPage> {
  void reload() {
    setState(() {
      status = FSBStatus.FSB_CLOSE;
    });
  }

  Stream quizStream;
  FSBStatus status;
  DatabaseService databaseService = new DatabaseService();

  ScrollController controller = ScrollController();
  double topContainer = 0;

  AudioCache audioCache = AudioCache();

  FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> logOut() async {
    FirebaseUser user = auth.signOut() as FirebaseUser;
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
                  controller: controller,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    double scale = 1.0;
                    if (topContainer > 1) {
                      scale = index + 1 - topContainer;
                      if (scale < 0) {
                        scale = 0;

                        //audioCache.play("images/scroll_sound.flac");
                      } else if (scale > 1) {
                        scale = 1;
                      }
                    }

                    return Opacity(
                      opacity: scale,
                      child: Transform(
                        transform: Matrix4.identity()..scale(scale, scale),
                        alignment: Alignment.bottomCenter,
                        child: QuizTile(
                          imgUrl:
                              snapshot.data.documents[index].get("quizImgUrl"),
                          desc: snapshot.data.documents[index].get("quizDesc"),
                          title:
                              snapshot.data.documents[index].get("quizTitle"),
                          quizid: snapshot.data.documents[index].get("quizId"),
                          quizListId:
                              snapshot.data.documents[index].get("quizListId"),
                          home: this,
                        ),
                      ),
                    );
                  });
        },
      ),
    );
  }

  @override
  void initState() {
    databaseService.getQuizesDataForTabBar(widget.quizId).then((val) {
      setState(() {
        quizStream = val;
      });
    });
    super.initState();
    controller.addListener(() {
      double value = controller.offset / 180;
      setState(() {
        topContainer = value;
      });
    });
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
  final String quizListId;
  final _QuizListForViewQuizPageState home;

  AudioCache audioCache = AudioCache();

  QuizTile(
      {@required this.imgUrl,
      @required this.title,
      @required this.desc,
      @required this.quizid,
      @required this.quizListId,
      @required this.home});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          audioCache.load("images/entry.m4a");
          audioCache.play("images/entry.m4a");

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlayQuiz2(quizid, quizListId),
            ),
          ).then((value) => home.reload());
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
                    fit: BoxFit.fill,
                  ),
                ),
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
                              fontSize: 16,
                              fontWeight: FontWeight.w800)),
                      SizedBox(
                        height: 6,
                      ),
                      Text(desc,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
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
