import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Save image for a specific stage (0 to 4)
Future<File> saveStageImageToFile(Uint8List data, int stage) async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/stage_$stage.png');
  await file.writeAsBytes(data);
  print("💾 Stage $stage image saved to: ${file.path}");

  final prefs = await SharedPreferences.getInstance();
  List<String> paths =
      prefs.getStringList('stage_image_paths') ?? List.filled(5, '');
  paths[stage] = file.path;
  await prefs.setStringList('stage_image_paths', paths);
  return file;
}

/// Load all 5 stage images from local storage
Future<List<File?>> loadStageImages() async {
  final prefs = await SharedPreferences.getInstance();
  List<String> paths = prefs.getStringList('stage_image_paths') ?? List.filled(5, '');
  return paths.map((path) => path.isNotEmpty && File(path).existsSync() ? File(path) : null).toList();
}


/// Clear all saved stage images and reset preferences
Future<void> clearAllStageImages() async {
  final prefs = await SharedPreferences.getInstance();
  List<String> paths = prefs.getStringList('stage_image_paths') ?? [];

  for (final path in paths) {
    if (path.isNotEmpty) {
      final file = File(path);
      if (file.existsSync()) {
        await file.delete();
      }
    }
  }

  await prefs.remove('stage_image_paths');
  print("🧹 All stage images cleared.");
}

