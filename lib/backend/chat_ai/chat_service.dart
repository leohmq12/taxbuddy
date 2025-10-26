import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatService {
  taxbuddy api key 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
api: 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

curl https://openrouter.ai/api/v1/chat/completions \

final String _apiKey = dotenv.env['API_KEY'] ?? ""; // Load API key from .env
final String _apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent";

ChatService() {
  if (_apiKey.isEmpty) {
    print("Error: API Key is missing. Check .env file.");
  }
}

Future<String> getResponse(String userMessage) async {
  return await _fetchAIResponse(userMessage);
}

Future<String> fetchTaxContentFromAI(String topic) async {
  return await _fetchAIResponse("Explain $topic in simple terms.");
}

Future<String> _fetchAIResponse(String query) async {
  try {
    final response = await http.post(
      Uri.parse('$_apiUrl?key=$_apiKey'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": "You are an AI Tax Assistant with expertise in global and regional tax regulations. Provide accurate and comprehensive responses on all tax-related topics, including personal and corporate taxes, VAT, compliance, deductions, international taxation, financial planning, and legal tax frameworks."}
            ]
          },
          {
            "parts": [
              {"text": query}
            ]
          }
        ],
        "generationConfig": {
          "maxOutputTokens": 750,
        }
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

  Future<Uint8List?> getSpeech(String text) async {
    return null;
  }
}
