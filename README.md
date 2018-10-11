# a2s_widgets

A set of widgets to make flutter programming more RAD, easy and fun.

First class is a PersistentModel that automatically saves and loads objects in the form of Map<String, dynamic>, assuming it can be converted to JSON.

See the test directory for usage. The data is written and read asyncronously. I will add widgets to easy the async programming by including a visual indicator when doing the async operations.

To add persistent data to the model:
```
  test('creates a PersistedModel', () {
    PersistedModel persistedModel = PersistedModel("testDocumentType");
    persistedModel
        .add({"count": 0, "rating": 5, "price": "0.5", "name": "Pickle Rick"});
    persistedModel
        .add({"count": 1, "rating": 4, "price": "1.5", "name": "Rick Sanchez"});
    expect(persistedModel.data.length, 2);
  });
```

```
To read persistent data, use the onLoadComplete parameter if you want to wait until data is loaded. 
  test('reads existing PersistedModel from disk', () {
    PersistedModel("testDocumentType",
        onLoadComplete: (List<Map<String, dynamic>> data) {
      expect(data.length, 2);
      String name = data[0]["name"];
      expect(name.contains("Rick"), true);
      name = data[1]["name"];
      expect(name.contains("Rick"), true);
    });
  });
```
