class VATCalculator {
  // VAT rates by region (standard rate only)
  static final Map<String, double> _vatRates = {
    'England': 0.20,
    'Scotland': 0.20,
    'Wales': 0.20,
    'Northern Ireland': 0.20,
  };

  static Map<String, double> calculateVAT({
    required String region,
    required double amount,
    required bool isInclusive,
  }) {
    final rate = _vatRates[region] ?? 0.20;
    double vatAmount;
    double netAmount;
    double grossAmount;

    if (isInclusive) {
      // VAT is included in the amount
      netAmount = amount / (1 + rate);
      vatAmount = amount - netAmount;
      grossAmount = amount;
    } else {
      // VAT needs to be added
      netAmount = amount;
      vatAmount = amount * rate;
      grossAmount = amount + vatAmount;
    }

    return {
      'netAmount': netAmount,
      'vatAmount': vatAmount,
      'grossAmount': grossAmount,
      'rate': rate,
    };
  }
}