// import 'package:geocode/geocode.dart';
// // import 'package:geolocator/geolocator.dart';
// import 'package:location/location.dart';
//
// class LocationInfo {
//   /// location
//   Location location = Location();
//   bool _serviceEnable = false;
//   late PermissionStatus _permissionGranted;
//   LocationData? _locationData;
//
//   Future<LocationData?> obtainLocation() async {
//     // location.enableBackgroundMode(enable: true);
//     _serviceEnable = await location.serviceEnabled();
//     if (!_serviceEnable) {
//       _serviceEnable = await location.requestService();
//       if (!_serviceEnable) return null;
//     }
//
//     _permissionGranted = await location.hasPermission();
//     if (_permissionGranted == PermissionStatus.denied) {
//       _permissionGranted = await location.requestPermission();
//       if (_permissionGranted != PermissionStatus.granted) return null;
//     }
//
//     _locationData = await location.getLocation();
//     return _locationData;
//   }
//
//   listen() {
//     location.onLocationChanged.listen((curLocation) {
//       print('onLocationChanged curLocation: ${curLocation.toString()}');
//     });
//   }
//
//   Future<String> obtainAddress(double? lat, double? lang) async {
//     if (lat == null || lang == null) {
//       return '';
//     }
//
//     GeoCode geoCode = GeoCode();
//     Address address = await geoCode.reverseGeocoding(latitude: lat, longitude: lang);
//     return '${address.streetAddress} ${address.city} ${address.countryName} ${address.postal}';
//   }
//
//   /// Geolocator
//   // Future<Position> geoLocation() async {
//   //   Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//   //   return position;
//   // }
// }
