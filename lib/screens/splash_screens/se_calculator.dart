import 'package:flutter/material.dart';

class SelfEmployedTaxScreen extends StatelessWidget {
  final VoidCallback onBackToCalculator;

  const SelfEmployedTaxScreen({super.key, required this.onBackToCalculator});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        onBackToCalculator();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Self Employed Income Tax & NI',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'OakSans',
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: onBackToCalculator,
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'If you are self-employed, the calculator below helps to work out how much income you will have after National Insurance and Income Tax.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 8),
              Text(
                'The figures below assume that self-employment is your only source of income and you are subject to NI charges.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 16),
              Text(
                'End of year profit',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Color(0xFF374151),
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'e.g. 25000',
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  border: UnderlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              _buildTaxSection(context, '2025/2026'),
              _buildTaxSection(context, '2024/2025'),
              SizedBox(height: 20),
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
                  child: Text(
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
    return Column(
      children: [
        SizedBox(height: 16),
        Center(
          child: Text(
            year,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF49B3CD),
            ),
          ),
        ),
        SizedBox(height: 8),
        _buildTaxRow(context, 'End of year profit', '£0'),
        _buildTaxRow(context, 'Income tax', '£0'),
        _buildTaxRow(context, 'Class 2 NI', '£0'),
        _buildTaxRow(context, 'Class 4 NI', '£0'),
        _buildTaxRow(context, 'Net profit after income tax & NI', '£0'),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTaxRow(BuildContext context, String label, String value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
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
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Color(0xFF004B9C)
                    : Color(0xFF49B3CD),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Text(
                value,
                textAlign: TextAlign.right,
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
    );
  }
}