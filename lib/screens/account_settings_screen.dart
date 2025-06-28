import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AccountSettingsScreen extends StatefulWidget {
  final String userName;
  final String? profileImagePath;
  final Function(String imagePath) onImageUpdated;

  const AccountSettingsScreen({
    super.key,
    required this.userName,
    required this.onImageUpdated,
    this.profileImagePath,
  });

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
      widget.onImageUpdated(picked.path);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.profileImagePath != null) {
      _imageFile = File(widget.profileImagePath!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _imageFile != null
                    ? FileImage(_imageFile!)
                    : null,
                child: _imageFile == null
                    ? const Icon(Icons.person, size: 50)
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.userName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _infoField('Email Address'),
            _infoField('Phone Number'),
            _infoField('Monthly Income'),
            _infoField('Financial Goals'),
          ],
        ),
      ),
    );
  }

  Widget _infoField(String label) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );
}
