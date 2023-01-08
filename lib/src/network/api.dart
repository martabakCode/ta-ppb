import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Network{
  final String _url = 'http://192.168.40.179:8000/api';
  var token;

  _getToken () async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = jsonDecode(localStorage.getString('access_token'));
  }

  auth(data, apiURL) async{
    var fullUrl = _url + apiURL;
    return await http.post(
        Uri.parse(fullUrl),
        body: jsonEncode(data),
        headers : _setHeaders()
    );
  }

  getData(apiURL) async{
    var fullUrl = _url + apiURL;
    await _getToken();
    return await http.get(
        Uri.parse(fullUrl),
        headers : _setHeaders()
    );
  }

  postData(data,apiURL) async{
    var fullUrl = _url + apiURL;
    await _getToken();
    return await http.post(
        Uri.parse(fullUrl),
        body: jsonEncode(data),
        headers : _setHeaders()
    );
  }

  putData(data,apiURL) async {
    var fullUrl = _url + apiURL;
    await _getToken();
    return await http.put(
        Uri.parse(fullUrl),
        body: data,
        headers: _setHeaders()
    );
  }

  deleteData(apiURL) async {
    var fullUrl = _url + apiURL;
    await _getToken();
    return await http.delete(
        Uri.parse(fullUrl),
        headers: _setHeaders()
    );
  }

  _setHeaders() => {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };

}