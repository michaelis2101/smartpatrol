import 'package:flutter/material.dart';
import 'package:smart_patrol/utils/enum.dart';
import 'package:smart_patrol/utils/styles/colors.dart';
import 'package:smart_patrol/utils/utils.dart';

class EformTile extends Card {
  EformTile(
      {super.key,
      required String title,
      required String subtitle,
       String template='',
      String tipeCpl = '',
      String body = '',
      int type = 0,
      int progress = 0,
      bool isActive = false,
      bool notDetected = false,
      bool stop = false,
      GestureTapCallback? onTap,
      ValueChanged<bool?>? onStopChanged,
      ValueChanged<bool?>? onNotDetectedChanged,
      String dataTo = ''})
      : super(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsetsDirectional.all(10.0),
              child: ListTile(
                onTap: onTap,
                title: Text(
                  title,
                  style: const TextStyle(
                      color: kRichBlack, fontWeight: FontWeight.bold),
                ),
                subtitle: type == 0
                    ? Text(
                        subtitle,
                        style: const TextStyle(color: kRichBlack, fontSize: 12),
                      )
                    : type == 1
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                body,
                                style: const TextStyle(
                                    color: Colors.green, fontSize: 12),
                              ),
                              Text(
                                subtitle,
                                style: const TextStyle(
                                    color: kRichBlack, fontSize: 12),
                              )
                            ],
                          )
                        : !tipeCpl.contains("Special")
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    subtitle,
                                    style: const TextStyle(
                                        color: kRichBlack, fontSize: 12),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Checkbox(
                                          side: MaterialStateBorderSide
                                              .resolveWith(
                                            (states) => const BorderSide(
                                                color: Colors.grey),
                                          ),
                                          activeColor:
                                              stop ? Colors.green : Colors.grey,
                                          value: stop,
                                          onChanged: onStopChanged),
                                      const Text(
                                        'Stop',
                                        style: TextStyle(
                                            color: kRichBlack, fontSize: 14),
                                      ),
                                      const SizedBox(width: 10),
                                      Checkbox(
                                          side: MaterialStateBorderSide
                                              .resolveWith(
                                            (states) => states.isEmpty
                                                ? const BorderSide(
                                                    color: Colors.grey)
                                                : const BorderSide(
                                                    color: Colors.green),
                                          ),
                                          activeColor: notDetected
                                              ? Colors.red
                                              : Colors.grey,
                                          value: notDetected,
                                          onChanged: onNotDetectedChanged),
                                      const Text(
                                        'Not Detected',
                                        style: TextStyle(
                                            color: kRichBlack, fontSize: 14),
                                      )
                                    ],
                                  )
                                ],
                              )
                            : Text(
                                    template,
                                    style: const TextStyle(
                                        color: kRichBlack, fontSize: 14),
                                  ),
                trailing: type == 0
                    ? null
                    : type == 1
                        ? Card(
                            color: Colors.blue,
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text('$progress%'),
                            ),
                          )
                        : Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: isActive ? kGreen : Colors.red),
                          ),
              ),
            ));
}

