import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'dart:async';

/// UI for managing Parse Server logins.
/// Currently incomplete and under heavy development.
class ParseUserPage extends StatefulWidget {
  final Function onComplete;

  const ParseUserPage({this.onComplete});

  @override
  _ParseUserPageState createState() => _ParseUserPageState();
}

class _ParseUserPageState extends State<ParseUserPage> {
  ParseUser user;
  ParseLoggInState userState;
  bool initializing = true;

  @override
  void initState() {
    initUser();
    super.initState();
  }

  initUser() async {
    user = await ParseUser.currentUser();
    userState = await getCurrentParseUserState(user);
    setState(() {
      initializing = false;
    });
  }

  logoutUser() async {
    await user.logout(deleteLocalUserData: false);

    setState(() {
      userState = ParseLoggInState.UserLoggedOut;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (initializing)
      return Center(
        child: CircularProgressIndicator(),
      );
    if (userState == ParseLoggInState.UserLoggedIn) {
      return ParseUserWidget(
          userName: user.username,
          email: user.emailAddress,
          onLogout: logoutUser);
    }
    return ParseLoginForm(
      user: user,
      onComplete: (ParseUser _user) {
        setState(() {
          user = _user;
          userState = ParseLoggInState.UserLoggedIn;
        });
      },
    );
  }
}

/// Dialog to handle Parse Server logins.
/// Currently incomplete and under heavy development.
class ParseUserDialog extends StatelessWidget {
  const ParseUserDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ParseUserPage(
        onComplete: (bool success) {
          Navigator.pop(context, success);
        },
      ),
    );
  }
}

/// Form to handle Parse Server logins.
/// Currently incomplete and under heavy development.
class ParseLoginForm extends StatefulWidget {
  final Function onComplete;
  final ParseUser user;
  const ParseLoginForm({this.onComplete, this.user});

  _ParseLoginFormState createState() => _ParseLoginFormState();
}

class _ParseLoginFormState extends State<ParseLoginForm> {
  bool register = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  ParseUser _user;

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
        if (register) {
          _user = ParseUser(usernameController.text, passwordController.text,
              emailController.text);
          await _user.signUp();
        } else {
          _user = ParseUser(usernameController.text, passwordController.text,
              emailController.text);
          await _user.login();
        }
        widget.onComplete(_user);
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

/// Widget allowing Parse Server logins and registration.
/// Currently incomplete and under heavy development.
class ParseUserWidget extends StatelessWidget {
  final String userName;
  final String email;
  final Function onLogout;

  const ParseUserWidget({this.userName, this.email, this.onLogout});

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

/// Enumeration of possible states for a Parse Server user.
enum ParseLoggInState { NoUser, UserLoggedOut, UserLoggedIn }

/// Check if the user is logged into a Parse Server
Future<ParseLoggInState> getCurrentParseUserState(ParseUser user) async {
  // user = await ParseUser.currentUser();
  // check if there is a user stored locally
  if (user == null) return ParseLoggInState.NoUser;
  // check if the user has a token, and if so, does it work?
  if (user != null) {
    ParseResponse response = await ParseUser.getCurrentUserFromServer();

    if (response != null) {
      if (response.result != null) return ParseLoggInState.UserLoggedIn;
    }
  }
  return ParseLoggInState.UserLoggedOut;
}
