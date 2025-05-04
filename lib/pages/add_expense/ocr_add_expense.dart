import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:iPocket/pages/add_expense/add_expense.dart';
import 'package:iPocket/widgets/custom_three_dot_menu.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';

class OCRAddExpensePage extends StatefulWidget {
  @override
  _OCRAddExpensePageState createState() => _OCRAddExpensePageState();
}

class _OCRAddExpensePageState extends State<OCRAddExpensePage> {
  File? _selectedImage;
  String? _imagepath;
  final ImagePicker _picker = ImagePicker();
  String? _geminiResponse; // To store the extracted data

  // Function to pick image from gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        _imagepath = image.path;
      });
    }
  }

  // Function to show image picker options
  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blue),
              title: const Text('Open Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.green),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  // Function to show full image in a dialog
  void _showFullImageDialog() {
    if (_selectedImage == null) return;
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            backgroundColor: Colors.black,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(
                  context,
                ); //_geminiResponse=  _sendImageToGemini();
              },
              child: InteractiveViewer(
                panEnabled: true,
                boundaryMargin: const EdgeInsets.all(10),
                minScale: 0.5,
                maxScale: 3.0,
                child: Image.file(_selectedImage!, fit: BoxFit.contain),
              ),
            ),
          ),
    );
  }

  Future<String?> _sendImageToGemini() async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => const Center(
            child: CircularProgressIndicator(color: Color(0xffdaa520)),
          ),
    );
    if (_selectedImage == null) return null;

    final apiKey =
        "api key"; //Platform.environment['GEMINI_API_KEY'];
    /*if (apiKey == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('API key not found')));
      return;
    }*/

    /*final schema = Schema.object(properties: {
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
          'Miscellaneous'
        ],
        description: 'Expense category chosen from predefined options.',
        nullable: true,
      ),
      'amount': Schema.number(description: 'Expense Total Amount', nullable: true),
      'description': Schema.string(description: 'Short description of the expense,no more than 10 words', nullable: true),
    });*/

    final model = GenerativeModel(
      model: 'gemini-1.5-flash', // Ensure this is a valid model name
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 1,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 50,
        responseMimeType: 'application/json',
        //responseSchema: schema,
      ),
      systemInstruction: Content.system("""
        Extract the expense details from the following receipt image.

        Return the result in *ONE valid JSON format* with the following structure:
        {
          "category": "<category>",
          "amount": <amount>,
          "description": "<short description>"
        }

        ### *Instructions:*
        - *expenseCategory*: Identify the most suitable category from the following:
          - "Groceries"
          - "Subscription"
          - "Food"
          - "Shopping"
          - "Healthcare"
          - "Transportation"
          - "Utilities"
          - "Housing"
          - If the category does not match any of the above, classify it as *"Miscellaneous"*.

        - *totalAmount: Extract the **final total amount paid* from the receipt. Look for keywords such as:
          - "Total"
          - "Grand Total"
          - "Amount Due"
          - "Balance Due"
          - "Subtotal" (only if no total amount is found)
          If multiple amounts are listed, *prioritize the one associated with "Total" or "Grand Total"* rather than just the last number.

        - *description*: Provide a concise description summarizing the transaction purchased product based on the extracted text.For example, where, which company/restaurant. no more than 10 words

        Ensure that the JSON output is correctly formatted and does not contain extra explanations.
        """),
    );

    final chat = model.startChat();

    try {
      Uint8List imageBytes =
          await _selectedImage!.readAsBytes(); // Read file as bytes

      print("image path: ${_imagepath}");

      final content = Content.multi([
        TextPart("What do you see in this image?"),
        DataPart('image/jpeg', imageBytes),
      ]);

      // Step 2: Send to Gemini chat
      final response = await chat.sendMessage(content);
      setState(() {
        print("response: ${response.text}");
        _geminiResponse = response.text;
      });
      return response.text;
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error processing image')));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE8E8E8),
      appBar: AppBar(
        title: const Text(
          'iScan (Scan the Receipt)',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'INVOICE / RECEIPT',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => _showFullImageDialog(),
              child: Container(
                width: double.infinity,
                height: 400,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child:
                    _selectedImage == null
                        ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add, color: Colors.grey, size: 40),
                            const Text(
                              'Add Invoice',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        )
                        : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _selectedImage!,
                            width: double.infinity,
                            height: 150,
                            fit: BoxFit.cover, // Keeps the aspect ratio
                          ),
                        ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'For the best OCR accuracy, ensure the receipt is well-lit, wrinkle-free, and placed on a flat surface. '
              'Avoid shadows, excessive glare, or blurry images. Clear, high-quality scans improve text recognition and data extraction.',
              style: TextStyle(color: Colors.red, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20), // Spacing before the button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // TODO: Handle OCR submission logic here
                    _geminiResponse = await _sendImageToGemini();
                    Map<String, dynamic> jsonResponse = jsonDecode(
                      _geminiResponse!,
                    );
                    print('json: $jsonResponse');
                    print(jsonResponse['amount'].runtimeType);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => AddExpensePage(
                              expenseCategory: jsonResponse['category'],
                              totalAmount: jsonResponse['amount'].runtimeType==double?jsonResponse['amount']:double.parse(jsonResponse['amount']),
                              description: jsonResponse['description'],
                            ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xffDAA520,
                    ), // ✅ Goldenrod color
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
                ElevatedButton(
                  onPressed: () {
                    _showImagePickerOptions(); //_showFullImageDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xffDAA520,
                    ), // ✅ Goldenrod color
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
                    'Add',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
