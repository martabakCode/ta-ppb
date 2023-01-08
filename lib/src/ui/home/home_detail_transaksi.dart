import 'package:flutter/material.dart';
import 'package:ta_ppb_flutter/src/api/barang_api.dart';
import 'package:ta_ppb_flutter/src/api/transaksi_api.dart';
import 'package:ta_ppb_flutter/src/firebase/barang_fire.dart';
import 'package:ta_ppb_flutter/src/firebase/transaksi_fire.dart';
import 'package:ta_ppb_flutter/src/model/barang.dart';
import 'package:ta_ppb_flutter/src/model/transaksi.dart';
import 'package:ta_ppb_flutter/src/ui/home/home_transaksi.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class DetailTransaksi extends StatefulWidget {
  Barang product;

  DetailTransaksi({this.product});

  @override
  _DetailTransaksiState createState() => _DetailTransaksiState();
}
class _DetailTransaksiState extends State<DetailTransaksi> {
  bool _isLoading = false;
  BarangApi _apiService = BarangApi();
  BarangFire _apiBarangFirebaseService = BarangFire();
  TransaksiApi _apiTransaksiService = TransaksiApi();
  TransaksiFire _apiTransaksiFirebaseService = TransaksiFire();
  bool _isFieldJumlahValid;

  TextEditingController _controllerJumlah = TextEditingController();
  @override
  void initState() {
    if (widget.product != null) {
      _isFieldJumlahValid = true;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldState,
        appBar: AppBar(
          title: Text('Detail Barang'),
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.orange),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeTransaksi()),
            ),
          ),
        ),
        body: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                    Row(
                      mainAxisAlignment : MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Align(
                        alignment: Alignment.bottomCenter,
                        child:
                        Image.network(
                          "https://images.unsplash.com/photo-1504674900247-0877df9cc836?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1770&q=80",
                          height: 300,
                          width: 400,
                          fit: BoxFit.fill,
                        ),
                        )
                  ]),
                  SizedBox(height: 10),
                  Text(
                    "Nama: ${widget.product.nama}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Harga : ${widget.product.harga}",
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Stok  : ${widget.product.jumlah} ${widget.product.satuan}",
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Terjual : ${widget.product.terjual} ${widget.product.satuan}",
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 10),
                  _buildTextFieldJumlah(),
                  SizedBox(height: 5),
                  ElevatedButton(
                    child: Text(
                      "Pesan",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      if (_isFieldJumlahValid == null ||
                          !_isFieldJumlahValid) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Please fill all field"),
                          ),
                        );
                        return;
                      }
                      setState(() => _isLoading = true);
                      int jumlah = int.parse(_controllerJumlah.text.toString());
                      Barang barang = Barang(id: widget.product.id,nama: widget.product.nama, satuan: widget.product.satuan, harga: widget.product.harga, jumlah: widget.product.jumlah, terjual: widget.product.terjual+jumlah);
                      Transaksi transaksi = Transaksi(barang_id: widget.product.id, nama: "Coba", total: jumlah);
                      _apiService.updateBarangTerjual(barang).then((isSuccess) async {
                        setState(() => _isLoading = false);
                        if (isSuccess) {
                          await _apiBarangFirebaseService.updateBarang(
                              nama: barang.nama,
                              satuan: barang.satuan,
                              harga: barang.harga,
                              jumlah: barang.jumlah,
                              terjual: barang.terjual,
                              id: widget.product.id.toString()
                          );
                          _apiTransaksiService.createTransaksi(transaksi).then((isSuccess) async {
                            setState(() => _isLoading = false);
                            if (!isSuccess.toString().isEmpty) {
                              await _apiTransaksiFirebaseService.addTransaksi(
                                  nama: barang.nama,
                                  barang_id: barang.id,
                                  total: jumlah,
                                  id: barang.id.toString()
                              );
                              Navigator.pop(_scaffoldState.currentState.context, true);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Create data tansaksi failed"),
                              ));
                            }
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Update data terjual failed"),
                          ));
                        }
                      });


                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      minimumSize: const Size.fromHeight(20),
                      padding: EdgeInsets.all(10),
                      shape: new RoundedRectangleBorder(
                          borderRadius:
                          new BorderRadius.circular(20.0)),
                    ),
                  ),
        ])));
  }
  Widget _buildTextFieldJumlah() {
    return TextField(
      controller: _controllerJumlah,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Jumlah di pesan",
        errorText: _isFieldJumlahValid == null || _isFieldJumlahValid
            ? null
            : "Jumlah is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldJumlahValid) {
          setState(() => _isFieldJumlahValid = isFieldValid);
        }
      },
    );
  }
}