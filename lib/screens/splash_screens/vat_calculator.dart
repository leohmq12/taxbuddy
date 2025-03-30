import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxbuddy/backend/region/region_backend.dart';
import 'package:taxbuddy/backend/tax/vat_backend.dart';

class VATTaxScreen extends StatefulWidget {
  final VoidCallback onBackToCalculator;

  const VATTaxScreen({super.key, required this.onBackToCalculator});

  @override
  State<VATTaxScreen> createState() => _VATTaxScreenState();
}

class _VATTaxScreenState extends State<VATTaxScreen> {
  final TextEditingController _amountController = TextEditingController();
  bool _isVatIncluded = false;
  double _amount = 0.0;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final region = Provider.of<RegionProvider>(context).selectedRegion ?? 'England';
    final calculations = _amount > 0
        ? VATCalculator.calculateVAT(
      region: region,
      amount: _amount,
      isInclusive: _isVatIncluded,
    )
        : {
      'netAmount': 0.0,
      'vatAmount': 0.0,
      'grossAmount': 0.0,
      'rate': 0.20,
    };

    return WillPopScope(
      onWillPop: () async {
        widget.onBackToCalculator();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'VAT',
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
                'Amount',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xFF374151),
                ),
              ),
              TextField(
                controller: _amountController,
                decoration: InputDecoration(
                  hintText: 'e.g. 5000',
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  border: const UnderlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  setState(() {
                    _amount = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Inclusive of VAT?',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  Switch(
                    value: _isVatIncluded,
                    onChanged: (value) {
                      setState(() {
                        _isVatIncluded = value;
                      });
                    },
                    activeColor: const Color(0xFF49B3CD),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildVATSection(context, calculations),
              const SizedBox(height: 20),
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

  Widget _buildVATSection(BuildContext context, Map<String, double> calculations) {
    return Column(
      children: [
        const SizedBox(height: 16),
        const Center(
          child: Text(
            '2025/2026',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF49B3CD),
            ),
          ),
        ),
        const SizedBox(height: 8),
        _buildVATRow(
          context,
          'Net Amount',
          '£${calculations['netAmount']!.toStringAsFixed(2)}',
        ),
        const SizedBox(height: 6),
        _buildVATRow(
          context,
          'VAT (${(calculations['rate']! * 100).toStringAsFixed(0)}%)',
          '£${calculations['vatAmount']!.toStringAsFixed(2)}',
        ),
        const SizedBox(height: 6),
        _buildVATRow(
          context,
          'Total Amount',
          '£${calculations['grossAmount']!.toStringAsFixed(2)}',
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildVATRow(BuildContext context, String label, String value) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[800]
                  : Colors.grey[200],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
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
    );
  }
}