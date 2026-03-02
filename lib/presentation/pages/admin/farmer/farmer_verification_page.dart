import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class FarmerVerificationPage extends StatefulWidget {
  const FarmerVerificationPage({super.key});

  @override
  State<FarmerVerificationPage> createState() =>
      _FarmerVerificationPageState();
}

class _FarmerVerificationPageState extends State<FarmerVerificationPage> {
  final _formKey = GlobalKey<FormState>();

  File? _selectedImage;        // For Mobile
  Uint8List? _webImage;        // For Web

  final ImagePicker _picker = ImagePicker();

  final Color primaryColor = const Color(0xFF1B5E20);
  final Color accentColor = const Color(0xFFFF6F00);
  final Color backgroundColor = const Color(0xFFFAFAFA);

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        setState(() {
          _webImage = bytes;
        });
      } else {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    }
  }

  void _validateAndSubmit() {
    if (!kIsWeb && _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Please upload your photo",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      return;
    }

    if (kIsWeb && _webImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Please upload your photo",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: primaryColor,
          content: const Text(
            "Details sent to Admin for Verification",
            style: TextStyle(color: Colors.white),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        toolbarHeight: 90,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1B5E20),
                Color(0xFF43A047),
              ],
            ),
          ),
        ),
        title: const Text(
          "Verification",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              Icon(
                Icons.verified_user,
                size: 90,
                color: primaryColor,
              ),

              const SizedBox(height: 20),

              Text(
                "Role: Farmer",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),

              const SizedBox(height: 30),

              GestureDetector(
                onTap: _pickImage,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: primaryColor.withOpacity(0.1),
                      backgroundImage: kIsWeb
                          ? (_webImage != null
                          ? MemoryImage(_webImage!)
                          : null)
                          : (_selectedImage != null
                          ? FileImage(_selectedImage!)
                          : null) as ImageProvider?,
                      child: (kIsWeb && _webImage == null) ||
                          (!kIsWeb && _selectedImage == null)
                          ? Icon(
                        Icons.camera_alt,
                        size: 40,
                        color: primaryColor,
                      )
                          : null,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Upload Farmer Photo",
                      style: TextStyle(
                        fontSize: 16,
                        color: primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _validateAndSubmit,
                  child: const Text(
                    "Verify",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}