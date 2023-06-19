
import 'dart:convert';

import 'package:actkosep/ui/app01/AppPage01_Subpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../config/constant.dart';
import '../../config/global_style.dart';
import '../../model/kosep/Ca636List_model.dart';
import '../../model/kosep/Da035List_model.dart';

class AppPage04 extends StatefulWidget {
  const AppPage04({Key? key}) : super(key: key);

  @override
  _AppPage04State createState() => _AppPage04State();
}

class _AppPage04State extends State<AppPage04>   {

  TextEditingController _etDate = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  DateTime _selectedDate = DateTime.now(), initialDate = DateTime.now();
  List<Ca636List_model> ca636Datas = ca636Data;
  String _dbnm = '';
  String _userid = '';
  String _username = '';
  String _perid = '';


  @override
  void initState() {
    sessionData();
    super.initState();
    _etDate.text = getToday();
  }

  @override
  void dispose() {
    _etDate.dispose();
    ca636Data.clear();
    super.dispose();
  }

  String getToday(){
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyyMMdd');
    String formattedDate = formatter.format(now);
    return formattedDate;
  }
  Future<void> sessionData() async{
    _dbnm     = (await SessionManager().get("dbnm")).toString();
    _userid   = (await SessionManager().get("userid")).toString();
    _username = (await SessionManager().get("username")).toString();
    _perid    = (await SessionManager().get("perid")).toString();
    print(_perid);
  }


