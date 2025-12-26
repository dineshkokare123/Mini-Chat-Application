import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

class ApiService {
  // Using dummyjson comments as they are reliable text sources
  final String _baseUrl = 'https://dummyjson.com/comments';

  Future<String> fetchRandomResponse() async {
    try {
      // Fetch a batch of comments and pick one randomly to simulate variety
      // Or use skip for more randomness if needed, but for mini app simple get is fine
      // limit=30 giving us 30 options
      final response = await http.get(Uri.parse('$_baseUrl?limit=30'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List comments = data['comments'];
        if (comments.isNotEmpty) {
          final random = Random();
          final randomComment = comments[random.nextInt(comments.length)];
          return randomComment['body'] ?? "Interesting point!";
        }
      }
      return "I see.";
    } catch (e) {
      debugPrint("Error fetching API: $e");
      return "That's cool!"; // Fallback
    }
  }

  Future<String> fetchWordDefinition(String word) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word'),
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        if (data.isNotEmpty) {
          final meanings = data[0]['meanings'] as List;
          if (meanings.isNotEmpty) {
            final firstMeaning = meanings[0];
            final partOfSpeech = firstMeaning['partOfSpeech'] ?? 'unknown';
            final definitions = firstMeaning['definitions'] as List;
            if (definitions.isNotEmpty) {
              final def = definitions[0]['definition'];
              return "$partOfSpeech: $def";
            }
          }
        }
      }
      return "No definition found.";
    } catch (e) {
      debugPrint("Error fetching definition: $e");
      return "Could not fetch definition.";
    }
  }
}
