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

    // Capital Gains Tax Rates
    final basicRate = 0.18;  // 18% for basic rate
    final higherRate = 0.24; // 24% for higher rate

    // UK Basic Rate Tax Band
    final basicRateBand = 50270.0;

    // Initialize Tax Values
    double basicTax = 0.0, higherTax = 0.0;
    double basicOtherTax = 0.0, higherOtherTax = 0.0;

    // We first check if taxableGain > 0 to calculate tax
    if (taxableGain > 0) {
      if (taxableGain <= basicRateBand) {
        // Entire gain fits within the basic rate band
        basicTax = taxableGain * basicRate;
        basicOtherTax = taxableGain * basicRate; // Same for other assets
      } else {
        // Portion of gain falls under basic rate and the rest under higher rate
        double higherTaxableAmount = taxableGain - basicRateBand;

        // Basic tax calculation
        basicTax = basicRateBand * basicRate;
        basicOtherTax = basicRateBand * basicRate; // Same for other assets

        // Now we apply the remaining amount to the higher tax rate
        higherTax = higherTaxableAmount * higherRate;
        higherOtherTax = higherTaxableAmount * higherRate; // Same for other assets
      }
    }

    // Return values
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
