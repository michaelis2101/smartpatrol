import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_patrol/data/data_sync_models/data_export_models.dart';
import 'package:smart_patrol/data/data_sync_models/data_export_models_sj.dart';
import 'package:smart_patrol/data/data_sync_models/data_sync_models.dart';
import 'package:smart_patrol/data/data_sync_models/data_sync_models_sj.dart';
import 'package:smart_patrol/data/data_sync_models/transaction.dart';
import 'package:smart_patrol/data/data_sync_models/transaction_special.dart';
import 'package:smart_patrol/data/data_sync_models/user.dart';
import 'package:smart_patrol/data/models/area_model.dart';
import 'package:smart_patrol/data/models/cpl_model.dart';
import 'package:smart_patrol/data/models/equipment_model.dart';
import 'package:smart_patrol/data/models/format_model.dart';
import 'package:smart_patrol/data/models/position_model.dart';
import 'package:smart_patrol/data/models/section_model.dart';
import 'package:smart_patrol/data/models/service_model.dart';
import 'package:smart_patrol/data/models/special_job_model.dart';
import 'package:smart_patrol/data/models/transaction_model.dart';
import 'package:smart_patrol/data/provider/database_helper.dart';
import 'package:smart_patrol/utils/constants.dart';
import 'package:smart_patrol/utils/enum.dart';
import 'package:smart_patrol/utils/utils.dart';
import 'package:uuid/uuid.dart';
part 'eform_event.dart';
part 'eform_state.dart';

class EFormBloc extends Bloc<EFormEvent, EFormState> {
  EFormBloc({EFormState? initialState}) : super(const EFormState()) {
    on<InitEFormEvent>(_initEform);
    on<SetDatePatrol>(_setTglPatrol);
    on<ImportFormatsEvent>(_importFormats);
    on<ImportSectionEvent>(_importSections);
    on<ImportAreaEvent>(_importArea);
    on<ImportCplEvent>(_importCpl);
    on<ImportEquipmentEvent>(_importEquipment);
    on<ImportServiceEvent>(_importService);
    on<ImportServiceSpecialEvent>(_importServiceSpecial);
    on<SearchAreaEvent>(_searchArea);
    on<SearchSectionEvent>(_searchSection);
    on<SearchFormatsEvent>(_searchFormats);
    on<GetAreaBySectionEvent>(_getAreaBySection);
    on<GetCplByAreaEvent>(_getCplByArea);
    on<GetServiceSearchByTag>(_searchServices);
    on<GetEquipmentByNfcTag>(_getEquipmentByNFC);
    on<SearchCplEvent>(_searchCpl);
    on<GetEquipmentByCplEvent>(_getEquipmentByCpl);
    on<SearchEquipmentEvent>(_searchEquipment);
    on<NfcReaderEvent>(_checkNfcReader);
    on<GetSectionByFormats>(_getSectionByKodeFormat);
    on<GetServiceByEquipmentEvent>(_getServiceByEquipment);
    on<GetServiceSpecialStep>(_getServiceByEquipmentStep);
    on<GetListHistorySpecialJob>(_getListHistorySpecialJob);
    on<GetTransactionSpecial>(_getTransactionSpecialJob);
    on<ValidationServiceSpecialStep>(_validationServiceSpecialStep);
    on<GetServiceSpecialUnloadingStep>(_getServiceSpecialUnloadingStep);
    on<GetServiceSpecialTransferStep>(_getServiceSpecialTransferStep);
    on<ChangeStopStateServiceByEquipmentEvent>(
        _changeStopStateServiceByEquipment);
    on<ChangeSelectControlTOSpecialTFEvent>(
        _changeSelectControlTOSpecialTFEvent);
    on<ChangeDetectedStateServiceByEquipmentEvent>(
        _changeDetectedStateServiceByEquipment);
    on<ChangeStopStateAllServiceByEquipmentEvent>(
        _changeStopStateAllServiceByEquipment);
    on<ChangeDetectedStateAllServiceByEquipmentEvent>(
        _changeDetectedStateAllServiceByEquipment);
    on<ChangeSkipStateAllServiceByEquipmentEvent>(
        _changeSkipStateAllServiceByEquipmentEvent);
    on<ChangeTextValueStateServiceByEquipmentEvent>(
        _changeTextValueStateServiceByEquipment);
    on<ChangeTextValueStateServiceByStepUnloadingEvent>(
        _changeTextValueStateServiceByStepUnloadingEvent);
    on<ChangeTextValueStateServiceByStepTransferEvent>(
        _changeTextValueStateServiceByStepTransferEvent);
    on<ChangeServiceReportedConditionEvent>(_changeServiceReportedCondition);
    on<ChangeServiceReportedRequestEvent>(_changeServiceReportedRequest);
    on<AddServiceReportedPhotoEvent>(_addServiceReportedPhoto);
    on<SaveNewEFormTransactionEvent>(_saveNewEFormTransaction);
    on<SaveAllStopEFormTransactionEvent>(
        _saveAllStopEquipmentByCplEFormTransaction);
    on<SaveNewEFormUnloadingSJTransactionEvent>(
        _saveNewEFormUnloadingTransaction);
    on<SaveNewTransferSJTransactionEvent>(_saveNewSpecialTransferTransaction);
    on<UpdateEFormTransactionEvent>(_updateEFormTransaction);
    on<ImportCplAutoEvent>(_importCplAuto);
    on<ImportEquipmentAutoEvent>(_importEquipmentAuto);
    on<ImportServiceAutoEvent>(_importServiceAuto);
    on<ImportSpecialCplEvent>(_importSpecialCpl);
    on<ImportSpecialPositionEvent>(_importSpecialPosition);
    on<ImportSpecialJobFormEvent>(_importSpecialJobForm);
    on<ExportTransactionEvent>(_exportTransaction);
    on<ExportSpecialTransactionEvent>(_exportTransactionSpecial);
    on<DeleteAllTransactionEvent>(_deleteAllTransaction);
    on<SyncTransactionEvent>(_syncTransaction);
    on<SyncTransactionSpecialJobEvent>(_syncTransactionSpecial);
    on<GetTransactionHistoryByFormatEvent>(_getTrxHistoryByFormat);

    on<CheckTransactionEvent>(_checkTransaction);
    // on<SetFormatForDropdown>(_setFormatForDropdown);
    // on<SetSelectedFormat>(_setSelectedFormat);
  }

  // Future<void> _setSelectedFormat(
  //     SetSelectedFormat event, Emitter<EFormState> emit) async {
  //   emit(EFormState(selectedFormat: event.format));
  // }

  // Future<void> _setFormatForDropdown(
  //     SetFormatForDropdown event, Emitter<EFormState> emit) async {
  //   emit(EFormLoading());
  //   final user = await DatabaseProvider.getSignedUserJson();
  //   final formats = await DatabaseProvider.getFormatsJson();

  //   if (formats.isNotEmpty) {
  //     List<Formats> byDepartment =
  //         formats.where((e) => e.department == user?.department).toList();
  //     emit(state.copyWith(formats: byDepartment));
  //   }
  // }

  Future<void> _initEform(
      InitEFormEvent event, Emitter<EFormState> emitter) async {
    try {
      final user = await DatabaseProvider.getSignedUserJson();
      final area = await DatabaseProvider.getAreaJson();
      final section = await DatabaseProvider.getSectionsJson();
      final formats = await DatabaseProvider.getFormatsJson();

      if (formats.isNotEmpty) {
        var byDepartment =
            formats.where((e) => e.department == user?.department).toList();
        emitter(state.copyWith(formats: byDepartment));
      }
      if (section.isNotEmpty) {
        emitter(state.copyWith(section: section));
      }

      if (area.isNotEmpty) {
        emitter(state.copyWith(areas: area));
      }
      final cpl = await DatabaseProvider.getCPLJson();
      if (cpl.isNotEmpty) {
        emitter(state.copyWith(cpls: cpl));
      }

      final equipment = await DatabaseProvider.getEquipmentJson();
      if (equipment.isNotEmpty) {
        emitter(state.copyWith(equipments: equipment));
      }

      final service = await DatabaseProvider.getServiceJson();
      if (service.isNotEmpty) {
        emitter(state.copyWith(services: service));
      }

      final specialCpl = await DatabaseProvider.getSpecialCPLJson();
      if (specialCpl.isNotEmpty) {
        emitter(state.copyWith(specialJobCpl: specialCpl));
      }
      final position = await DatabaseProvider.getPositionJson();
      if (position.isNotEmpty) {
        emitter(state.copyWith(specialJobPosition: position));
      }

      final job = await DatabaseProvider.getJobJson();
      if (job.isNotEmpty) {
        emitter(state.copyWith(specialJobForm: job));
      }

      final autoCpl = await DatabaseProvider.getCPLAutoJson();
      if (autoCpl.isNotEmpty) {
        emitter(state.copyWith(autonomousCpl: autoCpl));
      }

      final autoEq = await DatabaseProvider.getEquipmentAutoJson();
      if (autoCpl.isNotEmpty) {
        emitter(state.copyWith(autonomousEquipment: autoEq));
      }

      final autoService = await DatabaseProvider.getServiceAutoJson();
      if (autoCpl.isNotEmpty) {
        emitter(state.copyWith(autonomousService: autoService));
      }

      if (area.isNotEmpty &&
          cpl.isNotEmpty &&
          equipment.isNotEmpty &&
          service.isNotEmpty) {
        final trx = await DatabaseProvider.getTransactionJson();
        final trxSJ = await DatabaseProvider.getTransactionSpecialJobJson();

        if (trx.transactions.isEmpty) {
          emitter(state.copyWith(
              transactions: const TransactionModel(),
              transactionsHistoryManual: const TransactionModel()));
        }

        if (trxSJ.transactions.isEmpty) {
          emitter(state.copyWith(
              transactionsSpecialJob: const TransactionModel(),
              transactionsHistorySpecial: const TransactionModel()));
        }
        var dateNow = DateTime.now();
        if (trx.transactions.isNotEmpty && user!.shift.isNotEmpty) {
          if (state.tglPatrol.isNotEmpty) {
            var dataTrx = trx.transactions
                .where((e) =>
                    (AppUtil.defaultTimeFormatCustom(
                            DateTime.parse(e.dateCreated), "yyyy-MM-dd") ==
                        state.tglPatrol) &&
                    e.shift == user.shift &&
                    e.patrol == user.patrol &&
                    e.userId == user.nik)
                .toList();
            List<Transaction> listTrx = [];
            for (var dataOrigin in dataTrx) {
              listTrx.add(dataOrigin.copyWith(editable: false));
            }
            //set trx manual berdasarkan kondisi sekarang
            final transactions = TransactionModel(transactions: listTrx);
            emitter(state.copyWith(
                transactions: transactions,
                transactionsHistoryManual: transactions));
          } else {
            var dataTrx = trx.transactions
                .where((e) =>
                    // e.userId == event.userId &&
                    AppUtil.defaultTimeFormatCustom(dateNow, "yyyy-MM-dd") ==
                        AppUtil.defaultTimeFormatCustom(
                            DateTime.parse(e.dateUpdated), "yyyy-MM-dd") &&
                    e.shift == user.shift &&
                    e.patrol == user.patrol &&
                    e.userId == user.nik)
                .toList();
            List<Transaction> listTrx = [];
            for (var dataOrigin in dataTrx) {
              listTrx.add(dataOrigin.copyWith(editable: false));
            }
            //set trx manual berdasarkan kondisi sekarang
            final transactions = TransactionModel(transactions: listTrx);
            emitter(state.copyWith(
                transactions: transactions,
                transactionsHistoryManual: transactions));
          }
        }

        if (trxSJ.transactions.isNotEmpty) {
          // final transactionsSps =
          //     TransactionModel(transactions: trxSJ.transactions);
          var historySj =
              trxSJ.transactions.where((e) => e.finishJob == true).toList();
          emitter(state.copyWith(
              transactionsSpecialJob: trxSJ,
              transactionsHistorySpecial: historySj));
        }
      }
    } catch (e, st) {
      if (kDebugMode) {
        log('Init EForm Exception[e] $e');
        log('Init EForm Exception[st] $st');
      }
    }
  }

  Future<void> _checkNfcReader(
      NfcReaderEvent event, Emitter<EFormState> emitter) async {
    bool isNfcAvailable = await NfcManager.instance.isAvailable();
    if (isNfcAvailable) {
      emitter(state.copyWith(nfcIsAvailable: true));
    } else {
      emitter(state.copyWith(nfcIsAvailable: false));
    }
  }

  Future<void> readNFCTag() async {}

  Future<void> _importFormats(
      ImportFormatsEvent event, Emitter<EFormState> emitter) async {
    try {
      final File? file = await AppUtil.readFile(['json']);
      if (file != null) {
        final jsonFile = await json.decode(file.readAsStringSync());
        FormatModel formatModel = FormatModel.fromJson(jsonFile);
        await DatabaseProvider.putFormatJson(formatModel);
        final data = await DatabaseProvider.getFormatsJson();
        if (data.isNotEmpty) {
          emitter(state.copyWith(formats: data));
          event.onSuccess();
        } else {
          event.onFailed('Daftar format kosong');
        }
      } else {
        event.onFailed('Tidak ada file format yang di import');
      }
    } catch (e, st) {
      if (kDebugMode) {
        log('Import Format Eform Exception[e]: $e');
        log('Import Format Eform Exception[st]: $st');
      }
      event.onFailed('Gagal mengimport file');
    }
  }

  Future<void> _importSections(
      ImportSectionEvent event, Emitter<EFormState> emitter) async {
    try {
      final File? file = await AppUtil.readFile(['json']);
      if (file != null) {
        final jsonFile = await json.decode(file.readAsStringSync());
        SectionModel section = SectionModel.fromJson(jsonFile);
        await DatabaseProvider.putSectionJson(section);
        final data = await DatabaseProvider.getSectionsJson();
        if (data.isNotEmpty) {
          emitter(state.copyWith(section: data));
          event.onSuccess();
        } else {
          event.onFailed('Daftar section kosong');
        }
      } else {
        event.onFailed('Tidak ada file  yang di import');
      }
    } catch (e, st) {
      if (kDebugMode) {
        log('Import Section Exception[e]: $e');
        log('Import Section Exception[st]: $st');
      }
      event.onFailed('Gagal mengimport file');
    }
  }

  Future<void> _importArea(
      ImportAreaEvent event, Emitter<EFormState> emitter) async {
    try {
      final File? file = await AppUtil.readFile(['json']);
      if (file != null) {
        final jsonFile = await json.decode(file.readAsStringSync());
        AreaModel area = AreaModel.fromJson(jsonFile);
        await DatabaseProvider.putAreaJson(area);
        final data = await DatabaseProvider.getAreaJson();
        if (data.isNotEmpty) {
          emitter(state.copyWith(areas: data));
          event.onSuccess();
        } else {
          event.onFailed('Daftar area kosong');
        }
      } else {
        event.onFailed('Tidak ada file yang di import');
      }
    } catch (e, st) {
      if (kDebugMode) {
        log('Import Area Exception[e]: $e');
        log('Import Area Exception[st]: $st');
      }
      event.onFailed('Gagal mengimport file');
    }
  }

  Future<void> _importCpl(
      ImportCplEvent event, Emitter<EFormState> emitter) async {
    try {
      final File? file = await AppUtil.readFile(['json']);
      if (file != null) {
        final jsonFile = await json.decode(file.readAsStringSync());
        CplModel cpl = CplModel.fromJson(jsonFile);
        await DatabaseProvider.putCPLJson(cpl);
        final data = await DatabaseProvider.getCPLJson();
        if (data.isNotEmpty) {
          emitter(state.copyWith(cpls: data));
          event.onSuccess();
        } else {
          event.onFailed('Daftar CPL kosong');
        }
      } else {
        event.onFailed('Tidak ada file yang di import');
      }
    } catch (e, st) {
      if (kDebugMode) {
        log('Import CPL Exception[e]: $e');
        log('Import CPL Exception[st]: $st');
      }
      event.onFailed('Gagal mengimport file');
    }
  }

  Future<void> _importEquipment(
      ImportEquipmentEvent event, Emitter<EFormState> emitter) async {
    try {
      final File? file = await AppUtil.readFile(['json']);
      if (file != null) {
        final jsonFile = await json.decode(file.readAsStringSync());
        EquipmentModel equipment = EquipmentModel.fromJson(jsonFile);
        await DatabaseProvider.putEquipmentJson(equipment);
        final data = await DatabaseProvider.getEquipmentJson();
        if (data.isNotEmpty) {
          emitter(state.copyWith(equipments: data));
          event.onSuccess();
        } else {
          event.onFailed('Daftar equipment kosong');
        }
      } else {
        event.onFailed('Tidak ada file yang di import');
      }
    } catch (e, st) {
      if (kDebugMode) {
        log('Import Equipment Exception[e]: $e');
        log('Import Equipment Exception[st]: $st');
      }
      event.onFailed('Gagal mengimport file');
    }
  }

  Future<void> _importServiceSpecial(
      ImportServiceSpecialEvent event, Emitter<EFormState> emitter) async {
    try {
      final File? file = await AppUtil.readFile(['json']);
      if (file != null) {
        final jsonFile = await json.decode(file.readAsStringSync());
        ServiceModel service = ServiceModel.fromJson(jsonFile);
        //validasi is spesial or not
        final dataEquipment = await DatabaseProvider.getEquipmentJson();
        List<Equipment> checkSpesial = dataEquipment
            .where((equipment) =>
                equipment.kodeEquipment == service.service[0].kodeEquipment)
            .toList();
        var tipeForm = "";
        if (checkSpesial.isNotEmpty) {
          tipeForm = checkSpesial[0].tipeCpl;
        }
        if (tipeForm == "Special") {
          //replace only
          final dataService = await DatabaseProvider.getServiceJson();
          List<Service> tmpService =
              dataService.where((s) => s.step.isEmpty).toList();
          tmpService.addAll(service.service);
          ServiceModel tempService = ServiceModel(service: tmpService);
          await DatabaseProvider.putServiceJson(tempService);
        } else {
          final dataService = await DatabaseProvider.getServiceJson();
          List<Service> tmpService =
              dataService.where((s) => s.step.isNotEmpty).toList();
          tmpService.addAll(service.service);
          ServiceModel tempService = ServiceModel(service: tmpService);
          await DatabaseProvider.putServiceJson(tempService);
        }
        // await DatabaseProvider.putServiceJson(service);
        final data = await DatabaseProvider.getServiceJson();
        if (data.isNotEmpty) {
          add(const InitEFormEvent());
          emitter(state.copyWith(
              services: data.where((s) => s.step.isNotEmpty).toList()));
          event.onSuccess();
        } else {
          event.onFailed('Daftar service kosong');
        }
      } else {
        event.onFailed('Tidak ada file yang di import');
      }
    } catch (e, st) {
      if (kDebugMode) {
        log('Import Service Exception[e]: $e');
        log('Import Service Exception[st]: $st');
      }
      event.onFailed('Gagal mengimport file');
    }
  }

  Future<void> _importService(
      ImportServiceEvent event, Emitter<EFormState> emitter) async {
    try {
      final File? file = await AppUtil.readFile(['json']);
      if (file != null) {
        final fileRaw = file.readAsBytesSync();
        String cleanFile = AppUtil.fixInvalidCharacters(
            utf8.decode(fileRaw, allowMalformed: true));
        final jsonFile = await json.decode(cleanFile);
        ServiceModel service = ServiceModel.fromJson(jsonFile);
        //validasi is spesial or not
        final dataEquipment = await DatabaseProvider.getEquipmentJson();
        List<Equipment> checkSpesial = dataEquipment
            .where((equipment) =>
                equipment.kodeEquipment == service.service[0].kodeEquipment)
            .toList();
        var tipeForm = "";
        if (checkSpesial.isNotEmpty) {
          tipeForm = checkSpesial[0].tipeCpl;
        }
        if (tipeForm == "Special") {
          //replace only
          final dataService = await DatabaseProvider.getServiceJson();
          List<Service> tmpService =
              dataService.where((s) => s.step.isEmpty).toList();
          tmpService.addAll(service.service);
          ServiceModel tempService = ServiceModel(service: tmpService);
          await DatabaseProvider.putServiceJson(tempService);
        } else {
          final dataService = await DatabaseProvider.getServiceJson();
          List<Service> tmpService =
              dataService.where((s) => s.step.isNotEmpty).toList();
          tmpService.addAll(service.service);
          ServiceModel tempService = ServiceModel(service: tmpService);
          await DatabaseProvider.putServiceJson(tempService);
        }
        // await DatabaseProvider.putServiceJson(service);
        final data = await DatabaseProvider.getServiceJson();
        if (data.isNotEmpty) {
          emitter(state.copyWith(services: data));
          event.onSuccess();
        } else {
          event.onFailed('Daftar service kosong');
        }
      } else {
        event.onFailed('Tidak ada file yang di import');
      }
    } catch (e, st) {
      if (kDebugMode) {
        log('Import Service Exception[e]: $e');
        log('Import Service Exception[st]: $st');
      }
      event.onFailed('Gagal mengimport file');
    }
  }

