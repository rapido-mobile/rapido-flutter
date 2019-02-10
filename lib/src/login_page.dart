import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Function onComplete;

  const LoginPage({this.onComplete});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(labelText: "user name"),
          ),
          TextField(
            decoration: InputDecoration(labelText: "user name"),
            obscureText: true,
          ),
          FloatingActionButton(
            child: Icon(Icons.check),
            onPressed: () {
              widget.onComplete();
            },
          )
        ],
      ),
    );
  }
}

class LoginDialog extends StatelessWidget {
  final String userName;
  final String passWord;

  const LoginDialog({this.userName, this.passWord});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: LoginPage(onComplete: (){
        Navigator.pop(context);
      },),
    );
  }
}
