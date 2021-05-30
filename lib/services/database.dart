import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  getQuizData(String quizId) async {
    return await Firestore.instance
        .collection("Quiz")
        .document(quizId)
        .collection("QNA")
        .getDocuments();
  }

  getWeeklyQuizesData() async {
    return await Firestore.instance.collection("WeeklyQuiz").snapshots();
  }

  getQuizesDataForHomeScreen() async {
    return await Firestore.instance.collection("Quizes").snapshots();
  }

  Logger lgr = Logger();
  getQuizesDataForTabBar(String quizId) async {
    var result = await Firestore.instance
        .collection("Quizes")
        .document(quizId)
        .collection("QuizList")
        .snapshots();
    return result;
  }

  getQuizesQuestions(String quizId, String quizListId) async {
    var result = await Firestore.instance
        .collection("Quizes")
        .document(quizId)
        .collection("QuizList")
        .document(quizListId)
        .collection("QNA")
        .getDocuments();
//    print('this is the check ${result.docs}');
    return result;
  }

  setCategoryCorrectCounter(String question_id, bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("userId");
    var result = await Firestore.instance
        .collection("CategoryCorrectCounter")
        .document(userId)
        .collection("User")
        .document(question_id)
        .setData({'question_id': question_id, 'status': status});
    return result;
  }
}
