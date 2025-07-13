class UserProfile {
  final String id;
  final String email;

  UserProfile({
    required this.id,
    required this.email,
  });

  // Create a User profile from Firestore
  factory UserProfile.fromFirestore(Map<String, dynamic> data, String id) {
    return UserProfile(
      id: id,
      email: data['email'] ?? '',
      );
  }

  // Convert a UserProfile to a Firestore map (for saving)
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
    };
  }
}