class Trip {
  final String id; // Firestore document ID
  final String destination;
  final String notes;

  Trip({required this.id, required this.destination, required this.notes});

  // Convert Trip to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'destination': destination,
      'notes': notes,
      'createdAt': DateTime.now(),
    };
  }

  // Create Trip from Firestore snapshot
  factory Trip.fromMap(String id, Map<String, dynamic> data) {
    return Trip(
      id: id,
      destination: data['destination'] ?? '',
      notes: data['notes'] ?? '',
    );
  }
}
