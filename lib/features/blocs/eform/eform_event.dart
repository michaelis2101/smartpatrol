part of 'eform_bloc.dart';

abstract class EFormEvent extends Equatable {
  const EFormEvent();

  @override
  List<Object> get props => [];
}

//nfc read
class NfcReaderEvent extends EFormEvent {
  const NfcReaderEvent();
}

class InitEFormEvent extends EFormEvent {
  const InitEFormEvent();
}

class ImportFormatsEvent extends EFormEvent {
  final Function onSuccess;
  final Function(String) onFailed;

  const ImportFormatsEvent({required this.onSuccess, required this.onFailed});
}

class ImportSectionEvent extends EFormEvent {
  final Function onSuccess;
  final Function(String) onFailed;

  const ImportSectionEvent({required this.onSuccess, required this.onFailed});
}

class ImportAreaEvent extends EFormEvent {
  final Function onSuccess;
  final Function(String) onFailed;

  const ImportAreaEvent({required this.onSuccess, required this.onFailed});
}

class ImportCplEvent extends EFormEvent {
  final Function onSuccess;
  final Function(String) onFailed;

  const ImportCplEvent({required this.onSuccess, required this.onFailed});
}

class ImportEquipmentEvent extends EFormEvent {
  final Function onSuccess;
  final Function(String) onFailed;

  const ImportEquipmentEvent({required this.onSuccess, required this.onFailed});
}

class ImportServiceSpecialEvent extends EFormEvent {
  final Function onSuccess;
  final Function(String) onFailed;

  const ImportServiceSpecialEvent(
      {required this.onSuccess, required this.onFailed});
}

class ImportServiceEvent extends EFormEvent {
  final Function onSuccess;
  final Function(String) onFailed;

  const ImportServiceEvent({required this.onSuccess, required this.onFailed});
}

class ImportCplAutoEvent extends EFormEvent {
  final Function onSuccess;
  final Function(String) onFailed;

  const ImportCplAutoEvent({required this.onSuccess, required this.onFailed});
}

class ImportEquipmentAutoEvent extends EFormEvent {
  final Function onSuccess;
  final Function(String) onFailed;

  const ImportEquipmentAutoEvent(
      {required this.onSuccess, required this.onFailed});
}

class ImportServiceAutoEvent extends EFormEvent {
  final Function onSuccess;
  final Function(String) onFailed;

  const ImportServiceAutoEvent(
      {required this.onSuccess, required this.onFailed});
}

class ImportSpecialCplEvent extends EFormEvent {
  final Function onSuccess;
  final Function(String) onFailed;

  const ImportSpecialCplEvent(
      {required this.onSuccess, required this.onFailed});
}

class ImportSpecialPositionEvent extends EFormEvent {
  final Function onSuccess;
  final Function(String) onFailed;

  const ImportSpecialPositionEvent(
      {required this.onSuccess, required this.onFailed});
}

class ImportSpecialJobFormEvent extends EFormEvent {
  final Function onSuccess;
  final Function(String) onFailed;

  const ImportSpecialJobFormEvent(
      {required this.onSuccess, required this.onFailed});
}

class SearchFormatsEvent extends EFormEvent {
  final String namaFormats;

  const SearchFormatsEvent(this.namaFormats);
}

class SearchSectionEvent extends EFormEvent {
  final String namaSection, kodeFormat;
  const SearchSectionEvent(this.namaSection, this.kodeFormat);
}

class SearchAreaEvent extends EFormEvent {
  final String namaArea, kodeSection;

  const SearchAreaEvent(this.namaArea, this.kodeSection);
}

class GetSectionByFormats extends EFormEvent {
  final String kodeFormat;

  const GetSectionByFormats(this.kodeFormat);
}

class GetAreaBySectionEvent extends EFormEvent {
  final String kodeSection;

  const GetAreaBySectionEvent(this.kodeSection);
}

class GetCplByAreaEvent extends EFormEvent {
  final String kodeArea, kodeFormat;

  const GetCplByAreaEvent(this.kodeArea, this.kodeFormat);
}

class SearchCplEvent extends EFormEvent {
  final String namaCpl, kodeFormat;

  const SearchCplEvent(this.namaCpl, this.kodeFormat);
}

class GetEquipmentByCplEvent extends EFormEvent {
  final String kodeCpl;

  const GetEquipmentByCplEvent(this.kodeCpl);
}

