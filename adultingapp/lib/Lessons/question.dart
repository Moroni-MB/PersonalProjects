class Question {
  final String question;
  final Map<String, String> options;
  final String answer;

  Question({
    required this.question,
    required this.options,
    required this.answer,
  });

  factory Question.fromJson(Map<String, dynamic> json){
    return Question(
      question: json['question'], 
      options: Map<String, String>.from(json['options']), 
      answer: json['answer']);
  }

  Map<String, dynamic> toJson(){
    return {
      'question': question,
      'options': options,
      'answer': answer,
    };
  }

  String getCorrectAnswerText(){
    return options[answer] ?? '';
  }

  bool isCorrect(String SelectedAnswer){
    return SelectedAnswer == answer;
  }

  List<MapEntry<String, String>> getOptionsAsList(){
    return options.entries.toList();
  }

}