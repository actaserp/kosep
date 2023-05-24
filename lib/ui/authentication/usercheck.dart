import 'dart:convert';
import 'package:actkosep/config/constant.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

Future<Map<String, dynamic>> Usercheck(String userid, String userpw) async{
  Map<String, dynamic> userinfo = {};
  var uritxt = CLOUD_URL + '/authm/loginmchk';
  var encoded = Uri.encodeFull(uritxt);

  Uri uri = Uri.parse(encoded);
  //'Content-Type': 'application/x-www-form-urlencoded',
  final response = await http.post(
    uri,
    headers: <String, String> {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept' : 'application/json'
    },
    body: <String, String> {
      'userid': userid,
      'userpw': userpw,
      'dbnm': 'ERP_THEMOONN'
    },
  );
  if(response.statusCode == 200){
    userinfo = jsonDecode(response.body);
    // await SessionManager().set('userinfo', userinfo);
    // userinfo u = userinfo.fromJson(await SessionManager().get("saupnum"));
    // print(userinfo);
    await SessionManager().set("userid", userinfo['userid']);
    await SessionManager().set("username", userinfo['username']);
    // await SessionManager().set("useyn", userinfo['useyn']);
    //await SessionManager().set("saupnum", userinfo['saupnum']);
    //await SessionManager().set("phone", userinfo['phone']);
    //await SessionManager().set("actcd", userinfo['actcd']);
    // await SessionManager().set("cltcd", userinfo['cltcd']);
    // await SessionManager().set("flag", userinfo['flag']);
    await SessionManager().set("dbnm", userinfo['dbnm']);
    await SessionManager().set("perid", userinfo['perid']);
    await SessionManager().set("pernm", userinfo['pernm']);
    await SessionManager().set("custcd", userinfo['custcd']);
    // dynamic user_saupnum = await SessionManager().get("saupnum");

    //Update session
    //  await SessionManager().update();
    //Delete session and all data in it
    //  await SessionManager().destroy();
    //Remove a specific item
    //  await SessionManager().remove("id");
    //Verify wether or not a key exists
    //  await SessionManager().containsKey("id"); // true or false

    save_log();
  }else{
    // throw Exception('Failed to load data');
  }
  // print(userinfo.length);
  return userinfo;
}

Future<bool> save_log() async
{

  String ipAddress  = '';
    for (var interface in await NetworkInterface.list()) {
      print('== Interface: ${interface.name} ==');
      for (var address in interface.addresses) {
        print(
            '${address.address} ');
        ipAddress = address.address;

      }
    }

  String _custcd = '';
  String _userid = '';
  String _username = '';

 /*var ipAddress = IpAddress(type: RequestType.json);
  dynamic data = await ipAddress.getIpAddress();
  String ipAddressString = data["ip"];*/




  _userid = (await SessionManager().get("userid")).toString();
  _custcd = (await SessionManager().get("custcd")).toString();
  String username = (await SessionManager().get("username")).toString();
  _username = utf8.decode(username.runes.toList());


  var uritxt = CLOUD_URL + '/themoon/loginlog';
  var encoded = Uri.encodeFull(uritxt);
  Uri uri = Uri.parse(encoded);

  final response = await http.post(
    uri,
    headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept' : 'application/json'
    },
    body: <String, String>{
      'custcd' : _custcd,
      'userid' : _userid,

/*'ipaddr' : ipAddressString,*/

      'ipaddr' : ipAddress,
      'usernm' : _username
    },
  );
  if(response.statusCode == 200){
    return true;
  }else{
    throw Exception('에러발생!');
  }

}






