import 'package:flutter/material.dart';
import 'package:ta_ppb_flutter/src/api/barang_api.dart';
import 'package:ta_ppb_flutter/src/api/profile_api.dart';
import 'package:ta_ppb_flutter/src/firebase/barang_fire.dart';
import 'package:ta_ppb_flutter/src/helper/currencyFormat.dart';
import 'package:ta_ppb_flutter/src/model/barang.dart';
import 'package:ta_ppb_flutter/src/model/barang.dart';
import 'package:ta_ppb_flutter/src/ui/auth/home.dart';
import 'package:ta_ppb_flutter/src/ui/formadd/form_add_barang.dart';
import 'package:ta_ppb_flutter/src/ui/formadd/form_add_profile.dart';
import 'package:intl/intl.dart';

final oCcy = new NumberFormat("#,##0.00", "en_US");

class HomeLaporan extends StatefulWidget {
  @override
  _HomeLaporanState createState() => _HomeLaporanState();
}

class _HomeLaporanState extends State<HomeLaporan> {
  BuildContext context;
  BarangApi apiService;
  BarangFire firebaseService;
  final globalKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    apiService = BarangApi();
    firebaseService = BarangFire();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
        backgroundColor: Color(0xff151515),
        appBar: AppBar(
          title: Text('Barang'),
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.orange),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            ),
          ),
        ),
        body: SafeArea(
          child: FutureBuilder(
            future: apiService.getBarangs(),

            builder:
                (BuildContext context, AsyncSnapshot<List<Barang>> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                      "Something wrong with message: ${snapshot.error.toString()}"),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                List<Barang> barangs = snapshot.data;
                barangs.insert(0,Barang(id: 0,nama: "Nama", satuan: "Satuan", harga: 0, jumlah: 0, terjual: 0));
                return _buildListView(barangs);
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ));
  }

  Widget _buildListView(List<Barang> barangs) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Table(
        children:
          List<TableRow>.generate(
          barangs.length,
              (index) {
            final barang = barangs[index];
              return TableRow(
                children: [
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                        barang.id.toString(), textAlign: TextAlign.center),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(barang.nama, textAlign: TextAlign.center),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(barang.satuan, textAlign: TextAlign.center),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                        barang.harga.toString(), textAlign: TextAlign.center),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                        barang.jumlah.toString(), textAlign: TextAlign.center),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                        barang.terjual.toString(), textAlign: TextAlign.center),
                  ),
                ],
              );
          },
          growable: false,
        ),

      ),
    );
  }
}
