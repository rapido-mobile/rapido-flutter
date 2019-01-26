import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:validators/validators.dart' as validators;
import 'typed_display_field.dart';
import 'typed_input_field.dart';

/// A form field for allowing the user to choose an image. The chosen
/// value is stored as a string that is either a path to an image on the
/// local device, or a URL. Supports selecting images from the camera, the
/// device's gallery, or a URL. Images from the gallery or camera are
/// copied into the application's directory, and a path to the copied image
/// is stored. Images from the internet are not copied locally.
class ImageFormField extends StatefulWidget {
  /// The name of the field, used to calculate which type of input to return
  final String fieldName;

  /// The label to display in the UI for the specified fieldName
  final String label;

  /// Call back function invoked when the Form parent of the FormField is
  /// saved. The value returned is determined by the type of the field.
  final Function onSaved;

  /// The initial value to display in the FormField. Should be a string that is
  /// either a path to an image on the device, or a URL to an image on the
  /// internet.
  final String initialValue;

  ImageFormField(this.fieldName,
      {@required this.label, @required this.onSaved, this.initialValue});
  _ImageFormFieldState createState() => _ImageFormFieldState();
}

class _ImageFormFieldState extends State<ImageFormField> {
  File _imageFile;
  String _imageUrl;
  bool _dirty = false;
  final double _thumbSize = 200.0;

  @override
  void initState() {
    if (widget.initialValue != null) {
      if (validators.isURL(widget.initialValue)) {
        _imageUrl = widget.initialValue;
      } else {
        Uri uri = Uri(path: widget.initialValue);
        _imageFile = File.fromUri(uri);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _textEditingController = TextEditingController(
      text: _imageUrl,
    );

    return FormField(
      builder: (FormFieldState<String> state) {
        return Column(
          children: <Widget>[
            Row(
              children: <Widget>[
              FormFieldCaption(widget.label),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(color: Colors.grey),
                  child: _imageFile != null
                      ? ImageDisplayField(
                          imageString: _imageFile.path, boxSize: _thumbSize)
                      : ImageDisplayField(
                          imageString: _imageUrl, boxSize: _thumbSize),
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.image),
                      onPressed: () {
                        _setImageFile(ImageSource.gallery);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.camera),
                      onPressed: () {
                        _setImageFile(ImageSource.camera);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.insert_link),
                      onPressed: () async {
                        await showDialog<String>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Icon(Icons.link),
                              content: TextField(
                                controller: _textEditingController,
                                decoration: InputDecoration(
                                    hintText:
                                        "https://rapido-mobile.github.io/assets/background.jpg"),
                              ),
                              actions: <Widget>[
                                FloatingActionButton(
                                  child: Icon(Icons.check),
                                  onPressed: () {
                                    Navigator.pop(
                                        context, _textEditingController.text);
                                  },
                                ),
                              ],
                            );
                          },
                        ).then((String url) {
                          if (url == "" || url == null) return;
                          setState(() {
                            _imageFile = null;
                            _imageUrl = url;
                            _dirty = true;
                          });
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _imageFile = null;
                          _imageUrl = null;
                          _dirty = true;
                        });
                      },
                    )
                  ],
                ),
              ],
            ),
          ],
        );
      },
      onSaved: (String path) async {
        if (_dirty) {
          if (_imageFile != null) {
            Directory dir = await getApplicationDocumentsDirectory();
            String path = dir.path;
            String filename = basename(_imageFile.path);
            File newFile = _imageFile.copySync("$path/$filename");
            widget.onSaved(newFile.path);
          } else if (_imageUrl != null) {
            widget.onSaved(_imageUrl);
          } else {
            widget.onSaved(null);
          }
        } else {
          widget.onSaved(widget.initialValue);
        }
      },
    );
  }

  void _setImageFile(ImageSource source) async {
    File file = await ImagePicker.pickImage(source: source);
    if (file == null) return;
    setState(() {
      _imageUrl = null;
      _imageFile = file;
      _dirty = true;
    });
  }
}


