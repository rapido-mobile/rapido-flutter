import 'package:flutter/material.dart';
import 'dart:io';
import 'package:rapido/documents.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:validators/validators.dart' as validators;

class TypedDisplayField extends StatelessWidget {
  /// The name of the field, used to calculate which type of input to return
  final String fieldName;

  /// The label to display in the UI for the specified fieldName
  final String label;

  /// The document's whose data shoud be displayed
  final Document document;

  /// Size, used for fields that are displayed in a SizedBox, such as
  /// images, maps, etc... Will determine the height and width of the
  /// SizedBox
  final double boxSize;

  TypedDisplayField(
      {@required this.fieldName,
      @required this.document,
      this.boxSize,
      this.label});

  @override
  Widget build(BuildContext context) {
    if (fieldName.toLowerCase().endsWith("image")) {
      return ImageDisplayField(
        imageString: document[fieldName],
        boxSize: boxSize,
      );
    }
    if (fieldName.toLowerCase().endsWith("map point")) {
      return MapDisplayField(
        mapPoint: document[fieldName],
        boxSize: boxSize,
      );
    }
    return Flexible(
      child: Container(
        child: Text(
          document[fieldName].toString(),
          softWrap: true,
          style: Theme.of(context).textTheme.subhead,
        ),
      ),
    );
  }
}

class MapDisplayField extends StatelessWidget {
  final Map<String, double> mapPoint;
  final double boxSize;

  MapDisplayField({@required this.mapPoint, this.boxSize});

  @override
  Widget build(BuildContext context) {
    double sz = _getBoxSize(mapPoint, boxSize: boxSize);
    LatLng pos;
    if (mapPoint != null) {
      pos = LatLng(mapPoint["latitude"], mapPoint["longitude"]);
    }
    if (mapPoint == null) {
      return Icon(Icons.map);
    } else {
      return SizedBox(
        height: sz,
        width: sz,
        child: GoogleMap(
          options: GoogleMapOptions(
            cameraPosition: CameraPosition(
              target: pos,
              zoom: 15.0,
            ),
            compassEnabled: false,
            scrollGesturesEnabled: false,
            rotateGesturesEnabled: false,
            tiltGesturesEnabled: false,
            myLocationEnabled: false,
          ),
          onMapCreated: (GoogleMapController controller) {
            controller.addMarker(MarkerOptions(position: pos));
          },
        ),
      );
    }
  }
}

class ImageDisplayField extends StatelessWidget {
  final String imageString;
  final double boxSize;

  ImageDisplayField({@required this.imageString, this.boxSize});

  @override
  Widget build(BuildContext context) {
    Widget _image;
    double sz = _getBoxSize(imageString, boxSize: boxSize);
    if (imageString == null) {
      _image = Icon(Icons.broken_image);
    } else if (validators.isURL(imageString)) {
      _image = Image(
        image: NetworkImage(imageString),
      );
    } else {
      _image = Image.file(
        File.fromUri(
          Uri(
            path: imageString,
          ),
        ),
      );
    }
    return SizedBox(
      height: sz,
      width: sz,
      child: _image,
    );
  }
}

double _getBoxSize(dynamic value, {double boxSize}) {
  double sz = 0.0;
  if (value != "" && value != null) {
    if (boxSize != null)
      sz = boxSize;
    else {
      sz = 200.0;
    }
  }
  return sz;
}