  Future<void> _importCplAuto(
      ImportCplAutoEvent event, Emitter<EFormState> emitter) async {
    try {
      final File? file = await AppUtil.readFile(['json']);
      if (file != null) {
        final jsonFile = await json.decode(file.readAsStringSync());
        CplModel cpl = CplModel.fromJson(jsonFile);
        await DatabaseProvider.putCPLAutoJson(cpl);
        final data = await DatabaseProvider.getCPLAutoJson();
        if (data.isNotEmpty) {
          emitter(state.copyWith(autonomousCpl: data));
          event.onSuccess();
        } else {
          event.onFailed('Daftar CPL kosong');
        }
      } else {
        event.onFailed('Tidak ada file yang di import');
      }
    } catch (e, st) {
      if (kDebugMode) {
        log('Import CPL Auto Exception[e]: $e');
        log('Import CPL Auto Exception[st]: $st');
      }
      event.onFailed('Gagal mengimport file');
    }
  }

  Future<void> _importEquipmentAuto(
      ImportEquipmentAutoEvent event, Emitter<EFormState> emitter) async {
    try {
      final File? file = await AppUtil.readFile(['json']);
      if (file != null) {
        final jsonFile = await json.decode(file.readAsStringSync());
        EquipmentModel equipment = EquipmentModel.fromJson(jsonFile);
        await DatabaseProvider.putEquipmentAutoJson(equipment);
        final data = await DatabaseProvider.getEquipmentAutoJson();
        if (data.isNotEmpty) {
          emitter(state.copyWith(autonomousEquipment: data));
          event.onSuccess();
        } else {
          event.onFailed('Daftar equipment kosong');
        }
      } else {
        event.onFailed('Tidak ada file yang di import');
      }
    } catch (e, st) {
      if (kDebugMode) {
        log('Import Equipment Auto Exception[e]: $e');
        log('Import Equipment Auto Exception[st]: $st');
      }
      event.onFailed('Gagal mengimport file');
    }
  }

  Future<void> _importServiceAuto(
      ImportServiceAutoEvent event, Emitter<EFormState> emitter) async {
    try {
      final File? file = await AppUtil.readFile(['json']);
      if (file != null) {
        final jsonFile = await json.decode(file.readAsStringSync());
        ServiceModel service = ServiceModel.fromJson(jsonFile);
        await DatabaseProvider.putServiceAutoJson(service);
        final data = await DatabaseProvider.getServiceAutoJson();
        if (data.isNotEmpty) {
          emitter(state.copyWith(autonomousService: data));
          event.onSuccess();
        } else {
          event.onFailed('Daftar service kosong');
        }
      } else {
        event.onFailed('Tidak ada file yang di import');
      }
    } catch (e, st) {
      if (kDebugMode) {
        log('Import Service Auto Exception[e]: $e');
        log('Import Service Auto Exception[st]: $st');
      }
      event.onFailed('Gagal mengimport file');
    }
  }

  Future<void> _importSpecialCpl(
      ImportSpecialCplEvent event, Emitter<EFormState> emitter) async {
    try {
      final File? file = await AppUtil.readFile(['json']);
      if (file != null) {
        final jsonFile = await json.decode(file.readAsStringSync());
        CplModel cpl = CplModel.fromJson(jsonFile);
        await DatabaseProvider.putSpecialCPLJson(cpl);
        final data = await DatabaseProvider.getSpecialCPLJson();
        if (data.isNotEmpty) {
          emitter(state.copyWith(specialJobCpl: data));
          event.onSuccess();
        } else {
          event.onFailed('Daftar CPL kosong');
        }
      } else {
        event.onFailed('Tidak ada file yang di import');
      }
    } catch (e, st) {
      if (kDebugMode) {
        log('Import CPL Special Exception[e]: $e');
        log('Import CPL Special Exception[st]: $st');
      }
      event.onFailed('Gagal mengimport file');
    }
  }

  Future<void> _importSpecialPosition(
      ImportSpecialPositionEvent event, Emitter<EFormState> emitter) async {
    try {
      final File? file = await AppUtil.readFile(['json']);
      if (file != null) {
        final jsonFile = await json.decode(file.readAsStringSync());
        List<Position> position = ((jsonFile as List?) ?? [])
            .map((e) => Position.fromJson(e))
            .toList();
        await DatabaseProvider.putPositionJson(position);
        final data = await DatabaseProvider.getPositionJson();
        if (data.isNotEmpty) {
          emitter(state.copyWith(specialJobPosition: data));
          event.onSuccess();
        } else {
          event.onFailed('Daftar special position kosong');
        }
      } else {
        event.onFailed('Tidak ada file yang di import');
      }
    } catch (e, st) {
      if (kDebugMode) {
        log('Import Special Position Exception[e]: $e');
        log('Import Special Position Exception[st]: $st');
      }
      event.onFailed('Gagal mengimport file');
    }
  }

  Future<void> _importSpecialJobForm(
      ImportSpecialJobFormEvent event, Emitter<EFormState> emitter) async {
    try {
      final File? file = await AppUtil.readFile(['json']);
      if (file != null) {
        final jsonFile = await json.decode(file.readAsStringSync());
        List<SpecialJob> jobs = ((jsonFile as List?) ?? [])
            .map((e) => SpecialJob.fromJson(e))
            .toList();
        await DatabaseProvider.putJobJson(jobs);
        final data = await DatabaseProvider.getJobJson();
        if (data.isNotEmpty) {
          emitter(state.copyWith(specialJobForm: data));
          event.onSuccess();
        } else {
          event.onFailed('Daftar special job form kosong');
        }
      } else {
        event.onFailed('Tidak ada file yang di import');
      }
    } catch (e, st) {
      if (kDebugMode) {
        log('Import Special Job Form Exception[e]: $e');
        log('Import Special Job Form Exception[st]: $st');
      }
      event.onFailed('Gagal mengimport file');
    }
  }

  Future<void> _searchFormats(
      SearchFormatsEvent event, Emitter<EFormState> emitter) async {
    final user = await DatabaseProvider.getSignedUserJson();

    final formats = await DatabaseProvider.getFormatsJson();
    var byDepartment =
        formats.where((e) => e.department == user?.department).toList();
    if (event.namaFormats.isNotEmpty) {
      List<Formats> data = byDepartment
          .where((e) => e.kodeFormat
              .toLowerCase()
              .contains(event.namaFormats.toLowerCase()))
          .toList();

      emitter(state.copyWith(formats: data));
    } else {
      emitter(state.copyWith(formats: byDepartment));
    }
  }

  Future<void> _searchSection(
      SearchSectionEvent event, Emitter<EFormState> emitter) async {
    final sections = await DatabaseProvider.getSectionsJson();
    var sectionFormat =
        sections.where((e) => e.kodeFormat == event.kodeFormat).toList();
    if (event.namaSection.isNotEmpty) {
      List<Section> data = sectionFormat
          .where((e) => e.namaSection
              .toLowerCase()
              .contains(event.namaSection.toLowerCase()))
          .toList();

      emitter(state.copyWith(sectionByFormat: data));
    } else {
      emitter(state.copyWith(sectionByFormat: sectionFormat));
    }
  }

  Future<void> _searchArea(
      SearchAreaEvent event, Emitter<EFormState> emitter) async {
    final areas = await DatabaseProvider.getAreaJson();
    var areaSection =
        areas.where((e) => e.kodeSection == event.kodeSection).toList();
    if (event.namaArea.isNotEmpty) {
      List<Area> data = areaSection
          .where((e) =>
              e.namaArea.toLowerCase().contains(event.namaArea.toLowerCase()))
          .toList();

      emitter(state.copyWith(areasBySection: data));
    } else {
      emitter(state.copyWith(areasBySection: areaSection));
    }
  }

  Future<void> _getAreaBySection(
      GetAreaBySectionEvent event, Emitter<EFormState> emitter) async {
    final area = await DatabaseProvider.getAreaJson();
    List<Area> data =
        area.where((e) => e.kodeSection == event.kodeSection).toList();
    emitter(
        state.copyWith(areasBySection: data, kodeSection: event.kodeSection));
  }

  Future<void> _getCplByArea(
      GetCplByAreaEvent event, Emitter<EFormState> emitter) async {
    final cpls = await DatabaseProvider.getCPLJson();
    List<Cpl> data = cpls
        .where((e) =>
            e.kodeArea == event.kodeArea && e.formatTipe == event.kodeFormat)
        .toList();
    emitter(state.copyWith(cplsByArea: data, kodeArea: event.kodeArea));
  }

  Future<void> _searchCpl(
      SearchCplEvent event, Emitter<EFormState> emitter) async {
    final cpls = await DatabaseProvider.getCPLJson();
    List<Cpl> dataCpl = cpls
        .where((e) =>
            e.kodeArea == state.kodeArea && e.formatTipe == event.kodeFormat)
        .toList();

    if (event.namaCpl.isNotEmpty) {
      List<Cpl> data = dataCpl
          .where((e) =>
              e.namaCpl.toLowerCase().contains(event.namaCpl.toLowerCase()))
          .toList();
      emitter(state.copyWith(cplsByArea: data));
    } else {
      emitter(state.copyWith(cplsByArea: dataCpl));
    }
  }

  Future<void> _getEquipmentByNFC(
      GetEquipmentByNfcTag event, Emitter<EFormState> emitter) async {
    final equipments = await DatabaseProvider.getEquipmentJson();
    List<Equipment> data =
        equipments.where((e) => e.kodeNfc == event.kodeNfc).toList();
    emitter(state.copyWith(equipmentsByCpl: data, kodeNfc: event.kodeNfc));
  }

  Future<void> _getSectionByKodeFormat(
      GetSectionByFormats event, Emitter<EFormState> emitter) async {
    final sections = await DatabaseProvider.getSectionsJson();
    List<Section> data =
        sections.where((e) => e.kodeFormat == event.kodeFormat).toList();
    emitter(state.copyWith(sectionByFormat: data));
  }

  Future<void> _getEquipmentByCpl(
      GetEquipmentByCplEvent event, Emitter<EFormState> emitter) async {
    final equipments = await DatabaseProvider.getEquipmentJson();
    final cpl = await DatabaseProvider.getCPLJson();
    List<Equipment> data =
        equipments.where((e) => e.kodeCpl == event.kodeCpl).toList();
    emitter(state.copyWith(equipmentsByCpl: data, kodeCpl: event.kodeCpl));
  }

  Future<void> _searchEquipment(
      SearchEquipmentEvent event, Emitter<EFormState> emitter) async {
    final equipments = await DatabaseProvider.getEquipmentJson();
    List<Equipment> dataEquipment =
        equipments.where((e) => e.kodeCpl == state.kodeCpl).toList();

    if (event.namaEquipment.isNotEmpty) {
      List<Equipment> data = dataEquipment
          .where((e) => e.namaEquipment
              .toLowerCase()
              .contains(event.namaEquipment.toLowerCase()))
          .toList();
      emitter(state.copyWith(equipmentsByCpl: data));
    } else {
      emitter(state.copyWith(equipmentsByCpl: dataEquipment));
    }
  }

  Future<void> _searchServices(
      GetServiceSearchByTag event, Emitter<EFormState> emitter) async {
    List<Service> dataServices = state.servicesByEquipment
        .where((e) => e.tag.contains(event.searchTag))
        .toList();

    if (event.searchTag.isNotEmpty) {
      emitter(state.copyWith(servicesBySearch: dataServices));
    } else {
      emitter(state.copyWith(servicesBySearch: []));
    }
  }

  Future<void> _getListHistorySpecialJob(
      GetListHistorySpecialJob event, Emitter<EFormState> emitter) async {
    final trx = await DatabaseProvider.getTransactionSpecialJobJson();
    if (trx.transactions.isNotEmpty) {
      List<Transaction> data =
          trx.transactions.where((e) => e.finishJob == true).toList();
      if (event.searchEquipment.isEmpty) {
        data = data;
      } else {
        data = data
            .where((se) => se.codeEquipmentName.contains(event.searchEquipment))
            .toList();
      }
      Map<String, List<dynamic>> groupedData = {};
      TransactionModel mt =
          TransactionModel(transactions: data.toSet().toList());
      for (var item in data) {
        final name = item
            .uuid; // Replace 'name' with the actual field name in your data model
        if (!groupedData.containsKey(name)) {
          groupedData[name] = [];
        }
        groupedData[name]?.add(item);
      }
      emitter(state.copyWith(transactionsHistorySpecial: mt));
    }
  }

  Future<void> _getTrxHistoryByFormat(GetTransactionHistoryByFormatEvent event,
      Emitter<EFormState> emitter) async {
    final trx = await DatabaseProvider.getTransactionJson();
    final user = await DatabaseProvider.getSignedUserJson();
    var dateNow = DateTime.now();
    if (trx.transactions.isNotEmpty) {
      // e.shift == user!.shift &&
      List<Transaction> data = [];
      if (state.tglPatrol.isNotEmpty) {
        data = trx.transactions
            .where((e) =>
                (AppUtil.defaultTimeFormatCustom(
                        DateTime.parse(e.dateCreated), "yyyy-MM-dd") ==
                    state.tglPatrol) &&
                e.patrol == user!.patrol &&
                e.userId == user.nik &&
                e.shift == user.shift)
            .toList();
      } else {
        data = trx.transactions
            .where((e) =>
                (AppUtil.defaultTimeFormatCustom(
                        DateTime.parse(e.dateCreated), "yyyy-MM-dd") ==
                    AppUtil.defaultTimeFormatCustom(dateNow, "yyyy-MM-dd")) &&
                e.patrol == user!.patrol &&
                e.userId == user.nik &&
                e.shift == user.shift)
            .toList();
      }
      if (event.filterFormat == 'All') {
        if (event.search.isEmpty) {
          data = data;
        } else {
          data = data
              .where((se) => se.codeCplName.contains(event.search))
              .toList();
        }
      } else {
        data = data.where((e) => e.codeFormat == event.filterFormat).toList();
        if (event.search.isNotEmpty) {
          data = data
              .where((se) => se.codeCplName.contains(event.search))
              .toList();
        }
      }
      Map<String, List<dynamic>> groupedData = {};
      TransactionModel mt =
          TransactionModel(transactions: data.toSet().toList());
      for (var item in data) {
        final name = item
            .uuid; // Replace 'name' with the actual field name in your data model
        if (!groupedData.containsKey(name)) {
          groupedData[name] = [];
        }
        groupedData[name]?.add(item);
      }
      // print();
      emitter(state.copyWith(transactionsHistoryManual: mt));
    }
  }

  //get list of special job all on database
  //check if not finished
  Future<void> _getTransactionSpecialJob(
      GetTransactionSpecial event, Emitter<EFormState> emitter) async {
    final trx = await DatabaseProvider.getTransactionSpecialJobJson();

    if (trx.transactions.isNotEmpty) {
      List<Transaction> data = trx.transactions
          .where((e) =>
              e.codeEquipment == event.kodeEquipment && e.finishJob != true)
          .toList();

      Map<String, List<dynamic>> groupedData = {};
      TransactionModel mt = TransactionModel(transactions: data);
      for (var item in data) {
        final name = item
            .uuid; // Replace 'name' with the actual field name in your data model
        if (!groupedData.containsKey(name)) {
          groupedData[name] = [];
        }
        groupedData[name]?.add(item);
      }
      List<Service> listService = [];
      //set state to service

      if (event.isAreaBloc) {
        for (var i in event.areaState.services) {
          var equipment = i.kodeEquipment;
          var toEqp = event.areaState.equipments
              .where((e) => e.kodeEquipment == equipment)
              .firstOrNull;
          var inTo = '';
          if (toEqp != null) {
            inTo = toEqp.to;
          }
          Transaction j = data.firstWhere(
              (transaction) => transaction.idService == i.idService,
              orElse: () => const Transaction());
          if (j.idService.isNotEmpty) {
            listService.add(i.copyWith(
              to: inTo,
              selectedTo: j.selectedTo,
              controlTf: j.controlTf,
              editable: j.textValue.isEmpty,
              shipName: j.shipName,
              amount: j.amount,
              isContinue: j.isContinue,
              textValue: j.textValue,
              fiA1Amount: j.fiA1Amount,
              fiB1Amount: j.fiB1Amount,
              fiB2Amount: j.fiB2Amount,
              estUnloadingB1MinA: j.estUnloadingB1MinA,
              estUnloadingB2MinB1: j.estUnloadingB2MinB1,
            ));
          } else {
            listService.add(i.copyWith(to: inTo));
          }
        }
      } else {
        var mainService = event.areaState.services
            .where((e) => e.kodeEquipment == event.kodeEquipment)
            .toList();
        for (var i in mainService) {
          var equipment = event.kodeEquipment;
          var toEqp = event.areaState.equipments
              .where((e) => e.kodeEquipment == equipment)
              .first
              .to;
          Transaction j = data.firstWhere(
              (transaction) => transaction.idService == i.idService,
              orElse: () => const Transaction());
          if (j.idService.isNotEmpty) {
            listService.add(i.copyWith(
              to: toEqp,
              selectedTo: j.selectedTo,
              controlTf: j.controlTf,
              editable: j.textValue.isEmpty,
              shipName: j.shipName,
              isContinue: j.isContinue,
              amount: j.amount,
              textValue: j.textValue,
              fiA1Amount: j.fiA1Amount,
              fiB1Amount: j.fiB1Amount,
              fiB2Amount: j.fiB2Amount,
              estUnloadingB1MinA: j.estUnloadingB1MinA,
              estUnloadingB2MinB1: j.estUnloadingB2MinB1,
            ));
          } else {
            listService.add(i.copyWith(to: toEqp));
          }
        }
      }

      //set service to service
      //grouping untuk mengidentifikasi continue / finish
      if (event.isAreaBloc) {
        emitter(state.copyWith(
            services: listService,
            transactionsSpecialJob: mt,
            kodeEquipment: event.kodeEquipment));
      } else {
        emitter(state.copyWith(
            servicesByEquipment: listService,
            transactionsSpecialJob: mt,
            kodeEquipment: event.kodeEquipment));
      }
    } else {
      //get by area state
      Map<String, List<dynamic>> groupedData = {};
      List<Transaction> data = trx.transactions
          .where((e) => e.codeEquipment == event.kodeEquipment)
          .toList();
      List<Service> listService = [];
      for (var item in data) {
        final name = item
            .uuid; // Replace 'name' with the actual field name in your data model
        if (!groupedData.containsKey(name)) {
          groupedData[name] = [];
        }
        groupedData[name]?.add(item);
      }
      var mainService = event.areaState.services
          .where((e) => e.kodeEquipment == event.kodeEquipment)
          .toList();
      for (var i in mainService) {
        var equipment = event.kodeEquipment;
        var toEqp = event.areaState.equipments
            .where((e) => e.kodeEquipment == equipment)
            .first
            .to;
        Transaction j = data.firstWhere(
            (transaction) => transaction.idService == i.idService,
            orElse: () => const Transaction());
        if (j.idService.isNotEmpty) {
          listService.add(i.copyWith(
            to: toEqp,
            editable: j.textValue.isEmpty,
            shipName: j.shipName,
            isContinue: j.isContinue,
            amount: j.amount,
            textValue: j.textValue,
            fiA1Amount: j.fiA1Amount,
            fiB1Amount: j.fiB1Amount,
            fiB2Amount: j.fiB2Amount,
            estUnloadingB1MinA: j.estUnloadingB1MinA,
            estUnloadingB2MinB1: j.estUnloadingB2MinB1,
          ));
        } else {
          listService.add(i.copyWith(to: toEqp));
        }
      }
      TransactionModel mt = TransactionModel(transactions: data);
      if (event.isAreaBloc) {
        emitter(state.copyWith(
            servicesByEquipment: listService,
            transactionsSpecialJob: mt,
            kodeEquipment: event.kodeEquipment));
      } else {
        emitter(state.copyWith(
            servicesByEquipment: listService,
            transactionsSpecialJob: mt,
            kodeEquipment: event.kodeEquipment));
      }
      // emitter(state.copyWith(transactionsSpecialJob: mt, kodeEquipment: event.kodeEquipment,services:dataService));
    }
  }

