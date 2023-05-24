
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:actkosep/model/themoon/padlist_model.dart';
import 'package:actkosep/ui/app02/App02List.dart';
import 'package:flutter/services.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:pointmobile_scanner/pointmobile_scanner.dart';
import 'package:actkosep/ui/app01/AppPage01_Subpage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../config/constant.dart';
import '../../config/global_style.dart';
import '../../model/themoon/ca609list_model.dart';

class App02Reg extends StatefulWidget {
  const App02Reg({Key? key}) : super(key: key);

  @override
  _App02RegState createState() => _App02RegState();
}

class _App02RegState extends State<App02Reg>   {

  String? _decodeResult = "Unknown";
  int _decodeCount = 0;
  List<String> _decodeResults = [];
  List<String> _decodePda = [];
  String result  = '';
  String resultset = '';

  TextEditingController _etDate = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  DateTime _selectedDate = DateTime.now(), initialDate = DateTime.now();
  List<padlist_model> padlist = padlists;
  String _dbnm = '';
  String _userid = '';
  String _username = '';
  String _perid = '';
  String _custcd = "";



  @override
  void initState() {
    sessionData();

    super.initState();
    _etDate.text = getToday();

    PointmobileScanner.channel.setMethodCallHandler(_onBarcodeScannerHandler);
    PointmobileScanner.initScanner();
    PointmobileScanner.enableScanner();
    PointmobileScanner.enableBeep();
    PointmobileScanner.enableSymbology(PointmobileScanner.SYM_CODE128);
    PointmobileScanner.enableSymbology(PointmobileScanner.SYM_EAN13);
    PointmobileScanner.enableSymbology(PointmobileScanner.SYM_QR);
    PointmobileScanner.enableSymbology(PointmobileScanner.SYM_UPCA);

    setState(() {
      _decodeResult = "Read to decode";
      _decodeCount = 0;
    });
  }

  @override
  void dispose() {
    _etDate.dispose();
    ca609Data.clear();
    padlists.clear();
    super.dispose();
  }

  String getToday(){
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyyMMdd');
    String formattedDate = formatter.format(now);
    return formattedDate;
  }
  Future<void> sessionData() async {
    _dbnm     = (await SessionManager().get("dbnm")).toString();
    _userid   = (await SessionManager().get("userid")).toString();
    _username = (await SessionManager().get("username")).toString();
    _perid    = (await SessionManager().get("perid")).toString();
    _custcd = (await SessionManager().get("custcd")).toString();
    print(_perid);
    print("임경현");
    print(_custcd);


  }




