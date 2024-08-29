import 'package:image_picker/image_picker.dart';

class Utils {
  static Future<XFile?> _pickImage() async {
    XFile? file;

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        file = image;
      }
    } catch (e) {
      print("Image picker error: $e");
    } finally {}
    return file;
    ;
  }
}
