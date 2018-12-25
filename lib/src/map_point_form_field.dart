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
  Map<String, double> _currentValue;

  @override
  void initState() {
    if (_currentValue == null) {
      _currentValue = widget.initialValue;
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    LatLng location;
    return FormField(
      builder: (FormFieldState<Map<String, double>> state) {
        return MapPointPicker(
          initialValue: widget.initialValue,
          onLocationChanged: (LatLng loc) {
            location = loc;
          },
        );
      },
      onSaved: (Map<String, double> loc) {
        widget.onSaved(
            {"latitude": location.latitude, "longitude": location.longitude});
      },
    );


  }
}

class MapPointPicker extends StatefulWidget {
  final Map<String, double> initialValue;
  final Function onLocationChanged;
  MapPointPicker({this.initialValue, this.onLocationChanged});

  _MapPointPickerState createState() => _MapPointPickerState();
}

class _MapPointPickerState extends State<MapPointPicker> {
  Map<String, double> _startingMapPoint;
  Widget awaitingWidget = Center(child: CircularProgressIndicator());
  GoogleMapController mapController;

  Map<String, double> get location {
    if (mapController == null) {
      return _startingMapPoint;
    }
    Map<String, double> mp = {
      "latitude": mapController.cameraPosition.target.latitude,
      "longitude": mapController.cameraPosition.target.longitude,
    };
    return mp;
  }

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
  Widget build(BuildContext contexy) {
    return SizedBox(
      width: 300.0,
      height: 300.0,
      child: Overlay(initialEntries: [
        OverlayEntry(builder: (BuildContext context) {
          return GoogleMap(
            options: new GoogleMapOptions(
              trackCameraPosition: true,
              scrollGesturesEnabled: true,
              myLocationEnabled: true,
              cameraPosition: new CameraPosition(
                  target: new LatLng(_startingMapPoint["latitude"],
                      _startingMapPoint["longitude"]),
                  zoom: 15.0),
            ),
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
              mapController.addListener(() {
                if (widget.onLocationChanged != null) {
                  widget.onLocationChanged(mapController.cameraPosition.target);
                }
              });
            },
          );
        }),
        OverlayEntry(builder: (BuildContext context) {
          return Icon(Icons.flag, color: Theme.of(context).accentColor);
        })
      ]),
    );
  }
}

class MapPointDialog extends StatefulWidget {
  final Map<String, double> initialValue;
  MapPointDialog({this.initialValue});

  _MapPointDialogState createState() => _MapPointDialogState();
}

class _MapPointDialogState extends State<MapPointDialog> {
  @override
  Widget build(BuildContext context) {
    LatLng location;

    return Dialog(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Icon(Icons.map),
            Text(""),
            MapPointPicker(
              initialValue: widget.initialValue,
              onLocationChanged: (LatLng loc) {
                print(loc);
                location = loc;
              },
            ),
            FloatingActionButton(
              child: Icon(Icons.check),
              onPressed: () {
                Map<String, double> mp = {
                  "latitude": location.latitude,
                  "longitude": location.longitude,
                };
                Navigator.pop(context, mp);
              },
            )
          ],
        ),
      ),
    );
  }
}
