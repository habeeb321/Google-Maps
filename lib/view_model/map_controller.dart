import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '/model/locations.dart' as locations;

class MapController extends GetxController {
  final RxMap<String, Marker> markers = <String, Marker>{}.obs;

  Future<void> onMapCreated(GoogleMapController controller) async {
    final googleOffices = await locations.getGoogleOffices();
    markers.clear();
    for (final office in googleOffices.offices) {
      final marker = Marker(
        markerId: MarkerId(office.name),
        position: LatLng(office.lat, office.lng),
        infoWindow: InfoWindow(
          title: office.name,
          snippet: office.address,
        ),
      );
      markers[office.name] = marker;
    }
  }
}
