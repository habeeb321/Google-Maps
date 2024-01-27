import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps/service/api_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_google_places/flutter_google_places.dart' as loc;
import 'package:google_api_headers/google_api_headers.dart' as header;
import 'package:google_maps_webservice/places.dart' as places;

class MapController extends GetxController {
  String kGoogleApiKey = "AIzaSyCxH0SvAS1ZsBc9ExTVu2O81Q6QteFLltQ";
  final RxMap<String, Marker> markers = <String, Marker>{}.obs;
  Location location = Location();
  GoogleMapController? controllerMap;
  double latitude = 0;
  double longitude = 0;

  @override
  void onInit() async {
    getCurrentLocation();
    super.onInit();
  }

  final CameraPosition kGooglePlex = const CameraPosition(
    target: LatLng(33.298037, 44.2879251),
    zoom: 10,
  );

  Future<void> onMapCreated(GoogleMapController controller) async {
    final googleOffices = await ApiService.getGoogleOffices();
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

  getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      //check if thelocation service was enable or not
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      //if the location was denied it will ask next time the user enter the screen
      if (permissionGranted != PermissionStatus.granted) {
        //in case of denied you can add any thing here like error message or something else
        return;
      }
    }

    LocationData currentPosition = await location.getLocation();
    latitude = currentPosition.latitude!;
    longitude = currentPosition.longitude!;
    final marker = Marker(
      markerId: const MarkerId('myLocation'),
      position: LatLng(latitude, longitude),
      infoWindow: const InfoWindow(
        title: 'you can add any message here',
      ),
    );
    markers['myLocation'] = marker;
    controllerMap?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(latitude, longitude), zoom: 15),
      ),
    );
  }

  //searching
  Future<void> handleSearch(context, ScaffoldState scaffoldState) async {
    places.Prediction? p = await loc.PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      onError: (response) => onError(response, context),
      mode: loc.Mode.overlay,
      language: 'en', // you can set any language for search
      strictbounds: false,
      types: [],
      decoration: InputDecoration(
        hintText: 'search',
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
      components: [], // you can determine search for just one country
    );

    displayPrediction(p ?? places.Prediction(), scaffoldState);
  }

  void onError(places.PlacesAutocompleteResponse response, context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Message',
        message: response.errorMessage!,
        contentType: ContentType.failure,
      ),
    ));
  }

  Future<void> displayPrediction(
    places.Prediction p,
    ScaffoldState? currentState,
  ) async {
    places.GoogleMapsPlaces placess = places.GoogleMapsPlaces(
      apiKey: kGoogleApiKey,
      apiHeaders: await const header.GoogleApiHeaders().getHeaders(),
    );
    places.PlacesDetailsResponse detail =
        await placess.getDetailsByPlaceId(p.placeId!);
    // detail will get place details that the user chose from Prediction search
    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;
    markers.clear(); // clear old marker and set new one
    final marker = Marker(
      markerId: const MarkerId('deliveryMarker'),
      position: LatLng(lat, lng),
      infoWindow: const InfoWindow(
        title: '',
      ),
    );
    markers['myLocation'] = marker;
    controllerMap?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 15),
      ),
    );
  }
}
