import 'dart:convert';

import 'package:actkosep/model/kosep/Da035List_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pointmobile_scanner/pointmobile_scanner.dart';
import '../../config/constant.dart';
import '../../config/global_style.dart';
import 'AppPage01.dart';

class AppPage05 extends StatefulWidget {
  const AppPage05({Key? key}) : super(key: key);

  @override
  State<AppPage05> createState() => _AppPage05State();
}

class _AppPage05State extends State<AppPage05> {

  String arrBarcode = "";
  final List<String> arrBarcodeText = <String>[];
  final List<int> colorCodes = <int>[500, 600, 100];
  String _dbnm = '';
  String _userid = '';
  String _username = '';
  int _totqty = 0;
  String _uamt = '';
  String _lsEtGrade = '';
  String _lsEtWidth = '';
  String _lsEtThick = '';
  String _lsEtColor = '';
  String _lsDeldate = '';
  String _lsDelnum = '';
  String _lsDelseq = '';
  String _lsDelcltcd = '';
  String _lsDelpcode = '';
  String _lsDeldatetext = '';
  String _perid = '';
  String _lsItemcd = '';
  String? _decodeResult = "Unknown";
  DateTime _selectedDate = DateTime.now(), initialDate = DateTime.now();

  TextEditingController _etDate = TextEditingController() ;
  TextEditingController _etBarcode = TextEditingController();

  @override
  void initState() {
    sessionData();
    super.initState();
    arrBarcode = "";
    arrBarcodeText.clear();
    PointmobileScanner.channel.setMethodCallHandler(_onBarcodeScannerHandler);
    PointmobileScanner.initScanner();
    PointmobileScanner.enableScanner();
    PointmobileScanner.enableBeep();
    PointmobileScanner.enableSymbology(PointmobileScanner.SYM_CODE128);
    PointmobileScanner.enableSymbology(PointmobileScanner.SYM_EAN13);
    PointmobileScanner.enableSymbology(PointmobileScanner.SYM_QR);
    PointmobileScanner.enableSymbology(PointmobileScanner.SYM_UPCA);

    // _etDate = TextEditingController(
    //     text: _selectedDate.toLocal().toString().split('-')[0]+_selectedDate.toLocal().toString().split('-')[1]+_selectedDate.toLocal().toString().split('-')[2].substring(0,2));

    _etDate.text = getToday();
    setState(() {
      _decodeResult = "Ready to decode";
    });
  }

  @override
  void dispose() {
    _etDate.dispose();
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
    // print(_perid);
  }



