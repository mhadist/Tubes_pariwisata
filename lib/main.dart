import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login.dart';
import 'hotel.dart';
import 'restoran.dart';
import 'galeri.dart';
import 'database_user.dart';
import 'pesanhotel.dart';
import 'pesanrestoran.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(TourismApp());
}

class TourismApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Pariwisata',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }
}

class TourismLobbyPage extends StatefulWidget {
  final User user;
  final UserRole userRole;

  TourismLobbyPage({required this.userRole, required this.user});

  @override
  _TourismLobbyPageState createState() => _TourismLobbyPageState();
}

class _TourismLobbyPageState extends State<TourismLobbyPage>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;
  final List<String> images = [
    'https://bantenraya.co.id/wp-content/uploads/2023/04/pan-5-1200x675.jpg',
    'https://t-2.tstatic.net/travel/foto/bank/images/penampakan-wajah-baru-taman-mini-indonesia-indah-tmii-setelah-direvitalisasi.jpg',
    'https://storage.nu.or.id/storage/post/16_9/big/candi-borobudur2-medium_1654732502.webp',
  ];
  int currentIndex = 0;
  late String username;
  late UserRole role;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController!);

    username = widget.user.username;
    role = widget.user.role;
    startImageSlider();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  void startImageSlider() {
    Future.delayed(Duration(seconds: 10)).then((_) {
      if (currentIndex < images.length - 1) {
        setState(() {
          currentIndex++;
        });
      } else {
        setState(() {
          currentIndex = 0;
        });
      }
      _animationController!.forward(from: 0.0);
      startImageSlider();
    });
  }


  @override
  Widget build(BuildContext context) {
    double imageHeight = 250.0;
    double imageWidth = 400.0;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50.0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open the drawer
              },
            );
          },
        ),
        title: Container(
          width: 275.0, // Ubah lebar kontainer sesuai kebutuhan Anda
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                onPressed: () {
                  // Handle search action
                },
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Image.network(
              'https://lh3.googleusercontent.com/IMSn7H1NYNkIgYxkjQcmyCIB8-lvAyAjcyI4f-ZaZ34JzxzhvIt-WFvK8pDcu3LwGPsgEfTSARCcdkAhZWNOpFubwNkdy8FyYY4srKvK',
              width: 60,
            ),
            onPressed: () {
              // Handle logo action
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.indigo],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Welcome, $username!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    '${widget.userRole.toString().split('.').last}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                ); // Handle logout action
                //Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),

      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://i.pinimg.com/236x/31/d8/54/31d854bdce59730a6a360269c3fed94b.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    //child: Image.network(
                    //'https://lh3.googleusercontent.com/mxQzaGiHnuvvzAuWW_xk4veeP8l_eTgIpNE1SDaQFfrlPpV_RW44lKU__k1K9vza7myMsvQBw9fCdbHCaqJwspiAYD9DcpuF7D9emaULgw',
                    //width: 60,
                    //),
                  ),
                  Container(
                    height: imageHeight,
                    width: imageWidth,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: AnimatedBuilder(
                            animation: _fadeAnimation!,
                            builder: (BuildContext context, Widget? child) {
                              return Opacity(
                                opacity: _fadeAnimation!.value,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(
                                    images[currentIndex],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: AnimatedBuilder(
                            animation: _fadeAnimation!,
                            builder: (BuildContext context, Widget? child) {
                              return Opacity(
                                opacity: 1 - _fadeAnimation!.value,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(
                                    images[(currentIndex + 1) % images.length],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.only(bottom: 60.0), // Tambahkan padding di bagian bawah ListView
                      children: [
                        Container(
                          padding: EdgeInsets.all(16.0),
                          color: Colors.transparent, // Tambahkan transparansi pada kontainer agar latar belakang dapat terlihat
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Wisata Populer',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              _buildPopularDestinationCard(
                                'https://bantenraya.co.id/wp-content/uploads/2023/04/pan-5-1200x675.jpg',
                                'Pantai Kuta',
                                'Bali',
                                LatLng(-8.715151, 115.168679),
                              ),
                              SizedBox(height: 8.0),
                              _buildPopularDestinationCard(
                                'https://t-2.tstatic.net/travel/foto/bank/images/penampakan-wajah-baru-taman-mini-indonesia-indah-tmii-setelah-direvitalisasi.jpg',
                                'Taman Mini Indonesia Indah',
                                'Jakarta',
                                LatLng(-6.3038861625513425, 106.89163771534012),
                              ),
                              SizedBox(height: 8.0),
                              _buildPopularDestinationCard(
                                'https://storage.nu.or.id/storage/post/16_9/big/candi-borobudur2-medium_1654732502.webp',
                                'Borobudur',
                                'Yogyakarta',
                                LatLng(-7.6076823732457814, 110.20379421087299),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: 200.0,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.indigo],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (widget.user.role == UserRole.admin || widget.user.role == UserRole.hotelOwner) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HotelPage(user: widget.user),
                          ),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PesanHotelPage(user: widget.user),
                          ),
                        );
                      }
                    },
                    child: Column(
                      children: [
                        Icon(Icons.hotel, color: Colors.white),
                        SizedBox(height: 2.0),
                        Text(
                          'Hotel',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (widget.user.role == UserRole.admin || widget.user.role == UserRole.restaurantOwner) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RestoranScreen(user: widget.user),
                          ),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PesanRestoranScreen(user: widget.user),
                          ),
                        );
                      }
                    },
                    child: Column(
                      children: [
                        Icon(Icons.restaurant, color: Colors.white),
                        SizedBox(height: 2.0),
                        Text(
                          'Restoran',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GaleriScreen(user: widget.user),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Icon(Icons.photo_camera, color: Colors.white),
                        SizedBox(height: 2.0),
                        Text(
                          'Galeri',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildPopularDestinationCard(String imageUrl, String destinationName, String location, LatLng coordinates) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(destinationName),
              content: Container(
                height: 200, // Adjust the height as per your requirement
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: coordinates,
                    zoom: 14.0,
                  ),
                  markers: {Marker(markerId: MarkerId('destination'), position: LatLng(coordinates.latitude, coordinates.longitude))},
                ),
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
      },      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0.0, 2.0),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                imageUrl,
                height: 120.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          destinationName,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey[300],
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          location,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}
