import 'package:flutter/material.dart';
import '../splash_screens/tax_calculator.dart';
import '../splash_screens/settings.dart';
import '../splash_screens/profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Tracks the active tab index

  final List<Widget> _screens = [
    const HomeContent(), // Home Content
    const TaxCalculatorScreen(), // Tax Calculator
    Center(child: Text('Chat Screen')), // Placeholder for Chat
    const ProfileScreen(), // Placeholder for Profile
    const SettingsScreen(), // Placeholder for Settings
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex != 0) {
          // If not on the home tab, navigate back to Home instead of exiting
          setState(() {
            _selectedIndex = 0;
          });
          return false;
        }
        return true; // Allow exiting the app when on Home tab
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xFF004B9C),
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('assets/images/image1.png'),
                radius: 18,
              ),
              const SizedBox(width: 10),
              const Text(
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
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
        bottomNavigationBar: _buildBottomNavBar(),
      ),
    );
  }

  /// **🔹 Bottom Navigation Bar**
  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF004B9C),
      unselectedItemColor: Colors.grey,
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

/// **🏠 Home Content (Separated for Better Management)**
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildSearchBar(),
            const SizedBox(height: 20),
            _buildSectionTitle('Featured Topics'),
            const SizedBox(height: 10),
            _buildFeaturedTopics(),
            const SizedBox(height: 20),
            _buildSectionTitle('Recent Activity'),
            const SizedBox(height: 10),
            _buildRecentActivityCard(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// **🔍 Search Bar**
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: 'Search UK tax topics or ask a question',
          hintStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          prefixIcon: const Icon(Icons.mic, color: Color(0xFF49B3CD)),
          suffixIcon: const Icon(Icons.search, color: Colors.grey),
        ),
      ),
    );
  }

  /// **📌 Section Titles**
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontFamily: 'OakSans',
        fontWeight: FontWeight.bold,
        color: Color(0xFF043377),
      ),
    );
  }

  /// **📚 Featured Topics**
  Widget _buildFeaturedTopics() {
    List<Map<String, String>> topics = [
      {'title': 'Self-Assessment'},
      {'title': 'VAT Returns'},
      {'title': 'Business Tax'},
      {'title': 'Tax Credits'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.8,
      ),
      itemCount: topics.length,
      itemBuilder: (context, index) {
        return _buildTopicCard(topics[index]['title']!);
      },
    );
  }

  /// **📌 Topic Card with "Learn >" Button**
  Widget _buildTopicCard(String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withAlpha(50), blurRadius: 5, spreadRadius: 2),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'OakSans',
              fontWeight: FontWeight.bold,
              color: Color(0xFF043377),
            ),
          ),
          const SizedBox(height: 13),
          GestureDetector(
            onTap: () {
              // Navigate to respective topic page (Future implementation)
            },
            child: Row(
              children: const [
                Text(
                  'Learn',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'OakSans',
                    color: Color(0xFF49B3CD),
                  ),
                ),
                SizedBox(width: 5),
                Icon(Icons.arrow_forward, size: 16, color: Color(0xFF49B3CD)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// **🕒 Recent Activity**
  Widget _buildRecentActivityCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withAlpha(50), blurRadius: 5, spreadRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Tax Deadline Reminder',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'OakSans',
              fontWeight: FontWeight.bold,
              color: Color(0xFF043377),
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Self Assessment deadline: 31 January',
            style: TextStyle(fontSize: 14, color: Color(0xFF49B3CD)),
          ),
        ],
      ),
    );
  }
}
