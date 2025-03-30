import 'package:flutter/material.dart';
import 'package:taxbuddy/backend/tax/cg_backend.dart';

class CapitalGainsTaxScreen extends StatefulWidget {
  final VoidCallback onBackToCalculator;
  final String selectedRegion;

  const CapitalGainsTaxScreen({
    super.key,
    required this.onBackToCalculator,
    required this.selectedRegion,
  });

  @override
  State<CapitalGainsTaxScreen> createState() => _CapitalGainsTaxScreenState();
}

class _CapitalGainsTaxScreenState extends State<CapitalGainsTaxScreen> {
  final TextEditingController _saleProceedsController = TextEditingController();
  final TextEditingController _purchasePriceController = TextEditingController();
  final TextEditingController _sellingCostsController = TextEditingController();
  final TextEditingController _purchaseCostsController = TextEditingController();
  final TextEditingController _taxableIncomeController = TextEditingController();

  Map<String, dynamic> _results2024 = {};
  Map<String, dynamic> _results2025 = {};

  @override
  void dispose() {
    _saleProceedsController.dispose();
    _purchasePriceController.dispose();
    _sellingCostsController.dispose();
    _purchaseCostsController.dispose();
    _taxableIncomeController.dispose();
    super.dispose();
  }

  void _calculate() {
    setState(() {
      final saleProceeds = double.tryParse(_saleProceedsController.text) ?? 0;
      final purchasePrice = double.tryParse(_purchasePriceController.text) ?? 0;
      final sellingCosts = double.tryParse(_sellingCostsController.text) ?? 0;
      final purchaseCosts = double.tryParse(_purchaseCostsController.text) ?? 0;
      final taxableIncome = double.tryParse(_taxableIncomeController.text) ?? 0;

      _results2024 = CapitalGainsTaxCalculator.calculate(
        saleProceeds: saleProceeds,
        purchasePrice: purchasePrice,
        sellingCosts: sellingCosts,
        purchaseCosts: purchaseCosts,
        taxYear: '2024/2025',
        region: widget.selectedRegion,
        taxableIncome: taxableIncome,
      );

      _results2025 = CapitalGainsTaxCalculator.calculate(
        saleProceeds: saleProceeds,
        purchasePrice: purchasePrice,
        sellingCosts: sellingCosts,
        purchaseCosts: purchaseCosts,
        taxYear: '2025/2026',
        region: widget.selectedRegion,
        taxableIncome: taxableIncome,
      );
    });
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
            'Capital Gains Tax',
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
                'Capital Gains is a tax imposed on a profit you make from the sale of property or an investment / asset. Our calculator gives you a view of what tax you will need to pay based on your current tax rate.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 22),
              Text(
                'Please note that the basic rate is applicable only if there is any remaining basic rate band left from the taxable income, not for the entire amount of capital gains taxed.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              Text(
                'Sale Proceeds',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xFF374151),
                ),
              ),
              TextField(
                controller: _saleProceedsController,
                decoration: InputDecoration(
                  hintText: 'e.g. 10000',
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  border: const UnderlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (_) => _calculate(),
              ),
              const SizedBox(height: 16),
              Text(
                'Purchase Price',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xFF374151),
                ),
              ),
              TextField(
                controller: _purchasePriceController,
                decoration: InputDecoration(
                  hintText: 'e.g. 10000',
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  border: const UnderlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (_) => _calculate(),
              ),
              const SizedBox(height: 16),
              Text(
                'Selling Costs',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xFF374151),
                ),
              ),
              TextField(
                controller: _sellingCostsController,
                decoration: InputDecoration(
                  hintText: 'e.g. 10000',
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  border: const UnderlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (_) => _calculate(),
              ),
              const SizedBox(height: 16),
              Text(
                'Purchase Costs',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xFF374151),
                ),
              ),
              TextField(
                controller: _purchaseCostsController,
                decoration: InputDecoration(
                  hintText: 'e.g. 10000',
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  border: const UnderlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (_) => _calculate(),
              ),
              const SizedBox(height: 16),
              Text(
                'Your Taxable Income',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xFF374151),
                ),
              ),
              TextField(
                controller: _taxableIncomeController,
                decoration: InputDecoration(
                  hintText: 'e.g. 40000',
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  border: const UnderlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (_) => _calculate(),
              ),
              const SizedBox(height: 16),
              _buildTaxSection(context, '2025/2026', _results2025),
              _buildTaxSection(context, '2024/2025', _results2024),
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

  Widget _buildTaxSection(BuildContext context, String year, Map<String, dynamic> results) {
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
        _buildTaxRow(context, 'Chargeable gain', '£${results['chargeableGain'] ?? '0.00'}'),
        _buildTaxRow(context, 'Taxable gain', '£${results['taxableGain'] ?? '0.00'}'),
        _buildTaxRow(context, 'Basic', '£${results['basic'] ?? '0.00'}'),
        _buildTaxRow(context, 'Basic (other assets)', '£${results['basicOtherAssets'] ?? '0.00'}'),
        _buildTaxRow(context, 'Higher', '£${results['higher'] ?? '0.00'}'),
        _buildTaxRow(context, 'Higher (other assets)', '£${results['higherOtherAssets'] ?? '0.00'}'),
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