import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatService {
  
  final String _apiKey = dotenv.env['API_KEY'] ?? ""; // Load API key from .env
  final String _apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";

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
              "role": "user",
              "parts": [
                {
                  "text":
                      "You are an AI Tax Assistant with expertise in global and regional tax regulations. Provide accurate and comprehensive responses on all tax-related topics, including personal and corporate taxes, VAT, compliance, deductions, international taxation, financial planning, and legal tax frameworks."
                }
              ]
            },
            {
              "role": "user",
              "parts": [
                {"text": query}
              ]
            }
          ],
          "generationConfig": {
            "maxOutputTokens": 500,
          }
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

        String chatbotResponse =
            data["candidates"][0]["content"]["parts"][0]["text"].trim();

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
