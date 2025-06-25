import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class FileCopyService {
  /// Kopira sve .txt fajlove iz [sourcePath] u internu memoriju aplikacije
  /// na lokaciju: appDocDir/txt/
  static Future<void> copyTxtFilesToInternal(String sourcePath) async {
    final sourceDir = Directory(sourcePath);
    if (!await sourceDir.exists()) return;

    final appDir = await getApplicationDocumentsDirectory();
    final targetDir = Directory(p.join(appDir.path, 'txt'));

    if (!await targetDir.exists()) {
      await targetDir.create(recursive: true);
    }

    final txtFiles = sourceDir
        .listSync()
        .whereType<File>()
        .where((file) => file.path.toLowerCase().endsWith('.txt'));

    for (final file in txtFiles) {
      final fileName = p.basename(file.path);
      final targetFile = File(p.join(targetDir.path, fileName));
      await file.copy(targetFile.path);
    }
  }
}
