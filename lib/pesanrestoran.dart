import 'package:flutter/material.dart';
import 'database_restoran.dart';
import 'dart:io';
import 'main.dart';
import 'database_user.dart';

class PesanRestoranScreen extends StatefulWidget {
  final User user;
  PesanRestoranScreen({required this.user});
  @override
  _PesanRestoranScreenState createState() => _PesanRestoranScreenState();
}

class _PesanRestoranScreenState extends State<PesanRestoranScreen> {
  final DatabaseHelper3 _databaseHelper = DatabaseHelper3.instance;
  List<Map<String, dynamic>> _restorans = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pesan Restoran'),
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
  List<Map<String, dynamic>> _menus = [];

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
    );
  }
}