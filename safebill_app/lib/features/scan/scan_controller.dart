import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../core/models/document.dart';
import '../../core/providers.dart';

final scanControllerProvider =
    StateNotifierProvider<ScanController, AsyncValue<Document?>>(
  ScanController.new,
);

class ScanController extends StateNotifier<AsyncValue<Document?>> {
  ScanController(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;
  final _picker = ImagePicker();
  final _uuid = const Uuid();

  Future<void> scanInvoice() async {
    final imageFile = await _picker.pickImage(source: ImageSource.camera);
    if (imageFile == null) return;

    state = const AsyncValue.loading();
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);

    try {
      final recognizedText = await recognizer.processImage(
        InputImage.fromFilePath(imageFile.path),
      );
      final rawText = recognizedText.text;
      final document = await ref.read(documentRepositoryProvider).extractAndSave(
        userId: 'local_user',
        docId: _uuid.v4(),
        rawText: rawText,
      );
      state = AsyncValue.data(document);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    } finally {
      await recognizer.close();
    }
  }
}

