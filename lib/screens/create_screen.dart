import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:money_tracker/db/database_helper.dart';
import 'package:money_tracker/models/transaksi_model.dart';
import 'package:money_tracker/shared/theme.dart';

class CreateScreen extends StatefulWidget {
  final Transaksi? initialTransaksi;

  const CreateScreen({Key? key, this.initialTransaksi}) : super(key: key);

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  late TextEditingController _nameController;
  late TextEditingController _totalController;
  int _value = 1;

  @override
  void initState() {
    _nameController =
        TextEditingController(text: widget.initialTransaksi?.name ?? '');
    _totalController = TextEditingController(
        text: widget.initialTransaksi?.total.toString() ?? '');
    _value = widget.initialTransaksi?.type ?? 1;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.grey[300],
        iconTheme: IconThemeData(
          color: blackColor,
        ),
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.initialTransaksi != null
              ? 'Update Transaksi'
              : 'Tambah Transaksi',
          style: blackTextStyle.copyWith(
            fontSize: 20,
            fontWeight: semiBold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 35),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            padding: EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey[300],
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade500,
                    offset: Offset(4.0, 4.0),
                    blurRadius: 15.0,
                    spreadRadius: 1.0),
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(-4.0, -4.0),
                  blurRadius: 15.0,
                  spreadRadius: 1.0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nama Transaksi',
                  style: blackTextStyle.copyWith(
                    fontWeight: medium,
                  ),
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
                DView.height(20),
                Text(
                  'Total Transaksi',
                  style: blackTextStyle.copyWith(
                    fontWeight: medium,
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _totalController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
                DView.height(20),
                Text("Tipe Transaksi"),
                ListTile(
                  title: Text("Pemasukan"),
                  leading: Radio(
                      groupValue: _value,
                      value: 1,
                      onChanged: (value) {
                        setState(() {
                          _value = value as int;
                        });
                      }),
                ),
                ListTile(
                  title: Text("Pengeluaran"),
                  leading: Radio(
                      groupValue: _value,
                      value: 2,
                      onChanged: (value) {
                        setState(() {
                          _value = value as int;
                        });
                      }),
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: TextButton(
                    onPressed: () async {
                      // Validasi formulir
                      if (_nameController.text.isEmpty ||
                          _totalController.text.isEmpty) {
                        // Formulir masih kosong, tampilkan pesan atau berikan respons
                        print("Formulir masih kosong");
                      } else {
                        // Formulir tidak kosong, lanjutkan dengan menyimpan data
                        int total = int.tryParse(_totalController.text) ?? 0;
                        Transaksi transaksi = Transaksi(
                          name: _nameController.text,
                          type: _value,
                          total: total,
                          createdAt: DateTime.now().toString(),
                          updatedAt: DateTime.now().toString(),
                        );

                        if (widget.initialTransaksi != null) {
                          transaksi.id = widget.initialTransaksi!.id;
                          await DatabaseHelper.instance
                              .updateTransaksi(transaksi);
                        } else {
                          await DatabaseHelper.instance
                              .insertTransaksi(transaksi);
                        }

                        print("Sudah masuk: $transaksi");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.grey[500],
                            content: widget.initialTransaksi != null
                                ? Text('Data terupdate')
                                : Text('Data tersimpan'),
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[500],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(56),
                      ),
                    ),
                    child: Text(
                      'Simpan',
                      style: whiteTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: semiBold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
