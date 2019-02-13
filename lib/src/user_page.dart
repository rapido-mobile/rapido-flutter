import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class UserPage extends StatefulWidget {
  final Function onComplete;

  const UserPage({this.onComplete});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  ParseUser user;
  bool initializing = true;
  
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
        onLogout: () {
          user.logout();
          setState(() {
            user = null;
          });
        },
      );
    }
    return LoginForm(
      onComplete: (bool success) {
        if (success) {
          setState(() {});
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

  const LoginForm({this.onComplete});

  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool register = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
        }
        widget.onComplete(loginSuccess);
      },
    ));
    if(!register){
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
