import 'dart:async';
import 'package:flutter/material.dart';
import 'package:taxbuddy/backend/chat_ai/chat_service.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../splash_screens/home.dart';
import '../splash_screens/tax_calculator.dart';
import '../splash_screens/settings.dart';
import '../splash_screens/chatscreen.dart';
import '../splash_screens/profile.dart';

class TaxAssistantScreen extends StatefulWidget {
  final String topic;

  const TaxAssistantScreen({super.key, required this.topic});

  @override
  _TaxAssistantScreenState createState() => _TaxAssistantScreenState();
}

class _TaxAssistantScreenState extends State<TaxAssistantScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  final ChatService _chatservice = ChatService();
  String content = "Fetching details...";
  bool isPlaying = false;
  int currentSeconds = 0;
  int totalSeconds = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchContent();
    _flutterTts.setCompletionHandler(() {
      setState(() {
        isPlaying = false;
        currentSeconds = 0;
      });
      _timer?.cancel();
    });
  }

  Future<void> _fetchContent() async {
    String aiGeneratedContent = await _chatservice.fetchTaxContentFromAI(
        widget.topic);
    setState(() {
      content = aiGeneratedContent;
    });

    // Estimate duration based on word count
    int estimatedDuration = (aiGeneratedContent
        .split(" ")
        .length / 3).round();
    setState(() {
      totalSeconds = estimatedDuration;
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentSeconds < totalSeconds) {
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
    setState(() {
      isPlaying = !isPlaying;
    });
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tax Assistant"),
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
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(isPlaying ? Icons.pause : Icons
                              .play_arrow),
                          onPressed: _togglePlayback,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text("${_formatTime(
                              currentSeconds)} / ${_formatTime(totalSeconds)}"),
                        ),
                        const Icon(Icons.volume_up),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      // Align button to the left
                      child: ElevatedButton(
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
                  maxHeight: MediaQuery
                      .of(context)
                      .size
                      .height * 0.5, // Limits content height
                ),
                child: SingleChildScrollView(
                  child: Text(content, style: const TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        // Set index according to your tabs
        onTap: (index) {
          // Navigate to other screens accordingly
          switch (index) {
            case 0:
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()));
              break;
            case 1:
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (_) => const TaxCalculatorScreen()));
              break;
            case 2:
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const ChatScreen()));
              break;
            case 3:
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()));
              break;
            case 4:
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()));
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF004B9C),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calculate), label: 'Calculator'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
  }