  Future<void> _validationServiceSpecialStep(
      ValidationServiceSpecialStep event, Emitter<EFormState> emitter) async {
    var evstep = event.steps;
    var nextStep = evstep;
    if (nextStep <= 2) {
      nextStep += 1;
    }

    final trx = await DatabaseProvider.getTransactionJson();

    if (event.areaState.transactions.transactions.isEmpty) {
      if (trx.transactions.isNotEmpty) {
        // emitter(state.copyWith(transactions: const TransactionModel()));
        List<Service> data = trx.transactions
            .where((e) =>
                e.codeEquipment == event.kodeEquipment &&
                e.steps == nextStep.toString())
            .map((e) => Service(
                unit: e.unit,
                tipeForm: e.formType,
                kodeNfc: e.codeNfc,
                kodeEquipment: e.codeEquipment,
                tag: e.tag,
                to: e.to,
                namaService: e.serviceName,
                idService: e.idService,
                maxValue: e.maxValue,
                minValue: e.minValue,
                correctOption: e.correctOption,
                valueOption: e.valueOption,
                checkBox: e.checkBox,
                step: e.steps,
                reportedCondition: e.reportedCondition,
                reportedImage: e.reportedImage,
                reportedRequest: e.reportedRequest,
                reportedDescription: e.reportedDescription,
                textValue: e.textValue))
            .toList();
        emitter(state.copyWith(
            currentStep: evstep,
            servicesByEquipment: data,
            kodeEquipment: event.kodeEquipment));
      }
    } else {
      final trx = await DatabaseProvider.getTransactionJson();
      // List<Service> data = event.areaState.transactions.transactions
      //     .where((e) =>
      //         e.codeEquipment == event.kodeEquipment &&
      //         e.steps == nextStep.toString())
      List<Service> data = trx.transactions
          .where((e) =>
              e.codeEquipment == event.kodeEquipment &&
              e.steps == nextStep.toString())
          .map((e) => Service(
              unit: e.unit,
              tipeForm: e.formType,
              kodeNfc: e.codeNfc,
              kodeEquipment: e.codeEquipment,
              tag: e.tag,
              to: e.to,
              namaService: e.serviceName,
              idService: e.idService,
              maxValue: e.maxValue,
              minValue: e.minValue,
              correctOption: e.correctOption,
              valueOption: e.valueOption,
              checkBox: e.checkBox,
              step: e.steps,
              reportedCondition: e.reportedCondition,
              reportedImage: e.reportedImage,
              reportedRequest: e.reportedRequest,
              reportedDescription: e.reportedDescription,
              textValue: e.textValue))
          .toList();
      emitter(state.copyWith(
          servicesByEquipment: data, kodeEquipment: event.kodeEquipment));
    }
  }

  Future<void> _getServiceByEquipmentStep(
      GetServiceSpecialStep event, Emitter<EFormState> emitter) async {
    var evstep = event.steps;
    var nextStep = evstep;
    if (nextStep <= 2) {
      nextStep += 1;
    }

    final trx = await DatabaseProvider.getTransactionSpecialJobJson();
    List<Service> listService = [];
    if (event.areaState.transactionsSpecialJob.transactions.isEmpty) {
      if (trx.transactions.isNotEmpty) {
        List<Service> data = event.byUuid.isEmpty
            ? trx.transactions
                .where((e) =>
                    e.codeEquipment == event.kodeEquipment &&
                    e.steps == nextStep.toString())
                .map((e) => Service(
                    unit: e.unit,
                    editable: e.finishJob ? false : true,
                    tipeForm: e.formType,
                    kodeNfc: e.codeNfc,
                    kodeEquipment: e.codeEquipment,
                    tag: e.tag,
                    to: e.to,
                    isContinue: e.isContinue,
                    namaService: e.serviceName,
                    idService: e.idService,
                    maxValue: e.maxValue,
                    minValue: e.minValue,
                    correctOption: e.correctOption,
                    amount: e.amount,
                    valueOption: e.valueOption,
                    checkBox: e.checkBox,
                    step: e.steps,
                    controlTf: e.controlTf,
                    fiA1Amount: e.fiA1Amount,
                    fiB1Amount: e.fiB1Amount,
                    fiB2Amount: e.fiB2Amount,
                    estUnloadingB1MinA: e.estUnloadingB1MinA,
                    estUnloadingB2MinB1: e.estUnloadingB2MinB1,
                    selectedTo: e.selectedTo,
                    reportedCondition: e.reportedCondition,
                    reportedImage: e.reportedImage,
                    reportedRequest: e.reportedRequest,
                    reportedDescription: e.reportedDescription,
                    textValue: e.textValue))
                .toList()
            : trx.transactions
                .where((e) =>
                    e.uuid == event.byUuid &&
                    e.codeEquipment == event.kodeEquipment &&
                    e.steps == nextStep.toString())
                .map((e) => Service(
                    unit: e.unit,
                    editable: e.finishJob ? false : true,
                    tipeForm: e.formType,
                    kodeNfc: e.codeNfc,
                    kodeEquipment: e.codeEquipment,
                    tag: e.tag,
                    isContinue: e.isContinue,
                    to: e.to,
                    amount: e.amount,
                    fiA1Amount: e.fiA1Amount,
                    fiB1Amount: e.fiB1Amount,
                    fiB2Amount: e.fiB2Amount,
                    estUnloadingB1MinA: e.estUnloadingB1MinA,
                    estUnloadingB2MinB1: e.estUnloadingB2MinB1,
                    namaService: e.serviceName,
                    idService: e.idService,
                    maxValue: e.maxValue,
                    minValue: e.minValue,
                    controlTf: e.controlTf,
                    selectedTo: e.selectedTo,
                    correctOption: e.correctOption,
                    valueOption: e.valueOption,
                    checkBox: e.checkBox,
                    step: e.steps,
                    reportedCondition: e.reportedCondition,
                    reportedImage: e.reportedImage,
                    reportedRequest: e.reportedRequest,
                    reportedDescription: e.reportedDescription,
                    textValue: e.textValue))
                .toList();

        List<Transaction> trxSpecialJob = [];
        if (event.byUuid.isNotEmpty) {
          trxSpecialJob =
              trx.transactions.where((e) => e.uuid == event.byUuid).toList();
        }
        emitter(state.copyWith(
            transactionsSpecialJob:
                TransactionModel(transactions: trxSpecialJob),
            currentStep: evstep,
            servicesByStep: data,
            kodeEquipment: event.kodeEquipment));
      }
    } else {
      final trx = await DatabaseProvider.getTransactionSpecialJobJson();
      //by step
      List<Service> data = event.byUuid.isEmpty
          ? trx.transactions
              .where((e) =>
                  e.codeEquipment == event.kodeEquipment &&
                  e.steps == nextStep.toString())
              .map((e) => Service(
                  unit: e.unit,
                  tipeForm: e.formType,
                  kodeNfc: e.codeNfc,
                  kodeEquipment: e.codeEquipment,
                  tag: e.tag,
                  isContinue: e.isContinue,
                  to: e.to,
                  controlTf: e.controlTf,
                  selectedTo: e.selectedTo,
                  editable: e.finishJob ? false : true,
                  namaService: e.serviceName,
                  idService: e.idService,
                  maxValue: e.maxValue,
                  minValue: e.minValue,
                  correctOption: e.correctOption,
                  valueOption: e.valueOption,
                  checkBox: e.checkBox,
                  amount: e.amount,
                  fiA1Amount: e.fiA1Amount,
                  fiB1Amount: e.fiB1Amount,
                  fiB2Amount: e.fiB2Amount,
                  estUnloadingB1MinA: e.estUnloadingB1MinA,
                  estUnloadingB2MinB1: e.estUnloadingB2MinB1,
                  step: e.steps,
                  shipName: e.shipName,
                  reportedCondition: e.reportedCondition,
                  reportedImage: e.reportedImage,
                  reportedRequest: e.reportedRequest,
                  reportedDescription: e.reportedDescription,
                  textValue: e.textValue))
              .toList()
          : trx.transactions
              .where((e) =>
                  e.uuid == event.byUuid &&
                  e.codeEquipment == event.kodeEquipment &&
                  e.steps == nextStep.toString())
              .map((e) => Service(
                  unit: e.unit,
                  tipeForm: e.formType,
                  kodeNfc: e.codeNfc,
                  amount: e.amount,
                  kodeEquipment: e.codeEquipment,
                  tag: e.tag,
                  isContinue: e.isContinue,
                  editable: e.finishJob ? false : true,
                  to: e.to,
                  controlTf: e.controlTf,
                  selectedTo: e.selectedTo,
                  shipName: e.shipName,
                  namaService: e.serviceName,
                  idService: e.idService,
                  maxValue: e.maxValue,
                  minValue: e.minValue,
                  correctOption: e.correctOption,
                  valueOption: e.valueOption,
                  checkBox: e.checkBox,
                  fiA1Amount: e.fiA1Amount,
                  fiB1Amount: e.fiB1Amount,
                  fiB2Amount: e.fiB2Amount,
                  estUnloadingB1MinA: e.estUnloadingB1MinA,
                  estUnloadingB2MinB1: e.estUnloadingB2MinB1,
                  step: e.steps,
                  reportedCondition: e.reportedCondition,
                  reportedImage: e.reportedImage,
                  reportedRequest: e.reportedRequest,
                  reportedDescription: e.reportedDescription,
                  textValue: e.textValue))
              .toList();

      List<Service> dataByEquipment = event.byUuid.isEmpty
          ? trx.transactions
              .where((e) => e.codeEquipment == event.kodeEquipment)
              .map((e) => Service(
                  unit: e.unit,
                  amount: e.amount,
                  tipeForm: e.formType,
                  kodeNfc: e.codeNfc,
                  kodeEquipment: e.codeEquipment,
                  tag: e.tag,
                  isContinue: e.isContinue,
                  to: e.to,
                  controlTf: e.controlTf,
                  selectedTo: e.selectedTo,
                  editable: e.finishJob ? false : true,
                  namaService: e.serviceName,
                  idService: e.idService,
                  maxValue: e.maxValue,
                  minValue: e.minValue,
                  correctOption: e.correctOption,
                  valueOption: e.valueOption,
                  checkBox: e.checkBox,
                  fiA1Amount: e.fiA1Amount,
                  fiB1Amount: e.fiB1Amount,
                  fiB2Amount: e.fiB2Amount,
                  estUnloadingB1MinA: e.estUnloadingB1MinA,
                  estUnloadingB2MinB1: e.estUnloadingB2MinB1,
                  step: e.steps,
                  shipName: e.shipName,
                  reportedCondition: e.reportedCondition,
                  reportedImage: e.reportedImage,
                  reportedRequest: e.reportedRequest,
                  reportedDescription: e.reportedDescription,
                  textValue: e.textValue))
              .toList()
          : trx.transactions
              .where((e) =>
                  e.uuid == event.byUuid &&
                  e.codeEquipment == event.kodeEquipment)
              .map((e) => Service(
                  unit: e.unit,
                  tipeForm: e.formType,
                  kodeNfc: e.codeNfc,
                  kodeEquipment: e.codeEquipment,
                  tag: e.tag,
                  isContinue: e.isContinue,
                  editable: e.finishJob ? false : true,
                  to: e.to,
                  controlTf: e.controlTf,
                  selectedTo: e.selectedTo,
                  shipName: e.shipName,
                  amount: e.amount,
                  namaService: e.serviceName,
                  idService: e.idService,
                  maxValue: e.maxValue,
                  minValue: e.minValue,
                  correctOption: e.correctOption,
                  valueOption: e.valueOption,
                  checkBox: e.checkBox,
                  fiA1Amount: e.fiA1Amount,
                  fiB1Amount: e.fiB1Amount,
                  fiB2Amount: e.fiB2Amount,
                  estUnloadingB1MinA: e.estUnloadingB1MinA,
                  estUnloadingB2MinB1: e.estUnloadingB2MinB1,
                  step: e.steps,
                  reportedCondition: e.reportedCondition,
                  reportedImage: e.reportedImage,
                  reportedRequest: e.reportedRequest,
                  reportedDescription: e.reportedDescription,
                  textValue: e.textValue))
              .toList();
      List<Transaction> trxSpecialJob = [];
      if (event.byUuid.isNotEmpty) {
        trxSpecialJob =
            trx.transactions.where((e) => e.uuid == event.byUuid).toList();
      }
      List<Service> serviceAreaState = [];
      if (event.isAreaBloc) {
        for (var i in event.areaState.services) {
          Service j = data.firstWhere(
              (trService) => trService.idService == i.idService,
              orElse: () => const Service());
          if (j.idService.isNotEmpty) {
            serviceAreaState.add(i.copyWith(
              editable: j.textValue.isEmpty,
              shipName: j.shipName,
              selectedTo: j.selectedTo,
              controlTf: j.controlTf,
              isContinue: j.isContinue,
              amount: j.amount,
              textValue: j.textValue,
              fiA1Amount: j.fiA1Amount,
              fiB1Amount: j.fiB1Amount,
              fiB2Amount: j.fiB2Amount,
              estUnloadingB1MinA: j.estUnloadingB1MinA,
              estUnloadingB2MinB1: j.estUnloadingB2MinB1,
            ));
          } else {
            serviceAreaState.add(i);
          }
        }
        emitter(state.copyWith(
          services: serviceAreaState,
        ));
      } else {
        emitter(state.copyWith(
            servicesByEquipment: dataByEquipment,
            transactionsSpecialJob:
                TransactionModel(transactions: trxSpecialJob),
            servicesByStep: data,
            kodeEquipment: event.kodeEquipment));
      }
    }
  }

//showing data by service unloading list
  Future<void> _getServiceSpecialUnloadingStep(
      GetServiceSpecialUnloadingStep event, Emitter<EFormState> emitter) async {
    var evstep = event.steps;
    var nextStep = evstep;
    if (nextStep <= 2) {
      nextStep += 1;
    }
    final dbTrx = await DatabaseProvider.getTransactionSpecialJobJson();

    List<Transaction> dataOrigin = [];
    if (event.uuid.isNotEmpty) {
      dataOrigin = dbTrx.transactions
          .where((e) =>
              e.codeEquipment == event.kodeEquipment && e.uuid == event.uuid)
          .toList();
    } else {
      dataOrigin = dbTrx.transactions
          .where((e) =>
              e.codeEquipment == event.kodeEquipment && e.finishJob != true)
          .toList();
    }

    List<Service> dataAreaState = event.areaState.services
        .where((e) =>
            e.kodeEquipment == event.kodeEquipment &&
            e.step == nextStep.toString())
        .toList();

    /**
       * 1.Cek dulu di Database tersimpan
       *   if(exist) -> set ke state (continue / finish)
       *   else -> set data baru daris service (new trx)
       */

    //cek get service by area state

    List<Service> dataStep1 = state.servicesByStep
        .where((e) => e.kodeEquipment == event.kodeEquipment && e.step == "1")
        .toList();

    var _shipName = dataStep1.isNotEmpty ? dataStep1[0].shipName : '';
    var _amount = dataStep1.isNotEmpty ? dataStep1[0].amount : 0.0;
    var _fiA1Amount = dataStep1.isNotEmpty ? dataStep1[0].fiA1Amount : 0.0;
    List<Service> listService = [];
    List<Service> listServiceAreaBloc = [];
    //cek berdasarkan equipment dan step
    var doServiceExist = dataOrigin
        .where((e) =>
            e.codeEquipment == event.kodeEquipment &&
            e.steps == nextStep.toString())
        .isNotEmpty;
    if (doServiceExist) {
      listService = dataOrigin
          .where((e) =>
              e.codeEquipment == event.kodeEquipment &&
              e.steps == nextStep.toString())
          .map((e) => Service(
              unit: e.unit,
              tipeForm: e.formType,
              kodeNfc: e.codeNfc,
              kodeEquipment: e.codeEquipment,
              tag: e.tag,
              to: e.to,
              isContinue: e.isContinue, //unloading
              namaService: e.serviceName,
              idService: e.idService,
              maxValue: e.maxValue,
              minValue: e.minValue,
              correctOption: e.correctOption,
              valueOption: e.valueOption,
              checkBox: e.checkBox,
              step: e.steps,
              shipName: e.shipName,
              amount: e.amount,
              fiA1Amount: e.fiA1Amount,
              fiB1Amount: e.fiB1Amount,
              fiB2Amount: e.fiB2Amount,
              estUnloadingB1MinA: e.estUnloadingB1MinA,
              estUnloadingB2MinA: e.estUnloadingB2MinA,
              estUnloadingB2MinB1: e.estUnloadingB2MinB1,
              reportedCondition: e.reportedCondition,
              reportedImage: e.reportedImage,
              reportedRequest: e.reportedRequest,
              reportedDescription: e.reportedDescription,
              textValue: e.textValue))
          .toList();
    } else {
      listService = dataAreaState;
    }
    if (event.isAreaBloc) {
      for (var i in event.areaState.services) {
        var j = listService
            .where((trService) => trService.idService == i.idService)
            .firstOrNull;
        if (j != null) {
          listServiceAreaBloc.add(i.copyWith(
            editable: j.textValue.isEmpty,
            shipName: j.shipName,
            selectedTo: j.selectedTo,
            controlTf: j.controlTf,
            isContinue: j.isContinue,
            amount: j.amount,
            textValue: j.textValue,
            fiA1Amount: j.fiA1Amount,
            fiB1Amount: j.fiB1Amount,
            fiB2Amount: j.fiB2Amount,
            estUnloadingB1MinA: j.estUnloadingB1MinA,
            estUnloadingB2MinB1: j.estUnloadingB2MinB1,
          ));
        } else {
          listServiceAreaBloc.add(i);
        }
      }
      emitter(state.copyWith(
          services: listServiceAreaBloc, kodeEquipment: event.kodeEquipment));
    } else {
      emitter(state.copyWith(
          currentStep: evstep,
          servicesByStep: listService,
          kodeEquipment: event.kodeEquipment));
    }
  }

