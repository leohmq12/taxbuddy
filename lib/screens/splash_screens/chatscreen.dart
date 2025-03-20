import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[900], // Dark blue app bar
        title: Text(
          "AI Tax Assistant",
          style: GoogleFonts.urbanist(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          // Chat Bubble
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 5),
                        ],
                      ),
                      child: const Text(
                        "Hi there! I'm your AI tax assistant from A&T. How can I help you with your UK taxes today?",
                        style: TextStyle(fontSize: 14, fontFamily: 'OakSans', fontWeight: FontWeight.normal, color: Color(0xFF374151),),
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {},
                      child: const Row(
                        children: [
                          Icon(Icons.volume_up, size: 16, color: Color(0xFF49B3CD)),
                          SizedBox(width: 4),
                          Text(
                            "Listen",
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'OakSans',
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF043377),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Message Input & Suggested Questions
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[200], // Light gray background
            child: Column(
              children: [
                // Input Field
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: "Ask about UK taxes...",
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FloatingActionButton(
                      onPressed: () {}, // Add chat send functionality later
                      backgroundColor: Colors.blue,
                      mini: true,
                      child: const Icon(Icons.send, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Suggested Questions
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Suggested Questions:",
                    style: TextStyle(fontSize: 10,fontFamily: 'OakSans', fontWeight: FontWeight.normal),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildQuestionChip("When is my Self Assessment deadline?"),
                    _buildQuestionChip("How does VAT work?"),
                    _buildQuestionChip("What expenses can I claim?"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function to build question chips
  Widget _buildQuestionChip(String text) {
    return GestureDetector(
      onTap: () {}, // Add functionality later
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 10,fontFamily: 'OakSans', fontWeight: FontWeight.normal),
        ),
      ),
    );
  }
}
