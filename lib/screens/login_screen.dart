import 'package:flutter/material.dart';
import 'package:video_play/screens/home_screen.dart';

class LoginPage extends StatefulWidget {
  
  @override
  _LoginPageState createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
final _userName = TextEditingController();
  final _userPassword = TextEditingController();

    Widget _userNameWidget() {
    return TextFormField(
      controller: _userName,
      decoration: InputDecoration(
          hintText: "UserName",
          errorStyle: TextStyle(
              fontSize: 15.0)),
    );
  }
    Widget _passwordWidget() {
    return TextFormField(
      controller: _userPassword,
      obscureText: true,
      decoration: InputDecoration(
          hintText: "Password",
          errorStyle: TextStyle(
               
              fontSize: 15.0)),
    );
  }

Widget _button(textTODisplay,functionName){
  return RaisedButton(
    child: Text(textTODisplay),
    onPressed:functionName
    );
}

void checkCredentials(){
  if(_userName.text=='admin' && _userPassword.text=="admin"){
     Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(),
        ),
        );
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('Video Player'),
      ),
          body: Center(
        child: Container(
        color: Colors.yellow[50],
          height: MediaQuery.of(context).size.height * 0.40,
          width: MediaQuery.of(context).size.width * 0.80,
          child: Card(
            child: Column(
              mainAxisAlignment:MainAxisAlignment.spaceAround,
              children: <Widget>[
                _userNameWidget(),
                _passwordWidget(),
                _button("Login", checkCredentials)
                ],
            ),
          ),
        ),
      ),
    );
  }
}