import 'package:carousel_slider/carousel_slider.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:money_tracker/shared/theme.dart';
import 'package:money_tracker/widgets/buttons.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int currentIndex = 0;
  CarouselController carouselController = CarouselController();
  List<String> titles = [
    'For Your Information nih',
    'Cara menambah transaksi',
    'Cara mengubah nama',
    'Cara menghapus transaksi',
    'Yeay panduan selesai',
  ];

  List<String> subTitles = [
    'Aplikasi ini tidak berbahaya loh, karena tidak membutuhkan akses internet dan tidak membutuhkan perizinan apapun',
    'Untuk menambah transaksi, kamu bisa klik tanda + pada bagian atas sebelah kanan',
    'Kamu dapat mengubah nama dengan cara klik nama kamu',
    'Hapus transaki dengan klik tanda sampah atau kamu juga bisa klik tulisan Hapus Semua Transaksi',
    'Terimakasih sudah membaca panduan, langkah berikutnya isi nama dulu ya',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CarouselSlider(
                  items: [
                    Image.asset(
                      'assets/images/virus.png',
                    ),
                    Image.asset(
                      'assets/images/add_transaction.png',
                    ),
                    Image.asset(
                      'assets/images/add_transaction.png',
                    ),
                    Image.asset(
                      'assets/images/delete_transaction.png',
                    ),
                    Image.asset(
                      'assets/images/thank-you-illustration.png',
                    ),
                  ],
                  options: CarouselOptions(
                    height: 300,
                    viewportFraction: 1,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      setState(
                        () {
                          currentIndex = index;
                        },
                      );
                    },
                  ),
                  carouselController: carouselController,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  padding: EdgeInsets.symmetric(horizontal: 22, vertical: 24),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(15),
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
                    children: [
                      Text(
                        titles[currentIndex],
                        style: blackTextStyle.copyWith(
                          fontSize: 20,
                          fontWeight: semiBold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      DView.height(20),
                      Text(
                        subTitles[currentIndex],
                        style: greyTextStyle.copyWith(
                          fontSize: 16,
                          color: blackColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      DView.height(20),
                      currentIndex == 4
                          ? Column(
                              children: [
                                CustomFilledButton(
                                  title: 'Yuk lanjut isi nama',
                                  onPressed: () {
                                    Navigator.pushNamedAndRemoveUntil(
                                        context, '/profile', (route) => false);
                                  },
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  margin: EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: currentIndex == 0
                                        ? Colors.grey[500]
                                        : lightBackgroundColor,
                                  ),
                                ),
                                Container(
                                  width: 12,
                                  height: 12,
                                  margin: EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: currentIndex == 1
                                        ? Colors.grey[500]
                                        : lightBackgroundColor,
                                  ),
                                ),
                                Container(
                                  width: 12,
                                  height: 12,
                                  margin: EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: currentIndex == 2
                                        ? Colors.grey[500]
                                        : lightBackgroundColor,
                                  ),
                                ),
                                Container(
                                  width: 12,
                                  height: 12,
                                  margin: EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: currentIndex == 3
                                        ? Colors.grey[500]
                                        : lightBackgroundColor,
                                  ),
                                ),
                                Container(
                                  width: 12,
                                  height: 12,
                                  margin: EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: currentIndex == 4
                                        ? Colors.grey[500]
                                        : lightBackgroundColor,
                                  ),
                                ),
                                Spacer(),
                                CustomFilledButton(
                                  width: 150,
                                  title: 'Lanjut',
                                  onPressed: () {
                                    carouselController.nextPage();
                                  },
                                ),
                              ],
                            ),
                    ],
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
