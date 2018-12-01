import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPointFormField extends StatefulWidget {
  /// The name of the field, used to calculate which type of input to return
  final String fieldName;

  /// The label to display in the UI for the specified fieldName
  final String label;

  /// Call back function invoked when the Form parent of the FormField is
  /// saved. The value returned is determined by the type of the field.
  final Function onSaved;

  /// The initial value to display in the FormField.
  final Map<String, double> initialValue;
  MapPointFormField(this.fieldName,
      {@required this.label, @required this.onSaved, this.initialValue});

  _MapPointFormFieldState createState() => _MapPointFormFieldState();
}

class _MapPointFormFieldState extends State<MapPointFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        decoration: InputDecoration(
          labelText: widget.label,
          suffixIcon: IconButton(
            icon: Icon(Icons.map),
            onPressed: () {
              showDialog<Map<String, double>>(
                  context: context,
                  builder: (BuildContext context) {
                    return MapPointDialog();
                  }).then((Map<String, double> location) {
                print(location);
              });
            },
          ),
        ),
        initialValue:
            "${widget.initialValue["longitude"]}:${widget.initialValue["latitude"]}",
        onSaved: (String value) {
          widget.onSaved(value);
        });
  }
}

class MapPointDialog extends StatefulWidget {
  final Map<String, double> initialValue;
  MapPointDialog({this.initialValue});

  _MapPointDialogState createState() => _MapPointDialogState();
}

class _MapPointDialogState extends State<MapPointDialog> {
  Map<String, double> _startingMapPoint;
  Widget awaitingWidget = Center(child: CircularProgressIndicator());
  GoogleMapController mapController;

  @override
  void initState() {
    if (widget.initialValue != null) {
      _startingMapPoint = widget.initialValue;
    } else {
      _setCurrentLocation();
    }
    super.initState();
  }

  void _setCurrentLocation() async {
    Location().getLocation().then((Map<String, double> location) {
      setState(() {
        _startingMapPoint = location;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: _startingMapPoint == null
          ? awaitingWidget
          : Column(
              children: <Widget>[
                Icon(Icons.map),
                Text(""),
                SizedBox(
                  width: 300.0,
                  height: 300.0,
                  child: Overlay(initialEntries: [
                    OverlayEntry(builder: (BuildContext context) {
                      return GoogleMap(
                        options: new GoogleMapOptions(
                          trackCameraPosition: true,
                          myLocationEnabled: true,
                          cameraPosition: new CameraPosition(
                              target: new LatLng(_startingMapPoint["latitude"],
                                  _startingMapPoint["longitude"]),
                              zoom: 15.0),
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          mapController = controller;
                        },
                      );
                    }),
                    OverlayEntry(builder: (BuildContext context) {
                      return Icon(Icons.flag,
                          color: Theme.of(context).accentColor);
                    })
                  ]),
                ),
                FloatingActionButton(
                  child: Icon(Icons.check),
                  onPressed: () {
                    Map<String, double> mp = {
                      "latitude": mapController.cameraPosition.target.latitude,
                      "longitude":
                          mapController.cameraPosition.target.longitude,
                    };
                    Navigator.pop(
                      context, mp
                    );
                  },
                )
              ],
            ),
    );
  }
}
