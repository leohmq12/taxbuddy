import 'dart:async';
import 'package:flutter/material.dart';
import 'package:taxbuddy/backend/chat_ai/chat_service.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../splash_screens/home.dart';
import '../splash_screens/tax_calculator.dart';
import '../splash_screens/settings.dart';
import '../splash_screens/chatscreen.dart';
import '../splash_screens/profile.dart';
import 'package:google_fonts/google_fonts.dart';

class TaxAssistantScreen extends StatefulWidget {
  final String topic;

  const TaxAssistantScreen({super.key, required this.topic});

  @override
  _TaxAssistantScreenState createState() => _TaxAssistantScreenState();
}

class _TaxAssistantScreenState extends State<TaxAssistantScreen> with TickerProviderStateMixin {
  final FlutterTts _flutterTts = FlutterTts();
  final ChatService _chatservice = ChatService();
  String content = "";
  bool isPlaying = false;
  int currentSeconds = 0;
  int totalSeconds = 0;
  Timer? _timer;
  int _selectedIndex = 0;
  late AnimationController _dotController;
  int _activeDotIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _dotController.addListener(() {
      setState(() {
        _activeDotIndex = (_dotController.value * 3).floor() % 3;
      });
    });

    _fetchContent();
    _flutterTts.setCompletionHandler(() async {
      if (mounted) {
        setState(() {
          isPlaying = false;
          currentSeconds = 0;
        });
      }
      _timer?.cancel();
    });
  }

  Future<void> _fetchContent() async {
    String aiGeneratedContent = await _chatservice.fetchTaxContentFromAI(widget.topic);
    if (mounted) {
      setState(() {
        content = aiGeneratedContent;
        totalSeconds = (aiGeneratedContent.split(" ").length / 3).round();
        _isLoading = false;
      });
    }
  }

  Widget _buildDot(int index) {
    return AnimatedOpacity(
      opacity: _activeDotIndex == index ? 1.0 : 0.3,
      duration: const Duration(milliseconds: 300),
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildLoadingContent() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0), // Matches text content padding
      child: Row(
        children: [
          _buildDot(0),
          const SizedBox(width: 8),
          _buildDot(1),
          const SizedBox(width: 8),
          _buildDot(2),
        ],
      ),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && currentSeconds < totalSeconds) {
        setState(() {
          currentSeconds++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _togglePlayback() async {
    if (isPlaying) {
      await _flutterTts.stop();
      _timer?.cancel();
    } else {
      await _flutterTts.speak(content);
      _startTimer();
    }
    if (mounted) {
      setState(() {
        isPlaying = !isPlaying;
      });
    }
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return "$minutes:${secs.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _timer?.cancel();
    _dotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text(
          "Tax Assistant",
          style: GoogleFonts.urbanist(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[900]
                      : Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                          onPressed: content.isNotEmpty ? _togglePlayback : null,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            content.isNotEmpty
                                ? "${_formatTime(currentSeconds)} / ${_formatTime(totalSeconds)}"
                                : "Loading...",
                            style: TextStyle(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.volume_up,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[800]
                              : Colors.blue,
                          foregroundColor: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.white,
                        ),
                        onPressed: () {},
                        child: const Text("Simplify Jargon"),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 100,
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: _isLoading
                    ? _buildLoadingContent()
                    : Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: SingleChildScrollView(
                    child: Text(content, style: const TextStyle(fontSize: 16)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          switch (index) {
            case 0:
              Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
              break;
            case 1:
              Navigator.push(context, MaterialPageRoute(builder: (_) => const TaxCalculatorScreen()));
              break;
            case 2:
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen()));
              break;
            case 3:
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
              break;
            case 4:
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
              break;
          }
        },
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
      ),
    );
  }
}