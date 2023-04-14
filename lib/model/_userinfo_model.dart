class Userinfo{
  late String userid;
  late String userpw;

  Userinfo({
    required this.userid,
    required this.userpw
  });

  factory Userinfo.fromJson(Map<String, dynamic> json) {
    return Userinfo(
      userid: json['userId'],
      userpw: json['userpw'],
    );
  }
}