class GetEquipmentByNfcTag extends EFormEvent {
  final String kodeNfc;

  const GetEquipmentByNfcTag(this.kodeNfc);
}

class SearchEquipmentEvent extends EFormEvent {
  final String namaEquipment;

  const SearchEquipmentEvent(this.namaEquipment);
}

class ValidationServiceSpecialStep extends EFormEvent {
  final int steps;
  final String kodeEquipment;
  final EFormState areaState;

  const ValidationServiceSpecialStep({
    required this.steps,
    required this.kodeEquipment,
    required this.areaState,
  });
}

class GetTransactionSpecial extends EFormEvent {
  final int steps;
  final String kodeEquipment;
  final EFormState areaState;
  final bool isAreaBloc;
  final bool newTransaction;

  const GetTransactionSpecial({
    required this.steps,
    required this.isAreaBloc,
    required this.kodeEquipment,
    required this.areaState,
    this.newTransaction = false,
  });
}

class GetServiceSpecialStep extends EFormEvent {
  final int steps;
  final bool isAreaBloc;
  final String kodeEquipment;
  final String byUuid;
  final EFormState areaState;

  const GetServiceSpecialStep(
      {required this.steps,
      required this.kodeEquipment,
      required this.areaState,
      this.byUuid = '',
      this.isAreaBloc = false});
}

class GetListHistorySpecialJob extends EFormEvent {
  final String searchEquipment;

  const GetListHistorySpecialJob({
    required this.searchEquipment,
  });
}

class GetServiceSearchByTag extends EFormEvent {
  final String searchTag;
  final EFormState areaState;

  const GetServiceSearchByTag(
      {required this.searchTag, required this.areaState});
}

class GetServiceSpecialUnloadingStep extends EFormEvent {
  final int steps;
  final bool isAreaBloc;
  final String kodeEquipment, uuid;
  final EFormState areaState;
  final bool newTransaction;

  const GetServiceSpecialUnloadingStep(
      {required this.steps,
      required this.kodeEquipment,
      required this.areaState,
      this.newTransaction = false,
      this.isAreaBloc = false,
      this.uuid = ''});
}

class GetServiceSpecialTransferStep extends EFormEvent {
  final int steps;
  final bool isAreaBloc;
  final String kodeEquipment, uuid;
  final EFormState areaState;
  final bool newTransaction;

  const GetServiceSpecialTransferStep(
      {required this.steps,
      required this.kodeEquipment,
      required this.areaState,
      this.newTransaction = false,
      this.uuid = "",
      this.isAreaBloc = false});
}

class GetServiceByEquipmentEvent extends EFormEvent {
  final String kodeEquipment;
  final EFormState areaState;
  final String steps;

  const GetServiceByEquipmentEvent(
      {required this.kodeEquipment,
      required this.areaState,
      required this.steps});
}

class GetServiceByEquipmentStepEvent extends EFormEvent {
  final String kodeEquipment;
  final EFormState areaState;
  final String steps;

  const GetServiceByEquipmentStepEvent(
      {required this.kodeEquipment,
      required this.areaState,
      required this.steps});
}

class GetTransactionHistoryByFormatEvent extends EFormEvent {
  final String filterFormat, search, tipe; //tipe equipment/cpl
  const GetTransactionHistoryByFormatEvent(
      {required this.filterFormat, required this.search, this.tipe = ''});
}

class GetTransactionSpecialHistoryByFormatEvent extends EFormEvent {
  final String filterFormat, search, tipe; //tipe transfer/unloading/loading
  const GetTransactionSpecialHistoryByFormatEvent(
      {required this.filterFormat, required this.search, this.tipe = ''});
}

class ChangeStopStateServiceByEquipmentEvent extends EFormEvent {
  final bool? value;
  final bool isAreaBloc;
  final String idService;

  const ChangeStopStateServiceByEquipmentEvent(
      {required this.idService, required this.value, this.isAreaBloc = false});
}

class ChangeDetectedStateServiceByEquipmentEvent extends EFormEvent {
  final bool? value;
  final bool isAreaBloc;
  final String idService;

  const ChangeDetectedStateServiceByEquipmentEvent(
      {required this.idService, required this.value, this.isAreaBloc = false});
}

class ChangeSelectControlTOSpecialTFEvent extends EFormEvent {
  final String? value;
  final bool isAction, isAreaBloc;
  final String equipmentCode, type; //tipe control/to
  final int currentStep;

