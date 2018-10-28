# a2s_widgets
## Mental Model
The App to Store widget collection has two fundamental concepts:
1. Persistent Models
2. UI that renders itself based on the models

### PersistentModel
Persistent model is a class that encapsulates a map of objects keyed with strings. This map is accessed via the models data property. However, you only read from the data property, in order to add, delete, or update the data, you use the models build in properties. That is because the model manages persistence for you automatically! If users 

The following code creates a model and adds to entries to it:
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

You can retrive the data by indexing into the data property:

```
print(model.data[1]["name"]) => "Rick Sanchez";
```

### UI Elements
Once you have create a model, you can easily add it to your application by passing the model into PersistentModel UI classes. Those UI classes will do their best to render a UI with minimal configuration. For example, the following test app creates a ListView.
