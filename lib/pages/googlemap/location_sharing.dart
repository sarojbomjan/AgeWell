import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_care/pages/googlemap/location_history.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart' as loc;

class LocationSharingScreen extends StatefulWidget {
  const LocationSharingScreen({super.key});

  @override
  State<LocationSharingScreen> createState() => _LocationSharingScreenState();
}

class _LocationSharingScreenState extends State<LocationSharingScreen> {
  LatLng? _currentPosition;
  late GoogleMapController _mapController;
  String? _mapStyle;

  final loc.Location _locationController = loc.Location();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadMapStyle();
      await _fetchCurrentLocation();
    });
  }

  Future<void> _loadMapStyle() async {
    try {
      _mapStyle = await rootBundle.loadString('assets/map_style.json');
    } catch (e) {
      print("Error loading map style: $e");
    }
  }

  Future<void> _fetchCurrentLocation() async {
    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;

    // Check if location services are enabled
    serviceEnabled = await _locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
      if (!serviceEnabled) {
        Get.snackbar(
          "Error",
          "Location services are disabled.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
    }

    // Check and request location permissions
    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        Get.snackbar(
          "Error",
          "Location permission denied.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
    }

    // Get real-time location updates
    _locationController.onLocationChanged
        .listen((loc.LocationData locationData) {
      if (locationData.latitude != null &&
          locationData.longitude != null &&
          (_currentPosition == null ||
              _currentPosition!.latitude != locationData.latitude ||
              _currentPosition!.longitude != locationData.longitude)) {
        setState(() {
          _currentPosition =
              LatLng(locationData.latitude!, locationData.longitude!);
        });

        // Update the map camera position
        _mapController.animateCamera(
          CameraUpdate.newLatLng(_currentPosition!),
        );
      }
    });
  }

  Future<void> checkIn() async {
    try {
      final loc.LocationData locationData =
          await _locationController.getLocation();
      final currentPosition =
          LatLng(locationData.latitude!, locationData.longitude!);

      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        throw Exception("User not logged in!");
      }

      List<geocoding.Placemark> placemarks =
          await geocoding.placemarkFromCoordinates(
        currentPosition.latitude,
        currentPosition.longitude,
      );

      String address = placemarks.isNotEmpty
          ? '${placemarks[0].name}, ${placemarks[0].locality}, ${placemarks[0].country}'
          : 'Unknown Address';

      final timestamp = FieldValue.serverTimestamp();
      await FirebaseFirestore.instance.collection('LOCATION').add({
        'userId': userId,
        'location': {
          'latitude': currentPosition.latitude,
          'longitude': currentPosition.longitude,
        },
        'address': address,
        'lastCheckedIn': timestamp,
      });

      Get.snackbar(
        "Check-in Success",
        "Your location has been updated successfully.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to update location. $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).padding.top,
                ),
                Expanded(
                  child: Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: _currentPosition ??
                              const LatLng(27.70169, 85.3206),
                          zoom: 13,
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          _mapController = controller;
                          if (_mapStyle != null) {
                            _mapController.setMapStyle(_mapStyle);
                          }
                        },
                        markers: _currentPosition == null
                            ? {}
                            : {
                                Marker(
                                  markerId: const MarkerId("currentLocation"),
                                  icon: BitmapDescriptor.defaultMarkerWithHue(
                                      BitmapDescriptor.hueRed),
                                  position: _currentPosition!,
                                ),
                              },
                        myLocationEnabled: true,
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: checkIn,
                                icon: const Icon(Icons.location_on_outlined),
                                label: const Text('Check in'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black87,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  final userId =
                                      FirebaseAuth.instance.currentUser?.uid;
                                  if (userId != null) {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) =>
                                            LocationHistoryModal(
                                                userId: userId));
                                  } else {
                                    Get.snackbar(
                                      "Error",
                                      "User is not logged in!",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                      icon: const Icon(Icons.error,
                                          color: Colors.white),
                                    );
                                  }
                                },
                                icon: const Icon(Icons.history),
                                label: const Text('Show History'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black87,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
