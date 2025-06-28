import 'package:flutter/material.dart';
import 'package:free/pages/chat_bot_page.dart';
import 'package:free/pages/community_page.dart';
import 'package:free/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

@override
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/community': (context) => CommunityPage(),
        '/chatbotpage': (context) => ChatBotPage(),
      },
    );
  }
}
