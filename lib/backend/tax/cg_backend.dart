class CapitalGainsTaxCalculator {
  static Map<String, dynamic> calculate({
    required double saleProceeds,
    required double purchasePrice,
    required double sellingCosts,
    required double purchaseCosts,
    required String taxYear,
    required String region, // Not used (rates are UK-wide)
    required double taxableIncome,
  }) {
    // Annual exempt amount (2024/2025: £3,000; 2025/2026: £1,500)
    final annualExemptAmount = taxYear == '2024/2025' ? 3000.0 : 1500.0;

    // Calculate chargeable gain
    final chargeableGain = saleProceeds - purchasePrice - sellingCosts - purchaseCosts;
    final taxableGain = (chargeableGain - annualExemptAmount).clamp(0, double.infinity);

    // CGT rates for non-residential assets (UK-wide)
    final basicRate = 0.10; // 10% for basic-rate taxpayers
    final higherRate = 0.20; // 20% for higher-rate taxpayers

    // Determine tax bands (2024/2025 & 2025/2026 thresholds)
    final basicRateBand = 50270.0;
    final remainingBasicBand = (basicRateBand - taxableIncome).clamp(0, basicRateBand);

    double basicTax = 0.0;
    double higherTax = 0.0;

    if (taxableIncome >= basicRateBand) {
      // Entire gain taxed at higher rate (20%)
      higherTax = taxableGain * higherRate;
    } else if (taxableIncome + taxableGain <= basicRateBand) {
      // Entire gain taxed at basic rate (10%)
      basicTax = taxableGain * basicRate;
    } else {
      // Part basic rate (10%), part higher rate (20%)
      basicTax = remainingBasicBand * basicRate;
      higherTax = (taxableGain - remainingBasicBand) * higherRate;
    }

    return {
      'chargeableGain': chargeableGain.toStringAsFixed(2),
      'taxableGain': taxableGain.toStringAsFixed(2),
      'basic': basicTax.toStringAsFixed(2),       // 10% (non-residential)
      'basicOtherAssets': '0.00',                 // Not applicable (residential excluded)
      'higher': higherTax.toStringAsFixed(2),     // 20% (non-residential)
      'higherOtherAssets': '0.00',               // Not applicable (residential excluded)
      'region': region, // For reference (unused)
    };
  }
}