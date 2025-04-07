class CapitalGainsTaxCalculator {
  static Map<String, dynamic> calculate({
    required double saleProceeds,
    required double purchasePrice,
    required double sellingCosts,
    required double purchaseCosts,
    required String taxYear,
    required String region,
  }) {
    // Annual Exempt Amount (AEA)
    final annualExemptAmount = 3000.0;

    // Chargeable Gain Calculation
    final chargeableGain = saleProceeds - purchasePrice - sellingCosts - purchaseCosts;
    final taxableGain = (chargeableGain - annualExemptAmount).clamp(0.0, double.infinity);

    // UK CGT Rates (HMRC Compliant)
    final basicRateResidential = 0.18; // 18% for residential (basic rate)
    final higherRateResidential = 0.28; // 28% for residential (higher rate)
    final basicRateOther = 0.10;       // 10% for other assets (basic rate)
    final higherRateOther = 0.20;      // 20% for other assets (higher rate)

    // Since we don't have taxpayer income, assume higher rate applies (as per your request)
    final higherResidential = taxableGain * higherRateResidential; // 28%
    final higherOther = taxableGain * higherRateOther;             // 20%

    // Your existing basic rate logic (unchanged)
    final basicResidential = taxableGain * basicRateResidential; // 18%
    final basicOther = taxableGain * basicRateOther;             // 10%

    return {
      'chargeableGain': chargeableGain.toStringAsFixed(2),
      'taxableGain': taxableGain.toStringAsFixed(2),
      'basic': basicResidential.toStringAsFixed(2),       // 18% (residential)
      'basicOtherAssets': basicOther.toStringAsFixed(2),  // 10% (other assets)
      'higher': higherResidential.toStringAsFixed(2),     // 28% (residential)
      'higherOtherAssets': higherOther.toStringAsFixed(2), // 20% (other assets)
      'region': region,
    };
  }
}