  Future<void> _getServiceSpecialTransferStep(
      GetServiceSpecialTransferStep event, Emitter<EFormState> emitter) async {
    var evstep = event.steps;
    var nextStep = evstep;
    if (nextStep <= 2) {
      nextStep += 1;
    }

    final dbTrx = await DatabaseProvider.getTransactionSpecialJobJson();

    List<Transaction> dataOrigin = [];
    if (event.uuid.isNotEmpty) {
      dataOrigin = dbTrx.transactions
          .where((e) =>
              e.codeEquipment == event.kodeEquipment && e.uuid == event.uuid)
          .toList();
    } else {
      dataOrigin = dbTrx.transactions
          .where((e) =>
              e.codeEquipment == event.kodeEquipment && e.finishJob != true)
          .toList();
    }

    List<Service> dataAreaState = event.areaState.services
        .where((e) =>
            e.kodeEquipment == event.kodeEquipment &&
            e.step == nextStep.toString())
        .toList();

    /**
       * 1.Cek dulu di Database tersimpan
       *   if(exist) -> set ke state (continue / finish)
       *   else -> set data baru daris service (new trx)
       */

    List<Service> listService = [];
    //cek berdasarkan equipment dan step
    var doServiceExist = dataOrigin
        .where((e) =>
            e.codeEquipment == event.kodeEquipment &&
            e.steps == nextStep.toString())
        .isNotEmpty;
    Equipment Eqpto = event.areaState.equipments
        .firstWhere((e) => e.kodeEquipment == event.kodeEquipment);
    if (doServiceExist) {
      listService = dataOrigin
          .where((e) =>
              e.codeEquipment == event.kodeEquipment &&
              e.steps == nextStep.toString())
          .map((e) => Service(
              unit: e.unit,
              editable: e.textValue.isEmpty,
              tipeForm: e.formType,
              kodeNfc: e.codeNfc,
              kodeEquipment: e.codeEquipment,
              tag: e.tag,
              controlTf: e.controlTf,
              selectedTo: e.selectedTo,
              to: Eqpto.to,
              namaService: e.serviceName,
              idService: e.idService,
              maxValue: e.maxValue,
              minValue: e.minValue,
              correctOption: e.correctOption,
              valueOption: e.valueOption,
              checkBox: e.checkBox,
              step: e.steps,
              shipName: e.shipName,
              amount: e.amount,
              fiA1Amount: e.fiA1Amount,
              fiB1Amount: e.fiB1Amount,
              estUnloadingB1MinA: e.estUnloadingB1MinA,
              estUnloadingB2MinA: e.estUnloadingB2MinA,
              estUnloadingB2MinB1: e.estUnloadingB2MinB1,
              reportedCondition: e.reportedCondition,
              reportedImage: e.reportedImage,
              reportedRequest: e.reportedRequest,
              reportedDescription: e.reportedDescription,
              textValue: e.textValue))
          .toList();
    } else {
      dataAreaState.forEach((el) {
        listService.add(el.copyWith(
          to: Eqpto.to,
          editable: true,
        ));
      });
    }
    List<Service> listServiceAreaBloc = [];
    if (event.isAreaBloc) {
      for (var i in event.areaState.services) {
        Service j = listService
            .where((trService) => trService.idService == i.idService)
            .first;
        if (j.idService.isNotEmpty) {
          listServiceAreaBloc.add(i.copyWith(
            editable: j.textValue.isEmpty,
            shipName: j.shipName,
            selectedTo: j.selectedTo,
            controlTf: j.controlTf,
            isContinue: j.isContinue,
            amount: j.amount,
            textValue: j.textValue,
            fiA1Amount: j.fiA1Amount,
            fiB1Amount: j.fiB1Amount,
            fiB2Amount: j.fiB2Amount,
            estUnloadingB1MinA: j.estUnloadingB1MinA,
            estUnloadingB2MinB1: j.estUnloadingB2MinB1,
          ));
        } else {
          listServiceAreaBloc.add(i);
        }
      }
      emitter(state.copyWith(
          services: listServiceAreaBloc, kodeEquipment: event.kodeEquipment));
    } else {
      emitter(state.copyWith(
          servicesByStep: listService, kodeEquipment: event.kodeEquipment));
    }
  }

  Future<void> _getServiceByEquipment(
      GetServiceByEquipmentEvent event, Emitter<EFormState> emitter) async {
    final user = await DatabaseProvider.getSignedUserJson();

    if (event.areaState.transactions.transactions.isEmpty) {
      if (event.steps.isNotEmpty) {
        List<Service> data = event.areaState.services
            .where((e) =>
                e.kodeEquipment == event.kodeEquipment && e.step == event.steps)
            .toList();
        emitter(state.copyWith(
            servicesByEquipment: data, kodeEquipment: event.kodeEquipment));
      } else {
        //normal
        List<Service> data = event.areaState.services
            .where((e) =>
                e.kodeEquipment == event.kodeEquipment &&
                e.getShiftList().contains(user?.shift))
            .toList();
        List<Service> listService = [];
        for (var checkService in data) {
          listService.add(checkService.copyWith(editable: true));
        }
        emitter(state.copyWith(
            servicesByEquipment: listService,
            kodeEquipment: event.kodeEquipment));
      }
    } else {
      var dataExistTrx = event.areaState.transactions.transactions
          .where((e) =>
              e.codeEquipment == event.kodeEquipment &&
              e.shift == user!.shift &&
              e.patrol == user.patrol &&
              e.userId == user.nik)
          .toList();
      List<Service> dataService = event.areaState.services
          .where((e) =>
              e.kodeEquipment == event.kodeEquipment &&
              e.getShiftList().contains(user?.shift))
          .toList();
      List<Service> listService = [];
      bool foundMatch = false;
      for (var checkService in dataService) {
        for (var trxService in dataExistTrx) {
          if (checkService.idService == trxService.idService) {
            foundMatch = true;
            var e = trxService;
            listService.add(Service(
                isSync: e.isSync == 1, //check if true
                editable: e.editable,
                unit: e.unit,
                tipeForm: e.formType,
                kodeNfc: e.codeNfc,
                kodeEquipment: e.codeEquipment,
                tag: e.tag,
                namaService: e.serviceName,
                idService: e.idService,
                maxValue: e.maxValue,
                minValue: e.minValue,
                correctOption: e.correctOption,
                valueOption: e.valueOption,
                checkBox: e.checkBox,
                reportedCondition: e.reportedCondition,
                reportedImage: e.reportedImage,
                reportedImage2: e.reportedImage2,
                reportedRequest: e.reportedRequest,
                reportedDescription: e.reportedDescription,
                textValue: e.textValue));
            break; // No need to continue the inner loop as we found a match
          }
        }
        if (foundMatch) {
        } else {
          listService.add(checkService.copyWith(editable: true));
        }
      }
      List<Service> data = event.areaState.transactions.transactions
          .where((e) =>
              e.codeEquipment == event.kodeEquipment &&
              e.shift == user!.shift &&
              e.patrol == user.patrol &&
              e.userId == user.nik)
          .map((e) => Service(
              isSync: e.isSync == 1, //ch
              editable: e.editable,
              unit: e.unit,
              tipeForm: e.formType,
              kodeNfc: e.codeNfc,
              kodeEquipment: e.codeEquipment,
              tag: e.tag,
              namaService: e.serviceName,
              idService: e.idService,
              maxValue: e.maxValue,
              minValue: e.minValue,
              correctOption: e.correctOption,
              valueOption: e.valueOption,
              checkBox: e.checkBox,
              reportedCondition: e.reportedCondition,
              reportedImage: e.reportedImage,
              reportedImage2: e.reportedImage2,
              reportedRequest: e.reportedRequest,
              reportedDescription: e.reportedDescription,
              textValue: e.textValue))
          .toList();
      emitter(state.copyWith(
          servicesByEquipment: listService,
          kodeEquipment: event.kodeEquipment));
    }
  }

  Future<void> _changeDetectedStateServiceByEquipment(
      ChangeDetectedStateServiceByEquipmentEvent event,
      Emitter<EFormState> emitter) async {
    final user = await DatabaseProvider.getSignedUserJson();
    // .where((e) => e.getShiftList().contains(user?.shift))
    if (state.transactions.transactions.isEmpty) {
      List<Service> listService = [];
      var masterService =
          (event.isAreaBloc ? state.services : state.servicesByEquipment)
              // .where((e) => e.getShiftList().contains(user?.shift))
              .toList();
      for (var i in masterService) {
        if (i.idService == event.idService) {
          listService.add(i.copyWith(
              checkBox: event.value == true ? 2 : 0,
              textValue: event.value == true ? 'ND' : ''));
        } else {
          listService.add(i);
        }
      }
      if (event.isAreaBloc) {
        emitter(state.copyWith(services: listService));
      } else {
        emitter(state.copyWith(servicesByEquipment: listService));
      }
    } else {
      if (event.isAreaBloc) {
        List<Service> listService = [];
        var masterService = state.services
            // .where((e) => e.getShiftList().contains(user?.shift))
            .toList();
        for (var i in masterService) {
          if (i.idService == event.idService) {
            listService.add(i.copyWith(
                checkBox: event.value == true ? 2 : 0,
                textValue: event.value == true ? 'ND' : ''));
          } else {
            listService.add(i);
          }
        }
        List<Transaction> transactions = [];
        for (var i in (state.transactions.transactions)) {
          if (i.idService == event.idService) {
            transactions.add(i.copyWith(
                checkBox: event.value == true ? 2 : 0,
                textValue: event.value == true ? 'ND' : ''));
          } else {
            transactions.add(i);
          }
        }
        emitter(state.copyWith(
            transactions: TransactionModel(transactions: transactions),
            services: listService));
      } else {
        List<Service> listService = [];
        for (var i in (state.servicesByEquipment)) {
          if (i.idService == event.idService) {
            listService.add(i.copyWith(
                checkBox: event.value == true ? 2 : 0,
                textValue: event.value == true ? 'ND' : ''));
          } else {
            listService.add(i);
          }
        }
        emitter(state.copyWith(servicesByEquipment: listService));
      }
    }
  }

  Future<void> _changeStopStateServiceByEquipment(
      ChangeStopStateServiceByEquipmentEvent event,
      Emitter<EFormState> emitter) async {
    final user = await DatabaseProvider.getSignedUserJson();

    if (state.transactions.transactions.isEmpty) {
      List<Service> listService = [];
      for (var i
          in (event.isAreaBloc ? state.services : state.servicesByEquipment)) {
        if (i.idService == event.idService) {
          listService.add(i.copyWith(
              checkBox: event.value == true ? 1 : 0,
              textValue: event.value == true ? 'STOP' : ''));
        } else {
          listService.add(i);
        }
      }
      if (event.isAreaBloc) {
        emitter(state.copyWith(services: listService));
      } else {
        emitter(state.copyWith(servicesByEquipment: listService));
      }
    } else {
      if (event.isAreaBloc) {
        List<Service> listService = [];
        List<Transaction> transactions = [];
        var masterTrx = state.transactions.transactions
            .where((e) => e.getShiftList().contains(user?.shift));

        for (var i in masterTrx) {
          if (i.idService == event.idService) {
            transactions.add(i.copyWith(
                checkBox: event.value == true ? 1 : 0,
                textValue: event.value == true ? 'STOP' : ''));
          } else {
            transactions.add(i);
          }
        }
        var masterService = state.services;
        for (var m in masterService) {
          if (m.idService == event.idService) {
            listService.add(m.copyWith(
                checkBox: event.value == true ? 1 : 0,
                textValue: event.value == true ? 'STOP' : ''));
          } else {
            listService.add(m);
          }
        }
        emitter(state.copyWith(
            transactions: TransactionModel(transactions: transactions),
            services: listService));
      } else {
        List<Service> listService = [];
        for (var i in (state.servicesByEquipment)) {
          if (i.idService == event.idService) {
            listService.add(i.copyWith(
                checkBox: event.value == true ? 1 : 0,
                textValue: event.value == true ? 'STOP' : ''));
          } else {
            listService.add(i);
          }
        }
        emitter(state.copyWith(servicesByEquipment: listService));
      }
    }
  }

//update areabloc ->service,transactionspecialjob
  Future<void> _changeSelectControlTOSpecialTFEvent(
      ChangeSelectControlTOSpecialTFEvent event,
      Emitter<EFormState> emitter) async {
    var evstep = event.currentStep;
    var nextStep = evstep;
    if (nextStep <= 2) {
      nextStep += 1;
    }
    if (state.transactionsSpecialJob.transactions.isEmpty) {
      List<Service> listService = [];
      for (var i
          in (event.isAreaBloc ? state.services : state.servicesByStep)) {
        if (i.kodeEquipment == event.equipmentCode) {
          // i.step == nextStep.toString()) {
          if (event.type == 'control') {
            listService.add(i.copyWith(controlTf: event.value));
          } else {
            listService.add(i.copyWith(selectedTo: event.value));
          }
        } else {
          listService.add(i);
        }
      }
      if (event.isAreaBloc) {
        emitter(state.copyWith(services: listService));
      } else {
        emitter(state.copyWith(servicesByStep: listService));
      }
    } else {
      if (event.isAreaBloc) {
        List<Transaction> transactions = [];
        for (var i in (state.transactionsSpecialJob.transactions)) {
          if (i.codeEquipment == event.equipmentCode) {
            // i.steps == nextStep.toString()) {
            if (event.type == 'control') {
              transactions.add(i.copyWith(controlTf: event.value));
            } else {
              transactions.add(i.copyWith(selectedTo: event.value));
            }
          } else {
            transactions.add(i);
          }
        }
        emitter(state.copyWith(
            transactionsSpecialJob:
                TransactionModel(transactions: transactions)));
      } else {
        List<Service> listService = [];
        for (var i
            in (event.isAreaBloc ? state.services : state.servicesByStep)) {
          if (i.kodeEquipment == event.equipmentCode) {
            // i.step == nextStep.toString()) {
            if (event.type == 'control') {
              listService.add(i.copyWith(controlTf: event.value));
            } else {
              listService.add(i.copyWith(selectedTo: event.value));
            }
          } else {
            listService.add(i);
          }
        }
        emitter(state.copyWith(servicesByStep: listService));
      }
    }
  }

  Future<void> _changeTextValueStateServiceByStepUnloadingEvent(
      ChangeTextValueStateServiceByStepUnloadingEvent event,
      Emitter<EFormState> emitter) async {
    if (state.transactionsSpecialJob.transactions.isEmpty) {
      List<Service> listService = [];

      for (var i
          in (event.isAreaBloc ? state.services : state.servicesByStep)) {
        if (i.idService == event.idService) {
          listService.add(
              i.copyWith(textValue: event.value, shipName: event.shipName));
        } else {
          listService.add(i);
        }
      }

      if (event.isAreaBloc) {
        emitter(state.copyWith(services: listService));
      } else {
        emitter(state.copyWith(servicesByStep: listService));
      }
    } else {
      List<Service> listService = [];
      //update isi transaction
      for (var i
          in (event.isAreaBloc ? state.services : state.servicesByStep)) {
        if (i.idService == event.idService) {
          listService.add(
              i.copyWith(textValue: event.value, shipName: event.shipName));
        } else {
          listService.add(i);
        }
      }
      if (event.isAreaBloc) {
        List<Transaction> transactions = [];
        for (var i in (state.transactionsSpecialJob.transactions)) {
          if (i.idService == event.idService) {
            transactions.add(
                i.copyWith(textValue: event.value, shipName: event.shipName));
          } else {
            transactions.add(i);
          }
        }
        emitter(state.copyWith(
            services: listService,
            transactionsSpecialJob:
                TransactionModel(transactions: transactions)));
      } else {
        emitter(state.copyWith(
          servicesByStep: listService,
        ));
      }
    }
  }

  Future<void> _changeTextValueStateServiceByStepTransferEvent(
      ChangeTextValueStateServiceByStepTransferEvent event,
      Emitter<EFormState> emitter) async {
    if (state.transactionsSpecialJob.transactions.isEmpty) {
      List<Service> listService = [];

      for (var i
          in (event.isAreaBloc ? state.services : state.servicesByStep)) {
        if (i.idService == event.idService) {
          listService.add(
              i.copyWith(textValue: event.value, shipName: event.shipName));
        } else {
          listService.add(i);
        }
      }

      if (event.isAreaBloc) {
        emitter(state.copyWith(services: listService));
      } else {
        emitter(state.copyWith(servicesByStep: listService));
      }
    } else {
      List<Service> listService = [];
      //update isi transaction
      for (var i
          in (event.isAreaBloc ? state.services : state.servicesByStep)) {
        if (i.idService == event.idService) {
          listService.add(
              i.copyWith(textValue: event.value, shipName: event.shipName));
        } else {
          listService.add(i);
        }
      }
      if (event.isAreaBloc) {
        List<Transaction> transactions = [];
        for (var i in (state.transactionsSpecialJob.transactions)) {
          if (i.idService == event.idService) {
            transactions.add(
                i.copyWith(textValue: event.value, shipName: event.shipName));
          } else {
            transactions.add(i);
          }
        }
        emitter(state.copyWith(
            services: listService,
            transactionsSpecialJob:
                TransactionModel(transactions: transactions)));
      } else {
        emitter(state.copyWith(
          servicesByStep: listService,
        ));
      }
    }
  }

  Future<void> _changeTextValueStateServiceByEquipment(
      ChangeTextValueStateServiceByEquipmentEvent event,
      Emitter<EFormState> emitter) async {
    //check trx berdasarkan
    var checkTrxExisting = state.transactions.transactions
        .where((e) => e.idService == event.idService)
        .isEmpty;
    if (checkTrxExisting) {
      operate({bool isReport = false}) {
        List<Service> listService = [];
        for (var i in (event.isAreaBloc
            ? state.services
            : state.servicesByEquipment)) {
          if (i.idService == event.idService) {
            if (isReport) {
              listService.add(i.copyWith(reportedDescription: event.value));
            } else {
              listService.add(i.copyWith(textValue: event.value));
            }
          } else {
            listService.add(i);
          }
        }
        if (event.isAreaBloc) {
          emitter(state.copyWith(services: listService));
        } else {
          emitter(state.copyWith(servicesByEquipment: listService));
        }
      }

      if (!event.isRadio && !event.isReport) {
        if (AppUtil.isNumeric(event.value)) operate();
      } else if (event.isReport) {
        operate(isReport: event.isReport);
      } else {
        operate();
      }
    } else {
      operate({bool isReport = false}) {
        if (event.isAreaBloc) {
          List<Transaction> transactions = [];
          for (var i in (state.transactions.transactions)) {
            if (i.idService == event.idService) {
              if (isReport) {
                transactions.add(i.copyWith(reportedDescription: event.value));
              } else {
                transactions.add(i.copyWith(textValue: event.value));
              }
            } else {
              transactions.add(i);
            }
          }
          emitter(state.copyWith(
              transactions: TransactionModel(transactions: transactions)));
        } else {
          List<Service> listService = [];
          for (var i in (state.servicesByEquipment)) {
            if (i.idService == event.idService) {
              if (isReport) {
                listService.add(i.copyWith(reportedDescription: event.value));
              } else {
                listService.add(i.copyWith(textValue: event.value));
              }
            } else {
              listService.add(i);
            }
          }
          emitter(state.copyWith(servicesByEquipment: listService));
        }
      }

      if (!event.isRadio && !event.isReport) {
        if (AppUtil.isNumeric(event.value)) operate();
      } else if (event.isReport) {
        operate(isReport: event.isReport);
      } else {
        operate();
      }
    }
  }

  //Special job Skip
  Future<void> _changeSkipStateAllServiceByEquipmentEvent(
      ChangeSkipStateAllServiceByEquipmentEvent event,
      Emitter<EFormState> emitter) async {
    final user = await DatabaseProvider.getSignedUserJson();
    // .where((e) => e.getShiftList().contains(user?.shift))
    if (state.transactions.transactions.isEmpty) {
      List<Service> listService = [];
      var masterService =
          (event.isAction ? state.servicesByEquipment : state.services)
              .where((e) => e.getShiftList().contains(user?.shift));
      for (var i in masterService) {
        if (i.kodeEquipment == event.equipmentCode) {
          listService.add(i.copyWith(
              checkBox: event.value == true ? 0 : 0,
              textValue: event.value == true ? 'SKIP' : ''));
        } else {
          listService.add(i);
        }
      }
      if (event.isAction) {
        emitter(state.copyWith(servicesByEquipment: listService));
      } else {
        emitter(state.copyWith(services: listService));
      }
    } else {
      if (event.isAreaBloc) {
        List<Transaction> transactions = [];
        List<Service> listService = [];
        var masterTrx = state.transactions.transactions;
        // .where((e) => e.getShiftList().contains(user?.shift));
        for (var i in masterTrx) {
          if (i.codeEquipment == event.equipmentCode) {
            transactions.add(i.copyWith(
                checkBox: event.value == true ? 0 : 0,
                textValue: event.value == true ? 'SKIP' : ''));
          } else {
            transactions.add(i);
          }
        }

        var masterService = state.services;
        for (var i in masterService) {
          if (i.kodeEquipment == event.equipmentCode) {
            listService.add(i.copyWith(
                checkBox: event.value == true ? 0 : 0,
                textValue: event.value == true ? 'SKIP' : ''));
          } else {
            listService.add(i);
          }
        }
        emitter(state.copyWith(
            transactions: TransactionModel(transactions: transactions),
            services: listService));
      } else {
        List<Service> listService = [];
        var masterService =
            (event.isAction ? state.servicesByEquipment : state.services);
        // .where((e) => e.getShiftList().contains(user?.shift));
        for (var i in masterService) {
          if (i.kodeEquipment == event.equipmentCode) {
            listService.add(i.copyWith(
                checkBox: event.value == true ? 0 : 0,
                textValue: event.value == true ? 'SKIP' : ''));
          } else {
            listService.add(i);
          }
        }
        emitter(state.copyWith(servicesByEquipment: listService));
      }
    }
  }

