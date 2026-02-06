import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/trip.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseUIAuth.configureProviders([EmailAuthProvider()]);

  runApp(const MyApp());
}

// Entry point
// void main() {
//   runApp(const MyApp());
// }

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<fb_auth.User?>(
      stream: fb_auth.FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            providers: [
              EmailAuthProvider(), // ✅ firebase_ui_auth one
            ],
          );
        }

        return const MyHomePage();
      },
    );
  }
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
        title: 'iTravel',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        // home: const MyHomePage(),
        home: const AuthGate(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  final List<Trip> trips = [];
  late StreamSubscription tripsSubscription;

  // Firestore reference
  final CollectionReference tripsRef = FirebaseFirestore.instance.collection(
    'trips',
  );

  // Add a new trip to Firestore
  Future<void> addTrip(String destination, String notes) async {
    final user = fb_auth.FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await tripsRef.add({
      'destination': destination,
      'notes': notes,
      'createdAt': Timestamp.now(),
      'uid': user.uid, // 🔐 ownership
    });
  }

  // Remove a trip from Firestore
  Future<void> removeTrip(int index) async {
    final trip = trips[index];
    await tripsRef.doc(trip.id).delete();
  }

  void listenToTrips() {
    tripsSubscription = tripsRef.orderBy('createdAt').snapshots().listen((
      snapshot,
    ) {
      trips.clear();
      for (var doc in snapshot.docs) {
        trips.add(Trip.fromMap(doc.id, doc.data() as Map<String, dynamic>));
      }
      notifyListeners();
    });
  }

  void cancelTripsListener() {
    tripsSubscription.cancel();
  }
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
        page = const TripsPage();
        break;
      default:
        page = const HomePage();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('iTravel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: () async {
              await fb_auth.FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.favorite),
                  label: Text('Trips'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
            ),
          ),
        ],
      ),
    );
  }
}

// -------- Pages --------

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final tripsRef = FirebaseFirestore.instance.collection('trips');
    final defaultImg = "assets/travel_plane.webp";

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'iTravel',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add a destination and plan your trips',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Input fields
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Type a destination',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            // Add Trip button
            ElevatedButton(
              onPressed: () async {
                final user = fb_auth.FirebaseAuth.instance.currentUser;
                if (user == null) return;
                if (_controller.text.trim().isEmpty) return;

                await tripsRef.add({
                  'destination': _controller.text,
                  'notes': _notesController.text,
                  'createdAt': Timestamp.now(),
                  'uid': user.uid,
                });

                _controller.clear();
                _notesController.clear();
              },
              child: const Text('Add Trip'),
            ),

            const SizedBox(height: 20),

            // Display trips using StreamBuilder
            Expanded(
              child: Builder(
                builder: (context) {
                  final user = fb_auth.FirebaseAuth.instance.currentUser;

                  if (user == null) {
                    return const Center(child: Text('Not signed in'));
                  }

                  return StreamBuilder<QuerySnapshot>(
                    stream: tripsRef
                        .where('uid', isEqualTo: user.uid)
                        .orderBy('createdAt')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final docs = snapshot.data!.docs;

                      if (docs.isEmpty) {
                        return const Center(
                          child: Text(
                            'No trips yet!',
                            style: TextStyle(fontSize: 18),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final doc = docs[index];
                          final trip = Trip.fromMap(
                            doc.id,
                            doc.data() as Map<String, dynamic>,
                          );

                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  defaultImg,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(trip.destination),
                              subtitle: Text(trip.notes),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  tripsRef.doc(doc.id).delete();
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _notesController.dispose();
    super.dispose();
  }
}

class TripsPage extends StatelessWidget {
  const TripsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tripsRef = FirebaseFirestore.instance.collection('trips');
    final user = fb_auth.FirebaseAuth.instance.currentUser;

    // 🚫 Safety check (should never happen because of AuthGate, but good practice)
    if (user == null) {
      return const Center(child: Text('Not signed in'));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: tripsRef
            .where('uid', isEqualTo: user.uid)
            .orderBy('createdAt')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                'No trips added yet!',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final trip = Trip.fromMap(
                doc.id,
                doc.data() as Map<String, dynamic>,
              );

              return ListTile(
                leading: const Icon(Icons.flight),
                title: Text(trip.destination),
                subtitle: Text(trip.notes),
              );
            },
          );
        },
      ),
    );
  }
}




// class Trip {
//   final String destination;
//   final String notes;
//   final String imgPath;

//   Trip({
//     required this.destination,
//     required this.notes,
//     required this.imgPath,
//   });
// }