
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//AIzaSyCLrciNQx1xIXDeOUQCOWEbhzgq_NeIe0w
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RegistroTerminal extends StatefulWidget {
  @override
  _RegistroTerminalState createState() => _RegistroTerminalState();
}

class _RegistroTerminalState extends State<RegistroTerminal> {
  TextEditingController textController = new TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(-16.4825542, -68.1213619),
    zoom: 14.4746,
  );
  
  Future<void> _goToTheLake(_kLake,position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
    _markers.add(
            Marker(
               markerId: MarkerId('Terminal'),
               position: LatLng(position.latitude, position.longitude),
            ));
    setState(() {
      
    });
    
  }

  GoogleMapController mapController;
  Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            // color: Colors.red,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 25,),
                  Text("REGISTRO DE TERMINAL",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                  _labelNombreTerminal(),
                  _botonObtenerGeo (),
                  _botonEnviar(),
                  Container(
                    width: double.infinity,
                    height: 200,
                    child: GoogleMap(
                      mapType: MapType.normal,
                      markers: _markers,
                      initialCameraPosition: kGooglePlex,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                        mapController = controller;
                        
                      },
                      
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _botonEnviar(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30),
      child: CupertinoButton(
        onPressed: () async {
          print("===== ");
          // print(textController.text);
          // Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
          // print(position);
          
        },
        child: Text("Enviar"),
        color: Colors.orange,
      ),
    );
  }

  _labelNombreTerminal (){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
      width: double.infinity,
      child: Row(
        children: [
          Text("Nombre:"),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 20),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder()
                ),
                controller: textController,
              ),
            ),
          )
        ],
      ),
    );
  }
  _botonObtenerGeo (){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
      width: double.infinity,
      child: CupertinoButton(
        onPressed: () async {
          print("===== ");
          // print(textController.text);
          Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
          print(position);

          CameraPosition kLake = CameraPosition(
          // bearing: 192.8334901395799,
          target: LatLng(position.latitude, position.longitude),
          // tilt: 59.440717697143555,
          zoom: 16);
          _goToTheLake(kLake,position);
           
        },
        child: Text("obtener ubicacion"),
        color: Colors.green,
      ),
    );
  }
}


// class MapSample extends StatefulWidget {
//   @override
//   State<MapSample> createState() => MapSampleState();
// }

// class MapSampleState extends State<MapSample> {
//   Completer<GoogleMapController> _controller = Completer();

//   static final CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(37.42796133580664, -122.085749655962),
//     zoom: 14.4746,
//   );

//   static final CameraPosition _kLake = CameraPosition(
//       bearing: 192.8334901395799,
//       target: LatLng(37.43296265331129, -122.08832357078792),
//       tilt: 59.440717697143555,
//       zoom: 19.151926040649414);

//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       body: GoogleMap(
//         mapType: MapType.hybrid,
//         initialCameraPosition: _kGooglePlex,
//         onMapCreated: (GoogleMapController controller) {
//           _controller.complete(controller);
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _goToTheLake,
//         label: Text('To the lake!'),
//         icon: Icon(Icons.directions_boat),
//       ),
//     );
//   }

//   Future<void> _goToTheLake() async {
//     final GoogleMapController controller = await _controller.future;
//     controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
//   }
// }