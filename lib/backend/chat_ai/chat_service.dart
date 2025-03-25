import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
class ChatService {
  final String _apiKey = dotenv.env['API_KEY'] ?? ""; // Load API key from .env
  final String _apiUrl = "https://openrouter.ai/api/v1/chat/completions";

  ChatService() {
    if (_apiKey.isEmpty) {
      print("Error: API Key is missing. Check .env file.");
    }
  }

  Future<String> getResponse(String userMessage) async {
    if (!_isTaxRelated(userMessage)) {
      return "I can only assist with UK tax-related queries. Please ask about taxes in the UK.";
    }
    return await _fetchAIResponse(userMessage);
  }

  Future<String> fetchTaxContentFromAI(String topic) async {
    return await _fetchAIResponse("Explain $topic in simple terms.");
  }

  Future<String> _fetchAIResponse(String query) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "deepseek/deepseek-chat-v3-0324:free",
          "messages": [
            {
              "role": "system",
              "content": "You are an AI Tax Assistant specialized in UK taxes. Only respond to queries related to UK taxation laws, VAT, Self Assessment, expenses, and other tax-related topics in the UK."
            },
            {"role": "user", "content": query},
          ],
          "max_tokens": 1000,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        String chatbotResponse = data["choices"][0]["message"]["content"].trim();

        // 🔴 REMOVE Markdown Symbols (`#`, `*`, `_`, etc.)
        chatbotResponse = chatbotResponse.replaceAll(RegExp(r'[#*_]'), '');
        return chatbotResponse;
      } else {
        print("Error: ${response.statusCode}, Response: ${utf8.decode(response.bodyBytes)}");
        return "Error: Unable to fetch response. Please try again later.";
      }
    } catch (e) {
      print("Exception: $e");
      return "Error: Something went wrong. Please check your connection.";
    }
  }

  bool _isTaxRelated(String query) {
    List<String> keywords = [
      "tax", "VAT", "HMRC", "Self Assessment", "income tax", "corporation tax", "capital gains tax", "National Insurance", "tax return"
    ];
    return keywords.any((word) => query.toLowerCase().contains(word));
  }

  Future<Uint8List?> getSpeech(String text) async {
    return null;
  }
}
