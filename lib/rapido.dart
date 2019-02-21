export 'src/add_document_floating_action_button.dart';
export 'src/document_form.dart';
export 'src/document_list_scaffold.dart';
export 'src/document_list_view.dart';
export 'src/typed_input_field.dart';
export 'src/document_actions_button.dart';
export 'src/document_list.dart';
export 'src/document_list_sort_button.dart';
export 'src/document.dart';
export 'src/document_list_map_view.dart';
export 'src/document_page.dart';
export 'src/typed_display_field.dart';
export 'src/map_point_form_field.dart';
export 'src/image_form_field.dart';
export 'src/boolean_form_field.dart';
export 'src/document_list_page_view.dart';
export 'src/list_picker.dart';
export 'src/field_options.dart';
export 'src/user_page.dart';

import 'package:parse_server_sdk/parse_server_sdk.dart';

initializeBackend(){
    Parse().initialize("'app'", "http://10.0.2.2/parse", debug: true);
}