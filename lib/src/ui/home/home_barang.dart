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

class HomeBarang extends StatefulWidget {
  @override
  _HomeBarangState createState() => _HomeBarangState();
}

class _HomeBarangState extends State<HomeBarang> {
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
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add, color: Colors.orange),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FormAddBarang()),
              ),
            ),
          ],
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
      child: ListView.builder(
        itemBuilder: (context, index) {
          Barang barang = barangs[index];
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    title: Text(
                      barang.nama,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  Image.network(
                    "https://images.unsplash.com/photo-1504674900247-0877df9cc836?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1770&q=80",
                  ),
                  Container(
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.all(16.0),
                    child: new Column(
                      children: <Widget>[
                        Text(
                          "Stok :" +
                              barang.jumlah.toString() +
                              " " +
                              barang.satuan,
                        ),
                        Text(CurrencyFormat.convertToIdr(barang.harga, 2)),
                        Text("Terjual : " +
                            barang.terjual.toString() +
                            " " +
                            barang.satuan),
                      ],
                    ),
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.end,
                    children: <Widget>[
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Warning"),
                                  content: Text(
                                      "Are you sure want to delete data barang ${barang.nama}?"),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      child: Text("Yes"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        firebaseService.deleteBarang(barang.id.toString());
                                        apiService
                                            .deleteBarang(barang)
                                            .then((isSuccess) {
                                          if (isSuccess) {
                                            setState(() {});
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content:
                                                  Text("Delete data success"),
                                            ));
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content:
                                                  Text("Delete data failed"),
                                            ));
                                          }
                                        });
                                      },
                                    ),
                                    ElevatedButton(
                                      child: Text("No"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                );
                              });
                        },
                        child: Text(
                          "Delete",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                      SizedBox(width: 5),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.orange),
                        ),
                        onPressed: () async {
                          var result = await Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return FormAddBarang(barang: barang);
                          }));
                          if (result != null) {
                            setState(() {});
                          }
                        },
                        child: Text(
                          "Edit",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: barangs.length,
      ),
    );
  }
}
