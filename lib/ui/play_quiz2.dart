import 'package:audioplayers/audio_cache.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:logger/logger.dart';
import 'package:quiz_india/models/CategoryCorrectCounter.dart';
import 'package:quiz_india/models/question_model.dart';
import 'package:quiz_india/services/colors.dart';
import 'package:quiz_india/services/database.dart';
import 'package:quiz_india/ui/result.dart';
import 'package:quiz_india/widgets/quiz_play_widgets.dart';
import 'package:quiz_india/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayQuiz2 extends StatefulWidget {
  final String quizId;
  final String quizListId;

  PlayQuiz2(this.quizId, this.quizListId);

  @override
  _PlayQuiz2State createState() => _PlayQuiz2State();
}

int total = 0;
int _correct = 0;
int _incorrect = 0;
int _notAttempted = 0;

class _PlayQuiz2State extends State<PlayQuiz2> with TickerProviderStateMixin {
  DatabaseService databaseService = new DatabaseService();
  QuerySnapshot questionsSnapshot;
  QuestionModel que;
  int index = 0;
  List<QuestionModel> allQuestions = [];
  List<String> playedQuestionIDs = [];
  CardController controller = CardController(); //Use this to trigger swap.

  QuestionModel getQuestionModelFromDatasnapshot(int index) {
    return allQuestions[index];
  }

  Logger lgr = Logger();

  Future<List> checkPlayedQuestionIds() async {
    var playedQuestionIDs = <String>[];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("userId");

    var result = await Firestore.instance
        .collection("CategoryCorrectCounter")
        .document(userId)
        .collection("User")
        .getDocuments();

    for (var x in result.docs) {
      print("CHECK QUESTION ID---->${x.id}");

      if (x.data()['status']) {
        playedQuestionIDs.add(x.id);
      } else {
        print("UNPLAYED QUESTION --->${x.id}");
      }
    }
    return playedQuestionIDs;
  }

  void init() async {
    playedQuestionIDs = await checkPlayedQuestionIds();

    print("PLAYED LIST " + playedQuestionIDs.toString());
    for (int i = 0; i < questionsSnapshot.documents.length; i++) {
      DocumentSnapshot questionSnapshot = questionsSnapshot.documents[i];

      QuestionModel questionModel = new QuestionModel();

      questionModel.question = questionSnapshot.get("question");

      List<String> options = [
        questionSnapshot.get("option1"),
        questionSnapshot.get("option2"),
        questionSnapshot.get("option3"),
        questionSnapshot.get("option4"),
      ];
      options.shuffle();
      print(questionsSnapshot.documents[i].id);
      questionModel.questionId = questionsSnapshot.documents[i].id;
      questionModel.option1 = options[0];
      questionModel.option2 = options[1];
      questionModel.option3 = options[2];
      questionModel.option4 = options[3];
      questionModel.correctOption = questionSnapshot.get("option1");
      questionModel.answered = false;

      if (playedQuestionIDs.contains(questionModel.questionId)) {
      } else {
        allQuestions.add(questionModel);
        print("ADDING ${questionModel.questionId} [UNPLAYED]");
      }

      if (allQuestions.length == 0) {
        //Sabai questions sakeko ma k garne??!!
      }
      print("TOTAL QUESTIONS-->${allQuestions.length}");
    }
    setState(() {});
  }

  @override
  void initState() {
    print(widget.quizListId);
    print(widget.quizId);
    databaseService
        .getQuizesQuestions(widget.quizId, widget.quizListId)
        .then((value) {
      questionsSnapshot = value;
      _notAttempted = 0;
      _correct = 0;
      _incorrect = 0;
      total = questionsSnapshot.documents.length;
      setState(() {});
      init();
    });

    super.initState();
  }

  AudioCache audioCache = AudioCache();

