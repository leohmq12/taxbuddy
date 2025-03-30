class DividendTaxCalculator {
  static Map<String, dynamic> calculate({
    required double salary,
    required double dividends,
    required String taxYear,
    required String region,
  }) {
    // Default to 0 when no inputs
    final hasSalaryInput = salary > 0;
    final hasDividendsInput = dividends > 0;

    // Dynamic allowances
    final personalAllowance = hasSalaryInput ? 12570.0 : 0;
    final dividendAllowance = hasDividendsInput ? 500.0 : 0;

    // Tax band thresholds (unchanged)
    const basicRateThreshold = 50270.0;
    const higherRateThreshold = 125140.0;

    // Calculations
    final totalIncome = salary + dividends;
    final taxableIncome = (totalIncome - personalAllowance).clamp(0, double.infinity);
    final taxableDividends = (dividends - dividendAllowance).clamp(0, double.infinity);

    // Initialize all tax values
    double basicIncomeTax = 0;
    double higherIncomeTax = 0;
    double additionalIncomeTax = 0;
    double basicDividendTax = 0;
    double higherDividendTax = 0;
    double additionalDividendTax = 0;

    // Only calculate if there's taxable income
    if (taxableIncome > 0) {
      // Income tax calculation
      final basicBand = (taxableIncome <= basicRateThreshold)
          ? taxableIncome
          : basicRateThreshold;
      basicIncomeTax = basicBand * 0.20;

      if (taxableIncome > basicRateThreshold) {
        final higherBand = (taxableIncome <= higherRateThreshold)
            ? taxableIncome - basicRateThreshold
            : higherRateThreshold - basicRateThreshold;
        higherIncomeTax = higherBand * 0.40;

        if (taxableIncome > higherRateThreshold) {
          additionalIncomeTax = (taxableIncome - higherRateThreshold) * 0.45;
        }
      }

      // Dividend tax calculation
      if (taxableDividends > 0) {
        if (taxableIncome <= basicRateThreshold) {
          basicDividendTax = taxableDividends * 0.0875;
        }
        else if (taxableIncome <= higherRateThreshold) {
          higherDividendTax = taxableDividends * 0.3375;
        }
        else {
          additionalDividendTax = taxableDividends * 0.3935;
        }
      }
    }

    return {
      'personalAllowance': personalAllowance,
      'dividendAllowance': dividendAllowance,

      // Income Tax
      'basicIncomeTax': basicIncomeTax.toStringAsFixed(2),
      'higherIncomeTax': higherIncomeTax.toStringAsFixed(2),
      'additionalIncomeTax': additionalIncomeTax.toStringAsFixed(2),
      'totalIncomeTax': (basicIncomeTax + higherIncomeTax + additionalIncomeTax).toStringAsFixed(2),

      // Dividend Tax
      'basicDividendTax': basicDividendTax.toStringAsFixed(2),
      'higherDividendTax': higherDividendTax.toStringAsFixed(2),
      'additionalDividendTax': additionalDividendTax.toStringAsFixed(2),
      'totalDividendTax': (basicDividendTax + higherDividendTax + additionalDividendTax).toStringAsFixed(2),
    };
  }
}