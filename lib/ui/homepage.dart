import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:quiz_india/services/colors.dart';
import 'package:quiz_india/services/database.dart';
import 'package:quiz_india/ui/tab_bar.dart';
import 'package:quiz_india/ui/viewquiz.dart';
import 'package:quiz_india/widgets/widgets.dart';
import 'customTabView.dart';
import 'home.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  Stream quizStream;
  DatabaseService databaseService = new DatabaseService();
  TabController tabController;

  String quizId;

  Widget quizList() {
    return Container(
      margin: EdgeInsets.only(left: 24, top: 6, right: 24),
      child: StreamBuilder(
        stream: quizStream,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? Container()
              : CarouselSlider.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ViewQuiz(
                                    quizImgUrl: snapshot.data.documents[index]
                                        .get("quizImgUrl"),
                                    quizId: snapshot.data.documents[index]
                                        .get("quizId"),
                                    quizDesc: snapshot.data.documents[index]
                                        .get("quizDesc"),
                                    title: snapshot.data.documents[index]
                                        .get("quizTitle"),
                                  ))),
                      child: Hero(
                        tag: snapshot.data.documents[index].get("quizImgUrl"),
                        child: QuizTile(
                          imgUrl:
                              snapshot.data.documents[index].get("quizImgUrl"),
                          desc: snapshot.data.documents[index].get("quizDesc"),
                          title:
                              snapshot.data.documents[index].get("quizTitle"),
                          quizid: snapshot.data.documents[index].get("quizId"),
                        ),
                      ),
                    );
                  },
                  options: CarouselOptions(
                      height: 300,
                      viewportFraction: 0.8,
                      enableInfiniteScroll: true,
                      reverse: true,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 4),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.easeIn,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal),
                );
        },
      ),
    );
  }

  Widget _buildTabs() {
    return StreamBuilder(
        stream: quizStream,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? Container()
              : Expanded(
                  child: CustomTabView(
                    initPosition: 0,
                    itemCount: snapshot.data.documents.length,
                    tabBuilder: (context, index) => Tab(
                        text: snapshot.data.documents[index].get("quizTitle")),
                    pageBuilder: (context, index) => Center(
                      child: TabBarPage(
                          snapshot.data.documents[index].get("quizId")
//                  quizId: snapshot.data.documents[index].get("quizId"),
                          ),
                    ),
                    onPositionChange: (index) {
                      print('current position: $index');
                      //initPosition = index;
                    },
                    onScroll: (position) => print('$position'),
                  ),
                );
        });
  }

  Logger lgr = Logger();
  @override
  void initState() {
    databaseService.getQuizesDataForHomeScreen().then((val) {
      setState(() {
        quizStream = val;
      });
    });
    super.initState();
    tabController = TabController(length: 5, vsync: this);
  }

  logout() async {
    await googleSignIn.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: primaryColor,
        elevation: 0.0,
        brightness: Brightness.light,
        actions: <Widget>[],
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 20.0, top: 20.0),
            child: Text(
              "Trending Quizes",
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w700, fontSize: 20),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(height: 330, child: quizList()),
          _buildTabs(),
        ],
      ),
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
    return Container(
      child: Stack(
        children: <Widget>[
          ClipRRect(
            child: CachedNetworkImage(
              imageUrl: imgUrl,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
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
//                SizedBox(
//                  height: 6,
//                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(desc,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w800)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
