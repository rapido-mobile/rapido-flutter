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
  bool initializing = true;
  ParseUser user;

  @override
  void initState() {
    Parse().initialize("'app'", "http://10.0.2.2/parse", debug: true);
    initUser();
    super.initState();
  }

  initUser() async {
    user = await ParseUser.currentUser();
    if (user != null) {
      ParseResponse response = await ParseUser.getCurrentUserFromServer();
      if (response.success) user = response.result;

      response = await user.save();
      if (response.success) user = response.result;
    }
    setState(() {
      initializing = false;
    });
    print(user);
  }

  @override
  Widget build(BuildContext context) {
    if (initializing)
      return Center(
        child: CircularProgressIndicator(),
      );
    if (user != null) {
      return UserWidget(
        userName: user.username,
        email: user.emailAddress,
      );
    }
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

class UserWidget extends StatelessWidget {
  final String userName;
  final String email;

  const UserWidget({this.userName, this.email});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: Text(userName),
          ),
        ),
        Container(
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: Text(email),
          ),
        ),
        Container(
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: FloatingActionButton(
              child: Icon(Icons.exit_to_app),
              onPressed: () {},
            ),
          ),
        )
      ],
    );
  }
}
