# rapido
Rapido brings Rapid Application Development principles to mobile development, currently available for Flutter.

## Introduction
Rapido makes it simple to build document centric applications by:
1. Providing DocumentList and Document classes that makes it easy to manage user data, including persistence.
2. Provides many of the UI elements that you need to work with DocumentList, including ListViews, Forms, Maps, and other widgets. They know how to work with DocumentList so provide a ton of functionality with almost no additional coding.
3. The ability to easily customize the core widgets provided.

## Show Me
Create a DocumentList and defining labels for fields, and then create a DocumentListScaffold like this:
```
class _MyHomePageState extends State<MyHomePage> {
  DocumentList taskList = DocumentList("Tarea",
      labels: {"Date": "date", "Task": "task", "Priority": "pri count"});

  @override
  Widget build(BuildContext context) {
    return DocumentListScaffold(taskList);
  }
}
```

The rapido widgets infer what kind data is in each field based on the field name. Basic CRUD functionality is automatically created:
![add button, forms, listview, edit and delete, sorting](https://rapido-mobile.github.io/assets/basic-ui.png)

Rapido also handles specialized data types:
![pickers, and mapss](https://rapido-mobile.github.io/assets/advanced-ui.png)

You can replace any widget with your own widget, or you can use built in customization hooks to quickly create your own look and feel.

# Rapido Online
 * [Get Rapido](https://pub.dartlang.org/packages/rapido)
 * [Our Github Repo](https://github.com/rapido-mobile/rapido-flutter)
 * [Rapido Tutorial](https://rapido-mobile.github.io/tutorials/introduction.html)
 * We have some intro videos on our [Youtube Channel](https://www.youtube.com/channel/UCeoRpyhpNJmiMuAEJ4WRljg)

# A Closer Look
## Overview of Using DocumentList
DocumentList lies at the core of the R.A.D. experience. By simply using a list, you get:

1. Local persistence of objects.
2. Default CRUD UI that your users can use for displaying, creating, editing, and deleting documents in the list.

## Importing
Everything you need is in rapido.dart:

```
import 'package:rapido/rapido.dart';
```

This import includes DocumentList itself, and all of the UI elements that work on it.

### DocumentList
To create a DocumentList, all that is required is to include a "documentType" string. This string is used by DocumentList to organize its documents. Then you can add documents to it by simply passing in maps of type Map<String, dynamic>.

```
DocumentList taskList = DocumentList("tasks");
taskList.add(Document(initialValues: {"name":"grocery shopping", "priority": 1, "done": false}));
```

Notice that the maps use a string of a key, but the values are dynamic. You can store anything you like in the DocumentList.

You can modify and delete documents using normal list functionality. 

```
taskList[0]  = Document(initialValues: {"name":"grocery shopping", "priority": 1, "done": true});
```

You can delete them:

```
taskList.removeAt[0];
```

Note that all changes to the DocumentList are automatically persisted to the user's phone! The user can close the app, and when they reopen them, the data is still right there.

### UI Elements
After creating a DocumentList, you can use it in a variety of UI elements supplied by Rapido. By simply passing in a DocumentList, the widgets can figure out themselves what functionality to display to users.

For exampe, if you want to easily create an application that supports adding, removing, and editing documents, you can use the DocumentListScaffold class.

```
DocumentListScaffold(taskList, title:"Task List");
```

DocumentListView will create a ListView to display and edit the items in the list. It also offers several custimazation options, but the defautls "just work."

```
DocumentListView(taskList);
```

DocumentListMapView will display any documents with a field called "latlong" on a map:
```
DocumentListMapView(taskList);
```

DocumentForm allows easy creation of new documents, or editing of existing ones.

To create a new document:

```
DocumentForm(taskList);
```

To edit an existing one:

```
DocumentForm(taskList, index: 0);
```

## Feedback Welcome
Rapido is undergoing rapid development. Please visit [our Github repo](https://github.com/rapido-mobile/rapido-flutter) to log any issues or features requests. Of course, pull requests are most welcome.
