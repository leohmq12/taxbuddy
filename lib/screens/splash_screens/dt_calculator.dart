import 'package:flutter/material.dart';
import 'package:taxbuddy/backend/tax/dt_backend.dart';

class DividendTaxScreen extends StatefulWidget {
  final VoidCallback onBackToCalculator;

  const DividendTaxScreen({super.key, required this.onBackToCalculator});

  @override
  State<DividendTaxScreen> createState() => _DividendTaxScreenState();
}

class _DividendTaxScreenState extends State<DividendTaxScreen> {
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _dividendsController = TextEditingController();

  @override
  void dispose() {
    _salaryController.dispose();
    _dividendsController.dispose();
    super.dispose();
  }

  Map<String, dynamic> _calculateTax(String year) {
    final salary = double.tryParse(_salaryController.text) ?? 0;
    final dividends = double.tryParse(_dividendsController.text) ?? 0;

    return DividendTaxCalculator.calculate(
      salary: salary,
      dividends: dividends,
      taxYear: year,
      region: 'England',
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.onBackToCalculator();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Dividend Tax',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'OakSans',
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xFF004B9C),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: widget.onBackToCalculator,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                'Salary',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xFF374151),
                ),
              ),
              TextField(
                controller: _salaryController,
                decoration: InputDecoration(
                  hintText: 'e.g. 10000',
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  border: const UnderlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              Text(
                'Net Dividends',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xFF374151),
                ),
              ),
              TextField(
                controller: _dividendsController,
                decoration: InputDecoration(
                  hintText: 'e.g. 10000',
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  border: const UnderlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              _buildTaxSection(context, '2025/2026'),
              _buildTaxSection(context, '2024/2025'),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'Disclaimer',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaxSection(BuildContext context, String year) {
    final results = _calculateTax(year);

    return Column(
      children: [
        const SizedBox(height: 12),
        Center(
          child: Text(
            year,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF49B3CD),
            ),
          ),
        ),
        const SizedBox(height: 6),
        _buildTaxRow(context, 'Personal allowance', '£${results['personalAllowance']}'),
        _buildTaxRow(context, 'Basic income', '£${results['basicIncomeTax']}'),
        _buildTaxRow(context, 'Higher income', '£${results['higherIncomeTax']}'),
        _buildTaxRow(context, 'Additional income', '£${results['additionalIncomeTax']}'),
        _buildTaxRow(context, 'Total income tax', '£${results['totalIncomeTax']}'),
        _buildTaxRow(context, 'Dividend allowance', '£${results['dividendAllowance']}'),
        _buildTaxRow(context, 'Basic dividend', '£${results['basicDividendTax']}'),
        _buildTaxRow(context, 'Higher dividend', '£${results['higherDividendTax']}'),
        _buildTaxRow(context, 'Additional dividend', '£${results['additionalDividendTax']}'),
        _buildTaxRow(context, 'Total dividend rate', '£${results['totalDividendTax']}'),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildTaxRow(BuildContext context, String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[800]
            : Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF004B9C)
                    : const Color(0xFF49B3CD),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}