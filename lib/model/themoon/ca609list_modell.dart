import 'dart:ffi';

import 'package:flutter/cupertino.dart';

class ca609list_modell{

  late var ischdate;
  late var qcqty;
  late var cltcd;
  late var cltnm;
  late var pcode;
  late var pname;
  late var psize;
  late var punit;
  late var baldate;
  late var balnum;
  late var balseq;
  late var store;
  late var comcd;
  late var wmqty;
  late var qcflag;
  late var ibgflag;
  late var divicd;
  late var qty;
  late var qcdv;
  bool isChecked = true;
  TextEditingController? textEditingController = TextEditingController();


  ca609list_modell({
    this.qcqty,
    this.pcode,
    this.pname,
    this.psize,
    this.punit,
    this.baldate,
    this.balnum,
    this.balseq,
    this.store,
    this.comcd,
    this.wmqty,
    this.qcflag,
    this.ibgflag,
    this.divicd,
    this.qty,
    this.qcdv,
    this.ischdate,
    this.cltnm,
    this.cltcd,
    this.textEditingController,
    required this.isChecked,
  });

  bool startsWith(String prefix){
    return cltnm.toString().startsWith(prefix);
  }




}

List<ca609list_modell> ca609datal =[];