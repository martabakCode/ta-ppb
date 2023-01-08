
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ta_ppb_flutter/src/model/barang.dart';
import 'package:http/http.dart' show Client;
import 'package:ta_ppb_flutter/src/network/api.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('ta_ppb');

class BarangApi {


  Future<List<Barang>> getBarangs() async {
    var response = await Network().getData('/barang');
    if (response.statusCode == 200) {
      return barangFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<List<Barang>> createBarang(Barang data) async {
    var response = await Network().postData(data,'/barang');
    if (response.statusCode == 200) {
      return barangFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<bool> updateBarang(Barang data) async {
    var response = await Network().putData(barangToJson(data),'/barang/${data.id}');
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteBarang(Barang data) async {
    var response = await Network().deleteData('/barang/${data.id}');
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateBarangTerjual(Barang data) async {
    var response = await Network().putData(barangToJson(data),'/barang/${data.id}');
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
