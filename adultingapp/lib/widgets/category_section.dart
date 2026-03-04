import 'package:flutter/material.dart';
import '../models/lesson_item.dart';
import '../pages/car_maintenance_lesson.dart';
import '../pages/quiz_page.dart';

class CategorySection extends StatelessWidget {
  final String title;
  final Color titleColor;
  final List<LessonItem> lessons;

  const CategorySection({
    super.key,
    required this.title,
    required this.titleColor,
    required this.lessons,
  });

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case "easy":
        return Colors.green;
      case "medium":
        return Colors.orange;
      case "hard":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 15),

          // Lessons List
          Column(
            children: lessons.map((lesson) {
              return _LessonTile(
                lesson: lesson,
                difficultyColor: _getDifficultyColor(lesson.difficulty),
              );
            }).toList(),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class _LessonTile extends StatefulWidget {
  final LessonItem lesson;
  final Color difficultyColor;

  const _LessonTile({
    required this.lesson,
    required this.difficultyColor,
  });

  @override
  State<_LessonTile> createState() => _LessonTileState();
}

class _LessonTileState extends State<_LessonTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.lesson.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: IconButton(
              icon: Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
              ),
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
          ),

          if (isExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.lesson.description),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      // Difficulty label
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: widget.difficultyColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.lesson.difficulty,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Text("⏱ ${widget.lesson.duration}"),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // Start Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (widget.lesson.routeName != null) {
                          Navigator.pushNamed(context, widget.lesson.routeName!);
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizPage(lesson: widget.lesson),
                            ),
                          );
                        }
                      },
                      child: const Text("Start"),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}