import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> messages = [];
  final ScrollController _scrollController = ScrollController();
  String typingText = '';
  String animatedResponse = '';

  GenerativeModel? _model;
  ChatSession? _chat;
  bool hasLoadedData = false;
  String userDataJson = '{}';

  void startTypingAnimation() {
    typingText = 'Typing';
    int dotCount = 0;

    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!mounted || !messages.any((m) => m['content'] == typingText)) {
        timer.cancel();
        return;
      }

      setState(() {
        dotCount = (dotCount + 1) % 4; // 0 to 3 dots
        typingText = 'Typing${'.' * dotCount}';
        final index = messages.indexWhere(
          (m) => m['content']!.startsWith('Typing'),
        );
        if (index != -1) {
          messages[index] = {'role': 'ai', 'content': typingText};
        }
      });
    });
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    if (apiKey.isEmpty) {
      throw Exception(
        "GEMINI_API_KEY is not set in the environment variables.",
      );
    }
    _model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: apiKey);
    _chat = _model?.startChat(); // Creates session memory

   // Add welcome message
    messages.add({
      'role': 'ai',
      'content': '''
  👋 Hi there! I’m your iPocket AI Assistant.

  I can help you with:
  • 🔍 Reviewing your expenses
  • 💡 Giving savings suggestions
  • 📊 Summarizing your spending
  • 🧠 Budgeting and planning

  Try asking:
  - "Show me my expenses from last month"
  - "How can I save more money?"
  - "What’s my biggest expense category?"

  ''',
    });
  }

  /// Load user's transactions from Firestore and convert to JSON
  Future<String> loadUserDataAsJson() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return '{}';

    try {
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.email)
              .collection('transactions')
              .get();

      final dataList =
          querySnapshot.docs.map((doc) {
            final data = doc.data();
            if (data['dateTime'] is Timestamp) {
              data['dateTime'] =
                  (data['dateTime'] as Timestamp).toDate().toIso8601String();
            }
            return data;
          }).toList();

      return jsonEncode({'transactions': dataList});
    } catch (e) {
      return '{}';
    }
  }

  /// Send a user message to Gemini (with memory)
  Future<String> askGemini(
    String message, {
    bool isFirstMessage = false,
  }) async {
    if (_chat == null) return "❌ Chat session not ready.";

    final prompt = isFirstMessage
          ? '''
      You are a helpful AI financial assistant. 
      Reply using a paragraph of less than 100 words.

      ONLY answer questions related to finance, money management, budgeting, expenses, investments, and saving tips.
      If the user's question is unrelated to finance (for example: asking about coding, recipes, weather, movies, etc), politely respond with:
      "I'm sorry, I can only assist with financial topics."

      Here is the user's transaction data in JSON format: $userDataJson

      Now here is their first question: $message
      '''
          : message;


    try {
      final response = await _chat!.sendMessage(Content.text(prompt));
      return response.text ?? "⚠️ No response.";
    } catch (e) {
      return "⚠️ Error talking to Gemini: $e";
    }
  }

  /// Build the chat UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B132B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1B3E).withOpacity(0.85),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "iChat - AI Assistant",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.white.withOpacity(0.8), height: 1),
        ),
      ),
      body: Stack(
        children: [
          // 🔵 BACKGROUND IMAGE WITH ZOOM ANIMATION
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/chatbot_background.png",
                ), // ✅ Use your image here
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 💬 Chat UI with Glass Effect
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              backgroundBlendMode: BlendMode.darken,
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(top: 100, bottom: 20),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isUser = msg['role'] == 'user';

                      return Align(
                        alignment:
                            isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isUser
                                    ? Colors.white.withOpacity(0.1)
                                    : Colors.blueAccent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color:
                                  isUser
                                      ? Colors.white38
                                      : Colors.blueAccent.withOpacity(0.3),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            msg['content'] ?? '',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // 🔲 INPUT + SEND (Semi-transparent input bar)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 20,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: "Ask something...",
                              hintStyle: TextStyle(color: Colors.white54),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final question = _controller.text.trim();
                            if (question.isEmpty) return;
                            _controller.clear();

                            FocusScope.of(context).unfocus();

                            setState(() {
                              messages.add({
                                'role': 'user',
                                'content': question,
                              });
                            });
                            scrollToBottom();

                            if (!hasLoadedData) {
                              setState(() {
                                messages.add({
                                  'role': 'ai',
                                  'content':
                                      'Fetching your data, please wait...',
                                });
                              });

                              userDataJson = await loadUserDataAsJson();
                              messages.removeLast();

                              if (userDataJson == '{}' ||
                                  userDataJson.isEmpty) {
                                setState(() {
                                  messages.add({
                                    'role': 'ai',
                                    'content':
                                        '❗ No transactions found in your data.',
                                  });
                                });
                                return;
                              }

                              final reply = await askGemini(
                                question,
                                isFirstMessage: true,
                              );

                              setState(() {
                                messages.add({'role': 'ai', 'content': reply});
                                hasLoadedData = true;
                              });
                            } else {
                              setState(() {
                                typingText = 'Typing...';
                                messages.add({
                                  'role': 'ai',
                                  'content': typingText,
                                });
                              });
                              startTypingAnimation();

                              final reply = await askGemini(question);

                              setState(() {
                                messages.removeWhere(
                                  (m) => m['content']!.startsWith('Typing'),
                                );
                                messages.add({'role': 'ai', 'content': reply});
                              });
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOut,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.amber.shade600.withOpacity(0.8),
                            ),
                            child: const Icon(Icons.send, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
