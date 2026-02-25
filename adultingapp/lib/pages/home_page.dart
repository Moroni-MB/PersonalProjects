import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/category_section.dart';
import '../widgets/skill_card.dart';
import 'quiz_page.dart';
import '../pages/completed_page.dart';
import '../models/lesson_item.dart';

// Home page with NavigationRail
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;

    // Switch between pages
    switch (selectedIndex) {
      case 0:
        page = const HomePage();
        break;
      case 1:
        page = const CompletedPage();
        break;
      default:
        page = const HomePage();
    }

    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: page,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'Completed',
          ),
        ],
      ),
    );
  }
}

// -------- Pages --------

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        // App title
                        'Adulting App',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Display the email being used
                      Text(
                        FirebaseAuth.instance.currentUser?.email ?? "",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),

                  // Logout button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.logout),
                      color: Colors.red,
                      tooltip: "Logout",
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),


            const SizedBox(height: 20),
            

            // 🔹 Horizontal Skills Section
            SizedBox(
              height: 200,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: const [
                  SkillCard(title: 'Cooking', icon: Icons.restaurant),
                  SkillCard(title: 'Budgeting', icon: Icons.attach_money),
                  SkillCard(title: 'Car Care', icon: Icons.directions_car),
                  SkillCard(title: 'Cleaning', icon: Icons.cleaning_services),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 🔹 Category Sections (Team Code)
            CategorySection(
              title: "Cooking",
              titleColor: Colors.orange,
              lessons: [
                LessonItem(
                  title: "Boil Pasta",
                  description: "Learn how to properly boil pasta.",
                  difficulty: "Easy",
                  duration: "5 min",
                ),
                LessonItem(
                  title: "Cook Chicken",
                  description: "Safely cook chicken on stovetop.",
                  difficulty: "Medium",
                  duration: "10 min",
                ),
              ],
            ),

            CategorySection(
              title: "Budgeting",
              titleColor: Colors.green,
              lessons: [
                LessonItem(
                  title: "Track Expenses",
                  description: "Learn to track your daily expenses.",
                  difficulty: "Easy",
                  duration: "4 min",
                ),
                LessonItem(
                  title: "Create a Budget Plan",
                  description: "Build your first monthly budget.",
                  difficulty: "Medium",
                  duration: "8 min",
                ),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}