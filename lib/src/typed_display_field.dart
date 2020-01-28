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
/// "?" - any field name ending with a question mark will display with a
/// checkbox. By default the checkbox will be read only, but setting the
/// document property and fieldName property will make it interactive and
/// will automatically persist the state. This is useful for using checkboxes
/// in lists.
class TypedDisplayField extends StatelessWidget {
  /// The name of the field, used to calculate which type of input to return
  final String fieldName;

  /// The label to display in the UI for the specified fieldName
  final String label;

  /// The document's whose data should be displayed
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
        latlong: document[fieldName],
        boxSize: boxSize,
      );
    }
    if (fieldName.toLowerCase().endsWith("?")) {
      return BooleanDisplayField(
        value: document[fieldName],
        document: document,
        fieldName: fieldName,
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

/// Provides a widget that displays a map given a Map<String, double>
/// in the form of {"latitidude": latitude, "longitude": longitude}
class MapDisplayField extends StatelessWidget {
  /// The latitude and longitude to display
  final Map<String, double> latlong;

  /// The height and widgth of the box in which the map will display
  final double boxSize;

  MapDisplayField({@required this.latlong, this.boxSize});

  @override
  Widget build(BuildContext context) {
    GoogleMap googleMap;
    LatLng pos;
    double sz = _getBoxSize(latlong, boxSize: boxSize);

    if (latlong != null) {
      pos = LatLng(latlong["latitude"], latlong["longitude"]);

      googleMap = GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(latlong["latitude"], latlong["longitude"]),
          zoom: 15.0,
        ),
        compassEnabled: false,
        scrollGesturesEnabled: false,
        rotateGesturesEnabled: false,
        tiltGesturesEnabled: false,
        zoomGesturesEnabled: false,
        myLocationEnabled: false,
        markers: Set<Marker>.of([Marker(markerId: MarkerId("center"), position: pos)]),
        // onMapCreated: (GoogleMapController controller) {
        //   controller.addMarker(MarkerOptions(position: pos));
        // },
      );
    }

    if (latlong == null) {
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

/// Provides a widget for displaying an image. It will display
/// any image given either a filepath or a url.
class ImageDisplayField extends StatelessWidget {
  /// File path or URL to an image to display
  final String imageString;

  /// The height and width of the box in which the map will display
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

/// Provides a checkbox to display the current value of a
/// boolean. The display field can be made to be active by including
/// a document and fieldname to modify when the user interacts with the
/// checkbox, or inactive by only supplying the value
class BooleanDisplayField extends StatefulWidget {
  /// The value to display
  final bool value;

  /// Optional document to update for the supplied fieldName
  final Document document;

  /// Optional field to update for the supplied Document
  final String fieldName;

  const BooleanDisplayField({
    Key key,
    this.document,
    this.value: false,
    this.fieldName,
  }) : super(key: key);

  @override
  _BooleanDisplayFieldState createState() {
    return new _BooleanDisplayFieldState();
  }
}

class _BooleanDisplayFieldState extends State<BooleanDisplayField> {
  bool currentValue;
  @override
  Widget build(BuildContext context) {
    if (widget.document != null && widget.fieldName != null) {
      currentValue = widget.document[widget.fieldName];
    } else {
      currentValue = widget.value;
    }
    return Checkbox(
      value: currentValue,
      // if the fieldName and Document are supplied, the widget
      // will actually be interactive
      onChanged: widget.document != null && widget.fieldName != null
          ? onChanged
          : null,
    );
  }

  onChanged(bool val) {
    setState(() {
      currentValue = val;
    });
    widget.document[widget.fieldName] = val;
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
