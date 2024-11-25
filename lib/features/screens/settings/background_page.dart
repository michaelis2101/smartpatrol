import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_patrol/features/blocs/auth/auth_bloc.dart';
import 'package:smart_patrol/utils/styles/colors.dart';
import 'package:smart_patrol/utils/styles/text_styles.dart';

import '../../../utils/assets.dart';
import '../../../utils/utils.dart';

class BackgroundPage extends StatefulWidget {
  const BackgroundPage({super.key});

  @override
  State<BackgroundPage> createState() => _BackgroundPageState();
}

class _BackgroundPageState extends State<BackgroundPage> {
  final AuthBloc bloc = AuthBloc();

// Initial Selected Value
  String dropdownvalue = 'VCM 1';
  XFile? imageTemp;

  // List of items in our dropdown menu
  var items = ['VCM 1', 'VCM 2', 'VCM 3'];

  @override
  void initState() {
    bloc.add(const GetLoginStatusEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: containerToolbarDecoration,
        ),
        title: const Text(
          'Background',
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
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<AuthBloc, AuthState>(
          bloc: bloc,
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        color: kGreen,
                        child: const Text("Pilih Departemen",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButton(
                          style: const TextStyle(color: Colors.black),
                          // Initial Value
                          value: dropdownvalue,
                          // Down Arrow Icon
                          icon: const Icon(Icons.keyboard_arrow_down),
                          // Array list of items
                          items: items.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownvalue = newValue!;
                            });
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        child: const Text("Pilih Background",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700)),
                      ),
                      SizedBox(
                          width: double.infinity,
                          height: 250,
                          child: imageTemp != null
                              ? Image.file(File(imageTemp!.path),
                                  fit: BoxFit.cover)
                              : (state.signedUser?.backgroundCover == null
                                  ? Image.asset(ImageAssets.bgCover,
                                      fit: BoxFit.cover)
                                  : Image.memory(
                                      base64Decode(
                                          state.signedUser!.backgroundCover),
                                      fit: BoxFit.cover))),
                      OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.green,
                              shape: const RoundedRectangleBorder()),
                          child: Container(
                            width: double.infinity,
                            height: 60,
                            alignment: Alignment.center,
                            child: const Text(
                              'Pilih Gambar',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          onPressed: () async {
                            final XFile? image = await ImagePicker().pickImage(
                                source: ImageSource.gallery, imageQuality: 60);
                            if (image != null) {
                              setState(() {
                                imageTemp = image;
                              });
                            }
                          })
                    ]),
                ElevatedButton.icon(
                  onPressed: () {
                    if (imageTemp != null) {
                      bloc.add(SetSettingBackgroundEvent(image: imageTemp!));
                      Navigator.of(context).pop();
                    } else {
                      AppUtil.snackBar(message: 'Harap pilih gambar!');
                    }
                  },
                  style: ButtonStyle(backgroundColor:
                      MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      return kGreen; //<-- SEE e widget's default.
                    },
                  )),
                  icon: const Icon(
                    // <-- Icon
                    Icons.save,
                    color: Colors.white,
                    size: 24.0,
                  ),
                  label: const Text(
                    'Simpan',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ), // <-- Text
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
