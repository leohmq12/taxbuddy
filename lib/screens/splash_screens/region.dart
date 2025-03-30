import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxbuddy/backend/region/region_backend.dart';

class SelectRegionScreen extends StatefulWidget {
  final VoidCallback onBackToHome;
  final Function(String) onRegionSelected;

  const SelectRegionScreen({
    super.key,
    required this.onBackToHome,
    required this.onRegionSelected,
  });

  @override
  _SelectRegionScreenState createState() => _SelectRegionScreenState();
}

class _SelectRegionScreenState extends State<SelectRegionScreen> {
  @override
  Widget build(BuildContext context) {
    final regionProvider = Provider.of<RegionProvider>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
        regionProvider.clearRegion(); // Clear selection when going back
        widget.onBackToHome();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Select Your Region',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'OakSans',
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onPrimary),
            onPressed: () {
              regionProvider.clearRegion(); // Clear selection when going back
              widget.onBackToHome();
            },
          ),
          backgroundColor: const Color(0xFF004B9C),
        ),
        body: Consumer<RegionProvider>(
          builder: (context, provider, child) {
            return ListView(
              children: [
                _buildRegionTile(context, 'England', provider),
                _buildRegionTile(context, 'Wales', provider),
                _buildRegionTile(context, 'Scotland', provider),
                _buildRegionTile(context, 'Northern Ireland', provider),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildRegionTile(BuildContext context, String region, RegionProvider provider) {
    bool isSelected = provider.selectedRegion == region;
    return ListTile(
      title: Text(
        region,
        style: TextStyle(
          fontFamily: 'OakSans',
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: isSelected
              ? (Theme.of(context).brightness == Brightness.dark
              ? Color(0xFF49B3CD)
              : Color(0xFF043377))
              : (Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).colorScheme.onSurface
              : Color(0xFF4F5C6F)),
        ),
      ),
      onTap: () {
        provider.selectRegion(region); // Update provider
        widget.onRegionSelected(region); // Proceed to next screen
      },
    );
  }
}