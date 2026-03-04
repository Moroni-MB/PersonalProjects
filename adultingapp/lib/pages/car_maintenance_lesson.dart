import 'package:flutter/material.dart';

class CarMaintenanceLessonPage extends StatelessWidget {
  const CarMaintenanceLessonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Basic Car Maintenance"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Hero Icon
              Center(
                child: Icon(
                  Icons.directions_car,
                  size: 80,
                  color: Colors.blue.shade600,
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Basic Car Maintenance Guide",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              _buildSection(
                title: "🛢 Oil Changes",
                content: "Change your oil every 5,000–7,500 miles. "
                    "Check oil level monthly using the dipstick.",
              ),

              _buildSection(
                title: "🚗 Tire Pressure",
                content: "Check tire pressure monthly. "
                    "Underinflated tires reduce fuel efficiency and wear faster.",
              ),

              _buildSection(
                title: "🔋 Battery Care",
                content: "Most batteries last 3–5 years. "
                    "Watch for slow engine starts or dim headlights.",
              ),

              _buildSection(
                title: "🛑 Brake Inspection",
                content: "If you hear squeaking or grinding, get brakes checked immediately.",
              ),

              const SizedBox(height: 40),

              // Start Quiz Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/quiz');
                  },
                  child: const Text(
                    "Take Quiz",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}