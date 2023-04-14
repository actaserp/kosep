
import 'dart:convert';

import 'package:actkosep/ui/app01/AppPage01_Subpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../config/constant.dart';
import '../../config/global_style.dart';
import '../../model/kosep/Da035List_model.dart';

class AppPage03 extends StatefulWidget {
  const AppPage03({Key? key}) : super(key: key);

  @override
  _AppPage03State createState() => _AppPage03State();
}

class _AppPage03State extends State<AppPage03>   {

  TextEditingController _etDate = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  DateTime _selectedDate = DateTime.now(), initialDate = DateTime.now();
  List<Da035List_model> da035Datas = da035Data;
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
    da035Data.clear();
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


  Future da035list_getdata() async {
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
      da035Data.clear();
      for (int i = 0; i < alllist.length; i++) {
        Da035List_model emObject= Da035List_model(
            custcd:alllist[i]['custcd'],
            spjangcd:alllist[i]['spjangcd'],
            deldate:alllist[i]['deldate'],
            fdeldatetext:alllist[i]['fdeldatetext'],
            delnum:alllist[i]['delnum'],
            delseq:alllist[i]['delseq'],
            cltcd:alllist[i]['cltcd'],
            cltnm:alllist[i]['cltnm'],
            pcode:alllist[i]['pcode'],
            pname:alllist[i]['pname'],
            psize:alllist[i]['psize'],
            qty:alllist[i]['qty'],
            uamt:alllist[i]['uamt'],
            samt:alllist[i]['samt'],
        );
        setState(() {
          da035Data.add(emObject);
        });

      }
      return da035Data;
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
          '출고현황',
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
                      labelText: '출고일',
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
                    da035list_getdata();
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
            Expanded(child: ListView.builder(itemCount: da035Datas.length,
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index){
                return _buildListCard(da035Datas[index]);
              },
            ))
          ],
        ),

      ),


    );

  }



  Widget _buildListCard(Da035List_model da035Data){
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
              // showAlertDialog_chulgoDelete(context, da035Data.lotno, da035Data.deldate, da035Data.delnum, da035Data.delseq);
              print(da035Data);
              // Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage01_Subpage(da035Data: da035Data)));
            },
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(da035Data.fdeldatetext + '[' + da035Data.delnum + '/' + da035Data.delseq + ']', style: GlobalStyle.couponName),
                  Text(da035Data.pname  +' ['+da035Data.psize+'] ' , style: GlobalStyle.couponName),
                  Text('수량:' + da035Data.qty.toString()   , style: GlobalStyle.couponName),
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
                          Text('단가/금액:' + da035Data.uamt.toString() + ' / '  + da035Data.samt.toString() , style: GlobalStyle.couponName),
                        ],
                      ),
                      GestureDetector(
                        onTap: (){
                          print(da035Data);
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage11Detail(da035Data: da035Data)));
                        },
                        child: Text( da035Data.cltnm, style: TextStyle(
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




  Future<Null> _selectDateWithMinMaxDate(BuildContext context) async {
    var firstDate = DateTime(initialDate.year, initialDate.month - 3, initialDate.day);
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



