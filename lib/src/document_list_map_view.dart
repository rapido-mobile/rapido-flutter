import 'package:flutter/material.dart';
import 'package:rapido/documents.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

/// Initial experimental support for presenting a DocumentList on a GoogleMap.
/// The DocumentListMapView assumes that documents container certain fields.
/// map-point is a map in the form of {"latitude": double, "longitude: double"}.
/// The DocumentListMapView will automatically create points on the map for each.
/// It further assumes there is a "title" and "subtitle" field that will be used
/// for the info window on the GoogleMap.
/// Clicking on the info window will display a DocumentPage for the selected
/// Document.
class DocumentListMapView extends StatefulWidget {
  // The DocumentList that is the source of data to display on the map
  final DocumentList documentList;

  // The starting zoom level for the map
  final double startingZoom;

  // The starting latitude for the map
  final double startingLatitude;

  // The starting longitude for the map
  final double startingLongitude;

  DocumentListMapView(this.documentList,
      {this.startingZoom, this.startingLatitude, this.startingLongitude});

  _DocumentListMapViewState createState() => _DocumentListMapViewState();
}

class _DocumentListMapViewState extends State<DocumentListMapView> {
  DocumentList data;
  GoogleMapController mapController;
  double _startingZoom;
  double _startingLatitude;
  double _startingLongitude;
  Map<Marker, Document> markerHash = {};

  @override
  initState() {
    // Pick a starting location. Priorty order is:
    // 1. supplied specific coordinates
    // 2. Current location
    widget.startingZoom != null
        ? _startingZoom = widget.startingZoom
        : _startingZoom = 13.0;
    if (widget.startingLatitude == null || widget.startingLongitude == null) {
      _setCurrentLocation();
    }

    data = widget.documentList;

    super.initState();
  }

    void _setCurrentLocation() async {
    Location().getLocation().then((Map<String, double> location) {
      setState(() {
        _startingLatitude = location["latitude"];
        _startingLongitude = location["longitude"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    widget.documentList.onChanged = (DocumentList newData) {
      setState(() {
        data = newData;
      });
    };
    if (_startingLatitude == null || _startingLongitude == null) {
      return Center(child: CircularProgressIndicator(),);
    }
    return GoogleMap(
      options: new GoogleMapOptions(
        cameraPosition: new CameraPosition(
            target: new LatLng(_startingLatitude, _startingLongitude),
            zoom: _startingZoom),
      ),
      onMapCreated: _onMapCreated,
    );
  }

  Widget _getMapDetailsWidget(Document doc) {
    return DocumentPage(labels: widget.documentList.labels, document: doc);
  }

  _onMarkerTapped(Marker marker) {
    Document doc = markerHash[marker];
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return _getMapDetailsWidget(doc);
    }));
  }

  // called each time the map is rebuilt
  // the main job is to add the mapp markers from the DocumentList
  _onMapCreated(GoogleMapController controller) {
    markerHash.clear();

    mapController = controller;
    controller.onMarkerTapped.add(_onMarkerTapped);

    // see if there is any data to display on the map
    data.forEach((Document doc) {
      // don't try add a marker if the location is going to fail
      if (doc["map_point"] != null &&
          doc["map_point"]["latitude"] != null &&
          doc["map_point"]["longitude"] != null) {
        MarkerOptions mo = MarkerOptions(
          position: LatLng(
              doc["map_point"]["latitude"], doc["map_point"]["longitude"]),
          infoWindowText: InfoWindowText(doc["title"], doc["subtitle"]),
          icon: BitmapDescriptor.defaultMarker,
        );

        controller.addMarker(mo).then((Marker m) {
          markerHash[m] = doc;
        });
      }
    });
  }
}
