import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:money_tracker/db/database_helper.dart';
import 'package:money_tracker/models/user_model.dart';
import 'package:money_tracker/shared/theme.dart';

class ProfileScreen extends StatefulWidget {
  final User? initialUser;

  ProfileScreen({Key? key, this.initialUser}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;

  @override
  void initState() {
    _nameController =
        TextEditingController(text: widget.initialUser?.name ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: widget.initialUser != null
          ? AppBar(
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
                'Edit Profil',
                style: blackTextStyle.copyWith(
                  fontSize: 20,
                  fontWeight: semiBold,
                ),
              ),
            )
          :
          //  kalo kosong (tambah profile)
          AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.grey[300],
              iconTheme: IconThemeData(
                color: blackColor,
              ),
              elevation: 0,
              centerTitle: true,
              title: Text(
                'Isi Nama Dulu Ya',
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
                  'Nama',
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
                DView.height(30),
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: TextButton(
                    onPressed: () async {
                      // Validasi formulir
                      if (_nameController.text.isEmpty) {
                        // Formulir masih kosong, tampilkan pesan atau berikan respons
                        print("Formulir masih kosong");
                      } else {
                        // Formulir tidak kosong, lanjutkan dengan menyimpan data
                        User user = User(
                          name: _nameController.text,
                        );
                        if (widget.initialUser != null) {
                          user.id = widget.initialUser!.id;
                          await DatabaseHelper.instance.updateUser(user);
                        } else {
                          await DatabaseHelper.instance.insertUser(user);
                        }
                        print("Sudah masuk: $user");
                        Navigator.pushNamed(context, '/home');
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
