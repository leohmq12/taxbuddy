class CorporateTaxCalculator {
  static Map<String, dynamic> calculate({
    required double? profitBeforeTax,
    required String taxYear,
    required String region,
  }) {
    // Default to 0 if null
    final double profit = (profitBeforeTax ?? 0).clamp(0, double.infinity);

    // Define thresholds
    const lowerLimit = 50000.0;
    const upperLimit = 250000.0;
    const mainRate = 0.25;
    const smallProfitsRate = 0.19;

    double corporationTax = 0.0;
    double marginalRelief = 0.0;
    bool marginalReliefApplied = false;

    if (profit <= lowerLimit) {
      corporationTax = profit * smallProfitsRate;
    } else if (profit > lowerLimit && profit <= upperLimit) {
      corporationTax = profit * mainRate;
      final fraction = (upperLimit - profit) / (upperLimit - lowerLimit);
      marginalRelief = fraction * (mainRate - smallProfitsRate) * profit;
      corporationTax -= marginalRelief;
      marginalReliefApplied = true;
    } else {
      corporationTax = profit * mainRate;
    }

    return {
      'taxYear': taxYear,
      'region': region,
      'profitBeforeTax': profit.toStringAsFixed(2),
      'corporationTax': corporationTax.toStringAsFixed(2),
      'marginalReliefApplied': marginalReliefApplied,
      'marginalRelief': marginalRelief.toStringAsFixed(2),
      'effectiveTaxRate': (profit == 0 ? 0 : corporationTax / profit * 100)
          .toStringAsFixed(2) + '%',
    };
  }
}