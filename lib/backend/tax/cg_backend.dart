class CapitalGainsTaxCalculator {
  static Map<String, dynamic> calculate({
    required double saleProceeds,
    required double purchasePrice,
    required double sellingCosts,
    required double purchaseCosts,
    required String taxYear,
    required String region,
    double remainingBasicRateBand = 20000, // You can customize this
  }) {
    // Annual Exempt Amount (AEA)
    final annualExemptAmount = 3000.0;

    // Chargeable and Taxable Gain
    final chargeableGain = saleProceeds - purchasePrice - sellingCosts - purchaseCosts;
    final taxableGain = (chargeableGain - annualExemptAmount).clamp(0.0, double.infinity);

    // 2024/25 CGT rates
    final basicRateResidential = 0.18;
    final higherRateResidential = 0.24; // 24% from April 2024
    final basicRateOther = 0.10;
    final higherRateOther = 0.20;

    // Split into basic and higher band portions
    final basicPortion = taxableGain.clamp(0, remainingBasicRateBand);
    final higherPortion = (taxableGain - basicPortion).clamp(0.0, double.infinity);

    // Apply rates
    final basicResidential = basicPortion * basicRateResidential;
    final higherResidential = higherPortion * higherRateResidential;

    final basicOther = basicPortion * basicRateOther;
    final higherOther = higherPortion * higherRateOther;

    return {
      'chargeableGain': chargeableGain.toStringAsFixed(2),
      'taxableGain': taxableGain.toStringAsFixed(2),
      'basic': basicResidential.toStringAsFixed(2),
      'basicOtherAssets': basicOther.toStringAsFixed(2),
      'higher': higherResidential.toStringAsFixed(2),
      'higherOtherAssets': higherOther.toStringAsFixed(2),
      'region': region,
    };
  }
}