  Future PDAlist_getdata(String? decodeResult, int arg) async {
    String _dbnm = await  SessionManager().get("dbnm");

    var uritxt = CLOUD_URL + '/ca609/list01';
    var encoded = Uri.encodeFull(uritxt);

    Uri uri = Uri.parse(encoded);
    final response = await http.post(
      uri,
      headers: <String, String> {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept' : 'application/json'
      },
      body: <String, String> {
        'dbnm': "ERP_THEMOONN",
        'code88': decodeResult ?? '',
        'custcd': _custcd
      },
    );
    if(response.statusCode == 200){
      List<dynamic> alllist = [];
      alllist =  jsonDecode(utf8.decode(response.bodyBytes))  ;
      /*padlists.clear();
      */


      for (int i = 0; i < alllist.length; i++) {
        padlist_model emObject= padlist_model(
            phm_pcod: alllist[i]["pcode"],
            phm_pnam: alllist[i]["pname"],
            phm_size: alllist[i]["psize"],
            phm_unit: alllist[i]["punit"],
            Count:  arg,
            code88: alllist[i]["code88"]
        );

        String prefixToRemove = emObject.phm_pcod;
        print(prefixToRemove);

        bool isFirstMatched = true;
        padlists.removeWhere((element) {
          if (element.startsWith(prefixToRemove)) {

              // 두번째 이후로 매칭된 요소는 제거한다.
              return true;

          }
          return false;
        });

        /*if(padlists.contains(emObject.phm_pcod)){
          setState(() {
              padlists.
          });
        }*/

        setState(() {
          padlists.add(emObject);
          /*_decodePda.add(emObject.phm_pcod);
          */
        });

      }
      print("서버통신 성공");
      print(padlists[0]);
      print(padlists);
      return padlists;
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
          '수입검사등록',
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
                      labelText: '수입검사일',
                      labelStyle: TextStyle(color: BLACK_GREY),
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
            Expanded(child: ListView.builder(itemCount: /*ca609Datas.length*/   /*_decodeResults.length*/ padlists.length,
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index){
                return _buildListCard(/*ca609Datas[index]*/ padlists[index]);
              },
            ))
          ],
        ),

      ),
    );

  }

  Future<void> _onBarcodeScannerHandler(MethodCall call) async {
    try{
      if(call.method == PointmobileScanner.ON_DECODE) {
        setState(() {
          final List lDecodeResult = call.arguments;
           result = lDecodeResult[1];

        });

        int count = 0;

        _decodeResults.add(result);

        for(String value in _decodeResults){
          if(value == result){
            count ++;
          }
        }


        await PDAlist_getdata(result,count);
        print(count);
        print("수량체크");
        _onDecode(call);
        print(padlists.toString());



      } else if (call.method == PointmobileScanner.ON_ERROR){
        _onError(call.arguments);
      } else {
        print(call.arguments);
      }
    } catch(e) {
      print(e);
    }
  }



  void _onDecode(MethodCall call) async{

    setState(() {
      final List lDecodeResult = call.arguments;
      String result = "Symbology: ${lDecodeResult[0]}\nValue: ${lDecodeResult[1]}";

      /*String result1 = "${lDecodeResult[1]}";

      if(!_decodePda.contains(result1)){
        _decodePda.add(result1);
        print(_decodePda);
        print("object");
      }*/

      /*if(!_decodeResults.contains(result)){
        _decodeResults.add(result);
      }*/

      if(lDecodeResult.contains("READ_FAIL"))
      {
        _decodeCount;
      }
      else
      {
        _decodeCount++;
      }
      /*_decodeResult = "Symbology: ${lDecodeResult[0]}\nValue: ${lDecodeResult[1]}";
      */
      _decodeResult = "${lDecodeResult[1]}";
    });


  }

  void _onError(Exception error){
    setState(() {
        _decodeResult = error.toString();
    });
  }



  Widget _buildListCard(padlist_model padlistmodel /*String decodeResults*/){
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
            //Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage11view(ca609Data: da035Data)));
          },
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: (){

              print(padlistmodel);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => App02List(padlistmodel: padlistmodel)
                  )
              );
            },
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*Text(da035Data.cltnm, style: GlobalStyle.couponName),
                  Text(da035Data.grade, style: GlobalStyle.couponName),
                  Text(da035Data.thick+' ['+da035Data.width+'] '+da035Data.color, style: GlobalStyle.couponName),*/
                  Text("코드: " + padlistmodel.phm_pcod, style: GlobalStyle.couponName),
                  Text("품목명: " + padlistmodel.phm_pnam, style: GlobalStyle.couponName),
                  Text("규격: " + padlistmodel.phm_size, style: GlobalStyle.couponName),
                  Text("단위: " + padlistmodel.phm_unit, style: GlobalStyle.couponName),

                  Text("Code88: " + padlistmodel.code88, style: GlobalStyle.couponName),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GlobalStyle.iconTime,
                          SizedBox(
                            width: 4,
                          ),
                          Text(/*da035Data.pname*/"collapse" , style: GlobalStyle.couponName),
                        ],
                      ),
                      GestureDetector(

                        child: Text('수량 : ' + padlistmodel.Count.toString(), style: TextStyle(
                            fontSize: 14, color: SOFT_BLUE, fontWeight: FontWeight.bold
                        ),
                        ),
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