  @override
  Widget build(BuildContext context) {
    CardController controller = CardController();

    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: primaryColor,
        elevation: 0.0,
        brightness: Brightness.light,
      ),
      body: questionsSnapshot != null
          ? Container(
              decoration: myBoxDecoration1(context),
              child: Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: new TinderSwapCard(
                    cardController: controller,
                    swipeUp: false,
                    swipeDown: false,
                    orientation: AmassOrientation.TOP,
                    stackNum: 4,
                    swipeEdge: 4.0,
                    maxWidth: MediaQuery.of(context).size.width * 0.9,
                    maxHeight: MediaQuery.of(context).size.width * 0.9,
                    minWidth: MediaQuery.of(context).size.width * 0.8,
                    minHeight: MediaQuery.of(context).size.width * 0.8,
                    cardBuilder: (context, index) => Card(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: QuizPlayTile(
                          quizListId: widget.quizListId,
                          questionModel:
                              getQuestionModelFromDatasnapshot(index),
                          index: index,
                          onTap: () {
                            print('ontapped');
                            controller.triggerLeft();
                          },
                        ),
                      ),
                      elevation: 30.0,
                    ),
                    totalNum: allQuestions.length,
                    swipeUpdateCallback:
                        (DragUpdateDetails details, Alignment align) {
                      if (align.x < 0) {
                      } else if (align.x > 0) {}
                    },
                    swipeCompleteCallback:
                        (CardSwipeOrientation orientation, int index) {},
                  ),
                ),
              ),
            )
          : Container(
              height: 300,
              width: 400,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 6.0,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xfff9ea8f)),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(
          "View Score",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
        ),
        backgroundColor: accentColor,
        onPressed: () {
          audioCache.load("images/result.wav");
          audioCache.play("images/result.wav");

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Results(
                        correct: _correct,
                        incorrect: _incorrect,
                        total: total,
                      )));
        },
      ),
    );
  }
}

class QuizPlayTile extends StatefulWidget {
  final QuestionModel questionModel;
  final String questionId;
  final int index;
  final Function onTap;
  final String quizListId;

  QuizPlayTile(
      {this.questionModel,
      this.index,
      this.onTap,
      this.quizListId,
      this.questionId});

  @override
  _QuizPlayTileState createState() => _QuizPlayTileState();
}

class _QuizPlayTileState extends State<QuizPlayTile> {
  List<CategoryCorrectCounter> questions = [];

