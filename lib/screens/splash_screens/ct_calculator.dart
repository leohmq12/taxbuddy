import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxbuddy/backend/region/region_backend.dart';
import 'package:taxbuddy/backend/tax/ct_calculator.dart';

class CorporateTaxScreen extends StatefulWidget {
  final VoidCallback onBackToCalculator;
  final String selectedRegion;

  const CorporateTaxScreen({super.key, required this.onBackToCalculator, required this.selectedRegion});

  @override
  _CorporateTaxScreenState createState() => _CorporateTaxScreenState();
}

class _CorporateTaxScreenState extends State<CorporateTaxScreen> {
  final TextEditingController _profitController = TextEditingController();
  double _profit = 0.0; // Initialize as double

  @override
  void dispose() {
    _profitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final region = Provider.of<RegionProvider>(context).selectedRegion ?? 'England';

    return WillPopScope(
      onWillPop: () async {
        widget.onBackToCalculator();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Corporate Tax',
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
              Text(
                'Please note that the calculations below are based on a single corporation and do not take into account any associated companies.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'Profits before tax',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xFF374151),
                ),
              ),
              TextField(
                controller: _profitController,
                decoration: InputDecoration(
                  hintText: 'e.g. 10000',
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  border: const UnderlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  setState(() {
                    _profit = double.tryParse(value) ?? 0.0; // Ensure double
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildTaxSection(context, '2025/2026', region),
              _buildTaxSection(context, '2024/2025', region),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Disclaimer'),
                        content: const Text(
                          'This calculator provides estimates only. For official tax calculations, please consult HMRC guidelines.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
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

  Widget _buildTaxSection(BuildContext context, String year, String region) {
    double tax = 0.0;
    double profitAfterTax = 0.0;
    double effectiveRate = 0.0;

    if (_profit > 0) {
      final calculations = CorporateTaxCalculator.calculate(
        region: region,
        taxYear: year,
        profitBeforeTax: _profit,
      );

      // Safe extraction from string values
      tax = double.tryParse(calculations['corporationTax'] ?? '0') ?? 0.0;

      final profitBeforeTax = double.tryParse(calculations['profitBeforeTax'] ?? '0') ?? 0.0;
      profitAfterTax = (profitBeforeTax - tax).clamp(0.0, double.infinity);

      final effectiveRateStr = calculations['effectiveTaxRate']?.replaceAll('%', '');
      effectiveRate = double.tryParse(effectiveRateStr ?? '0') ?? 0.0;
    }

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
        _buildTaxRow(context, 'Corporation tax', '£${tax.toStringAsFixed(2)}'),
        _buildTaxRow(context, 'Profits after tax', '£${profitAfterTax.toStringAsFixed(2)}'),
        _buildTaxRow(context, 'Effective Tax Rate (%)', '${effectiveRate.toStringAsFixed(1)}%'),
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