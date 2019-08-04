import 'dart:io';

import 'package:rapido/rapido.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'dart:async';

class ParsePersistence implements PersistenceProvider {
  final String parseApp;
  final String parseUrl;

  ParsePersistence({this.parseApp, this.parseUrl}) {
    _initializeParse(parseApp, parseUrl);
  }

  @override
  Future deleteDocument(Document doc) {
    if (doc["objectId"] == null) return null;
    ParseObject obj = _parseObjectFromDocument(doc);
    String path = "${doc.documentType}/${doc.id}";
    obj.delete(path: path);
    return null;
  }

  @override
  Future loadDocuments(DocumentList documentList,
      {Function onChangedListener}) async {

    ParseResponse apiResponse =
        await ParseObject(documentList.documentType).getAll();

    if (apiResponse.success && apiResponse.result != null) {
      for (ParseObject obj in apiResponse.result) {

        Map<String, dynamic> savedData =
            Map<String, dynamic>.from(obj.getObjectData());
        Map<String, dynamic> newData = {};

        for (String key in savedData.keys) {
          if (key.startsWith("rapido_")) {
            String realKey = key.replaceFirst("rapido_", "_");
            newData[realKey] = savedData[key];
          }
          if (key.endsWith("latlong")) {
            // convert latlongs to the correct type
            Map<String, double> latlongMap = {};
            latlongMap["latitude"] = savedData[key]["latitude"];
            latlongMap["longitude"] = savedData[key]["longitude"];
            newData[key] = latlongMap;
          } else {
            newData[key] = savedData[key];
          }
        }
        Document doc = Document.fromMap(newData,
            persistenceProvider: documentList.persistenceProvider);
        documentList.add(doc, saveOnAdd: false);
        documentList.notifyListeners();
      }
    }
  }

  @override
  Future<bool> saveDocument(Document doc) {
    ParseObject obj = _parseObjectFromDocument(doc);
    if (doc["objectId"] == null) {
      obj.create().then((ParseResponse responts) {
        ParseObject newObj = responts.result;
        doc["objectId"] = newObj.objectId;
      });
    } else {
      obj.save();
    }
    return null;
  }

  ParseObject _parseObjectFromDocument(Document doc) {
    ParseObject obj = ParseObject(doc.documentType, debug: true);
    for (String key in doc.keys) {
      String parseKey = key;
      if (key.startsWith("_")) {
        parseKey = "rapido" + parseKey;
      }
      obj.set(parseKey, doc[key]);
    }
    return obj;
  }

  _initializeParse(String parseApp, String parseUrl,
      {bool debug = false,
      String appName = "",
      String liveQueryUrl,
      String clientKey,
      String sessionId,
      bool autoSendSessionId,
      SecurityContext securityContext}) {
    Parse().initialize(parseApp, parseUrl,
        debug: debug,
        appName: appName,
        liveQueryUrl: liveQueryUrl,
        clientKey: clientKey,
        sessionId: sessionId,
        autoSendSessionId: autoSendSessionId,
        securityContext: securityContext);
  }
}
