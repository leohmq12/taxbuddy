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

    // Define tax rules for each tax year
    Map<String, Map<String, double>> taxRates = {
      "2023/2024": {
        "personalAllowance": 12570,
        "basicRate": 0.20,
        "higherRate": 0.40,
        "additionalRate": 0.45,
        "higherThreshold": 50270,
        "additionalThreshold": 125140,
        "nationalInsurance": 0.12,
      },
      "2024/2025": {
        "personalAllowance": 12750,
        "basicRate": 0.19,
        "higherRate": 0.38,
        "additionalRate": 0.45,
        "higherThreshold": 51000,
        "additionalThreshold": 130000,
        "nationalInsurance": 0.11,
      },
      "2025/2026": {
        "personalAllowance": 13000,
        "basicRate": 0.18,
        "higherRate": 0.37,
        "additionalRate": 0.45,
        "higherThreshold": 52000,
        "additionalThreshold": 135000,
        "nationalInsurance": 0.10,
      },
    };

    var rates = taxRates[taxYear] ?? taxRates["2024/2025"]!; // Default to 2024/2025 if not found

    double taxableIncome = totalIncome - rates["personalAllowance"]!;
    if (taxableIncome > 0) {
      if (taxableIncome <= rates["higherThreshold"]!) {
        incomeTax = taxableIncome * rates["basicRate"]!;
      } else if (taxableIncome <= rates["additionalThreshold"]!) {
        incomeTax = (rates["higherThreshold"]! * rates["basicRate"]!) +
            ((taxableIncome - rates["higherThreshold"]!) * rates["higherRate"]!);
      } else {
        incomeTax = (rates["higherThreshold"]! * rates["basicRate"]!) +
            ((rates["additionalThreshold"]! - rates["higherThreshold"]!) * rates["higherRate"]!) +
            ((taxableIncome - rates["additionalThreshold"]!) * rates["additionalRate"]!);
      }
    }

    // National Insurance Calculation
    if (totalIncome > rates["personalAllowance"]!) {
      nationalInsurance = (totalIncome - rates["personalAllowance"]!) * rates["nationalInsurance"]!;
    }

    // VAT Calculation (Assuming self-employed income is subject to VAT at 20%)
    if (selfEmploymentIncome > 0) {
      vat = selfEmploymentIncome * 0.20;
    }

    return {
      "Income Tax": incomeTax,
      "National Insurance": nationalInsurance,
      "VAT": vat,
    };
  }
}
