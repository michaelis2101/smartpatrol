import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_patrol/data/models/cpl_model.dart';
import 'package:smart_patrol/data/models/equipment_model.dart';
import 'package:smart_patrol/data/models/section_model.dart';
import 'package:smart_patrol/data/models/service_model.dart';
import 'package:smart_patrol/data/models/transaction_model.dart';
import 'package:smart_patrol/features/blocs/auth/auth_bloc.dart';
import 'package:smart_patrol/features/blocs/eform/eform_bloc.dart';
import 'package:smart_patrol/features/screens/eform/warning_report.dart';
import 'package:smart_patrol/features/screens/home/widget/eform_tile.dart';
import 'package:smart_patrol/features/screens/home/widget/empty_state.dart';
import 'package:smart_patrol/features/screens/settings/settings_page.dart';
import 'package:smart_patrol/utils/constants.dart';
import 'package:smart_patrol/utils/enum.dart';
import 'package:smart_patrol/utils/routes.dart';
import 'package:smart_patrol/utils/styles/colors.dart';
import 'package:smart_patrol/utils/styles/text_styles.dart';
import 'package:smart_patrol/utils/utils.dart';

class EformPage extends StatefulWidget {
  const EformPage(
      {super.key,
      required this.kodeNfc,
      required this.eformBloc,
      required this.authBloc});

  final EFormBloc eformBloc;
  final AuthBloc authBloc;
  final String kodeNfc;

  @override
  State<EformPage> createState() => _EformPageState();
}

class _EformPageState extends State<EformPage> {
  late final EFormBloc areaBloc;
  late final EFormBloc sectionBloc;
  late final EFormBloc formatsBloc;
  final EFormBloc cplBloc = EFormBloc();

