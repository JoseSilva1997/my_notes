class ToDo {
  final String id;
  final String title;
  final bool isDone;


  ToDo ({
    required this.id,
    required this.title,
    required this.isDone,
  });

  // Create a ToDo from Firestore document
  factory ToDo.fromFirestore(Map<String, dynamic> data, String id) {
    return ToDo(
      id: id,
      title: data['title'] ?? '',
      isDone: data['isDone']  ?? false,
    );
  }

  // Convert a ToDo to a Firestore map (for saving)
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'isDone': isDone,
    };
  }
}