import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'database_restoran.dart';
import 'dart:io';
import 'main.dart';
import 'database_user.dart';

class RestoranScreen extends StatefulWidget {
  final User user;

  RestoranScreen({required this.user});
  @override
  _RestoranScreenState createState() => _RestoranScreenState();
}

class _RestoranScreenState extends State<RestoranScreen> {
  final DatabaseHelper3 _databaseHelper = DatabaseHelper3.instance;
  final ImagePicker _imagePicker = ImagePicker();

  List<Map<String, dynamic>> _restorans = [];

  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRestorans();
  }

  Future<void> _loadRestorans() async {
    final restorans = await _databaseHelper.getAllRestorans();
    setState(() {
      _restorans = restorans;
    });
  }

  Future<void> _addRestoran() async {
    final image = await _imagePicker.getImage(source: ImageSource.gallery);
    if (image != null) {
      final restoran = {
        'name': _nameController.text,
        'address': _addressController.text,
        'description': _descriptionController.text,
        'image': image.path,
      };
      await _databaseHelper.insertRestoran(restoran);
      _nameController.clear();
      _addressController.clear();
      _descriptionController.clear();
      await _loadRestorans();
    }
  }


  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restoran List'),
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
      body: ListView.builder(
        itemCount: _restorans.length,
        itemBuilder: (context, index) {
          final restoran = _restorans[index];
          return ListTile(
            leading: Image.file(
              File(restoran['image']),
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(restoran['name']),
            subtitle: Text(restoran['address']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MenuScreen(restoranId: restoran['id']),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add Restoran'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                        ),
                      ),
                      TextField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          labelText: 'Address',
                        ),
                      ),
                      TextField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description',
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _addRestoran();
                    },
                    child: Text('Save'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class MenuScreen extends StatefulWidget {
  final int restoranId;

  MenuScreen({required this.restoranId});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final DatabaseHelper3 _databaseHelper = DatabaseHelper3.instance;
  final ImagePicker _imagePicker = ImagePicker();

  List<Map<String, dynamic>> _menus = [];

  TextEditingController _menuNameController = TextEditingController();
  TextEditingController _menuDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMenus();
  }

  Future<void> _loadMenus() async {
    final menus = await _databaseHelper.getMenusForRestoran(widget.restoranId);
    setState(() {
      _menus = menus;
    });
  }

  Future<void> _addMenu() async {
    final image = await _imagePicker.getImage(source: ImageSource.gallery);
    if (image != null) {
      final menu = {
        'restoran_id': widget.restoranId,
        'menu_name': _menuNameController.text,
        'menu_description': _menuDescriptionController.text,
        'menu_image': image.path,
      };
      await _databaseHelper.insertMenu(menu);
      _menuNameController.clear();
      _menuDescriptionController.clear();
      await _loadMenus();
    }
  }

  @override
  void dispose() {
    _menuNameController.dispose();
    _menuDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu List'),
      ),
      body: ListView.builder(
        itemCount: _menus.length,
        itemBuilder: (context, index) {
          final menu = _menus[index];
          return ListTile(
            leading: Image.file(
              File(menu['menu_image']),
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(menu['menu_name']),
            subtitle: Text(menu['menu_description']),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add Menu'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: _menuNameController,
                        decoration: InputDecoration(
                          labelText: 'Menu Name',
                        ),
                      ),
                      TextField(
                        controller: _menuDescriptionController,
                        decoration: InputDecoration(
                          labelText: 'Menu Description',
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _addMenu();
                    },
                    child: Text('Save'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
