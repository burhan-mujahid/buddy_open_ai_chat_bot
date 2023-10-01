import 'package:flutter/material.dart';
import 'package:open_ai_chat_bot/chat_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OpenAI Chat Bot',
      theme: ThemeData.light(useMaterial3: true).copyWith(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(background: Colors.white),
      ),
      home: const ChatScreen(),
    );
  }
}

