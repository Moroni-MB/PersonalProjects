import 'question.dart';

class Lesson {
  final String title;
  final String difficulty;
  final List<Question> questions;

  Lesson({
    required this.title,
    required this.difficulty,
    required this.questions,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      title: json['title'],
      difficulty: json['difficulty'],
      questions: (json['questions'] as List)
          .map((q) => Question.fromJson(q))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'difficulty': difficulty,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }
}



