class TaxCalculator {
  final double annualIncome;
  final double selfEmploymentIncome;
  final String taxYear;
  final String region;

  TaxCalculator({
    required this.annualIncome,
    required this.selfEmploymentIncome,
    required this.taxYear,
    required this.region,
  });

  Map<String, double> getTaxBreakdown() {
    double incomeTax = 0;
    double nationalInsurance = 0;
    double vat = 0;

    double totalIncome = annualIncome + selfEmploymentIncome;

    // UK-Wide Tax Rates with Scottish Bands
    Map<String, Map<String, dynamic>> taxRates = {
      "2023/2024": {
        // UK Rates
        "personalAllowance": 12570.0,
        "basicRate": 0.20,
        "higherRate": 0.40,
        "additionalRate": 0.45,
        "higherThreshold": 50270.0,
        "additionalThreshold": 125140.0,
        "nicClass1Rate": 0.12,
        "nicClass4Rate": 0.09,
        "class2Weekly": 3.45,

        // Scotland-Specific (2023/2024)
        "scottishBands": {
          "starterEnd": 14732.0,
          "basicEnd": 25688.0,
          "intermediateEnd": 43662.0,
          "higherEnd": 125140.0,
          "starterRate": 0.19,
          "basicRate": 0.20,
          "intermediateRate": 0.21,
          "higherRate": 0.42,
          "topRate": 0.47,
        },
      },
      "2024/2025": {
        // UK Rates
        "personalAllowance": 12570.0,
        "basicRate": 0.20,
        "higherRate": 0.40,
        "additionalRate": 0.45,
        "higherThreshold": 50270.0,
        "additionalThreshold": 125140.0,
        "nicClass1Rate": 0.10,
        "nicClass4Rate": 0.08,
        "class2Weekly": 3.45,

        // Scotland-Specific (2024/2025)
        "scottishBands": {
          "starterEnd": 14876.0,
          "basicEnd": 26561.0,
          "intermediateEnd": 43662.0,
          "higherEnd": 125140.0,
          "starterRate": 0.19,
          "basicRate": 0.20,
          "intermediateRate": 0.21,
          "higherRate": 0.42,
          "topRate": 0.47,
        },
      },
      "2025/2026": {
        // UK Rates (projected)
        "personalAllowance": 12570.0,
        "basicRate": 0.20,
        "higherRate": 0.40,
        "additionalRate": 0.45,
        "higherThreshold": 50270.0,
        "additionalThreshold": 125140.0,
        "nicClass1Rate": 0.08,
        "nicClass4Rate": 0.06,
        "class2Weekly": 3.45,

        // Scotland-Specific (projected - same as 2024/2025)
        "scottishBands": {
          "starterEnd": 14876.0,
          "basicEnd": 26561.0,
          "intermediateEnd": 43662.0,
          "higherEnd": 125140.0,
          "starterRate": 0.19,
          "basicRate": 0.20,
          "intermediateRate": 0.21,
          "higherRate": 0.42,
          "topRate": 0.47,
        },
      },
    };

    var rates = taxRates[taxYear] ?? taxRates["2024/2025"]!;

    // 1. Income Tax Calculation
    double adjustedPersonalAllowance = rates["personalAllowance"]!;
    if (totalIncome > 100000) {
      adjustedPersonalAllowance = (12570 - ((totalIncome - 100000) / 2)).clamp(0, 12570);
    }

    double taxableIncome = totalIncome - adjustedPersonalAllowance;

    if (taxableIncome > 0) {
      if (region == "Scotland") {
        final bands = rates["scottishBands"] as Map<String, dynamic>;

        if (taxableIncome <= bands["starterEnd"]) {
          incomeTax += (taxableIncome - 12571) * bands["starterRate"];
        }
        else if (taxableIncome <= bands["basicEnd"]) {
          incomeTax += (bands["starterEnd"] - 12571) * bands["starterRate"] +
              (taxableIncome - bands["starterEnd"]) * bands["basicRate"];
        }
        else if (taxableIncome <= bands["intermediateEnd"]) {
          incomeTax += (bands["starterEnd"] - 12571) * bands["starterRate"] +
              (bands["basicEnd"] - bands["starterEnd"]) * bands["basicRate"] +
              (taxableIncome - bands["basicEnd"]) * bands["intermediateRate"];
        }
        else if (taxableIncome <= bands["higherEnd"]) {
          incomeTax += (bands["starterEnd"] - 12571) * bands["starterRate"] +
              (bands["basicEnd"] - bands["starterEnd"]) * bands["basicRate"] +
              (bands["intermediateEnd"] - bands["basicEnd"]) * bands["intermediateRate"] +
              (taxableIncome - bands["intermediateEnd"]) * bands["higherRate"];
        }
        else {
          incomeTax += (bands["starterEnd"] - 12571) * bands["starterRate"] +
              (bands["basicEnd"] - bands["starterEnd"]) * bands["basicRate"] +
              (bands["intermediateEnd"] - bands["basicEnd"]) * bands["intermediateRate"] +
              (bands["higherEnd"] - bands["intermediateEnd"]) * bands["higherRate"] +
              (taxableIncome - bands["higherEnd"]) * bands["topRate"];
        }
      } else {
        // Rest of UK calculation (unchanged)
        double basicTaxable = taxableIncome.clamp(0, (rates["higherThreshold"] as num).toDouble() - adjustedPersonalAllowance);
        incomeTax += basicTaxable * (rates["basicRate"] as num).toDouble();

        double higherTaxable = (taxableIncome - (rates["higherThreshold"] as num).toDouble()).clamp(0, (rates["additionalThreshold"] as num).toDouble() - (rates["higherThreshold"] as num).toDouble());
        incomeTax += higherTaxable * (rates["higherRate"] as num).toDouble();

        double additionalTaxable = (taxableIncome - rates["additionalThreshold"]!).clamp(0, double.infinity);
        incomeTax += additionalTaxable * rates["additionalRate"]!;
      }
    }

    // 2. National Insurance (unchanged)
    double class2NI = rates["class2Weekly"]! * 52;

    double nicEmployment = 0;
    if (annualIncome > 12570) {
      double empLowerBand = (annualIncome - 12570).clamp(0, 50270 - 12570);
      double empUpperBand = (annualIncome - 50270).clamp(0, double.infinity);
      nicEmployment = (empLowerBand * rates["nicClass1Rate"]!) + (empUpperBand * 0.02);
    }

    double nicSelfEmployed = 0;
    if (selfEmploymentIncome > 12570) {
      double selfLowerBand = (selfEmploymentIncome - 12570).clamp(0, 50270 - 12570);
      double selfUpperBand = (selfEmploymentIncome - 50270).clamp(0, double.infinity);
      nicSelfEmployed = (selfLowerBand * rates["nicClass4Rate"]!) + (selfUpperBand * 0.02);
    }

    nationalInsurance = nicEmployment + nicSelfEmployed + class2NI;

    // 3. VAT (unchanged)
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