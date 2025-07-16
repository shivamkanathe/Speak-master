import 'package:communicate/helperfunction.dart/colors.dart';
import 'package:communicate/helperfunction.dart/theme.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translator/translator.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({Key? key}) : super(key: key);

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final TextEditingController _controller = TextEditingController();
  final GoogleTranslator _translator = GoogleTranslator();
  final FlutterTts _flutterTts = FlutterTts();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _translated = '';
  String _selectedTargetLang = 'hi'; // Hindi by default

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  Future<void> _translate() async {
    if (_controller.text.isEmpty) return;
    final translation = await _translator.translate(
      _controller.text,
      from: 'en',
      to: _selectedTargetLang,
    );
    setState(() {
      _translated = translation.text;
    });
  }

  Future<void> _speak() async {
    if (_translated.isEmpty) return;
    await _flutterTts.setLanguage(_selectedTargetLang == 'hi' ? 'hi-IN' : 'en-US');
    await _flutterTts.awaitSpeakCompletion(true);
    await _flutterTts.speak(_translated);
  }

  Future<void> _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            setState(() {
              _controller.text = result.recognizedWords;
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _flutterTts.stop();
    _speech.stop();
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
        title: Text('Translator',style: Theme.of(context).textTheme.bodyLarge,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: null,
              decoration: InputDecoration(
                hintText: "Enter text or use mic",
                hintStyle: TextStyle(color: Colors.white,fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.border)
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.border)
                ),
                
                suffixIcon: IconButton(
                  icon: Icon(_isListening ? Icons.mic : Icons.mic_none,color: Colors.white,),
                  onPressed: _listen,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _translate,
                  icon: const Icon(Icons.translate),
                  label: const Text('Translate'),
                ),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  dropdownColor: AppColors.cardColor,
                  style: TextStyle(color: Colors.white),
                  value: _selectedTargetLang,
                  items: const [
                    DropdownMenuItem(
                      value: 'hi',
                      child: Text('Hindi'),
                    ),
                     DropdownMenuItem(
                      value: 'en',
                      child: Text('English'),
                    ),
                    
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedTargetLang = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_translated.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _translated,
                  style: const TextStyle(fontSize: 20,color: Colors.black),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _speak,
                icon: const Icon(Icons.volume_up),
                label: const Text('Speak'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
