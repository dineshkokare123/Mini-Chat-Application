class ChatSession {
  final String contactId;
  final String contactName;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  ChatSession({
    required this.contactId,
    required this.contactName,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
  });

  String get initials {
    if (contactName.isEmpty) return "?";
    List<String> parts = contactName.trim().split(" ");
    if (parts.length > 1) {
      return "${parts[0][0]}${parts[1][0]}".toUpperCase();
    }
    return contactName[0].toUpperCase();
  }
}
