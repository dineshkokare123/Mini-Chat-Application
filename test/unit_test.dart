import 'package:flutter_test/flutter_test.dart';
import 'package:mini_chat_app/providers/chat_provider.dart';
import 'package:mini_chat_app/services/api_service.dart';

class MockApiService extends ApiService {
  @override
  Future<String> fetchRandomResponse() async {
    return "Mock Response";
  }
}

void main() {
  group('ChatProvider Tests', () {
    test('Initial state is empty', () {
      final provider = ChatProvider(
        apiService: MockApiService(),
        seedData: false,
      );
      expect(provider.users.isEmpty, true);
      expect(provider.sessions.isEmpty, true);
    });

    test('Add User increases user count', () {
      final provider = ChatProvider(
        apiService: MockApiService(),
        seedData: false,
      );
      provider.addUser("Alice");
      expect(provider.users.length, 1);
      expect(provider.users.first.name, "Alice");
      expect(provider.users.first.initials, "A");
    });

    test('Send message updates messages and creates session', () {
      final provider = ChatProvider(
        apiService: MockApiService(),
        seedData: false,
      );
      provider.addUser("Bob");
      final userId = provider.users.first.id;

      provider.sendMessage(userId, "Bob", "Hello");

      // Verify local message added immediately
      expect(provider.getMessages(userId).length, 1);
      expect(provider.getMessages(userId).first.text, "Hello");
      expect(provider.getMessages(userId).first.isMe, true);

      // Verify session created
      expect(provider.sessions.length, 1);
      expect(provider.sessions.first.lastMessage, "Hello");
    });
  });
}
