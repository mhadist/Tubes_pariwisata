import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'main.dart';
import 'database_user.dart';
import 'database_galeri.dart';
import 'package:flutter/widgets.dart';

class GaleriScreen extends StatefulWidget {
  final User user;

  GaleriScreen({required this.user});

  @override
  _GaleriScreenState createState() => _GaleriScreenState();
}

class _GaleriScreenState extends State<GaleriScreen> {
  DatabaseHelper4 _databaseHelper = DatabaseHelper4();
  List<String> images = [];
  int selectedImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    List<String> loadedImages = await _databaseHelper.getImages();
    setState(() {
      images = loadedImages;
    });
  }

  void _viewImage(int index) {
    setState(() {
      if (index >= 0 && index < images.length) {
        selectedImageIndex = index;
      }
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      String imagePath = pickedFile.path;
      await _databaseHelper.insertImage(imagePath);
      _loadImages();
    }
  }

  void _deleteImage(int index) async {
    if (index >= 0 && index < images.length) {
      int imageId = index + 1; // Assuming the database ID starts from 1
      await _databaseHelper.deleteImage(imageId);
      _loadImages();
      if (selectedImageIndex >= images.length) {
        selectedImageIndex = images.length - 1;
      }
    }
  }

  void _viewFullImage(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) { // Use 'context' here instead of 'dialogContext'
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              children: [
                Expanded(
                  child: Image.file(
                    File(images[index]),
                    fit: BoxFit.cover,
                  ),
                ),
                if (widget.user.role == UserRole.admin)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        _deleteImage(index);
                        Navigator.pop(context);
                      },
                      child: Text("Hapus"),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Galeri"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TourismLobbyPage(userRole: widget.user.role, user: widget.user)),
            );
          },
        ),
      ),
      body: GridView.builder(
        itemCount: images.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _viewFullImage(index);
            },
            child: Image.file(
              File(images[index]),
              fit: BoxFit.cover,
            ),
          );
        },
      ),
      floatingActionButton: widget.user.role == UserRole.admin
          ? Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(width: 16.0),
          FloatingActionButton(
            onPressed: _pickImage,
            child: Icon(Icons.add),
          ),
          SizedBox(width: 16.0),
        ],
      )
          : null,
    );
  }
}
