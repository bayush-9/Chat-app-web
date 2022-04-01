import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class GroupIconPicker extends StatefulWidget {
  GroupIconPicker(this.imagePickedFn);
  final void Function(File pickedImage) imagePickedFn;
  @override
  _GroupIconPickerState createState() => _GroupIconPickerState();
}

class _GroupIconPickerState extends State<GroupIconPicker> {
  File _pickedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
        source: ImageSource.gallery, imageQuality: 20, maxWidth: 150);
    final pickedImageFile = File(pickedImage.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    widget.imagePickedFn(pickedImageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 90,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage) : null,
        ),
        FlatButton.icon(
          onPressed: _pickImage,
          icon: Icon(Icons.image),
          label: Text("Pick image"),
        ),
      ],
    );
  }
}
