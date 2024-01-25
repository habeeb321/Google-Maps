import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:google_maps/view_model/map_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends GetView<MapController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MapController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Office Locations'),
        centerTitle: true,
        elevation: 20,
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(border: Border.all(width: 2)),
        child: GoogleMap(
          onMapCreated: controller.onMapCreated,
          initialCameraPosition: const CameraPosition(
            target: LatLng(10.8505, 76.2711),
            zoom: 8,
          ),
          markers: controller.markers.values.toSet(),
        ),
      ),
    );
  }
}
