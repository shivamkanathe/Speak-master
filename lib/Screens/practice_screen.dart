import 'dart:math';
import 'package:communicate/practice_question.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  bool _isSpeechEnabled = false;
  bool _isListening = false;
  bool _showHindi = false; // true: show Hindi, expect English; false: show English, expect Hindi

  String _promptSentence = "";
  String _expectedAnswer = "";
  String _feedback = "";

  


  @override
  void initState() {
    super.initState();
    initSpeech();
    loadNewSentence();
  }

  void initSpeech() async {
    _isSpeechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void loadNewSentence() {
    final random = Random();
    final randomSentence = sentenceBank[random.nextInt(sentenceBank.length)];
    _showHindi = random.nextBool();

    setState(() {
      if (_showHindi) {
        _promptSentence = randomSentence['hindi']!;
        _expectedAnswer = randomSentence['english']!;
      } else {
        _promptSentence = randomSentence['english']!;
        _expectedAnswer = randomSentence['hindi']!;
      }
      _feedback = "";
    });

    // Speak the prompt too:
    speak(_promptSentence, language: _showHindi ? "hi-IN" : "en-US");
  }

   speak(String text, {String language = "en-US"}) async {
    await _flutterTts.setLanguage(language);
     await _flutterTts.awaitSpeakCompletion(true); 
    await _flutterTts.setSpeechRate(0.4);
    await _flutterTts.speak(text);
  }

  void startListening() async {
    await _speechToText.listen(onResult: onSpeechResult, localeId: _showHindi ? "en_US" : "hi_IN");
    setState(() {
      _isListening = true;
    }); 
  }

  void stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });
  }



  void onSpeechResult(SpeechRecognitionResult result) async{
  if (result.finalResult) {
    final userAnswer = normalize(result.recognizedWords);
    final expected = normalize(_expectedAnswer);

    bool isCorrect = userAnswer == expected;

    if (isCorrect) {
      _feedback = "✅ Correct! Great job.";
     await speak(_feedback);
    } else {
      _feedback = "❌ Incorrect.\nCorrect answer: $_expectedAnswer";
     await speak("Incorrect. The correct translation is: $_expectedAnswer",
          language: _showHindi ? "en-US" : "hi-IN");
    }

    setState(() {
      _isListening = false; 
    });

    Future.delayed(Duration(seconds: 4), () {
      loadNewSentence();
    });
  }
}

String normalize(String input) {
  return input
      .replaceAll(RegExp(r'[^\w\s]'), '')  // remove punctuation
      .replaceAll(RegExp(r'\s+'), ' ')     // collapse multiple spaces
      .trim()
      .toLowerCase();
}



  @override
  void dispose() {
    _speechToText.stop();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios,color: Colors.white,),
        ),
        title: Text('Practice Sentence',style: Theme.of(context).textTheme.bodyLarge,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "🔊 Listen & Translate:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              _promptSentence,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500,color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            if (_feedback.isNotEmpty)
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _feedback.startsWith("✅") ? Colors.green[100] : Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _feedback,
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            Spacer(),
            ElevatedButton.icon(
              onPressed: _isListening ? stopListening : startListening,
              icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
              label: Text(_isListening ? 'Stop Listening' : 'Start Speaking'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}
