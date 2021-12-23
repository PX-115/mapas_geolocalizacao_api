import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Completer<GoogleMapController> _controllerCompleter = Completer();
  Set<Marker> _marcadores = {};

  _onMapCreated(GoogleMapController googleMapController) {
    _controllerCompleter.complete(googleMapController);
  }

  _movimentarCamera() async {
    GoogleMapController googleMapController = await _controllerCompleter.future;
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(-21.5572576, -45.7295776), zoom: 20, tilt: 45, bearing: 85,)));
  }

  _carregarMarcadores(){
    Set<Marker> _marcadorLocal = {};

    Marker marcadorSJ = Marker(
      markerId: MarkerId("marcador-saojoao"),
      position: LatLng(-21.557267578362513, -45.72978815339992),
      infoWindow: InfoWindow(title: "São João Supermercados")
    );

    Marker marcadorPdQ = Marker(
      markerId: MarkerId("marcador-casapaoqueijo"),
      position: LatLng(-21.548644742295426, -45.735878485787886),
      infoWindow: InfoWindow(title: "Casa do Pão de Queijo")
    );

    _marcadorLocal.add(marcadorSJ);
    _marcadorLocal.add(marcadorPdQ);

    setState(() {
      _marcadores = _marcadorLocal;
    });
  }

  _recuperarLocalAtual() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    print("Localização atual: " + position.toString());
  }

  @override
  void initState() {
    super.initState();
    // _carregarMarcadores();
    _recuperarLocalAtual();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mapas e Geolocalização"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
          onPressed: _movimentarCamera, child: Icon(Icons.done)),
      body: Container(
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition:
              CameraPosition(target: LatLng(-21.548360, -45.747945), zoom: 16),
          onMapCreated: _onMapCreated,
          markers: _marcadores,
        ),
      ),
    );
  }
}
