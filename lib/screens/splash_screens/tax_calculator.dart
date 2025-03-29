import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taxbuddy/backend/tax/tax_service.dart';

class TaxCalculatorScreen extends StatefulWidget {
  final VoidCallback? onBackToCalculator;

  const TaxCalculatorScreen({super.key, this.onBackToCalculator});

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
      taxYear: selectedTaxYear,
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
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? const Color(0xFF004B9C) : const Color(0xFF004B9C),
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: isDarkMode ? Colors.white : Colors.white),
              onPressed: () {
                if (widget.onBackToCalculator != null) {
                  widget.onBackToCalculator!();
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
            const SizedBox(width: 10),
            Text(
              "Tax Calculator",
              style: GoogleFonts.urbanist(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.white,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Estimate Your Taxes',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'OakSans',
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? const Color(0xFF49B3CD) : Colors.blue[900],
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildCurrencyTextField('Annual Income', annualIncomeController, isDarkMode),
                  const SizedBox(height: 15),
                  _buildTaxYearDropdown(isDarkMode),
                  const SizedBox(height: 15),
                  _buildCurrencyTextField('Self-Employment Income', selfEmploymentController, isDarkMode),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: calculateTaxes,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF004B9C),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        minimumSize: const Size(double.infinity, 50),
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
            _buildTaxBreakdown(isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyTextField(String label, TextEditingController controller, bool isDarkMode) {
    return TextField(
      controller: controller,
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
        prefixText: '£ ',
        filled: true,
        fillColor: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none, // Remove white border in dark mode
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildTaxYearDropdown(bool isDarkMode) {
    return DropdownButtonFormField<String>(
      value: selectedTaxYear,
      dropdownColor: isDarkMode ? Colors.black12.withOpacity(0.95) : Colors.white,
      items: taxYears.map((String year) {
        return DropdownMenuItem(
          value: year,
          child: Text(
            year,
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedTaxYear = newValue!;
        });
      },
      decoration: InputDecoration(
        labelText: 'Tax Year',
        labelStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
        filled: true,
        fillColor: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none, // Remove white border in dark mode
        ),
      ),
    );
  }

  Widget _buildTaxBreakdown(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estimated Tax Breakdown',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'OakSans',
            fontWeight: FontWeight.bold,
            color: isDarkMode ? const Color(0xFF49B3CD) : Colors.blue[900],
          ),
        ),
        const SizedBox(height: 10),
        _buildTaxRow('Income Tax', '£${incomeTax.toStringAsFixed(2)}', isDarkMode),
        _buildTaxRow('National Insurance', '£${nationalInsurance.toStringAsFixed(2)}', isDarkMode),
        _buildTaxRow('VAT (if registered)', '£${vat.toStringAsFixed(2)}', isDarkMode),
      ],
    );
  }

  Widget _buildTaxRow(String label, String value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontFamily: 'OakSans', color: isDarkMode ? Colors.white : Colors.black),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'OakSans',
              fontWeight: FontWeight.bold,
              color: isDarkMode ? const Color(0xFF49B3CD) : Colors.blue[900],
            ),
          ),
        ],
      ),
    );
  }
}