  Future<void> _changeDetectedStateAllServiceByEquipment(
      ChangeDetectedStateAllServiceByEquipmentEvent event,
      Emitter<EFormState> emitter) async {
    final user = await DatabaseProvider.getSignedUserJson();
    if (state.transactions.transactions.isEmpty) {
      List<Service> listService = [];
      var masterService =
          (event.isAction ? state.servicesByEquipment : state.services)
              // .where((e) => e.getShiftList().contains(user?.shift))
              .toList();

      for (var i in masterService) {
        if (i.kodeEquipment == event.equipmentCode) {
          listService.add(i.copyWith(
              checkBox: event.value == true ? 2 : 0,
              textValue: event.value == true ? 'ND' : ''));
        } else {
          listService.add(i);
        }
      }
      if (event.isAction) {
        emitter(state.copyWith(servicesByEquipment: listService));
      } else {
        emitter(state.copyWith(services: listService));
      }
    } else {
      if (event.isAreaBloc) {
        List<Transaction> transactions = [];
        List<Service> listService = [];
        var masterTrx = state.transactions.transactions
            .where((e) => e.getShiftList().contains(user?.shift));

        //adding to service value
        for (var i in masterTrx) {
          if (i.codeEquipment == event.equipmentCode) {
            transactions.add(i.copyWith(
                checkBox: event.value == true ? 2 : 0,
                textValue: event.value == true ? 'ND' : ''));
          } else {
            transactions.add(i);
          }
        }
        var masterService = state.services;
        for (var m in masterService) {
          if (m.kodeEquipment == event.equipmentCode) {
            listService.add(m.copyWith(
                checkBox: event.value == true ? 2 : 0,
                textValue: event.value == true ? 'ND' : ''));
          } else {
            listService.add(m);
          }
        }
        emitter(state.copyWith(
            transactions: TransactionModel(transactions: transactions),
            services: listService));
        // emitter(state.copyWith(transactions: TransactionModel(transactions: transactions)));
      } else {
        List<Service> listService = [];
        var masterService =
            (event.isAction ? state.servicesByEquipment : state.services)
                .where((e) => e.getShiftList().contains(user?.shift))
                .toList();
        for (var i in masterService) {
          if (i.kodeEquipment == event.equipmentCode) {
            listService.add(i.copyWith(
                checkBox: event.value == true ? 2 : 0,
                textValue: event.value == true ? 'ND' : ''));
          } else {
            listService.add(i);
          }
        }
        emitter(state.copyWith(servicesByEquipment: listService));
      }
    }
  }

  Future<void> _changeStopStateAllServiceByEquipment(
      ChangeStopStateAllServiceByEquipmentEvent event,
      Emitter<EFormState> emitter) async {
    final user = await DatabaseProvider.getSignedUserJson();
    final trx = await DatabaseProvider.getTransactionJson();
    if (state.transactions.transactions.isEmpty) {
      List<Service> listService = [];
      var masterService =
          (event.isAreaBloc ? state.services : state.servicesByEquipment)
              .where((e) => e.getShiftList().contains(user?.shift))
              .toList();
      for (var i in masterService) {
        bool foundMatch = false;
        // for (var cpl in state.equipmentsByCpl) {
        // if (i.kodeEquipment == cpl.kodeEquipment) {
        // foundMatch = true;
        // break; // No need to continue the inner loop as we foun
        // }
        // }
        if (i.kodeEquipment == event.equipmentCode) {
          listService.add(i.copyWith(
              checkBox: event.value == true ? 1 : 0,
              textValue: event.value == true ? 'STOP' : ''));
        } else {
          listService.add(i);
        }
      }
      if (event.isAction) {
        emitter(state.copyWith(servicesByEquipment: listService));
      } else {
        emitter(state.copyWith(services: listService));
      }
    } else {
      if (event.isAreaBloc) {
        List<Service> listService = [];
        List<Transaction> transactions = [];
        var masterTrx = state.transactions.transactions
            .where((e) => e.getShiftList().contains(user?.shift));
        for (var i in masterTrx) {
          bool foundMatch = false;
          // for (var cpl in state.equipmentsByCpl) {
          // if (i.codeEquipment == cpl.kodeEquipment) {
          // foundMatch = true;
          // break; // No need to continue the inner loop as we foun
          // }
          // }
          if (i.codeEquipment == event.equipmentCode) {
            transactions.add(i.copyWith(
                checkBox: event.value == true ? 1 : 0,
                textValue: event.value == true ? 'STOP' : ''));
          } else {
            transactions.add(i);
          }
        }

        var masterService =
            state.services.where((e) => e.getShiftList().contains(user?.shift));
        for (var m in masterService) {
          // bool foundMatch = false;
          // for (var cpl in state.equipmentsByCpl) {
          // if (m.kodeEquipment == cpl.kodeEquipment) {
          // foundMatch = true;
          // break;
          // }
          // }
          if (m.kodeEquipment == event.equipmentCode) {
            listService.add(m.copyWith(
                checkBox: event.value == true ? 1 : 0,
                textValue: event.value == true ? 'STOP' : ''));
          } else {
            listService.add(m);
          }
        }
        emitter(state.copyWith(
            transactions: TransactionModel(transactions: transactions),
            services: listService));
      } else {
        List<Service> listService = [];
        var masterService = (state.services)
            .where((e) => e.getShiftList().contains(user?.shift))
            .toList();
        for (var m in masterService) {
          if (m.kodeEquipment == event.equipmentCode) {
            listService.add(m.copyWith(
                checkBox: event.value == true ? 1 : 0,
                textValue: event.value == true ? 'STOP' : ''));
          } else {
            listService.add(m);
          }
        }
        emitter(state.copyWith(servicesByEquipment: listService));
      }
    }

    if (state.transactions.transactions.isEmpty ||
        (state.transactions.transactions
            .where((element) => element.codeEquipment == event.equipmentCode)
            .isEmpty)) {
      if (state.areas.isNotEmpty) {
        log("area bloc");
        add(SaveNewEFormTransactionEvent(
            codeEquipment: event.equipmentCode, reloadAll: false));
      } else {
        log("equipment bloc");
      }
      log("save ${event.equipmentCode}");
      // add(SaveNewEFormTransactionEvent(
      // codeEquipment: event.equipmentCode, reloadAll: true));
    } else {
      log("update ${event.equipmentCode}");
      add(UpdateEFormTransactionEvent(
          codeEquipment: event.equipmentCode, reloadAll: true));
    }
  }

  Future<void> _changeServiceReportedCondition(
      ChangeServiceReportedConditionEvent event,
      Emitter<EFormState> emitter) async {
    if (state.transactions.transactions.isEmpty) {
      List<Service> listService = [];
      for (var i
          in (event.isAreaBloc ? state.services : state.servicesByEquipment)) {
        if (i.idService == event.idService) {
          listService.add(i.copyWith(reportedCondition: event.value));
        } else {
          listService.add(i);
        }
      }
      if (event.isAreaBloc) {
        emitter(state.copyWith(services: listService));
      } else {
        emitter(state.copyWith(servicesByEquipment: listService));
      }
    } else {
      if (event.isAreaBloc) {
        List<Service> listService = [];
        for (var i in (event.isAreaBloc
            ? state.services
            : state.servicesByEquipment)) {
          if (i.idService == event.idService) {
            listService.add(i.copyWith(reportedCondition: event.value));
          } else {
            listService.add(i);
          }
        }
        List<Transaction> transactions = [];
        List<Transaction> newTransactions = [];
        var checkServiceExistTrx = state.transactions.transactions
            .where((trx) => trx.idService == event.idService)
            .toList()
            .isNotEmpty;
        transactions.addAll(state.transactions.transactions);
        if (!checkServiceExistTrx) {
          var serviceById = state.services
              .where((sr) => sr.idService == event.idService)
              .first;
          log("cek reported condition ${serviceById.reportedCondition}");
        }
        for (var i in (state.transactions.transactions)) {
          if (i.idService == event.idService) {
            transactions.add(i.copyWith(reportedCondition: event.value));
          } else {
            transactions.add(i);
          }
        }
        emitter(state.copyWith(
            transactions: TransactionModel(transactions: transactions),
            services: listService));
      } else {
        List<Service> listService = [];
        for (var i in (state.servicesByEquipment)) {
          if (i.idService == event.idService) {
            listService.add(i.copyWith(reportedCondition: event.value));
          } else {
            listService.add(i);
          }
        }
        emitter(state.copyWith(servicesByEquipment: listService));
      }
    }
  }

  Future<void> _changeServiceReportedRequest(
      ChangeServiceReportedRequestEvent event,
      Emitter<EFormState> emitter) async {
    if (state.transactions.transactions.isEmpty) {
      List<Service> listService = [];
      for (var i
          in (event.isAreaBloc ? state.services : state.servicesByEquipment)) {
        if (i.idService == event.idService) {
          listService.add(i.copyWith(reportedRequest: event.value));
        } else {
          listService.add(i);
        }
      }
      if (event.isAreaBloc) {
        emitter(state.copyWith(services: listService));
      } else {
        emitter(state.copyWith(servicesByEquipment: listService));
      }
    } else {
      if (event.isAreaBloc) {
        List<Service> listService = [];
        for (var i in (event.isAreaBloc
            ? state.services
            : state.servicesByEquipment)) {
          if (i.idService == event.idService) {
            listService.add(i.copyWith(reportedRequest: event.value));
          } else {
            listService.add(i);
          }
        }
        List<Transaction> transactions = [];
        for (var i in (state.transactions.transactions)) {
          if (i.idService == event.idService) {
            transactions.add(i.copyWith(reportedRequest: event.value));
          } else {
            transactions.add(i);
          }
        }
        emitter(state.copyWith(
            transactions: TransactionModel(transactions: transactions),
            services: listService));
      } else {
        List<Service> listService = [];
        for (var i in (state.servicesByEquipment)) {
          if (i.idService == event.idService) {
            listService.add(i.copyWith(reportedRequest: event.value));
          } else {
            listService.add(i);
          }
        }
        emitter(state.copyWith(servicesByEquipment: listService));
      }
    }
  }

  Future<void> _addServiceReportedPhoto(
      AddServiceReportedPhotoEvent event, Emitter<EFormState> emitter) async {
    var bytes = await event.image.readAsBytes();
    var encodedImage = base64Encode(bytes);
    if (state.transactions.transactions.isEmpty) {
      List<Service> listService = [];
      for (var i
          in (event.isAreaBloc ? state.services : state.servicesByEquipment)) {
        if (i.idService == event.idService) {
          if (event.imageIndex == 1) {
            listService.add(i.copyWith(reportedImage: encodedImage));
          } else {
            listService.add(i.copyWith(reportedImage2: encodedImage));
          }
        } else {
          listService.add(i);
        }
      }
      if (event.isAreaBloc) {
        emitter(state.copyWith(services: listService));
      } else {
        emitter(state.copyWith(servicesByEquipment: listService));
      }
    } else {
      if (event.isAreaBloc) {
        List<Service> listService = [];

        for (var i in state.services) {
          if (i.idService == event.idService) {
            if (event.imageIndex == 1) {
              listService.add(i.copyWith(reportedImage: encodedImage));
            } else {
              listService.add(i.copyWith(reportedImage2: encodedImage));
            }
          } else {
            listService.add(i);
          }
        }
        List<Transaction> transactions = [];
        for (var i in (state.transactions.transactions)) {
          if (i.idService == event.idService) {
            if (event.imageIndex == 1) {
              transactions.add(i.copyWith(reportedImage: encodedImage));
            } else {
              transactions.add(i.copyWith(reportedImage2: encodedImage));
            }
          } else {
            transactions.add(i);
          }
        }
        emitter(state.copyWith(
            transactions: TransactionModel(transactions: transactions),
            services: listService));
      } else {
        List<Service> listService = [];
        for (var i in (state.servicesByEquipment)) {
          if (i.idService == event.idService) {
            if (event.imageIndex == 1) {
              listService.add(i.copyWith(reportedImage: encodedImage));
            } else {
              listService.add(i.copyWith(reportedImage2: encodedImage));
            }
          } else {
            listService.add(i);
          }
        }
        emitter(state.copyWith(servicesByEquipment: listService));
      }
    }
  }

  Area? findKodeAreaName(String kdArea, List<Area> area) {
    return area.firstWhere(
      (mArea) => mArea.kodeArea == kdArea,
      orElse: () => const Area(kodeArea: "null", namaArea: "null"),
    );
  }

  //save all stop eqp
  Future<void> _saveAllStopEquipmentByCplEFormTransaction(
      SaveAllStopEFormTransactionEvent event,
      Emitter<EFormState> emitter) async {
    final user = await DatabaseProvider.getSignedUserJson();
    final trx = await DatabaseProvider.getTransactionJson();
    var listEquipment = event.equipmentsByCpl;
    List<Service> listService = [];
    List<Transaction> transactions = [];

    List<Transaction> newTransactions = [];
    var masterTrx = state.transactions.transactions
        .where((e) => e.getShiftList().contains(user?.shift));
    for (var i in masterTrx) {
      bool foundMatch = false;
      for (var eqp in listEquipment!) {
        if (i.codeEquipment == eqp.kodeEquipment) {
          foundMatch = true;
          break; // No need to continue the inner loop as we foun
        }
      }
      if (foundMatch) {
        transactions
            .add(i.copyWith(checkBox: 1, textValue: event.value ? 'STOP' : ''));
      } else {
        // transactions.add(i);
      }
    }
    log("total add trx $transactions");

    var masterService =
        state.services.where((e) => e.getShiftList().contains(user?.shift));
    for (var m in masterService) {
      bool foundMatch = false;
      for (var eqp in listEquipment!) {
        if (m.kodeEquipment == eqp.kodeEquipment) {
          foundMatch = true;
          break; // No need to continue the inner loop as we foun
        }
      }
      if (foundMatch) {
        listService.add(m.copyWith(
            checkBox: event.value ? 1 : 0, textValue: true ? 'STOP' : ''));
      }
    }
    log("total add service $listService");
    var dateNow = DateTime.now();
    var tglPatrol = state.tglPatrol.isEmpty
        ? AppUtil.defaultTimeFormatCustom(dateNow, "yyyy-MM-dd")
        : state.tglPatrol;
    log("tgl patrol :$tglPatrol");

    //trx yg bukan hari ini
    final oldData = trx.transactions
        .where((e) =>
            AppUtil.defaultTimeFormatCustom(dateNow, "yyyy-MM-dd") !=
                AppUtil.defaultTimeFormatCustom(
                    DateTime.parse(e.dateCreated), "yyyy-MM-dd") &&
            e.shift != user!.shift &&
            e.patrol != user.patrol &&
            e.userId != user.nik)
        .toList();
    log("old data $oldData");

    //trx hari ini other
    final newDataToday = trx.transactions
        .where((e) =>
            AppUtil.defaultTimeFormatCustom(
                    DateTime.parse(e.dateCreated), "yyyy-MM-dd") ==
                AppUtil.defaultTimeFormatCustom(dateNow, "yyyy-MM-dd") &&
            e.shift == user!.shift &&
            e.patrol == user.patrol &&
            e.userId == user.nik)
        .toList();
    log("trx today $newDataToday");
    newTransactions.addAll(oldData);

    //filter new data yg servicenya == now
    var filterTrxNow =
        newDataToday.where((e) => e.getShiftList().contains(user?.shift));
    for (var filterTrx in listService) {
      bool foundMatch = false;
      for (var srv in filterTrxNow) {
        if (filterTrx.idService != srv.idService) {
          foundMatch = true;
          break; // No need to continue the inner loop as we foun
        }
        if (foundMatch) {
          newTransactions.add(srv);
        }
      }
    }
    // newTransactions.addAll(newData);
    log("trx todayFilterTrx $newTransactions");

    execute() async {
      AppUtil.showLoading();
      var uuid = const Uuid();
      var keyUUid = uuid.v8();
      for (var i in listService) {
        var kodeCpl = state.equipments.firstWhere(
            (e) => e.kodeEquipment == i.kodeEquipment,
            orElse: () => const Equipment(to: ''));

        var kodeEquipment = state.equipments.firstWhere(
            (e) => e.kodeEquipment == i.kodeEquipment,
            orElse: () => const Equipment(to: ''));

        var kodeArea = state.cpls.firstWhere(
            (e) => e.kodeCpl == kodeCpl.kodeCpl,
            orElse: () => const Cpl());

        var template = state.cpls.firstWhere(
            (e) => e.kodeCpl == kodeCpl.kodeCpl,
            orElse: () => const Cpl());

        var kodeFormat = kodeEquipment.tipeCpl;
        String kodeAreaName =
            findKodeAreaName(kodeArea.kodeArea, state.areas) == null
                ? ""
                : findKodeAreaName(kodeArea.kodeArea, state.areas)!.namaArea;
        String namaCpl = state.cpls
            .firstWhere((e) => e.kodeCpl == kodeCpl.kodeCpl,
                orElse: () => const Cpl())
            .namaCpl;

        newTransactions.add(Transaction(
            uuid: keyUUid,
            patrol: user!.patrol,
            shift: user.shift,
            template: template.template,
            dateCreated: DateTime.now().toString(),
            dateUpdated: DateTime.now().toString(),
            userId: user.nik,
            codeFormat: kodeFormat,
            codeEquipment: i.kodeEquipment,
            codeEquipmentName: kodeEquipment.namaEquipment,
            codeCpl: kodeCpl.kodeCpl,
            codeCplName: namaCpl,
            codeArea: kodeArea == null ? '' : kodeArea.kodeArea,
            codeAreaName: kodeAreaName,
            unit: i.unit,
            formType: i.tipeForm,
            codeNfc: i.kodeNfc,
            tag: i.tag,
            serviceName: i.namaService,
            idService: i.idService,
            parameter: i.parameter,
            maxValue: i.maxValue,
            to: i.to,
            minValue: i.minValue,
            correctOption: i.correctOption,
            valueOption: i.valueOption,
            checkBox: i.checkBox,
            steps: i.step,
            reportedCondition: i.reportedCondition,
            reportedImage: i.reportedImage,
            reportedImage2: i.reportedImage2,
            reportedRequest: i.reportedRequest,
            reportedDescription: i.reportedDescription,
            textValue: i.textValue));
      }
      log("data insert $newTransactions");
      // newTransactions.addAll(transactions);
      await DatabaseProvider.putTransactionJson(newTransactions);
      log("save to db");
      log(jsonEncode(TransactionModel(transactions: transactions).toJson()));
      add(const InitEFormEvent());
      Navigator.of(AppUtil.context!).pop();
    }

    if (event.value) {
      execute();
    } else {
      AppUtil.showLoading();
      await DatabaseProvider.putTransactionJson(newTransactions);
      add(const InitEFormEvent());
      Navigator.of(AppUtil.context!).pop();
    }
  }

