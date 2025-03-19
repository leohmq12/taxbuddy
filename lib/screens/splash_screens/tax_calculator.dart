import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// **Back Button**
              Align(
                alignment: Alignment.centerLeft,
              ),

              /// **Tax Calculator Form Box**
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

                    /// **Annual Income Input Field**
                    _buildCurrencyTextField('Annual Income', annualIncomeController),

                    const SizedBox(height: 15),

                    /// **Tax Year Dropdown**
                    _buildTaxYearDropdown(),

                    const SizedBox(height: 15),

                    /// **Self-Employment Income Input Field**
                    _buildCurrencyTextField('Self-Employment Income', selfEmploymentController),

                    const SizedBox(height: 20),

                    /// **Calculate Button**
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
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

              /// **Estimated Tax Breakdown**
              _buildTaxBreakdown(),
            ],
          ),
        ),
      ),
    );
  }

  /// **🔹 Currency Text Field (With "£" Symbol)**
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

  /// **🔹 Tax Year Dropdown**
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

  /// **🔹 Tax Breakdown**
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
        _buildTaxRow('Income Tax', '£6,570'),
        _buildTaxRow('National Insurance', '£3,750'),
        _buildTaxRow('VAT (if registered)', '£4,200'),
      ],
    );
  }

  /// **🔹 Tax Row Widget**
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
