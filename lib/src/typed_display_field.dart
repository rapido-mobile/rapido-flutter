import 'package:flutter/material.dart';
import 'dart:io';
import 'package:rapido/rapido.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:validators/validators.dart' as validators;

/// Given a Document and field name, TypedDisplayField will return a widget
/// appropriate for displaying the current value in that document.
/// Currently, the following special fieldnamse are supported:
/// "latlong" - any field name ending in "latlong" will be displayed with
/// a map widget.
/// "image" - any field name ending in "image" will be display with an image,
/// and will assume that the value is a string that is either a path to an
/// image on disk, or is a url to a publicly accessible image on the interent.
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

  static const double defaultBoxSize = 200.0;

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
    if (fieldName.toLowerCase().endsWith("latlong")) {
      return MapDisplayField(
        mapPoint: document[fieldName],
        boxSize: boxSize,
      );
    }
    if (fieldName.toLowerCase().endsWith("?")) {
      return BooleanDisplayField(
        label: label,
        value: document[fieldName],
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
    GoogleMap googleMap;
    GoogleMapOptions mapOptions;
    LatLng pos;
    double sz = _getBoxSize(mapPoint, boxSize: boxSize);

    if (mapPoint != null) {
      pos = LatLng(mapPoint["latitude"], mapPoint["longitude"]);

      mapOptions = GoogleMapOptions(
        cameraPosition: CameraPosition(
          target: LatLng(mapPoint["latitude"], mapPoint["longitude"]),
          zoom: 15.0,
        ),
        compassEnabled: false,
        scrollGesturesEnabled: false,
        rotateGesturesEnabled: false,
        tiltGesturesEnabled: false,
        zoomGesturesEnabled: false,
        myLocationEnabled: false,
      );

      googleMap = GoogleMap(
        options: mapOptions,
        onMapCreated: (GoogleMapController controller) {
          controller.addMarker(MarkerOptions(position: pos));
        },
      );
    }

    if (mapPoint == null) {
      return Icon(Icons.map);
    } else {
      return SizedBox(
        key: Key("${pos.toString()}:${sz.toString()}"),
        height: sz,
        width: sz,
        child: googleMap,
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
    double sz = _getBoxSize(imageString, boxSize: boxSize);
    if (imageString == null) {
      return Container(
        child: SizedBox(
          height: TypedDisplayField.defaultBoxSize,
          width: TypedDisplayField.defaultBoxSize,
          child: Icon(Icons.broken_image),
        ),
      );
    } else if (validators.isURL(imageString)) {
      return Image(
        image: NetworkImage(imageString),
        height: sz,
        width: sz,
      );
    } else {
      return Container(
        child: Image.file(
          File.fromUri(
            Uri(
              path: imageString,
            ),
          ),
          height: sz,
          width: sz,
        ),
      );
    }
  }
}

class BooleanDisplayField extends StatelessWidget {
  final bool value;
  final String label;

  const BooleanDisplayField({Key key, this.value: false, this.label})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<Widget> children = List<Widget>();
    if (label != null && label != "") {
      children.add(Text(label));
    }
    children.add(Checkbox(
      value: value,
      onChanged: ((bool val) {}),
    ));
    return Column(children: children);
  }
}

double _getBoxSize(dynamic value,
    {double boxSize: TypedDisplayField.defaultBoxSize}) {
  double sz = 0.0;
  if (value != "" && value != null) {
    return boxSize == null ? TypedDisplayField.defaultBoxSize : boxSize;
  }
  return sz;
}
