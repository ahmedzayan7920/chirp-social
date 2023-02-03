import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

abstract class AppUtils {
  static showSnackBar({
    required BuildContext context,
    required String content,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
      ),
    );
  }

  static String getNameFromEmail(String email) {
    return email.split("@")[0];
  }

  static Future<List<File>> pickMultiImages() async {
    List<File> images = [];
    final selectedImages = await ImagePicker().pickMultiImage();
    if (selectedImages.isNotEmpty) {
      for (final image in selectedImages) {
        images.add(File(image.path));
      }
    }
    return images;
  }

  static Future<File?> pickSingleImage() async {
    final selectedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      return File(selectedImage.path);
    }
    return null;
  }
}
