
import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:pointmobile_scanner/pointmobile_scanner.dart';

import '../../config/constant.dart';
import '../../config/colors.gen.dart';
import '../../config/global_style.dart';
import '../../model/kosep/Da035List_model.dart';
import '../../model/kosep/StoreList_model.dart';

import 'AppPage01.dart';
import 'AppPage04.dart';

class AppPage03 extends StatefulWidget {


  const AppPage03({Key? key}) : super(key: key);
  @override
  _AppPage03State createState() => _AppPage03State();
}

class _AppPage03State extends State<AppPage03>   {

  TextEditingController _etDate = TextEditingController();
  TextEditingController _etBarcode = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  DateTime _selectedDate = DateTime.now(), initialDate = DateTime.now();
  final List<String> arrBarcodeText = <String>[];
  List<StoreList_model> storeDatas = storeData;
  final List<String> _eIpStoreData = [];
  final List<String> _eChulStoreData = [];
  String _lsItemcd = '';
  String? _decodeResult = "Unknown";
  String _dbnm = '';
  String _userid = '';
  String _username = '';
  String _perid = '';
  String? _etChulStoreTxt;
  String? _etIpStoreTxt;
  String arrBarcode = "";
  static const _itemsLength = 20;

  var movelist_card;
  List<String> productList_Reg = []; // 입고등록할 목록
  var productList = [];
  int ipgolist_size = 0;
  late final List<Color> colors_m;

  @override
  void initState() {
    sessionData();
    super.initState();
    _etDate.text = getToday();
    StoreChullist_getdata();
    StoreIplist_getdata();

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

    setState(() {
      _decodeResult = "Ready to decode";
    });

    // colors_m = getRandomColors(_itemsLength);

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
  }