  const ChangeSelectControlTOSpecialTFEvent(
      {required this.equipmentCode,
      this.isAction = false,
      required this.value,
      required this.type,
      this.isAreaBloc = false,
      required this.currentStep});
}

class ChangeTextValueStateServiceByEquipmentEvent extends EFormEvent {
  final bool isAreaBloc, isRadio, isReport, isSpecialJob;
  final String idService, value;

  const ChangeTextValueStateServiceByEquipmentEvent({
    required this.idService,
    required this.value,
    this.isAreaBloc = false,
    this.isRadio = false,
    this.isReport = false,
    this.isSpecialJob = false,
  });
}

class ChangeTextValueStateServiceByStepTransferEvent extends EFormEvent {
  final bool isAreaBloc;
  final String idService, value, shipName;
  final int step;

  const ChangeTextValueStateServiceByStepTransferEvent({
    required this.idService,
    required this.value,
    required this.shipName,
    this.isAreaBloc = false,
    this.step = 1,
  });
}

class ChangeTextValueStateServiceByStepUnloadingEvent extends EFormEvent {
  final bool isAreaBloc, isSpecialJob;
  final String idService, value, shipName;
  final double amount;
  final int step;

  const ChangeTextValueStateServiceByStepUnloadingEvent({
    required this.idService,
    required this.value,
    required this.shipName,
    this.isAreaBloc = false,
    this.isSpecialJob = false,
    this.step = 1,
    this.amount = 0.0,
  });
}

class ChangeStopStateAllServiceByEquipmentEvent extends EFormEvent {
  final bool? value;
  final bool isAction, isAreaBloc;
  final String equipmentCode;

  const ChangeStopStateAllServiceByEquipmentEvent(
      {required this.equipmentCode,
      required this.value,
      required this.isAreaBloc,
      this.isAction = false});
}

class ChangeSkipStateAllServiceByEquipmentEvent extends EFormEvent {
  final bool? value;
  final bool isAction, isAreaBloc;
  final String equipmentCode;

  const ChangeSkipStateAllServiceByEquipmentEvent(
      {required this.equipmentCode,
      required this.value,
      required this.isAreaBloc,
      this.isAction = false});
}

class ChangeDetectedStateAllServiceByEquipmentEvent extends EFormEvent {
  final bool? value;
  final bool isAction, isAreaBloc;
  final String equipmentCode;

  const ChangeDetectedStateAllServiceByEquipmentEvent(
      {required this.equipmentCode,
      required this.value,
      required this.isAreaBloc,
      this.isAction = false});
}

class ChangeServiceReportedConditionEvent extends EFormEvent {
  final int value;
  final String idService;
  final bool isAreaBloc;

  const ChangeServiceReportedConditionEvent(
      {required this.idService, required this.value, this.isAreaBloc = false});
}

class ChangeServiceReportedRequestEvent extends EFormEvent {
  final String idService, value;
  final bool isAreaBloc;

  const ChangeServiceReportedRequestEvent(
      {required this.idService, required this.value, this.isAreaBloc = false});
}

class AddServiceReportedPhotoEvent extends EFormEvent {
  final String idService;
  final bool isAreaBloc;
  final XFile image;
  final int imageIndex; //1,2
  const AddServiceReportedPhotoEvent(
      {required this.idService,
      required this.image,
      this.isAreaBloc = false,
      required this.imageIndex});
}

class SaveNewEFormUnloadingSJTransactionEvent extends EFormEvent {
  final String codeEquipment, typeForm;
  final Function? onFinish;
  final bool verify;
  final bool isSpecialJob;
  final bool isFinish, isAreaBloc, isContinue;
  final int step;
  final EFormState areaState;
  final InsertStep1? step1;
  final InsertStep2? step2;
  final InsertStep3? step3;

  const SaveNewEFormUnloadingSJTransactionEvent(
      {this.codeEquipment = '',
      required this.typeForm,
      this.onFinish,
      this.verify = true,
      this.isSpecialJob = false,
      this.isContinue = true,
      this.step = 1,
      this.isFinish = false, //set true to
      this.isAreaBloc = false,
      this.step1,
      this.step2,
      this.step3,
      required this.areaState});
}

class SaveNewTransferSJTransactionEvent extends EFormEvent {
  final String codeEquipment;
  final Function? onFinish;
  final bool verify;
  final bool isUpdate;
  final bool isFinish, isAreaBloc;
  final int step;
  final EFormState areaState;
  final InsertStep12? step1n2;

