import 'package:common_constants/common_constants.dart';
import 'package:flutter/cupertino.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Builder(
          builder: (context) => Column(
            children: [
              CupertinoSearchTextField(
                onTap: () {
                  controller.handleSearch(context, Scaffold.of(context));
                },
              ),
              Constants.height10,
              Expanded(
                child: Container(
                  decoration: BoxDecoration(border: Border.all(width: 2)),
                  child: GoogleMap(
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    initialCameraPosition: controller.kGooglePlex,
                    markers: controller.markers.values.toSet(),
                    onTap: (LatLng latlng) {
                      controller.latitude = latlng.latitude;
                      controller.longitude = latlng.longitude;
                      final marker = Marker(
                        markerId: const MarkerId('myLocation'),
                        position:
                            LatLng(controller.latitude, controller.longitude),
                        infoWindow: const InfoWindow(
                          title:
                              'AppLocalizations.of(context).will_deliver_here',
                        ),
                      );
                      controller.markers['myLocation'] = marker;
                    },
                    onMapCreated: (GoogleMapController controller) {
                      this.controller.controllerMap = controller;
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_google_places/flutter_google_places.dart' as loc;
// import 'package:google_api_headers/google_api_headers.dart' as header;
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_webservice/places.dart' as places;
// import 'package:location/location.dart';
// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _LocationAccessState();
// }

// class _LocationAccessState extends State<HomeScreen> {
//   String kGoogleApiKey = "AIzaSyCxH0SvAS1ZsBc9ExTVu2O81Q6QteFLltQ";

//   Location location = Location();
//   final Map<String, Marker> _markers = {};

//   double latitude = 0;
//   double longitude = 0;
//   GoogleMapController? _controller;
//   final CameraPosition _kGooglePlex = const CameraPosition(
//     target: LatLng(33.298037, 44.2879251),
//     zoom: 10,
//   );

//   Future<void> _handleSearch(context) async {
//     places.Prediction? p = await loc.PlacesAutocomplete.show(
//         context: context,
//         apiKey: kGoogleApiKey, // Replace with your API key
//         onError: onError, // call the onError function below
//         mode: loc.Mode.overlay,
//         language: 'en', // you can set any language for search
//         strictbounds: false,
//         types: [],
//         decoration: InputDecoration(
//             hintText: 'Search',
//             focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(20),
//                 borderSide: const BorderSide(color: Colors.white))),
//         components: [] // you can determine search for just one country
//         );

//     displayPrediction(p!, context);
//   }

//   void onError(places.PlacesAutocompleteResponse response) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       elevation: 0,
//       behavior: SnackBarBehavior.floating,
//       backgroundColor: Colors.transparent,
//       content: AwesomeSnackbarContent(
//         title: 'Message',
//         message: response.errorMessage!,
//         contentType: ContentType.failure,
//       ),
//     ));
//   }

//   Future<void> displayPrediction(
//       places.Prediction p, ScaffoldState? currentState) async {
//     places.GoogleMapsPlaces placess = places.GoogleMapsPlaces(
//         apiKey: kGoogleApiKey,
//         apiHeaders: await const header.GoogleApiHeaders().getHeaders());
//     places.PlacesDetailsResponse detail =
//         await placess.getDetailsByPlaceId(p.placeId!);
// // detail will get place details that user chose from Prediction search
//     final lat = detail.result.geometry!.location.lat;
//     final lng = detail.result.geometry!.location.lng;
//     _markers.clear(); //clear old marker and set new one
//     final marker = Marker(
//       markerId: const MarkerId('deliveryMarker'),
//       position: LatLng(lat, lng),
//       infoWindow: const InfoWindow(
//         title: '',
//       ),
//     );
//     setState(() {
//       _markers['myLocation'] = marker;
//       _controller?.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(target: LatLng(lat, lng), zoom: 15),
//         ),
//       );
//     });
//   }

//   getCurrentLocation() async {
//     bool serviceEnabled;
//     PermissionStatus permissionGranted;

//     serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await location.requestService();
//       if (!serviceEnabled) {
//         return;
//       }
//     }

//     permissionGranted = await location.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await location.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) {
//         return;
//       }
//     }

//     LocationData currentPosition = await location.getLocation();
//     latitude = currentPosition.latitude!;
//     longitude = currentPosition.longitude!;
//     final marker = Marker(
//       markerId: const MarkerId('myLocation'),
//       position: LatLng(latitude, longitude),
//       infoWindow: const InfoWindow(
//         title: 'You can add any message here',
//       ),
//     );
//     setState(() {
//       _markers['myLocation'] = marker;
//       _controller?.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(target: LatLng(latitude, longitude), zoom: 15),
//         ),
//       );
//     });
//   }

//   @override
//   void initState() {
//     getCurrentLocation();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 10),
//             width: double.infinity,
//             height: double.infinity,
//             child: GoogleMap(
//               mapType: MapType.normal,
//               myLocationEnabled: true,
//               initialCameraPosition: _kGooglePlex,
//               markers: _markers.values.toSet(),
//               onTap: (LatLng latlng) {
//                 latitude = latlng.latitude;
//                 longitude = latlng.longitude;
//                 final marker = Marker(
//                   markerId: const MarkerId('myLocation'),
//                   position: LatLng(latitude, longitude),
//                   infoWindow: const InfoWindow(
//                     title: 'AppLocalizations.of(context).will_deliver_here',
//                   ),
//                 );
//                 setState(() {
//                   _markers['myLocation'] = marker;
//                 });
//               },
//               onMapCreated: (GoogleMapController controller) {
//                 _controller = controller;
//               },
//             ),
//           ),
//           Positioned(
//             left: 10, // you can change place of search bar any where on the map
//             child: ElevatedButton(
//                 onPressed: () {
//                   _handleSearch(context);
//                 },
//                 child: const Text('Search')),
//           )
//         ],
//       ),
//     );
//   }
// }
