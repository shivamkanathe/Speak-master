import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GeminiService {
    // String? apiKey = dotenv.env['RAZORPAY_KEY'];
  final String? apiKey = dotenv.env['GEMINI_KEY']; 

}