  const SaveNewTransferSJTransactionEvent(
      {this.codeEquipment = '',
      this.onFinish,
      this.verify = true,
      this.step = 1,
      this.isFinish = false, //set true to
      this.isAreaBloc = false,
      this.step1n2,
      this.isUpdate = false,
      required this.areaState});
}

class InsertStep12 {
  final String control;
  final String to;

  InsertStep12({required this.control, required this.to});
}

class InsertStep1 {
  final String amount;
  final String shipName;
  final String fiA1Amount;

  InsertStep1(
      {required this.amount, required this.shipName, required this.fiA1Amount});
}

class InsertStep2 {
  final String estimateUnloadingB1minA1;
  final String sumB1;

  InsertStep2({required this.estimateUnloadingB1minA1, required this.sumB1});
}

class InsertStep3 {
  final String estimateUnloadingB2minB1;
  final String sumB2;
  InsertStep3({required this.estimateUnloadingB2minB1, required this.sumB2});
}

class SetDatePatrol extends EFormEvent {
  final String tglPatrol;
  const SetDatePatrol({
    this.tglPatrol = '',
  });
}

class SaveAllStopEFormTransactionEvent extends EFormEvent {
  final Function? onFinish;
  final bool verify, value;
  final List<Equipment>? equipmentsByCpl;

  const SaveAllStopEFormTransactionEvent(
      {this.onFinish,
      this.verify = true,
      this.value = false,
      this.equipmentsByCpl});
}

class SaveNewEFormTransactionEvent extends EFormEvent {
  final String codeEquipment, codeSectionArea;
  final Function? onFinish;
  final bool verify, reloadAll;
  final bool isSpecialJob;

  const SaveNewEFormTransactionEvent(
      {this.codeEquipment = '',
      this.codeSectionArea = '',
      this.onFinish,
      this.verify = true,
      this.reloadAll = true,
      this.isSpecialJob = false});
}

class UpdateEFormTransactionEvent extends EFormEvent {
  final String codeEquipment;
  final Function? onFinish;
  final bool verify, reloadAll;
  final int step;
  final bool isSpecialJob;

  const UpdateEFormTransactionEvent(
      {this.codeEquipment = '',
      this.onFinish,
      this.verify = true,
      this.reloadAll = true,
      this.step = 1,
      this.isSpecialJob = false});
}

class ExportTransactionEvent extends EFormEvent {
  final String userId;
  final int patrol;
  final String shift;
  final String type; //st , sebagian (modified)

  const ExportTransactionEvent(
      {this.type = 'standard',
      required this.userId,
      required this.shift,
      required this.patrol});
}

class ExportSpecialTransactionEvent extends EFormEvent {
  final String userId;
  final int patrol;
  final String shift;
  final String type; //st , sebagian (modified)

  const ExportSpecialTransactionEvent(
      {this.type = 'standard',
      required this.userId,
      required this.shift,
      required this.patrol});
}

class DeleteAllTransactionEvent extends EFormEvent {
  final String userId;
  final int patrol;
  final String shift;

  const DeleteAllTransactionEvent(
      {required this.userId, required this.shift, required this.patrol});
}

class PostTransactionEvent extends EFormEvent {
  const PostTransactionEvent();
}

class SyncTransactionEvent extends EFormEvent {
  final String userId, uName, nik, department, nama, shift, urlServer, api_id;
  final int patrol;

  const SyncTransactionEvent(
      {required this.userId,
      required this.uName,
      required this.nik,
      required this.nama,
      required this.department,
      required this.shift,
      required this.patrol,
      required this.urlServer,
      required this.api_id});
}

class CheckTransactionEvent extends EFormEvent {
  const CheckTransactionEvent();
}

// class SetFormatForDropdown extends EFormEvent {
//   const SetFormatForDropdown();
// }

// class SetSelectedFormat extends EFormEvent {
//   final String format;
//   const SetSelectedFormat({required this.format});
// }

class SyncTransactionSpecialJobEvent extends EFormEvent {
  final String userId, uName, nik, department, nama, shift, urlServer, api_id;
  final int patrol;

  const SyncTransactionSpecialJobEvent(
      {required this.userId,
      required this.uName,
      required this.nik,
      required this.nama,
      required this.department,
      required this.shift,
      required this.patrol,
      required this.urlServer,
      required this.api_id});
}
