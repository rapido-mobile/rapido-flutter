# rapido
Rapido brings Rapid Application Development principles to mobile development, currently available for Flutter.

## Overview of Using DocumentList
DocumentList lies at the core of the R.A.D. experience. By simply using a list, you get:

1. Local persistence of objects.
2. Default CRUD UI that your users can use for displaying, creating, editing, and deleting documents in the list.

## Importing
Everything you need is in document_list.dart:

```
import 'package:rapido/document_list.dart';
```

This import includes DocumentList itself, and all of the UI elements that work on it.

### DocumentList
To create a DocumentList, all that is required is to include a "documentType" string. This string is used by DocumentList to organize its documents. Then you can add documents to it by simply passing in maps of type Map<String, dynamic>.

```
DocumentList taskList = DocumentList("tasks");
taskList.add({"name":"grocery shopping", "priority": 1, "done": false});
```

Notice that the maps use a string of a key, but the values are dynamic. You can store anything you like in the DocumentList.

You can modify and delete documents using normal list functionality. 

```
taskList[0]  = {"name":"grocery shopping", "priority": 1, "done": true};
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

## Roadmap
### More TypedInputFields
DocumentForm works by creating input fields based on the name of the field in the document. Our current plan is to add more typed input fields, such as:
 * Switches
 * Favorite 
 * Time and DateTime
 * Long Text

### Cloud Storage and Syncing
We plan to make storing and syncing documents with DocumentList incredibly easy.

### Camera Widget
We need to dramatically simplify using a camera in your application.
