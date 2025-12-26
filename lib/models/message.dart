import 'package:uuid/uuid.dart';

class Message {
  final String id;
  final String text;
  final DateTime timestamp;
  final bool isMe; // True if sent by the user, False if received
  final String senderName; // To display initials/name

  Message({
    required this.id,
    required this.text,
    required this.timestamp,
    required this.isMe,
    required this.senderName,
  });

  factory Message.create({
    required String text,
    required bool isMe,
    required String senderName,
  }) {
    return Message(
      id: const Uuid().v4(),
      text: text,
      timestamp: DateTime.now(),
      isMe: isMe,
      senderName: senderName,
    );
  }
}
