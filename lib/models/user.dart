import 'package:uuid/uuid.dart';

class User {
  final String id;
  final String name;
  final bool isOnline;
  final String? lastActive;

  User({
    required this.id,
    required this.name,
    this.isOnline = false,
    this.lastActive,
  });

  String get initials {
    if (name.isEmpty) return "?";
    List<String> parts = name.trim().split(" ");
    if (parts.length > 1) {
      return "${parts[0][0]}${parts[1][0]}".toUpperCase();
    }
    return name[0].toUpperCase();
  }

  factory User.create({required String name}) {
    // Default new users to online for now
    return User(
      id: const Uuid().v4(),
      name: name,
      isOnline: true,
      lastActive: "Online",
    );
  }
}
