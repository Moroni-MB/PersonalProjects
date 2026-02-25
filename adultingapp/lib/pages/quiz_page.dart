import 'package:flutter/material.dart';
import '../widgets/option_card.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  double progressValue = 0.0;

  void _handleOptionSelected() {
    setState(() {
      //ADD LOGIC 
      progressValue += 0.25; 
      if (progressValue > 1.0) {
        progressValue = 1.0;
      }
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                height: 20,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                          width: constraints.maxWidth * progressValue,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 241, 73, 40),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Question Text
              const Text(
                "Which one of these is a heart?",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              Expanded(
                child: Center(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.0,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      OptionCard(
                        emoji: "⭐",
                        label: "Star",
                        onTap: _handleOptionSelected,
                      ),
                      OptionCard(
                        emoji: "❤️",
                        label: "A heart",
                        onTap: _handleOptionSelected,
                      ),
                      OptionCard(
                        emoji: "🔵",
                        label: "Circle",
                        onTap: _handleOptionSelected,
                      ),
                      OptionCard(
                        emoji: "🟩",
                        label: "Square",
                        onTap: _handleOptionSelected,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Check Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _handleOptionSelected,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 241, 73, 40),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text("CHECK"),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}