  String optionSelected = "";
  final ScrollController _scrollController = ScrollController();
  AudioCache audioCache = AudioCache();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CupertinoScrollbar(
        controller: _scrollController,
        isAlwaysShown: true,
        child: SingleChildScrollView(
          controller: _scrollController,
          //wrapped column wih SingleChildScrollView to solve the problem of renderflex error
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Q.${widget.index + 1}) ${widget.questionModel.question}",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                GestureDetector(
                  onTap: () async {
                    if (!widget.questionModel.answered) {
                      bool isCorrect = false;
                      if (widget.questionModel.option1 ==
                          widget.questionModel.correctOption) {
                        isCorrect = true;
                        optionSelected = widget.questionModel.option1;
                        widget.questionModel.answered = true;
                        _correct = _correct + 1;
                        _notAttempted = _notAttempted - 1;
                        audioCache.load("images/correct.wav");
                        audioCache.play("images/correct.wav");
                        setState(() async {
                          await DatabaseService().setCategoryCorrectCounter(
                              widget.questionModel.questionId, isCorrect);
                        });
                      } else {
                        isCorrect = false;
                        optionSelected = widget.questionModel.option1;
                        widget.questionModel.answered = true;
                        _incorrect = _incorrect + 1;
                        _notAttempted = _notAttempted - 1;
                        audioCache.load("images/wrong.wav");
                        audioCache.play("images/wrong.wav");

                        setState(() async {
                          await DatabaseService().setCategoryCorrectCounter(
                              widget.questionModel.questionId, isCorrect);
                        });
                      }

                      await Future.delayed(const Duration(milliseconds: 600));

                      widget.onTap();
                    }
                  },
                  child: OptionTile(
                    correctAnswer: widget.questionModel.correctOption,
                    description: widget.questionModel.option1,
                    option: "A",
                    optionSelected: optionSelected,
                    isAnswered: widget.questionModel.answered,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                GestureDetector(
                  onTap: () async {
                    if (!widget.questionModel.answered) {
                      bool isCorrect = false;
                      if (widget.questionModel.option2 ==
                          widget.questionModel.correctOption) {
                        isCorrect = true;
                        optionSelected = widget.questionModel.option2;
                        widget.questionModel.answered = true;
                        _correct = _correct + 1;
                        _notAttempted = _notAttempted - 1;
                        audioCache.load("images/correct.wav");
                        audioCache.play("images/correct.wav");
                        setState(() async {
                          await DatabaseService().setCategoryCorrectCounter(
                              widget.questionModel.questionId, isCorrect);
                        });
                      } else {
                        isCorrect = false;
                        optionSelected = widget.questionModel.option2;
                        widget.questionModel.answered = true;
                        _incorrect = _incorrect + 1;
                        _notAttempted = _notAttempted - 1;
                        audioCache.load("images/wrong.wav");
                        audioCache.play("images/wrong.wav");
                        setState(() {
                          DatabaseService().setCategoryCorrectCounter(
                              widget.questionModel.questionId, isCorrect);
                        });
                      }
                    }
                    await Future.delayed(const Duration(milliseconds: 600));

                    widget.onTap();
                  },
                  child: OptionTile(
                    correctAnswer: widget.questionModel.correctOption,
                    description: widget.questionModel.option2,
                    option: "B",
                    optionSelected: optionSelected,
                    isAnswered: widget.questionModel.answered,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                GestureDetector(
                  onTap: () async {
                    if (!widget.questionModel.answered) {
                      bool isCorrect = false;
                      if (widget.questionModel.option3 ==
                          widget.questionModel.correctOption) {
                        isCorrect = true;
                        optionSelected = widget.questionModel.option3;
                        widget.questionModel.answered = true;
                        _correct = _correct + 1;
                        _notAttempted = _notAttempted - 1;
                        audioCache.load("images/correct.wav");
                        audioCache.play("images/correct.wav");
                        setState(() {
                          DatabaseService().setCategoryCorrectCounter(
                              widget.questionModel.questionId, isCorrect);
                        });
                      } else {
                        isCorrect = false;
                        optionSelected = widget.questionModel.option3;
                        widget.questionModel.answered = true;
                        _incorrect = _incorrect + 1;
                        _notAttempted = _notAttempted - 1;
                        audioCache.load("images/wrong.wav");
                        audioCache.play("images/wrong.wav");
                        setState(() {
                          DatabaseService().setCategoryCorrectCounter(
                              widget.questionModel.questionId, isCorrect);
                        });
                      }
                    }
                    await Future.delayed(const Duration(milliseconds: 600));
                    widget.onTap();
                  },
                  child: OptionTile(
                    correctAnswer: widget.questionModel.correctOption,
                    description: widget.questionModel.option3,
                    option: "C",
                    optionSelected: optionSelected,
                    isAnswered: widget.questionModel.answered,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                GestureDetector(
                  onTap: () async {
                    if (!widget.questionModel.answered) {
                      bool isCorrect = false;
                      if (widget.questionModel.option4 ==
                          widget.questionModel.correctOption) {
                        isCorrect = true;
                        optionSelected = widget.questionModel.option4;
                        widget.questionModel.answered = true;
                        _correct = _correct + 1;
                        _notAttempted = _notAttempted - 1;
                        audioCache.load("images/correct.wav");
                        audioCache.play("images/correct.wav");
                        setState(() {
                          DatabaseService().setCategoryCorrectCounter(
                              widget.questionModel.questionId, isCorrect);
                        });
                      } else {
                        isCorrect = false;
                        optionSelected = widget.questionModel.option4;
                        widget.questionModel.answered = true;
                        _incorrect = _incorrect + 1;
                        _notAttempted = _notAttempted - 1;
                        audioCache.load("images/wrong.wav");
                        audioCache.play("images/wrong.wav");
                        setState(() {
                          DatabaseService().setCategoryCorrectCounter(
                              widget.questionModel.questionId, isCorrect);
                        });
                      }
                    }
                    await Future.delayed(const Duration(milliseconds: 600));
                    widget.onTap();
                  },
                  child: OptionTile(
                    correctAnswer: widget.questionModel.correctOption,
                    description: widget.questionModel.option4,
                    option: "D",
                    optionSelected: optionSelected,
                    isAnswered: widget.questionModel.answered,
                  ),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
