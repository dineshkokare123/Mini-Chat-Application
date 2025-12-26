import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/user.dart';
import '../models/message.dart';
import '../models/chat_session.dart';
import '../services/api_service.dart';

class ChatProvider with ChangeNotifier {
  final ApiService _apiService;

  ChatProvider({ApiService? apiService, bool seedData = true})
    : _apiService = apiService ?? ApiService() {
    if (seedData) {
      _seedDummyData();
    }
  }

  ApiService get apiService => _apiService;

  // List of contacts/users added
  final List<User> _users = [];

  // Chat history sessions
  final List<ChatSession> _sessions = [];

  // Map of messages by user ID
  final Map<String, List<Message>> _messages = {};

  List<User> get users => List.unmodifiable(_users);
  List<ChatSession> get sessions => List.unmodifiable(_sessions);

  // Get messages for a specific user conversation
  List<Message> getMessages(String userId) {
    return _messages[userId] ?? [];
  }

  void addUser(String name) {
    final newUser = User.create(name: name);
    _users.insert(0, newUser); // Add to top
    notifyListeners();
  }

  Future<void> sendMessage(String userId, String userName, String text) async {
    // 1. Add local message
    final userMessage = Message.create(
      text: text,
      isMe: true,
      senderName: "Me",
    );
    _addMessageSafely(userId, userMessage);
    _updateSession(userId, userName, userMessage);
    notifyListeners();

    // 2. Simulate delay and fetch reply
    await Future.delayed(const Duration(seconds: 1));

    // 3. Fetch from API
    final replyText = await _apiService.fetchRandomResponse();

    final replyMessage = Message.create(
      text: replyText,
      isMe: false,
      senderName: userName,
    );
    _addMessageSafely(userId, replyMessage);
    _updateSession(userId, userName, replyMessage, incrementUnread: false);
    // Usually incoming messages increment unread, but since we are "in" the chat, we assume read?
    // For this specific UI requirement, let's keep it simple.

    notifyListeners();
  }

  void _addMessageSafely(String userId, Message msg) {
    if (!_messages.containsKey(userId)) {
      _messages[userId] = [];
    }
    _messages[userId]!.add(msg);
  }

  void _updateSession(
    String userId,
    String userName,
    Message lastMsg, {
    bool incrementUnread = false,
  }) {
    final index = _sessions.indexWhere((s) => s.contactId == userId);
    int currentUnread = 0;

    if (index != -1) {
      currentUnread = _sessions[index].unreadCount;
      _sessions.removeAt(index);
    }

    if (incrementUnread) {
      currentUnread++;
    }

    final newSession = ChatSession(
      contactId: userId,
      contactName: userName,
      lastMessage: lastMsg.text,
      lastMessageTime: lastMsg.timestamp,
      unreadCount: currentUnread,
    );

    _sessions.insert(0, newSession);
  }

  void _seedDummyData() {
    final dummyUsers = [
      (
        "Alice Johnson",
        "See you tomorrow!",
        2,
        DateTime.now().subtract(const Duration(minutes: 2)),
      ),
      (
        "Bob Smith",
        "Thanks for the help",
        0,
        DateTime.now().subtract(const Duration(minutes: 10)),
      ),
      (
        "Carol Williams",
        "Let's catch up soon",
        1,
        DateTime.now().subtract(const Duration(hours: 1)),
      ),
      (
        "David Brown",
        "Got it, thanks!",
        0,
        DateTime.now().subtract(const Duration(hours: 3)),
      ),
      (
        "Emma Davis",
        "Perfect, see you then",
        0,
        DateTime.now().subtract(const Duration(hours: 5)),
      ),
      (
        "Frank Miller",
        "That sounds great",
        0,
        DateTime.now().subtract(const Duration(days: 1)),
      ),
      (
        "Grace Wilson",
        "I'll check it out",
        0,
        DateTime.now().subtract(const Duration(days: 1)),
      ),
      (
        "Henry Moore",
        "2 days ago",
        0,
        DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];

    // Duplicate data to ensure list is long enough to scroll
    for (int i = 0; i < 3; i++) {
      for (var data in dummyUsers) {
        final id = const Uuid().v4();
        final name = data.$1;
        final msgWithIds = Message.create(
          text: data.$2,
          isMe: false,
          senderName: name,
        );

        // Logic to determine online/time status based on dummy data
        // For exact match to image:
        // Alice: Online
        // Bob: 2 min ago
        // Carol: Online
        // David: 1 hour ago
        // Emma: Online
        // Frank: 5 min ago
        // Grace: Online

        bool isOnline = [0, 2, 4, 6].contains(
          dummyUsers.indexOf(data),
        ); // Indexes for Alice, Carol, Emma, Grace
        String lastActive;

        if (isOnline) {
          lastActive = "Online";
        } else {
          // Manually mapping to image for perfection
          if (name.contains("Bob")) {
            lastActive = "2 min ago";
          } else if (name.contains("David")) {
            lastActive = "1 hour ago";
          } else if (name.contains("Frank")) {
            lastActive = "5 min ago";
          } else if (name.contains("Henry")) {
            lastActive = "2 days ago";
          } else {
            lastActive = "Offline";
          }
        }

        // Add to users
        _users.add(
          User(id: id, name: name, isOnline: isOnline, lastActive: lastActive),
        );

        // Add to messages (dummy)
        _messages[id] = [msgWithIds];

        // Add to sessions
        _sessions.add(
          ChatSession(
            contactId: id,
            contactName: name,
            lastMessage: data.$2,
            lastMessageTime: data.$4,
            unreadCount: data.$3,
          ),
        );
      }
    }
  }
}