class ServiceForm extends Card {
  ServiceForm(
      {super.key,
      required String label,
      required String tag,
      required FormType type,
      required String formatForm, //standard / special
      TextEditingController? input,
      String unit = '',
      String bottomHint = '',
      List<String> options = const [],
      String selectedOption = '',
      bool isActive = false,
      bool isEnabled = false,
      bool editan = false,
      bool notDetected = false,
      bool stop = false,
      bool warning = false,
      String tipeSpecial = '',
      String planning = '',
      int resultPlanning = 0,
      ValueChanged<bool?>? onStopChanged,
      ValueChanged<bool?>? onNotDetectedChanged,
      ValueChanged<String>? onInputChanged,
      ValueChanged<String>? onInputChangedPlan,
      ValueChanged<dynamic>? onRadioChanged,
      GestureTapCallback? onWarningTap})
      : super(
            color: Colors.white,
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 10,
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: const BoxDecoration(
                        color: kGreen,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8))),
                  ),
                  formatForm == "Standard"
                      ? Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'TAG : $tag',
                                style: const TextStyle(
                                  color: kDavysGrey,
                                  fontSize: 14,
                                ),
                              ),
                              InkWell(
                                onTap: warning ? onWarningTap : null,
                                child: Icon(
                                  Icons.warning,
                                  color: warning ? Colors.red : Colors.grey,
                                ),
                              )
                            ],
                          ))
                      : Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'TAG : $tag',
                                style: const TextStyle(
                                  color: kDavysGrey,
                                  fontSize: 14,
                                ),
                              )
                            ],
                          )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      label,
                      style: const TextStyle(
                          color: textBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Divider(color: Colors.grey),
                  if (type != FormType.options)
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: SizedBox(
                        width: AppUtil.width,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                                child: TextField(
                              controller: input,
                              enabled: editan?isEnabled:(!stop && !notDetected),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: true, decimal: true),
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  disabledBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(12, 0, 12, 0),
                                  hintText: 'Input Here...',
                                  hintStyle: const TextStyle(color: kGreyLight),
                                  // helperText: "",
                                  helperText: bottomHint,
                                  helperStyle: const TextStyle(
                                    color: kDavysGrey,
                                    fontSize: 14,
                                  )),
                              onChanged: onInputChanged,
                            )),
                            const SizedBox(width: 10),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Text(
                                unit,
                                style: const TextStyle(
                                  color: kDavysGrey,
                                  fontSize: 14,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var i in options)
                            SizedBox(
                              height: 30,
                              child: Row(
                                children: [
                                  Radio(
                                      fillColor:
                                          MaterialStateProperty.resolveWith(
                                              (Set states) {
                                        if (states
                                            .contains(MaterialState.disabled)) {
                                          return Colors.grey.withOpacity(.32);
                                        }
                                        if (states
                                            .contains(MaterialState.selected)) {
                                          return kGreen;
                                        }
                                        if (states
                                            .contains(MaterialState.selected)) {
                                          return kGreen;
                                        }
                                        return Colors.grey;
                                      }),
                                      value: i,
                                      groupValue: selectedOption,
                                      onChanged: onRadioChanged),
                                  Text(
                                    i,
                                    style: const TextStyle(
                                      color: kDavysGrey,
                                      fontSize: 14,
                                    ),
                                  )
                                ],
                              ),
                            )
                        ],
                      ),
                    ),
                  formatForm == "Standard"
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                                side: MaterialStateBorderSide.resolveWith(
                                  (states) =>
                                      const BorderSide(color: Colors.green),
                                ),
                                value: stop,
                                activeColor: stop ? Colors.green : Colors.grey,
                                onChanged: onStopChanged),
                            const Text(
                              'Stop',
                              style: TextStyle(color: kRichBlack, fontSize: 14),
                            ),
                            const SizedBox(width: 10),
                            Checkbox(
                                side: MaterialStateBorderSide.resolveWith(
                                  (states) => states.isNotEmpty
                                      ? const BorderSide(color: Colors.red)
                                      : const BorderSide(color: Colors.grey),
                                ),
                                activeColor:
                                    notDetected ? Colors.red : Colors.grey,
                                // fillColor:
                                //     const MaterialStatePropertyAll<Color>(
                                //         kRedBlack),
                                value: notDetected,
                                onChanged: onNotDetectedChanged),
                            const Text(
                              'Not Detected',
                              style: TextStyle(color: kRichBlack, fontSize: 14),
                            )
                          ],
                        )
                      // : (formatForm == "Special" && tipeSpecial != 'unloading')
                      //     ? Container(
                      //         margin:
                      //             const EdgeInsetsDirectional.only(start: 12.0),
                      //         child: Text(
                      //           'Unloading Plan $planning Sisa $resultPlanning',
                      //           style: const TextStyle(
                      //               color: kRichBlack, fontSize: 14),
                      //         ),
                      //       )
                      //     :
                      : const SizedBox()
                ],
              ),
            ));
}

