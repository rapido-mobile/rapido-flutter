import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'dart:async';

class UserPage extends StatefulWidget {
  final Function onComplete;

  const UserPage({this.onComplete});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  ParseUser user;
  UserState userState;
  bool initializing = true;

  @override
  void initState() {
    Parse().initialize("'app'", "http://10.0.2.2/parse", debug: true);
    initUser();
    super.initState();
  }

  initUser() async {
    user = await ParseUser.currentUser();
    userState = await getCurrentUserState(user);
    setState(() {
      initializing = false;
    });
  }

  logoutUser() async {
    user.logout();
    user = await ParseUser.currentUser();
    ParseResponse response = await ParseUser.getCurrentUserFromServer();
    if (response.success) user = response.result;

    response = await user.save();
    if (response.success) user = response.result;
    print("------");
    print(user);
    setState(() {
      userState = UserState.UserLoggedOut;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("******** $userState");
    if (initializing)
      return Center(
        child: CircularProgressIndicator(),
      );
    if (userState == UserState.UserLoggedIn)
      return UserWidget(
          userName: user.username,
          email: user.emailAddress,
          onLogout: logoutUser);
    return LoginForm(
      user: user,
      onComplete: (bool success) {
        if (success) {
          setState(() {
            userState = UserState.UserLoggedIn;
          });
        }
      },
    );
  }
}

class LoginDialog extends StatelessWidget {
  const LoginDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: UserPage(
        onComplete: (bool success) {
          Navigator.pop(context, success);
        },
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  final Function onComplete;
  final ParseUser user;
  const LoginForm({this.onComplete, this.user});

  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool register = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.user != null) {
      usernameController.text = widget.user.username;
      passwordController.text = widget.user.password;
      emailController.text = widget.user.emailAddress;
    }

    return Container(
      child: Column(
        children: _createChildren(),
      ),
    );
  }

  List<Widget> _createChildren() {
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
    if (register) {
      widgets.add(TextField(
        decoration: InputDecoration(labelText: "email"),
        controller: emailController,
      ));
    }
    widgets.add(FloatingActionButton(
      child: Icon(Icons.check),
      onPressed: () async {
        bool loginSuccess = false;
        if (register) {
          ParseUser user = ParseUser(usernameController.text,
              passwordController.text, emailController.text);
          ParseResponse response = await user.signUp();

          loginSuccess = response.success;
        } else {
          ParseUser user = ParseUser(usernameController.text,
              passwordController.text, emailController.text);
          ParseResponse response = await user.login();

          loginSuccess = response.success;
        }
        widget.onComplete(loginSuccess);
      },
    ));
    if (!register) {
      widgets.add(RaisedButton(
        child: Text("Register"),
        onPressed: () {
          setState(() {
            register = true;
          });
        },
      ));
    } else {
      widgets.add(RaisedButton(
        child: Text("Login"),
        onPressed: () {
          setState(() {
            register = false;
          });
        },
      ));
    }
    return widgets;
  }
}

class UserWidget extends StatelessWidget {
  final String userName;
  final String email;
  final Function onLogout;

  const UserWidget({this.userName, this.email, this.onLogout});

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
              onPressed: () {
                onLogout();
              },
            ),
          ),
        )
      ],
    );
  }
}

enum UserState { NoUser, UserLoggedOut, UserLoggedIn }

Future<UserState> getCurrentUserState(ParseUser user) async {
  // user = await ParseUser.currentUser();
  // check if there is a user stored locally
  if (user == null) return UserState.NoUser;

  // check if that user's existing token works
  if (user != null) {
    ParseResponse response = await ParseUser.getCurrentUserFromServer();
    if (response.success) {
      return UserState.UserLoggedIn;
    }
  }
  return UserState.UserLoggedOut;
}
