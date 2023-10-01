import 'dart:convert';

import 'package:http/http.dart' as http;

import 'key.dart';

class OpenAIService {
  final List<Map<String, String>> messages = [];

  Future<String> isArtPromptAPI(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIAPIKey',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              "role": "user",
              "content":
              "Clearly understand the message enclosed in curly braces and tell me Does this message wants any type of Image, Art, drawing or anything similar? { $prompt }. Only answer with a YES or NO.  ",
            },
          ],
        }),
      );

      print(response.body);

      if (response.statusCode == 200) {
        String content =
        jsonDecode(response.body)['choices'][0]['message']['content'];
        content = content.trim();

        if (content.toLowerCase() == 'yes') {
          final res = await dallEAPI(prompt);
          return res;
        } else if (content.toLowerCase() == 'no') {
          final res = await chatGptAPI(prompt);
          return res;
        } else {
          // Handle other responses here if needed
          return 'Unrecognized response: $content';
        }
      }

      return 'An internal error occurred';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> chatGptAPI(String prompt) async {
    messages.add({
      'role': 'user',
      'content': prompt,
    });

    try {
      final response = await http.post(
          Uri.parse('https://api.openai.com/v1/chat/completions'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $openAIAPIKey'
          },
          body: jsonEncode({"model": "gpt-3.5-turbo", "messages": messages}));

      print(response.body);

      if (response.statusCode == 200) {
        String content =
            jsonDecode(response.body)['choices'][0]['message']['content'];
        content = content.trim();
        messages.add({'role': 'assistant', 'content': content});

        return content;
      }

      return 'An Internal error occured';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> dallEAPI(String prompt) async {
    messages.add({
      'role': 'user',
      'content': prompt,
    });

    try {
      final response = await http.post(
          Uri.parse('https://api.openai.com/v1/images/generations'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $openAIAPIKey'
          },
          body: jsonEncode({"prompt": prompt, "n": 1, "size": "1024x1024"}));

      print(response.body);

      if (response.statusCode == 200) {
        String imageUrl = jsonDecode(response.body)['data'][0]['url'];
        imageUrl = imageUrl.trim();
        messages.add({'role': 'assistant', 'content': imageUrl});

        return imageUrl;
      }

      return 'An Internal error occured';
    } catch (e) {
      return e.toString();
    }
  }
}
