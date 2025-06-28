import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final List<Map<String, dynamic>> _messages = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || isLoading) return;

    setState(() {
      _messages.add({"text": text, "isUser": true});
      _controller.clear();
      isLoading = true;
    });

    _scrollToBottom();

    final history = _messages
        .sublist(0, _messages.length - 1)
        .map(
          (msg) => {
            "role": msg["isUser"] ? "user" : "assistant",
            "content": msg["text"],
          },
        )
        .toList();

    final requestBody = {"user_input": text, "history": history};

    try {
      final response = await http.post(
        Uri.parse('https://perspective-shift-main.onrender.com/chat'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      print("Status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['reply'] ?? "No reply from server.";

        setState(() {
          _messages.add({"text": reply, "isUser": false});
        });
      } else {
        setState(() {
          _messages.add({
            "text": "Server error: ${response.statusCode}",
            "isUser": false,
          });
        });
      }
    } catch (e) {
      print("ERROR: $e");
      setState(() {
        _messages.add({
          "text": "Failed to connect to server.\nError: $e",
          "isUser": false,
        });
      });
    }

    setState(() {
      isLoading = false;
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color.fromARGB(255, 152, 182, 236),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Let’s Talk",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 💬 Chat Area
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final isUser = msg['isUser'] as bool;
                  return Align(
                    alignment: isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisAlignment: isUser
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!isUser)
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.smart_toy,
                                size: 18,
                                color: Colors.black,
                              ),
                            ),
                          if (!isUser) SizedBox(width: 8),
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: isUser
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Text(
                                msg['text'],
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                          if (isUser) SizedBox(width: 8),
                          if (isUser)
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.person,
                                size: 18,
                                color: Colors.black,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            //  Loading indicator
            if (isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),

            //  Input area
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        enabled: !isLoading,
                        decoration: InputDecoration(
                          hintText: "Type something...",
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: isLoading ? null : _sendMessage,
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: isLoading ? Colors.grey : Colors.black,
                      child: Icon(Icons.send, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
