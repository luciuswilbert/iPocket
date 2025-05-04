import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class GeminiImg2ImgService {
  static const String apiUrl =
      'https://gemini-img2img-1082344891584.asia-southeast1.run.app/generate-image';

  static Future<Uint8List?> generateImageFromFile({
    required String prompt,
    required File imageFile,
  }) async {
    try {
      print("🔹 Reading image file...");
      final Uint8List imageBytes = await imageFile.readAsBytes();
      print("✅ Image file read: ${imageBytes.lengthInBytes} bytes");

      final String base64Image = base64Encode(imageBytes);

      final body = jsonEncode({
        "prompt": prompt,
        "image_base64": base64Image,
      });

      print("🌐 Sending POST request to Cloud Run backend...");
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      print("📨 Response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final base64Result = jsonData['image_base64'];
        if (base64Result != null) {
          print("✅ Image received from Cloud Run Gemini API!");
          return base64Decode(base64Result);
        } else {
          print("❗ image_base64 field missing from response.");
        }
      } else {
        print("❌ Error from Cloud Run: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("❗ Exception during Cloud Run request: $e");
    }

    return null;
  }
}
