import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:open_ai_chat_bot/OpenAI/openai_service.dart';
import 'package:open_ai_chat_bot/widgets/welcome_ui.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Message {
  final String text;
  final bool isUser;
  final bool isImage;

  Message({
    required this.text,
    required this.isUser,
    required this.isImage,
  });
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();
  final SpeechToText speechToText = SpeechToText();
  final OpenAIService openAIService = OpenAIService();
  List<Message> messages = [];
  FlutterTts flutterTts = FlutterTts();
  String currentSpeech = '';
  bool isListening = false;
  bool isProcessingMessage = false;
  bool isSpeaking = false;


  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
    isSpeaking = false;
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {
      isListening = true;
    });
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {
      isListening = false;
    });
  }

  void onSpeechResult(SpeechRecognitionResult result) async {
    final recognizedWords = result.recognizedWords;
    print(recognizedWords);

    setState(() {
      currentSpeech = recognizedWords;
    });

    if (!speechToText.isListening) {
      final userMessage = Message(
        text: currentSpeech,
        isUser: true,
        isImage: false,
      );
      setState(() {
        messages.add(userMessage);
        isProcessingMessage = true;
      });

      final response = await openAIService.isArtPromptAPI(currentSpeech);

      final botMessage = Message(
        text: response,
        isUser: false,
        isImage: response.contains('https://oaidalleapiprodscus.blob.core.windows.net'),
      );
      setState(() {
        messages.add(botMessage);
        isProcessingMessage = false;
      });

      setState(() {
        currentSpeech = '';
      });

      // await systemSpeak(response);
    }
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        title: const Text(
          "Buddy",
          style: TextStyle(fontWeight: FontWeight.w800, color: Colors.blueAccent),
        ),
        centerTitle: true,

      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Visibility(
                    visible: messages.isEmpty || isListening,
                    child: WelcomeUI(),
                  ),
                  Visibility(
                    visible: messages.isNotEmpty,
                    child: FadeInUp(
                      delay: Duration(milliseconds: 100),
                      child: Column(
                        children: messages.map((message) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Align(
                              alignment:
                              message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                              child: message.isImage
                                  ? SizedBox(
                                width: screenWidth * 0.8,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                        message.text,
                                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) {
                                            // Image has finished loading
                                            return child;
                                          } else {
                                            // Image is still loading, show a CircularProgressIndicator
                                            return Center(
                                              child: LoadingAnimationWidget.threeArchedCircle(
                                                  color: Colors.blueAccent,
                                                  size: 50
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                )
                                ,
                              )
                                  : Stack(
                                children: [
                                  Container(
                                    width: screenWidth * 0.8,
                                    padding: EdgeInsets.only(left: screenWidth * 0.02, right: screenWidth * 0.02, top: screenWidth * 0.02, bottom: screenWidth * 0.04),
                                    decoration: BoxDecoration(
                                      color: message.isUser
                                          ? Colors.blueAccent.shade200
                                          : Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(15),
                                        topRight: const Radius.circular(15),
                                        bottomLeft: message.isUser
                                            ? const Radius.circular(15)
                                            : const Radius.circular(0),
                                        bottomRight: message.isUser
                                            ? const Radius.circular(0)
                                            : const Radius.circular(15),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: message.isUser
                                              ? Colors.white
                                              : Colors.blueAccent.shade100,
                                          blurRadius: 5,
                                        ),
                                      ],
                                      border: Border.all(
                                        color: message.isUser
                                            ? Colors.blueAccent
                                            : Colors.blue.withOpacity(0.2),
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Text(
                                      message.text,
                                      style: TextStyle(
                                        color: message.isUser ? Colors.white : Colors.black,
                                        fontSize: 15,
                                        fontFamily: 'Cera-Pro',
                                      ),
                                    ),
                                  ),
                                  if (!message.isUser) // Show the IconButton when message.isUser is false
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: IconButton(
                                        onPressed: () async {
                                          setState(() {
                                            isSpeaking = !isSpeaking; // Toggle the speaking state
                                          });

                                          if (isSpeaking) {
                                            await flutterTts.stop();
                                          } else {

                                            await systemSpeak(message.text);
                                          }
                                        },
                                        icon: Icon(
                                          isSpeaking ? Icons.volume_up : Icons.volume_off, size: 20,
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                    ),
                                ],
                              )
                              ,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  if (/*isListening ||*/ isProcessingMessage)
                    FadeInUp(
                      delay: Duration(milliseconds: 150),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(alignment: Alignment.centerLeft,
                          child: Container(
                            //width: screenWidth * 0.1,
                            padding: EdgeInsets.only(left: screenWidth * 0.04, right: screenWidth * 0.04, top: screenWidth * 0.02, bottom: screenWidth * 0.01),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(15),
                                  topRight: const Radius.circular(15),
                                  bottomLeft: const Radius.circular(0),
                                bottomRight: const Radius.circular(15),


                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueAccent.shade100,
                                  blurRadius: 5,
                                ),
                              ],
                              border: Border.all(
                                color: Colors.blue.withOpacity(0.2),
                                width: 1.0,
                              ),
                            ),
                            child: LoadingAnimationWidget.staggeredDotsWave(
                                color: Colors.blueAccent,
                                size: 30
                            ),
                          ),
                        ),
                      ),
                    )
                  ,
                ],
              ),
            ),
          ),
          SizedBox(height: 5,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10),
                width: screenWidth * 0.75,
                //height: screenWidth * 0.13,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade400,
                      blurRadius: 10,
                    ),
                  ],
                ),
                padding: const EdgeInsets.only(left: 10, right: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          cursorColor: Colors.blueAccent,
                          controller: messageController,
                          decoration: const InputDecoration(
                            hintText: "Type your message...",
                            border: InputBorder.none,
                          ),
                          maxLines: null,
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          onPressed: () async {
                            final userMessageText = messageController.text;
                            messageController.clear();
                            if (userMessageText.isNotEmpty) {
                              final userMessage = Message(
                                text: userMessageText,
                                isUser: true,
                                isImage: false,
                              );
                              setState(() {
                                messages.add(userMessage);
                                isProcessingMessage = true;
                              });

                              final response = await openAIService.isArtPromptAPI(userMessageText);

                              final botMessage = Message(
                                text: response,
                                isUser: false,
                                isImage: response.contains(
                                  'https://oaidalleapiprodscus.blob.core.windows.net',
                                ),
                              );
                              setState(() {
                                messages.add(botMessage);
                                isProcessingMessage = false;
                              });
                            }
                          },
                          icon: const Icon(
                            Icons.send,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: const EdgeInsets.only(left: 2),
                  width: screenWidth * 0.15,
                  height: screenWidth * 0.13,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: IconButton(
                      onPressed: () async {
                        if (await speechToText.hasPermission &&
                            speechToText.isNotListening) {
                          await startListening();
                        } else if (speechToText.isListening) {
                          await stopListening();
                        } else {
                          await initSpeechToText();
                        }
                      },
                      icon: Icon(
                        speechToText.isListening ? Icons.stop : Icons.mic,
                        color: speechToText.isListening ? Colors.black : Colors.blueAccent,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
