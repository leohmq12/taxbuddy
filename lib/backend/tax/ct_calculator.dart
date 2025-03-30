class CorporateTaxCalculator {
  // Verified rates as of July 2024 (source: HMRC & Revenue Scotland)
  static final Map<String, Map<String, List<TaxBand>>> _taxRules = {
    'England': {
      '2024/2025': [
        TaxBand(maxProfit: 50000, rate: 0.19),
        TaxBand(maxProfit: 250000, rate: 0.25),
        TaxBand(maxProfit: double.infinity, rate: 0.25),
      ],
      '2025/2026': [
        TaxBand(maxProfit: 50000, rate: 0.19),
        TaxBand(maxProfit: 250000, rate: 0.25),
        TaxBand(maxProfit: double.infinity, rate: 0.25),
      ],
    },
    'Scotland': {
      '2024/2025': [
        TaxBand(maxProfit: 50000, rate: 0.19),
        TaxBand(maxProfit: 250000, rate: 0.25),
        TaxBand(maxProfit: double.infinity, rate: 0.25),
      ],
      '2025/2026': [
        TaxBand(maxProfit: 50000, rate: 0.19),
        TaxBand(maxProfit: 250000, rate: 0.25),
        TaxBand(maxProfit: double.infinity, rate: 0.25),
      ],
    },
    'Wales': {
      '2024/2025': [
        TaxBand(maxProfit: 50000, rate: 0.19),
        TaxBand(maxProfit: 250000, rate: 0.25),
        TaxBand(maxProfit: double.infinity, rate: 0.25),
      ],
      '2025/2026': [
        TaxBand(maxProfit: 50000, rate: 0.19),
        TaxBand(maxProfit: 250000, rate: 0.25),
        TaxBand(maxProfit: double.infinity, rate: 0.25),
      ],
    },
    'Northern Ireland': {
      '2024/2025': [
        TaxBand(maxProfit: 50000, rate: 0.19),
        TaxBand(maxProfit: 250000, rate: 0.25),
        TaxBand(maxProfit: double.infinity, rate: 0.25),
      ],
      '2025/2026': [
        TaxBand(maxProfit: 50000, rate: 0.19),
        TaxBand(maxProfit: 250000, rate: 0.25),
        TaxBand(maxProfit: double.infinity, rate: 0.25),
      ],
    },
  };

  static Map<String, dynamic> calculateTax({
    required String region,
    required String year,
    required double profit,
  }) {
    final bands = _taxRules[region]?[year] ?? _taxRules['England']!['2024/2025']!;
    double remainingProfit = profit;
    double totalTax = 0;

    for (final band in bands) {
      if (remainingProfit <= 0) break;

      final taxableAmount = remainingProfit.clamp(0, band.maxProfit);
      totalTax += taxableAmount * band.rate;
      remainingProfit -= band.maxProfit;
    }

    return {
      'tax': totalTax,
      'profitAfterTax': profit - totalTax,
      'effectiveRate': totalTax / profit,
      'bands': bands,
    };
  }
}

class TaxBand {
  final double maxProfit;
  final double rate;

  TaxBand({required this.maxProfit, required this.rate});
}