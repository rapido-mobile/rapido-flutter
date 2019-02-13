import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class UserPage extends StatefulWidget {
  final Function onComplete;
  final bool register;

  const UserPage({this.onComplete, this.register: false});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  dynamic user;

  @override
  void initState() async{
    user = await ParseUser.currentUser();
    print(user);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: _createChildren(widget.register),
      ),
    );
  }

  List<Widget> _createChildren(bool regsiter) {
    List<Widget> widgets = [];
    widgets.add(TextField(
      decoration: InputDecoration(labelText: "user name"),
      controller: usernameController,
    ));
    widgets.add(
      TextField(
        decoration: InputDecoration(labelText: "password"),
        obscureText: true,
        controller: passwordController,
      ),
    );
    if (regsiter) {
      widgets.add(TextField(
        decoration: InputDecoration(labelText: "email"),
        controller: emailController,
      ));
    }
    widgets.add(FloatingActionButton(
      child: Icon(Icons.check),
      onPressed: () async {
        bool loginSuccess = false;
        if (regsiter) {
          // String endPoint = "http://10.0.2.2/parse/classes/_User";
          // Map<String, String> body = {
          //   "username": "testUser",
          //   "password": "password",
          //   "email": "test@example.com"
          // };
          // Map<String, String> headers = {
          //     "Content-Type": "application/json",
          //     "X-Parse-Application-Id": "'app'",
          //   };
          // http
          //     .post(
          //   endPoint,
          //   headers: headers,
          //   body: json.encode(body),
          // )
          //     .then((http.Response response) {

          //   print("$endPoint returned:");
          //   print(response.body);
          //   print("With headers: ${response.headers}");
          // });
          Parse().initialize("'app'", "http://10.0.2.2/parse", debug: true);

          ParseUser user = ParseUser(usernameController.text,
              passwordController.text, emailController.text);
          ParseResponse response = await user.signUp();

          loginSuccess = response.success;
        }
        widget.onComplete(loginSuccess);
      },
    ));
    return widgets;
  }
}

class LoginDialog extends StatelessWidget {
  final bool register;

  const LoginDialog({this.register: false});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: UserPage(
        register: register,
        onComplete: (bool success) {
          Navigator.pop(context, success);
        },
      ),
    );
  }
}
