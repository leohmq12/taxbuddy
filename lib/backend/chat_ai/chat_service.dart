import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:taxbuddy/flutter_dotenv/flutter_dotenv.dart';

class ChatService {
  final String _apiKey = dotenv.env['OPENAI_API_KEY'] ?? "";// Use a placeholder for testing
  final String _apiUrl = "https://api.openai.com/v1/chat/completions";
  final String _ttsUrl = "https://api.openai.com/v1/audio/speech";

  Future<String> getResponse(String userMessage) async {
    if (!_isTaxRelated(userMessage)) {
      return "I can only assist with UK tax-related queries. Please ask about taxes in the UK.";
    }

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "gpt-4",
          "messages": [
            {"role": "system", "content": "You are an AI Tax Assistant specialized in UK taxes. Only respond to queries related to UK taxation laws, VAT, Self Assessment, expenses, and other tax-related topics in the UK."},
            {"role": "user", "content": userMessage},
          ],
          "max_tokens": 300,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data["choices"][0]["message"]["content"].trim();
      } else {
        print("Error: ${response.statusCode}, Response: ${response.body}");
        return "Error: Unable to fetch response. Please try again later.";
      }
    } catch (e) {
      return "Error: Something went wrong. Please check your connection.";
    }
  }

  Future<Uint8List?> getSpeech(String text) async {
    try {
      final response = await http.post(
        Uri.parse(_ttsUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "tts-1",
          "input": text,
          "voice": "alloy",
        }),
      );

      if (response.statusCode == 200) {
        return response.bodyBytes; // Returns audio data
      } else {
        print("Error: ${response.statusCode}, Response: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }

  bool _isTaxRelated(String query) {
    List<String> keywords = [
      "tax", "VAT", "HMRC", "Self Assessment", "income tax", "corporation tax", "capital gains tax", "National Insurance", "tax return"
    ];
    return keywords.any((word) => query.toLowerCase().contains(word));
  }
}
