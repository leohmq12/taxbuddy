class CapitalGainsTaxCalculator {
  static Map<String, dynamic> calculate({
    required double saleProceeds,
    required double purchasePrice,
    required double sellingCosts,
    required double purchaseCosts,
    required String taxYear,
    required String region,
    required double taxableIncome,
    required bool isResidential,
  }) {
    // Annual Exempt Amount (AEA)
    final annualExemptAmount = 3000.0;

    // Chargeable Gain Calculation
    final chargeableGain = saleProceeds - purchasePrice - sellingCosts - purchaseCosts;
    final taxableGain = (chargeableGain - annualExemptAmount).clamp(0.0, double.infinity);

    // Capital Gains Tax Rates
    final basicRate = 0.18;  // 18% for non-residential
    final higherRate = 0.24; // 24% for non-residential

    final basicOtherRate = 0.24;  // 24% for residential property
    final higherOtherRate = 0.28; // 28% for residential property

    // UK Basic Rate Tax Band
    final basicRateBand = 50270.0;
    final remainingBasicBand = (basicRateBand - taxableIncome).clamp(0.0, basicRateBand) as double;

    // Initialize Tax Values
    double basicTax = 0.0, higherTax = 0.0;
    double basicOtherTax = 0.0, higherOtherTax = 0.0;

    if (taxableGain > 0) {
      if (taxableIncome < basicRateBand) {
        // Portion taxed at basic rate, rest at higher rate
        if (taxableGain <= remainingBasicBand) {
          if (isResidential) {
            basicOtherTax = taxableGain * basicOtherRate;
          } else {
            basicTax = taxableGain * basicRate;
          }
        } else {
          double higherTaxableAmount = taxableGain - remainingBasicBand.toDouble();

          if (isResidential) {
            basicOtherTax = remainingBasicBand * basicOtherRate;
            higherOtherTax = higherTaxableAmount * higherOtherRate;
          } else {
            basicTax = remainingBasicBand * basicRate;
            higherTax = higherTaxableAmount * higherRate;
          }
        }
      } else {
        // All taxable gain taxed at higher rate
        if (isResidential) {
          higherOtherTax = taxableGain * higherOtherRate;
        } else {
          higherTax = taxableGain * higherRate;
        }
      }
    }

    return {
      'chargeableGain': chargeableGain.toStringAsFixed(2),
      'taxableGain': taxableGain.toStringAsFixed(2),
      'basic': basicTax.toStringAsFixed(2),
      'basicOtherAssets': basicOtherTax.toStringAsFixed(2),
      'higher': higherTax.toStringAsFixed(2),
      'higherOtherAssets': higherOtherTax.toStringAsFixed(2),
      'region': region,
    };
  }
}