  Future da006list_getdata() async {
    String _dbnm = await  SessionManager().get("dbnm");

    var uritxt = CLOUD_URL + '/kosep/list02';
    var encoded = Uri.encodeFull(uritxt);
    Uri uri = Uri.parse(encoded);
    // print(arrBarcode);
    // print("_lsEtGrade=>" + _lsEtGrade);
    // print("_lsEtThick=>" + _lsEtThick);
    //  arrBarcode = 'R1022204247|R1022204248';
    _lsDeldate =  _etDate.text;
    _lsDelnum = "0000";
    print("_lsDeldate=>" + _lsDeldate);
    print("_lsDelnum=>" + _lsDelnum);
    final response = await http.post(
      uri,
      headers: <String, String> {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept' : 'application/json'
      },
      body: <String, String> {
        'dbnm': _dbnm,
        'itemcd': arrBarcode,
        'pcode': _lsDelpcode,
        'cltcd': _lsDelcltcd,
        'fdeldate': _lsDeldate,
        'fdelnum': _lsDelnum,
        'fdelseq': _lsDelseq,
        'grade': _lsEtGrade,
        'width': _lsEtWidth,
        'thick': _lsEtThick,
        'color': _lsEtColor,
        'qty'  : _totqty.toString(),
        'uamt'  : _uamt.toString(),
        'perid': _perid
      },
    );
    if(response.statusCode == 200){
      try{
        // var result =  jsonDecode(utf8.decode(response.bodyBytes))  ;
        var result =  utf8.decode(response.bodyBytes);
        if (result == "SUCCESS"){
          showAlertDialog(context, "등록되었습니다.");
          setState(() {
            arrBarcode = "";
            arrBarcodeText.clear();
            _etBarcode =TextEditingController(text: "");
          });
          // Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage01()));
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
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: GlobalStyle.appBarIconThemeColor,

        ),
        elevation: GlobalStyle.appBarElevation,
        title: Text('출고등록 LOT',
          style: GlobalStyle.appBarTitle,
        ),
        backgroundColor: GlobalStyle.appBarBackgroundColor,
        systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 1) _onExit();
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              const PopupMenuItem(child: Text('Exit'), value: 1),
            ],
          ),

        ],
      ),

        body:
        ListView(
          padding: EdgeInsets.all(16),
          children: [
          TextField(
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
                  labelText: '출고예정일',
                  labelStyle: TextStyle(color: BLACK_GREY),
                ),
              ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 100,
              child: TextField(
                controller: _etBarcode,
                readOnly: true,
                maxLines: 3,
                autofocus: true,
                onTap: (){
                  print(arrBarcode);
                  if(arrBarcode.length > 0){
                    showAlertDialog_Clear(context);
                  }
                },
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                        BorderSide(color: PRIMARY_COLOR, width: 2.0)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                    ),
                    hintText: "여기를 누르시면 리셋됩니다.",
                    hintStyle: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                    labelText: 'LOTNO :',
                    labelStyle:
                    TextStyle(color: Colors.redAccent)),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.178,
              margin: EdgeInsets.only(bottom: 10),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.black45),
                  onPressed: (){
                    setState(() {
                      if(arrBarcodeText.length == 0){
                        showAlertDialog(context, "등록할 lotno를 스캔하세요.");
                        return;
                      }
                      showAlertDialog_chulgoSave(context);
                    });
              }, child: Text('출고등록')),
            )

            // ListView.builder(
            //     padding: const EdgeInsets.all(8.0),
            //     itemCount: arrBarcode.length,
            //     itemBuilder: (BuildContext context2 , int icnt){
            //       return Container(
            //         height: 50,
            //         color: Colors.amber[colorCodes[icnt]],
            //         child: Center(child: Text('LotNo ${arrBarcode[icnt]}')),
            //       );
            //     })
          ],
        ),
    );

  }

  Future<void> _onBarcodeScannerHandler(MethodCall call) async {
    try {
      if (call.method == PointmobileScanner.ON_DECODE) {
        _onDecode(call);
      } else if (call.method == PointmobileScanner.ON_ERROR) {
        _onError(call.arguments);
      } else {
        print(call.arguments);
      }
    } catch(e) {
      print(e);
    }
  }

  void _onDecode(MethodCall call) {
    setState(() {
      final List lDecodeResult = call.arguments;
      _decodeResult = "Symbology: ${lDecodeResult[0]}\nValue: ${lDecodeResult[1]}";
      _lsItemcd = lDecodeResult[1];
    });
    if(_lsItemcd == 'READ_FAIL'){
      showAlertDialog(context, "바코드 스캔을 실패했습니다.");
    }else{

      for(var code in arrBarcodeText){
        if(code == _lsItemcd){
          showAlertDialog(context, "동일한 코드가 스캔되었습니다.");
          return ;
        }
      }
      //R1092205672
      // _lsItemcd = 'R1092205672';
      setState(() {
        arrBarcodeText.add(_lsItemcd);
      });
      // print(arrBarcodeText);
      // if(arrBarcodeText.length > _totqty){
      //   showAlertDialog(context, "출고수량을 초과했습니다.");
      //   return;
      // }
      String ls_arrcode = "";
      arrBarcode = "";
      for(var code in arrBarcodeText){
        if(ls_arrcode.length > 0){
          ls_arrcode = ls_arrcode + " * " + code;
        }else{
          ls_arrcode =  code;
        }
      }
      for(var code in arrBarcodeText){
        if(arrBarcode.length > 0){
          arrBarcode = arrBarcode + "|" + code;
        }else{
          arrBarcode =  code;
        }
      }
      _etBarcode = TextEditingController(text: ls_arrcode);
      // showAlertDialog_chulgoSave(context, _lsItemcd);
    }
  }

  void _onExit() {
    PointmobileScanner.disableScanner();
    // SystemNavigator.pop();
  }

  void _onError(Exception error) {
    setState(() {
      _decodeResult = error.toString();
    });
    print("_onError : " );
    print(_decodeResult );
  }


  void showAlertDialog_chulgoSave(BuildContext context) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ACTAS 출고등록'),
          content: Text("출고등록을 하시겠습니까?"),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () async{
                Navigator.pop(context, "저장");
                var result = await da006list_getdata();
                if(result){
                  setState(() {
                  });
                  // Navigator.pushReplacement(
                  //     context, MaterialPageRoute(builder: (context) =>
                  //     mpuchase(pernm: widget.pernm, perid: widget.perid, userid: widget.userid)
                  // ));
                  // print("저장성공!");
                }else{
                  showAlertDialog(context, "출고저장 중 오류가 ");
                  return ;
                }
                print("chulgo_save result=>" + result.toString());
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

  void showAlertDialog_Clear(BuildContext context) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ACTAS 출고등록'),
          content: Text("스캔한 LotNo를 리셋하시겠습니까?"),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () async{
                  setState(() {
                    arrBarcode = "";
                    arrBarcodeText.clear();
                    _etBarcode =TextEditingController(text: "");
                  });
                  Navigator.pop(context, "닫기");
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
          title: Text('ACTAS 출고등록'),
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
