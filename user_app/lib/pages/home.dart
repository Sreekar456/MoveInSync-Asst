import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:app/global/global_var.dart'; // Make sure this contains `googlePlexInitialPosition`

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> googleMapCompleterController =
      Completer<GoogleMapController>();

  final GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();

  Position? currentPositionOfUser;
  GoogleMapController? googleMapController;

  Future<void> getCurrentLiveLocation() async {
    Position positionOfUser = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );
    currentPositionOfUser = positionOfUser;

    LatLng userLatLng = LatLng(
      currentPositionOfUser!.latitude,
      currentPositionOfUser!.longitude,
    );

    CameraPosition cameraPosition = CameraPosition(
      target: userLatLng,
      zoom: 15,
    );

    googleMapController?.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: sKey,
      drawer: Container(
        width: 255,
        color: Colors.black87,
        child: Drawer(
          backgroundColor: Colors.white10,
          child: ListView(
            children: [
              Container(
                color: Colors.black87,
                height: 160,
                child: DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.black87,
                  ),
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
                        children: [
                          Text(userName,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),),
                          const SizedBox(height: 4),
                          Text("Profile",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),)
                        ],
                      )
                    ],
                  ),
                ),
              )  ,
              // header
              // body
              const Divider(height: 1,color: Colors.white,thickness: 1,),

              const SizedBox(height: 10,),
              ListTile(
                leading: IconButton(onPressed: (){}, icon: const Icon(Icons.info, color: Colors.grey,)),
                title: const Text(
                  "About",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                
              ),
              ListTile(
                leading: IconButton(onPressed: (){}, icon: const Icon(Icons.logout, color: Colors.grey,)),
                title: const Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: googlePlexInitialPosition,
            onMapCreated: (GoogleMapController controller) {
              googleMapController = controller;
              updateMapTheme(controller);
              if (!googleMapCompleterController.isCompleted) {
                googleMapCompleterController.complete(controller);
              }
              getCurrentLiveLocation();
            },
          ),



          Positioned(
            top: 36,
            left: 10,
            child: GestureDetector(
              onTap: (){

              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      spreadRadius: 0.5,
                      offset: Offset(0.7,0.7),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 20,
                  child: Icon(
                    Icons.menu,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Loads and applies the custom map theme
  void updateMapTheme(GoogleMapController controller) {
    getJsonFileFromThemes("themes/dark_style.json").then(
      (style) => setGoogleMapStyle(style, controller),
    );
  }

  /// Loads the map style JSON file from the assets
  Future<String> getJsonFileFromThemes(String mapStylePath) async {
    ByteData byteData = await rootBundle.load(mapStylePath);
    final list = byteData.buffer.asUint8List(
      byteData.offsetInBytes,
      byteData.lengthInBytes,
    );
    return utf8.decode(list);
  }

  /// Applies the map style to the GoogleMapController
  void setGoogleMapStyle(String googleMapStyle, GoogleMapController controller) {
    controller.setMapStyle(googleMapStyle);
  }
}
