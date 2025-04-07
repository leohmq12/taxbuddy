class SelfEmploymentCalculator {
  static Map<String, dynamic> calculate({
    required String region,
    required double profit,
    required String taxYear,
  }) {
    // Validate input
    profit = profit < 0 ? 0 : profit;
    final is2025 = taxYear == '2025/2026';

    // 1. Calculate Income Tax (region-specific)
    final incomeTax = _calculateIncomeTax(region, profit, is2025);

    // 2. Calculate NICs (UK-wide)
    final nics = _calculateNICs(profit, is2025);

    // 3. Return all values needed for UI
    return {
      'year': taxYear,
      'grossProfit': profit,
      'incomeTax': incomeTax.tax,
      'class2Nics': nics.class2,
      'class4Nics': nics.class4,
      'netProfit': profit - incomeTax.tax - nics.class2 - nics.class4,
      'taxBands': incomeTax.bands,
    };
  }

  // ========= INCOME TAX CALCULATION =========
  static ({double tax, List<TaxBand> bands}) _calculateIncomeTax(
      String region, double profit, bool is2025) {
    final bands = _getTaxBands(region, is2025);
    double allowance = _calculatePersonalAllowance(profit);
    double taxable = (profit - allowance).clamp(0, double.infinity);
    double tax = 0;

    for (final band in bands) {
      if (taxable <= 0) break;
      final amountInBand = taxable.clamp(0, band.max);
      tax += amountInBand * band.rate;
      taxable -= amountInBand;
    }

    return (tax: tax, bands: bands);
  }

  static List<TaxBand> _getTaxBands(String region, bool is2025) {
    // Updated rates for 2024/2025 and 2025/2026
    switch (region) {
      case 'Scotland':
        return [
          TaxBand(max: 14876 - 12570, rate: 0.19),
          TaxBand(max: 26561 - 14876, rate: 0.20),
          TaxBand(max: 43662 - 26561, rate: 0.21),
          TaxBand(max: 125140 - 43662, rate: 0.42),
          TaxBand(max: double.infinity, rate: 0.47),
        ];
      default: // England, Wales, NI
        return [
          TaxBand(max: 50270 - 12570, rate: 0.20),
          TaxBand(max: 125140 - 50270, rate: 0.40),
          TaxBand(max: double.infinity, rate: 0.45),
        ];
    }
  }

  static double _calculatePersonalAllowance(double profit) {
    const double basicAllowance = 12570.0;
    if (profit <= 100000) return basicAllowance;
    return (basicAllowance - (profit - 100000) / 2).clamp(0, basicAllowance).toDouble();
  }

  // ========= NICs CALCULATION =========
  static ({double class2, double class4}) _calculateNICs(double profit, bool is2025) {
    // From April 2024 onward, Class 2 NICs are abolished for most
    double class2 = 0;

    // Corrected Class 4 rates
    final class4LowerRate = 0.06; // As per 2024/25 and projected 2025/26
    final class4UpperRate = 0.02;

    double class4 = 0;

    if (profit > 12570) {
      final lowerBand = (profit > 50270) ? 50270 : profit;
      class4 = (lowerBand - 12570) * class4LowerRate;
      if (profit > 50270) {
        class4 += (profit - 50270) * class4UpperRate;
      }
    }

    return (class2: class2, class4: class4);
  }
}

class TaxBand {
  final double max;
  final double rate;
  TaxBand({required this.max, required this.rate});
}
