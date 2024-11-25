import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:smart_patrol/features/blocs/auth/auth_bloc.dart';
import 'package:smart_patrol/features/screens/eform/eform_page.dart';
import 'package:smart_patrol/utils/utils.dart';

import '../../../utils/styles/colors.dart';
import '../../../utils/styles/text_styles.dart';
import '../../blocs/eform/eform_bloc.dart';

class NfcScanPage extends StatefulWidget {
  const NfcScanPage(
      {super.key, required this.authBloc, required this.eformBloc});
  final AuthBloc authBloc;
  final EFormBloc eformBloc;
  @override
  _NfcScanPageState createState() => _NfcScanPageState();
}

int _counter = 0;
bool listenerRunning = false;
bool writeCounterOnNextContact = false;

class _NfcScanPageState extends State<NfcScanPage> {
  ValueNotifier<dynamic> result = ValueNotifier(null);
  final EFormBloc nfcBloc = EFormBloc();

  final Widget svgIcon = SvgPicture.asset('assets/ico_svg/cellphone_nfc.svg',
      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      semanticsLabel: 'A red up arrow');

  @override
  void initState() {
    super.initState();
    nfcBloc.add(const NfcReaderEvent());
    nfcBloc.add(const InitEFormEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NFC Page'),
        // Menambahkan tombol kembali di AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Kembali ke layar sebelumnya
          },
        ),
      ),
      body: Container(
          padding: const EdgeInsets.all(10.0),
          margin:
              const EdgeInsets.only(top: 40, left: 30, right: 30, bottom: 20),
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/img/bg_nfc.png"),
                  fit: BoxFit.fill)),
          child: _checkIsNfcAvailable()),
    );
  }

  Widget _checkIsNfcAvailable() => BlocBuilder<EFormBloc, EFormState>(
      bloc: nfcBloc,
      builder: (context, nfcState) => nfcState.nfcIsAvailable
          ? //For ios always false, for android tru
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text(
                //   '$_counter',
                //   style: const TextStyle(color: Colors.red, fontSize: 16),
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed:
                        ((defaultTargetPlatform == TargetPlatform.android) &&
                                listenerRunning)
                            ? null
                            : _listenForNFCEvents,
                    child: Text(
                        defaultTargetPlatform == TargetPlatform.android
                            ? listenerRunning
                                ? 'Ready to Scan'
                                : 'Tap Button to read NFC'
                            : 'Read from tag',
                        style:
                            const TextStyle(color: Colors.black, fontSize: 16)),
                  ),
                ),
                listenerRunning
                    ? Lottie.asset('assets/lottie/nfc_card_read.json')
                    : InkWell(
                        onTap: ((defaultTargetPlatform == TargetPlatform.android) &&
                            listenerRunning)
                            ? null
                            : _listenForNFCEvents,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: buttonPageNFCDecoration,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: svgIcon,
                          ),
                        ),
                      ),
                ((defaultTargetPlatform == TargetPlatform.android) &&
                        listenerRunning)
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Hold Phone near the NFC field',
                          style: kDefaultText,
                        ))
                    : Container(),
              ],
            )
          : Container(
              alignment: Alignment.center,
              child: const Text("NFC Tidak Ada",
                  style: TextStyle(color: Colors.black)),
            ));

  Future<void> _listenForNFCEvents() async {
    //Always run this for ios but only once for android
    if ((defaultTargetPlatform == TargetPlatform.android) &&
            listenerRunning == false ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      if ((defaultTargetPlatform == TargetPlatform.android)) {
        AppUtil.snackBar(
            message: 'NFC listener running in background now, approach tag(s)');
        //Update button states
        setState(() {
          listenerRunning = true;
        });
      }
      _tagRead();
    }
  }

  void _tagRead() {
    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        bool success = false;
        //Try to convert the raw tag data to NDEF
        final ndefTag = Ndef.from(tag);
        //If the data could be converted we will get an object
        if (ndefTag != null) {
          // If we want to write the current counter vlaue we will replace the current content on the tag
          if (writeCounterOnNextContact) {
            //Ensure the write flag is off again
            setState(() {
              writeCounterOnNextContact = false;
            });
            //Create a 1Well known tag with en as language code and 0x02 encoding for UTF8
            final ndefRecord = NdefRecord.createText(_counter.toString());
            //Create a new ndef message with a single record
            final ndefMessage = NdefMessage([ndefRecord]);
            //Write it to the tag, tag must still be "connected" to the device
            try {
              //Any existing content will be overrwirten
              await ndefTag.write(ndefMessage);
              // _alert('Counter written to tag');
              success = true;
            } catch (e) {
              // _alert("Writting failed, press 'Write to tag' again");
            }
          }
          //The NDEF Message was already parsed, if any
          else if (ndefTag.cachedMessage != null) {
            var ndefMessage = ndefTag.cachedMessage!;
            //Each NDEF message can have multiple records, we will use the first one in our example
            if (ndefMessage.records.isNotEmpty &&
                ndefMessage.records.first.typeNameFormat ==
                    NdefTypeNameFormat.nfcWellknown) {
              //If the first record exists as 1:Well-Known we consider this tag as having a value for us
              final wellKnownRecord = ndefMessage.records.first;

              ///Payload for a 1:Well Known text has the following format:
              ///[Encoding flag 0x02 is UTF8][ISO language code like en][content]

              if (wellKnownRecord.payload.first == 0x02) {
                //Now we know the encoding is UTF8 and we can skip the first byte
                final languageCodeAndContentBytes =
                    wellKnownRecord.payload.skip(1).toList();
                //Note that the language code can be encoded in ASCI, if you need it be carfully with the endoding
                final languageCodeAndContentText =
                    utf8.decode(languageCodeAndContentBytes);
                //Cutting of the language code
                final payload = languageCodeAndContentText.substring(2);
                //Parsing the content to int
                // final storedCounters = int.tryParse(payload);
                success = true;
                setState(() {
                  _counter = 0;
                  listenerRunning = false;
                });
                try {
                  NfcManager.instance.stopSession();
                } catch (_) {
                  //We dont care
                }

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => EformPage(
                            kodeNfc: payload.toString(),
                            eformBloc: widget.eformBloc,
                            authBloc: widget.authBloc)));
              }
            }
          }
        }
        // Required for iOS to define what type of tags should be noticed
      },
      // Required for iOS to define what type of tags should be noticed
      pollingOptions: {
        NfcPollingOption.iso14443,
        NfcPollingOption.iso15693,
      },
    );
  }

  @override
  void dispose() {
    setState(() {
      _counter = 0;
      listenerRunning = false;
    });
    try {
      NfcManager.instance.stopSession();
    } catch (_) {
      //We dont care
    }
    super.dispose();
  }
}
