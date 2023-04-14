import 'package:actkosep/ui/account/tab_account.dart';
import 'package:flutter/material.dart';

import '../app01/AppPage01.dart';
import '../app01/AppPage02.dart';
import '../home/tab_home.dart';




class Nav_right extends StatelessWidget{
  final Widget text;
  final Color color;

  Nav_right(
      {Key? key,
        required this.text, required this.color,

      }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(child:
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Actas',
              style: TextStyle(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold
              ),
            ),
          ),
              decoration: BoxDecoration(
                  color: Colors.blue[800]
              )),
          ListTile(
              title: GestureDetector(
                  onTap: (){
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => TabHomePage()));                    },
                  child:  Row(
                      children:[
                        Icon(Icons.home),
                        SizedBox(
                            width: 10),
                        Text('Home'),
                      ]))),
          ListTile(
              title: GestureDetector(
                  onTap: (){
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => AppPage01()));                    },
                  child:  Row(
                      children:[
                        Icon(Icons.favorite),
                        SizedBox(
                            width: 10),
                        Text('출고등록'),
                      ]))),
          ListTile(
              title: GestureDetector(
                  onTap: (){
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => AppPage02()));                     },
                  child:  Row(
                      children:[
                        Icon(Icons.safety_check),
                        SizedBox(
                            width: 10),
                        Text('출고현황'),
                      ]))),
          ListTile(
              title: GestureDetector(
                  onTap: (){
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => TabAccountPage()));
                    },
                  child:  Row(
                      children:[
                        Icon(Icons.person_outlined),
                        SizedBox(
                            width: 10),
                        Text('Account'),
                      ]))),
          ListTile(
              title: GestureDetector(
                  onTap: (){
                    Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                    },
                  child:  Row(
                      children:[
                        // SizedBox(height: MediaQuery.of(context).size.height/1.4,
                        //     width: 190),
                        Icon(Icons.door_back_door_outlined),
                        SizedBox(
                            width: 10),
                        Text('Logout'),
                      ]))),
        ],
      ),
    );
  }



}