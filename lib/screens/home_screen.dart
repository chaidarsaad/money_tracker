import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/db/database_helper.dart';
import 'package:money_tracker/models/transaksi_model.dart';
import 'package:money_tracker/models/user_model.dart';
import 'package:money_tracker/screens/create_screen.dart';
import 'package:money_tracker/screens/profile_screen.dart';
import 'package:money_tracker/shared/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isHidden = true;
  String hideBalance(int length) {
    return '*' * length;
  }

  String currentMonth = DateFormat('MMMM').format(DateTime.now());

  String formatRupiah(int? amount) {
    if (amount != null) {
      return "Rp. " +
          amount.toString().replaceAllMapped(
                new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                (Match match) => '${match[1]},',
              );
    } else {
      return "Rp. -";
    }
  }

  Future _refresh() async {
    setState(() {});
  }

  Future<int> hitungTotalSaldo() async {
    int totalPemasukan = await DatabaseHelper.instance.totalPemasukan();
    int totalPengeluaran = await DatabaseHelper.instance.totalPengeluaran();
    return totalPemasukan - totalPengeluaran;
  }

  Future<int> hitungTotalSelisihBulanIni() async {
    int totalPemasukanBulanIni =
        await DatabaseHelper.instance.totalPemasukanBulanIni();
    int totalPengeluaranBulanIni =
        await DatabaseHelper.instance.totalPengeluaranBulanIni();
    return totalPemasukanBulanIni - totalPengeluaranBulanIni;
  }

  showAlertDialogDeleteTransaksi(BuildContext contex) {
    Widget okButton = TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.grey[500],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(56),
        ),
      ),
      child: Text(
        'Hapus Semua Transaksi',
        style: whiteTextStyle.copyWith(
          fontSize: 14,
          fontWeight: semiBold,
        ),
      ),
      onPressed: () async {
        try {
          // Call the clearTransaksiTable function
          await DatabaseHelper.instance.clearTransaksiTable();

          // Perform any additional actions or update the UI as needed
        } catch (error) {
          // Handle any potential errors
          print("Error clearing transaksi table: $error");
        }
        Navigator.of(contex, rootNavigator: true).pop();
        setState(() {});
      },
    );

    AlertDialog alertDialog = AlertDialog(
      title: Text("Peringatan !"),
      content: Text("Anda yakin akan menghapus semua transaksi?"),
      backgroundColor: Colors.grey[300],
      actions: [okButton],
    );

    showDialog(
      context: contex,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }

  showAlertDialog(BuildContext contex, int idTransaksi) {
    Widget okButton = TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.grey[500],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(56),
        ),
      ),
      child: Text(
        'Hapus',
        style: whiteTextStyle.copyWith(
          fontSize: 14,
          fontWeight: semiBold,
        ),
      ),
      onPressed: () {
        DatabaseHelper.instance.deleteTransaksi(idTransaksi);
        Navigator.of(contex, rootNavigator: true).pop();
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.grey[500],
            content: Text('Transaksi dihapus'),
          ),
        );
      },
    );

    AlertDialog alertDialog = AlertDialog(
      title: Text("Peringatan !"),
      content: Text("Anda yakin akan menghapus ?"),
      backgroundColor: Colors.grey[300],
      actions: [okButton],
    );

    showDialog(
      context: contex,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }

  String getGreeting() {
    var hour = DateTime.now().hour;

    if (hour < 11) {
      return 'Selamat Pagi';
    } else if (hour < 15) {
      return 'Selamat Siang';
    } else if (hour < 18) {
      return 'Selamat Sore';
    } else {
      return 'Selamat Malam';
    }
  }

  Future<bool> hasTransactions() async {
    List<Transaksi> transactions =
        await DatabaseHelper.instance.getAllTransactions();
    return transactions.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[300],
        shape: CircularNotchedRectangle(),
        clipBehavior: Clip.antiAlias,
        notchMargin: 6,
        elevation: 0,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.grey[300],
          elevation: 0,
          selectedItemColor: blueColor,
          unselectedItemColor: blackColor,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: blueTextStyle.copyWith(
            fontSize: 10,
            fontWeight: medium,
          ),
          unselectedLabelStyle: blackTextStyle.copyWith(
            fontSize: 10,
            fontWeight: medium,
          ),
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
                color: blueColor,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.history,
              ),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.bar_chart,
              ),
              label: 'Statistic',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person_2_outlined,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/create-transaction').then((value) {
            setState(() {});
          });
        },
        backgroundColor: Colors.grey[500],
        child: Icon(
          Icons.add,
          size: 24,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Column(
          children: [
            // greetings (appBar)
            Container(
              color: Colors.grey[300],
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 35, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getGreeting(),
                        style: blackTextStyle.copyWith(
                          fontSize: 16,
                        ),
                      ),
                      FutureBuilder<User?>(
                        future: DatabaseHelper.instance.getUser(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            User user = snapshot.data!;
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProfileScreen(initialUser: user),
                                  ),
                                ).then((_) {
                                  setState(() {});
                                });
                              },
                              child: Text(
                                user.name,
                                style: blackTextStyle.copyWith(
                                  fontSize: 20,
                                ),
                              ),
                            );
                          } else {
                            if (snapshot.hasData && snapshot.data != null) {
                              User user = snapshot.data!;
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProfileScreen(initialUser: user),
                                    ),
                                  ).then((_) {
                                    setState(() {});
                                  });
                                },
                                child: Text(
                                  user.name,
                                  style: blackTextStyle.copyWith(
                                    fontSize: 20,
                                  ),
                                ),
                              );
                            } else {
                              return Text(
                                'Nama User',
                                style: blackTextStyle.copyWith(
                                  fontSize: 20,
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  FutureBuilder<User?>(
                    future: DatabaseHelper.instance.getUser(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        User user = snapshot.data!;
                        return IconButton(
                          icon: Icon(
                            Icons.person,
                            color: Colors.black,
                            size: 35,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProfileScreen(initialUser: user),
                              ),
                            ).then((_) {
                              setState(() {});
                            });
                          },
                        );
                      } else {
                        if (snapshot.hasData && snapshot.data != null) {
                          User user = snapshot.data!;
                          return IconButton(
                            icon: Icon(
                              Icons.person,
                              color: Colors.black,
                              size: 35,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileScreen(initialUser: user),
                                ),
                              ).then((_) {
                                setState(() {});
                              });
                            },
                          );
                        } else {
                          return IconButton(
                            icon: Icon(
                              Icons.person,
                              color: Colors.black,
                              size: 35,
                            ),
                            onPressed: () {},
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
            // end greetings (appBar)

            DView.height(10),

            // saldo
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Saldo',
                    style: blackTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: semiBold,
                    ),
                  ),
                  DView.height(5),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isHidden = !isHidden;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FutureBuilder(
                          future: hitungTotalSaldo(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text(
                                isHidden
                                    ? hideBalance(
                                        snapshot.data.toString().length)
                                    : '${formatRupiah(snapshot.data)}',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            } else {
                              if (snapshot.hasData) {
                                return Text(
                                  isHidden
                                      ? hideBalance(
                                          snapshot.data.toString().length)
                                      : '${formatRupiah(snapshot.data)}',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.grey[800],
                                      fontSize: 16,
                                    ),
                                  ),
                                );
                              } else {
                                return FutureBuilder(
                                  future:
                                      DatabaseHelper.instance.totalPemasukan(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      int totalPemasukan = snapshot.data as int;

                                      return Text(
                                        '${formatRupiah(totalPemasukan)}',
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            color: Colors.grey[800],
                                            fontSize: 16,
                                          ),
                                        ),
                                      );
                                    } else {
                                      if (snapshot.hasData) {
                                        int totalPemasukan =
                                            snapshot.data as int;

                                        return Text(
                                          '${formatRupiah(totalPemasukan)}',
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                              color: Colors.grey[800],
                                              fontSize: 16,
                                            ),
                                          ),
                                        );
                                      } else {
                                        return Center(
                                          child: Text(
                                            "0",
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                );
                              }
                            }
                          },
                        ),
                        DView.width(5),
                        Icon(
                          isHidden
                              ? Icons.visibility_off
                              : Icons.remove_red_eye,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // end saldo

            DView.height(10),

            // wallet card
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(4.0),
              child: Container(
                height: 160,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Pemasukan',
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      FutureBuilder(
                                        future: DatabaseHelper.instance
                                            .totalPemasukanBulanIni(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            int totalPengeluaran =
                                                snapshot.data as int;
                                            return Text(
                                              '${formatRupiah(totalPengeluaran)}',
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            );
                                          } else {
                                            if (snapshot.hasData) {
                                              int totalPengeluaran =
                                                  snapshot.data as int;
                                              return Text(
                                                '${formatRupiah(totalPengeluaran)}',
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return Center(
                                                child: Text(
                                                  "0",
                                                  style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Pengeluaran',
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      FutureBuilder(
                                        future: DatabaseHelper.instance
                                            .totalPengeluaranBulanIni(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            int totalPengeluaran =
                                                snapshot.data as int;
                                            return Text(
                                              '${formatRupiah(totalPengeluaran)}',
                                              style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              )),
                                            );
                                          } else {
                                            if (snapshot.hasData) {
                                              int totalPengeluaran =
                                                  snapshot.data as int;
                                              return Text(
                                                '${formatRupiah(totalPengeluaran)}',
                                                style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                              );
                                            } else {
                                              return Center(
                                                child: Text(
                                                  "0",
                                                  style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    DView.height(10),
                    Text(
                      'Selisih',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: semiBold,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                    FutureBuilder(
                      future: hitungTotalSelisihBulanIni(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text(
                            '${formatRupiah(snapshot.data)}',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 16,
                                fontWeight: semiBold,
                              ),
                            ),
                          );
                        } else {
                          if (snapshot.hasData) {
                            return Text(
                              '${formatRupiah(snapshot.data)}',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 16,
                                  fontWeight: semiBold,
                                ),
                              ),
                            );
                          } else {
                            return FutureBuilder(
                              future: DatabaseHelper.instance.totalPemasukan(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  int totalPemasukan = snapshot.data as int;

                                  return Text(
                                    '${formatRupiah(totalPemasukan)}',
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        color: Colors.grey[800],
                                        fontSize: 16,
                                      ),
                                    ),
                                  );
                                } else {
                                  if (snapshot.hasData) {
                                    int totalPemasukan = snapshot.data as int;

                                    return Text(
                                      '${formatRupiah(totalPemasukan)}',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          color: Colors.grey[800],
                                          fontSize: 16,
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Center(
                                      child: Text(
                                        "0",
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            color: Colors.grey[800],
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
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
              ),
            ),
            // end wallet card

            // text transaksi terbaru
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Transaksi Bulan $currentMonth',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 16,
                      ),
                    ),
                  ),
                  FutureBuilder<bool>(
                    future: hasTransactions(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox
                            .shrink(); // return an empty widget while waiting
                      } else {
                        bool hasData = snapshot.data ?? false;
                        return Visibility(
                          visible: hasData,
                          child: GestureDetector(
                            onTap: () {},
                            child: Text(
                              'Lihat Semua',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            // text transaksi terbaru

            // list transaction
            FutureBuilder<List<Transaksi>>(
              future: DatabaseHelper.instance.getTransaksiBulanIni(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Transaksi transaksi = snapshot.data![index];
                        // Format the date using intl package
                        String formattedDate = DateFormat('dd-MM-yyyy').format(
                            DateTime.parse(snapshot.data![index].createdAt));
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Card(
                            elevation: 2,
                            child: ListTile(
                              title: Text(
                                snapshot.data![index].name,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data![index].type == 1
                                        ? "+ ${formatRupiah(snapshot.data![index].total)}"
                                        : "- ${formatRupiah(snapshot.data![index].total)}",
                                    style: TextStyle(
                                      fontWeight: bold,
                                    ),
                                  ),
                                  Text(
                                    formattedDate,
                                  ),
                                ],
                              ),
                              leading: snapshot.data![index].type == 1
                                  ? Icon(
                                      Icons.arrow_upward,
                                    )
                                  : Icon(
                                      Icons.arrow_downward,
                                    ),
                              trailing: Wrap(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CreateScreen(
                                              initialTransaksi: transaksi),
                                        ),
                                      ).then((_) {
                                        _refresh();
                                      });
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showAlertDialog(
                                          context, snapshot.data![index].id!);
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  if (snapshot.hasData) {
                    if (snapshot.data!.length > 0) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            Transaksi transaksi = snapshot.data![index];
                            // Format the date using intl package
                            String formattedDate = DateFormat('dd-MM-yyyy')
                                .format(DateTime.parse(
                                    snapshot.data![index].createdAt));
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              child: Card(
                                elevation: 2,
                                child: ListTile(
                                  title: Text(
                                    snapshot.data![index].name,
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data![index].type == 1
                                            ? "+ ${formatRupiah(snapshot.data![index].total)}"
                                            : "- ${formatRupiah(snapshot.data![index].total)}",
                                        style: TextStyle(
                                          fontWeight: bold,
                                        ),
                                      ),
                                      Text(
                                        formattedDate,
                                      ),
                                    ],
                                  ),
                                  leading: snapshot.data![index].type == 1
                                      ? Icon(
                                          Icons.arrow_upward,
                                        )
                                      : Icon(
                                          Icons.arrow_downward,
                                        ),
                                  trailing: Wrap(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CreateScreen(
                                                      initialTransaksi:
                                                          transaksi),
                                            ),
                                          ).then((_) {
                                            _refresh();
                                          });
                                        },
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          showAlertDialog(context,
                                              snapshot.data![index].id!);
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return Center(
                        child: Text(
                          'Tidak ada transaksi bulan ini',
                          style: blackTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: semiBold,
                          ),
                        ),
                      );
                    }
                  } else {
                    return Center(
                      child: Text(
                        'Tidak ada transaksi',
                        style: blackTextStyle.copyWith(
                          fontSize: 14,
                          fontWeight: semiBold,
                        ),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
