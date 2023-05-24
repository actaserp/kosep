import 'dart:ffi';

import 'package:flutter/cupertino.dart';

class ca609list_model{

  late var dbnm;
  //CA609
  late var custcd;
  late var spjangcd;
  late var baldate;
  late var balnum;
  late var balseq;
  late var pcode;
  late var moncls;
  late var monrate;
  late var qty;
  late var uamt;
  late var samt;
  late var tamt;
  late var mamt;
  late var remark;
  late var ibgflag;
  late var qcflag;
  late var qcqty;
  late var ibgqty;
  late var pumdate;
  late var pumnum;
  late var pumseq;
  late var pumdv;
  late var deldate;
  late var taxflag;
  late var projno;
  late var indate;
  late var inperid;
  late var actcd;
  late var divicd;
  late var psize;
  late var punit;
  late var actnm;
  late var orddate;
  late var ordnum;
  late var ordseq;
  late var compflag;
  late var buddate;
  late var budnum;
  late var budseq;
  late var budflag;
  late var size;
  late var code88;

  // CA608
  late var baldv;
  late var balno;
  late var pumdivicd;
  late var taxcls;
  late var setcls;
  late var store;
  late var domcls;
  late var sunflag;
  late var sunamt;
  late var ischdate;
  late var bigo;
  late var maildv;
  late var cdflag;
  late var taxgubun;
  late var ibgdate;
  late var ibgnum;
  late var compperid;
  late var compdivicd;
  late var compdate;
  late var state;
  late var hagigan;
  late var sogigan;
  late var balpernm;
  late var pumperid;
  late var title;

  // Lot
  late var cltcd;
  late var delnum;
  late var delseq;
  late var pname;
  late var coilqty;
  late var balqty;

  // CA501(B)
  late var lotno;
  late var cltnm;
  late var qcdate;
  late var wqty;

  late var wqcqty;
  late var comcd;
  late var wmqty;
  late var qcnum;
  late var qcdv;

  bool isChecked = true;

  TextEditingController? textEditingController = TextEditingController();



  ca609list_model({ this.dbnm, this.custcd, this.spjangcd, this.baldate, this.balnum, this.balseq, this.pcode, this.moncls, this.monrate, this.qty, this.uamt, this.samt, this.tamt, this.mamt,
    this.remark, this.ibgflag, this.qcflag, this.qcqty, this.ibgqty, this.pumdate, this.pumnum, this.pumseq, this.pumdv, this.deldate, this.taxflag, this.projno, this.qcdate, this.wqcqty,
    this.indate, this.inperid, this.actcd, this.divicd, this.psize, this.punit, this.actnm, this.orddate, this.ordnum, this.ordseq, this.compflag, this.buddate, this.comcd, this.wmqty,
    this.budnum, this.budseq, this.budflag, this.size, this.code88, this.baldv, this.balno, this.pumdivicd, this.taxcls, this.setcls, this.store, this.domcls, this.wqty,
    this.sunflag, this.sunamt, this.ischdate, this.bigo, this.maildv, this.cdflag, this.taxgubun, this.ibgdate, this.ibgnum, this.compperid, this.compdivicd, this.compdate,
    this.state, this.hagigan, this.sogigan, this.balpernm, this.pumperid, this.title, this.cltcd, this.delnum, this.delseq, this.pname, this.coilqty, this.lotno, this.balqty, this.cltnm, this.textEditingController,
    required this.isChecked, this.qcnum, this.qcdv

  });



}

List<ca609list_model> ca609Data =[];