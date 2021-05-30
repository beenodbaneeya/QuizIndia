import 'package:cloud_firestore/cloud_firestore.dart';

class QuizModel {
  String quizDesc;
  String quizId;
  String quizImgUrl;
  String quizTitle;
  QuizModel({this.quizDesc, this.quizId, this.quizImgUrl, this.quizTitle});

  factory QuizModel.fromFireStore(DocumentSnapshot doc) {
    Map data = doc.data();
    return QuizModel(
        quizDesc: data['quizDesc'],
        quizId: doc.documentID,
        quizImgUrl: data['quizImgUrl'],
        quizTitle: data['quizTitle']);
  }
}
