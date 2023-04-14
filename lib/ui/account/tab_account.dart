/*
This is account page
we used AutomaticKeepAliveClientMixin to keep the state when moving from 1 navbar to another navbar, so the page is not refresh overtime
 */

import 'dart:convert';

import 'package:actkosep/config/constant.dart';
import 'package:actkosep/config/global_style.dart';
import 'package:actkosep/ui/account/account_information/account_information.dart';
import 'package:actkosep/ui/home/Nav_right.dart';
import 'package:actkosep/ui/reusable/reusable_widget.dart';
import 'package:actkosep/ui/reusable/cache_image_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TabAccountPage extends StatefulWidget {
  @override
  _TabAccountPageState createState() => _TabAccountPageState();
}

class _TabAccountPageState extends State<TabAccountPage> with SingleTickerProviderStateMixin {
  // with SingleTickerProviderStateMixin
  final _reusableWidget = ReusableWidget();
  ///작성자
  var _usernm = "";
  var _userid = "";

  @override
  void initState() {
    sessionData();
    super.initState();
  }
  @override
  bool get wantKeepAlive => true;
  @override
  Future<void> sessionData() async {
    String username = await  SessionManager().get("username");
    // _usernm = utf8.decode(username.runes.toList());
    String userid = await  SessionManager().get("userid");
    // _userid = utf8.decode(userid.runes.toList());
    setState(() {
      _usernm = utf8.decode(username.runes.toList());
      _userid = utf8.decode(userid.runes.toList());
    });

  }
  final Future<String> _calculation = Future<String>.delayed(
    const Duration(seconds: 0),
        () => 'e',
  );

  @override
  Widget build(BuildContext context) {
    // if we used AutomaticKeepAliveClientMixin, we must call super.build(context);
    // super.build(context);
    return Scaffold(
        endDrawer: Nav_right(
          text: Text('acc_nav'),
          color: SOFT_BLUE,
        ),
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: GlobalStyle.appBarIconThemeColor,
          ),
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Text(
            'Account',
            style: GlobalStyle.appBarTitle,
          ),
          backgroundColor: GlobalStyle.appBarBackgroundColor,
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: [
            _createAccountInformation(),
            Container(
              height: 20,
              margin: EdgeInsets.fromLTRB(0, 18, 0, 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(_usernm, style: TextStyle(
                      fontSize: 15, color: CHARCOAL,
                  )),
                  // Icon(Icons.chevron_right, size: 20, color: SOFT_GREY),
                ],
              ),
            ),

            _reusableWidget.divider1(),
            Container(
              height: 20,
              margin: EdgeInsets.fromLTRB(0, 18, 0, 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(_userid, style: TextStyle(
                      fontSize: 15, color: SOFT_BLUE, fontWeight: FontWeight.bold
                  )),
                  Text( ' 님이 접속 중입니다.',
                    style: TextStyle(color: BLACK_GREY ,fontSize: 15),
                  ),
                  // Icon(Icons.chevron_right, size: 20, color: SOFT_GREY),
                ],
              ),
            ),
            _reusableWidget.divider1(),
          ],
        )
    );
  }

  Widget _createAccountInformation(){
    final double profilePictureSize = MediaQuery.of(context).size.width/4;
    return Container(
      margin: EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: profilePictureSize,
            height: profilePictureSize,
            child: GestureDetector(
              // onTap: () {
              //   Navigator.push(context, MaterialPageRoute(builder: (context) => AccountInformationPage()));
              // },
              child: CircleAvatar(
                backgroundColor: Colors.grey[200],
                radius: profilePictureSize,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: profilePictureSize-4,
                  child: Hero(
                    tag: 'profilePicture2',
                    child: ClipOval(
                        child: buildCacheNetworkImage(width: profilePictureSize-4, height: profilePictureSize-4, url: GLOBAL_URL+'/user/avatar.png')
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                start(),
                Text( _usernm,
                  style: TextStyle(color: SOFT_BLUE ,fontSize: 18,fontWeight: FontWeight.bold),
                ),
                Text( ' 님 반갑습니다.',
                  style: TextStyle(color: BLACK_GREY ,fontSize: 18),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _createListMenu(String menuTitle, StatefulWidget page){
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 18, 0, 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(menuTitle, style: TextStyle(
                fontSize: 15, color: CHARCOAL
            )),
            // Icon(Icons.chevron_right, size: 20, color: SOFT_GREY),
          ],
        ),
      ),
    );
  }
  Widget start(){
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.displayMedium!,
        textAlign: TextAlign.center,
        child: FutureBuilder<String>(
          future: _calculation, // a previously-obtained Future<String> or null
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            List<Widget> check;
            if (snapshot.hasData) {
              check = <Widget>[
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 20,
                ),

              ];
            } else if (snapshot.hasError) {
              check = <Widget>[
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 20,
                ),
              ];
            } else {
              check = const <Widget>[
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(),
                ),
              ];
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: check,
              ),
            );
          },
        ),
      ),
    );
  }
}
