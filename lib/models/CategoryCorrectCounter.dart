class CategoryCorrectCounter {
  String question_id;
  String user_id;
  bool status;

  CategoryCorrectCounter({this.question_id, this.user_id, this.status});

  CategoryCorrectCounter.fromJsonMap(Map<String, dynamic> map)
      : question_id = map["question_id"],
        user_id = map["user_id"],
        status = map["status"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question_id'] = question_id;
    data['user_id'] = user_id;
    data['status'] = status;
    return data;
  }
}
