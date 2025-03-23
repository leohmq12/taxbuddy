import 'package:url_launcher/url_launcher.dart';

class SearchService {
  /// Opens a web search for UK tax-related queries
  static Future<void> searchUKTax(String query) async {
    // Ensure query is related to UK taxes
    if (!_isRelevantQuery(query)) {
      print("Invalid search query. Only UK tax-related searches are allowed.");
      return;
    }

    final Uri searchUrl = Uri.parse('https://www.google.com/search?q=${Uri.encodeComponent(query + " UK tax")}');

    if (await canLaunchUrl(searchUrl)) {
      await launchUrl(searchUrl, mode: LaunchMode.externalApplication);
    } else {
      print('Could not launch $searchUrl');
      throw 'Could not launch $searchUrl';
    }
  }

  /// Checks if the query is relevant to UK tax
  static bool _isRelevantQuery(String query) {
    final List<String> allowedKeywords = [
      'self assessment', 'VAT', 'business tax', 'tax credits', 'PAYE',
      'corporation tax', 'income tax', 'capital gains tax', 'inheritance tax'
    ];

    return allowedKeywords.any((keyword) => query.toLowerCase().contains(keyword));
  }
}