  @override
  void initState() {
    areaBloc = widget.eformBloc;
    sectionBloc = widget.eformBloc;
    if (widget.kodeNfc.isNotEmpty) {
      EformController.searchInput.clear();
      EformController.equipmentBloc.add(GetEquipmentByNfcTag(widget.kodeNfc));
      EformController.indexPage.value = eformStepEquipment;

      EformController.sectionTitle.value = "EQUIPMENT";
      EformController.equipmentCollection.value = [];
      widget.authBloc.add(const ChangeMainPageEvent(index: 2));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(EformController.equipmentBloc.state);

    return Scaffold(
      appBar: appBar(),
      backgroundColor: kRedBgGrey,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          headerSection(),
          listItem(),
        ],
      ),
    );
  }

  AppBar appBar() => AppBar(
        flexibleSpace: Container(
          decoration: containerToolbarDecoration,
        ),
        title: ValueListenableBuilder(
          valueListenable: EformController.indexPage,
          builder: (context, indexPage, child) => indexPage <=
                  eformStepEquipment
              ? indexPage == eformStepEquipment
                  ? ValueListenableBuilder(
                      valueListenable: EformController.sectionTitle,
                      builder: (context, title, child) => Text(
                        widget.kodeNfc.isNotEmpty
                            ? "NFC Tag - ${widget.kodeNfc}"
                            : "Equipments",
                        style: kToolbarHeader,
                      ),
                    )
                  : ValueListenableBuilder(
                      valueListenable: EformController.sectionTitle,
                      builder: (context, title, child) => Text(
                            getStepTitle(indexPage),
                            style: kToolbarHeader,
                          ))
              : indexPage > eformStepDocument
                  ? LayoutBuilder(
                      builder: (context, constraint) => SizedBox(
                        width: constraint.maxWidth,
                        child: Row(
                          children: [
                            SizedBox(
                              width: constraint.maxWidth - 55,
                              child: ValueListenableBuilder(
                                valueListenable: EformController.equipmentName,
                                builder: (context, title, child) => Text(
                                  title, //${getStepTitle(index)}
                                  overflow: TextOverflow.ellipsis,
                                  style: kToolbarHeader,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: ValueListenableBuilder(
                                valueListenable:
                                    EformController.equipmentCollection,
                                builder:
                                    (context, collection, child) =>
                                        ValueListenableBuilder(
                                            valueListenable:
                                                EformController.indexEquipment,
                                            builder: (context, index, child) =>
                                                BlocBuilder<EFormBloc,
                                                        EFormState>(
                                                    bloc: areaBloc,
                                                    builder: (context, areaState) =>
                                                        EformController
                                                                .specialBtnOn
                                                                .value
                                                            ? const SizedBox()
                                                            : (indexPage ==
                                                                        eformStepSpecialJob ||
                                                                    indexPage ==
                                                                        eformStepSpecialJobForm ||
                                                                    EformController
                                                                            .fromHomePage
                                                                            .value ==
                                                                        fromHistorySpecialJob)
                                                                ? const SizedBox()
                                                                : ValueListenableBuilder(
                                                                    valueListenable:
                                                                        EformController
                                                                            .detectEditableManualService,
                                                                    builder: (context,
                                                                            isEditable,
                                                                            child) =>
                                                                        isEditable
                                                                            ? InkWell(
                                                                                child: Text(
                                                                                  index < EformController.equipmentCollection.value.length ? 'Next' : 'Finish',
                                                                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13),
                                                                                ),
                                                                                onTap: () {
                                                                                  nextPage() {
                                                                                    EformController.indexEquipment.value = index + 1;
                                                                                    EformController.serviceBloc.add(GetServiceByEquipmentEvent(kodeEquipment: collection[index].kodeEquipment, areaState: areaState, steps: ""));
                                                                                    EformController.equipmentName.value = collection[index].namaEquipment;
                                                                                    EformController.equipmentCode.value = collection[index].kodeEquipment;
                                                                                  }

                                                                                  if (kDebugMode) {
                                                                                    log('collection index :$index');
                                                                                    log('collection check :${collection.length}');
                                                                                    log('collection uuid :${EformController.uuidSelected.value}');
                                                                                    log('collection eq :${EformController.equipmentCode.value}');
                                                                                  }

                                                                                  //check trx yg equipmentnya ini
                                                                                  if (collection.isEmpty) {
                                                                                    if (kDebugMode) {
                                                                                      log("collection empty mode");
                                                                                    }
                                                                                    if (EformController.uuidSelected.value.isNotEmpty) {
                                                                                      areaBloc.add(UpdateEFormTransactionEvent(
                                                                                          codeEquipment: collection[index - 1].kodeEquipment,
                                                                                          onFinish: () {
                                                                                            EformController.reset();
                                                                                          }));
                                                                                    } else {
                                                                                      areaBloc.add(UpdateEFormTransactionEvent(
                                                                                          codeEquipment: EformController.equipmentCode.value,
                                                                                          onFinish: () {
                                                                                            EformController.reset();
                                                                                          }));
                                                                                    }
                                                                                  } else {
                                                                                    if (kDebugMode) {
                                                                                      log("collection mode");
                                                                                    }
                                                                                    var checkTrxExisting = areaState.transactions.transactions.where((e) => e.codeEquipment == collection[index - 1].kodeEquipment).isEmpty;
                                                                                    if (checkTrxExisting) {
                                                                                      areaBloc.add(SaveNewEFormTransactionEvent(
                                                                                          codeSectionArea: EformController.sectionSelected.value,
                                                                                          codeEquipment: collection[index - 1].kodeEquipment,
                                                                                          onFinish: () {
                                                                                            if (index < EformController.equipmentCollection.value.length) {
                                                                                              nextPage();
                                                                                            } else {
                                                                                              //back to equipment
                                                                                              EformController.indexPage.value = EformController.indexPage.value - 1;
                                                                                            }
                                                                                          }));
                                                                                    } else {
                                                                                      areaBloc.add(UpdateEFormTransactionEvent(
                                                                                          codeEquipment: collection[index - 1].kodeEquipment,
                                                                                          onFinish: () {
                                                                                            if (index < EformController.equipmentCollection.value.length) {
                                                                                              nextPage();
                                                                                            } else {
                                                                                              // back to eqp
                                                                                              EformController.indexPage.value = EformController.indexPage.value - 1;
                                                                                            }
                                                                                          }));
                                                                                    }
                                                                                  }
                                                                                },
                                                                              )
                                                                            : const SizedBox())

                                                    //inkwell
                                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : LayoutBuilder(
                      builder: (context, constraint) => SizedBox(
                        width: constraint.maxWidth,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: constraint.maxWidth - 80,
                              child: ValueListenableBuilder(
                                valueListenable: EformController.sectionTitle,
                                builder: (context, title, child) => Text(
                                  title,
                                  overflow: TextOverflow.ellipsis,
                                  style: kToolbarHeader,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: BlocBuilder<EFormBloc, EFormState>(
                                bloc: EformController.equipmentBloc,
                                builder: (context, equipmentState) =>
                                    BlocBuilder<EFormBloc, EFormState>(
                                  bloc: areaBloc,
                                  builder: (context, areaState) => Text(
                                    '${areaState.transactions.getProgress(equipmentState.kodeCpl)}%',
                                    style: kToolbarHeader,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: BlocBuilder<EFormBloc, EFormState>(
                                bloc: areaBloc,
                                builder: (context, areaState) => InkWell(
                                  child: const Icon(
                                    Icons.save,
                                    color: Colors.white,
                                  ),
                                  onTap: () {
                                    if (areaState
                                        .transactions.transactions.isEmpty) {
                                      areaBloc.add(
                                          const SaveNewEFormTransactionEvent(
                                              verify: false));
                                    } else {
                                      areaBloc.add(
                                          const UpdateEFormTransactionEvent(
                                              verify: false));
                                    }
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
        ),
        leading: ValueListenableBuilder(
          valueListenable: EformController.equipmentCollection,
          builder: (context, collection, child) => ValueListenableBuilder(
            valueListenable: EformController.indexPage,
            builder: (context, index, child) => index > 0
                ? BackButton(
                    color: Colors.white,
                    onPressed: () {
                      EformController.searchInput.clear();
                      EformController.equipmentBloc
                          .add(const SearchEquipmentEvent(''));
                      cplBloc.add(SearchCplEvent(
                          '', EformController.formatSelected.value));
                      areaBloc.add(SearchAreaEvent(
                          '', EformController.sectionSelected.value));
                      areaBloc.add(const SearchFormatsEvent(''));
                      setState(() {
                        _currentStep = 0;
                      });
                      if (index > 0) {
                        if (index < eformStepService) {
                          if (widget.kodeNfc.isNotEmpty) {
                            EformController.indexPage.value =
                                EformController.indexPage.value - 1;
                            EformController.equipmentBloc
                                .add(GetEquipmentByNfcTag(widget.kodeNfc));
                          } else {
                            EformController.indexPage.value =
                                EformController.indexPage.value - 1;
                            if (EformController.indexPage.value == 0) {
                              EformController.sectionTitle.value =
                                  'FORMAT TYPE';
                            }
                          }
                        } else {
                          if (EformController.fromHomePage.value ==
                                  fromHomePage ||
                              (EformController.fromHomePage.value ==
                                  fromHistoryDocument)) {
                            widget.authBloc.add(ChangeMainPageEvent(
                                index: EformController.fromIndex));
                            EformController.reset();
                          } else if (EformController.fromHomePage.value ==
                              fromHistorySpecialJob) {
                            widget.authBloc.add(ChangeMainPageEvent(
                                index: EformController.fromIndex));
                            EformController.reset();
                          } else {
                            if (index == eformStepSpecialJobForm &&
                                collection.isNotEmpty) {
                              EformController.indexPage.value =
                                  EformController.indexPage.value - 3;
                            } else if (index == eformStepSpecialJob &&
                                collection.isNotEmpty) {
                              EformController.indexPage.value =
                                  EformController.indexPage.value - 2;
                            } else {
                              if (index == eformStepService) {
                                if (widget.kodeNfc.isNotEmpty) {
                                  EformController.indexPage.value =
                                      EformController.indexPage.value - 1;
                                  EformController.equipmentBloc.add(
                                      GetEquipmentByNfcTag(widget.kodeNfc));
                                } else {
                                  EformController.indexPage.value =
                                      EformController.indexPage.value - 1;
                                }
                              } else {
                                EformController.indexPage.value =
                                    EformController.indexPage.value - 2;
                                if (EformController.indexPage.value == 0) {
                                  EformController.sectionTitle.value =
                                      'FORMAT TYPE';
                                }
                              }
                            }
                          }
                        }
                      }
                      //back home special
                      if ((index == eformStepSpecialJob &&
                          collection.isEmpty)) {
                        widget.authBloc.add(ChangeMainPageEvent(
                            index: EformController.fromIndex));
                        EformController.reset();
                      }

                      if ((index == eformStepSpecialJobForm &&
                          collection.isEmpty)) {
                        widget.authBloc.add(ChangeMainPageEvent(
                            index: EformController.fromIndex));
                        EformController.reset();
                      }

                      if (EformController.fromHomePage.value ==
                          fromHistoryDocument) {
                        widget.authBloc.add(ChangeMainPageEvent(
                            index: EformController.fromIndex));
                        EformController.reset();
                      }

                      if (EformController.fromHomePage.value ==
                          fromHistoryEquipment) {
                        widget.authBloc.add(ChangeMainPageEvent(
                            index: EformController.fromIndex));
                        EformController.reset();
                      }

                      //back home service
                      if ((index == eformStepService && collection.isEmpty) &&
                          (EformController.fromHomePage.value ==
                              fromHomePage)) {
                        widget.authBloc.add(ChangeMainPageEvent(
                            index: EformController.fromIndex));
                        EformController.reset();
                      }

                      if ((index == eformStepService && collection.isEmpty) &&
                          (EformController.fromHomePage.value ==
                              fromHistorySpecialJob)) {
                        widget.authBloc.add(ChangeMainPageEvent(
                            index: EformController.fromIndex));
                        EformController.reset();
                      }
                      //handling back for history,home,nfc
                      if ((index == eformStepService && collection.isEmpty) ||
                          (index == eformStepDocument &&
                                  EformController.fromIndex ==
                                      eformStepFormat) &&
                              EformController.fromHomePage.value.isNotEmpty) {
                        widget.authBloc.add(ChangeMainPageEvent(
                            index: EformController.fromIndex));
                        EformController.reset();
                      }

                      //nfc navigation
                      if (widget.kodeNfc.isNotEmpty &&
                          (index == eformStepEquipment)) {
                        EformController.indexPage.value = 0;
                        widget.authBloc
                            .add(const ChangeMainPageEvent(index: 0));
                        EformController.reset();
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        // Navigator.pushNamed(context, nfcScanRoute);
                      }
                    },
                  )
                : const SizedBox(),
          ),
        ),
        actions: [
          ValueListenableBuilder(
            valueListenable: EformController.indexPage,
            builder: (context, index, child) => index > 1
                ? BlocBuilder<EFormBloc, EFormState>(
                    bloc: index == eformStepEquipment
                        ? EformController.equipmentBloc
                        : EformController.serviceBloc,
                    builder: (context, state) => index ==
                            eformStepEquipment //start from equipment
                        ? EformController.eqpOptionMenuSpecial.value
                            ? const SizedBox()
                            : PopupMenuButton<int>(
                                icon: const Icon(Icons.more_vert),
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 1,
                                    child: Text("Check Stop",
                                        style: TextStyle(color: kRichBlack)),
                                  ),
                                  const PopupMenuItem(
                                    value: 2,
                                    child: Text("Uncheck Stop",
                                        style: TextStyle(color: kRichBlack)),
                                  ),
                                ],
                                color: Colors.white,
                                elevation: 2,
                                onSelected: (value) {
                                  switch (value) {
                                    case 2: //uncheck stop
                                      {
                                        if (index == eformStepService) {
                                          //list service
                                          // EformController.serviceBloc.add(
                                          //     ChangeStopStateAllServiceByEquipmentEvent(
                                          //         equipmentCode:
                                          //             state.kodeEquipment,
                                          //         value: false,
                                          //         isAreaBloc: false,
                                          //         isAction: true));
                                          // areaBloc.add(
                                          //     ChangeStopStateAllServiceByEquipmentEvent(
                                          //         equipmentCode:
                                          //             state.kodeEquipment,
                                          //         isAreaBloc: true,
                                          //         value: false));
                                          areaBloc.add(
                                              SaveAllStopEFormTransactionEvent(
                                                  value: false,
                                                  equipmentsByCpl:
                                                      state.equipmentsByCpl));
                                        } else {
                                          //equipment

                                          // for (var i in state.equipmentsByCpl) {
                                          //   EformController.serviceBloc.add(
                                          //       SaveAllStopEFormTransactionEvent(equipmentsByCpl:state.equipmentsByCpl));
                                          areaBloc.add(
                                              SaveAllStopEFormTransactionEvent(
                                                  value: false,
                                                  equipmentsByCpl:
                                                      state.equipmentsByCpl));
                                          // }
                                        }
                                      }
                                      break;
                                    case 3:
                                      {
                                        if (index == eformStepEquipment) {
                                          EformController.serviceBloc.add(
                                              ChangeDetectedStateAllServiceByEquipmentEvent(
                                                  equipmentCode:
                                                      state.kodeEquipment,
                                                  value: true,
                                                  isAreaBloc: false,
                                                  isAction: true));
                                          areaBloc.add(
                                              ChangeDetectedStateAllServiceByEquipmentEvent(
                                                  equipmentCode:
                                                      state.kodeEquipment,
                                                  isAreaBloc: true,
                                                  value: true));
                                        } else {
                                          for (var i in state.equipmentsByCpl) {
                                            EformController.serviceBloc.add(
                                                ChangeDetectedStateAllServiceByEquipmentEvent(
                                                    equipmentCode:
                                                        i.kodeEquipment,
                                                    value: true,
                                                    isAreaBloc: false,
                                                    isAction: true));
                                            areaBloc.add(
                                                ChangeDetectedStateAllServiceByEquipmentEvent(
                                                    equipmentCode:
                                                        i.kodeEquipment,
                                                    isAreaBloc: true,
                                                    value: true));
                                          }
                                        }
                                      }
                                      break;
                                    case 4:
                                      {
                                        if (index == eformStepEquipment) {
                                          EformController.serviceBloc.add(
                                              ChangeDetectedStateAllServiceByEquipmentEvent(
                                                  equipmentCode:
                                                      state.kodeEquipment,
                                                  value: false,
                                                  isAreaBloc: false,
                                                  isAction: true));
                                          areaBloc.add(
                                              ChangeDetectedStateAllServiceByEquipmentEvent(
                                                  equipmentCode:
                                                      state.kodeEquipment,
                                                  isAreaBloc: true,
                                                  value: false));
                                        } else {
                                          for (var i in state.equipmentsByCpl) {
                                            EformController.serviceBloc.add(
                                                ChangeDetectedStateAllServiceByEquipmentEvent(
                                                    equipmentCode:
                                                        i.kodeEquipment,
                                                    value: false,
                                                    isAreaBloc: false,
                                                    isAction: true));
                                            areaBloc.add(
                                                ChangeDetectedStateAllServiceByEquipmentEvent(
                                                    equipmentCode:
                                                        i.kodeEquipment,
                                                    isAreaBloc: true,
                                                    value: false));
                                          }
                                        }
                                      }
                                      break;
                                    default:
                                      {
                                        if (index == eformStepService) {
                                          log("check only 1");
                                          areaBloc.add(
                                              SaveAllStopEFormTransactionEvent(
                                                  value: true,
                                                  equipmentsByCpl:
                                                      state.equipmentsByCpl));
                                        } else {
                                          log("check all");
                                          //check stop all by equipmentCpl
                                          areaBloc.add(
                                              SaveAllStopEFormTransactionEvent(
                                                  value: true,
                                                  equipmentsByCpl:
                                                      state.equipmentsByCpl));
                                        }
                                      }
                                  }
                                },
                              )
                        : index > eformStepEquipment
                            ? (index == eformStepSpecialJob ||
                                    index == eformStepSpecialJobForm)
                                ? const SizedBox()
                                : BlocBuilder<EFormBloc, EFormState>(
                                    bloc: EformController.equipmentBloc,
                                    builder: (context, equipmentState) {
                                      // var data = equipmentState.equipmentsByCpl[0];
                                      if (equipmentState
                                          .equipmentsByCpl.isNotEmpty) {
                                        if (index == eformStepSpecialJob) {
                                          //spesial job
                                          return const SizedBox();
                                        } else {
                                          //service
                                          return ValueListenableBuilder(
                                              valueListenable: EformController
                                                  .detectEditableManualService,
                                              builder:
                                                  (context, isEditable,
                                                          child) =>
                                                      isEditable
                                                          ? PopupMenuButton<
                                                              int>(
                                                              //service
                                                              icon: const Icon(
                                                                  Icons
                                                                      .more_vert),
                                                              itemBuilder:
                                                                  (context) => [
                                                                const PopupMenuItem(
                                                                  value: 3,
                                                                  child: Text(
                                                                      "Check ND",
                                                                      style: TextStyle(
                                                                          color:
                                                                              kRichBlack)),
                                                                ),
                                                                const PopupMenuItem(
                                                                  value: 4,
                                                                  child: Text(
                                                                      "Uncheck ND",
                                                                      style: TextStyle(
                                                                          color:
                                                                              kRichBlack)),
                                                                ),
                                                                const PopupMenuItem(
                                                                  value: 5,
                                                                  child: Text(
                                                                      "Skip",
                                                                      style: TextStyle(
                                                                          color:
                                                                              kRichBlack)),
                                                                ),
                                                              ],
                                                              color:
                                                                  Colors.white,
                                                              elevation: 2,
                                                              onSelected:
                                                                  (value) {
                                                                switch (value) {
                                                                  case 3:
                                                                    {
                                                                      if (index ==
                                                                          eformStepEquipment) {
                                                                        //service
                                                                        EformController.serviceBloc.add(ChangeDetectedStateAllServiceByEquipmentEvent(
                                                                            equipmentCode: state
                                                                                .kodeEquipment,
                                                                            value:
                                                                                true,
                                                                            isAreaBloc:
                                                                                false,
                                                                            isAction:
                                                                                true));
                                                                        areaBloc.add(ChangeDetectedStateAllServiceByEquipmentEvent(
                                                                            equipmentCode: state
                                                                                .kodeEquipment,
                                                                            isAreaBloc:
                                                                                true,
                                                                            value:
                                                                                true));
                                                                      } else if (index ==
                                                                          eformStepService) {
                                                                        for (var i
                                                                            in state.servicesByEquipment) {
                                                                          EformController.serviceBloc.add(ChangeDetectedStateAllServiceByEquipmentEvent(
                                                                              equipmentCode: i.kodeEquipment,
                                                                              value: true,
                                                                              isAreaBloc: false,
                                                                              isAction: true));
                                                                          areaBloc.add(ChangeDetectedStateAllServiceByEquipmentEvent(
                                                                              equipmentCode: i.kodeEquipment,
                                                                              isAreaBloc: true,
                                                                              value: true));
                                                                        }
                                                                      } else {
                                                                        for (var i
                                                                            in state.equipmentsByCpl) {
                                                                          EformController.serviceBloc.add(ChangeDetectedStateAllServiceByEquipmentEvent(
                                                                              equipmentCode: i.kodeEquipment,
                                                                              value: true,
                                                                              isAreaBloc: false,
                                                                              isAction: true));
                                                                          areaBloc.add(ChangeDetectedStateAllServiceByEquipmentEvent(
                                                                              equipmentCode: i.kodeEquipment,
                                                                              isAreaBloc: true,
                                                                              value: true));
                                                                        }
                                                                      }
                                                                    }
                                                                    break;
                                                                  case 4:
                                                                    {
                                                                      if (index ==
                                                                          eformStepService) {
                                                                        EformController.serviceBloc.add(ChangeDetectedStateAllServiceByEquipmentEvent(
                                                                            equipmentCode: state
                                                                                .kodeEquipment,
                                                                            value:
                                                                                false,
                                                                            isAreaBloc:
                                                                                false,
                                                                            isAction:
                                                                                true));
                                                                        areaBloc.add(ChangeDetectedStateAllServiceByEquipmentEvent(
                                                                            equipmentCode: state
                                                                                .kodeEquipment,
                                                                            isAreaBloc:
                                                                                true,
                                                                            value:
                                                                                false));
                                                                      } else {
                                                                        for (var i
                                                                            in state.equipmentsByCpl) {
                                                                          EformController.serviceBloc.add(ChangeDetectedStateAllServiceByEquipmentEvent(
                                                                              equipmentCode: i.kodeEquipment,
                                                                              value: false,
                                                                              isAreaBloc: false,
                                                                              isAction: true));
                                                                          areaBloc.add(ChangeDetectedStateAllServiceByEquipmentEvent(
                                                                              equipmentCode: i.kodeEquipment,
                                                                              isAreaBloc: true,
                                                                              value: false));
                                                                        }
                                                                      }
                                                                    }
                                                                    break;
                                                                  case 5:
                                                                    EformController.serviceBloc.add(ChangeSkipStateAllServiceByEquipmentEvent(
                                                                        equipmentCode:
                                                                            state
                                                                                .kodeEquipment,
                                                                        value:
                                                                            true,
                                                                        isAreaBloc:
                                                                            false,
                                                                        isAction:
                                                                            true));
                                                                    areaBloc.add(ChangeSkipStateAllServiceByEquipmentEvent(
                                                                        equipmentCode:
                                                                            state
                                                                                .kodeEquipment,
                                                                        isAreaBloc:
                                                                            true,
                                                                        value:
                                                                            true));
                                                                    break;
                                                                  default:
                                                                    {
                                                                      if (index ==
                                                                          eformStepEquipment) {
                                                                        EformController.serviceBloc.add(ChangeStopStateAllServiceByEquipmentEvent(
                                                                            equipmentCode: state
                                                                                .kodeEquipment,
                                                                            value:
                                                                                true,
                                                                            isAreaBloc:
                                                                                false,
                                                                            isAction:
                                                                                true));
                                                                        areaBloc.add(ChangeStopStateAllServiceByEquipmentEvent(
                                                                            equipmentCode: state
                                                                                .kodeEquipment,
                                                                            isAreaBloc:
                                                                                true,
                                                                            value:
                                                                                true));
                                                                      } else {
                                                                        for (var i
                                                                            in state.equipmentsByCpl) {
                                                                          EformController.serviceBloc.add(ChangeStopStateAllServiceByEquipmentEvent(
                                                                              equipmentCode: i.kodeEquipment,
                                                                              value: true,
                                                                              isAreaBloc: false,
                                                                              isAction: true));
                                                                          areaBloc.add(ChangeStopStateAllServiceByEquipmentEvent(
                                                                              equipmentCode: i.kodeEquipment,
                                                                              isAreaBloc: true,
                                                                              value: true));
                                                                        }
                                                                      }
                                                                    }
                                                                }
                                                              },
                                                            )
                                                          : const SizedBox());
                                        }
                                      } else {
                                        return const SizedBox();
                                      }
                                    })
                            : const SizedBox(),
                  )
                : const SizedBox(),
          )
        ],
      );

  Widget headerSection() => ValueListenableBuilder(
        valueListenable: EformController.indexPage,
        builder: (context, index, child) => index != eformStepService
            ? index == eformStepService
                ?
                //service
                Container(
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: EformController.searchInput,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: kGreyLight, width: 2)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: kGreen, width: 2)),
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Search tag',
                            hintStyle:
                                TextStyle(fontSize: 12.0, color: Colors.black),
                            labelStyle:
                                TextStyle(fontSize: 13.0, color: Colors.black),
                            suffixIcon: Icon(Icons.search)),
                        onChanged: (str) {
                          sectionBloc.add(SearchSectionEvent(
                              str, EformController.idFormatSelected.value));
                        },
                      ),
                    ),
                  )
                : index == eformStepSpecialJob ||
                        index == eformStepSpecialJobForm
                    ? const SizedBox()
                    : Container(
                        color: Colors.white,
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: EformController.searchInput,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: kGreyLight, width: 2)),
                                focusedBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: kGreen, width: 2)),
                                fillColor: Colors.white,
                                filled: true,
                                hintText: 'Search ${getStepTitle(index)}',
                                hintStyle: const TextStyle(
                                    fontSize: 12.0, color: Colors.black),
                                labelStyle: const TextStyle(
                                    fontSize: 13.0, color: Colors.black),
                                suffixIcon: const Icon(Icons.search)),
                            onChanged: (str) {
                              switch (EformController.indexPage.value) {
                                case eformStepSection:
                                  {
                                    sectionBloc.add(SearchSectionEvent(
                                        str,
                                        EformController
                                            .idFormatSelected.value));
                                  }
                                  break;
                                case eformStepArea:
                                  {
                                    areaBloc.add(SearchAreaEvent(str,
                                        EformController.sectionSelected.value));
                                  }
                                  break;
                                case eformStepDocument:
                                  {
                                    cplBloc.add(SearchCplEvent(str,
                                        EformController.formatSelected.value));
                                  }
                                  break;
                                case eformStepEquipment:
                                  {
                                    EformController.equipmentBloc
                                        .add(SearchEquipmentEvent(str));
                                  }
                                  break;
                                default:
                                  {
                                    sectionBloc.add(SearchFormatsEvent(str));
                                  }
                              }
                            },
                          ),
                        ),
                      )
            : index == eformStepService
                ? //service
                BlocBuilder<EFormBloc, EFormState>(
                    bloc: areaBloc,
                    builder: (context, areaState) {
                      return Container(
                        color: Colors.white,
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: EformController.searchInput,
                            style: const TextStyle(color: Colors.black),
                            decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: kGreyLight, width: 2)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: kGreen, width: 2)),
                                fillColor: Colors.white,
                                filled: true,
                                hintText: 'Search tag',
                                hintStyle: TextStyle(
                                    fontSize: 12.0, color: Colors.black),
                                labelStyle: TextStyle(
                                    fontSize: 13.0, color: Colors.black),
                                suffixIcon: Icon(Icons.search)),
                            onChanged: (str) {
                              // EformController.serviceBloc.add(
                              //     GetServiceSearchByTag(
                              //         areaState: areaState, searchTag: str));
                              EformController.searchService.value = str;
                            },
                          ),
                        ),
                      );
                    },
                  )
                : Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: const RoundedRectangleBorder(),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ValueListenableBuilder(
                            valueListenable: EformController.equipmentName,
                            builder: (context, name, child) => Text(
                              name,
                              style: const TextStyle(
                                  color: kRichBlack, fontSize: 14),
                            ),
                          ),
                          ValueListenableBuilder(
                            valueListenable: EformController.equipmentCode,
                            builder: (context, name, child) => Text(
                              name,
                              style: const TextStyle(
                                  color: kRichBlack, fontSize: 14),
                            ),
                          ),
                          const SizedBox(height: 10)
                        ],
                      ),
                    ),
                  ),
      );

  Widget listItem() => ValueListenableBuilder(
        valueListenable: EformController.indexPage,
        builder: (context, index, child) {
          switch (index) {
            case 1:
              return sectionSection();
            case 2:
              return areaSection();
            case 3:
              return cplSection();
            case 4:
              return equipmentSection();
            case 5:
              return serviceSection();
            case 6:
              return specialJobCheckingList();
            case 7:
              return specialSection();
            default:
              return formatSection();
          }
        },
      );

  String getStepTitle(index) {
    switch (index) {
      case 1:
        return "Organization";
      // return "Section";
      case 2:
        return "Building";
      // return "Area";
      case 3:
        return "Floor";
      // return "Document";
      case 4:
        return "Room";
      // return "Equipment";
      case 5:
        return "Service";
      case 6:
        return "Special";
      default:
        return "Format";
    }
  }

  int _currentStep = 0;

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued(EFormState areaState, String kodeEquipment) {
    if (_currentStep < 2) {
      setState(() => _currentStep += 1);
    }
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  Widget formatSection() => BlocBuilder<EFormBloc, EFormState>(
        bloc: sectionBloc,
        builder: (context, formatState) => Expanded(
          child: formatState.formats.isEmpty
              ? EmptyStateWidget(label: 'Format')
              : ListView.builder(
                  controller: EformController.scroll,
                  itemCount: formatState.formats.length,
                  itemBuilder: (context, i) {
                    var data = formatState.formats[i];
                    return EformTile(
                      title: data.kodeFormat,
                      subtitle: "",
                      onTap: () {
                        print(data.id);
                        EformController.idFormatSelected.value = data.id;
                        EformController.formatSelected.value = data.kodeFormat;
                        EformController.searchInput.clear();
                        areaBloc.add(GetSectionByFormats(data.id));
                        EformController.indexPage.value = 1;
                        EformController.sectionTitle.value = data.kodeFormat;
                        EformController.scroll.jumpTo(0);
                      },
                    );
                  }),
        ),
      );

  Widget sectionSection() => BlocBuilder<EFormBloc, EFormState>(
        bloc: sectionBloc,
        builder: (context, sectionState) => Expanded(
          child: sectionState.sectionByFormat.isEmpty
              ? EmptyStateWidget(label: 'Section')
              : ListView.builder(
                  controller: EformController.scroll,
                  itemCount: sectionState.sectionByFormat.length,
                  itemBuilder: (context, i) {
                    var data = sectionState.sectionByFormat[i];
                    return EformTile(
                      title: data.namaSection,
                      subtitle: data.kodeSection,
                      onTap: () {
                        EformController.searchInput.clear();
                        areaBloc.add(GetAreaBySectionEvent(data.id));
                        EformController.indexPage.value = eformStepArea;
                        EformController.sectionTitle.value = data.namaSection;
                        EformController.sectionSelected.value = data.id;
                        EformController.sectionCollection.value =
                            sectionState.section;
                        EformController.scroll.jumpTo(0);
                      },
                    );
                  }),
        ),
      );

  Widget areaSection() => BlocBuilder<EFormBloc, EFormState>(
        bloc: areaBloc,
        builder: (context, areaState) => Expanded(
          child: areaState.areasBySection.isEmpty
              ? EmptyStateWidget(label: 'Area')
              : ListView.builder(
                  controller: EformController.scroll,
                  itemCount: areaState.areasBySection.length,
                  itemBuilder: (context, i) {
                    var data = areaState.areasBySection[i];
                    return EformTile(
                      title: data.namaArea,
                      subtitle: data.kodeArea,
                      onTap: () {
                        EformController.searchInput.clear();
                        cplBloc.add(GetCplByAreaEvent(data.kodeArea,
                            EformController.formatSelected.value));
                        EformController.indexPage.value = eformStepDocument;
                        EformController.sectionTitle.value = data.namaArea;
                        EformController.scroll.jumpTo(0);
                      },
                    );
                  }),
        ),
      );

  Widget cplSection() => BlocBuilder<EFormBloc, EFormState>(
        bloc: cplBloc,
        builder: (context, cplState) => Expanded(
          child: cplState.cplsByArea.isEmpty
              ? EmptyStateWidget(label: 'CPL')
              : ListView.builder(
                  controller: EformController.scroll,
                  itemCount: cplState.cplsByArea.length,
                  itemBuilder: (context, i) {
                    EformController.cplCollection.value = cplState.cplsByArea;
                    var data = cplState.cplsByArea[i];
                    return BlocBuilder<EFormBloc, EFormState>(
                      bloc: areaBloc,
                      builder: (context, areaState) => EformTile(
                        title: data.namaCpl,
                        type: 1,
                        body: data.tipeCpl,
                        subtitle: data.kodeCpl,
                        progress:
                            areaState.transactions.getProgress(data.kodeCpl),
                        onTap: () {
                          EformController.searchInput.clear();
                          EformController.equipmentBloc
                              .add(GetEquipmentByCplEvent(data.kodeCpl));
                          areaBloc.add(GetEquipmentByCplEvent(data.kodeCpl));
                          EformController.serviceBloc
                              .add(GetEquipmentByCplEvent(data.kodeCpl));
                          EformController.indexPage.value = eformStepEquipment;
                          EformController.sectionTitle.value = data.namaCpl;
                          EformController.scroll.jumpTo(0);
                        },
                      ),
                    );
                  }),
        ),
      );

  Widget equipmentSection() => BlocBuilder<EFormBloc, EFormState>(
        bloc: EformController.equipmentBloc,
        builder: (context, equipmentState) => Expanded(
          child: equipmentState.equipmentsByCpl.isEmpty
              ? EmptyStateWidget(label: 'Equipment')
              : ListView.builder(
                  controller: EformController.scroll,
                  itemCount: equipmentState.equipmentsByCpl.length,
                  itemBuilder: (context, i) {
                    var data = equipmentState.equipmentsByCpl[i];
                    var namaTemplate = areaBloc.state.cpls
                        .where((e) => e.kodeCpl == data.kodeCpl)
                        .first
                        .template;
                    log("nama template $namaTemplate");
                    var dataTo = data.to;
                    if (data.tipeCpl == 'Special') {
                      EformController.eqpOptionMenuSpecial.value = true;
                    } else {
                      EformController.eqpOptionMenuSpecial.value = false;
                    }
                    Map<String, List<String>> listMapTo = {};
                    var checkTo = (jsonDecode(jsonDecode(data.to))).toString();

                    if (checkTo.isNotEmpty) {
                      var lengthTo =
                          (jsonDecode(jsonDecode(dataTo)) as List).length;
                      if (jsonDecode(jsonDecode(dataTo))
                          .toString()
                          .isNotEmpty) {
                        for (var i = 0; i < lengthTo; i++) {
                          var itemTo = (jsonDecode(jsonDecode(dataTo))[i]
                                  as Map<String, dynamic>)
                              .cast();
                          var mkeys = itemTo.keys.first;
                          var indexs = mkeys;
                          if (itemTo[indexs][0] != "") {
                            var item = itemTo[indexs];
                            List<String> icastStr = item.cast<String>();
                            listMapTo[indexs] = icastStr;
                          }
                        }
                      }
                    }

                    return BlocBuilder<EFormBloc, EFormState>(
                      bloc: areaBloc,
                      builder: (context, areaState) => EformTile(
                        title: data.namaEquipment,
                        template: namaTemplate,
                        tipeCpl: (jsonDecode(jsonDecode(dataTo))
                                .toString()
                                .isNotEmpty)
                            ? 'Special Transfer'
                            : data.tipeCpl,
                        type: 3,
                        dataTo: dataTo,
                        subtitle: data.kodeEquipment,
                        isActive: areaState.transactions.transactions.isNotEmpty
                            ? (areaState.transactions
                                        .getTransactionByEquipment(
                                            data.kodeEquipment,
                                            authBloc.state.signedUser)
                                        .length ==
                                    areaState.transactions
                                        .getTransactionByEquipment(
                                            data.kodeEquipment,
                                            authBloc.state.signedUser)
                                        .where((e) =>
                                            e.codeEquipment ==
                                                data.kodeEquipment &&
                                            e.isValidated())
                                        .length) &&
                                areaState.transactions
                                    .getTransactionByEquipment(
                                        data.kodeEquipment,
                                        widget.authBloc.state.signedUser)
                                    .isNotEmpty
                            : areaState.services
                                    .where((e) =>
                                        e.kodeEquipment == data.kodeEquipment)
                                    .length ==
                                areaState.services
                                    .where((e) =>
                                        e.kodeEquipment == data.kodeEquipment &&
                                        e.isValidated())
                                    .length,
                        stop: areaState.transactions.transactions.isNotEmpty
                            ? (areaState.transactions
                                        .getTransactionByEquipment(
                                            data.kodeEquipment,
                                            widget.authBloc.state.signedUser)
                                        .length ==
                                    areaState.transactions
                                        .getTransactionByEquipment(
                                            data.kodeEquipment,
                                            widget.authBloc.state.signedUser)
                                        .where((e) =>
                                            e.codeEquipment ==
                                                data.kodeEquipment &&
                                            e.checkBox == 1)
                                        .length) &&
                                areaState.transactions
                                    .getTransactionByEquipment(
                                        data.kodeEquipment,
                                        widget.authBloc.state.signedUser)
                                    .isNotEmpty
                            :
                            //pastikan data tidak kosong
                            areaState.services
                                    .where((e) =>
                                        e.kodeEquipment == data.kodeEquipment)
                                    .length ==
                                areaState.services
                                    .where((e) =>
                                        e.kodeEquipment == data.kodeEquipment &&
                                        e.checkBox == 1)
                                    .length,
                        notDetected: areaState
                                .transactions.transactions.isNotEmpty
                            ? (areaState.transactions
                                        .getTransactionByEquipment(
                                            data.kodeEquipment,
                                            widget.authBloc.state.signedUser)
                                        .length ==
                                    areaState.transactions
                                        .getTransactionByEquipment(
                                            data.kodeEquipment,
                                            widget.authBloc.state.signedUser)
                                        .where((e) =>
                                            e.codeEquipment ==
                                                data.kodeEquipment &&
                                            e.checkBox == 2)
                                        .length) &&
                                areaState.transactions
                                    .getTransactionByEquipment(
                                        data.kodeEquipment,
                                        widget.authBloc.state.signedUser)
                                    .isNotEmpty
                            : areaState.services
                                    .where((e) =>
                                        e.kodeEquipment == data.kodeEquipment)
                                    .length ==
                                areaState.services
                                    .where((e) =>
                                        e.kodeEquipment == data.kodeEquipment &&
                                        e.checkBox == 2)
                                    .length,
                        onStopChanged: (v) {
                          areaBloc.add(
                              ChangeStopStateAllServiceByEquipmentEvent(
                                  equipmentCode: data.kodeEquipment,
                                  value: v,
                                  isAreaBloc: true));
                        },
                        onNotDetectedChanged: (v) {
                          areaBloc.add(
                              ChangeDetectedStateAllServiceByEquipmentEvent(
                                  equipmentCode: data.kodeEquipment,
                                  value: v,
                                  isAreaBloc: true));
                          //       EformController.serviceBloc.add(
                          // ChangeDetectedStateAllServiceByEquipmentEvent(
                          //     equipmentCode: data.kodeEquipment,
                          //     value: v,
                          //     isAreaBloc: true));
                        },
                        onTap: () {
                          if (data.tipeCpl == 'Special') {
                            EformController.specialBtnOn.value = true;
                            //special job biasa unloading
                            if (jsonDecode(jsonDecode(dataTo))
                                .toString()
                                .isEmpty) {
                              log("tipe :special job Unloading");
                              EformController.searchInput.clear();
                              EformController.serviceBloc.add(
                                  GetTransactionSpecial(
                                      isAreaBloc: false,
                                      steps: 0,
                                      kodeEquipment: data.kodeEquipment,
                                      areaState: areaState));

                              //get retriving data ke area state
                              areaBloc.add(GetTransactionSpecial(
                                  isAreaBloc: true,
                                  steps: 0,
                                  kodeEquipment: data.kodeEquipment,
                                  areaState: areaState));
                              EformController.equipmentName.value =
                                  data.namaEquipment;
                              EformController.tipeCpl.value = data.tipeCpl;
                              EformController.equipmentCode.value =
                                  data.kodeEquipment;
                              EformController.indexEquipment.value = i + 1;
                              EformController.eqpTo = {};
                              EformController.indexPage.value =
                                  eformStepSpecialJob;
                              EformController.equipmentCollection.value =
                                  equipmentState.equipmentsByCpl;
                              EformController.scroll.jumpTo(0);
                            } else {
                              log("special job TF");
                              //special job transfer
                              EformController.searchInput.clear();
                              EformController.eqpTo = listMapTo;
                              EformController.serviceBloc.add(
                                  GetTransactionSpecial(
                                      isAreaBloc: false,
                                      steps: 0,
                                      kodeEquipment: data.kodeEquipment,
                                      areaState: areaState));
                              areaBloc.add(GetTransactionSpecial(
                                  isAreaBloc: true,
                                  steps: 0,
                                  kodeEquipment: data.kodeEquipment,
                                  areaState: areaState));
                              EformController.equipmentName.value =
                                  data.namaEquipment;
                              EformController.tipeCpl.value = data.tipeCpl;
                              EformController.equipmentCode.value =
                                  data.kodeEquipment;
                              EformController.indexEquipment.value = i + 1;
                              EformController.indexPage.value =
                                  eformStepSpecialJob;
                              EformController.equipmentCollection.value =
                                  equipmentState.equipmentsByCpl;
                              EformController.scroll.jumpTo(0);
                            }
                          } else {
                            EformController.specialBtnOn.value = false;
                            EformController.searchInput.clear();
                            areaBloc.add(GetServiceByEquipmentEvent(
                                kodeEquipment: data.kodeEquipment,
                                areaState: areaState,
                                steps: ""));
                            EformController.serviceBloc.add(
                                GetServiceByEquipmentEvent(
                                    kodeEquipment: data.kodeEquipment,
                                    areaState: areaState,
                                    steps: ""));
                            EformController.equipmentName.value =
                                data.namaEquipment;
                            EformController.equipmentCode.value =
                                data.kodeEquipment;
                            EformController.indexEquipment.value = i + 1;
                            EformController.indexPage.value = eformStepService;
                            EformController.equipmentCollection.value =
                                equipmentState.equipmentsByCpl;
                            EformController.scroll.jumpTo(0);
                          }
                        },
                      ),
                    );
                  }),
        ),
      );

// cek transaction special step
  Widget specialJobCheckingList() {
    return BlocBuilder<EFormBloc, EFormState>(
        bloc: areaBloc,
        builder: (context, areaState) => BlocBuilder<EFormBloc, EFormState>(
              bloc: EformController.equipmentBloc,
              builder: (context, equipmentState) {
                //equipment collection
                bool isStep2 = false;
                SpecialJobType sJobCondition = SpecialJobType.newTrx;
                //proses in here
                return BlocBuilder<EFormBloc, EFormState>(
                  bloc: EformController.serviceBloc,
                  builder: (context, serviceState) {
                    //checking is special unloading / transfer

                    var isSpecialTransfer = false;
                    //if from standard flow -> using equipment
                    if (EformController.fromHomePage.value.isEmpty) {
                      if (serviceState.servicesByEquipment.isEmpty) {
                      } else {
                        if (serviceState
                            .servicesByEquipment.first.to.isNotEmpty) {
                          var checkTo = (jsonDecode(jsonDecode(
                                  serviceState.servicesByEquipment.first.to)))
                              .toString();
                          isSpecialTransfer = checkTo.isNotEmpty;
                        }
                      }
                    } else {
                      //from history
                      if (serviceState.servicesByStep.isNotEmpty) {
                        if (serviceState
                            .servicesByStep.first.controlTf.isNotEmpty) {
                          isSpecialTransfer = true;
                        }
                      } else {
                        //from step normal flow
                        if (EformController.eqpTo.values.isNotEmpty) {
                          isSpecialTransfer = true;
                        } else {
                          isSpecialTransfer = false;
                        }
                      }
                    }

                    //unloading
                    if (!isSpecialTransfer) {
                      //new trx or Continue(),
                      if (EformController.fromHomePage.value.isNotEmpty) {
                        //from history
                        log("From history");
                        var isContinue =
                            serviceState.servicesByStep.first.amount >
                                0; //isContinue
                        if (isContinue) {
                          //if continue step
                          //check of the last step entry
                          var checkStep2 = serviceState
                              .transactionsSpecialJob.transactions
                              .where((tr) => tr.steps == "2")
                              .toList();
                          isStep2 = checkStep2
                              .where((e) => e.textValue.isEmpty)
                              .toList()
                              .isNotEmpty; //if not empty step 3
                          var isContinue = checkStep2.first.unloadingContinue();
                          if (isStep2) {
                            isStep2 = false;
                            sJobCondition = SpecialJobType.continueTrx;
                            EformController.uuidSelected.value = serviceState
                                .transactionsSpecialJob.transactions[0].uuid;
                            log(" continue 2");
                          } else {
                            if (isContinue) {
                              //next step
                              log("finish 3");
                              sJobCondition = SpecialJobType.finishTrx;
                            } else {
                              isStep2 = false;
                              sJobCondition = SpecialJobType.continueTrx;
                              EformController.uuidSelected.value = serviceState
                                  .transactionsSpecialJob.transactions[0].uuid;
                              log(" continue 2");
                            }
                          }
                        } else {
                          log("new");
                          sJobCondition = SpecialJobType.newTrx;
                        }
                      } else {
                        var isContinue =
                            serviceState.servicesByEquipment.first.fiA1Amount >
                                0; //isContinue
                        //from equipment
                        if (isContinue) {
                          //if continue step
                          //check of the last step entry
                          var checkStep2 = serviceState
                              .transactionsSpecialJob.transactions
                              .where((tr) => tr.steps == "2")
                              .toList();
                          isStep2 = checkStep2
                              .where((e) => e.textValue.isEmpty)
                              .toList()
                              .isNotEmpty; //if not empty step 3
                          var isContinue = checkStep2.first.unloadingContinue();
                          if (isStep2) {
                            isStep2 = false;
                            sJobCondition = SpecialJobType.continueTrx;
                            EformController.uuidSelected.value = serviceState
                                .transactionsSpecialJob.transactions[0].uuid;
                            log(" continue 2");
                          } else {
                            if (isContinue) {
                              //next step
                              log("finish 3");
                              sJobCondition = SpecialJobType.finishTrx;
                            } else {
                              isStep2 = false;
                              sJobCondition = SpecialJobType.continueTrx;
                              EformController.uuidSelected.value = serviceState
                                  .transactionsSpecialJob.transactions[0].uuid;
                              log(" continue 2");
                            }
                          }
                        } else {
                          log("new");
                          sJobCondition = SpecialJobType.newTrx;
                        }
                      }
                      log("special unloading list");
                      return specialJobUnloadingListStatus(
                          areaState, equipmentState, sJobCondition);
                    } else {
                      log("special transfer list");

                      //new trx or Continue(),
                      bool isNew = false;
                      if (serviceState.servicesByEquipment.isNotEmpty) {
                        if (serviceState.servicesByStep.isEmpty) {
                          log("From non history");
                        }
                        //  log("From non history");
                        //from non history
                        bool isNew = false;
                        isNew = serviceState.servicesByEquipment
                            .where((e) => e.step == "1")
                            .first
                            .textValue
                            .isEmpty;
                        if (!isNew) {
                          //if continue step
                          //check of the last step entry
                          var checkStep2 = serviceState
                              .transactionsSpecialJob.transactions
                              .where((tr) => tr.steps == "2")
                              .toList();
                          isStep2 = checkStep2
                              .where((e) => e.textValue.isEmpty)
                              .toList()
                              .isNotEmpty; //if not empty step 3
                          if (isStep2) {
                            isStep2 = false;
                            sJobCondition = SpecialJobType.continueTrx;
                            EformController.uuidSelected.value = serviceState
                                .transactionsSpecialJob.transactions[0].uuid;
                            log(" continue 2");
                          } else {
                            EformController.uuidSelected.value = serviceState
                                .transactionsSpecialJob.transactions[0].uuid;
                            sJobCondition = SpecialJobType.finishTrx;
                            log(" continue 3");
                          }
                        } else {
                          sJobCondition = SpecialJobType.newTrx;
                        }
                      } else {
                        log("history transfer");
                        isNew = serviceState.servicesByStep
                            .where((e) => e.step == "1")
                            .first
                            .textValue
                            .isEmpty;
                        if (!isNew) {
                          //if continue step
                          //check of the last step entry
                          var checkStep2 = serviceState
                              .transactionsSpecialJob.transactions
                              .where((tr) => tr.steps == "2")
                              .toList();
                          isStep2 = checkStep2
                              .where((e) => e.textValue.isEmpty)
                              .toList()
                              .isNotEmpty; //if not empty step 3
                          if (isStep2) {
                            isStep2 = false;
                            sJobCondition = SpecialJobType.continueTrx;
                            EformController.uuidSelected.value = serviceState
                                .transactionsSpecialJob.transactions[0].uuid;
                            log(" continue 2");
                          } else {
                            sJobCondition = SpecialJobType.finishTrx;
                            log(" continue 3");
                          }
                        } else {
                          sJobCondition = SpecialJobType.newTrx;
                        }
                      }
                      return specialJobTransferListStatus(
                          areaState, equipmentState, sJobCondition);
                    }
                  },
                );
              },
            ));
  }

  Widget specialJobUnloadingListStatus(EFormState areaState,
      EFormState equipmentState, SpecialJobType sJobCondition) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            log("new unloading");
            if (sJobCondition == SpecialJobType.newTrx) {
              var equipmentCode = EformController.equipmentCode.value;
              var stepIndexPage = EformController.indexPage.value;
              EformController.searchInput.clear();
              EformController.serviceBloc.add(GetServiceSpecialUnloadingStep(
                  newTransaction: true,
                  steps: 0,
                  kodeEquipment: equipmentCode,
                  areaState: areaState));
              EformController.equipmentName.value =
                  EformController.equipmentName.value;
              EformController.tipeCpl.value = EformController.tipeCpl.value;
              EformController.equipmentCode.value = equipmentCode;

              EformController.indexEquipment.value =
                  EformController.indexEquipment.value + 1;
              log("cek equipment code $equipmentCode  index $stepIndexPage");
              EformController.eqpTo = {};
              EformController.indexPage.value = eformStepSpecialJobForm;
              EformController.equipmentCollection.value =
                  equipmentState.equipmentsByCpl;
            }
          },
          child: Card(
              color: Colors.white,
              margin: const EdgeInsets.only(left: 10, right: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Container(
                margin: const EdgeInsetsDirectional.all(8.0),
                width: AppUtil.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Text(
                        "New",
                        style: TextStyle(
                            color: sJobCondition == SpecialJobType.newTrx
                                ? Colors.black
                                : Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            if (sJobCondition == SpecialJobType.continueTrx) {
              //goto step 2
              setState(() {
                _currentStep = 1;
              });
              log("continue unloading");
              var equipmentCode = EformController.equipmentCode.value;
              var stepIndexPage = EformController.indexPage.value;
              EformController.searchInput.clear();
              EformController.serviceBloc.add(GetServiceSpecialUnloadingStep(
                  newTransaction: false,
                  steps: 1,
                  kodeEquipment: equipmentCode,
                  areaState: areaState));

              areaBloc.add(GetServiceSpecialUnloadingStep(
                  isAreaBloc: true,
                  newTransaction: false,
                  steps: 1,
                  kodeEquipment: equipmentCode,
                  areaState: areaState));
              EformController.equipmentName.value =
                  EformController.equipmentName.value;
              EformController.tipeCpl.value = EformController.tipeCpl.value;
              EformController.equipmentCode.value = equipmentCode;

              EformController.indexEquipment.value =
                  EformController.indexEquipment.value + 1;
              log("cek equipment code $equipmentCode  index $stepIndexPage");
              EformController.eqpTo = {};
              EformController.indexPage.value = eformStepSpecialJobForm;
              EformController.equipmentCollection.value =
                  equipmentState.equipmentsByCpl;
            }
          },
          child: Card(
              color: Colors.white,
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Container(
                margin: const EdgeInsetsDirectional.all(8.0),
                width: AppUtil.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Text(
                        "Continue",
                        style: TextStyle(
                            color: sJobCondition == SpecialJobType.continueTrx
                                ? Colors.black
                                : Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            if (sJobCondition == SpecialJobType.finishTrx) {
              //goto step 2
              setState(() {
                _currentStep = 2;
              });
              log("continue unloading");
              var equipmentCode = EformController.equipmentCode.value;
              var stepIndexPage = EformController.indexPage.value;
              EformController.searchInput.clear();
              EformController.serviceBloc.add(GetServiceSpecialUnloadingStep(
                  newTransaction: false,
                  steps: 2,
                  uuid: EformController.uuidSelected.value,
                  kodeEquipment: equipmentCode,
                  areaState: areaState));

              areaBloc.add(GetServiceSpecialUnloadingStep(
                  newTransaction: false,
                  isAreaBloc: true,
                  uuid: EformController.uuidSelected.value,
                  steps: 2,
                  kodeEquipment: equipmentCode,
                  areaState: areaState));
              EformController.equipmentName.value =
                  EformController.equipmentName.value;
              EformController.tipeCpl.value = EformController.tipeCpl.value;
              EformController.equipmentCode.value = equipmentCode;

              EformController.indexEquipment.value =
                  EformController.indexEquipment.value + 1;
              log("cek equipment code $equipmentCode  index $stepIndexPage");
              EformController.eqpTo = {};
              EformController.indexPage.value = eformStepSpecialJobForm;
              EformController.equipmentCollection.value =
                  equipmentState.equipmentsByCpl;
            }
          },
          child: Card(
              color: Colors.white,
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Container(
                margin: const EdgeInsetsDirectional.all(8.0),
                width: AppUtil.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Text(
                        "Finish",
                        style: TextStyle(
                            color: sJobCondition == SpecialJobType.finishTrx
                                ? Colors.black
                                : Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
      const SizedBox(height: 12),
    ]);
  }

  Widget specialJobTransferListStatus(EFormState areaState,
      EFormState equipmentState, SpecialJobType sJobCondition) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            if (sJobCondition == SpecialJobType.newTrx) {
              var equipmentCode = EformController.equipmentCode.value;
              var stepIndexPage = EformController.indexPage.value;
              EformController.searchInput.clear();
              EformController.serviceBloc.add(GetServiceSpecialTransferStep(
                  newTransaction: true,
                  steps: 0,
                  kodeEquipment: equipmentCode,
                  areaState: areaState));
              EformController.equipmentName.value =
                  EformController.equipmentName.value;
              EformController.tipeCpl.value = EformController.tipeCpl.value;
              EformController.equipmentCode.value = equipmentCode;

              EformController.indexEquipment.value =
                  EformController.indexEquipment.value + 1;
              log("cek equipment code $equipmentCode  index $stepIndexPage");
              EformController.eqpTo = {};
              EformController.indexPage.value = eformStepSpecialJobForm;
              EformController.equipmentCollection.value =
                  equipmentState.equipmentsByCpl;
            }
          },
          child: Card(
              color: Colors.white,
              margin: const EdgeInsets.only(left: 10, right: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Container(
                margin: const EdgeInsetsDirectional.all(8.0),
                width: AppUtil.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Text(
                        "New",
                        style: TextStyle(
                            color: sJobCondition == SpecialJobType.newTrx
                                ? Colors.black
                                : Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            if (sJobCondition == SpecialJobType.finishTrx) {
              //goto step 2
              setState(() {
                _currentStep = 2;
              });
              log("continue tf");
              var equipmentCode = EformController.equipmentCode.value;
              var stepIndexPage = EformController.indexPage.value;
              EformController.searchInput.clear();
              areaBloc.add(GetServiceSpecialTransferStep(
                  isAreaBloc: true,
                  newTransaction: false,
                  steps: 2,
                  uuid: EformController.uuidSelected.value,
                  kodeEquipment: equipmentCode,
                  areaState: areaState));
              EformController.serviceBloc.add(GetServiceSpecialTransferStep(
                  newTransaction: false,
                  steps: 2,
                  uuid: EformController.uuidSelected.value,
                  kodeEquipment: equipmentCode,
                  areaState: areaState));

              EformController.equipmentName.value =
                  EformController.equipmentName.value;
              EformController.tipeCpl.value = EformController.tipeCpl.value;
              EformController.equipmentCode.value = equipmentCode;

              EformController.indexEquipment.value =
                  EformController.indexEquipment.value + 1;
              log("cek equipment code $equipmentCode  index $stepIndexPage");
              EformController.eqpTo = {};
              EformController.indexPage.value = eformStepSpecialJobForm;
              EformController.equipmentCollection.value =
                  equipmentState.equipmentsByCpl;
            }
          },
          child: Card(
              color: Colors.white,
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Container(
                margin: const EdgeInsetsDirectional.all(8.0),
                width: AppUtil.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Text(
                        "Continue",
                        style: TextStyle(
                            color: sJobCondition == SpecialJobType.finishTrx
                                ? Colors.black
                                : Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
      const SizedBox(height: 12),
    ]);
  }

  Widget serviceSection() => BlocBuilder<EFormBloc, EFormState>(
        bloc: EformController.serviceBloc,
        builder: (context, serviceState) => Expanded(
          child: serviceState.servicesByEquipment.isEmpty
              ? EmptyStateWidget(label: 'Service')
              : ValueListenableBuilder(
                  valueListenable: EformController.searchService,
                  builder: (context, search, child) {
                    return BlocBuilder<EFormBloc, EFormState>(
                        bloc: areaBloc,
                        builder: (context, areaState) {
                          List<Service> listService = [];
                          if (search.isNotEmpty) {
                            listService = serviceState.servicesByEquipment
                                .where((e) => e.tag.contains(search.toString()))
                                .toList();
                          } else {
                            listService = serviceState.servicesByEquipment;
                          }
                          var editAble =
                              !listService.first.isSync; //sync == not editable
                          //listService.first.editable;
                          log("info editable ?$editAble");
                          EformController.detectEditableManualService.value =
                              editAble;
                          return ListView.builder(
                              controller: EformController.scroll,
                              itemCount: listService.length,
                              itemBuilder: (context, i) {
                                Service data;
                                data = listService[i];
                                final input = TextEditingController();
                                if (data.textValue.isNotEmpty) {
                                  input.text = data.textValue;
                                  input.selection = TextSelection.fromPosition(
                                      TextPosition(offset: input.text.length));
                                }
                                return ServiceForm(
                                  label: data.namaService,
                                  tag: data.tag,
                                  editan: true,
                                  isEnabled: editAble,
                                  type: data.formType(),
                                  formatForm: "Standard",
                                  unit: data.unit,
                                  options: data.getValueOptions(),
                                  selectedOption: data.textValue,
                                  bottomHint: data.getRange(),
                                  stop: data.checkBox == 1,
                                  notDetected: data.checkBox == 2,
                                  input: input,
                                  warning: data.isWarning(),
                                  onWarningTap: () {
                                    if (editAble) {
                                      Navigator.pushNamed(
                                          context, warningReportRoute,
                                          arguments: WarningReportArgs(
                                              description: areaState
                                                      .transactions
                                                      .transactions
                                                      .isEmpty
                                                  ? data.reportedDescription
                                                  : areaState.transactions
                                                          .transactions
                                                          .firstWhere(
                                                              (e) =>
                                                                  e.idService ==
                                                                  data
                                                                      .idService,
                                                              orElse: () =>
                                                                  const Transaction())
                                                          .reportedDescription
                                                          .isEmpty
                                                      ? data.reportedDescription
                                                      : areaState.transactions
                                                          .transactions
                                                          .firstWhere((e) =>
                                                              e.idService ==
                                                              data.idService)
                                                          .reportedDescription,
                                              serviceCode: data.idService,
                                              areaBloc: areaBloc,
                                              serviceBloc: EformController.serviceBloc,
                                              label: data.namaService,
                                              tag: data.tag));
                                    }
                                  },
                                  onInputChanged: (v) {
                                    EformController.serviceBloc.add(
                                        ChangeTextValueStateServiceByEquipmentEvent(
                                            idService: data.idService,
                                            value: v));
                                    areaBloc.add(
                                        ChangeTextValueStateServiceByEquipmentEvent(
                                            idService: data.idService,
                                            value: v,
                                            isAreaBloc: true));
                                  },
                                  onNotDetectedChanged: (v) {
                                    if (editAble) {
                                      EformController.serviceBloc.add(
                                          ChangeDetectedStateServiceByEquipmentEvent(
                                              idService: data.idService,
                                              value: v));
                                      areaBloc.add(
                                          ChangeDetectedStateServiceByEquipmentEvent(
                                              idService: data.idService,
                                              value: v,
                                              isAreaBloc: true));
                                    }
                                  },
                                  onStopChanged: (v) {
                                    if (editAble) {
                                      EformController.serviceBloc.add(
                                          ChangeStopStateServiceByEquipmentEvent(
                                              idService: data.idService,
                                              value: v));
                                      areaBloc.add(
                                          ChangeStopStateServiceByEquipmentEvent(
                                              idService: data.idService,
                                              value: v,
                                              isAreaBloc: true));
                                    }
                                  },
                                  onRadioChanged: (v) {
                                    v as String;
                                    EformController.serviceBloc.add(
                                        ChangeTextValueStateServiceByEquipmentEvent(
                                            idService: data.idService,
                                            value: v,
                                            isRadio: true));
                                    areaBloc.add(
                                        ChangeTextValueStateServiceByEquipmentEvent(
                                            idService: data.idService,
                                            value: v,
                                            isAreaBloc: true,
                                            isRadio: true));
                                  },
                                );
                              });
                        });
                  }),
        ),
      );

  //tipe /transfer
  Widget specialTransferSectionStep(int step) =>
      BlocBuilder<EFormBloc, EFormState>(
          bloc: EformController.serviceBloc,
          builder: (context, serviceState) => SizedBox(
                height: AppUtil.height - 120,
                child: serviceState.servicesByStep.isEmpty
                    ? EmptyStateWidget(label: 'Service')
                    : BlocBuilder<EFormBloc, EFormState>(
                        bloc: areaBloc,
                        builder: (context, areaState) {
                          return ListView.builder(
                              controller: EformController.scroll,
                              itemCount: serviceState.servicesByStep.length,
                              itemBuilder: (context, i) {
                                var data = serviceState.servicesByStep[i];
                                final input = TextEditingController();
                                if (data.textValue.isNotEmpty) {
                                  input.text = data.textValue;
                                  input.selection = TextSelection.fromPosition(
                                      TextPosition(offset: input.text.length));
                                }
                                var checkDisable = data.editable;
                                var disableStep1n2 =
                                    data.selectedTo.isNotEmpty &&
                                        data.textValue.isNotEmpty;
                                var disableForm = false;
                                if (step <= 2) {
                                  disableForm = !disableStep1n2;
                                } else {
                                  disableForm = true;
                                }
                                log("editable input  $checkDisable  ");
                                // log("nama servc $data.namaService");
                                return ServiceFormUnloading(
                                  label: data.namaService,
                                  tag: data.tag,
                                  isEnabled: checkDisable,
                                  type: data.formType(),
                                  formatForm: "Special",
                                  tipeSpecial: 'transfer',
                                  unit: data.unit,
                                  options: data.getValueOptions(),
                                  selectedOption: data.textValue,
                                  bottomHint: data.getRange(),
                                  stop: data.checkBox == 1,
                                  notDetected: data.checkBox == 2,
                                  input: input,
                                  warning: data.isWarning(),
                                  onWarningTap: () {},
                                  onInputChanged: (v) {
                                    EformController.serviceBloc.add(
                                        ChangeTextValueStateServiceByStepTransferEvent(
                                            idService: data.idService,
                                            value: v,
                                            step: step,
                                            shipName: EformController
                                                .inputShipName.text));
                                    areaBloc.add(
                                        ChangeTextValueStateServiceByStepTransferEvent(
                                            idService: data.idService,
                                            value: v,
                                            step: step,
                                            shipName: EformController
                                                .inputShipName.text,
                                            isAreaBloc: true));
                                  },
                                  onNotDetectedChanged: (v) {},
                                  onStopChanged: (v) {},
                                  onRadioChanged: (v) {},
                                );
                              });
                        },
                      ),
              ));

  Widget specialSectionStepUnloading(int step) =>
      BlocBuilder<EFormBloc, EFormState>(
          bloc: EformController.serviceBloc,
          builder: (context, serviceState) => SizedBox(
                height: AppUtil.height - 120,
                child: serviceState.servicesByStep.isEmpty
                    ? EmptyStateWidget(label: 'Service')
                    : BlocBuilder<EFormBloc, EFormState>(
                        bloc: areaBloc,
                        builder: (context, areaState) {
                          //cek data yang sudah terisi yang berada di transaksi
                          return ListView.builder(
                              controller: EformController.scroll,
                              itemCount: serviceState.servicesByStep.length,
                              itemBuilder: (context, i) {
                                var data =
                                    serviceState.servicesByStep[i]; //service
                                final input = TextEditingController();
                                // if (step < 3) {
                                var dataTrx = serviceState.servicesByStep[i];

                                var isEditableStep1 = serviceState
                                    .servicesByStep[i]
                                    .isEditableStep1();
                                var isEditableStep2 = serviceState
                                    .servicesByStep[i]
                                    .isEditableStep2();
                                var isEditableStep3 = serviceState
                                    .servicesByStep[i]
                                    .isEditableStep3();
                                var isEditable = false;
                                if (step == 1) {
                                  isEditable = isEditableStep1;
                                } else if (step == 2) {
                                  isEditable = isEditableStep2;
                                } else {
                                  isEditable = !isEditableStep3;
                                }
                                if (dataTrx.textValue.isNotEmpty) {
                                  input.text = dataTrx.textValue;
                                  input.selection = TextSelection.fromPosition(
                                      TextPosition(offset: input.text.length));
                                }
                                return ServiceFormUnloading(
                                  label: data.namaService,
                                  tag: data.tag,
                                  isEnabled: !isEditable,
                                  type: data.formType(),
                                  formatForm: "Special",
                                  tipeSpecial: 'unloading',
                                  planning: '',
                                  resultPlanning: 0,
                                  unit: data.unit,
                                  options: data.getValueOptions(),
                                  selectedOption: data.textValue,
                                  bottomHint: data.getRange(),
                                  stop: false,
                                  notDetected: data.checkBox == 2,
                                  input: input,
                                  warning: data.isWarning(),
                                  onWarningTap: () {},
                                  onInputChanged: (v) {
                                    log("step update:$step");
                                    EformController.serviceBloc.add(
                                        ChangeTextValueStateServiceByStepUnloadingEvent(
                                            isSpecialJob: true,
                                            idService: data.idService,
                                            value: v,
                                            step: step,
                                            shipName: EformController
                                                .inputShipName.text));
                                    areaBloc.add(
                                        ChangeTextValueStateServiceByStepUnloadingEvent(
                                            idService: data.idService,
                                            isSpecialJob: true,
                                            value: v,
                                            step: step,
                                            shipName: EformController
                                                .inputShipName.text,
                                            isAreaBloc: true));
                                  },
                                  onNotDetectedChanged: (v) {},
                                  onStopChanged: (v) {},
                                  onRadioChanged: (v) {},
                                );
                              });
                        },
                      ),
              ));

  String? selectedItemTo, selectedControl;
  int? selectedIndexTo, selectedIndexControl;

  Widget specialSection() => Theme(
        data: ThemeData(
          useMaterial3: false,
          cardColor: Colors.white,
          primaryColor: Colors.black,
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: Colors.green,
                background: Colors.white,
                secondary: Colors.green,
              ),
          textTheme: const TextTheme(
            bodySmall: TextStyle(
                color: Colors.red), // Color for step numbers and titles
          ),
        ),
        child: BlocBuilder<EFormBloc, EFormState>(
            bloc: EformController.serviceBloc,
            builder: (context, serviceState) {
              List<String>? itemStep1, itemStep2, itemStep3;
              bool isSpecialTf = false;
              Map<String, List<String>> listMapTo = {};
              var cTo = serviceState.servicesByStep.isNotEmpty
                  ? serviceState.servicesByStep.first.to
                  : '';
              log('cto is $cTo');
              if (cTo.isNotEmpty) {
                var checkTo = (jsonDecode(jsonDecode(cTo))).toString();
                if (checkTo.isNotEmpty) {
                  var lengthTo = (jsonDecode(jsonDecode(cTo)) as List).length;
                  if (jsonDecode(jsonDecode(cTo)).toString().isNotEmpty) {
                    for (var i = 0; i < lengthTo; i++) {
                      var itemTo = (jsonDecode(jsonDecode(cTo))[i]
                              as Map<String, dynamic>)
                          .cast();
                      var mkeys = itemTo.keys.first;
                      var indexs = mkeys;
                      if (itemTo[indexs][0] != "") {
                        var item = itemTo[indexs];
                        List<String> icastStr = item.cast<String>();
                        listMapTo[indexs] = icastStr;
                        EformController.eqpTo = listMapTo;
                        log("map to $listMapTo");
                      }
                    }
                  }
                  isSpecialTf = true;
                  itemStep1 = EformController.eqpTo['1'];
                  itemStep2 = EformController.eqpTo['2'];
                  itemStep3 = EformController.eqpTo['3'];
                } else {
                  //unloading
                  isSpecialTf = false;
                }
              }

              log("special transfer ? $isSpecialTf");
              //transfer
              if (isSpecialTf) {
                log("enter tf");
                return specialJobTransferSection(
                    serviceState, itemStep1, itemStep2, itemStep3, isSpecialTf);
              } else {
                //unloading
                log("enter unloading");
                return specialJobUnloadingSection(serviceState);
              }
            }),
      );

  Widget specialJobUnloadingSection(EFormState serviceState) {
    var isEditSteps1 = serviceState.servicesByStep.isNotEmpty
        ? !serviceState.servicesByStep[0].isEditableStep1()
        : true;

    var isEditSteps2 = serviceState.servicesByStep.isNotEmpty
        ? !serviceState.servicesByStep[0].disableStep2()
        : true;

    var isEditSteps3 = serviceState.servicesByStep.isNotEmpty
        ? !serviceState.servicesByStep[0].isEditableStep3()
        : true;

    var isContinue = serviceState.servicesByStep.isNotEmpty
        ? serviceState.servicesByStep[0].continueStep2()
        : false;
    return BlocBuilder<EFormBloc, EFormState>(
        bloc: areaBloc,
        builder: (context, areaState) {
          //stepper eform1
          return Expanded(
            child: Stepper(
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                return Row(
                  mainAxisAlignment: _currentStep == 1
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.center,
                  children: [
                    if (_currentStep < 1)
                      const SizedBox()
                    else //unloading
                      _currentStep == 1 //step 2 Save Only
                          ? Row(
                              children: [
                                SizedBox(
                                  width: AppUtil.width / 3,
                                  child: BlocBuilder<EFormBloc, EFormState>(
                                    bloc: EformController.serviceBloc,
                                    builder: (context, btnState) {
                                      var disableStep2 = btnState.servicesByStep
                                              .where((st2) =>
                                                  st2.textValue != "" &&
                                                  st2.fiB1Amount > 0 &&
                                                  st2.estUnloadingB1MinA > 0)
                                              .toList()
                                              .isNotEmpty &&
                                          btnState
                                              .servicesByStep.first.isContinue;
                                      if (isContinue) {
                                        disableStep2 = false;
                                      } else {
                                        disableStep2 = disableStep2;
                                      }
                                      return ElevatedButton(
                                        onPressed: () {
                                          // finish step 3
                                          if (_currentStep == 1) {
                                            //on step 2
                                            log("save new trx unloading on step 2 ");
                                            log("b1m1 ${EformController.inputB1minA.text}");
                                            log("b1 ${EformController.inputB1Amount.text}");

                                            areaBloc.add(
                                                SaveNewEFormUnloadingSJTransactionEvent(
                                                    isAreaBloc: true,
                                                    verify: true,
                                                    isContinue: false,
                                                    areaState: areaState,
                                                    codeEquipment: serviceState
                                                        .kodeEquipment,
                                                    step: 2,
                                                    typeForm: 'unloading',
                                                    step2: InsertStep2(
                                                        estimateUnloadingB1minA1:
                                                            EformController
                                                                .inputB1minA
                                                                .text,
                                                        sumB1: EformController
                                                            .inputB1Amount
                                                            .text),
                                                    isSpecialJob: true,
                                                    onFinish: () {
                                                      setState(() {
                                                        _currentStep += 1;
                                                      });
                                                      // EformController.reset();
                                                      log("page ${EformController.indexPage.value}");
                                                      if (EformController
                                                                  .indexPage
                                                                  .value ==
                                                              eformStepSpecialJobForm &&
                                                          EformController
                                                              .equipmentCollection
                                                              .value
                                                              .isNotEmpty) {
                                                        log("back to equipment");
                                                        EformController
                                                                .indexPage
                                                                .value =
                                                            EformController
                                                                    .indexPage
                                                                    .value -
                                                                3;
                                                      }
                                                    }));

                                            EformController.serviceBloc.add(
                                                SaveNewEFormUnloadingSJTransactionEvent(
                                                    isAreaBloc: false,
                                                    areaState: areaState,
                                                    isContinue: false,
                                                    verify: false,
                                                    typeForm: 'unloading',
                                                    codeEquipment: serviceState
                                                        .kodeEquipment,
                                                    step: 2,
                                                    step2: InsertStep2(
                                                        estimateUnloadingB1minA1:
                                                            EformController
                                                                .inputB1minA
                                                                .text,
                                                        sumB1: EformController
                                                            .inputB1Amount
                                                            .text),
                                                    isSpecialJob: true,
                                                    onFinish: () {
                                                      log("Back To Equipment");
                                                    }));
                                          }
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  disableStep2
                                                      ? kGreyLight
                                                      : kGreenPrimary),
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  disableStep2
                                                      ? const Color.fromARGB(
                                                          255, 170, 127, 127)
                                                      : Colors
                                                          .white), // Text color
                                        ),
                                        child: const Text(
                                          'Save',
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 7,
                                ),
                                SizedBox(
                                  width: AppUtil.width / 3,
                                  child: BlocBuilder<EFormBloc, EFormState>(
                                    bloc: EformController.serviceBloc,
                                    builder: (context, btnState) {
                                      var disableStep2 = btnState.servicesByStep
                                              .where((st2) =>
                                                  st2.textValue != "" &&
                                                  st2.fiB1Amount > 0 &&
                                                  st2.estUnloadingB1MinA > 0)
                                              .toList()
                                              .isNotEmpty &&
                                          btnState
                                              .servicesByStep.first.isContinue;
                                      if (isContinue) {
                                        disableStep2 = false;
                                      } else {
                                        disableStep2 = disableStep2;
                                      }
                                      return ElevatedButton(
                                        onPressed: () {
                                          // Finish ->
                                          if (_currentStep == 1) {
                                            //on step 2
                                            log("save new trx unloading on step 2 ");
                                            log("b1m1 ${EformController.inputB1minA.text}");
                                            log("b1 ${EformController.inputB1Amount.text}");

                                            areaBloc.add(
                                                SaveNewEFormUnloadingSJTransactionEvent(
                                                    isAreaBloc: true,
                                                    isContinue: true,
                                                    verify: true,
                                                    areaState: areaState,
                                                    codeEquipment: serviceState
                                                        .kodeEquipment,
                                                    step: 2,
                                                    typeForm: 'unloading',
                                                    step2: InsertStep2(
                                                        estimateUnloadingB1minA1:
                                                            EformController
                                                                .inputB1minA
                                                                .text,
                                                        sumB1: EformController
                                                            .inputB1Amount
                                                            .text),
                                                    isSpecialJob: true,
                                                    onFinish: () {
                                                      setState(() {
                                                        _currentStep += 1;
                                                      });
                                                      // EformController.reset();
                                                      log("page ${EformController.indexPage.value}");
                                                      if (EformController
                                                                  .indexPage
                                                                  .value ==
                                                              eformStepSpecialJobForm &&
                                                          EformController
                                                              .equipmentCollection
                                                              .value
                                                              .isNotEmpty) {
                                                        log("back to equipment");
                                                        EformController
                                                                .indexPage
                                                                .value =
                                                            EformController
                                                                    .indexPage
                                                                    .value -
                                                                3;
                                                      }
                                                    }));

                                            EformController.serviceBloc.add(
                                                SaveNewEFormUnloadingSJTransactionEvent(
                                                    isAreaBloc: false,
                                                    isContinue: true,
                                                    areaState: areaState,
                                                    verify: false,
                                                    typeForm: 'unloading',
                                                    codeEquipment: serviceState
                                                        .kodeEquipment,
                                                    step: 2,
                                                    step2: InsertStep2(
                                                        estimateUnloadingB1minA1:
                                                            EformController
                                                                .inputB1minA
                                                                .text,
                                                        sumB1: EformController
                                                            .inputB1Amount
                                                            .text),
                                                    isSpecialJob: true,
                                                    onFinish: () {
                                                      log("next step service state$_currentStep");
                                                    }));
                                          }
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  disableStep2
                                                      ? kGreyLight
                                                      : kBlueButton),
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  disableStep2
                                                      ? const Color.fromARGB(
                                                          255, 170, 127, 127)
                                                      : Colors
                                                          .white), // Text color
                                        ),
                                        child: const Text(
                                          'Finish',
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                    const SizedBox(
                      width: 10,
                    ),
                    //right button
                    _currentStep != 2
                        ? const SizedBox()
                        : BlocBuilder<EFormBloc, EFormState>(
                            bloc: EformController.serviceBloc,
                            builder: (context, btnState) {
                              var disableStep3 = btnState.servicesByStep
                                  .where((st1) =>
                                      st1.textValue != "" &&
                                      st1.amount > 0 &&
                                      st1.estUnloadingB2MinB1 > 0 &&
                                      st1.shipName.isNotEmpty)
                                  .toList()
                                  .isNotEmpty;
                              return Center(
                                child: SizedBox(
                                    width: AppUtil.width / 2,
                                    child: TextButton(
                                      style: !disableStep3
                                          ? ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(kGreenPrimary),
                                              foregroundColor:
                                                  MaterialStateProperty
                                                      .all<Color>(Colors
                                                          .white), // Text color
                                            )
                                          : ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.grey),
                                              foregroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Colors.grey.shade300),
                                            ),
                                      onPressed: () {
                                        if (!disableStep3) {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return BackdropFilter(
                                                  filter: ImageFilter.blur(
                                                      sigmaX: 6, sigmaY: 6),
                                                  child: AlertDialog(
                                                    title: const Center(
                                                        child: Text(
                                                      'Are you sure',
                                                      style: textStyleSubtitle,
                                                    )),
                                                    content: Container(
                                                        height: 150,
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .all(8.0),
                                                        child: Column(
                                                          children: [
                                                            const Center(
                                                                child: Text(
                                                              'Complete this Unloading ?',
                                                              style:
                                                                  textStyleSubtitleEform,
                                                            )),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                SizedBox(
                                                                  width: AppUtil
                                                                          .width /
                                                                      4,
                                                                  child:
                                                                      ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              AppUtil.context!)
                                                                          .pop();
                                                                      log("finish");
                                                                      areaBloc.add(SaveNewEFormUnloadingSJTransactionEvent(
                                                                          isAreaBloc: true,
                                                                          typeForm: 'unloading',
                                                                          isFinish: true,
                                                                          verify: true,
                                                                          areaState: areaState,
                                                                          codeEquipment: serviceState.kodeEquipment,
                                                                          step: 3,
                                                                          step3: InsertStep3(estimateUnloadingB2minB1: EformController.inputB2minB1.text, sumB2: EformController.inputB2Amount.text),
                                                                          isSpecialJob: true,
                                                                          onFinish: () {
                                                                            setState(() {
                                                                              _currentStep = 0;
                                                                            });
                                                                            EformController.reset();
                                                                            log("page ${EformController.indexPage.value}");
                                                                            if (EformController.indexPage.value == eformStepSpecialJobForm &&
                                                                                EformController.equipmentCollection.value.isNotEmpty) {
                                                                              log("back to equipment");
                                                                              EformController.indexPage.value = EformController.indexPage.value - 3;
                                                                            }
                                                                          }));

                                                                      EformController.serviceBloc.add(SaveNewEFormUnloadingSJTransactionEvent(
                                                                          isAreaBloc: false,
                                                                          typeForm: 'unloading',
                                                                          areaState: areaState,
                                                                          isFinish: true,
                                                                          verify: false,
                                                                          codeEquipment: serviceState.kodeEquipment,
                                                                          step: 3,
                                                                          step3: InsertStep3(estimateUnloadingB2minB1: EformController.inputB2minB1.text, sumB2: EformController.inputB2Amount.text),
                                                                          isSpecialJob: true,
                                                                          onFinish: () {
                                                                            log("finish");
                                                                          }));
                                                                    },
                                                                    style:
                                                                        ButtonStyle(
                                                                      backgroundColor:
                                                                          MaterialStateProperty.all<Color>(
                                                                              kGreenPrimary),
                                                                      foregroundColor: MaterialStateProperty.all<
                                                                              Color>(
                                                                          Colors
                                                                              .white), // Text color
                                                                    ),
                                                                    child:
                                                                        const Text(
                                                                      'Save',
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: AppUtil
                                                                          .width /
                                                                      4,
                                                                  child:
                                                                      ElevatedButton(
                                                                    onPressed:
                                                                        () => {
                                                                      Navigator.of(
                                                                              AppUtil.context!)
                                                                          .pop()
                                                                    },
                                                                    style:
                                                                        ButtonStyle(
                                                                      backgroundColor:
                                                                          MaterialStateProperty.all<Color>(
                                                                              kGreyLight),
                                                                      foregroundColor: MaterialStateProperty.all<
                                                                              Color>(
                                                                          Colors
                                                                              .black), // Text color
                                                                    ),
                                                                    child:
                                                                        const Text(
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
                                              });
                                        }
                                      },
                                      child: const Text(
                                        "Finish",
                                        style: TextStyle(
                                          color: Color(0xffffffff),
                                        ),
                                      ),
                                    )),
                              );
                            },
                          )
                  ],
                );
              },
              currentStep: _currentStep,
              type: StepperType.horizontal,
              onStepTapped: (step) {
                setState(() => _currentStep = step);
                EformController.serviceBloc.add(GetServiceSpecialUnloadingStep(
                    steps: step,
                    uuid: EformController.uuidSelected.value,
                    kodeEquipment: serviceState.kodeEquipment,
                    areaState: areaState));
              },
              onStepContinue: () {
                if (_currentStep < 2) {
                  // selectedIndex = null;
                  setState(() => _currentStep += 1);
                  EformController.serviceBloc.add(
                      GetServiceSpecialUnloadingStep(
                          steps: _currentStep,
                          kodeEquipment: serviceState.kodeEquipment,
                          areaState: areaState));
                  // areaBloc.add(GetServiceSpecialUnloadingStep(
                  //     steps: _currentStep,
                  //     kodeEquipment: serviceState.kodeEquipment,
                  //     areaState: areaState));
                } else {
                  log("finish");
                }
              },
              onStepCancel: () {
                _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
                EformController.serviceBloc.add(GetServiceSpecialStep(
                    steps: _currentStep,
                    kodeEquipment: serviceState.kodeEquipment,
                    areaState: areaState));

                areaBloc.add(GetServiceSpecialUnloadingStep(
                    steps: 0,
                    kodeEquipment: serviceState.kodeEquipment,
                    areaState: areaState));
              },
              physics: const ScrollPhysics(),
              steps: <Step>[
                Step(
                  title: const Text('Start'),
                  content:
                      // EformSpecialUnloading(authBloc: widget.authBloc,serviceBloc: EformController.serviceBloc,areaBloc: areaBloc, kodeEquipment: serviceState.kodeEquipment,)
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                        BlocBuilder<EFormBloc, EFormState>(
                          bloc: EformController.serviceBloc,
                          builder: (context, state) {
                            var shipName = state.servicesByStep.isNotEmpty
                                ? state.servicesByStep[0].shipName.toString()
                                : '';

                            var amount = state.servicesByStep.isNotEmpty
                                ? state.servicesByStep[0].amount == 0.0
                                    ? ''
                                    : state.servicesByStep[0].amount.toString()
                                : '';
                            var f1Amount = state.servicesByStep.isNotEmpty
                                ? state.servicesByStep[0].fiA1Amount.toString()
                                : '';
                            var isEditStep1 = state.servicesByStep.isNotEmpty
                                ? !state.servicesByStep[0].isEditableStep1()
                                : true;

                            log("step 1");
                            log("amount name : $amount");
                            log("sum A  : $f1Amount");
                            log("editable step 1  : $isEditStep1");
                            EformController.inputShipName.text = shipName;
                            EformController.inputFI21002A.text = f1Amount;
                            if (amount.isNotEmpty) {
                              EformController.inputS1Amount.text = amount;
                              EformController.inputS1Amount.selection =
                                  TextSelection.fromPosition(TextPosition(
                                      offset: EformController
                                          .inputS1Amount.text.length));
                            }

                            return Column(
                              children: [
                                Card(
                                    color: Colors.white,
                                    margin: const EdgeInsets.fromLTRB(
                                        10, 0, 10, 10),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 10,
                                                margin: const EdgeInsets.only(
                                                    bottom: 10),
                                                decoration: const BoxDecoration(
                                                    color: kGreen,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(8),
                                                            topRight:
                                                                Radius.circular(
                                                                    8))),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                child: Text(
                                                  "Ship Name",
                                                  style: TextStyle(
                                                      color: textBlack,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              const Divider(color: Colors.grey),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: SizedBox(
                                                  width: AppUtil.width,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Flexible(
                                                          child: TextField(
                                                        enabled: isEditStep1,
                                                        controller:
                                                            EformController
                                                                .inputShipName,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black),
                                                        decoration:
                                                            const InputDecoration(
                                                                focusedBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Colors
                                                                            .grey)),
                                                                disabledBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Colors
                                                                            .grey)),
                                                                enabledBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Colors
                                                                            .grey)),
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            12,
                                                                            0,
                                                                            12,
                                                                            0),
                                                                hintText:
                                                                    'Input Here...',
                                                                hintStyle:
                                                                    TextStyle(
                                                                        color:
                                                                            kGreyLight),
                                                                // helperText: "",
                                                                helperText: '',
                                                                helperStyle:
                                                                    TextStyle(
                                                                  color:
                                                                      kDavysGrey,
                                                                  fontSize: 14,
                                                                )),
                                                        // onChanged: onInputChanged,
                                                      )),
                                                      const SizedBox(width: 10),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ]))),
                                Card(
                                    color: Colors.white,
                                    margin: const EdgeInsets.fromLTRB(
                                        10, 0, 10, 10),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 10,
                                                margin: const EdgeInsets.only(
                                                    bottom: 10),
                                                decoration: const BoxDecoration(
                                                    color: kGreen,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(8),
                                                            topRight:
                                                                Radius.circular(
                                                                    8))),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                child: Text(
                                                  "Amount (MT)",
                                                  style: TextStyle(
                                                      color: textBlack,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              const Divider(color: Colors.grey),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: SizedBox(
                                                  width: AppUtil.width,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Flexible(
                                                          child: TextField(
                                                        enabled: isEditStep1,
                                                        controller:
                                                            EformController
                                                                .inputS1Amount,
                                                        keyboardType:
                                                            const TextInputType
                                                                .numberWithOptions(
                                                                signed: true,
                                                                decimal: true),
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black),
                                                        decoration:
                                                            const InputDecoration(
                                                                focusedBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Colors
                                                                            .grey)),
                                                                disabledBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Colors
                                                                            .grey)),
                                                                enabledBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Colors
                                                                            .grey)),
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            12,
                                                                            0,
                                                                            12,
                                                                            0),
                                                                hintText:
                                                                    'Input Here...',
                                                                hintStyle:
                                                                    TextStyle(
                                                                        color:
                                                                            kGreyLight),
                                                                // helperText: "",
                                                                helperText:
                                                                    'input number nominal',
                                                                helperStyle:
                                                                    TextStyle(
                                                                  color:
                                                                      kDavysGrey,
                                                                  fontSize: 14,
                                                                )),
                                                        // onChanged: onInputChanged,
                                                      )),
                                                      const SizedBox(width: 10),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ]))),
                              ],
                            );
                          },
                        ),
                        specialSectionStepUnloading(1),
                        Card(
                            color: Colors.white,
                            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 10,
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        decoration: const BoxDecoration(
                                            color: kGreen,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                topRight: Radius.circular(8))),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          "FI-21002 (Sum) A =",
                                          style: TextStyle(
                                              color: textBlack,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      const Divider(color: Colors.grey),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: SizedBox(
                                          width: AppUtil.width,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Flexible(
                                                  child: TextField(
                                                enabled: isEditSteps1,
                                                controller: EformController
                                                    .inputFI21002A,
                                                keyboardType:
                                                    const TextInputType
                                                        .numberWithOptions(
                                                        signed: true,
                                                        decimal: true),
                                                style: const TextStyle(
                                                    color: Colors.black),
                                                decoration:
                                                    const InputDecoration(
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .grey)),
                                                        disabledBorder:
                                                            OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .grey)),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .grey)),
                                                        contentPadding:
                                                            EdgeInsets.fromLTRB(
                                                                12, 0, 12, 0),
                                                        hintText:
                                                            'Input Here...',
                                                        hintStyle: TextStyle(
                                                            color: kGreyLight),
                                                        // helperText: "",
                                                        helperText: '',
                                                        helperStyle: TextStyle(
                                                          color: kDavysGrey,
                                                          fontSize: 14,
                                                        )),
                                                // onChanged: onInputChanged,
                                              )),
                                              const SizedBox(width: 10),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]))),
                        BlocBuilder<EFormBloc, EFormState>(
                          bloc: EformController.serviceBloc,
                          builder: (context, btnState) {
                            //
                            var disableStep1 = btnState.servicesByStep
                                .where((st1) =>
                                    st1.textValue != "" &&
                                    st1.amount > 0 &&
                                    st1.fiA1Amount > 0 &&
                                    st1.shipName.isNotEmpty)
                                .toList()
                                .isNotEmpty;
                            return Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Center(
                                child: SizedBox(
                                  width: AppUtil.width / 2,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      //validation

                                      if (!disableStep1) {
                                        log("save btn unloading step 1");
                                        areaBloc.add(
                                            SaveNewEFormUnloadingSJTransactionEvent(
                                                isAreaBloc: true,
                                                verify: true,
                                                typeForm: 'unloading',
                                                areaState: areaState,
                                                codeEquipment:
                                                    serviceState.kodeEquipment,
                                                step: 1,
                                                isSpecialJob: true,
                                                step1: InsertStep1(
                                                    amount: EformController
                                                        .inputS1Amount.text
                                                        .toString(),
                                                    shipName: EformController
                                                        .inputShipName.text
                                                        .toString(),
                                                    fiA1Amount: EformController
                                                        .inputFI21002A.text
                                                        .toString()),
                                                onFinish: () {
                                                  setState(() {
                                                    _currentStep += 1;
                                                  });
                                                  // EformController.reset();
                                                  log("page ${EformController.indexPage.value}");
                                                  if (EformController.indexPage
                                                              .value ==
                                                          eformStepSpecialJobForm &&
                                                      EformController
                                                          .equipmentCollection
                                                          .value
                                                          .isNotEmpty) {
                                                    log("back to equipment");
                                                    //reload
                                                    //
                                                    EformController.indexPage
                                                        .value = EformController
                                                            .indexPage.value -
                                                        3;
                                                  }
                                                }));

                                        EformController.serviceBloc.add(
                                            SaveNewEFormUnloadingSJTransactionEvent(
                                                isAreaBloc: false,
                                                verify: false,
                                                typeForm: 'unloading',
                                                areaState: areaState,
                                                codeEquipment:
                                                    serviceState.kodeEquipment,
                                                step: 1,
                                                isSpecialJob: true,
                                                step1: InsertStep1(
                                                    amount: EformController
                                                        .inputS1Amount.text
                                                        .toString(),
                                                    shipName: EformController
                                                        .inputShipName.text
                                                        .toString(),
                                                    fiA1Amount: EformController
                                                        .inputFI21002A.text
                                                        .toString()),
                                                onFinish: () {
                                                  log("back step $_currentStep");
                                                }));
                                      }
                                    },
                                    style: !disableStep1
                                        ? ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(kGreenPrimary),
                                            foregroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    Colors.white), // Text color
                                          )
                                        : ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.grey),
                                            foregroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    Colors.grey.shade300),
                                          ),
                                    child: const Text(
                                      'Save',
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ]),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 0
                      ? StepState.complete
                      : StepState.disabled,
                ),
                Step(
                  //step 2
                  title: const Text('Continue'),
                  content: Column(children: <Widget>[
                    BlocBuilder<EFormBloc, EFormState>(
                        bloc: EformController.serviceBloc,
                        builder: (context, state) {
                          var shipName = state.servicesByStep.isNotEmpty
                              ? state.servicesByStep.first.shipName.toString()
                              : '';

                          var amount = state.servicesByStep.isNotEmpty
                              ? state.servicesByStep[0].amount == 0.0
                                  ? ''
                                  : state.servicesByStep[0].amount.toString()
                              : '';
                          var f1Amount = state.servicesByStep.isNotEmpty
                              ? state.servicesByStep[0].fiA1Amount.toString()
                              : '';
                          var b1Amount = state.servicesByStep.isNotEmpty
                              ? state.servicesByStep[0].fiB1Amount.toString()
                              : '';
                          var isEditStep2 = state.servicesByStep.isNotEmpty
                              ? !state.servicesByStep[0].isEditableStep2()
                              : true;

                          var b1minAmount = state.servicesByStep.isNotEmpty
                              ? state.servicesByStep[0].estUnloadingB1MinA
                                  .toString()
                              : '';

                          var estb1minAAmount = state.servicesByStep.isNotEmpty
                              ? state.servicesByStep[0].estUnloadingB1MinA
                                  .toString()
                              : '';
                          log("step 2 ship name : $shipName");
                          log("step 2-> b1Amount db : $b1Amount");
                          log("step 2 b1MinA db : $b1minAmount");
                          EformController.inputShipName.text = shipName;
                          EformController.inputFI21002A.text = f1Amount;
                          EformController.inputB1Amount.text = b1Amount;
                          EformController.inputB1minA.text = estb1minAAmount;
                          if (amount.isNotEmpty) {
                            EformController.inputS1Amount.text = amount;
                            EformController.inputS1Amount.selection =
                                TextSelection.fromPosition(TextPosition(
                                    offset: EformController
                                        .inputS1Amount.text.length));
                          }
                          return Column(
                            children: [
                              Card(
                                  color: Colors.white,
                                  margin:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 10,
                                              margin: const EdgeInsets.only(
                                                  bottom: 10),
                                              decoration: const BoxDecoration(
                                                  color: kGreen,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  8),
                                                          topRight:
                                                              Radius.circular(
                                                                  8))),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: Text(
                                                "Ship Name",
                                                style: TextStyle(
                                                    color: textBlack,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            const Divider(color: Colors.grey),
                                            Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: SizedBox(
                                                width: AppUtil.width,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Flexible(
                                                        child: TextField(
                                                      enabled: false,
                                                      controller:
                                                          EformController
                                                              .inputShipName,
                                                      keyboardType:
                                                          const TextInputType
                                                              .numberWithOptions(
                                                              signed: true,
                                                              decimal: true),
                                                      style: const TextStyle(
                                                          color: Colors.black),
                                                      decoration:
                                                          const InputDecoration(
                                                              focusedBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .grey)),
                                                              disabledBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .grey)),
                                                              enabledBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .grey)),
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          12,
                                                                          0,
                                                                          12,
                                                                          0),
                                                              hintText:
                                                                  'Input Here...',
                                                              hintStyle: TextStyle(
                                                                  color:
                                                                      kGreyLight),
                                                              // helperText: "",
                                                              helperText: '',
                                                              helperStyle:
                                                                  TextStyle(
                                                                color:
                                                                    kDavysGrey,
                                                                fontSize: 14,
                                                              )),
                                                      // onChanged: onInputChanged,
                                                    )),
                                                    const SizedBox(width: 10),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ]))),
                              Card(
                                  color: Colors.white,
                                  margin:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 10,
                                              margin: const EdgeInsets.only(
                                                  bottom: 10),
                                              decoration: const BoxDecoration(
                                                  color: kGreen,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  8),
                                                          topRight:
                                                              Radius.circular(
                                                                  8))),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: Text(
                                                "Amount (MT)",
                                                style: TextStyle(
                                                    color: textBlack,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            const Divider(color: Colors.grey),
                                            Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: SizedBox(
                                                width: AppUtil.width,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Flexible(
                                                        child: TextField(
                                                      enabled: false,
                                                      controller:
                                                          EformController
                                                              .inputS1Amount,
                                                      keyboardType:
                                                          const TextInputType
                                                              .numberWithOptions(
                                                              signed: true,
                                                              decimal: true),
                                                      style: const TextStyle(
                                                          color: Colors.black),
                                                      decoration:
                                                          const InputDecoration(
                                                              focusedBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .grey)),
                                                              disabledBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .grey)),
                                                              enabledBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .grey)),
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          12,
                                                                          0,
                                                                          12,
                                                                          0),
                                                              hintText:
                                                                  'Input Here...',
                                                              hintStyle: TextStyle(
                                                                  color:
                                                                      kGreyLight),
                                                              // helperText: "",
                                                              helperText:
                                                                  'input number nominal',
                                                              helperStyle:
                                                                  TextStyle(
                                                                color:
                                                                    kDavysGrey,
                                                                fontSize: 14,
                                                              )),
                                                      // onChanged: onInputChanged,
                                                    )),
                                                    const SizedBox(width: 10),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ]))),
                            ],
                          );
                        }),
                    specialSectionStepUnloading(2),
                    Card(
                        color: Colors.white,
                        margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
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
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                      "FI-21002 (Sum) A =",
                                      style: TextStyle(
                                          color: textBlack,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  const Divider(color: Colors.grey),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: SizedBox(
                                      width: AppUtil.width,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Flexible(
                                              child: TextField(
                                            enabled: false,
                                            controller:
                                                EformController.inputFI21002A,
                                            keyboardType: const TextInputType
                                                .numberWithOptions(
                                                signed: true, decimal: true),
                                            style: const TextStyle(
                                                color: Colors.black),
                                            decoration: const InputDecoration(
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .grey)),
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide:
                                                            BorderSide(
                                                                color:
                                                                    Colors
                                                                        .grey)),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.grey)),
                                                contentPadding:
                                                    EdgeInsets.fromLTRB(
                                                        12, 0, 12, 0),
                                                hintText: '',
                                                hintStyle: TextStyle(
                                                    color: kGreyLight),
                                                helperText: '',
                                                helperStyle: TextStyle(
                                                  color: kDavysGrey,
                                                  fontSize: 14,
                                                )),
                                            // onChanged: onInputChanged,
                                          )),
                                          const SizedBox(width: 10),
                                        ],
                                      ),
                                    ),
                                  ),
                                ]))),
                    Card(
                        color: Colors.white,
                        margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
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
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                      "FI-21002 (Sum) B1 =",
                                      style: TextStyle(
                                          color: textBlack,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  const Divider(color: Colors.grey),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: SizedBox(
                                      width: AppUtil.width,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Flexible(
                                              child: TextField(
                                            onChanged: (value) {
                                              if (EformController.inputS1Amount
                                                  .text.isNotEmpty) {
                                                int b1Amount = int.parse(
                                                    AppUtil.isNumeric(value)
                                                        ? value
                                                        : '0');
                                                int fI21002AValue = int.parse(
                                                    EformController
                                                        .inputFI21002A.text
                                                        .toString()
                                                        .removeDecimalString());
                                                int total =
                                                    b1Amount - fI21002AValue;
                                                EformController.inputB1minA
                                                    .text = total.toString();
                                                log("total $total");
                                              }
                                            },
                                            enabled: isContinue
                                                ? true
                                                : isEditSteps2,
                                            controller:
                                                EformController.inputB1Amount,
                                            keyboardType: const TextInputType
                                                .numberWithOptions(
                                                signed: true, decimal: true),
                                            style: const TextStyle(
                                                color: Colors.black),
                                            decoration: const InputDecoration(
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .grey)),
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide:
                                                            BorderSide(
                                                                color:
                                                                    Colors
                                                                        .grey)),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.grey)),
                                                contentPadding:
                                                    EdgeInsets.fromLTRB(
                                                        12, 0, 12, 0),
                                                hintText: '',
                                                hintStyle: TextStyle(
                                                    color: kGreyLight),
                                                helperText: '',
                                                helperStyle: TextStyle(
                                                  color: kDavysGrey,
                                                  fontSize: 14,
                                                )),
                                            // onChanged: onInputChanged,
                                          )),
                                          const SizedBox(width: 10),
                                        ],
                                      ),
                                    ),
                                  ),
                                ]))),
                    Card(
                        color: Colors.white,
                        margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
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
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                      "Estimation Unloading (T) I : B1 - A =",
                                      style: TextStyle(
                                          color: textBlack,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  const Divider(color: Colors.grey),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: SizedBox(
                                      width: AppUtil.width,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Flexible(
                                              child: TextField(
                                            enabled: false,
                                            controller:
                                                EformController.inputB1minA,
                                            keyboardType: const TextInputType
                                                .numberWithOptions(
                                                signed: true, decimal: true),
                                            style: const TextStyle(
                                                color: Colors.black),
                                            decoration: const InputDecoration(
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .grey)),
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide:
                                                            BorderSide(
                                                                color:
                                                                    Colors
                                                                        .grey)),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.grey)),
                                                contentPadding:
                                                    EdgeInsets.fromLTRB(
                                                        12, 0, 12, 0),
                                                hintText: '',
                                                hintStyle: TextStyle(
                                                    color: kGreyLight),
                                                helperText: '',
                                                helperStyle: TextStyle(
                                                  color: kDavysGrey,
                                                  fontSize: 14,
                                                )),
                                            // onChanged: onInputChanged,
                                          )),
                                          const SizedBox(width: 10),
                                        ],
                                      ),
                                    ),
                                  ),
                                ]))),
                  ]),
                  isActive: _currentStep >= 0,
                  state: EformController.uuidSelected.value.isNotEmpty
                      ? StepState.complete
                      : _currentStep >= 1
                          ? StepState.complete
                          : StepState.disabled,
                ),
                Step(
                  //step 3
                  title: const Text('Finish'),
                  content: BlocBuilder<EFormBloc, EFormState>(
                    bloc: EformController.serviceBloc,
                    builder: (context, state) {
                      var shipName = state.servicesByStep.isNotEmpty
                          ? state.servicesByStep[0].shipName.toString()
                          : '';

                      var amount = state.servicesByStep.isNotEmpty
                          ? state.servicesByStep[0].amount == 0.0
                              ? ''
                              : state.servicesByStep[0].amount.toString()
                          : '';
                      var b1Amount = state.servicesByStep.isNotEmpty
                          ? state.servicesByStep[0].fiB1Amount.toString()
                          : '';

                      var b2Amount = state.servicesByStep.isNotEmpty
                          ? state.servicesByStep[0].fiB2Amount.toString()
                          : '';
                      var estb2minb1Amount = state.servicesByStep.isNotEmpty
                          ? state.servicesByStep[0].estUnloadingB2MinB1
                              .toString()
                          : '';
                      log("step 3 ship name : $shipName");
                      log("step 3 b1Amount db : $b1Amount");
                      log("step 3 b2Amount db : $b2Amount");
                      EformController.inputShipName.text = shipName;
                      EformController.inputB1Amount.text = b1Amount;
                      EformController.inputB2Amount.text = b2Amount;
                      EformController.inputB2minB1.text = estb2minb1Amount;
                      if (amount.isNotEmpty) {
                        EformController.inputS1Amount.text = amount;
                        EformController.inputS1Amount.selection =
                            TextSelection.fromPosition(TextPosition(
                                offset:
                                    EformController.inputS1Amount.text.length));
                      }
                      return Column(children: <Widget>[
                        Card(
                            color: Colors.white,
                            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 10,
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        decoration: const BoxDecoration(
                                            color: kGreen,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                topRight: Radius.circular(8))),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          "Ship Name",
                                          style: TextStyle(
                                              color: textBlack,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      const Divider(color: Colors.grey),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: SizedBox(
                                          width: AppUtil.width,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Flexible(
                                                  child: TextField(
                                                enabled: false,
                                                controller: EformController
                                                    .inputShipName,
                                                keyboardType:
                                                    const TextInputType
                                                        .numberWithOptions(
                                                        signed: true,
                                                        decimal: true),
                                                style: const TextStyle(
                                                    color: Colors.black),
                                                decoration:
                                                    const InputDecoration(
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .grey)),
                                                        disabledBorder:
                                                            OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .grey)),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .grey)),
                                                        contentPadding:
                                                            EdgeInsets.fromLTRB(
                                                                12, 0, 12, 0),
                                                        hintText:
                                                            'Input Here...',
                                                        hintStyle: TextStyle(
                                                            color: kGreyLight),
                                                        // helperText: "",
                                                        helperText: '',
                                                        helperStyle: TextStyle(
                                                          color: kDavysGrey,
                                                          fontSize: 14,
                                                        )),
                                                // onChanged: onInputChanged,
                                              )),
                                              const SizedBox(width: 10),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]))),
                        Card(
                            color: Colors.white,
                            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 10,
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        decoration: const BoxDecoration(
                                            color: kGreen,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                topRight: Radius.circular(8))),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          "Amount (MT)",
                                          style: TextStyle(
                                              color: textBlack,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      const Divider(color: Colors.grey),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: SizedBox(
                                          width: AppUtil.width,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Flexible(
                                                  child: TextField(
                                                enabled: false,
                                                controller: EformController
                                                    .inputS1Amount,
                                                keyboardType:
                                                    const TextInputType
                                                        .numberWithOptions(
                                                        signed: true,
                                                        decimal: true),
                                                style: const TextStyle(
                                                    color: Colors.black),
                                                decoration:
                                                    const InputDecoration(
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .grey)),
                                                        disabledBorder:
                                                            OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .grey)),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .grey)),
                                                        contentPadding:
                                                            EdgeInsets.fromLTRB(
                                                                12, 0, 12, 0),
                                                        hintText:
                                                            'Input Here...',
                                                        hintStyle: TextStyle(
                                                            color: kGreyLight),
                                                        // helperText: "",
                                                        helperText:
                                                            'input number nominal',
                                                        helperStyle: TextStyle(
                                                          color: kDavysGrey,
                                                          fontSize: 14,
                                                        )),
                                                // onChanged: onInputChanged,
                                              )),
                                              const SizedBox(width: 10),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]))),
                        specialSectionStepUnloading(3),
                        Card(
                            color: Colors.white,
                            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 10,
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        decoration: const BoxDecoration(
                                            color: kGreen,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                topRight: Radius.circular(8))),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          "FI-21002 (Sum) B1=",
                                          style: TextStyle(
                                              color: textBlack,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      const Divider(color: Colors.grey),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: SizedBox(
                                          width: AppUtil.width,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Flexible(
                                                  child: TextField(
                                                enabled: false,
                                                controller: EformController
                                                    .inputB1Amount,
                                                keyboardType:
                                                    const TextInputType
                                                        .numberWithOptions(
                                                        signed: true,
                                                        decimal: true),
                                                style: const TextStyle(
                                                    color: Colors.black),
                                                decoration:
                                                    const InputDecoration(
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .grey)),
                                                        disabledBorder:
                                                            OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .grey)),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .grey)),
                                                        contentPadding:
                                                            EdgeInsets.fromLTRB(
                                                                12, 0, 12, 0),
                                                        hintText: '',
                                                        hintStyle: TextStyle(
                                                            color: kGreyLight),
                                                        helperText: '',
                                                        helperStyle: TextStyle(
                                                          color: kDavysGrey,
                                                          fontSize: 14,
                                                        )),
                                                // onChanged: onInputChanged,
                                              )),
                                              const SizedBox(width: 10),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]))),
                        Card(
                            color: Colors.white,
                            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 10,
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        decoration: const BoxDecoration(
                                            color: kGreen,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                topRight: Radius.circular(8))),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          "FI-21002 (Sum) B2=",
                                          style: TextStyle(
                                              color: textBlack,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      const Divider(color: Colors.grey),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: SizedBox(
                                          width: AppUtil.width,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Flexible(
                                                  child: TextField(
                                                enabled: true,
                                                onChanged: (value) {
                                                  if (EformController
                                                      .inputB1Amount
                                                      .text
                                                      .isNotEmpty) {
                                                    int b2Amount = int.parse(
                                                        AppUtil.isNumeric(value)
                                                            ? value
                                                            : '0');
                                                    int b1Amount = int.parse(
                                                        EformController
                                                            .inputB1Amount.text
                                                            .toString()
                                                            .removeDecimalString());
                                                    int total =
                                                        b2Amount - b1Amount;
                                                    EformController
                                                            .inputB2minB1.text =
                                                        total.toString();
                                                    log("total b2-b1 $total");
                                                  }
                                                },
                                                controller: EformController
                                                    .inputB2Amount,
                                                keyboardType:
                                                    const TextInputType
                                                        .numberWithOptions(
                                                        signed: true,
                                                        decimal: true),
                                                style: const TextStyle(
                                                    color: Colors.black),
                                                decoration:
                                                    const InputDecoration(
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .grey)),
                                                        disabledBorder:
                                                            OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .grey)),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .grey)),
                                                        contentPadding:
                                                            EdgeInsets.fromLTRB(
                                                                12, 0, 12, 0),
                                                        hintText: '',
                                                        hintStyle: TextStyle(
                                                            color: kGreyLight),
                                                        helperText: '',
                                                        helperStyle: TextStyle(
                                                          color: kDavysGrey,
                                                          fontSize: 14,
                                                        )),
                                                // onChanged: onInputChanged,
                                              )),
                                              const SizedBox(width: 10),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]))),
                        Card(
                            color: Colors.white,
                            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 10,
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        decoration: const BoxDecoration(
                                            color: kGreen,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                topRight: Radius.circular(8))),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          "Estimation Unloading (T) I : B2 - B1 =",
                                          style: TextStyle(
                                              color: textBlack,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      const Divider(color: Colors.grey),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: SizedBox(
                                          width: AppUtil.width,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Flexible(
                                                  child: TextField(
                                                enabled: false,
                                                controller: EformController
                                                    .inputB2minB1,
                                                keyboardType:
                                                    const TextInputType
                                                        .numberWithOptions(
                                                        signed: true,
                                                        decimal: true),
                                                style: const TextStyle(
                                                    color: Colors.black),
                                                decoration:
                                                    const InputDecoration(
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .grey)),
                                                        disabledBorder:
                                                            OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .grey)),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .grey)),
                                                        contentPadding:
                                                            EdgeInsets.fromLTRB(
                                                                12, 0, 12, 0),
                                                        hintText: '',
                                                        hintStyle: TextStyle(
                                                            color: kGreyLight),
                                                        helperText: '',
                                                        helperStyle: TextStyle(
                                                          color: kDavysGrey,
                                                          fontSize: 14,
                                                        )),
                                                // onChanged: onInputChanged,
                                              )),
                                              const SizedBox(width: 10),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]))),
                      ]);
                    },
                  ),
                  isActive: _currentStep >= 0,
                  state: EformController.uuidSelected.value.isNotEmpty
                      ? StepState.editing
                      : _currentStep >= 2
                          ? StepState.complete
                          : StepState.disabled,
                ),
              ],
            ),
          );
        });
  }

  Widget specialJobTransferSection(
      EFormState serviceState,
      List<String>? itemStep1,
      List<String>? itemStep2,
      List<String>? itemStep3,
      bool isSpecialTf) {
    return BlocBuilder<EFormBloc, EFormState>(
      bloc: areaBloc,
      builder: (context, areaState) {
        List<String> listControl = ['ST-5911 A', 'ST-5911 B', 'ST-5911C'];
        List<String>? listItemTo = [];
        List<String>? cekTo = [];
        var isFinishJob = false;
        var disableInput = false;
        if (serviceState.servicesByStep.isNotEmpty) {
          log("selected to :${serviceState.servicesByStep}");
          log("nextm step to :${_currentStep}");
          log("uuid :${EformController.uuidSelected.value}");

          switch (_currentStep) {
            case 0: //step 1
              int index = listControl.indexWhere((item) =>
                  item == serviceState.servicesByStep.first.controlTf);
              selectedIndexControl = index;
              selectedControl = serviceState.servicesByStep.first.controlTf;
              log("selectedControl : $selectedControl");
              break;
            case 1: //step 2
              disableInput = !serviceState.servicesByStep.first.editable; //i
              if (itemStep1 != null) {
                cekTo = itemStep1.isNotEmpty
                    ? itemStep1
                    : itemStep2!.isNotEmpty
                        ? itemStep2
                        : itemStep3;
                listItemTo = cekTo;
                int index = cekTo!.indexWhere((item) =>
                    item == serviceState.servicesByStep.first.selectedTo);
                selectedIndexTo = index;
                selectedItemTo = serviceState.servicesByStep.first.selectedTo;
              } else {
                selectedItemTo = '';
              }

              log("selected TO : $selectedItemTo");
              log("selected List to : $itemStep2");
              log("disable input: $disableInput");
              break;
            default:
              {
                disableInput = !serviceState
                    .servicesByStep.first.editable; //if false == true
                int index = listControl.indexWhere((item) =>
                    item == serviceState.servicesByStep.first.selectedTo);
                selectedIndexTo = index;
                selectedItemTo = serviceState.servicesByStep.first.controlTf;
                isFinishJob = serviceState.servicesByStep.first.editable;
                break;
              }
          }
        }
        //stepper form
        return Expanded(
          child: Stepper(
            controlsBuilder: (BuildContext context, ControlsDetails details) {
              return Row(
                mainAxisAlignment: _currentStep == 1
                    ? MainAxisAlignment.spaceEvenly
                    : MainAxisAlignment.center,
                children: const [],
              );
            },
            currentStep: _currentStep,
            type: StepperType.horizontal,
            onStepTapped: (step) {
              setState(() => _currentStep = step);
              log("step tapped $_currentStep");
              EformController.serviceBloc.add(GetServiceSpecialTransferStep(
                  uuid: EformController.uuidSelected.value,
                  steps: _currentStep,
                  kodeEquipment: serviceState.kodeEquipment,
                  areaState: areaState));
            },
            onStepContinue: () {
              if (_currentStep < 2) {
                // selectedIndex = null;
                setState(() => _currentStep += 1);
                EformController.serviceBloc.add(GetServiceSpecialTransferStep(
                    uuid: EformController.uuidSelected.value,
                    steps: _currentStep,
                    kodeEquipment: serviceState.kodeEquipment,
                    areaState: areaState));
              }
              log("step continue $_currentStep");
            },
            steps: <Step>[
              Step(
                title: const Text('Pre\nCondition'),
                content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      isSpecialTf
                          ? SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Control',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16)),
                                  ),
                                  Container(
                                      margin: const EdgeInsetsDirectional.only(
                                          start: 8.0, bottom: 10.0),
                                      width: double.infinity,
                                      height: 50,
                                      child: listControl.isNotEmpty
                                          ? ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: listControl.map((item) {
                                                int itemIndex =
                                                    listControl.indexOf(item);
                                                return Center(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      // setState(() {
                                                      //   selectedIndex = itemIndex;
                                                      // });
                                                      // EformController
                                                      //         .spcTfEntry['1'] =
                                                      //     listControl[
                                                      //         selectedIndex!];
                                                      EformController
                                                          .serviceBloc
                                                          .add(ChangeSelectControlTOSpecialTFEvent(
                                                              currentStep:
                                                                  _currentStep,
                                                              equipmentCode:
                                                                  serviceState
                                                                      .kodeEquipment,
                                                              value: item,
                                                              type: "control",
                                                              isAction: true,
                                                              isAreaBloc:
                                                                  false));

                                                      areaBloc.add(
                                                          ChangeSelectControlTOSpecialTFEvent(
                                                              currentStep:
                                                                  _currentStep,
                                                              equipmentCode:
                                                                  serviceState
                                                                      .kodeEquipment,
                                                              value: item,
                                                              type: "control",
                                                              isAction: true,
                                                              isAreaBloc:
                                                                  true));
                                                    },
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2,
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 5.0),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 5.0,
                                                          vertical: 5.0),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            selectedIndexControl ==
                                                                    itemIndex
                                                                ? kGreenPrimary
                                                                : Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                      ),
                                                      child: Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            item,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: selectedIndexControl ==
                                                                      itemIndex
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            )
                                          : const SizedBox()),
                                ],
                              ),
                            )
                          : const SizedBox(),
                      specialTransferSectionStep(1),
                      Center(
                        child: SizedBox(
                          width: AppUtil.width / 2,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _currentStep += 1;
                              });
                              EformController.serviceBloc.add(
                                  GetServiceSpecialTransferStep(
                                      uuid: EformController.uuidSelected.value,
                                      steps: _currentStep,
                                      kodeEquipment: serviceState.kodeEquipment,
                                      areaState: areaState));
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(kBlueButton),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white), // Text color
                            ),
                            child: const Text(
                              'Next',
                            ),
                          ),
                        ),
                      )
                    ]),
                isActive: _currentStep >= 0,
                state:
                    _currentStep >= 0 ? StepState.complete : StepState.disabled,
              ),
              Step(
                title: const Text('Start\nTransfer'),
                content: Column(children: <Widget>[
                  SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('To',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16)),
                        ),
                        Container(
                            margin:
                                const EdgeInsetsDirectional.only(bottom: 10.0),
                            width: double.infinity,
                            height: 50,
                            child: listItemTo != null
                                ? ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: listItemTo.map((item) {
                                      int itemIndex = listItemTo!.indexOf(item);
                                      return GestureDetector(
                                        onTap: () {
                                          // EformController.spcTfEntry['2'] =
                                          //     itemStep1[selectedIndex!];
                                          //set 1 equipment

                                          EformController.serviceBloc.add(
                                              ChangeSelectControlTOSpecialTFEvent(
                                                  currentStep: _currentStep,
                                                  equipmentCode: serviceState
                                                      .kodeEquipment,
                                                  value: item,
                                                  isAction: true,
                                                  isAreaBloc: false,
                                                  type: 'to'));

                                          areaBloc.add(
                                              ChangeSelectControlTOSpecialTFEvent(
                                                  equipmentCode: serviceState
                                                      .kodeEquipment,
                                                  isAreaBloc: true,
                                                  value: item,
                                                  currentStep: _currentStep,
                                                  type: 'to'));
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.5,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0, vertical: 5.0),
                                          decoration: BoxDecoration(
                                            color: itemIndex == selectedIndexTo
                                                ? kGreenPrimary
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                item,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: itemIndex ==
                                                          selectedIndexTo
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  )
                                : const SizedBox()),
                      ],
                    ),
                  ),
                  specialTransferSectionStep(2),
                  Center(
                    child: SizedBox(
                      width: AppUtil.width / 2,
                      child: ElevatedButton(
                        onPressed: () {
                          if (!disableInput) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return BackdropFilter(
                                    filter:
                                        ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                    child: AlertDialog(
                                      title: const Center(
                                          child: Text(
                                        'Are you sure',
                                        style: textStyleSubtitle,
                                      )),
                                      content: Container(
                                          height: 150,
                                          padding:
                                              const EdgeInsetsDirectional.all(
                                                  8.0),
                                          child: Column(
                                            children: [
                                              const Center(
                                                  child: Text(
                                                'Complete this Special Transfer Section ?',
                                                style: textStyleSubtitleEform,
                                              )),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  SizedBox(
                                                    width: AppUtil.width / 4,
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.of(AppUtil
                                                                .context!)
                                                            .pop();
                                                        log("save");
                                                        areaBloc.add(
                                                            SaveNewTransferSJTransactionEvent(
                                                                isAreaBloc:
                                                                    true,
                                                                isFinish: false,
                                                                verify: true,
                                                                areaState:
                                                                    areaState,
                                                                codeEquipment:
                                                                    serviceState
                                                                        .kodeEquipment,
                                                                step: 2,
                                                                step1n2: InsertStep12(
                                                                    control:
                                                                        selectedControl!,
                                                                    to: selectedItemTo!),
                                                                onFinish: () {
                                                                  setState(() {
                                                                    _currentStep +=
                                                                        1;
                                                                  });
                                                                  // EformController
                                                                  //     .reset();
                                                                  log("page ${EformController.indexPage.value}");
                                                                  if (EformController
                                                                              .indexPage
                                                                              .value ==
                                                                          eformStepSpecialJobForm &&
                                                                      EformController
                                                                          .equipmentCollection
                                                                          .value
                                                                          .isNotEmpty) {
                                                                    log("back to equipment");
                                                                    EformController
                                                                        .indexPage
                                                                        .value = EformController
                                                                            .indexPage
                                                                            .value -
                                                                        3;
                                                                  }
                                                                }));

                                                        EformController.serviceBloc.add(
                                                            SaveNewTransferSJTransactionEvent(
                                                                isAreaBloc:
                                                                    false,
                                                                areaState:
                                                                    areaState,
                                                                isFinish: false,
                                                                verify: false,
                                                                codeEquipment:
                                                                    serviceState
                                                                        .kodeEquipment,
                                                                step: 2,
                                                                step1n2: InsertStep12(
                                                                    control:
                                                                        selectedControl!,
                                                                    to: selectedItemTo!),
                                                                onFinish: () {
                                                                  log("finish");
                                                                }));
                                                      },
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all<Color>(
                                                                    kGreenPrimary),
                                                        foregroundColor:
                                                            MaterialStateProperty
                                                                .all<Color>(Colors
                                                                    .white), // Text color
                                                      ),
                                                      child: const Text(
                                                        'Save',
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: AppUtil.width / 4,
                                                    child: ElevatedButton(
                                                      onPressed: () => {
                                                        Navigator.of(AppUtil
                                                                .context!)
                                                            .pop()
                                                      },
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all<Color>(
                                                                    kGreyLight),
                                                        foregroundColor:
                                                            MaterialStateProperty
                                                                .all<Color>(Colors
                                                                    .black), // Text color
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
                                });
                          }
                        },
                        style: ButtonStyle(
                          padding:
                              MaterialStateProperty.all<EdgeInsetsDirectional>(
                                  const EdgeInsetsDirectional.all(8)),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              (disableInput ? kGrey : kGreen)),
                          foregroundColor: MaterialStateProperty.all<Color>(
                              (disableInput
                                  ? Colors.grey
                                  : Colors.white)), // Text color
                        ),
                        child: const Text(
                          'Save',
                        ),
                      ),
                    ),
                  )
                ]),
                isActive: _currentStep >= 0,
                state: EformController.uuidSelected.value.isNotEmpty
                    ? StepState.complete
                    : _currentStep >= 1
                        ? StepState.complete
                        : StepState.disabled,
              ),
              Step(
                title: const Text('Finish\nTransfer'),
                content: Column(children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  specialTransferSectionStep(3),
                  Center(
                    child: SizedBox(
                        width: AppUtil.width / 2,
                        child: TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor:
                                  disableInput ? kGrey : kBlueButton),
                          onPressed: () {
                            if (!disableInput) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 6, sigmaY: 6),
                                      child: AlertDialog(
                                        title: const Center(
                                            child: Text(
                                          'Are you sure',
                                          style: textStyleSubtitle,
                                        )),
                                        content: Container(
                                            height: 150,
                                            padding:
                                                const EdgeInsetsDirectional.all(
                                                    8.0),
                                            child: Column(
                                              children: [
                                                const Center(
                                                    child: Text(
                                                  'Finish Special Transfer  ?',
                                                  style: textStyleSubtitleEform,
                                                )),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    SizedBox(
                                                      width: AppUtil.width / 4,
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.of(AppUtil
                                                                  .context!)
                                                              .pop();
                                                          log("finish");
                                                          areaBloc.add(
                                                              SaveNewTransferSJTransactionEvent(
                                                                  isAreaBloc:
                                                                      true,
                                                                  isFinish:
                                                                      true,
                                                                  verify: true,
                                                                  areaState:
                                                                      areaState,
                                                                  codeEquipment:
                                                                      serviceState
                                                                          .kodeEquipment,
                                                                  step: 3,
                                                                  onFinish: () {
                                                                    setState(
                                                                        () {
                                                                      _currentStep =
                                                                          0;
                                                                    });
                                                                    EformController
                                                                        .uuidSelected
                                                                        .value = '';
                                                                    EformController
                                                                        .eqpTo = {};
                                                                    log("back to equipment");
                                                                    EformController
                                                                        .indexPage
                                                                        .value = EformController
                                                                            .indexPage
                                                                            .value -
                                                                        3;
                                                                  }));

                                                          EformController.serviceBloc.add(
                                                              SaveNewTransferSJTransactionEvent(
                                                                  isAreaBloc:
                                                                      false,
                                                                  areaState:
                                                                      areaState,
                                                                  isFinish:
                                                                      true,
                                                                  verify: false,
                                                                  codeEquipment:
                                                                      serviceState
                                                                          .kodeEquipment,
                                                                  step: 3,
                                                                  onFinish: () {
                                                                    log("finish special transfer");
                                                                  }));
                                                        },
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all<Color>(
                                                                      kGreenPrimary),
                                                          foregroundColor:
                                                              MaterialStateProperty
                                                                  .all<Color>(Colors
                                                                      .white), // Text color
                                                        ),
                                                        child: const Text(
                                                          'Save',
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: AppUtil.width / 4,
                                                      child: ElevatedButton(
                                                        onPressed: () => {
                                                          Navigator.of(AppUtil
                                                                  .context!)
                                                              .pop()
                                                        },
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all<Color>(
                                                                      kGreyLight),
                                                          foregroundColor:
                                                              MaterialStateProperty
                                                                  .all<Color>(Colors
                                                                      .black), // Text color
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
                                  });
                            }
                          },
                          child: Text(
                            "Finish",
                            style: TextStyle(
                              color: (disableInput ? kGreyLight : Colors.white),
                            ),
                          ),
                        )),
                  )
                ]),
                isActive: _currentStep >= 0,
                state: EformController.uuidSelected.value.isNotEmpty
                    ? StepState.complete
                    : _currentStep >= 2
                        ? StepState.complete
                        : StepState.disabled,
              ),
            ],
          ),
        );
      },
    );
  }
}

