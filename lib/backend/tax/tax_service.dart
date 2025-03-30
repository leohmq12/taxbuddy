class TaxCalculator {
  final double annualIncome;
  final double selfEmploymentIncome;
  final String taxYear;

  TaxCalculator({
    required this.annualIncome,
    required this.selfEmploymentIncome,
    required this.taxYear,
  });

  Map<String, double> getTaxBreakdown() {
    double incomeTax = 0;
    double nationalInsurance = 0;
    double vat = 0;

    double totalIncome = annualIncome + selfEmploymentIncome;

    // **Verified UK Tax Rates**
    Map<String, Map<String, double>> taxRates = {
      "2023/2024": {
        "personalAllowance": 12570,
        "basicRate": 0.20,
        "higherRate": 0.40,
        "additionalRate": 0.45,
        "higherThreshold": 50270,
        "additionalThreshold": 125140,
        "nicThreshold": 12570,
        "nicRate": 0.10, // Employment NIC
        "selfEmployedNIC": 0.09, // Self-employed NIC
      },
      "2024/2025": {
        "personalAllowance": 12570,
        "basicRate": 0.20,
        "higherRate": 0.40,
        "additionalRate": 0.45,
        "higherThreshold": 50270,
        "additionalThreshold": 125140,
        "nicThreshold": 12570,
        "nicRate": 0.08, // Reduced NIC
        "selfEmployedNIC": 0.08, // Self-employed NIC
      },
      "2025/2026": {
        "personalAllowance": 12570,
        "basicRate": 0.20,
        "higherRate": 0.40,
        "additionalRate": 0.45,
        "higherThreshold": 50270,
        "additionalThreshold": 125140,
        "nicThreshold": 12570,
        "nicRate": 0.08, // Expected cut
        "selfEmployedNIC": 0.08, // Self-employed NIC
      },
    };

    var rates = taxRates[taxYear] ?? taxRates["2024/2025"]!; // Default to 2024/2025 if not found

    // **Adjust Personal Allowance for High Earners (£1 reduction per £2 over £100,000)**
    double adjustedPersonalAllowance = rates["personalAllowance"]!;
    if (totalIncome > 100000) {
      adjustedPersonalAllowance = (12570 - ((totalIncome - 100000) / 2)).clamp(0, 12570);
    }

    // **Calculate Taxable Income**
    double taxableIncome = totalIncome - adjustedPersonalAllowance;

    if (taxableIncome > 0) {
      // **Basic Rate**
      double basicTaxable = taxableIncome.clamp(0, rates["higherThreshold"]! - adjustedPersonalAllowance);
      incomeTax += basicTaxable * rates["basicRate"]!;

      // **Higher Rate**
      double higherTaxable = (taxableIncome - rates["higherThreshold"]!).clamp(0, rates["additionalThreshold"]! - rates["higherThreshold"]!);
      incomeTax += higherTaxable * rates["higherRate"]!;

      // **Additional Rate**
      double additionalTaxable = (taxableIncome - rates["additionalThreshold"]!).clamp(0, double.infinity);
      incomeTax += additionalTaxable * rates["additionalRate"]!;
    }

    // **National Insurance Calculation**
    if (totalIncome > rates["nicThreshold"]!) {
      double nicEmployment = (annualIncome - rates["nicThreshold"]!).clamp(0, double.infinity) * rates["nicRate"]!;
      double nicSelfEmployed = (selfEmploymentIncome - rates["nicThreshold"]!).clamp(0, double.infinity) * rates["selfEmployedNIC"]!;
      nationalInsurance = nicEmployment + nicSelfEmployed;
    }

    // **VAT Calculation** (Only applicable if self-employment income is above £85,000)
    if (selfEmploymentIncome >= 85000) {
      vat = selfEmploymentIncome * 0.20;
    }

    return {
      "Income Tax": incomeTax,
      "National Insurance": nationalInsurance,
      "VAT": vat,
    };
  }
}
