import 'package:flutter/material.dart';

class VATTaxScreen extends StatefulWidget {
  final VoidCallback onBackToCalculator;

  const VATTaxScreen({super.key, required this.onBackToCalculator});

  @override
  State<VATTaxScreen> createState() => _VATTaxScreenState();
}

class _VATTaxScreenState extends State<VATTaxScreen> {
  bool isVatIncluded = false;

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
            'VAT',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'OakSans',
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
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
                decoration: InputDecoration(
                  hintText: 'e.g. 5000',
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  border: const UnderlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Inclusive of VAT?',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  Checkbox(
                    value: isVatIncluded,
                    onChanged: (value) {
                      setState(() {
                        isVatIncluded = value!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildVATSection(context, '2025/2026'),
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

  Widget _buildVATSection(BuildContext context, String year) {
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
        _buildVATRow(context, 'Cost', '£0'),
        const SizedBox(height: 6),
        _buildVATRow(context, 'VAT', '£0'),
        const SizedBox(height: 6),
        _buildVATRow(context, 'Total', '£0'),
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
    );
  }
}