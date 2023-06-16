import 'package:flutter/material.dart';
import 'package:tubes/database_hotel.dart';
import 'package:tubes/hotel.dart';
import 'main.dart';
import 'database_user.dart';
import 'dart:io';

class PesanHotelPage extends StatefulWidget {
  final User user;
  PesanHotelPage({required this.user});
  @override
  _PesanHotelPageState createState() => _PesanHotelPageState();
}

class _PesanHotelPageState extends State<PesanHotelPage> {
  TextEditingController _locationController = TextEditingController();
  TextEditingController _checkInController = TextEditingController();
  TextEditingController _checkOutController = TextEditingController();
  TextEditingController _adultsController = TextEditingController();
  TextEditingController _childrenController = TextEditingController();

  List<Hotel> _searchedHotels = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pesan Hotel'),
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _searchedHotels.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: _searchedHotels[index].image != null
                        ? Image.file(
                      File(_searchedHotels[index].image!),
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                    )
                        : Image.asset(
                      'assets/default_image.jpg',
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                    ),
                    title: Text(_searchedHotels[index].name),
                    subtitle: Text(_searchedHotels[index].address),
                    onTap: () {
                      showHotelDetails(_searchedHotels[index]);
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Lokasi',
              ),
            ),
            TextField(
              controller: _checkInController,
              decoration: InputDecoration(
                labelText: 'Tanggal Check-in',
              ),
            ),
            TextField(
              controller: _checkOutController,
              decoration: InputDecoration(
                labelText: 'Tanggal Check-out',
              ),
            ),
            TextField(
              controller: _adultsController,
              decoration: InputDecoration(
                labelText: 'Jumlah Dewasa',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _childrenController,
              decoration: InputDecoration(
                labelText: 'Jumlah Anak-anak',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                searchHotels();
              },
              child: Text('Cari Hotel'),
            ),
          ],
        ),
      ),
    );
  }

  void searchHotels() async {
    String location = _locationController.text;
    DatabaseHelper2 databaseHelper = DatabaseHelper2.instance;
    List<Hotel> hotels = await databaseHelper.getHotels();

    List<Hotel> searchedHotels = hotels.where((hotel) => hotel.address == location).toList();

    setState(() {
      _searchedHotels = searchedHotels;
    });
  }

  void showHotelDetails(Hotel hotel) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(hotel.name),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Alamat: ${hotel.address}'),
              SizedBox(height: 8.0),
              Text('Deskripsi: ${hotel.description}'),
              SizedBox(height: 8.0),
              Text('Gambar Kamar:'),
              SizedBox(height: 8.0),
              if (hotel.roomImages != null)
                Column(
                  children: hotel.roomImages!
                      .map((roomImage) => roomImage != null
                      ? Image.file(
                    File(roomImage),
                    width: 128,
                    height: 128,
                    fit: BoxFit.cover,
                  )
                      : Image.asset(
                    'assets/default_image.jpg',
                    width: 128,
                    height: 128,
                    fit: BoxFit.cover,
                  ))
                      .toList(),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tutup'),
            ),
          ],
        );
      },
    );
  }
}