  Future StoreChullist_getdata() async {
    String _dbnm = await  SessionManager().get("dbnm");

      var uritxt = CLOUD_URL + '/kosep/list03chulstore';
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
        },
      );
      if(response.statusCode == 200){
        List<dynamic> alllist = [];
        alllist =  jsonDecode(utf8.decode(response.bodyBytes))  ;
        _eChulStoreData.clear();
        for (int i = 0; i < alllist.length; i++) {
          StoreList_model emObject= StoreList_model(
            com_code:alllist[i]['com_code'],
            com_cnam:alllist[i]['com_cnam'],
          );
          setState(() {
            storeData.add(emObject);
            _eChulStoreData.add(alllist[i]['com_cnam']);
          });
        }

      return storeData;
    }else{
      //만약 응답이 ok가 아니면 에러를 던집니다.
      throw Exception('불러오는데 실패했습니다');
    }
  }

  Future StoreIplist_getdata() async {
    String _dbnm = await  SessionManager().get("dbnm");

    var uritxt = CLOUD_URL + '/kosep/list03ipstore';
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
      },
    );
    if(response.statusCode == 200){
        List<dynamic> alllist = [];
        alllist =  jsonDecode(utf8.decode(response.bodyBytes))  ;
        _eIpStoreData.clear();
        for (int i = 0; i < alllist.length; i++) {
          StoreList_model emObject= StoreList_model(
            com_code:alllist[i]['com_code'],
            com_cnam:alllist[i]['com_cnam'],
          );
          setState(() {
            storeData.add(emObject);
            _eIpStoreData.add(alllist[i]['com_cnam'] + "[" + alllist[i]['com_code'] + "]");
          });
        }
        return storeData;
      }else{
        //만약 응답이 ok가 아니면 에러를 던집니다.
        throw Exception('불러오는데 실패했습니다');
      }
  }


  Future Jpum_getdata(argcode) async {
    String _dbnm = await  SessionManager().get("dbnm");

    var uritxt = CLOUD_URL + '/kosep/list03Pcode';
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
        'barcode' : argcode,
        'store' : _etChulStoreTxt.toString(),
      },
    );
    String ls_arrcode = "";
    if(response.statusCode == 200){
      List<dynamic> alllist = [];
      alllist =  jsonDecode(utf8.decode(response.bodyBytes))  ;

      if (alllist.length == 0){
        arrBarcodeText.remove(_lsItemcd);
        _etBarcode.clear();
        for(var code in arrBarcodeText){
          if(ls_arrcode.length > 0){
            ls_arrcode = ls_arrcode + " * " + code;
          }else{
            ls_arrcode =  code;
          }
        }
        _etBarcode.text = ls_arrcode;
        showAlertDialog(context, "창고와 바코드가 일치하는 정보가 없습니다.");
        return "ERROR";
      }else{
        var ipgolist = alllist;
        setState(() {
          productList.add(ipgolist);
          productList_Reg.add(argcode);
          // ipgolist_size = movelist_card.length;
        });
        // print(productList[0][0]['pcode'].toString());
        // print(productList[1][0]['pcode'].toString());
        return "SUCCESS";
      }

    }else{
      //만약 응답이 ok가 아니면 에러를 던집니다.
      throw Exception('불러오는데 실패했습니다');
    }
    return true;
  }

  Future da006list_getdata() async {
    String _dbnm = await  SessionManager().get("dbnm");

    var uritxt = CLOUD_URL + '/kosep/list03save';
    var encoded = Uri.encodeFull(uritxt);
    Uri uri = Uri.parse(encoded);
    if(_etChulStoreTxt == null){
      showAlertDialog(context, "출고창고를 선택하세요.");
      return false;
    }
    if(_etIpStoreTxt == null){
      showAlertDialog(context, "입고창고를 선택하세요.");
      return  false;
    }
    if(arrBarcode == null){
      showAlertDialog(context, "바코드를 스캔하세요.");
      return  false;
    }
    // print(arrBarcode);
    // print( _etChulStoreTxt.toString());
    // print(_etIpStoreTxt.toString());
    // print( _etDate.toString());
    //  arrBarcode = 'R1022204247|R1022204248';
    var ls_movdate = _etDate.text;
    var ls_ipstore = [] ;
    ls_ipstore = _etIpStoreTxt.toString().split("[");
    var ls_iptxt = ls_ipstore[1].substring(0,2);
    print(ls_movdate);
    final response = await http.post(
      uri,
      headers: <String, String> {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept' : 'application/json'
      },
      body: <String, String> {
        'dbnm': _dbnm,
        'itemcd': arrBarcode,
        'chulstore' : _etChulStoreTxt.toString(),
        'ipstore' : ls_iptxt,
        'movedate' : ls_movdate,
        'perid': _perid
      },
    );
    if(response.statusCode == 200){
      try{
        // var result =  jsonDecode(utf8.decode(response.bodyBytes))  ;
        var result =  utf8.decode(response.bodyBytes);
        if (result == "SUCCESS"){
          showAlertDialog(context, "등록되었습니다.");
          Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage04()));
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
        title: Text(
          '창고이동',
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
              ],
            ),
            Row(
              children: [
                Container(
                  width: 320,
                  margin: EdgeInsets.only(top: 10, left:10),
                  child: Text('출고창고(*)'),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 320,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child:
                  Card(
                    color: Colors.blue[800],
                    elevation: 5,
                    child:
                    Container(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          icon: Icon(Icons.keyboard_arrow_down),
                          dropdownColor: Colors.blue[800],
                          iconEnabledColor: Colors.white,
                          hint: Text("출고창고", style: TextStyle(color: Colors.white)),
                          value:  this._etChulStoreTxt != null? this._etChulStoreTxt :null ,
                          items: _eChulStoreData.map((item) {
                            return DropdownMenuItem<String>(
                              child: Text(item, style: TextStyle(color: Colors.white)),
                              value: item,
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              this._etChulStoreTxt = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 320,
                  margin: EdgeInsets.only(top: 10, left:10),
                  child: Text('입고창고(*)'),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 320,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child:
                  Card(
                    color: Colors.blue[800],
                    elevation: 5,
                    child:
                    Container(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          icon: Icon(Icons.keyboard_arrow_down),
                          dropdownColor: Colors.blue[800],
                          iconEnabledColor: Colors.white,
                          hint: Text("입고창고", style: TextStyle(color: Colors.white)),
                          value:  this._etIpStoreTxt != null? this._etIpStoreTxt :null ,
                          items: _eIpStoreData.map((item) {
                            return DropdownMenuItem<String>(
                              child: Text(item, style: TextStyle(color: Colors.white)),
                              value: item,
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              this._etIpStoreTxt = value;
                              /*widget.e401receData.contcd = value;*/

                            });

                          },
                        ),
                      ),
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
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only( left: 10),
                  child:  SizedBox(
                    width: 320,
                    child: TextField(
                      controller: _etBarcode,
                      readOnly: true,
                      maxLines: 2,
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
                )

              ],
            ),
            Row(
              children: [
                Container(
                  width: 320,
                  margin: EdgeInsets.only(top: 10, left: 10),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.black45),
                      onPressed: (){
                        setState(() {
                          if(arrBarcodeText.length == 0){
                            showAlertDialog(context, "이동할 lotno를 스캔하세요.");
                            return;
                          }
                          showAlertDialog_movegoSave(context);
                        });
                      }, child: Text('이동등록')),
                )
              ],
            ),
            // SizedBox(
            //   height: 10,
            // ),

            SizedBox(
              // size: Size.square(600),
              //   height: 400,  //800
              //   width: 600,
                child :
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  // color: Colors.amber,
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.all(20),
                      itemCount: productList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SafeArea(
                            top: false,
                            bottom: false,
                            child: GestureDetector(
                                onTap: () {
                                  // _ls_balkey = movelist_card[index]['balkey'].toString();
                                  // favoriteSet(_ls_balkey!, movelist_card[index]);
                                },
                                child: Stack(children: [
                                  Card(
                                    elevation: 1.5,
                                    margin: const EdgeInsets.fromLTRB(
                                        6, 12, 6, 0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(4),
                                    ),
                                    child: GestureDetector(
                                      // onTap: () {
                                      //   print("입고등록 선택");
                                      // },
                                        child: Stack(children: [
                                          Padding(
                                            padding:
                                            const EdgeInsets.all(5.0),
                                            child: Row(
                                              crossAxisAlignment:  CrossAxisAlignment.start,
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor:
                                                  Colors.blue,
                                                  child: Text(
                                                    productList[index][0]['itemcd'] != null
                                                        ? index.toString()
                                                        : "",
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 16)),
                                                Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Text(
                                                          productList[index][0]['color'],
                                                          style: const TextStyle(

                                                            fontWeight:
                                                            FontWeight.w500,
                                                          ),
                                                        ),
                                                        const Padding(
                                                            padding:
                                                            EdgeInsets.only(
                                                                top: 8)),
                                                        Text(
                                                          productList[index][0]['grade']  ,
                                                          style: const TextStyle(
                                                            fontWeight:
                                                            FontWeight.w500,
                                                          ),
                                                        ),
                                                        Text(
                                                          productList[index][0]['thick'],
                                                          style: const TextStyle(

                                                            fontWeight:
                                                            FontWeight.w500,
                                                          ),

                                                        ),
                                                      ],
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ])),
                                  )
                                ])));
                      }),
                )
            )



          ],
        ),

      ),


    );

  }



  int RandomNum(){
    Random rnd;
    int r ;
    int min = 1;
    int max = 19;
    rnd = new Random();
    r = min + rnd.nextInt(max - min);
    // print("$r is in the range of $min and $max");

    return r;
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
                  productList.clear();
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

      //R1092205672
      // _lsItemcd = 'R1022300259'; // 'R1022301024';
      // _lsItemcd = 'R1022301024';
      // _lsItemcd = 'R1022300259';
      for(var code in arrBarcodeText){
        if(code == _lsItemcd){
          showAlertDialog(context, "동일한 코드가 스캔되었습니다.");
          return ;
        }
      }
      setState(() {
        arrBarcodeText.add(_lsItemcd);
      });
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

      if (Jpum_getdata(_lsItemcd).toString() == "ERROR"){
        return ;
      }else{
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


  void showAlertDialog_movegoSave(BuildContext context) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ACTAS 재고이동'),
          content: Text("재고이동을 하시겠습니까?"),
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
                  showAlertDialog(context, "재고이동 중 오류 ");
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

  void showAlertDialog(BuildContext context, String as_msg) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ACTAS 재고이동'),
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



