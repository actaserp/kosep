import 'package:actkosep/config/global_style.dart';
import 'package:actkosep/ui/authentication/forgot_password.dart';
import 'package:actkosep/ui/home.dart';
import 'package:actkosep/ui/authentication/usercheck.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:actkosep/config/constant.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../home/tab_home.dart';
class SigninPage extends StatefulWidget {
  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  TextEditingController _etEmail = TextEditingController();
  bool _obscureText = true;
  IconData _iconVisible = Icons.visibility_off;
  String _userid = '';
  String _userpw = '';
  String? userInfo = ""; //user의 정보를 저장하기 위한 변수
  static final storage =  new FlutterSecureStorage(); //flutter_secure_storage 사용을 위한 초기화 작업

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
      if (_obscureText == true) {
        _iconVisible = Icons.visibility_off;
      } else {
        _iconVisible = Icons.visibility;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    //비동기로 flutter secure storage 정보를 불러오는 작업.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }


  _asyncMethod() async {
    //read 함수를 통하여 key값에 맞는 정보를 불러오게 됩니다. 이때 불러오는 결과의 타입은 String 타입임을 기억해야 합니다.
    //(데이터가 없을때는 null을 반환을 합니다.)
    userInfo = await storage.read(key: "login");
    print(userInfo);

    //user의 정보가 있다면 바로 로그아웃 페이지로 넝어가게 합니다.
    if (userInfo != null) {
      Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
              builder: (context) => TabHomePage(
                id: userInfo!.split(" ")[1],
                pass: userInfo!.split(" ")[3],
              )));
    }
  }

  @override
  void dispose() {
    _etEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
          padding: EdgeInsets.fromLTRB(30, 120, 30, 30),
          children: <Widget>[
            Center(
                child: Image.asset(LOCAL_IMAGES_URL+'/logo.png',
                    height: 32)),
            SizedBox(
              height: 80,
            ),
            Text('Sign In', style: GlobalStyle.authTitle),
            TextFormField(
              controller: _etEmail,
              style: TextStyle(color: CHARCOAL),
              validator: (value){
                if(value!.isEmpty){
                  return '아이디를 입력하세요';
                }
              },
              onChanged: (textValue) {
                setState(() {
                  _userid = textValue;
                });
              },
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                    BorderSide(color: PRIMARY_COLOR, width: 2.0)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                ),
                labelText: 'ID',
                labelStyle: TextStyle(color: BLACK_GREY),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              obscureText: _obscureText,
              style: TextStyle(color: CHARCOAL),
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                    BorderSide(color: PRIMARY_COLOR, width: 2.0)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                ),
                labelText: 'Password',
                labelStyle: TextStyle(color: BLACK_GREY),
                suffixIcon: IconButton(
                    icon: Icon(_iconVisible, color: Colors.grey[400], size: 20),
                    onPressed: () {
                      _toggleObscureText();
                    }),
              ),
              onChanged: (textValue) {
                setState(() {
                  _userpw = textValue;
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            Align(
                alignment: Alignment.centerRight,
                child: Container(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
                      FocusScope.of(context).unfocus();
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: Color.fromRGBO(0, 0, 051, 0), fontSize: 13),  //비밀번호 찾기 opacity 0  임시로 visible false로 함.
                    ),
                  ),
                )),
            SizedBox(
              height: 40,
            ),
            Container(
              child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) => Color.fromRGBO(0, 0, 051, 100),
                    ),
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.0),
                        )
                    ),
                  ),
                  onPressed: () async{
                    // Fluttertoast.showToast(
                    //     msg: 'Click login : ' + _userid + '/' + _userpw,
                    //     toastLength: Toast.LENGTH_LONG);
                    var user = await Usercheck(_userid, _userpw);
                    if(user.length == 0){
                      print("사용자가 없음.");
                      showAlertDialog(context, "사용자가 없습니다.");
                      return;
                    }else{
                      await storage.write(
                          key: "login",
                          value: "id " +
                              _etEmail.text.toString() +
                              " " +
                              "password " +
                              _obscureText.toString());

                      Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => TabHomePage(
                              id: _userid,
                              pass: _userpw,
                            )),
                      );
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));

                    }
                    //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage()), (Route<dynamic> route) => false);
                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(_userid,_userpw)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  )
              ),
            ),
            SizedBox(
              height: 40,
            ),

            SizedBox(
              height: 20,
            ),
          ],
        ));
  }

  void showAlertDialog(BuildContext context, String as_msg) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('User Info'),
          content: Text(as_msg),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context, "확인");
              },
            ),
          ],
        );
      },
    );
  }
}
