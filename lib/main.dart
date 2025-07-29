import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const DisponentkaInesApp());
}

class DisponentkaInesApp extends StatelessWidget {
  const DisponentkaInesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Disponentka INES',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const DisponentkaScreen(),
    );
  }
}

class DisponentkaScreen extends StatefulWidget {
  const DisponentkaScreen({super.key});

  @override
  _DisponentkaScreenState createState() => _DisponentkaScreenState();
}

class _DisponentkaScreenState extends State<DisponentkaScreen> {
  String odgovor = '';
  TextEditingController kontroler = TextEditingController();

  Future<void> posljiVprasanje() async {
    const apiKey = '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';
    const apiUrl = 'https://api.openai.com/v1/chat/completions';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "user", "content": kontroler.text}
        ]
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      setState(() {
        odgovor = json['choices'][0]['message']['content'];
      });
    } else {
      setState(() {
        odgovor = 'Napaka pri pošiljanju.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Disponentka INES')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: kontroler,
              decoration: const InputDecoration(labelText: 'Vprašanje'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: posljiVprasanje,
              child: const Text('Pošlji'),
            ),
            const SizedBox(height: 24),
            Text(odgovor),
          ],
        ),
      ),
    );
  }
}
