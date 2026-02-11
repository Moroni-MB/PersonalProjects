import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'category_section.dart';

// Entry point
void main() {
  runApp(const MyApp());
}

// Root widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Menu Scaffold App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

// App-wide state (empty for now)
class MyAppState extends ChangeNotifier {
  // Add shared state later if needed
}

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

// -------- Empty Pages --------

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Page title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Adulting App',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

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


class CompletedPage extends StatelessWidget {
  const CompletedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Completed Page', style: TextStyle(fontSize: 24)),
    );
  }
}


class SkillCard extends StatelessWidget{
  final String title;
  final IconData icon;

  const SkillCard({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SizedBox(
          width: 160,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}