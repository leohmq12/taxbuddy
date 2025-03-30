import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxbuddy/backend/region/region_backend.dart'; // Your RegionProvider

class SelectCalculatorScreen extends StatefulWidget {
  final VoidCallback onBackToRegion;
  final void Function(String) onCalculatorSelected;

  const SelectCalculatorScreen({
    super.key,
    required this.onBackToRegion,
    required this.onCalculatorSelected,
  });

  @override
  _SelectCalculatorState createState() => _SelectCalculatorState();
}

class _SelectCalculatorState extends State<SelectCalculatorScreen> {
  String? _selectedTopic;

  @override
  Widget build(BuildContext context) {
    // Backend: Silently access the stored region (no UI impact)
    final selectedRegion = Provider.of<RegionProvider>(context).selectedRegion;
    print("Region in Calculator Screen: $selectedRegion");

    return WillPopScope(
      onWillPop: () async {
        widget.onBackToRegion();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Select Your Calculator',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'OakSans',
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onPrimary),
            onPressed: widget.onBackToRegion,
          ),
          backgroundColor: const Color(0xFF004B9C),
        ),
        body: ListView(
          children: [
            _buildTopicTile(context, 'Capital Gains Tax Calculator'),
            _buildTopicTile(context, 'Corporate Tax Calculator'),
            _buildTopicTile(context, 'Dividend Tax Calculator'),
            _buildTopicTile(context, 'Self Employment Calculator'),
            _buildTopicTile(context, 'VAT Calculator'),
            _buildTopicTile(context, 'General Tax Calculator'),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicTile(BuildContext context, String topic) {
    bool isSelected = _selectedTopic == topic;
    return ListTile(
      title: Text(
        topic,
        style: TextStyle(
          fontFamily: 'OakSans',
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: isSelected
              ? (Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF49B3CD)
              : const Color(0xFF043377))
              : (Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).colorScheme.onSurface
              : const Color(0xFF4F5C6F)),
        ),
      ),
      onTap: () {
        setState(() => _selectedTopic = topic);
        widget.onCalculatorSelected(topic);
      },
    );
  }
}