  Future<void> _saveNewEFormTransaction(
      SaveNewEFormTransactionEvent event, Emitter<EFormState> emitter) async {
    final user = await DatabaseProvider.getSignedUserJson();
    final trx = await DatabaseProvider.getTransactionJson();
    //save from areaState
    execute() async {
      AppUtil.showLoading();
      final othData = trx.transactions
          .where((e) =>
              e.shift != user!.shift &&
              e.patrol != user.patrol &&
              e.userId != user.nik)
          .toList();
      log("data before $othData");
      final newData = trx.transactions
          .where((e) =>
              e.shift == user!.shift &&
              e.patrol == user.patrol &&
              e.userId == user.nik)
          .toList();

      List<Transaction> transactions = [];
      transactions.addAll(othData);
      for (var nowTrx in newData) {
        transactions.add(nowTrx);
      }
      var serviceByEquipment = state.services
          .where((eq) =>
              eq.kodeEquipment == event.codeEquipment &&
              eq.getShiftList().contains(user?.shift))
          .toList();
      var uuid = const Uuid();
      var keyUUid = uuid.v8();
      for (var i in serviceByEquipment) {
        Equipment kodeCpl = state.equipments.firstWhere(
            (e) => e.kodeEquipment == i.kodeEquipment,
            orElse: () => const Equipment(to: ''));

        var kodeEquipment = state.equipments.firstWhere(
            (e) => e.kodeEquipment == i.kodeEquipment,
            orElse: () => const Equipment(to: ''));

        var kodeArea = state.cpls.firstWhere(
            (e) => e.kodeCpl == kodeCpl.kodeCpl,
            orElse: () => const Cpl());

        var template = state.cpls.firstWhere(
            (e) => e.kodeCpl == kodeCpl.kodeCpl,
            orElse: () => const Cpl());

        var dataArea = state.areas.firstWhere(
            (e) => e.kodeArea == kodeArea.kodeArea,
            orElse: () => const Area());

        var dataSection = state.section.firstWhere(
            (e) => e.id == dataArea.kodeSection,
            orElse: () => const Section());

        var kodeFormat = event.formatId;
        // var kodeFormat = kodeEquipment.tipeCpl;
        var dataFormat = state.formats.firstWhere((e) => e.id == kodeFormat,
            orElse: () => const Formats());
        String kodeAreaName =
            findKodeAreaName(kodeArea.kodeArea, state.areas) == null
                ? ""
                : findKodeAreaName(kodeArea.kodeArea, state.areas)!.namaArea;
        String namaCpl = state.cpls
            .firstWhere((e) => e.kodeCpl == kodeCpl.kodeCpl,
                orElse: () => const Cpl())
            .namaCpl;

        transactions.add(Transaction(
            uuid: keyUUid,
            patrol: user!.patrol,
            shift: user.shift,
            template: template.template,
            dateCreated: DateTime.now().toString(),
            dateUpdated: DateTime.now().toString(),
            userId: user.nik,
            codeFormat: kodeFormat,
            codeEquipment: i.kodeEquipment,
            codeEquipmentName: kodeEquipment.namaEquipment,
            codeCpl: kodeCpl.kodeCpl,
            codeCplName: namaCpl,
            codeArea: kodeArea == null ? '' : kodeArea.kodeArea,
            codeAreaName: kodeAreaName,
            unit: i.unit,
            formType: i.tipeForm,
            codeNfc: i.kodeNfc,
            tag: i.tag,
            serviceName: i.namaService,
            idService: i.idService,
            parameter: i.parameter,
            maxValue: i.maxValue,
            to: i.to,
            minValue: i.minValue,
            correctOption: i.correctOption,
            valueOption: i.valueOption,
            checkBox: i.checkBox,
            steps: i.step,
            reportedCondition: i.reportedCondition,
            reportedImage: i.reportedImage,
            reportedImage2: i.reportedImage2,
            reportedRequest: i.reportedRequest,
            reportedDescription: i.reportedDescription,
            textValue: i.textValue));
      }
      log("data new $transactions");
      await DatabaseProvider.putTransactionJson(transactions);
      log("save to db");
      log(jsonEncode(TransactionModel(transactions: transactions).toJson()));
      // log(transactions);
      if (event.reloadAll) {
        add(const InitEFormEvent());
      }
      Navigator.of(AppUtil.context!).pop();
      if (event.onFinish != null) event.onFinish!();
    }

    if (user!.shift.isNotEmpty) {
      if (!event.verify) {
        execute();
      } else {
        if (event.isSpecialJob) {
          execute();
        } else {
          if (state.services
                  .where((e) =>
                      e.kodeEquipment == event.codeEquipment &&
                      e.getShiftList().contains(user.shift))
                  .length ==
              state.services
                  .where((e) =>
                      e.kodeEquipment == event.codeEquipment &&
                      e.isValidated() &&
                      e.getShiftList().contains(user.shift))
                  .length) {
            execute();
          } else {
            AppUtil.snackBar(message: 'Harap isi data dengan lengkap');
          }
        }
      }
    } else {
      AppUtil.snackBar(message: 'Shift belum diatur');
    }
  }

// save unloading
  Future<void> _saveNewEFormUnloadingTransaction(
      SaveNewEFormUnloadingSJTransactionEvent event,
      Emitter<EFormState> emitter) async {
    final user = await DatabaseProvider.getSignedUserJson();

    execute() async {
      AppUtil.showLoading();
      final trx = await DatabaseProvider.getTransactionSpecialJobJson();
      final othData = trx.transactions; //data origin without filter
      List<Transaction> transactions = [];
      transactions.addAll(othData);
      log("total trx existing  :${othData.length}");
      var uuid = const Uuid();
      var keyUUid = uuid.v1();
      var listServices = state.services
          .where((filter) => filter.kodeEquipment == event.codeEquipment)
          .toList();
      log("total service save :${listServices.length}");

      for (var i in listServices) {
        var kodeCpl = state.equipments.firstWhere(
            (e) => e.kodeEquipment == i.kodeEquipment,
            orElse: () => const Equipment(to: ''));

        var kodeEquipment = state.equipments.firstWhere(
            (e) => e.kodeEquipment == i.kodeEquipment,
            orElse: () => const Equipment(to: ''));

        var kodeArea = state.cpls.firstWhere(
            (e) => e.kodeCpl == kodeCpl.kodeCpl,
            orElse: () => const Cpl());

        var template = state.cpls.firstWhere(
            (e) => e.kodeCpl == kodeCpl.kodeCpl,
            orElse: () => const Cpl());

        String kodeAreaName =
            findKodeAreaName(kodeArea.kodeArea, state.areas) == null
                ? ""
                : findKodeAreaName(kodeArea.kodeArea, state.areas)!.namaArea;
        String namaCpl = state.cpls
            .firstWhere((e) => e.kodeCpl == kodeCpl.kodeCpl,
                orElse: () => const Cpl())
            .namaCpl;

        var dataArea = state.areas.firstWhere(
            (e) => e.kodeArea == kodeArea.kodeArea,
            orElse: () => const Area());

        var dataSection = state.section.firstWhere(
            (e) => e.kodeSection == dataArea.kodeSection,
            orElse: () => const Section());
        transactions.add(Transaction(
            uuid: keyUUid,
            isContinue: event.isContinue,
            patrol: user!.patrol,
            codeFormat: template.formatTipe,
            shift: user.shift,
            template: template.template,
            dateCreated: DateTime.now().toString(),
            dateUpdated: DateTime.now().toString(),
            userId: user.nik,
            codeEquipment: i.kodeEquipment,
            codeEquipmentName: kodeEquipment.namaEquipment ?? "",
            codeCpl: kodeCpl.kodeCpl ?? '',
            codeCplName: namaCpl,
            codeArea: kodeArea == null ? '' : kodeArea.kodeArea,
            codeAreaName: kodeAreaName,
            unit: i.unit,
            formType: i.tipeForm,
            codeNfc: i.kodeNfc,
            tag: i.tag,
            serviceName: i.namaService,
            idService: i.idService,
            parameter: i.parameter,
            maxValue: i.maxValue,
            to: i.to,
            minValue: i.minValue,
            correctOption: i.correctOption,
            valueOption: i.valueOption,
            checkBox: i.checkBox,
            steps: i.step,
            shipName: i.shipName,
            amount: i.amount,
            fiA1Amount: i.fiA1Amount,
            fiB1Amount: i.fiB1Amount,
            fiB2Amount: i.fiB2Amount,
            estUnloadingB1MinA: i.estUnloadingB1MinA,
            estUnloadingB2MinA: i.estUnloadingB2MinA,
            estUnloadingB2MinB1: i.estUnloadingB2MinB1,
            reportedCondition: i.reportedCondition,
            reportedImage: i.reportedImage,
            reportedImage2: i.reportedImage2,
            reportedRequest: i.reportedRequest,
            reportedDescription: i.reportedDescription,
            textValue: i.textValue,
            finishJob: event.isFinish));
      }
      if (kDebugMode) {
        log("saving........... total trx special job ${transactions.length}");
      }
      await DatabaseProvider.putTransactionSpecialJobJson(transactions);
      add(const InitEFormEvent());
      Navigator.of(AppUtil.context!).pop();
      log("success save to db...........");
      if (event.onFinish != null) event.onFinish!();
    }

    update() async {
      log("update unloading saving step ${event.step}");
      AppUtil.showLoading();
      final trx = await DatabaseProvider.getTransactionSpecialJobJson();
      // data old(finish) + data new ter update
      final validData =
          trx.transactions.where((e) => e.finishJob == true).toList();
      List<Transaction> transactions = [];
      transactions.addAll(validData);

      //get all continue != uuid

      //saving update by equipment
      var trxByEqp = state.transactionsSpecialJob.transactions
          .where((element) =>
              element.codeEquipment == event.codeEquipment &&
              element.finishJob == false)
          .toList();
      log("update special transfer  ${state.transactionsSpecialJob.transactions.toString()}");
      log("update special transfer cek by eqp ${trxByEqp.toString()}");
      final continueData = trx.transactions
          .where((e) => e.finishJob == false && e.uuid != trxByEqp.first.uuid)
          .toList();
      if (continueData.isNotEmpty) {
        continueData.forEach((tr) {
          transactions.add(tr);
        });
      }
      // final continueData = trx.transactions
      //     .where((e) => e.finishJob == false && e.uuid != trxByEqp.first.uuid)
      //     .toList();
      // continueData.forEach((tr) {
      //   transactions.add(tr);
      // });

      if (kDebugMode) {
        log("total data continue ${continueData.length}");
      }
      for (var i in trxByEqp) {
        if (i.steps == event.step.toString()) {
          transactions.add(i.copyWith(
              dateUpdated: DateTime.now().toString(),
              userId: user?.nik,
              shift: user?.shift,
              patrol: user?.patrol,
              isContinue: event.isContinue,
              finishJob: event.isFinish));
        } else {
          transactions.add(i.copyWith(finishJob: event.isFinish));
        }
      }
      await DatabaseProvider.putTransactionSpecialJobJson(transactions);
      if (event.step == 3) {}
      add(const InitEFormEvent());
      Navigator.of(AppUtil.context!).pop();
      if (event.onFinish != null) event.onFinish!();
    }

    //hanya menyimpan komponen berdasarkan step
    //step 1 hanya amount ,f1
    savingDataState() {
      //save to list state
      if (event.step == 1) {
        log("saving unloading new - step ${event.step}");
        List<Service> listService = [];
        //area state
        for (var i in (event.isAreaBloc
            ? event.areaState.services
            : state.servicesByStep)) {
          if (i.kodeEquipment == event.codeEquipment) {
            log("total service ${i.idService}");
            if (event.step == 1) {
              log("new step 1");
              listService.add(i.copyWith(
                  amount: AppUtil.parseStringToDouble(event.step1!.amount),
                  fiA1Amount:
                      AppUtil.parseStringToDouble(event.step1!.fiA1Amount),
                  shipName: event.step1!.shipName));
            } else if (event.step == 2) {
              log("update step 2 ${AppUtil.parseStringToDouble(event.step2!.sumB1)}");
              listService.add(i.copyWith(
                fiB1Amount: AppUtil.parseStringToDouble(event.step2!.sumB1),
                estUnloadingB1MinA: AppUtil.parseStringToDouble(
                    event.step2!.estimateUnloadingB1minA1),
                isContinue: event.isContinue,
              ));
              log("insert step 2 $listService");
            } else {
              log("update step 3");
              listService.add(i.copyWith(
                fiB2Amount: AppUtil.parseStringToDouble(event.step3!.sumB2),
                estUnloadingB2MinB1: AppUtil.parseStringToDouble(
                    event.step3!.estimateUnloadingB2minB1),
              ));
            }
          } else {
            listService.add(i);
          }
        }

        if (event.isAreaBloc) {
          emitter(state.copyWith(services: listService));
        } else {
          emitter(state.copyWith(servicesByStep: listService));
        }

        if (event.verify) {
          //from service
          log("save to db new entry ${state.servicesByStep.length}");
          execute();
          // if (event.onFinish != null) event.onFinish!();
        } else {
          log("not save to db  new entry");
        }
      } else {
        List<Service> listService = [];
        //area state
        for (var i in (event.isAreaBloc
            ? event.areaState.services
            : state.servicesByStep)) {
          if (i.kodeEquipment == event.codeEquipment) {
            log("total service ${i.idService}");
            if (event.step == 1) {
              log("new step 1");
              listService.add(i.copyWith(
                  amount: AppUtil.parseStringToDouble(event.step1!.amount),
                  fiA1Amount:
                      AppUtil.parseStringToDouble(event.step1!.fiA1Amount),
                  shipName: event.step1!.shipName));
            } else if (event.step == 2) {
              log("update step 2");
              listService.add(i.copyWith(
                fiB1Amount: AppUtil.parseStringToDouble(event.step2!.sumB1),
                estUnloadingB1MinA: AppUtil.parseStringToDouble(
                    event.step2!.estimateUnloadingB1minA1),
                isContinue: event.isContinue,
              ));
              log("insert step 2 ");
            } else {
              log("update step 3");
              listService.add(i.copyWith(
                fiB2Amount: AppUtil.parseStringToDouble(event.step3!.sumB2),
                estUnloadingB2MinB1: AppUtil.parseStringToDouble(
                    event.step3!.estimateUnloadingB2minB1),
              ));
            }
          } else {
            listService.add(i);
          }
        }

        List<Transaction> transactions = [];
        //update item didalam trx special job
        for (var i in (state.transactionsSpecialJob.transactions)) {
          if (i.codeEquipment == event.codeEquipment) {
            //  i.steps == event.step.toString()
            if (event.step == 1) {
              log("update step 1");
              transactions.add(i.copyWith(
                  amount: AppUtil.parseStringToDouble(event.step1!.amount),
                  fiA1Amount:
                      AppUtil.parseStringToDouble(event.step1!.fiA1Amount),
                  shipName: event.step1!.shipName));
            } else if (event.step == 2) {
              log("update step 2 ${AppUtil.parseStringToDouble(event.step2!.sumB1)}");
              transactions.add(i.copyWith(
                fiB1Amount: AppUtil.parseStringToDouble(event.step2!.sumB1),
                estUnloadingB1MinA: AppUtil.parseStringToDouble(
                    event.step2!.estimateUnloadingB1minA1),
                isContinue: event.isContinue,
              ));
            } else {
              log("update step 3");
              transactions.add(i.copyWith(
                fiB2Amount: AppUtil.parseStringToDouble(event.step3!.sumB2),
                estUnloadingB2MinB1: AppUtil.parseStringToDouble(
                    event.step3!.estimateUnloadingB2minB1),
              ));
            }
          } else {
            transactions.add(i);
          }
        }

        if (event.isAreaBloc) {
          emitter(state.copyWith(
              services: listService,
              transactionsSpecialJob:
                  TransactionModel(transactions: transactions)));
        } else {
          emitter(state.copyWith(
              servicesByStep: listService,
              transactionsSpecialJob:
                  TransactionModel(transactions: transactions)));
        }

        if (event.verify) {
          log("update to db");
          update();
        } else {
          log("not save to db");
        }
      }
    }

    if (user!.shift.isNotEmpty) {
      if (event.step == 1) {
        if (event.step1!.shipName.isEmpty) {
          AppUtil.snackBar(message: 'Ship Name Empty');
        } else if (event.step1!.amount.isEmpty) {
          AppUtil.snackBar(message: 'Amount Empty');
        } else if (event.step1!.fiA1Amount.isEmpty) {
          AppUtil.snackBar(message: 'SUM A Cannot Empty');
        } else {
          log("execute saving step 1 unloading");
          var checkEmptyInput = event.areaState.services
              .where((e) =>
                  e.kodeEquipment == event.codeEquipment &&
                  e.step == "1" &&
                  e.textValue == "")
              .toList();
          var validateStep1 = event.isAreaBloc
              ? checkEmptyInput
              : state.servicesByStep
                  .where((s) =>
                      s.textValue == "" &&
                      s.step == event.step.toString() &&
                      s.kodeEquipment == event.codeEquipment)
                  .toList();
          if (validateStep1.isNotEmpty) {
            AppUtil.snackBar(message: 'Please fill in complete data');
          } else {
            savingDataState();
          }
        }
      } else if (event.step == 2) {
        if (event.step2!.sumB1.isEmpty) {
          AppUtil.snackBar(message: 'B1 Cannot Empty');
        } else if (event.step2!.estimateUnloadingB1minA1.isEmpty) {
          AppUtil.snackBar(message: 'Estimate Unloading Cannot Empty');
        } else {
          log("execute saving step 2 unloading");
          //validating
          var validateStep2 = event.isAreaBloc
              ? state.services
                  .where((e) =>
                      e.kodeEquipment == event.codeEquipment &&
                      e.step == "2" &&
                      e.textValue.isEmpty)
                  .toList()
              : state.servicesByStep
                  .where((s) =>
                      s.textValue == "" &&
                      s.step == event.step.toString() &&
                      s.kodeEquipment == event.codeEquipment)
                  .toList();
          if (validateStep2.isNotEmpty) {
            AppUtil.snackBar(message: 'Please fill in complete data');
          } else {
            savingDataState();
          }
        }
      } else {
        if (event.step3!.sumB2.isEmpty) {
          AppUtil.snackBar(message: 'B2 Cannot Empty');
        } else if (event.step3!.estimateUnloadingB2minB1.isEmpty) {
          AppUtil.snackBar(message: 'Estimate Unloading B2-B1 Cannot Empty');
        } else {
          log("execute saving step 3 unloading");
          var checkEmptyInput = event.areaState.services
              .where((e) =>
                  e.kodeEquipment == event.codeEquipment &&
                  e.step == "3" &&
                  e.textValue == "")
              .toList();
          //validating
          var validateStep3 = event.isAreaBloc
              ? checkEmptyInput
              : state.servicesByStep
                  .where((s) =>
                      s.textValue == "" &&
                      s.step == event.step.toString() &&
                      s.kodeEquipment == event.codeEquipment)
                  .toList();
          if (validateStep3.isNotEmpty) {
            AppUtil.snackBar(message: 'Please fill in complete data');
          } else {
            savingDataState();
          }
        }
      }
    } else {
      AppUtil.snackBar(message: 'Shift Not Set');
    }
  }

