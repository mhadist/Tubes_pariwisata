import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'database_hotel.dart';
import 'main.dart';
import 'database_user.dart';

class HotelPage extends StatefulWidget {
  final User user;
  HotelPage({required this.user});
  @override
  _HotelPageState createState() => _HotelPageState();
}

class _HotelPageState extends State<HotelPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<Hotel> _hotels = [];
  late DatabaseHelper2 _databaseHelper;
  File? _selectedImage;
  List<File?> _selectedRoomImages = [];

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper2();
    _databaseHelper.initDatabase(); // Memanggil initDatabase() setelah inisialisasi _databaseHelper
    _refreshHotelList();
    _selectedRoomImages = List<File?>.filled(3, null);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _refreshHotelList() async {
    List<Hotel> hotels = await _databaseHelper.getHotels();
    setState(() {
      _hotels = hotels;
    });
  }

  void _pickImage() async {
    PickedFile? pickedImage =
    await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = pickedImage != null ? File(pickedImage.path) : null;
    });
  }

  void _pickRoomImages() async {
    List<XFile>? pickedImages = await ImagePicker().pickMultiImage();
    if (pickedImages != null) {
      setState(() {
        for (int i = 0; i < pickedImages.length; i++) {
          _selectedRoomImages[i] = File(pickedImages[i].path);
        }
      });
    }
  }

  void _saveHotel() async {
    if (_formKey.currentState!.validate()) {
      Hotel hotel = Hotel(
        name: _nameController.text,
        address: _addressController.text,
        description: _descriptionController.text,
        image: _selectedImage != null ? _selectedImage!.path : null,
        roomImages: _selectedRoomImages
            .map((file) => file != null ? file.path : null)
            .toList(),
      );
      await _databaseHelper.insertHotel(hotel);
      _refreshHotelList();
      _resetForm();
    }
  }

  void _deleteHotel(int id) async {
    await _databaseHelper.deleteHotel(id);
    _refreshHotelList();
  }

  void _resetForm() {
    _nameController.clear();
    _addressController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedImage = null;
      _selectedRoomImages.clear();
      _selectedRoomImages = List<File?>.filled(3, null);
    });
  }

  Widget _buildHotelList() {
    return ListView.builder(
      itemCount: _hotels.length,
      itemBuilder: (context, index) {
        Hotel hotel = _hotels[index];
        return ListTile(
          leading: hotel.image != null
              ? Image.file(
            File(hotel.image!),
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          )
              : Container(
            width: 50,
            height: 50,
            color: Colors.grey,
          ),
          title: Text(hotel.name),
          subtitle: Text(hotel.address),
          onTap: () {
            _showHotelDetails(hotel);
          },
        );
      },
    );
  }

  void _showHotelDetails(Hotel hotel) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(hotel.name),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hotel.image != null) ...[
                Image.file(
                  File(hotel.image!),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 10),
              ],
              if (hotel.roomImages != null)
                ...hotel.roomImages!.map(
                      (imagePath) => imagePath != null
                      ? Image.file(
                    File(imagePath),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  )
                      : Container(),
                ),
              SizedBox(height: 10),
              Text('Address: ${hotel.address}'),
              SizedBox(height: 10),
              Text('Description: ${hotel.description}'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                _deleteHotel(hotel.id!);
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotel List'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TourismLobbyPage(userRole: widget.user.role,user: widget.user)),
            );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildHotelList(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the hotel name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(labelText: 'Address'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the hotel address';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    child: Text('Pick Image'),
                    onPressed: _pickImage,
                  ),
                  SizedBox(height: 10),
                  _selectedImage != null
                      ? Image.file(
                    _selectedImage!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  )
                      : Container(),
                  SizedBox(height: 10),
                  ElevatedButton(
                    child: Text('Pick Room Images'),
                    onPressed: _pickRoomImages,
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _selectedRoomImages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _selectedRoomImages[index] != null
                              ? Image.file(
                            _selectedRoomImages[index]!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                              : Container(),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        child: Text('Save'),
                        onPressed: _saveHotel,
                      ),
                      ElevatedButton(
                        child: Text('Reset'),
                        onPressed: _resetForm,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
