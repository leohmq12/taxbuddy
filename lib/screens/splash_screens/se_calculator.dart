import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxbuddy/backend/region/region_backend.dart';
import 'package:taxbuddy/backend/tax/se_backend.dart';

class SelfEmployedTaxScreen extends StatefulWidget {
  final VoidCallback onBackToCalculator;
  final String selectedRegion;

  const SelfEmployedTaxScreen({super.key, required this.onBackToCalculator, required this.selectedRegion});

  @override
  State<SelfEmployedTaxScreen> createState() => _SelfEmployedTaxScreenState();
}

class _SelfEmployedTaxScreenState extends State<SelfEmployedTaxScreen> {
  final TextEditingController _profitController = TextEditingController();
  double _profit = 0;

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
            'Self Employed Income Tax & NI',
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
                'If you are self-employed, the calculator below helps to work out how much income you will have after National Insurance and Income Tax.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'The figures below assume that self-employment is your only source of income and you are subject to NI charges.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'End of year profit',
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
                  hintText: 'e.g. 25000',
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  border: const UnderlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _profit = double.tryParse(value) ?? 0;
                  });
                },
              ),
              const SizedBox(height: 20),
              _buildTaxSection(context, '2025/2026', region),
              _buildTaxSection(context, '2024/2025', region),
              const SizedBox(height: 20),
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
    final calculations = SelfEmploymentCalculator.calculate(
      region: region,
      profit: _profit,
      taxYear: year,
    );

    return Column(
      children: [
        const SizedBox(height: 16),
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
        const SizedBox(height: 8),
        _buildTaxRow(context, 'End of year profit', '£${_profit.toStringAsFixed(2)}'),
        _buildTaxRow(context, 'Income tax', '£${calculations['incomeTax']!.toStringAsFixed(2)}'),
        _buildTaxRow(context, 'Class 2 NI', '£${calculations['class2Nics']!.toStringAsFixed(2)}'),
        _buildTaxRow(context, 'Class 4 NI', '£${calculations['class4Nics']!.toStringAsFixed(2)}'),
        _buildTaxRow(context, 'Net profit after tax & NI', '£${calculations['netProfit']!.toStringAsFixed(2)}'),
        const SizedBox(height: 16),
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
                    fontWeight: FontWeight.w500),
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