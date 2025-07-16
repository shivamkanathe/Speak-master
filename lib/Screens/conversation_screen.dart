import 'dart:convert';

import 'package:communicate/helperfunction.dart/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final SpeechToText _speechToText = SpeechToText();

  bool _isSpeechEnabled = false;
  String _wordsSpoken = "";
  String _aiAnswer = "";
  bool _isListening = false;
  bool _isLoadingAnswer = false;

  final FlutterTts flutterTts = FlutterTts();
  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    _isSpeechEnabled = await _speechToText.initialize();
    Gemini.init(apiKey: GeminiService().apiKey.toString(), enableDebugging: true);
    print("checking api response here ${GeminiService().apiKey}"); 
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      _isListening = true;
      _isLoadingAnswer = false;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
    print(" wokring result here now ${_wordsSpoken}");
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _wordsSpoken = "${result.recognizedWords}";
    });
    if (result.finalResult) {
      //  GeminiService().generateContent(_wordsSpoken);
      setState(() {
        _isListening = false;
        _isLoadingAnswer = true;
      });
      processInput(_wordsSpoken);
    }
  }


  Future<void> processInput(String input) async {
    print("Working this function");
    final gemini = Gemini.instance;
    int retries = 3;
    int attempt = 0;

    final prompt = """
You are an English tutor helping a student practice spoken English.
Here is what the student said: "$input"

Tasks:
1. If there are any vocabulary mistake, correct them.
2. Show the corrected version in short.
3. Explain what was wrong and how to improve in short.
4. While explaining what was wrong you can use hindi language only for explaining but in short way.
5. Don't focus on written mistake as user trying to improve voice based communication skills so just focus on what user said not written grammer mistake.
6. Avoid saying "" again and again if it come in sentence.
7. Try to keep more clear and short as possible.
8. If answer is correct than ask new question or keep conversation going on don't explain other things.
9. Then ask a follow-up question to keep the conversation going.
10. Keep your answer very short and friendly.
"""; 

    while (attempt < retries) {
      try {
        final value = await gemini.text(prompt);
        print("Final output here: ${value?.output}");
        setState(() {
          _aiAnswer = "${value?.output}";
          _isLoadingAnswer = false;
        });
        textToSpeech("${value?.output}");
        return;
      } catch (e) {
        print("Gemini error (attempt $attempt): $e");
        if (e.toString().contains('503')) {
          attempt++;
          await Future.delayed(Duration(seconds: 2 * attempt)); // exponential backoff
          continue; // retry
        } else {
          setState(() {
            _aiAnswer = "Something went wrong: $e";
            _isLoadingAnswer = false;
          });
          return;
        }
      } 
    }

    setState(() {
      _aiAnswer = "Server busy. Please try again later.";
      _isLoadingAnswer = false;
    });
  }

  

  Future<void> textToSpeech(String result) async {
  // Detect simple Hindi or English — for demo, you can improve this!
  bool isHindi = RegExp(r'[\u0900-\u097F]').hasMatch(result);

  if (isHindi) {
    await flutterTts.setLanguage("hi-IN");
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.setPitch(0.9);
    await flutterTts.setVolume(1.0);
  } else {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.setPitch(1.0);
    await flutterTts.setVolume(1.0);
  }

  await flutterTts.speak(result); 
  setState(() {
    _isLoadingAnswer = false;
  });
}


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voice Chat', style: TextTheme.of(context).bodyLarge),
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                _speechToText.isListening
                    ? "Listening... say"
                    : _isSpeechEnabled
                    ? "Tap the mic to communicate"
                    : "Oops! Speech recognition isn't available.",
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                   _wordsSpoken == "" ? SizedBox.shrink() : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(
                            "assets/speak_master.png",
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.3,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Colors.white24,
                          ),
                          child: Text(
                            _wordsSpoken,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.white
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    _isListening
                        ? SizedBox.shrink()
                        : _isLoadingAnswer
                        ? Align(
                          alignment: Alignment.centerRight,
                          child: LoadingAnimationWidget.staggeredDotsWave(
                            color: Colors.white,
                            size: 25,
                          ),
                        )
                        :  _aiAnswer == "" ? SizedBox.shrink() : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                            SizedBox(width: 8),
                            Container(
                              width: MediaQuery.of(context).size.width / 1.3,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: Colors.white10
                              ),
                              child: Text(
                                _aiAnswer,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white
                                ),
                              ),
                            ),
                          ],
                        ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _speechToText.isListening ? _stopListening : _startListening,
        tooltip: 'Listen',
        backgroundColor: const Color.fromARGB(255, 110, 80, 163),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
