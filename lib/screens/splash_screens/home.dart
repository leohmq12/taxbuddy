import 'package:flutter/material.dart';
import '../splash_screens/tax_calculator.dart';
import '../splash_screens/settings.dart';
import '../splash_screens/profile.dart';
import '../splash_screens/chatscreen.dart';
import '../splash_screens/learn_screen.dart';
import 'package:taxbuddy/backend/search/search_service.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

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
    const TaxCalculatorScreen(),
    const ChatScreen(),
    const ProfileScreen(),
    const SettingsScreen(),
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
          setState(() {
            _selectedIndex = 0;
          });
          return false;
        }
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
        bottomNavigationBar: _buildBottomNavBar(),
      ),
    );
  }

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

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery
              .of(context)
              .size
              .width * 0.05),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                _buildSearchBar(context),
                const SizedBox(height: 20),
                _buildSectionTitle('Featured Topics'),
                const SizedBox(height: 10),
                _buildFeaturedTopics(context),
                const SizedBox(height: 20),
                _buildSectionTitle('Recent Activity'),
                const SizedBox(height: 10),
                _buildRecentActivityCard(),
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Search UK tax topics or ask a question',
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

  Widget _buildFeaturedTopics(BuildContext context) {
    List<String> topics = ['Self-Assessment', 'VAT Returns', 'Business Tax', 'Tax Credits'];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 cards per row
        crossAxisSpacing: 6, // 🔹 Reduced space between columns
        mainAxisSpacing: 6,  // 🔹 Reduced space between rows
        childAspectRatio: 2.3, // 🔹 Adjust for better fitting
      ),
      itemCount: topics.length,
      itemBuilder: (context, index) {
        return _buildTopicCard(context, topics[index]);
      },
    );
  }


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

  Widget _buildTopicCard(BuildContext context, String title) {
    return GestureDetector(
      onTap: () =>
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TaxAssistantScreen(topic: title)),
          ),
      child: Container(
        width: 140, // Keep your custom width
        height: 80, // Keep your custom height
        padding: const EdgeInsets.all(12),
        alignment: Alignment.topLeft, // 🔹 Ensures content starts from top-left
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.grey.withAlpha(50),
                blurRadius: 5,
                spreadRadius: 2)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 🔹 Aligns text to left
          mainAxisAlignment: MainAxisAlignment.start, // 🔹 Keeps content at top
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'OakSans',
                color: Color(0xFF043377),
              ),
            ),
            const SizedBox(height: 5), // 🔹 Small space between title & label
            Text(
              "Learn >",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF49B3CD), // 🔹 Keeps "Learn >" distinct
              ),
            ),
          ],
        ),
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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            'Self Assessment Deadline: 31 October',
            style: TextStyle(fontSize: 14, color: Color(0xFF49B3CD)),
          ),
        ],
      ),
    );
  }
}