  Future<void> _saveNewSpecialTransferTransaction(
      SaveNewTransferSJTransactionEvent event,
      Emitter<EFormState> emitter) async {
    final user = await DatabaseProvider.getSignedUserJson();

    execute() async {
      AppUtil.showLoading();
      final trx = await DatabaseProvider.getTransactionSpecialJobJson();
      final othData = trx.transactions; //data origin without filter
      List<Transaction> transactions = [];
      transactions.addAll(othData);

      var uuid = const Uuid();
      var keyUUid = uuid.v1();
      var listServices = state.services
          .where((filter) => filter.kodeEquipment == event.codeEquipment)
          .toList();

      log("total exist data save :${othData.length}");
      log("total exist data area state save :${othData.length}");

      for (var i in listServices) {
        var kodeCpl = state.equipments.firstWhere(
            (e) => e.kodeEquipment == i.kodeEquipment,
            orElse: () => const Equipment(to: ''));

        var kodeEquipment = state.equipments.firstWhere(
            (e) => e.kodeEquipment == i.kodeEquipment,
            orElse: () => const Equipment(to: ''));

        var kodeArea = state.cpls.firstWhere(
            (e) => e.kodeCpl == kodeCpl.kodeCpl,
            orElse: () => const Cpl());
        var dataArea = state.areas.firstWhere(
            (e) => e.kodeArea == kodeArea.kodeArea,
            orElse: () => const Area());

        var dataSection = state.section.firstWhere(
            (e) => e.kodeSection == dataArea.kodeSection,
            orElse: () => const Section());
        var formatType = state.section.firstWhere(
            (e) => e.kodeSection == kodeArea.formatTipe,
            orElse: () => const Section());
        var template = state.cpls.firstWhere(
            (e) => e.kodeCpl == kodeCpl.kodeCpl,
            orElse: () => const Cpl());

        String kodeAreaName =
            findKodeAreaName(kodeArea.kodeArea, state.areas) == null
                ? ""
                : findKodeAreaName(kodeArea.kodeArea, state.areas)!.namaArea;
        String namaCpl = state.cpls
            .firstWhere((e) => e.kodeCpl == kodeCpl.kodeCpl,
                orElse: () => const Cpl())
            .namaCpl;

        transactions.add(Transaction(
            uuid: keyUUid,
            patrol: user!.patrol,
            shift: user.shift,
            template: template.template,
            dateCreated: DateTime.now().toString(),
            dateUpdated: DateTime.now().toString(),
            userId: user.nik,
            codeFormat: template.formatTipe,
            codeEquipment: i.kodeEquipment,
            codeEquipmentName: kodeEquipment.namaEquipment ?? "",
            codeCpl: kodeCpl.kodeCpl,
            codeCplName: namaCpl,
            codeArea: kodeArea == null ? '' : kodeArea.kodeArea,
            codeAreaName: kodeAreaName,
            unit: i.unit,
            formType: i.tipeForm,
            codeNfc: i.kodeNfc,
            tag: i.tag,
            serviceName: i.namaService,
            idService: i.idService,
            parameter: i.parameter,
            maxValue: i.maxValue,
            to: kodeEquipment.to,
            controlTf: i.controlTf,
            selectedTo: i.selectedTo,
            minValue: i.minValue,
            correctOption: i.correctOption,
            valueOption: i.valueOption,
            checkBox: i.checkBox,
            steps: i.step,
            shipName: i.shipName,
            amount: i.amount,
            fiA1Amount: i.fiA1Amount,
            fiB1Amount: i.fiB1Amount,
            fiB2Amount: i.fiB2Amount,
            estUnloadingB1MinA: i.estUnloadingB1MinA,
            estUnloadingB2MinA: i.estUnloadingB2MinA,
            estUnloadingB2MinB1: i.estUnloadingB2MinB1,
            reportedCondition: i.reportedCondition,
            reportedImage: i.reportedImage,
            reportedImage2: i.reportedImage2,
            reportedRequest: i.reportedRequest,
            reportedDescription: i.reportedDescription,
            textValue: i.textValue,
            finishJob: event.isFinish));
      }
      if (kDebugMode) {
        log("saving........... total trx special job transfer ${transactions}");
      }
      await DatabaseProvider.putTransactionSpecialJobJson(transactions);
      add(const InitEFormEvent());
      Navigator.of(AppUtil.context!).pop();
      log("success save to db...........");
      if (event.onFinish != null) event.onFinish!();
    }

    update() async {
      AppUtil.showLoading();
      final trx = await DatabaseProvider.getTransactionSpecialJobJson();
      // data old(finish) + data new ter update
      final validData =
          trx.transactions.where((e) => e.finishJob == true).toList();
      List<Transaction> transactions = [];
      transactions.addAll(validData);
      //get all continue != uuid
      //saving update by equipment
      var trxByEqp = state.transactionsSpecialJob.transactions
          .where((element) =>
              element.codeEquipment == event.codeEquipment &&
              element.finishJob == false)
          .toList();
      log("update special transfer cek by eqp ${trxByEqp.toString()}");
      final continueData = trx.transactions
          .where((e) => e.finishJob == false && e.uuid != trxByEqp.first.uuid)
          .toList();
      if (continueData.isNotEmpty) {
        continueData.forEach((tr) {
          transactions.add(tr);
        });
      }

      if (kDebugMode) {}
      for (var i in trxByEqp) {
        if (i.steps == event.step.toString()) {
          transactions.add(i.copyWith(
              dateUpdated: DateTime.now().toString(),
              userId: user?.nik,
              shift: user?.shift,
              patrol: user?.patrol,
              finishJob: event.isFinish));
        } else {
          transactions.add(i.copyWith(finishJob: event.isFinish));
        }
      }
      log("list trx to update $transactions");
      await DatabaseProvider.putTransactionSpecialJobJson(transactions);
      if (event.step == 3) {
        log("update finish job");
        add(const InitEFormEvent());
      }
      Navigator.of(AppUtil.context!).pop();
      if (event.onFinish != null) event.onFinish!();
    }

    //hanya menyimpan komponen berdasarkan step
    //step
    savingDataState() {
      //save to list state
      if (event.step < 3) {
        log("save new - step ${event.step}");
        List<Service> listService = [];
        //area state
        for (var i in (event.isAreaBloc
            ? event.areaState.services
            : state.servicesByStep)) {
          if (i.kodeEquipment == event.codeEquipment) {
            log("total service ${i.idService}");
            if (event.step == 2) {
              listService.add(i.copyWith(
                  controlTf: event.step1n2!.control,
                  selectedTo: event.step1n2!.to));
              log("insert step 2 special transfer control :${event.step1n2!.control} to ${event.step1n2!.to}");
            } else {
              listService.add(i);
              log("insert");
            }
          } else {
            listService.add(i);
          }
        }

        if (event.isAreaBloc) {
          emitter(state.copyWith(services: listService));
        } else {
          emitter(state.copyWith(servicesByStep: listService));
        }

        if (event.verify) {
          //from service
          log("save to db new entry ${state.servicesByStep.length}");
          execute();
          // if (event.onFinish != null) event.onFinish!();
        } else {
          log("not save to db  new entry");
        }
      } else {
        log("Update Trx Transfer");
        List<Service> listService = [];
        //area state
        for (var i in (event.isAreaBloc
            ? event.areaState.services
            : state.servicesByStep)) {
          if (i.kodeEquipment == event.codeEquipment) {
            log("total service ${i.idService}");
            if (event.step == 2) {
              log("update step 2 ");
              listService.add(i.copyWith(
                  controlTf: event.step1n2!.control,
                  selectedTo: event.step1n2!.to));
              log("insert step 2 ");
            } else {
              log("update step 3");
              listService.add(i);
            }
          } else {
            listService.add(i);
          }
        }

        List<Transaction> transactions = [];
        //update item didalam trx special job
        debugPrint(state.transactionsSpecialJob.transactions.toString());
        for (var i in (state.transactionsSpecialJob.transactions)) {
          if (i.codeEquipment == event.codeEquipment) {
            if (event.step == 2) {
              log("update trx state step 1n2");
              transactions.add(i.copyWith(
                  controlTf: event.step1n2!.control,
                  selectedTo: event.step1n2!.to));
            } else {
              log("update trx state  step 3");
              transactions.add(i);
            }
          } else {
            transactions.add(i);
          }
        }

        if (event.isAreaBloc) {
          emitter(state.copyWith(
              services: listService,
              transactionsSpecialJob:
                  TransactionModel(transactions: transactions)));
        } else {
          emitter(state.copyWith(
              servicesByStep: listService,
              transactionsSpecialJob:
                  TransactionModel(transactions: transactions)));
        }

        if (event.verify) {
          log("update to db");
          update();
        } else {
          log("not save to db");
        }
      }
    }

    if (user!.shift.isNotEmpty) {
      if (event.step == 2) {
        if (event.step1n2!.control.isEmpty) {
          AppUtil.snackBar(message: 'Control Cannot Empty');
        } else if (event.step1n2!.to.isEmpty) {
          AppUtil.snackBar(message: 'To Cannot Empty');
        } else {
          log("execute saving step 1 n 2 transfer");
          //validating
          var validateStep12 = event.isAreaBloc
              ? state.services
                  .where((e) =>
                      e.kodeEquipment == event.codeEquipment &&
                      e.step == "2" &&
                      e.step == "1" &&
                      e.textValue.isEmpty)
                  .toList()
              : state.servicesByStep
                  .where((s) =>
                      s.textValue == "" &&
                      s.step == "2" &&
                      s.step == "1" &&
                      s.kodeEquipment == event.codeEquipment)
                  .toList();
          if (validateStep12.isNotEmpty) {
            AppUtil.snackBar(message: 'Please fill in complete data');
          } else {
            savingDataState();
          }
        }
      } else {
        log("execute saving step 3 transfer");
        var checkEmptyInput = event.areaState.services
            .where((e) =>
                e.kodeEquipment == event.codeEquipment &&
                e.step == "3" &&
                e.textValue == "")
            .toList();
        //validating
        var validateStep3 = event.isAreaBloc
            ? checkEmptyInput
            : state.servicesByStep
                .where((s) =>
                    s.textValue == "" &&
                    s.step == event.step.toString() &&
                    s.kodeEquipment == event.codeEquipment)
                .toList();
        if (validateStep3.isNotEmpty) {
          AppUtil.snackBar(message: 'Please fill in complete data');
        } else {
          savingDataState();
        }
      }
    } else {
      AppUtil.snackBar(message: 'Shift Not Set');
    }
  }

  Future<void> _updateEFormTransaction(
      UpdateEFormTransactionEvent event, Emitter<EFormState> emitter) async {
    final user = await DatabaseProvider.getSignedUserJson();

    execute() async {
      AppUtil.showLoading();
      final trx = await DatabaseProvider.getTransactionJson();
      final othData = trx.transactions
          .where((e) =>
              e.shift != user!.shift &&
              e.patrol != user.patrol &&
              e.userId != user.nik)
          .toList();
      List<Transaction> transactions = [];
      transactions.addAll(othData);
      for (var i in state.transactions.transactions) {
        transactions.add(i.copyWith(dateUpdated: DateTime.now().toString()));
      }
      log("update db");
      await DatabaseProvider.putTransactionJson(transactions);
      if (event.reloadAll) {
        add(const InitEFormEvent());
      }
      Navigator.of(AppUtil.context!).pop();
      if (event.onFinish != null) event.onFinish!();
    }

    if (!event.verify) {
      execute();
    } else {
      if (event.isSpecialJob) {
        execute();
      } else {
        if (state.transactions.transactions
                .where((e) => e.codeEquipment == event.codeEquipment)
                .length ==
            state.transactions.transactions
                .where((e) =>
                    e.codeEquipment == event.codeEquipment && e.isValidated())
                .length) {
          execute();
        } else {
          AppUtil.snackBar(message: 'Harap isi data dengan lengkap');
        }
      }
    }
  }

  Future<void> _updateEFormSpecialJobTransaction(
      UpdateEFormTransactionEvent event, Emitter<EFormState> emitter) async {
    final user = await DatabaseProvider.getSignedUserJson();

    execute() async {
      AppUtil.showLoading();
      final trx = await DatabaseProvider.getTransactionSpecialJobJson();
      // data old(finish) + data new ter update
      final validData =
          trx.transactions.where((e) => e.finishJob == true).toList();
      List<Transaction> transactions = [];
      transactions.addAll(validData);
      //saving update by equipment
      var trxByEqp = state.transactionsSpecialJob.transactions
          .where((element) => element.codeEquipment == event.codeEquipment)
          .toList();
      for (var i in trxByEqp) {
        if (i.steps == event.step.toString()) {
          transactions.add(i.copyWith(
            dateUpdated: DateTime.now().toString(),
            userId: user?.nik,
            shift: user?.shift,
            patrol: user?.patrol,
          ));
        } else {
          transactions.add(i);
        }
      }
      await DatabaseProvider.putTransactionSpecialJobJson(transactions);
      add(const InitEFormEvent());
      Navigator.of(AppUtil.context!).pop();
      if (event.onFinish != null) event.onFinish!();
    }

    if (!event.verify) {
      execute();
    } else {
      if (event.isSpecialJob) {
        execute();
      } else {
        if (state.transactionsSpecialJob.transactions
                .where((e) => e.codeEquipment == event.codeEquipment)
                .length ==
            state.transactionsSpecialJob.transactions
                .where((e) =>
                    e.codeEquipment == event.codeEquipment && e.isValidated())
                .length) {
          execute();
        } else {
          AppUtil.snackBar(message: 'Harap isi data dengan lengkap');
        }
      }
    }
  }

  Future<void> _checkTransaction(
      CheckTransactionEvent event, Emitter<EFormState> emitter) async {
    emitter(EFormLoading());
    final trx = await DatabaseProvider.getTransactionJson();
    final user = await DatabaseProvider.getSignedUserJson();

    var now = DateTime.now();

    List<Transaction> transactions = [];

    if (trx.transactions.isNotEmpty) {
      // print(state.transactionsHistoryManual.transactions.first.codeCplName);
      if (state.tglPatrol.isNotEmpty) {
        if (event.filterDropdown == "All") {
          transactions.addAll(trx.transactions
              .where((element) =>
                  (AppUtil.defaultTimeFormatCustom(
                          DateTime.parse(element.dateCreated), "yyyy-MM-dd") ==
                      state.tglPatrol) &&
                  element.userId == user!.nik &&
                  element.shift == user.shift &&
                  element.patrol == user.patrol &&
                  element.dateCreated
                      .contains(now.toString().substring(0, 10)))!
              .toList());
        } else {
          transactions.addAll(trx.transactions
              .where((element) =>
                  (AppUtil.defaultTimeFormatCustom(
                          DateTime.parse(element.dateCreated), "yyyy-MM-dd") ==
                      state.tglPatrol) &&
                  element.userId == user!.nik &&
                  element.shift == user.shift &&
                  element.patrol == user.patrol &&
                  element.codeFormat
                      .toLowerCase()
                      .contains(event.filterDropdown.toLowerCase()))
              .toList());
        }
        print('tgl patrol not empty');
      } else {
        if (event.filterDropdown == "All") {
          if (event.search.isEmpty) {
            transactions.addAll(trx.transactions
                .where((e) =>
                    (AppUtil.defaultTimeFormatCustom(
                            DateTime.parse(e.dateCreated), "yyyy-MM-dd") ==
                        AppUtil.defaultTimeFormatCustom(now, "yyyy-MM-dd")) &&
                    e.patrol == user!.patrol &&
                    e.userId == user.nik &&
                    e.shift == user.shift)
                .toList());
          } else {
            transactions.addAll(trx.transactions.where((e) =>
                (AppUtil.defaultTimeFormatCustom(
                        DateTime.parse(e.dateCreated), "yyyy-MM-dd") ==
                    AppUtil.defaultTimeFormatCustom(now, "yyyy-MM-dd")) &&
                e.patrol == user!.patrol &&
                e.userId == user.nik &&
                e.shift == user.shift &&
                (e.codeEquipment
                        .toLowerCase()
                        .contains(event.search.toLowerCase()) ||
                    e.codeEquipmentName
                        .toLowerCase()
                        .contains(event.search.toLowerCase()) ||
                    e.codeCpl
                        .toLowerCase()
                        .contains(event.search.toLowerCase()) ||
                    e.codeCplName
                        .toLowerCase()
                        .contains(event.search.toLowerCase()) ||
                    e.codeArea
                        .toLowerCase()
                        .contains(event.search.toLowerCase()) ||
                    e.codeAreaName
                        .toLowerCase()
                        .contains(event.search.toLowerCase()) ||
                    e.codeNfc
                        .toLowerCase()
                        .contains(event.search.toLowerCase()) ||
                    e.serviceName
                        .toLowerCase()
                        .contains(event.search.toLowerCase()) ||
                    e.textValue
                        .toLowerCase()
                        .contains(event.search.toLowerCase()))));
          }
        } else {
          transactions.addAll(trx.transactions
              .where((element) =>
                  (AppUtil.defaultTimeFormatCustom(
                          DateTime.parse(element.dateCreated), "yyyy-MM-dd") ==
                      AppUtil.defaultTimeFormatCustom(now, "yyyy-MM-dd")) &&
                  element.patrol == user!.patrol &&
                  element.userId == user.nik &&
                  element.shift == user.shift &&
                  element.codeFormat
                      .toLowerCase()
                      .contains(event.filterDropdown.toLowerCase()))
              .toList());
        }

        // if (event.search.isNotEmpty) {
        //   transactions.addAll(trx.transactions.where((element) =>
        //   (AppUtil.defaultTimeFormatCustom(DateTime.parse(element.dateCreated), "yyyy-MM-dd") == AppUtil.defaultTimeFormatCustom(now, "yyyy-MM-dd")) &&
        //   element.patrol == user!.patrol &&
        //           element.userId == user.nik &&
        //           element.shift == user.shift &&
        //   (
        //     element.codeEquipment.toLowerCase().contains(event.search.toLowerCase()) ||
        //     element.codeEquipmentName.toLowerCase().contains(event.search.toLowerCase()) ||
        //     element.codeCpl.toLowerCase().contains(event.search.toLowerCase()) ||
        //     element.codeCplName.toLowerCase().contains(event.search.toLowerCase()) ||
        //     element.codeArea.toLowerCase().contains(event.search.toLowerCase()) ||
        //     element.codeAreaName.toLowerCase().contains(event.search.toLowerCase()) ||
        //     element.codeNfc.toLowerCase().contains(event.search.toLowerCase()) ||
        //     element.serviceName.toLowerCase().contains(event.search.toLowerCase()) ||
        //     element.textValue.toLowerCase().contains(event.search.toLowerCase()
        //   )
        //   )).toList());
        // }
        // print('tgl patrol empty');
        // print(transactions.length);
      }

      // if () {

      // }

      Map<String, List<dynamic>> groupedData = {};
      TransactionModel mt =
          TransactionModel(transactions: transactions.toSet().toList());
      // print(mt.runtimeType.toString());
      log(mt.toJson().toString());
      emitter(state.copyWith(transactionsHistoryManual: mt));

      // print(
      //     state.transactionsHistoryManual.transactions.runtimeType.toString());
      // print('mt : ${mt.toJson()}');
    }

    // if (state.transactions.transactions.isNotEmpty) {
    //   int length = state.transactions.transactions.length;
    //   print(length.toString());
    //   print(state.transactions.transactions);
    //   AppUtil.snackBar(message: length.toString());
    // } else {
    //   print('kosong');
    // }
  }

