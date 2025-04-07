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
    final personalAllowance = hasSalaryInput ? 12570.0 : 0; // Personal allowance
    final dividendAllowance = hasDividendsInput ? 500.0 : 0; // Dividend allowance

    // Tax band thresholds (unchanged)
    const basicRateThreshold = 50270.0; // Threshold for basic rate
    const higherRateThreshold = 125140.0; // Threshold for higher rate

    // Calculations
    final taxableSalary = (salary - personalAllowance).clamp(0, double.infinity); // Taxable salary (after personal allowance)
    final taxableDividends = (dividends - dividendAllowance).clamp(0, double.infinity); // Taxable dividends (after dividend allowance)

    // Initialize all tax values
    double basicIncomeTax = 0;
    double higherIncomeTax = 0;
    double additionalIncomeTax = 0;
    double basicDividendTax = 0;
    double higherDividendTax = 0;
    double additionalDividendTax = 0;

    // Only calculate if there's taxable salary
    if (taxableSalary > 0) {
      // Income tax calculation based only on salary
      final basicBand = (taxableSalary <= basicRateThreshold)
          ? taxableSalary
          : basicRateThreshold;
      basicIncomeTax = basicBand * 0.20;

      if (taxableSalary > basicRateThreshold) {
        final higherBand = (taxableSalary <= higherRateThreshold)
            ? taxableSalary - basicRateThreshold
            : higherRateThreshold - basicRateThreshold;
        higherIncomeTax = higherBand * 0.40;

        if (taxableSalary > higherRateThreshold) {
          additionalIncomeTax = (taxableSalary - higherRateThreshold) * 0.45;
        }
      }
    }

    // Dividend tax calculation based on overall income bands (salary + dividends)
    final totalIncome = salary + dividends; // Total income for dividend tax bands
    final taxableTotalIncome = (totalIncome - personalAllowance).clamp(0, double.infinity);

    if (taxableDividends > 0) {
      if (taxableTotalIncome <= basicRateThreshold) {
        basicDividendTax = taxableDividends * 0.0875; // Basic dividend tax rate
      }
      else if (taxableTotalIncome <= higherRateThreshold) {
        higherDividendTax = taxableDividends * 0.3375; // Higher dividend tax rate
      }
      else {
        additionalDividendTax = taxableDividends * 0.3935; // Additional dividend tax rate
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
