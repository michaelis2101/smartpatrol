import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:smart_patrol/features/screens/settings/settings_page.dart';
import 'package:smart_patrol/utils/styles/colors.dart';
import 'package:smart_patrol/utils/utils.dart';

class AlertWindow extends StatelessWidget {
  const AlertWindow(
      {Key? key, required this.messages, this.onTap, this.onFinishStep})
      : super(key: key);
  final String messages;
  final Function? onTap;
  final Function? onFinishStep;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: AlertDialog(
        title: const Center(
            child: Text(
          'Are you sure',
          style: textStyleSubtitle,
        )),
        content: Container(
            height: 150,
            padding: const EdgeInsetsDirectional.all(8.0),
            child: Column(
              children: [
                Center(
                    child: Text(
                  messages,
                  style: textStyleSubtitleEform,
                )),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: AppUtil.width / 4,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(AppUtil.context!).pop();
                          onFinishStep;
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(kGreenPrimary),
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.white), // Text color
                        ),
                        child: const Text(
                          'Save',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: AppUtil.width / 4,
                      child: ElevatedButton(
                        onPressed: () => {Navigator.of(AppUtil.context!).pop()},
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(kGreyLight),
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.black), // Text color
                        ),
                        child: const Text(
                          'Cancel',
                        ),
                      ),
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }
}