class EformController {
  static final TextEditingController searchInput = TextEditingController();
  static final TextEditingController inputShipName = TextEditingController();
  static final TextEditingController inputS1Amount = TextEditingController();
  static final TextEditingController inputB2Amount = TextEditingController();
  static final TextEditingController inputB1Amount = TextEditingController();
  static final TextEditingController inputB2minB1 = TextEditingController();
  static final TextEditingController inputFI21002A = TextEditingController();
  static final TextEditingController inputB1minA = TextEditingController();
  // static final ValueNotifier<int> indexPage = ValueNotifier(1),
  //     indexEquipment = ValueNotifier(1);
  static final ValueNotifier<int> indexPage = ValueNotifier(0),
      indexEquipment = ValueNotifier(0);
  static final ValueNotifier<List<Equipment>> equipmentCollection =
      ValueNotifier([]);
  static final ValueNotifier<List<Section>> sectionCollection =
      ValueNotifier([]);
  static final ValueNotifier<List<Cpl>> cplCollection = ValueNotifier([]);
  static final ValueNotifier<String> sectionTitle =
      ValueNotifier('FORMAT TYPE');
  static final ValueNotifier<String> formType =
      ValueNotifier('Standard'); //special
  static final ValueNotifier<String> equipmentName = ValueNotifier('');
  //for passing uuid to continue / finish step
  static final ValueNotifier<String> uuidSpecialJob = ValueNotifier('');
  static final ValueNotifier<String> idFormatSelected = ValueNotifier('');
  static final ValueNotifier<String> sectionSelected = ValueNotifier('');
  static final ValueNotifier<String> formatSelected = ValueNotifier('');
  static final ValueNotifier<bool> specialNewTrx = ValueNotifier(false);
  static final ValueNotifier<bool> specialBtnOn = ValueNotifier(false);
  //detect button is editable service form manual ->default true
  static final ValueNotifier<bool> detectEditableManualService =
      ValueNotifier(true);
  static final ValueNotifier<bool> eqpOptionMenuSpecial =
      ValueNotifier(false); //if true hidden option menu
  static final ValueNotifier<String> equipmentCode = ValueNotifier('');
  static final ValueNotifier<String> tipeCpl = ValueNotifier('');
  static final ValueNotifier<String> uuidSelected = ValueNotifier('');
  static final ValueNotifier<String> searchService = ValueNotifier('');
  static final ValueNotifier<String> fromHomePage =
      ValueNotifier(''); //Home,History
  static final ScrollController scroll = ScrollController();
  static final EFormBloc specialJobUnloadingService = EFormBloc(),
      serviceBloc = EFormBloc(),
      equipmentBloc = EFormBloc();
  static int fromIndex = 0;
  static Map<String, List<String>> eqpTo = {};
  static Map<String, String> spcTfEntry = {}; //isian setiap step special tf

  static void reset() {
    searchInput.text = '';
    uuidSelected.value = '';
    eqpTo = {};
    indexPage.value = 0;
    indexEquipment.value = 0;
    specialNewTrx.value = false;
    detectEditableManualService.value = true;
    equipmentCollection.value = [];
    sectionTitle.value = 'FORMAT TYPE';
    equipmentName.value = '';
    equipmentCode.value = '';
    fromIndex = 0;
    fromHomePage.value = '';
    formatSelected.value = '';
  }
}
