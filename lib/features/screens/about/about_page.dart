import 'package:flutter/material.dart';
import 'package:smart_patrol/features/screens/settings/settings_page.dart';
import 'package:smart_patrol/utils/constants.dart';
import 'package:smart_patrol/utils/styles/text_styles.dart';

import '../../../utils/styles/colors.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: containerToolbarDecoration,
          ),
          title: const Text(
            'About VCM Digitization',
            style: kToolbarHeader,
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 20.0),
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Image.asset(
                    'assets/img/logo_asahimas.png',
                    width: 200,
                  ),
                ),
              ),
            ),
            const Center(
                child: Text('Version 1.6.9',
                    style: TextStyle(color: Colors.black87, fontSize: 16))),
            Container(
              color: Colors.white,
              child: const Center(
                  child: Text(
                appName,
                style: textStyleSubtitle,
              )),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              color: Colors.white,
              child: const Text(
                // 'Ditonton Yuk merupakan sebuah aplikasi katalog film yang dikembangkan oleh Dicoding Indonesia sebagai contoh proyek aplikasi untuk kelas Menjadi Flutter Developer Expert.',
                '    Patrol Checklist Application is an application to retrieve, process and store data from chemical equipment with the use of android mobile technology and desktop warehouse as data server. Patrol checklist application has two main applications Android Patrol checklist this application is tasked to retrieve data from chemical equipment by using barcode scanning feature. This application will take the output data from the equipment, then the data will be written on Microsoft excel file. final output of this application is a file data with .xls /.xlsx format.',
                style: TextStyle(color: Colors.black87, fontSize: 16),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ));
  }
}
