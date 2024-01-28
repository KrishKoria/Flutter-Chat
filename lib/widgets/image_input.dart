import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onSelectImage});
  final void Function(File pickedImage) onSelectImage;
  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  void _takePicture() async {
    bool? isCamera = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child:
                  Text("Camera", style: Theme.of(context).textTheme.titleLarge),
            ),
            const SizedBox(
              height: 24,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Gallery",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
      ),
    );

    final imagePicker = ImagePicker();
    if (isCamera == null) {
      return;
    }
    final pickedImage = await imagePicker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 150,
      maxHeight: 150,
      imageQuality: 50,
    );
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _storedImage = File(pickedImage.path);
    });
    widget.onSelectImage(_storedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage:
              _storedImage != null ? FileImage(_storedImage!) : null,
        ),
        TextButton.icon(
          onPressed: _takePicture,
          icon: const Icon(Icons.image),
          label: Text(
            "Add Image",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
