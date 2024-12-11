import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';

import 'BrowsePostsActivity.dart';

class NewPostActivity extends StatefulWidget {
  @override
  _ImagePickerWithThumbnailsState createState() =>
      _ImagePickerWithThumbnailsState();
}

class _ImagePickerWithThumbnailsState extends State<NewPostActivity> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  List<File> _images = [];

  // Function to show options for taking a photo or picking from gallery
  Future<void> _showImageSourceDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take a Photo'),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_album),
                title: Text('Select from Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to pick an image from the selected source
  Future<void> _pickImage(ImageSource source) async {
    if (_images.length >= 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You can only select up to 4 images.')),
      );
      return;
    }

    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<String> _uploadImageToStorage(File image) async {
    try {
      final String fileId = const Uuid().v4();
      final Reference ref = _storage.ref().child('images/$fileId.jpg');
      final UploadTask uploadTask = ref.putFile(image);

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  Future<void> _submitForm() async {
    final title = _titleController.text.trim();
    final price = double.tryParse(_priceController.text.trim());
    final description = _descriptionController.text.trim();

    if (title.isEmpty || price == null || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields correctly.')),
      );
      return;
    }

    if (_images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please add at least one image.')),
      );
      return;
    }

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Uploading, please wait...')),
      );

      // Upload each image to storage and get the URL
      List<String> imageUrls = [];
      for (var image in _images) {
        final imageUrl = await _uploadImageToStorage(image);
        print("_uploadImageToStorage...imageUrl:"+imageUrl.toString());
        imageUrls.add(imageUrl);
      }

      // Store data in Firestore
      await _firestore.collection('posts').add({
        'title': title,
        'price': price,
        'description': description,
        'images': imageUrls,
        'created_at': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post submitted successfully!')),
      );

      // Clear the form
      _titleController.clear();
      _priceController.clear();
      _descriptionController.clear();
      setState(() {
        _images.clear();
      });

      // Navigate back to the BrowsePostsActivity
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BrowsePostsActivity()),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit post: $e')),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HyperGarageSale'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the previous screen
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input fields
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),

            // Thumbnail images display
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(_images.length, (index) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Thumbnail image
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _images[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Remove button
                    Positioned(
                      top: -10,
                      right: -10,
                      child: IconButton(
                        icon: Icon(Icons.cancel, color: Colors.red),
                        onPressed: () => _removeImage(index),
                      ),
                    ),
                  ],
                );
              }),
            ),

            const SizedBox(height: 20),

            // Buttons
            Row(
              children: [
                ElevatedButton(
                  onPressed: _showImageSourceDialog, // Show image source options
                  child: Text('Add Image'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
