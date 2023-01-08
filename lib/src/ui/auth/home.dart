import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ta_ppb_flutter/src/network/api.dart';
import 'package:ta_ppb_flutter/src/ui/home/home_barang.dart';
import 'package:ta_ppb_flutter/src/ui/home/home_laporan.dart';
import 'package:ta_ppb_flutter/src/ui/home/home_profile.dart';
import 'package:ta_ppb_flutter/src/ui/home/home_transaksi.dart';
import 'dart:convert';
import 'login.dart';

class Home extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{
  String name='';
  @override
  void initState(){
    super.initState();
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xff151515),
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.power_settings_new, color: Colors.orange),
            onPressed: (){
              logout();
            },
          )
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        //physics:BouncingScrollPhysics(),
        childAspectRatio: 3/4,

        padding: EdgeInsets.all(10.0),
        children: <Widget>[
          GestureDetector(
            onTap: (){
              Navigator.pushReplacement(
                context,
                new MaterialPageRoute(
                    builder: (context) => HomeBarang()
                ),
              );

              },
            child: Container(
              padding: const EdgeInsets.all(16),

              child: Column(

                children: [
                  Icon(Icons.storage_outlined,size:150,color:Colors.white70,),
                  Text(
                      'Master',

                      style: Theme.of(context).textTheme.headline4,
                      textAlign: TextAlign.center)
                ],
              ),
            )
          ),
          GestureDetector(
              onTap: (){
                Navigator.pushReplacement(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => HomeTransaksi()
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),

                child: Column(

                  children: [
                    Icon(Icons.attach_money,size:150,color:Colors.white70,),
                    Text(
                        'Transaksi',
                        style: Theme.of(context).textTheme.headline4,
                        textAlign: TextAlign.center)
                  ],
                ),
              )
          ),
          GestureDetector(
              onTap: (){
                Navigator.pushReplacement(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => HomeLaporan()
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),

                child: Column(

                  children: [
                    Icon(Icons.document_scanner,size:150,color:Colors.white70,),
                    Text(
                        'Laporan',
                        style: Theme.of(context).textTheme.headline4,
                        textAlign: TextAlign.center)
                  ],
                ),
              )
          ),
          GestureDetector(
              onTap: (){
                Navigator.pushReplacement(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => HomeProfile()
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),

                child: Column(

                  children: [
                    Icon(Icons.account_circle,size:150,color:Colors.white70,),
                    Text(
                        'Tentang Saya',
                        style: Theme.of(context).textTheme.headline4,
                        textAlign: TextAlign.center)
                  ],
                ),
              )
          ),
        ],
      ),
    );
  }

  void logout() async{
    var res = await Network().getData('/logout');
    var body = json.decode(res.body);
    if(body['success']){
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('access_token');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context)=>Login()));
    }
  }
}