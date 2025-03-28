import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:taxbuddy/backend/chat_ai/chat_service.dart';
import 'dart:typed_data';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ChatService _chatService = ChatService();
  final List<Map<String, String>> _messages = [];
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isLoading = false;

  void _sendMessage() async {
    String userMessage = _textController.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "content": userMessage});
      _textController.clear();
      _isLoading = true;
    });

    String botResponse = await _chatService.getResponse(userMessage);

    setState(() {
      _messages.add({"role": "bot", "content": botResponse});
      _isLoading = false;
    });

    // Generate and play AI voice
    Uint8List? audioData = await _chatService.getSpeech(botResponse);
    if (audioData != null) {
      await _audioPlayer.play(BytesSource(audioData));
    }
  }

  Widget _buildChatBubble(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
            ),
          ],
        ),
        constraints: const BoxConstraints(maxWidth: 300),
        child: Text(
          text,
          style: GoogleFonts.urbanist(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: isUser
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
            ),
          ],
        ),
        constraints: const BoxConstraints(maxWidth: 60),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDot(),
            const SizedBox(width: 4),
            _buildDot(delay: 200),
            const SizedBox(width: 4),
            _buildDot(delay: 400),
          ],
        ),
      ),
    );
  }

  Widget _buildDot({int delay = 0}) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 900),
      transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
      child: Container(
        key: ValueKey(delay),
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        automaticallyImplyLeading: false, // Removes the back button
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/images/image1.png'),
              radius: 18,
            ),
            const SizedBox(width: 10),
            Text(
              "AI Tax Assistant",
              style: GoogleFonts.urbanist(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ..._messages.map((msg) => _buildChatBubble(msg["content"]!, msg["role"] == "user")),
                if (_isLoading) _buildTypingIndicator(),
              ],
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.background,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: "Send message...",
                hintStyle: GoogleFonts.urbanist(
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
                ),
                fillColor: Theme.of(context).colorScheme.surface,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            onPressed: _sendMessage,
            backgroundColor: Theme.of(context).colorScheme.primary,
            mini: true,
            child: Icon(Icons.send, color: Theme.of(context).colorScheme.onPrimary),
          ),
        ],
      ),
    );
  }
}