  Future<void> _syncTransaction(
      SyncTransactionEvent event, Emitter<EFormState> emitter) async {
    AppUtil.showLoading();
    if (state.transactions.transactions.isNotEmpty) {
      final data = TransactionModel(
          transactions: state.transactions.transactions
              .where((e) =>
                  e.userId == event.userId &&
                  e.patrol == event.patrol &&
                  e.shift == event.shift &&
                  e.textValue.isNotEmpty &&
                  e.isSync == 0)
              .toList());
      final equipment = await DatabaseProvider.getEquipmentJson();
      //check eqp condition 100%
      List<String> equipment100 = [];
      for (var eqp in equipment) {
        var list = data.transactions
            .where((e) => e.codeEquipment == eqp.kodeEquipment && e.isSync == 0)
            .toList();
        var items = list.where((e) => e.isValidated()).toList();
        var result = (items.length / list.length) * 100;
        if (!result.isNaN) {
          var percentage = result.round();
          if (percentage >= 100) {
            equipment100.add(eqp.kodeEquipment);
          }
        }
      }
      //check filtering by cpl yang sudah 100%

      List<TransactionDataSync> listData = [];
      var dateTimeSync = AppUtil.defaultTimeFormatStandard(DateTime.now());
      var mUser = User(
          shift: event.shift.toString(),
          namaStaff: event.nama,
          department: event.department);

      if (equipment100.isNotEmpty) {
        for (var eqp in equipment100) {
          //cek data yang belum tersinkronasi
          var listCplToSync = data.transactions
              .where((e) => e.codeEquipment == eqp && e.isSync == 0)
              .toList();

          for (var trxService in listCplToSync) {
            var kodeArea = state.cpls.firstWhere(
                (e) => e.kodeCpl == trxService.codeCpl,
                orElse: () => const Cpl());

            var formatType = state.section.firstWhere(
                (e) => e.kodeSection == kodeArea.formatTipe,
                orElse: () => const Section());
            listData.add(TransactionDataSync(
                nfcCode: trxService.codeNfc,
                shift: event.shift.toString(),
                department: event.department,
                userNik: event.nik,
                userName: mUser.namaStaff,
                areaName: trxService.codeAreaName,
                date: trxService.dateCreated,
                status: trxService.isWarning() ? "abnormal" : "normal",
                areaCode: trxService.codeArea,
                documentCode: trxService.codeCpl,
                documentName: trxService.codeCplName,
                equipmentCode: trxService.codeEquipment,
                equipmentName: trxService.codeEquipmentName,
                tag: trxService.tag,
                formatType: trxService.codeFormat,
                formType: trxService.formType,
                idService: trxService.idService,
                serviceName: trxService.serviceName,
                input: trxService.textValue,
                parameter: trxService.parameter,
                unit: trxService.unit,
                steps: trxService.steps,
                to: trxService.to,
                correctOption: trxService.correctOption,
                minValue: trxService.minValue,
                maxValue: trxService.maxValue,
                description: trxService.reportedDescription,
                foto: trxService.reportedImage,
                foto2: trxService.reportedImage2));
          }
        }
        final mdata = DataSyncModels(user: mUser, transactions: listData);
        //try to recover
        final trxExisting = state.transactions.transactions
            .where((e) =>
                e.userId == event.userId &&
                e.patrol == event.patrol &&
                e.shift == event.shift &&
                e.isSync == 0)
            .toList();
        try {
          final base_options = BaseOptions(
            connectTimeout: const Duration(seconds: 100),
            receiveTimeout: const Duration(seconds: 100),
          );
          Dio dio = Dio(base_options);
          // Perform the POST request
          final options = Options(
            headers: {
              'api_id': event.api_id.toString(),
            },
          );
          log("sync to server ${event.urlServer.toString()}$urlSync?form=standart");
          log(mdata.toJson().toString());
          Response response = await dio.post(
              "${event.urlServer.toString()}$urlSync?form=standart",
              data: mdata.toJson(),
              options: options);
          print(mdata.toJson().toString());
          // Check the response status
          if (response.statusCode == 200) {
            print('POST sync request successful!');
            // print('Response: ${response.data}');
            execute() async {
              List<Transaction> transactions = [];
              List<Transaction> tempTransactions = [];
              transactions.addAll(trxExisting);
              for (int i = 0; i < transactions.length; i++) {
                var trxExisting = transactions[i];
                bool foundMatch = false;
                for (var dataSync in listData) {
                  if (dataSync.idService == trxExisting.idService) {
                    foundMatch = true;
                    break; // No need to continue the inner loop as we found a match
                  }
                }
                if (foundMatch) {
                  tempTransactions.add(trxExisting.copyWith(isSync: 1));
                } else {
                  tempTransactions.add(trxExisting.copyWith(isSync: 0));
                }
              }
              await DatabaseProvider.putTransactionJson(tempTransactions);
              add(const InitEFormEvent());
            }

            execute();
            Navigator.of(AppUtil.context!).pop();
            AppUtil.snackBar(message: 'Success  \nSyncron data');
          } else {
            Navigator.of(AppUtil.context!).pop();
            print('Failed to make POST ');
            AppUtil.snackBar(message: 'Failed  \nSync data ');
            print('Status Code: ${response.statusCode}');
          }
        } catch (e) {
          Navigator.of(AppUtil.context!).pop();
          if (e is DioException &&
              e.type == DioExceptionType.connectionTimeout) {
            print('Connection Timeout Exception');
            AppUtil.snackBar(message: 'Failed  \n Connection Timeout}');
          } else {
            AppUtil.snackBar(message: 'Failed  \nSync data ${e.toString()}');
            print('Error: $e');
          }
        }
        // Navigator.of(AppUtil.context!).pop();
        // AppUtil.snackBar(message: 'Failed  \nSync data ');
      } else {
        Navigator.of(AppUtil.context!).pop();
        AppUtil.snackBar(
            message: 'No transaction is 100% \nComplete your transaction');
      }
    } else {
      Navigator.of(AppUtil.context!).pop();
      AppUtil.snackBar(message: 'No transaction completed to export');
    }
  }

  Future<void> _syncTransactionSpecial(
      SyncTransactionSpecialJobEvent event, Emitter<EFormState> emitter) async {
    AppUtil.showLoading();
    final trxSaved = await DatabaseProvider.getTransactionSpecialJobJson();
    var listTrxSpecial = trxSaved.transactions;
    if (listTrxSpecial.isNotEmpty) {
      List<TransactionDataSyncSpecial> listData = [];
      var dateTimeSync = AppUtil.defaultTimeFormatStandard(DateTime.now());
      var mUser = User(
          shift: event.shift.toString(),
          namaStaff: event.nama,
          department: event.department);
      //cek data yang belum tersinkronasi
      var listSpecialToSync = listTrxSpecial
          .where((e) => e.finishJob == true && e.isSync == 0)
          .toList();

      for (var trxService in listSpecialToSync) {
        // var kodeArea = state.cpls.firstWhere(
        //     (e) => e.kodeCpl == trxService.codeCpl,
        //     orElse: () => const Cpl());

        // var formatType = state.section.firstWhere(
        //     (e) => e.kodeSection == kodeArea.formatTipe,
        //     orElse: () => const Section());
        listData.add(TransactionDataSyncSpecial(
            nfcCode: trxService.codeNfc,
            template: trxService.template.toLowerCase(),
            shift: event.shift.toString(),
            department: event.department,
            userNik: event.nik,
            userName: mUser.namaStaff,
            areaName: trxService.codeAreaName,
            date: trxService.dateCreated,
            status: "normal", //normal only
            areaCode: trxService.codeArea,
            documentCode: trxService.codeCpl,
            documentName: trxService.codeCplName,
            equipmentCode: trxService.codeEquipment,
            equipmentName: trxService.codeEquipmentName,
            tag: trxService.tag,
            formatType: trxService.template,
            formType: trxService.formType,
            idService: trxService.idService,
            serviceName: trxService.serviceName,
            input: trxService.textValue,
            parameter: trxService.parameter,
            unit: trxService.unit,
            steps: trxService.steps,
            to: trxService.to,
            correctOption: trxService.correctOption,
            minValue: trxService.minValue,
            maxValue: trxService.maxValue,
            description: trxService.reportedDescription,
            foto: trxService.reportedImage,
            foto2: trxService.reportedImage2,
            shipName: trxService.shipName,
            amount: trxService.amount.toString(),
            a1Amount: trxService.fiA1Amount.toString(),
            b1Amount: trxService.fiB1Amount.toString(),
            b2Amount: trxService.fiB2Amount.toString(),
            estUnloadingB1A: trxService.estUnloadingB1MinA.toString(),
            estUnloadingB2A: '',
            estUnloadingB2B1: trxService.estUnloadingB2MinB1.toString(),
            controlSelected: trxService.controlTf,
            toSelected: trxService.selectedTo));
      }

      final mdata = DataSyncModelsSpecial(user: mUser, transactions: listData);
      //try to recover
      List<Transaction> listNewData = [];
      //adding trx finish job to set isSync
      final trxExisting = listTrxSpecial
          .where((e) => e.finishJob == true && e.isSync == 1)
          .toList();
      listNewData.addAll(trxExisting);
      for (var insTemp in listSpecialToSync) {
        listNewData.add(insTemp.copyWith(isSync: 1, dateUpdated: dateTimeSync));
      }
      log("list trx $listNewData");
      log("list json ${mdata.toJson()}");
      // exit;
      try {
        final base_options = BaseOptions(
          connectTimeout: const Duration(seconds: 100),
          receiveTimeout: const Duration(seconds: 100),
        );
        Dio dio = Dio(base_options);
        // Perform the POST request
        final options = Options(
          headers: {
            'api_id': event.api_id.toString(),
          },
        );
        log(mdata.toJson().toString());
        Response response = await dio.post(
            "${event.urlServer.toString()}$urlSync?form=special",
            data: mdata.toJson(),
            options: options);
        // Check the response status
        if (response.statusCode == 200) {
          print('POST sync request successful!');
          print('Response: ${response.data}');
          execute() async {
            await DatabaseProvider.putTransactionSpecialJobJson(listNewData);
            add(const InitEFormEvent());
          }

          execute();
          Navigator.of(AppUtil.context!).pop();
          AppUtil.snackBar(message: 'Success  \nSyncron data');
        } else {
          Navigator.of(AppUtil.context!).pop();
          print('Failed to make POST ');
          AppUtil.snackBar(message: 'Failed  \nSync data ');
          print('Status Code: ${response.statusCode}');
        }
      } catch (e) {
        Navigator.of(AppUtil.context!).pop();
        if (e is DioException && e.type == DioExceptionType.connectionTimeout) {
          print('Connection Timeout Exception');
          AppUtil.snackBar(message: 'Failed  \n Connection Timeout}');
        } else {
          AppUtil.snackBar(message: 'Failed  \nSync data ${e.toString()}');
          print('Error: $e');
        }
      }
      // Navigator.of(AppUtil.context!).pop();
      // AppUtil.snackBar(message: 'Failed  \nSync data ');
    } else {
      Navigator.of(AppUtil.context!).pop();
      AppUtil.snackBar(
          message: 'No transaction is 100% \nComplete your transaction');
    }
  }

  Future<void> _exportTransaction(
      ExportTransactionEvent event, Emitter<EFormState> emitter) async {
    List<Transaction> dataTrx = [];
    List<TransactionDataSync> dataTrxExport = [];
    final user = await DatabaseProvider.getSignedUserJson();
    var mUser = User(
        shift: user!.shift, namaStaff: user.name, department: user.department);
    if (state.transactions.transactions.isNotEmpty) {
      if (event.type == "modified") {
        dataTrx = state.transactions.transactions
            .where((e) =>
                e.userId == event.userId &&
                e.dateCreated ==
                    AppUtil.defaultTimeFormatStandard(
                        DateTime.parse(e.dateUpdated)) &&
                e.isSync == 0 &&
                e.textValue.isNotEmpty)
            .toList();
      } else {
        dataTrx = state.transactions.transactions
            .where((e) =>
                e.userId == event.userId &&
                e.isSync == 0 &&
                e.textValue.isNotEmpty)
            .toList();
      }

      if (dataTrx.isEmpty) {
        AppUtil.snackBar(message: 'No Data To Export!');
      } else {
        for (var trxService in dataTrx) {
          dataTrxExport.add(TransactionDataSync(
              template: trxService.template,
              nfcCode: trxService.codeNfc,
              shift: event.shift.toString(),
              department: user?.department,
              userNik: user?.nik,
              userName: user?.name,
              areaName: trxService.codeAreaName,
              date: trxService.dateCreated,
              status: trxService.isWarning() ? "abnormal" : "normal",
              areaCode: trxService.codeArea,
              documentCode: trxService.codeCpl,
              documentName: trxService.codeCplName,
              equipmentCode: trxService.codeEquipment,
              equipmentName: trxService.codeEquipmentName,
              tag: trxService.tag,
              formatType: trxService.codeFormat,
              formType: trxService.formType,
              idService: trxService.idService,
              serviceName: trxService.serviceName,
              input: trxService.textValue,
              parameter: trxService.parameter,
              unit: trxService.unit,
              steps: trxService.steps,
              to: trxService.to,
              correctOption: trxService.correctOption,
              minValue: trxService.minValue,
              maxValue: trxService.maxValue,
              description: trxService.reportedDescription,
              foto: trxService.reportedImage,
              foto2: trxService.reportedImage2));
        }
        final dataExport = DataExportModels(dataTrxExport);
        // final dataExport = DataSyncModels(
        //   user: mUser,
        //   transactions: dataTrxExport,
        // );
        // final file = json.encode(data.toJson());
        // var exportJSOn = dataTrx.map((v) => v.toJson()).toList();
        var exportJSOn = dataExport.toJson();
        final file = exportJSOn;
        //json.encode(exportJSOn);
        log("info json export :");
        log(file);
        if (!await AppUtil.onCheckPermissionGranted()) {
          AppUtil.snackBar(message: 'Required Storage Permission!');
        } else {
          var directory = Platform.isIOS
              ? await getApplicationDocumentsDirectory()
              : await getExternalStorageDirectory();
          var path = directory!.path;
          var localPath =
              Platform.isIOS ? '$path${Platform.pathSeparator}JSON' : path;
          final savedDir = Directory(localPath);
          if (!await savedDir.exists()) {
            savedDir.create();
          }
          var dateExported = AppUtil.defaultTimeFormatCustom(
              DateTime.now(), "yyyy-MM-dd_HH:mm:ss");
          var jsonFile = File(
              '${savedDir.path}${Platform.pathSeparator}${dateExported}_${user?.department}_${user?.shift}_${user?.name}.json');
          if (Platform.isAndroid) {
            final folder = await getExternalStorageDirectory();
            final fileTempPath =
                '${folder?.path}/${dateExported}_${user?.department}_${user?.shift}_${user?.name}.json';
            try {
              final files = File(fileTempPath);
              final raf = await files.open(mode: FileMode.writeOnlyAppend);
              await raf.writeString(file);
              await raf.close();
              log('Saved to $files');
            } on PlatformException catch (e) {
              log('file saving error: ${e.code}');
            }
          } else {
            jsonFile.writeAsStringSync(file);
          }

          final otherData = state.transactions.transactions
              .where((e) => e.userId != event.userId)
              .toList();
          final myNewData = state.transactions.transactions
              .where((e) =>
                  e.userId == event.userId &&
                  e.patrol != event.patrol &&
                  e.shift != event.shift)
              .toList();
          List<Transaction> newTransactions = [];
          newTransactions.addAll(otherData);
          newTransactions.addAll(myNewData);
          // await DatabaseProvider.putTransactionJson(newTransactions);
          // await DatabaseProvider.putTransactionSpecialJobJson([]);
          add(const InitEFormEvent());

          AppUtil.snackBar(
              message: 'Transaction exported successfully',
              action: SnackBarAction(
                textColor: Colors.amber,
                label: "Open",
                onPressed: () {
                  AppUtil.openFile(jsonFile.path);
                },
              ));
        }
      }
    } else {
      AppUtil.snackBar(message: 'No transaction recorded');
    }
  }

  static Future<String> getExternalDocumentPath() async {
    // To check whether permission is given for this app or not.
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // If not we will ask for permission first
      await Permission.storage.request();
    }
    Directory? _directory = Directory("");
    if (Platform.isAndroid) {
      // Redirects it to download folder in android
      _directory = await getExternalStorageDirectory();
    } else {
      _directory = await getApplicationDocumentsDirectory();
    }

    final exPath = _directory!.path;
    print("Saved Path: $exPath");
    await Directory(exPath).create(recursive: true);
    return exPath;
  }

  static Future<String> get _localPath async {
    // final directory = await getApplicationDocumentsDirectory();
    // return directory.path;
    // To get the external path from device of download folder
    final String directory = await getExternalDocumentPath();
    return directory;
  }

  Future<void> _exportTransactionSpecial(
      ExportSpecialTransactionEvent event, Emitter<EFormState> emitter) async {
    List<Transaction> dataTrx = [];
    List<TransactionDataSyncSpecial> dataTrxExport = [];
    var dateNow = DateTime.now();
    final user = await DatabaseProvider.getSignedUserJson();
    var mUser = User(
        shift: user!.shift, namaStaff: user.name, department: user.department);
    final trxSpecial = await DatabaseProvider.getTransactionSpecialJobJson();
    if (trxSpecial.transactions.isNotEmpty) {
      if (event.type == "modified") {
        dataTrx = trxSpecial.transactions
            .where((e) =>
                // e.userId == event.userId &&
                AppUtil.defaultTimeFormatCustom(dateNow, "yyyy-MM-dd") ==
                    AppUtil.defaultTimeFormatCustom(
                        DateTime.parse(e.dateUpdated), "yyyy-MM-dd") &&
                e.isSync == 0 &&
                (e.finishJob == true))
            .toList();
      } else {
        dataTrx = trxSpecial.transactions
            .where((e) => e.isSync == 0 && (e.finishJob == true))
            .toList();
      }

      if (dataTrx.isEmpty) {
        AppUtil.snackBar(message: 'No Data To Export!');
      } else {
        for (var trxService in dataTrx) {
          dataTrxExport.add(TransactionDataSyncSpecial(
            template: trxService.template.toLowerCase(),
            nfcCode: trxService.codeNfc,
            shift: event.shift.toString(),
            department: user?.department,
            userNik: user?.nik,
            userName: user?.name,
            areaName: trxService.codeAreaName,
            date: trxService.dateCreated,
            status: trxService.isWarning() ? "abnormal" : "normal",
            areaCode: trxService.codeArea,
            documentCode: trxService.codeCpl,
            documentName: trxService.codeCplName,
            equipmentCode: trxService.codeEquipment,
            equipmentName: trxService.codeEquipmentName,
            tag: trxService.tag,
            formatType: trxService.template,
            formType: trxService.formType,
            idService: trxService.idService,
            serviceName: trxService.serviceName,
            input: trxService.textValue,
            parameter: trxService.parameter,
            unit: trxService.unit,
            steps: trxService.steps,
            to: trxService.to,
            correctOption: trxService.correctOption,
            minValue: trxService.minValue,
            maxValue: trxService.maxValue,
            description: trxService.reportedDescription,
            foto: trxService.reportedImage,
            foto2: trxService.reportedImage2,
            shipName: trxService.shipName,
            amount: trxService.amount.toString(),
            a1Amount: trxService.fiA1Amount.toString(),
            b1Amount: trxService.fiB1Amount.toString(),
            b2Amount: trxService.fiB2Amount.toString(),
            estUnloadingB1A: trxService.estUnloadingB1MinA.toString(),
            estUnloadingB2A: trxService.estUnloadingB2MinA.toString(),
            estUnloadingB2B1: trxService.estUnloadingB2MinB1.toString(),
            controlSelected: trxService.controlTf,
            toSelected: trxService.selectedTo,
          ));
        }

        final dataExport = DataExportModelsSpecial(dataTrxExport);

        // DataSyncModelsSpecial(user: mUser, transactions: dataTrxExport);
        // var exportJSOn = dataTrx.map((v) => v.toJson()).toList();
        var exportJSOn = dataExport.toJson();
        final fileJson = exportJSOn;
        //json.encode(exportJSOn);
        log("export special");
        log(fileJson);
        if (!await AppUtil.isStorageGranted()) {
          AppUtil.snackBar(message: 'Required Storage Permission!');
        }

        var directory = Platform.isIOS
            ? await getApplicationDocumentsDirectory()
            : await getExternalStorageDirectory();
        var path = directory!.path;
        var localPath = Platform.isIOS
            ? '$path${Platform.pathSeparator}JSON'
            : '$path${Platform.pathSeparator}';
        final savedDir = Directory(localPath);
        if (!await savedDir.exists()) {
          savedDir.create();
        }
        var dateExported = AppUtil.defaultTimeFormatCustom(
            DateTime.now(), "yyyy-MM-dd_HH:mm:ss");
        final pathDire = await _localPath;
        File jsonFile;
        // Create a file for the path of
        // device and file name with extension
        if (Platform.isAndroid) {
          jsonFile = File(
              '$pathDire/specialjob_${dateExported}_${user?.department}_${user?.shift}_${user?.name}.json');

          print("Save file");
          jsonFile.writeAsString(fileJson);
        } else {
          jsonFile = File(
              '${savedDir.path}${Platform.pathSeparator}_specialjob_${dateExported}_${user?.department}_${user?.shift}_${user?.name}.json');
          jsonFile.writeAsStringSync(fileJson);
        }

        final otherData = state.transactionsSpecialJob.transactions
            .where((e) => e.userId != event.userId)
            .toList();
        final myNewData = state.transactionsSpecialJob.transactions
            .where((e) => e.userId == event.userId)
            .toList();
        List<Transaction> newTransactions = [];
        newTransactions.addAll(otherData);
        newTransactions.addAll(myNewData);
        // await DatabaseProvider.putTransactionJson(newTransactions);
        // await DatabaseProvider.putTransactionSpecialJobJson([]);
        add(const InitEFormEvent());

        AppUtil.snackBar(
            message: 'Transaction exported successfully',
            action: SnackBarAction(
              textColor: Colors.amber,
              label: "Open",
              onPressed: () {
                AppUtil.openFile(jsonFile.path);
              },
            ));
      }
    } else {
      AppUtil.snackBar(message: 'No transaction recorded');
    }
  }

  Future<void> _deleteAllTransaction(
      DeleteAllTransactionEvent event, Emitter<EFormState> emitter) async {
    List<Transaction> newTransactions = [];
    await DatabaseProvider.putTransactionJson(newTransactions);
    await DatabaseProvider.putTransactionSpecialJobJson(newTransactions);
    add(const InitEFormEvent());
    AppUtil.snackBar(message: 'Delete All Transaction successfully');
  }

  FutureOr<void> _setTglPatrol(SetDatePatrol event, Emitter<EFormState> emit) {
    emit(state.copyWith(tglPatrol: event.tglPatrol));
    add(const InitEFormEvent());
  }
}
