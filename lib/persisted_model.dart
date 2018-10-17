library a2s_widgets;
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:math';


import 'package:scoped_model/scoped_model.dart';

class PersistedModel extends Model {
  final String documentType;
  Function onLoadComplete;

  List<Map<String, dynamic>> data;

  PersistedModel(this.documentType, {this.onLoadComplete}) {
    data = [];
    _loadLocalData();
  }

  void _loadLocalData() async {
    getApplicationDocumentsDirectory().then((Directory appDir){
    appDir.listSync(recursive: true,
     followLinks: true).forEach(( FileSystemEntity f) {
        if(f.path.endsWith('.json')) {
            String j = new File(f.path).readAsStringSync();
            Map newData = json.decode(j);
            data.add(newData);
        }
    });
    notifyListeners();
    if(onLoadComplete != null) onLoadComplete(this);
  });}

  void add(Map<String,dynamic> map) {
      map["docType"] = documentType;
      map["_id"] = randomFileSafeId(24);
      map["_time_stamp"] = new DateTime.now().millisecondsSinceEpoch.toInt();
      data.add(map);
      _writeMap(map);
      notifyListeners();
  }

void delete(int index) {
  _deleteMap(data[index]["_id"]);
  data.removeAt(index);
  notifyListeners();

}
static String randomFileSafeId(int length) {
   var rand = new Random();
   var codeUnits = new List.generate(
      length, 
      (index){
         List<int> illegalChars = [34, 39, 44, 96];
         int randChar = rand.nextInt(33)+89;
         while( illegalChars.contains(randChar)) {
            randChar = rand.nextInt(33)+89;
         }
         return randChar;
      }
   );
   
   return new String.fromCharCodes(codeUnits);
}

void _deleteMap(String id) async {
  final file = await _localFile(id);

  print("Deleting " + id);
  file.delete();
}

Future<File> _writeMap(Map<String,dynamic> map) async {
  final file = await _localFile(map["_id"]);
  // Write the file
  String mapString = json.encode(map);
  return file.writeAsString('$mapString');
}

Future<File> _localFile(String id) async {
  final path = await _localPath;
  return File('$path/$id.json');
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  String path = directory.path;
  return path;
}


}