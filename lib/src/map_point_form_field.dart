import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';

/// A form field for allowing the user to choose a location on a
/// map. The chosen value is stored as a Map<String, double>.
class MapPointFormField extends StatefulWidget {
  /// The name of the field in the Document
  final String fieldName;

  /// The label to display in the UI for the specified fieldName
  final String label;

  /// Call back function invoked when the Form parent of the FormField is
  /// saved. The value returned is determined by the type of the field.
  final Function onSaved;

  /// The initial location to display in the map. If null, the map
  /// will use the device's location as the initial value.
  /// The value must be a Map<String, double> with at least the
  /// keys "latitude" and "longitude" defined.
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
    return FormField(
      builder: (FormFieldState<Map<String, double>> state) {
        return Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    widget.label,
                    style: Theme.of(context).textTheme.caption,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
            MapPointPicker(
              initialValue: _currentValue,
              onLocationChanged: (Map<String, double> loc) {
                _currentValue = loc;
              },
            ),
          ],
        );
      },
      onSaved: (Map<String, double> loc) {
        if (_currentValue == null && widget.initialValue != null) {
          widget.onSaved(_currentValue);
        } else if (_currentValue != null) {
          widget.onSaved(_currentValue);
        }
      },
    );
  }
}

/// A picker for a point on a map. Used by the MapPointFormField, though
/// it could be generally useful.
class MapPointPicker extends StatefulWidget {
  /// The initial location to display in the map. If null, the map
  /// will use the device's location as the initial value.
  /// The value must be a Map<String, double> with at least the
  /// keys "latitude" and "longitude" defined.
  final Map<String, double> initialValue;

  /// call back function to reveive notification when the map
  /// position changes.
  final Function onLocationChanged;
  MapPointPicker({this.initialValue, this.onLocationChanged});

  _MapPointPickerState createState() => _MapPointPickerState();
}

class _MapPointPickerState extends State<MapPointPicker> {
  Map<String, double> _startingMapPoint;
  Widget awaitingWidget = Center(child: CircularProgressIndicator());
  double _currentLatitude;
  double _currentLongitude;

  Map<String, double> get location {
    if (_currentLatitude == null || _currentLongitude == null) {
      return _startingMapPoint;
    }
    Map<String, double> mp = {
      "latitude": _currentLatitude,
      "longitude": _currentLongitude,
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
    Location().getLocation().then((LocationData locationData) {
      Map<String, double> loc = Map<String, double>();
      loc["latitude"] = locationData.latitude;
      loc["longitude"] = locationData.longitude;

      setState(() {
        _startingMapPoint = loc;
      });
      if (widget.onLocationChanged != null) {
        widget.onLocationChanged(loc);
      }
    });
  }

  @override
  Widget build(BuildContext contexy) {
    return _startingMapPoint == null
        ? CircularProgressIndicator()
        : SizedBox(
            width: 300.0,
            height: 300.0,
            child: Overlay(initialEntries: [
              OverlayEntry(
                builder: (BuildContext context) {
                  return GoogleMap(
                    gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                      new Factory<OneSequenceGestureRecognizer>(
                        () => new EagerGestureRecognizer(),
                      ),
                    ].toSet(),
                    scrollGesturesEnabled: true,
                    myLocationEnabled: true,
                    initialCameraPosition: new CameraPosition(
                        target: new LatLng(_startingMapPoint["latitude"],
                            _startingMapPoint["longitude"]),
                        zoom: 15.0),
                    onCameraMove: (CameraPosition newPosition) {
                      _currentLatitude = newPosition.target.latitude;
                      _currentLongitude = newPosition.target.longitude;
                      Map<String, double> mp = {
                        "latitude": _currentLatitude,
                        "longitude": _currentLongitude,
                      };
                      widget.onLocationChanged(mp);
                    },
                  );
                },
              ),
              OverlayEntry(builder: (BuildContext context) {
                return Icon(Icons.flag, color: Theme.of(context).accentColor);
              })
            ]),
          );
  }
}

/// A dialog that encapsulated a MapPointPicker. Returns the chosen locations
/// as a Map<String, double> with the keys "latitude" and "longitude."
class MapPointDialog extends StatefulWidget {
  /// The initial location to display in the map. If null, the map
  /// will use the device's location as the initial value.
  /// The value must be a Map<String, double> with at least the
  /// keys "latitude" and "longitude" defined.
  final Map<String, double> initialValue;
  MapPointDialog({this.initialValue});

  _MapPointDialogState createState() => _MapPointDialogState();
}

class _MapPointDialogState extends State<MapPointDialog> {
  @override
  Widget build(BuildContext context) {
    Map<String, double> location;

    return Dialog(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Icon(Icons.map),
            Text(""),
            MapPointPicker(
              initialValue: widget.initialValue,
              onLocationChanged: (Map<String, double> loc) {
                location = loc;
              },
            ),
            FloatingActionButton(
              child: Icon(Icons.check),
              onPressed: () {
                Navigator.pop(context, location);
              },
            )
          ],
        ),
      ),
    );
  }
}
