import 'dart:async';
import 'dart:convert';
import 'package:app/authentication/login.dart';
import 'package:app/global/global_var.dart';
import 'package:app/methods/common_methods.dart' as common_methods;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> _mapControllerCompleter = Completer();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final common_methods.CommonMethods _commonMethods = common_methods.CommonMethods();

  GoogleMapController? _googleMapController;
  Position? _currentPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildAppDrawer(),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: googlePlexInitialPosition,
            onMapCreated: (controller) {
              _googleMapController = controller;
              _applyMapTheme(controller);
              if (!_mapControllerCompleter.isCompleted) {
                _mapControllerCompleter.complete(controller);
              }
              _getCurrentLocationAndValidateUser();
            },
          ),
          Positioned(
            top: 36,
            left: 10,
            child: GestureDetector(
              onTap: () => _scaffoldKey.currentState?.openDrawer(),
              child: _buildMenuButton(),
            ),
          ),
        ],
      ),
    );
  }

  Drawer _buildAppDrawer() {
    return Drawer(
      backgroundColor: Colors.white10,
      child: ListView(
        children: [
          _buildDrawerHeader(),
          const Divider(height: 1, color: Colors.white, thickness: 1),
          const SizedBox(height: 10),
          _buildDrawerItem(icon: Icons.info, label: "About", onTap: () {}),
          _buildDrawerItem(icon: Icons.logout, label: "Logout", onTap: () {
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LogIn()),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      color: Colors.black87,
      height: 160,
      child: DrawerHeader(
        decoration: const BoxDecoration(color: Colors.black87),
        child: Row(
          children: [
            Image.asset(
              "assets/images/avatarman.png",
              height: 60,
              width: 60,
            ),
            const SizedBox(width: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Profile",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  ListTile _buildDrawerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      onTap: onTap,
    );
  }

  Widget _buildMenuButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            spreadRadius: 0.5,
            offset: Offset(0.7, 0.7),
          ),
        ],
      ),
      child: const CircleAvatar(
        backgroundColor: Colors.grey,
        radius: 20,
        child: Icon(Icons.menu, color: Colors.black87),
      ),
    );
  }

  Future<void> _getCurrentLocationAndValidateUser() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );
      _currentPosition = position;

      final userLatLng = LatLng(position.latitude, position.longitude);
      final cameraPosition = CameraPosition(target: userLatLng, zoom: 15);

      _googleMapController?.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition),
      );

      await _validateUserStatus();
    } catch (e) {
      _commonMethods.displaySnackbar("Failed to get location: $e", context);
    }
  }

  Future<void> _validateUserStatus() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      _redirectToLogin("No user ID found.");
      return;
    }

    final userRef = FirebaseDatabase.instance.ref().child("users").child(userId);

    try {
      final snapshot = await userRef.once();

      if (!snapshot.snapshot.exists) {
        _redirectToLogin("User does not exist");
        return;
      }

      final data = snapshot.snapshot.value as Map?;
      if (data == null || data['blockStatus'] != "no") {
        _redirectToLogin("User is blocked");
        return;
      }

      userName = data['name'] ?? '';
    } catch (e) {
      _redirectToLogin("Error retrieving user: $e");
    }
  }

  void _redirectToLogin(String message) {
    FirebaseAuth.instance.signOut();
    Navigator.pop(context);
    _commonMethods.displaySnackbar(message, context);
  }

  void _applyMapTheme(GoogleMapController controller) {
    _loadMapStyle("themes/dark_style.json").then(
      (style) => controller.setMapStyle(style),
    );
  }

  Future<String> _loadMapStyle(String path) async {
    final byteData = await rootBundle.load(path);
    return utf8.decode(byteData.buffer.asUint8List());
  }
}
