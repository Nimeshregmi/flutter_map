// sk.eyJ1IjoiYW51cGFtYmlzdGExMjQiLCJhIjoiY2xxd2t0dGR5MDNybzJrcGhyenBjOGVpNSJ9.XQTo8lkXFj7FjsHMho2Tdg

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_directions/flutter_map_directions.dart';
// ignore: unused_import
import 'package:location/location.dart' as loc;
// ignore: depend_on_referenced_packages
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const App(),
    );
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  String _message = 'Finding route...';
  double _topPadding = 0;
  late double latitude = 27.700769;
  late double lognitude = 85.300140;
  final mapController = MapController();

  List<DirectionCoordinate> _coordinates = [];
  final DirectionController _directionController = DirectionController();
  @override
  void initState() {
    getCurrentLocation();
    _loadNewRoute(); // Your synchronous function logic here
    super.initState();
  }

  void _loadNewRoute() async {
    await Future.delayed(const Duration(seconds: 5));
    _coordinates = [
      DirectionCoordinate(27.671262160275386, 85.34685365158633),
      DirectionCoordinate(27.6262160275386, 85.34685365158633),
      DirectionCoordinate(27.66848738115947, 85.33591040557214),
    ];
    final bounds = LatLngBounds.fromPoints(_coordinates.map((location) => LatLng(location.latitude, location.longitude)).toList());
    CenterZoom centerZoom = mapController.centerZoomFitBounds(bounds);
    mapController.move(centerZoom.center, centerZoom.zoom);
    _directionController.updateDirection(_coordinates);
  }

  void getCurrentLocation() async {
    LocationPermission permision = await Geolocator.checkPermission();
    if (permision == LocationPermission.denied || permision == LocationPermission.deniedForever) {
      // print('Permission Denied');
      await Geolocator.requestPermission();
      getCurrentLocation();
    } else {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      latitude = position.latitude;
      lognitude = position.longitude;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    _topPadding = MediaQuery.of(context).padding.top;
    final bounds = LatLngBounds.fromPoints(
        [DirectionCoordinate(27.671262160275386, 85.34685365158633)].map((location) => LatLng(location.latitude, location.longitude)).toList());
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              bounds: bounds,
              boundsOptions: _buildMapFitBoundsOptions(),
            ),
            nonRotatedChildren: [
              TileLayer(
                urlTemplate:
                    'https://api.mapbox.com/styles/v1/anupambista124/clquxxur6010401nw9q5z15he/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYW51cGFtYmlzdGExMjQiLCJhIjoiY2xxdXZmam4wNGc0ejJxbzB5YWZ4cmoydiJ9.q4MyXFYKYGdXmHJD1b0XAA',
              ),
              MarkerLayer(
                  markers: _coordinates.map((location) {
                return Marker(
                    point: LatLng(location.latitude, location.longitude),
                    width: 35,
                    height: 35,
                    builder: (context) => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(
                      child: Text(
                        ' Destination',
                        style:TextStyle(fontWeight: FontWeight.w900, fontSize: 10, color: Colors.white, decoration: TextDecoration.none),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      width: 30,
                      child:Image.asset('assets/images/location_ticker.png'),
                    )
                  ],),
                    anchorPos:AnchorPos.align(AnchorAlign.top));
              }).toList()),
              DirectionsLayer(
                coordinates: _coordinates,
                color: Colors.deepOrange,
                onCompleted: (isRouteAvailable) => _updateMessage(isRouteAvailable),
                controller: _directionController,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(40)),
                  child: Text(_message),
                ),
              ),
            ],
          ),
        ],
      ),
      // options: MapOptions(
      //   // initialCenter: const LatLng(27.700769, 85.300140),
      //   // initialZoom: 13,
      //   center: const LatLng(27.700769, 85.300140),
      //   zoom: 13,
      // ),
      // children: [
      //   TileLayer(
      //     urlTemplate:
      //         'https://api.mapbox.com/styles/v1/anupambista124/clquxxur6010401nw9q5z15he/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYW51cGFtYmlzdGExMjQiLCJhIjoiY2xxdXZmam4wNGc0ejJxbzB5YWZ4cmoydiJ9.q4MyXFYKYGdXmHJD1b0XAA',
      //     userAgentPackageName: 'com.example.app',
      //     additionalOptions: const {
      //       'accessToken': 'pk.eyJ1IjoiYW51cGFtYmlzdGExMjQiLCJhIjoiY2xxdXZmam4wNGc0ejJxbzB5YWZ4cmoydiJ9.q4MyXFYKYGdXmHJD1b0XAA',
      //       'id': 'mapbox.mapbox-streets-v8',
      //     },
      //   ),
      //   MarkerLayer(
      //     markers: [
      //       Marker(
      //         point: LatLng(latitude, lognitude),
      //         width: 70,
      //         height: 60,
      //         builder: (context) {
      //           return Column(
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               const Expanded(
      //                 child: Text(
      //                   ' Destination',
      //                   style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10, color: Colors.white, decoration: TextDecoration.none),
      //                 ),
      //               ),
      //               SizedBox(
      //                 height: 30,
      //                 width: 30,
      //                 child: Image.asset('assets/images/location_ticker.png'),
      //               )
      //             ],
      //           );
      //         },
      //       ),
      //       Marker(
      //         point: LatLng(latitude + 0.03, lognitude + 0.03),
      //         width: 70,
      //         height: 50,
      //         builder: (context) {
      //           return Column(
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               const Expanded(
      //                 child: Text(
      //                   ' Source',
      //                   style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10, color: Colors.white, decoration: TextDecoration.none),
      //                 ),
      //               ),
      //               SizedBox(
      //                 height: 30,
      //                 width: 30,
      //                 child: Image.asset('assets/images/location_ticker.png'),
      //               )
      //             ],
      //           );
      //         },
      //       ),

      //     ],
      //   ),
      //   PolylineLayer(
      //     polylines: [
      //       Polyline(
      //         points: [LatLng(latitude, lognitude), LatLng(latitude + 0.03, lognitude + 0.03)],
      //         color: Colors.blue,
      //       ),
      //     ],
      //   ),
      // ],
    );
  }

  FitBoundsOptions _buildMapFitBoundsOptions() {
    const padding = 50.0;
    return FitBoundsOptions(
      padding: EdgeInsets.only(
        left: padding,
        top: padding + _topPadding,
        right: padding,
        bottom: padding,
      ),
    );
  }

  void _updateMessage(bool isRouteAvailable) {
    if (_coordinates.length < 2) return;

    setState(() {
      _message = isRouteAvailable ? 'Found route' : 'No route found';
    });
  }
}
