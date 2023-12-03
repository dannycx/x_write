import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:location/location.dart';
import 'package:x_write/model/net/api/weather_api.dart';
import 'package:x_write/tool/location_info.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  WeatherApi api = WeatherApi();
  // LocationInfo _locationInfo = LocationInfo();
  String data = '';
  bool _loading = false;
  // LocationData? curLocationData;
  String address = '';

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: Wrap(
          spacing: 10,
          direction: Axis.vertical,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            CupertinoActivityIndicator(),
            Text(
              'loading...',
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
      );
    }
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // if (curLocationData != null) Text('Location: ${curLocationData!.latitude}:${curLocationData!.longitude}'),
            // if (curLocationData != null) Text('address: $address'),
            MaterialButton(onPressed: () {
              // _locationInfo.obtainLocation().then((value) {
              //   LocationData? location = value;
              //   _locationInfo.obtainAddress(location?.latitude, location?.longitude).then((value) {
              //     setState(() {
              //       curLocationData = location;
              //       address = value;
              //     });
              //   });
              // });
            },color: Colors.purple,
            child: const Text("Get Location", style: TextStyle(color: Colors.white),),)
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    _loading = true;
    setState(() {});
    data = await api.obtainWeather('air_daily', '39:118').toString();
    _loading = false;
    setState(() {});
  }
}