class ServiceFormUnloading extends Card {
  ServiceFormUnloading(
      {super.key,
      required String label,
      required String tag,
      required FormType type,
      required String formatForm, //standard / special
      TextEditingController? input,
      String unit = '',
      String bottomHint = '',
      List<String> options = const [],
      String selectedOption = '',
      bool isActive = false,
      bool isEnabled = false,
      bool notDetected = false,
      bool stop = false,
      bool warning = false,
      String tipeSpecial = '',
      String planning = '',
      int resultPlanning = 0,
      ValueChanged<bool?>? onStopChanged,
      ValueChanged<bool?>? onNotDetectedChanged,
      ValueChanged<String>? onInputChanged,
      ValueChanged<String>? onInputChangedPlan,
      ValueChanged<dynamic>? onRadioChanged,
      GestureTapCallback? onWarningTap})
      : super(
            color: Colors.white,
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 10,
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: const BoxDecoration(
                        color: kGreen,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8))),
                  ),
                  formatForm == "Standard"
                      ? Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'TAG : $tag',
                                style: const TextStyle(
                                  color: kDavysGrey,
                                  fontSize: 14,
                                ),
                              ),
                              InkWell(
                                onTap: warning ? onWarningTap : null,
                                child: Icon(
                                  Icons.warning,
                                  color: warning ? Colors.red : Colors.grey,
                                ),
                              )
                            ],
                          ))
                      : Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'TAG : $tag',
                                style: const TextStyle(
                                  color: kDavysGrey,
                                  fontSize: 14,
                                ),
                              )
                            ],
                          )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      label,
                      style: const TextStyle(
                          color: textBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Divider(color: Colors.grey),
                  if (type != FormType.options)
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: SizedBox(
                        width: AppUtil.width,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                                child: TextField(
                              controller: input,
                              enabled: isEnabled,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: true, decimal: true),
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  disabledBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(12, 0, 12, 0),
                                  hintText: 'Input Here...',
                                  hintStyle: const TextStyle(color: kGreyLight),
                                  // helperText: "",
                                  helperText: bottomHint,
                                  helperStyle: const TextStyle(
                                    color: kDavysGrey,
                                    fontSize: 14,
                                  )),
                              onChanged: onInputChanged,
                            )),
                            const SizedBox(width: 10),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Text(
                                unit,
                                style: const TextStyle(
                                  color: kDavysGrey,
                                  fontSize: 14,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var i in options)
                            SizedBox(
                              height: 30,
                              child: Row(
                                children: [
                                  Radio(
                                      fillColor:
                                          MaterialStateProperty.resolveWith(
                                              (Set states) {
                                        if (states
                                            .contains(MaterialState.disabled)) {
                                          return Colors.grey.withOpacity(.32);
                                        }
                                        if (states
                                            .contains(MaterialState.selected)) {
                                          return kGreen;
                                        }
                                        if (states
                                            .contains(MaterialState.selected)) {
                                          return kGreen;
                                        }
                                        return Colors.grey;
                                      }),
                                      value: i,
                                      groupValue: selectedOption,
                                      onChanged: onRadioChanged),
                                  Text(
                                    i,
                                    style: const TextStyle(
                                      color: kDavysGrey,
                                      fontSize: 14,
                                    ),
                                  )
                                ],
                              ),
                            )
                        ],
                      ),
                    ),
                  formatForm == "Standard"
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                                side: MaterialStateBorderSide.resolveWith(
                                  (states) =>
                                      const BorderSide(color: Colors.green),
                                ),
                                value: stop,
                                activeColor: stop ? Colors.green : Colors.grey,
                                onChanged: onStopChanged),
                            const Text(
                              'Stop',
                              style: TextStyle(color: kRichBlack, fontSize: 14),
                            ),
                            const SizedBox(width: 10),
                            Checkbox(
                                side: MaterialStateBorderSide.resolveWith(
                                  (states) => states.isNotEmpty
                                      ? const BorderSide(color: Colors.red)
                                      : const BorderSide(color: Colors.grey),
                                ),
                                activeColor:
                                    notDetected ? Colors.red : Colors.grey,
                                // fillColor:
                                //     const MaterialStatePropertyAll<Color>(
                                //         kRedBlack),
                                value: notDetected,
                                onChanged: onNotDetectedChanged),
                            const Text(
                              'Not Detected',
                              style: TextStyle(color: kRichBlack, fontSize: 14),
                            )
                          ],
                        )
                      // : (formatForm == "Special" && tipeSpecial != 'unloading')
                      //     ? Container(
                      //         margin:
                      //             const EdgeInsetsDirectional.only(start: 12.0),
                      //         child: Text(
                      //           'Unloading Plan $planning Sisa $resultPlanning',
                      //           style: const TextStyle(
                      //               color: kRichBlack, fontSize: 14),
                      //         ),
                      //       )
                      //     :
                      : const SizedBox()
                ],
              ),
            ));
}