  Future ca636list_getdata() async {
    String _dbnm = await  SessionManager().get("dbnm");

    var uritxt = CLOUD_URL + '/kosep/list04';
    var encoded = Uri.encodeFull(uritxt);

    Uri uri = Uri.parse(encoded);
    final response = await http.post(
      uri,
      headers: <String, String> {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept' : 'application/json'
      },
      body: <String, String> {
        'dbnm': _dbnm,
        'todate': _etDate.text
      },
    );
    if(response.statusCode == 200){
      List<dynamic> alllist = [];
      alllist =  jsonDecode(utf8.decode(response.bodyBytes))  ;
      ca636Data.clear();
      for (int i = 0; i < alllist.length; i++) {
        Ca636List_model emObject= Ca636List_model(
            custcd:alllist[i]['custcd'],
            spjangcd:alllist[i]['spjangcd'],
            movdate:alllist[i]['movdate'],
            strmovdate:alllist[i]['strmovdate'],
            movnum:alllist[i]['movnum'],
            movseq:alllist[i]['movseq'],
            pcode:alllist[i]['pcode'],
            pname:alllist[i]['pname'],
            grade:alllist[i]['grade'],
            thick:alllist[i]['thick'],
            width:alllist[i]['width'],
            color:alllist[i]['color'],
            lotno:alllist[i]['lotno'],
        );
        setState(() {
          ca636Data.add(emObject);
        });
      }
      return ca636Data;
    }else{
      //만약 응답이 ok가 아니면 에러를 던집니다.
      throw Exception('불러오는데 실패했습니다');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: GlobalStyle.appBarIconThemeColor,
        ),
        elevation: GlobalStyle.appBarElevation,
        title: Text(
          '이동현황',
          style: GlobalStyle.appBarTitle,
        ),
        backgroundColor: GlobalStyle.appBarBackgroundColor,
        systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,

      ),
      body:
      WillPopScope(
        onWillPop: (){
          Navigator.pop(context);
          return Future.value(true);
        },
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _etDate,
                    readOnly: true,
                    onTap: () {
                      _selectDateWithMinMaxDate(context);
                    },
                    maxLines: 1,
                    cursorColor: Colors.grey[600],
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding:  EdgeInsets.all(10),
                      suffixIcon: Icon(Icons.date_range, color: Colors.indigo),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[600]!),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[600]!),
                      ),
                      labelText: '이동일',
                      labelStyle: TextStyle(color: BLACK_GREY),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _etDate.text  ;
                    });
                    String ls_etdate = _etDate.text  ;
                    if(ls_etdate.length == 0){
                      print("일자를 입력하세요");
                      return;
                    }
                    ca636list_getdata();
                    print(_etDate.text );
                  },
                  child: Text(
                    '목록조회',
                    style: TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color(0xffcccccc),
                    width: 1.0,
                  ),
                ),
              ),
            ),
            Expanded(child: ListView.builder(itemCount: ca636Datas.length,
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index){
                return _buildListCard(ca636Datas[index]);
              },
            ))
          ],
        ),

      ),


    );

  }



  Widget _buildListCard(Ca636List_model ca636Data){
    return Card(
        margin: EdgeInsets.only(top: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        elevation: 2,
        color: Colors.white,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: (){
            //Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage11view(da035Data: da035Data)));
          },
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: (){
              showAlertDialog_MoveDelete(context, ca636Data.lotno, ca636Data.movdate, ca636Data.movnum, ca636Data.movseq);
              print(ca636Data);
              // Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage01_Subpage(ca636Data: ca636Data)));
            },
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ca636Data.movdate + "[" + ca636Data.movnum + "/" + ca636Data.movseq + "]", style: GlobalStyle.couponName),
                  Text(ca636Data.pname   , style: GlobalStyle.couponName),
                  Text('Lotno:' + ca636Data.lotno   , style: GlobalStyle.couponName),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GlobalStyle.iconTime,
                          SizedBox(
                            width: 4,
                          ),
                          Text(ca636Data.grade.toString() + "/"  + ca636Data.thick.toString()+ "/"  + ca636Data.width.toString() , style: GlobalStyle.couponName),
                        ],
                      ),
                      GestureDetector(
                        onTap: (){
                          print(ca636Data);
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage11Detail(ca636Data: ca636Data)));
                        },
                        child: Text( ca636Data.color, style: TextStyle(
                            fontSize: 14, color: SOFT_BLUE, fontWeight: FontWeight.bold
                        )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }


  void showAlertDialog_MoveDelete(BuildContext context, arg1, arg2, arg3, arg4) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ACTAS 이동삭제'),
          content: Text("Lotno : " + arg1  + " 정보를 삭제 하시겠습니까?"),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () async{
                Navigator.pop(context, "삭제");

                String _dbnm = await  SessionManager().get("dbnm");

                var uritxt = CLOUD_URL + '/kosep/list04del';
                var encoded = Uri.encodeFull(uritxt);
                Uri uri = Uri.parse(encoded);
                print(arg2);
                print(arg3);
                print(arg4);
                // print(_etIpStoreTxt.toString());
                // print( _etDate.toString());
                //  arrBarcode = 'R1022204247|R1022204248';
                final response = await http.post(
                  uri,
                  headers: <String, String> {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'Accept' : 'application/json'
                  },
                  body: <String, String> {
                    'dbnm': _dbnm,
                    'movdate': arg2,
                    'movnum' : arg3,
                    'movseq' : arg4
                  },
                );
                if(response.statusCode == 200){
                  try{
                    // var result =  jsonDecode(utf8.decode(response.bodyBytes))  ;
                    var result =  utf8.decode(response.bodyBytes);
                    if (result == "SUCCESS"){
                      showAlertDialog(context, "삭제되었습니다.");
                      ca636list_getdata();
                    }else{
                      showAlertDialog(context, result + " : 관리자에게 문의하세요");
                    }
                    return ;
                  }catch(e){
                    // print(e.toString());
                    showAlertDialog(context, e.toString() + " : 관리자에게 문의하세요");
                  }
                }else{
                  //만약 응답이 ok가 아니면 에러를 던집니다.
                  throw Exception('불러오는데 실패했습니다');
                }
              },
            ),
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.pop(context, "닫기");
              },
            ),
          ],
        );
      },
    );
  }


  void showAlertDialog(BuildContext context, String as_msg) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ACTAS 이동현황'),
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

  Future<Null> _selectDateWithMinMaxDate(BuildContext context) async {
    var firstDate = DateTime(initialDate.year, initialDate.month - 6, initialDate.day);
    var lastDate = DateTime(initialDate.year, initialDate.month, initialDate.day + 7);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.indigo,
            colorScheme: ColorScheme.light(primary: Colors.indigo, secondary: Colors.indigo),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;

        _etDate = TextEditingController(
            text: _selectedDate.toLocal().toString().split('-')[0]+_selectedDate.toLocal().toString().split('-')[1]+_selectedDate.toLocal().toString().split('-')[2].substring(0,2));
      });
    }
  }




}



