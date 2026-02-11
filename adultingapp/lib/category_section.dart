import 'package:flutter/material.dart';

class LessonItem {
  final String title;
  final String description;
  final String difficulty;
  final String duration;

  const LessonItem({
    required this.title,
    required this.description,
    required this.difficulty,
    required this.duration,
  });
}

class CategorySection extends StatelessWidget {
  final String title;
  final Color titleColor;
  final List<LessonItem> lessons;
  final void Function(LessonItem lesson)? onStart;

  const CategorySection({
    super.key,
    required this.title,
    required this.titleColor,
    required this.lessons,
    this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header row ("Cooking" + chevron)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: titleColor,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.keyboard_arrow_up_rounded, size: 28),
              ),
            ],
          ),
        ),

        // Lessons list (non-scrollable list inside the page scroll)
        ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: lessons.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final lesson = lessons[index];
            return _LessonCard(
              lesson: lesson,
              onStart: () => onStart?.call(lesson),
            );
          },
        ),
      ],
    );
  }
}

class _LessonCard extends StatelessWidget {
  final LessonItem lesson;
  final VoidCallback onStart;

  const _LessonCard({
    required this.lesson,
    required this.onStart,
  });

  Color _pillColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green.shade600;
      case 'med':
      case 'medium':
        return Colors.orange.shade700;
      case 'hard':
        return Colors.red.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    final pillColor = _pillColor(lesson.difficulty);

    return Material(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(16),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        collapsedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Expanded(
              child: Text(
                lesson.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: pillColor,
                ),
              ),
            ),
            _Pill(text: lesson.difficulty, color: pillColor),
            const SizedBox(width: 8),
            _Pill(text: lesson.duration, color: pillColor),
          ],
        ),
        subtitle: Text(
          lesson.description,
          style: TextStyle(fontSize: 15, color: Colors.grey.shade800),
        ),
        trailing: const Icon(Icons.keyboard_arrow_down_rounded, size: 28),
        children: [
          Row(
            children: [
              const Spacer(),
              ElevatedButton(
                onPressed: onStart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Start Now",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_forward_rounded, size: 20),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final Color color;

  const _Pill({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }
}
