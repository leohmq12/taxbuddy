import 'package:flutter/material.dart';
import 'package:taxbuddy/screens/splash_screens/calc_select.dart';
import '../splash_screens/settings.dart';
import '../splash_screens/profile.dart';
import '../splash_screens/chatscreen.dart';
import '../splash_screens/learn_screen.dart';
import 'package:taxbuddy/backend/search/search_service.dart';
import 'package:flutter/services.dart';
import '../splash_screens/region.dart';
import '../splash_screens/ct_calculator.dart';
import '../splash_screens/se_calculator.dart';
import '../splash_screens/vat_calculator.dart';
import '../splash_screens/dt_calculator.dart';
import '../splash_screens/tax_calculator.dart';
import '../splash_screens/cg_calculator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _showingRegionScreen = false;
  bool _showingCalculatorScreen = false;
  bool _showingCorporateTaxScreen = false;
  bool _showingSelfEmployedTaxScreen = false;
  bool _showingVATTaxScreen = false;
  bool _showingDividendTaxScreen = false;
  bool _showingGeneralTaxScreen = false;
  bool _showingCapitalGainsTaxScreen = false;

  final List<Widget> _screens = [
    Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF004B9C),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/image1.png'),
              radius: 18,
            ),
            SizedBox(width: 10),
            Text(
              'Tax Assistant',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'OakSans',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: const HomeContent(),
    ),
    const ChatScreen(),
    const ProfileScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      // When calculator tab is selected (index 1), show region screen first
      if (index == 1) {
        _showingRegionScreen = true;
        _showingCalculatorScreen = false;
        _showingCorporateTaxScreen = false;
        _showingSelfEmployedTaxScreen = false;
        _showingVATTaxScreen = false;
        _showingDividendTaxScreen = false;
        _showingGeneralTaxScreen = false;
        _showingCapitalGainsTaxScreen = false;
      } else {
        // Reset all calculator states for other tabs
        _showingRegionScreen = false;
        _showingCalculatorScreen = false;
        _showingCorporateTaxScreen = false;
        _showingSelfEmployedTaxScreen = false;
        _showingVATTaxScreen = false;
        _showingDividendTaxScreen = false;
        _showingGeneralTaxScreen = false;
        _showingCapitalGainsTaxScreen = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_showingCapitalGainsTaxScreen) {
          setState(() => _showingCapitalGainsTaxScreen = false);
          return false;
        }
        if (_showingDividendTaxScreen) {
          setState(() => _showingDividendTaxScreen = false);
          return false;
        }
        if (_showingVATTaxScreen) {
          setState(() => _showingVATTaxScreen = false);
          return false;
        }
        if (_showingSelfEmployedTaxScreen) {
          setState(() => _showingSelfEmployedTaxScreen = false);
          return false;
        }
        if (_showingCorporateTaxScreen) {
          setState(() => _showingCorporateTaxScreen = false);
          return false;
        }
        if (_showingCalculatorScreen) {
          setState(() => _showingCalculatorScreen = false);
          return false;
        }
        if (_showingRegionScreen) {
          setState(() {
            _showingRegionScreen = false;
            _selectedIndex = 0; // Return to home
          });
          return false;
        }
        if (_selectedIndex != 0) {
          setState(() => _selectedIndex = 0);
          return false;
        }
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            _screens[0], // Home
            _showingCapitalGainsTaxScreen
                ? CapitalGainsTaxScreen(onBackToCalculator: (){
                  setState (() => _showingCapitalGainsTaxScreen =false);
              },
            )
                : _showingGeneralTaxScreen
                ? TaxCalculatorScreen(
              onBackToCalculator: () {
                setState(() => _showingGeneralTaxScreen = false);
              },
            )
                : _showingVATTaxScreen
                ? VATTaxScreen(
              onBackToCalculator: () {
                setState(() => _showingVATTaxScreen = false);
              },
            )
                : _showingSelfEmployedTaxScreen
                ? SelfEmployedTaxScreen(
              onBackToCalculator: () {
                setState(() => _showingSelfEmployedTaxScreen = false);
              },
            )
                : _showingCorporateTaxScreen
                ? CorporateTaxScreen(
              onBackToCalculator: () {
                setState(() => _showingCorporateTaxScreen = false);
              },
            )
                : _showingDividendTaxScreen
                ? DividendTaxScreen(
              onBackToCalculator: () {
                setState(() => _showingDividendTaxScreen = false);
              },
            )
                : _showingCalculatorScreen
                ? SelectCalculatorScreen(
              onBackToRegion: () {
                setState(() => _showingCalculatorScreen = false);
              },
              onCalculatorSelected: (String calculatorType) {
                setState(() {
                  if (calculatorType == 'Corporate Tax Calculator') {
                    _showingCorporateTaxScreen = true;
                  } else if (calculatorType == 'Self Employment Calculator') {
                    _showingSelfEmployedTaxScreen = true;
                  } else if (calculatorType == 'VAT Calculator') {
                    _showingVATTaxScreen = true;
                  } else if (calculatorType == 'Dividend Tax Calculator') {
                    _showingDividendTaxScreen = true;
                  } else if (calculatorType == 'General Tax Calculator') {
                    _showingGeneralTaxScreen = true;
                  } else if (calculatorType == 'Capital Gains Tax Calculator'){
                    _showingCapitalGainsTaxScreen = true;
                  }
                });
              },
            )
                : SelectRegionScreen(
              onBackToHome: () {
                setState(() {
                  _showingRegionScreen = false;
                  _selectedIndex = 0;
                });
              },
              onRegionSelected: () {
                setState(() => _showingCalculatorScreen = true);
              },
            ),
            _screens[1], // Chat
            _screens[2], // Profile
            _screens[3], // Settings
          ],
        ),
        bottomNavigationBar: _buildBottomNavBar(),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _showingRegionScreen ||
          _showingCalculatorScreen ||
          _showingCorporateTaxScreen ||
          _showingSelfEmployedTaxScreen ||
          _showingVATTaxScreen ||
          _showingDividendTaxScreen
          ? 1 : _selectedIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
      unselectedItemColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
      backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Calculator'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                _buildSearchBar(context),
                const SizedBox(height: 20),
                _buildSectionTitle('Featured Topics', isDarkMode),
                const SizedBox(height: 10),
                _buildFeaturedTopics(context, isDarkMode),
                const SizedBox(height: 20),
                _buildSectionTitle('Recent Activity', isDarkMode),
                const SizedBox(height: 10),
                _buildRecentActivityCard(context, isDarkMode),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: searchController,
        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        decoration: InputDecoration(
          hintText: 'Search UK tax topics or ask a question',
          hintStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          prefixIcon: const Icon(Icons.mic, color: Color(0xFF49B3CD)),
          suffixIcon: IconButton(
            icon: const Icon(Icons.search, color: Colors.grey),
            onPressed: () {
              SearchService.searchUKTax(searchController.text);
            },
          ),
        ),
        onSubmitted: (query) {
          SearchService.searchUKTax(query);
        },
      ),
    );
  }

  Widget _buildFeaturedTopics(BuildContext context, bool isDarkMode) {
    List<String> topics = [
      'Capital Gains',
      'Corporate Tax',
      'Dividend Tax',
      'Self Employment',
      'VAT'
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: 2.3,
      ),
      itemCount: topics.length,
      itemBuilder: (context, index) {
        return _buildTopicCard(context, topics[index], isDarkMode);
      },
    );
  }

  Widget _buildSectionTitle(String title, bool isDarkMode) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontFamily: 'OakSans',
        fontWeight: FontWeight.bold,
        color: isDarkMode ? Colors.white : const Color(0xFF043377),
      ),
    );
  }

  Widget _buildTopicCard(BuildContext context, String title, bool isDarkMode) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TaxAssistantScreen(topic: title)),
      ),
      child: Container(
        width: 140,
        height: 80,
        padding: const EdgeInsets.all(12),
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'OakSans',
                color: isDarkMode ? Colors.white : const Color(0xFF043377),
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "Learn >",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF49B3CD),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildRecentActivityCard(BuildContext context, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tax Deadline Reminder',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'OakSans',
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : const Color(0xFF043377),
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Self Assessment Deadline: 31 October',
            style: TextStyle(fontSize: 14, color: Color(0xFF49B3CD)),
          ),
        ],
      ),
    );
  }
}