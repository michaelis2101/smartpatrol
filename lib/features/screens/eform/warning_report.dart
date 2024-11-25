import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_patrol/data/models/service_model.dart';
import 'package:smart_patrol/data/models/transaction_model.dart';
import 'package:smart_patrol/features/blocs/eform/eform_bloc.dart';
import 'package:smart_patrol/utils/assets.dart';
import 'package:smart_patrol/utils/styles/colors.dart';
import 'package:smart_patrol/utils/styles/text_styles.dart';
import 'package:smart_patrol/utils/utils.dart';

class WarningReportArgs {
  final EFormBloc serviceBloc, areaBloc;
  final String label, tag, serviceCode, description;

  const WarningReportArgs(
      {required this.areaBloc,
      required this.serviceBloc,
      required this.label,
      required this.tag,
      required this.serviceCode,
      required this.description});
}

class WarningReportPage extends StatefulWidget {
  const WarningReportPage({super.key, required this.args});

  final WarningReportArgs args;

  @override
  State<WarningReportPage> createState() => _WarningReportPage();
}

class _WarningReportPage extends State<WarningReportPage> {
  final TextEditingController input = TextEditingController();

  @override
  void initState() {
    if (widget.args.description.isNotEmpty) {
      input.text = widget.args.description;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tag Merah',
          style: kToolbarHeader,
        ),
        leading: const BackButton(color: Colors.white),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: const RoundedRectangleBorder(),
                  color: Colors.white,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.args.label,
                          style:
                              const TextStyle(color: kRichBlack, fontSize: 14),
                        ),
                        Text(
                          'TAG : ${widget.args.tag}',
                          style:
                              const TextStyle(color: kRichBlack, fontSize: 14),
                        ),
                        const SizedBox(height: 10)
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<EFormBloc, EFormState>(
                      bloc: widget.args.areaBloc,
                      builder: (context, areaState) =>
                          BlocBuilder<EFormBloc, EFormState>(
                        bloc: widget.args.serviceBloc,
                        builder: (context, serviceState) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Choose Condition :',
                                style: TextStyle(color: Colors.grey)),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey)),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  isExpanded: true,
                                  hint: const Text('Choose One',
                                      style: TextStyle(color: Colors.grey)),
                                  style: const TextStyle(color: Colors.black),
                                  dropdownColor: Colors.white,
                                  value: areaState
                                          .transactions.transactions.isEmpty
                                      ? serviceState.servicesByEquipment.firstWhere((e) => e.idService == widget.args.serviceCode).reportedCondition ==
                                              0
                                          ? null
                                          : serviceState.servicesByEquipment
                                              .firstWhere((e) =>
                                                  e.idService ==
                                                  widget.args.serviceCode)
                                              .reportedCondition
                                      : areaState.transactions.transactions
                                                  .firstWhere((e) => e.idService == widget.args.serviceCode,
                                                      orElse: () =>
                                                          const Transaction())
                                                  .reportedCondition ==
                                              0
                                          ? serviceState.servicesByEquipment
                                                      .firstWhere((e) => e.idService == widget.args.serviceCode,
                                                          orElse: () =>
                                                              const Service())
                                                      .reportedCondition ==
                                                  0
                                              ? null
                                              : serviceState.servicesByEquipment
                                                  .firstWhere((e) => e.idService == widget.args.serviceCode,
                                                      orElse: () =>
                                                          const Service())
                                                  .reportedCondition
                                          : areaState.transactions.transactions
                                              .firstWhere((e) =>
                                                  e.idService == widget.args.serviceCode)
                                              .reportedCondition,
                                  items: const [
                                    DropdownMenuItem(
                                        value: 1,
                                        child: Text("Process Condition")),
                                    DropdownMenuItem(
                                        value: 2,
                                        child: Text("Equipment Trouble")),
                                  ],
                                  onChanged: (value) {
                                    widget.args.serviceBloc.add(
                                        ChangeServiceReportedConditionEvent(
                                            idService: widget.args.serviceCode,
                                            value: value ?? 0));
                                    widget.args.areaBloc.add(
                                        ChangeServiceReportedConditionEvent(
                                            idService: widget.args.serviceCode,
                                            isAreaBloc: true,
                                            value: value ?? 0));
                                  },
                                ),
                              ),
                            ),
                            if (serviceState.servicesByEquipment
                                        .firstWhere((e) =>
                                            e.idService ==
                                            widget.args.serviceCode)
                                        .reportedCondition ==
                                    2
                                //  ||
                                // (areaState
                                // .transactions.transactions.isNotEmpty &&
                                // areaState.transactions.transactions
                                // .firstWhere(
                                // (e) =>
                                // e.idService ==
                                // widget.args.serviceCode,
                                // orElse: () =>
                                // const Transaction())
                                // .reportedCondition ==
                                // 2
                                ) ...[
                              const SizedBox(height: 10),
                              const Text('Choose Request :',
                                  style: TextStyle(color: Colors.grey)),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey)),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    isExpanded: true,
                                    hint: const Text('Choose One',
                                        style: TextStyle(color: Colors.grey)),
                                    style: const TextStyle(color: Colors.black),
                                    dropdownColor: Colors.white,
                                    value: areaState
                                            .transactions.transactions.isEmpty
                                        ? serviceState.servicesByEquipment
                                                .firstWhere((e) => e.idService == widget.args.serviceCode,
                                                    orElse: () =>
                                                        const Service())
                                                .reportedRequest
                                                .isEmpty
                                            ? null
                                            : serviceState.servicesByEquipment
                                                .firstWhere((e) => e.idService == widget.args.serviceCode,
                                                    orElse: () =>
                                                        const Service())
                                                .reportedRequest
                                        : areaState.transactions.transactions
                                                .firstWhere((e) => e.idService == widget.args.serviceCode,
                                                    orElse: () =>
                                                        const Transaction())
                                                .reportedRequest
                                                .isEmpty
                                            ? serviceState.servicesByEquipment
                                                    .firstWhere((e) =>
                                                        e.idService ==
                                                        widget.args.serviceCode)
                                                    .reportedRequest
                                                    .isEmpty
                                                ? null
                                                : serviceState
                                                    .servicesByEquipment
                                                    .firstWhere((e) =>
                                                        e.idService ==
                                                        widget.args.serviceCode)
                                                    .reportedRequest
                                            : areaState
                                                .transactions.transactions
                                                .firstWhere(
                                                    (e) => e.idService == widget.args.serviceCode,
                                                    orElse: () => const Transaction())
                                                .reportedRequest,
                                    items: const [
                                      DropdownMenuItem(
                                          value: 'Instrument',
                                          child: Text("Instrument")),
                                      DropdownMenuItem(
                                          value: 'Mechanic',
                                          child: Text("Mechanic")),
                                      DropdownMenuItem(
                                          value: "Electric",
                                          child: Text("Electric")),
                                      DropdownMenuItem(
                                          value: "Civil", child: Text("Civil")),
                                    ],
                                    onChanged: (value) {
                                      widget.args.serviceBloc.add(
                                          ChangeServiceReportedRequestEvent(
                                              idService:
                                                  widget.args.serviceCode,
                                              value: value ?? ''));
                                      widget.args.areaBloc.add(
                                          ChangeServiceReportedRequestEvent(
                                              idService:
                                                  widget.args.serviceCode,
                                              isAreaBloc: true,
                                              value: value ?? ''));
                                    },
                                  ),
                                ),
                              )
                            ]
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text('Description :',
                          style: TextStyle(color: Colors.grey)),
                    ),
                    SizedBox(
                      height: 200,
                      child: TextField(
                        controller: input,
                        maxLines: 20,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Colors.grey)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Colors.grey)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Colors.grey)),
                            hintText: 'Text Here...'),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Image Attachment 1 :',
                          style: TextStyle(color: Colors.black)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            child: const Row(
                              children: [
                                Icon(Icons.photo),
                                SizedBox(width: 5),
                                Text('Gallery')
                              ],
                            ),
                            onPressed: () async {
                              final XFile? image = await ImagePicker()
                                  .pickImage(
                                      source: ImageSource.gallery,
                                      imageQuality: 60);
                              if (image != null) {
                                widget.args.serviceBloc.add(
                                    AddServiceReportedPhotoEvent(
                                        imageIndex: 1,
                                        idService: widget.args.serviceCode,
                                        image: image));
                                widget.args.areaBloc.add(
                                    AddServiceReportedPhotoEvent(
                                        imageIndex: 1,
                                        idService: widget.args.serviceCode,
                                        image: image,
                                        isAreaBloc: true));
                              }
                            },
                          ),
                          const SizedBox(width: 20),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            child: const Row(
                              children: [
                                Icon(Icons.camera_alt),
                                SizedBox(width: 5),
                                Text('Camera')
                              ],
                            ),
                            onPressed: () async {
                              final XFile? image = await ImagePicker()
                                  .pickImage(
                                      source: ImageSource.camera,
                                      imageQuality: 60);
                              if (image != null) {
                                widget.args.serviceBloc.add(
                                    AddServiceReportedPhotoEvent(
                                        imageIndex: 1,
                                        idService: widget.args.serviceCode,
                                        image: image));
                                widget.args.areaBloc.add(
                                    AddServiceReportedPhotoEvent(
                                        imageIndex: 1,
                                        idService: widget.args.serviceCode,
                                        image: image,
                                        isAreaBloc: true));
                              }
                            },
                          )
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Image Attachment 2 :',
                          style: TextStyle(color: Colors.black)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            child: const Row(
                              children: [
                                Icon(Icons.photo),
                                SizedBox(width: 5),
                                Text('Gallery')
                              ],
                            ),
                            onPressed: () async {
                              final XFile? image = await ImagePicker()
                                  .pickImage(
                                      source: ImageSource.gallery,
                                      imageQuality: 60);
                              if (image != null) {
                                widget.args.serviceBloc.add(
                                    AddServiceReportedPhotoEvent(
                                        imageIndex: 2,
                                        idService: widget.args.serviceCode,
                                        image: image));
                                widget.args.areaBloc.add(
                                    AddServiceReportedPhotoEvent(
                                        imageIndex: 2,
                                        idService: widget.args.serviceCode,
                                        image: image,
                                        isAreaBloc: true));
                              }
                            },
                          ),
                          const SizedBox(width: 20),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            child: const Row(
                              children: [
                                Icon(Icons.camera_alt),
                                SizedBox(width: 5),
                                Text('Camera')
                              ],
                            ),
                            onPressed: () async {
                              final XFile? image = await ImagePicker()
                                  .pickImage(
                                      source: ImageSource.camera,
                                      imageQuality: 60);
                              if (image != null) {
                                widget.args.serviceBloc.add(
                                    AddServiceReportedPhotoEvent(
                                        imageIndex: 2,
                                        idService: widget.args.serviceCode,
                                        image: image));
                                widget.args.areaBloc.add(
                                    AddServiceReportedPhotoEvent(
                                        imageIndex: 2,
                                        idService: widget.args.serviceCode,
                                        image: image,
                                        isAreaBloc: true));
                              }
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Image 1 :', style: TextStyle(color: Colors.black)),
              ),
              BlocBuilder<EFormBloc, EFormState>(
                bloc: widget.args.areaBloc,
                builder: (context, areaState) =>
                    BlocBuilder<EFormBloc, EFormState>(
                  bloc: widget.args.serviceBloc,
                  builder: (context, serviceState) => SizedBox(
                    width: double.infinity,
                    height: 250,
                    child: areaState.transactions.transactions.isEmpty
                        ? serviceState.servicesByEquipment
                                .firstWhere((e) =>
                                    e.idService == widget.args.serviceCode)
                                .reportedImage
                                .isEmpty
                            ? Image.asset(ImageAssets.placeholder,
                                fit: BoxFit.cover)
                            : Image.memory(
                                base64Decode(serviceState.servicesByEquipment
                                    .firstWhere((e) =>
                                        e.idService == widget.args.serviceCode)
                                    .reportedImage),
                                fit: BoxFit.cover)
                        : areaState.transactions.transactions
                                .firstWhere((e) => e.idService == widget.args.serviceCode,
                                    orElse: () => const Transaction())
                                .reportedImage
                                .isEmpty
                            ? serviceState.servicesByEquipment
                                    .firstWhere((e) =>
                                        e.idService == widget.args.serviceCode)
                                    .reportedImage
                                    .isNotEmpty
                                ? Image.memory(base64Decode(serviceState.servicesByEquipment.firstWhere((e) => e.idService == widget.args.serviceCode).reportedImage),
                                    fit: BoxFit.cover)
                                : Image.asset(ImageAssets.placeholder,
                                    fit: BoxFit.cover)
                            : Image.memory(
                                base64Decode(areaState.transactions.transactions
                                    .firstWhere((e) => e.idService == widget.args.serviceCode)
                                    .reportedImage),
                                fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Image 2 :', style: TextStyle(color: Colors.black)),
              ),
              BlocBuilder<EFormBloc, EFormState>(
                bloc: widget.args.areaBloc,
                builder: (context, areaState) =>
                    BlocBuilder<EFormBloc, EFormState>(
                  bloc: widget.args.serviceBloc,
                  builder: (context, serviceState) => SizedBox(
                    width: double.infinity,
                    height: 250,
                    child: areaState.transactions.transactions.isEmpty
                        ? serviceState.servicesByEquipment
                                .firstWhere(
                                    (e) =>
                                        e.idService == widget.args.serviceCode,
                                    orElse: () => const Service())
                                .reportedImage2
                                .isEmpty
                            ? Image.asset(ImageAssets.placeholder,
                                fit: BoxFit.cover)
                            : Image.memory(
                                base64Decode(serviceState.servicesByEquipment
                                    .firstWhere((e) =>
                                        e.idService == widget.args.serviceCode)
                                    .reportedImage2),
                                fit: BoxFit.cover)
                        : areaState.transactions.transactions
                                .firstWhere(
                                    (e) =>
                                        e.idService == widget.args.serviceCode,
                                    orElse: () => const Transaction())
                                .reportedImage2
                                .isEmpty
                            ? serviceState.servicesByEquipment
                                    .firstWhere((e) =>
                                        e.idService == widget.args.serviceCode)
                                    .reportedImage2
                                    .isNotEmpty
                                ? Image.memory(
                                    base64Decode(serviceState.servicesByEquipment
                                        .firstWhere((e) => e.idService == widget.args.serviceCode)
                                        .reportedImage2),
                                    fit: BoxFit.cover)
                                : Image.asset(ImageAssets.placeholder, fit: BoxFit.cover)
                            : Image.memory(
                                base64Decode(
                                  areaState.transactions.transactions
                                      .firstWhere(
                                          (e) =>
                                              e.idService ==
                                              widget.args.serviceCode,
                                          orElse: () => const Transaction())
                                      .reportedImage2,
                                ),
                                fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              BlocBuilder<EFormBloc, EFormState>(
                bloc: widget.args.areaBloc,
                builder: (context, areaState) =>
                    BlocBuilder<EFormBloc, EFormState>(
                  bloc: widget.args.serviceBloc,
                  builder: (context, serviceState) => OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                        shape: const RoundedRectangleBorder()),
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      alignment: Alignment.center,
                      child: const Text(
                        'Simpan',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    onPressed: () {
                      var service = serviceState.servicesByEquipment.firstWhere(
                          (e) => e.idService == widget.args.serviceCode);
                      if ((service.reportedCondition == 1 ||
                              service.reportedCondition == 2 &&
                                  service.reportedRequest.isNotEmpty) &&
                          input.value.text.isNotEmpty &&
                          service.reportedImage.isNotEmpty) {
                        widget.args.serviceBloc.add(
                            ChangeTextValueStateServiceByEquipmentEvent(
                                idService: widget.args.serviceCode,
                                value: input.value.text,
                                isReport: true));
                        widget.args.areaBloc.add(
                            ChangeTextValueStateServiceByEquipmentEvent(
                                idService: widget.args.serviceCode,
                                value: input.value.text,
                                isReport: true,
                                isAreaBloc: true));
                        Navigator.of(context).pop();
                      } else {
                        AppUtil.snackBar(message: 'Data is incomplete');
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
