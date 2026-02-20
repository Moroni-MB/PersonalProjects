import 'package:adultingapp/auth_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'category_section.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';


// Entry point
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        home: const AuthWrapper(),
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
        page = const QuizPage();
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


class CompletedPage extends StatelessWidget {
  const CompletedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Completed Page', style: TextStyle(fontSize: 24)),
    );
  }
}

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

// --- Reusable Option Widget ---
class OptionCard extends StatelessWidget {
  final String emoji;
  final String label;
  final VoidCallback onTap;

  const OptionCard({
    super.key,
    required this.emoji,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.black,
            width: 2.5, 
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              offset: const Offset(0, 4),
              blurRadius: 0, 
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 60), // Emoji size
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
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