import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taxbuddy/backend/tax/tax_service.dart'; // Import backend

class TaxCalculatorScreen extends StatefulWidget {
  const TaxCalculatorScreen({super.key});

  @override
  _TaxCalculatorScreenState createState() => _TaxCalculatorScreenState();
}

class _TaxCalculatorScreenState extends State<TaxCalculatorScreen> {
  String selectedTaxYear = "2024/2025";
  final List<String> taxYears = ["2023/2024", "2024/2025", "2025/2026"];
  final TextEditingController annualIncomeController = TextEditingController();
  final TextEditingController selfEmploymentController = TextEditingController();

  double incomeTax = 0;
  double nationalInsurance = 0;
  double vat = 0;

  void calculateTaxes() {
    double annualIncome = double.tryParse(annualIncomeController.text) ?? 0;
    double selfEmploymentIncome = double.tryParse(selfEmploymentController.text) ?? 0;

    TaxCalculator taxCalculator = TaxCalculator(
      annualIncome: annualIncome,
      selfEmploymentIncome: selfEmploymentIncome,
      taxYear: selectedTaxYear, // Pass selected tax year
    );

    setState(() {
      var breakdown = taxCalculator.getTaxBreakdown();
      incomeTax = breakdown['Income Tax']!;
      nationalInsurance = breakdown['National Insurance']!;
      vat = breakdown['VAT']!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900], // Dark blue app bar
        title: Text(
          "Tax Calculator",
          style: GoogleFonts.urbanist(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      spreadRadius: 2,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Estimate Your Taxes',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'OakSans',
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF043377),
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildCurrencyTextField('Annual Income', annualIncomeController),
                    const SizedBox(height: 15),
                    _buildTaxYearDropdown(),
                    const SizedBox(height: 15),
                    _buildCurrencyTextField('Self-Employment Income', selfEmploymentController),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: calculateTaxes,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF004B9C),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text(
                          'Calculate Taxes',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'OakSans',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildTaxBreakdown(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencyTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixText: '£ ',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildTaxYearDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedTaxYear,
      items: taxYears.map((String year) {
        return DropdownMenuItem(
          value: year,
          child: Text(year),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedTaxYear = newValue!;
        });
      },
      decoration: InputDecoration(
        labelText: 'Tax Year',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildTaxBreakdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Estimated Tax Breakdown',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'OakSans',
            fontWeight: FontWeight.bold,
            color: Color(0xFF043377),
          ),
        ),
        const SizedBox(height: 10),
        _buildTaxRow('Income Tax', '£${incomeTax.toStringAsFixed(2)}'),
        _buildTaxRow('National Insurance', '£${nationalInsurance.toStringAsFixed(2)}'),
        _buildTaxRow('VAT (if registered)', '£${vat.toStringAsFixed(2)}'),
      ],
    );
  }

  Widget _buildTaxRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontFamily: 'OakSans'),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'OakSans',
              fontWeight: FontWeight.bold,
              color: Color(0xFF004B9C),
            ),
          ),
        ],
      ),
    );
  }
}
