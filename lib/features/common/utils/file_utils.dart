import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class FileUtils {
  static Future<Directory> getInternalDirectory() async {
    return await getApplicationDocumentsDirectory();
  }

  static Future<File> getInternalFile(String fileName) async {
    final dir = await getInternalDirectory();
    return File(p.join(dir.path, fileName));
  }

  static Future<Directory> getSetlistDirectory() async {
    final dir = await getInternalDirectory();
    final setlistDir = Directory(p.join(dir.path, 'setlists'));
    if (!setlistDir.existsSync()) {
      setlistDir.createSync(recursive: true);
    }
    return setlistDir;
  }

  static Future<void> copyTxtFilesToInternal(String sourceFolderPath) async {
    final sourceDir = Directory(sourceFolderPath);
    if (!sourceDir.existsSync()) return;

    final targetDir = await getInternalDirectory();

    final txtFiles = sourceDir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.toLowerCase().endsWith('.txt'));

    for (final file in txtFiles) {
      final fileName = p.basename(file.path);
      final newPath = p.join(targetDir.path, fileName);
      final newFile = File(newPath);

      if (!newFile.existsSync()) {
        await file.copy(newPath);
      }
    }
  }
}
