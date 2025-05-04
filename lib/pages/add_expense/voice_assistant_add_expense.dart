import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:google_speech/google_speech.dart';
import 'package:iPocket/pages/add_expense/add_expense.dart';
import 'package:iPocket/widgets/custom_three_dot_menu.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class RecorderScreen extends StatefulWidget {
  const RecorderScreen({super.key});

  @override
  _RecorderScreenState createState() => _RecorderScreenState();
}

class _RecorderScreenState extends State<RecorderScreen> {
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  bool _isRecording = false;
  bool _isRecorderReady = false;
  String? _recordedFilePath;
  String _recognizedText = 'Text to be recognized';
  String _responseText = 'Categorized text';

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();
    _initialize();
  }

  Future<void> _initialize() async {
    var status = await Permission.microphone.request();
    if (status == PermissionStatus.granted) {
      await _recorder!.openRecorder();
      await _player!.openPlayer();
      setState(() {
        _isRecorderReady = true;
      });
    } else {
      debugPrint('Microphone permission denied');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission is required')),
      );
    }
  }

  @override
  void dispose() {
    _recorder!.closeRecorder();
    _player!.closePlayer();
    super.dispose();
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    if (_isRecorderReady) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String path = '${appDocDir.path}/audio.amr';
      await _recorder!.startRecorder(toFile: path, codec: Codec.amrNB);
      setState(() {
        _isRecording = true;
      });
    }
  }

  Future<void> _stopRecording() async {
    if (_isRecorderReady && _isRecording) {
      _recordedFilePath = await _recorder!.stopRecorder();
      setState(() {
        _isRecording = false;
        _transcribe();
      });
    }
  }

  Future<void> _transcribe() async {
    if (_recordedFilePath != null) {
      final serviceAccount = ServiceAccount.fromString(
        await rootBundle.loadString('service account api key'),
      );
      final speechToText = SpeechToText.viaServiceAccount(serviceAccount);
      final config = RecognitionConfig(
        encoding: AudioEncoding.AMR,
        model: RecognitionModel.basic,
        enableAutomaticPunctuation: true,
        sampleRateHertz: 8000,
        languageCode: 'en-US',
      );
      final audio = File(_recordedFilePath!).readAsBytesSync().toList();
      final response = await speechToText.recognize(config, audio);
      setState(() {
        _recognizedText = response.results
            .map((e) => e.alternatives.first.transcript)
            .join('\n');
      });
    }
  }

  Future<void> _categorize() async {
    if (_recognizedText.isNotEmpty &&
        _recognizedText != 'Text to be recognized') {
      final schema = Schema.object(
        properties: {
          'category': Schema.enumString(
            enumValues: [
              'Shopping',
              'Subscription',
              'Food',
              'Healthcare',
              'Groceries',
              'Transportation',
              'Utilities',
              'Housing',
              'Miscellaneous',
            ],
            description: 'Expense category chosen from predefined options.',
            nullable: true,
          ),
          'amount': Schema.number(
            description: 'Expense Total Amount',
            nullable: true,
          ),
          'description': Schema.string(
            description: 'Concise description of the expense',
            nullable: true,
          ),
        },
      );

      final model = GenerativeModel(
        model: 'gemini-2.0-flash', // Ensure this is a valid model name
        apiKey: 'api key',
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
          responseSchema: schema,
        ),
      );

      final prompt =
          'Extract expense details from this sentence: $_recognizedText. '
          'Return a JSON with category, amount, and description fields.Amount can be in another currency like ringit, no problem just return the amount in that same currency';
      final response = await model.generateContent([Content.text(prompt)]);
      setState(() {
        _responseText = response.text ?? 'Error categorizing text';
        print('Response: $_responseText');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE8E8E8),
      appBar: AppBar(
        title: const Text(
          'iSpeak (Voice Assistant)',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: const Color(0xffDAA520), // Goldenrod
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [CustomThreeDotMenu(context: context)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 400,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 150,
                    width: 300,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        _recognizedText,
                        style: TextStyle(
                          color:
                              _recognizedText == 'Text to be recognized'
                                  ? Colors.grey
                                  : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  GestureDetector(
                    onTap: _toggleRecording,
                    child: Container(
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isRecording ? Colors.red : Color(0xffdaa520),
                      ),
                      child: Icon(
                        _isRecording ? Icons.stop : Icons.mic,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Speak clearly to record your expense (E.g. I bought a pizza for 30 ringit)',
                style: TextStyle(color: Colors.red, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _categorize();
                Map<String, dynamic> jsonResponse = jsonDecode(_responseText);
                print(jsonResponse['amount'].runtimeType);
                print(jsonResponse['amount'].runtimeType==int?jsonResponse['amount'].toDouble():jsonResponse['amount']);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => AddExpensePage(
                          expenseCategory: jsonResponse['category'],
                          totalAmount: jsonResponse['amount'].runtimeType==int?jsonResponse['amount'].toDouble():jsonResponse['amount'],
                          description: jsonResponse['description'],
                        ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffDAA520), // ✅ Goldenrod color
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    12,
                  ), // ✅ Same rounded style
                ),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
