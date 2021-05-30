class QuestionsAttempted {
  bool correct;
  String questionId;
  QuestionsAttempted({this.correct, this.questionId});

  QuestionsAttempted.fromJsonMap(Map<String, dynamic> map)
      : correct = map["correct"],
        questionId = map["questionId"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['correct'] = correct;
    data['questionId'] = questionId;
    return data;
  }
}
