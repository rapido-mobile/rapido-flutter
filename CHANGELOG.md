## [0.0.10] - 2018-11-24
 * Add a specific Document class that inherits from MapBase<String, dynamic>. Most code should not be effected by this, but this is a breaking change for many of the functions on DocumentList. For example, DocumentList.add and DocumentList.addAll must be updated to create a Docuent: documentList.add(Document({"field1":"value1})). This change is in preparation to improve the usability of working with Documents and DocumentLists.

## [0.0.9] - 2018-11-24
 * Added datetime field support in TypedInputField. Requires that the string be in a specific format ("EEE, MMM d, y H:mm:s"). This can be overridden by passing in a custom dateTimeFormat string when creating the TypedInputField. Date field now supports custom date formats as well. More work is required to enhance the usability of this part of the API, but the current API is 

## [0.0.8] - 2018-11-23
 * Updated README with a more clear explanation of the project
 * Add the ability to include a label with the add document fab

## [0.0.7] - 2018-11-20
 * Removed required title parameter from DocumentListScaffold

## [0.0.6] - 2018-11-19 
 * Adding a sorting button widget

## [0.0.5] - 2018-11-19 
 * Added more examples to example/
 * added DocumentList.sortByField() to simplify sorting

## [0.0.4] - 2018-11-17
* Updated pubspec.yaml to explicitly reference test.dart after flutter update
* Fixed https://github.com/rapido-mobile/rapido-flutter/issues/5 which made DocumentList.sort() work

## [0.0.1] - 2018-11-14
* Initial relese with DocumentList and related classes
* Document persistence handled by writing json files as first implementation







 