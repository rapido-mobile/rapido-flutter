import 'package:flutter/material.dart';
import 'package:rapido/documents.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DocumentMapView extends StatefulWidget {
  final DocumentList documentList;
  final Function onItemTap;
  final Function customItemBuilder;
  final double startingZoom;
  final double startingLatitude;
  final double startingLongitude;

  DocumentMapView(this.documentList,
      {this.onItemTap,
      this.customItemBuilder,
      this.startingZoom,
      this.startingLatitude,
      this.startingLongitude});

  _DocumentMapViewState createState() => _DocumentMapViewState();
}

class _DocumentMapViewState extends State<DocumentMapView> {
  DocumentList data;
  GoogleMapController mapController;
  double _startingZoom;
  double _startingLatitude;
  double _startingLongitude;
  @override
  initState() {
    super.initState();
    widget.startingZoom != null
        ? _startingZoom = widget.startingZoom
        : _startingZoom = 13.0;
    widget.startingLatitude != null
        ? _startingLatitude = widget.startingLatitude
        : _startingLatitude = 39.1218096;
    widget.startingLongitude != null
        ? _startingLongitude = widget.startingLongitude
        : _startingLongitude = -77.1724523;

    data = widget.documentList;
  }

  @override
  Widget build(BuildContext context) {
    widget.documentList.onChanged = (DocumentList newData) {
      setState(() {
        data = newData;
      });
    };

    return GoogleMap(
      options: new GoogleMapOptions(
        cameraPosition: new CameraPosition(
            target: new LatLng(_startingLatitude, _startingLongitude),
            zoom: _startingZoom),
      ),
      onMapCreated: (GoogleMapController controller) {
        mapController = controller;
      },
    );
  }
}
