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
  CameraPosition _posicaoCamera =
      CameraPosition(target: LatLng(-21.548360, -45.747945), zoom: 17);
  Set<Marker> _marcadores = {};

  _onMapCreated(GoogleMapController googleMapController) {
    _controllerCompleter.complete(googleMapController);
  }

  _movimentarCamera() async {
    GoogleMapController googleMapController = await _controllerCompleter.future;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(_posicaoCamera));
  }

  _carregarMarcadores() {
    Set<Marker> _marcadorLocal = {};

    /* Marker marcadorPosicaoAtual = Marker(
      markerId: MarkerId("marcador-posicao-atual"),
      position: LatLng(-21.5484403, -45.7479973)
    ); */

    Marker marcadorSJ = Marker(
        markerId: MarkerId("marcador-saojoao"),
        position: LatLng(-21.557267578362513, -45.72978815339992),
        infoWindow: InfoWindow(title: "São João Supermercados"));

    Marker marcadorPdQ = Marker(
        markerId: MarkerId("marcador-casapaoqueijo"),
        position: LatLng(-21.548644742295426, -45.735878485787886),
        infoWindow: InfoWindow(title: "Casa do Pão de Queijo"));

    // _marcadorLocal.add(marcadorPosicaoAtual);
    _marcadorLocal.add(marcadorSJ);
    _marcadorLocal.add(marcadorPdQ);

    setState(() {
      _marcadores = _marcadorLocal;
    });
  }

  _recuperarLocalAtual() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // print("Localização atual: " + position.toString());

    setState(() {
      _posicaoCamera = CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 17);
    });
    _movimentarCamera();
  }

  _listenerLocalizacao() {
    var geolocator = Geolocator();
    var locationSettings =
        LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 2);
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      setState(() {
        _posicaoCamera = CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 17);
      });
      _movimentarCamera();
    });
  }

  @override
  void initState() {
    super.initState();
    // _carregarMarcadores();
    // _recuperarLocalAtual();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mapas e Geolocalização"),
      ),
      /* floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
          onPressed: _movimentarCamera, child: Icon(Icons.done)), */
      body: Container(
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _posicaoCamera,
          onMapCreated: _onMapCreated,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          // markers: _marcadores,
        ),
      ),
    );
  }
}
