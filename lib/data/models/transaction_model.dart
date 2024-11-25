import 'package:equatable/equatable.dart';
import 'package:smart_patrol/data/models/user_model.dart';
import 'package:smart_patrol/utils/enum.dart';
import 'package:smart_patrol/utils/utils.dart';

class TransactionModel extends Equatable {
  const TransactionModel({this.transactions = const []});

  factory TransactionModel.fromJson(dynamic json) => TransactionModel(
      transactions: ((json["transactions"] as List?) ?? [])
          .map((e) => Transaction.fromJson(e))
          .toList());

  final List<Transaction> transactions;

  TransactionModel copyWith({List<Transaction>? transactions}) =>
      TransactionModel(transactions: transactions ?? this.transactions);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['transactions'] = transactions.map((v) => v.toJson()).toList();
    return map;
  }

  @override
  List<Object> get props => [transactions];
}

class Transaction extends Equatable {
  const Transaction({
    this.uuid = '',
    this.codeEquipment = '',
    this.codeFormat = '',
    this.template = '',
    this.codeEquipmentName = '',
    this.patrol = 1,
    this.shift = '',
    this.dateCreated = '',
    this.dateUpdated = '',
    this.userId = '',
    this.codeCpl = '',
    this.codeCplName = '',
    this.codeArea = '',
    this.codeAreaName = '',
    this.unit = '',
    this.formType = '',
    this.codeNfc = '',
    this.tag = '',
    this.serviceName = '',
    this.shipName = '',
    this.parameter = '',
    this.idService = '',
    this.maxValue = '',
    this.minValue = '',
    this.correctOption = '',
    this.valueOption = '',
    this.checkBox = 0,
    this.reportedCondition = 0,
    this.reportedImage = '',
    this.reportedImage2 = '',
    this.reportedRequest = '',
    this.reportedDescription = '',
    this.textValue = '',
    this.to = '', //special transfer
    this.controlTf = '', //special transfer
    this.selectedTo = '', //special transfer
    this.isSync = 0, //not
    this.status = '', //not
    this.steps = '', //not
    this.amount = 0.0, //not
    //unloading
    this.fiA1Amount = 0.0, //not
    this.fiB1Amount = 0.0, //not
    this.fiB2Amount = 0.0, //not
    this.estUnloadingB1MinA = 0.0, //not
    this.estUnloadingB2MinA = 0.0, //not
    this.estUnloadingB2MinB1 = 0.0,
    this.finishJob = false,
    this.isContinue = false,
    this.editable = true, //not from db
  });

  final String codeArea,
      template,
      uuid,
      codeAreaName,
      codeCpl,
      codeCplName,
      userId,
      dateCreated,
      dateUpdated,
      codeEquipment,
      codeEquipmentName,
      parameter,
      shift,
      to,
      controlTf,
      selectedTo,
      shipName,
      steps;
  final int patrol, isSync; //sync 0 no 1 true
  //special unloading
  final double amount;
  final bool finishJob, isContinue, editable;
  final double fiA1Amount;
  final double fiB1Amount;
  final double fiB2Amount;
  final double estUnloadingB1MinA; //b1-A
  final double estUnloadingB2MinB1; //b2-b1
  final double estUnloadingB2MinA; //b2-A
  final String unit, codeFormat;
  final String formType;
  final String codeNfc;
  final String tag;
  final String serviceName;
  final String idService;
  final String maxValue;
  final String minValue;
  final String correctOption;
  final String valueOption;
  final int checkBox;
  final String reportedImage;
  final String reportedImage2;
  final int reportedCondition;
  final String reportedRequest;
  final String reportedDescription;
  final String textValue;
  final String status;

  factory Transaction.fromJson(dynamic json) => Transaction(
        uuid: json['uuid'] ?? '',
        codeFormat: json['code_format'] ?? '',
        codeEquipment: json['code_equipment'] ?? '',
        codeEquipmentName: json['equipment_name'] ?? '',
        patrol: json['patrol'] ?? 1,
        shift: json['shift'] ?? '',
        dateCreated: json['date_created'] ?? '',
        dateUpdated: json['date_updated'] ?? '',
        userId: json['user_id'] ?? '',
        codeCpl: json['code_cpl'] ?? '',
        template: json['template'] ?? '',
        codeCplName: json['cpl_name'] ?? '',
        codeArea: json['code_area'] ?? '',
        codeAreaName: json['area_name'] ?? '',
        unit: json['unit'] ?? '',
        formType: json['form_type'] ?? '',
        codeNfc: json['code_nfc'] ?? '',
        tag: json['tag'] ?? '',
        serviceName: json['service_name'] ?? '',
        parameter: json['parameter'] ?? '',
        idService: json['id_service'] ?? '',
        correctOption: json['correct_option'] ?? '',
        valueOption: json['value_option'] ?? '',
        minValue: json['min_value'] ?? '',
        maxValue: json['max_value'] ?? '',
        checkBox: json['checkbox'] ?? 0,
        reportedCondition: json['reported_condition'] ?? 0,
        reportedImage: json['reported_image'] ?? '',
        reportedImage2: json['reported_image_2'] ?? '',
        reportedRequest: json['reported_request'] ?? '',
        reportedDescription: json['reported_description'] ?? '',
        textValue: json['text_value'],
        isSync: json['is_sync'] ?? 0,
        status: json['status'] ?? '',
        steps: json['steps'] ?? '',
        to: json['to'] ?? '',
        controlTf: json['control_tf'] ?? '',
        selectedTo: json['selected_to'] ?? '',
        shipName: json['ship_name'] ?? '',
        amount: json['amount'] ?? 0.0,
        fiA1Amount: json['a1_amount'] ?? 0.0,
        fiB1Amount: json['b1_amount'] ?? 0.0,
        fiB2Amount: json['b2_amount'] ?? 0.0,
        estUnloadingB1MinA: json['est_unloading_b1_a'] ?? 0.0,
        estUnloadingB2MinA: json['est_unloading_b2_a'] ?? 0.0,
        estUnloadingB2MinB1: json['est_unloading_b2_b1'] ?? 0.0,
        finishJob: json['finish_job'] ?? false,
        isContinue: json['is_continue'] ?? false, //for step 2
        editable: json['editable'] ?? true, //for step 2
      );

  Transaction copyWith({
    String? uuid,
    String? codeArea,
    String? codeFormat,
    String? codeAreaName,
    String? codeCplName,
    String? codeCpl,
    String? userId,
    String? dateCreated,
    String? dateUpdated,
    String? shift,
    int? patrol,
    String? codeEquipment,
    String? codeEquipmentName,
    String? unit,
    String? formType,
    String? codeNfc,
    String? tag,
    String? serviceName,
    String? idService,
    String? parameter,
    String? maxValue,
    String? minValue,
    String? correctOption,
    String? valueOption,
    int? checkBox,
    String? reportedImage,
    String? reportedImage2,
    int? reportedCondition,
    String? reportedRequest,
    String? reportedDescription,
    String? textValue,
    int? isSync,
    String? status,
    String? steps,
    String? to,
    String? controlTf,
    String? selectedTo,
    String? template,
    String? shipName,
    double? amount,
    double? fiA1Amount,
    double? fiB1Amount,
    double? fiB2Amount,
    double? estUnloadingB1MinA,
    double? estUnloadingB2MinA,
    double? estUnloadingB2MinB1,
    bool? finishJob,
    bool? isContinue,
    bool? editable,
  }) =>
      Transaction(
        uuid: uuid ?? this.uuid,
        codeArea: codeArea ?? this.codeArea,
        codeFormat: codeFormat ?? this.codeFormat,
        codeAreaName: codeAreaName ?? this.codeAreaName,
        codeCpl: codeCpl ?? this.codeCpl,
        codeCplName: codeCplName ?? this.codeCplName,
        userId: userId ?? this.userId,
        dateCreated: dateCreated ?? this.dateCreated,
        shift: shift ?? this.shift,
        patrol: patrol ?? this.patrol,
        dateUpdated: dateUpdated ?? this.dateUpdated,
        codeEquipment: codeEquipment ?? this.codeEquipment,
        codeEquipmentName: codeEquipmentName ?? this.codeEquipmentName,
        unit: unit ?? this.unit,
        formType: formType ?? this.formType,
        codeNfc: codeNfc ?? this.codeNfc,
        tag: tag ?? this.tag,
        serviceName: serviceName ?? this.serviceName,
        idService: idService ?? this.idService,
        parameter: parameter ?? this.parameter,
        maxValue: maxValue ?? this.maxValue,
        minValue: minValue ?? this.minValue,
        correctOption: correctOption ?? this.correctOption,
        valueOption: valueOption ?? this.valueOption,
        checkBox: checkBox ?? this.checkBox,
        reportedRequest: reportedRequest ?? this.reportedRequest,
        reportedImage: reportedImage ?? this.reportedImage,
        reportedImage2: reportedImage2 ?? this.reportedImage2,
        reportedCondition: reportedCondition ?? this.reportedCondition,
        reportedDescription: reportedDescription ?? this.reportedDescription,
        textValue: textValue ?? this.textValue,
        isSync: isSync ?? this.isSync,
        status: status ?? this.status,
        steps: steps ?? this.steps,
        to: to ?? this.to,
        selectedTo: selectedTo ?? this.selectedTo,
        controlTf: controlTf ?? this.controlTf,
        template: template ?? this.template,
        shipName: shipName ?? this.shipName,
        amount: amount ?? this.amount,
        fiA1Amount: fiA1Amount ?? this.fiA1Amount,
        fiB1Amount: fiB1Amount ?? this.fiB1Amount,
        fiB2Amount: fiB2Amount ?? this.fiB2Amount,
        estUnloadingB1MinA: estUnloadingB1MinA ?? this.estUnloadingB1MinA,
        estUnloadingB2MinA: estUnloadingB2MinA ?? this.estUnloadingB2MinA,
        estUnloadingB2MinB1: estUnloadingB2MinB1 ?? this.estUnloadingB2MinB1,
        finishJob: finishJob ?? this.finishJob,
        isContinue: isContinue ?? this.isContinue,
        editable: editable ?? this.editable,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uuid'] = uuid;
    map['code_equipment'] = codeEquipment;
    map['code_format'] = codeFormat;
    map['patrol'] = patrol;
    map['shift'] = shift;
    map['date_created'] = dateCreated;
    map['date_updated'] = dateUpdated;
    map['user_id'] = userId;
    map['code_cpl'] = codeCpl;
    map['cpl_name'] = codeCplName;
    map['area_name'] = codeAreaName;
    map['equipment_name'] = codeEquipmentName;
    map['code_area'] = codeArea;
    map['unit'] = unit;
    map['form_type'] = formType;
    map['code_nfc'] = codeNfc;
    map['tag'] = tag;
    map['status'] = status;
    map['service_name'] = serviceName;
    map['id_service'] = idService;
    map['parameter'] = parameter;
    map['correct_option'] = correctOption;
    map['value_option'] = valueOption;
    map['min_value'] = minValue;
    map['max_value'] = maxValue;
    map['checkbox'] = checkBox;
    map['reported_condition'] = reportedCondition;
    map['reported_image'] = reportedImage;
    map['reported_image_2'] = reportedImage2;
    map['reported_request'] = reportedRequest;
    map['reported_description'] = reportedDescription;
    map['text_value'] = textValue;
    map['is_sync'] = isSync;
    map['status'] = status;
    map['steps'] = steps;
    map['to'] = to;
    map['control_tf'] = controlTf;
    map['selected_to'] = selectedTo;
    map['template'] = template;
    map['ship_name'] = shipName;
    map['amount'] = amount;
    map['a1_amount'] = fiA1Amount;
    map['b1_amount'] = fiB1Amount;
    map['b2_amount'] = fiB2Amount;
    map['est_unloading_b1_a'] = estUnloadingB1MinA;
    map['est_unloading_b2_a'] = estUnloadingB2MinA;
    map['est_unloading_b2_b1'] = estUnloadingB2MinB1;
    map['finish_job'] = finishJob;
    map['is_continue'] = isContinue;
    map['true'] = editable;
    return map;
  }

// This function updates the flag

  @override
  List<Object> get props => [
        uuid,
        codeArea,
        codeFormat,
        codeAreaName,
        codeCpl,
        codeCplName,
        userId,
        dateCreated,
        dateUpdated,
        shift,
        patrol,
        parameter,
        codeEquipment,
        codeEquipmentName,
        unit,
        formType,
        codeNfc,
        tag,
        template,
        serviceName,
        idService,
        maxValue,
        minValue,
        correctOption,
        valueOption,
        checkBox,
        reportedCondition,
        reportedImage,
        reportedImage2,
        reportedRequest,
        reportedDescription,
        textValue,
        isSync,
        status,
        steps,
        to,
        controlTf,
        selectedTo,
        amount,
        shipName,
        fiA1Amount,
        fiB1Amount,
        fiB2Amount,
        estUnloadingB1MinA,
        estUnloadingB2MinA,
        estUnloadingB2MinB1,
        finishJob,
        isContinue,
        editable
      ];
}

//iscontinue indicator if amount
extension TransactionExtension on Transaction {
  FormType getFormType() =>
      FormType.values.firstWhere((e) => e.type == formType);

  String getRange() => minValue.isEmpty
      ? 'max $maxValue'
      : maxValue.isEmpty
          ? 'min $minValue'
          : 'min $minValue ~ max $maxValue';

  List<String> getValueOptions() => valueOption.split(',');

  List<String> getCorrectOptions() => correctOption.split(',');

  bool unloadingContinue() {
    return isContinue;
  }

  List<String> getShiftList() {
    // Check if the inputString contains the delimiter ";"
    if (shift.contains(';')) {
      // Split the inputString into a list of strings using the ";" delimiter
      List<String> resultList = shift.split(';');
      return resultList;
    } else {
      // If the inputString doesn't contain ";", return a list with the original string
      return [shift];
    }
  }

  bool isValidated() {
    if (textValue.isEmpty) {
      return false;
    }
    if (getFormType() == FormType.options) {
      if (textValue.isNotEmpty && correctOption.toLowerCase().contains(textValue.toLowerCase())) {
        return true;
      } else if (textValue.isNotEmpty &&
          !correctOption.contains(textValue) &&
          textValue.toUpperCase() == "STOP") {
        if (textValue == 'STOP' && reportedCondition == 0) {
          return true;
        }

        if (textValue == 'STOP' &&
            (reportedCondition == 1 || reportedCondition == 2) &&
            reportedDescription.isEmpty) {
          return false;
        }

        if (textValue == 'STOP' &&
            (reportedCondition == 1 || reportedCondition == 2)) {
          //&& reportedImage.isNotEmpty
          return false;
        }

        if (textValue == 'STOP' &&
            reportedCondition == 2 &&
            reportedRequest.isEmpty) {
          return false;
        }
      }
      return false;
    } else {
      if (textValue.toUpperCase() == 'STOP' && checkBox == 1) {
        return true;
      }
    }

    if (textValue == 'ND' && reportedCondition == 0) {
      return false;
    }

    if (textValue == 'ND' &&
        (reportedCondition == 1 || reportedCondition == 2) &&
        reportedDescription.isEmpty) {
      return false;
    }

    if (textValue == 'ND' &&
        (reportedCondition == 1 || reportedCondition == 2) &&
        reportedImage.isNotEmpty) {
      //&& reportedImage.isNotEmpty
      return true;
    }

    if (textValue == 'ND' &&
        reportedCondition == 2 &&
        reportedRequest.isEmpty) {
      return false;
    }

    if (textValue == 'ND' &&
        reportedCondition == 1 &&
        reportedDescription.isNotEmpty &&
        reportedImage.isNotEmpty) {
      //&& reportedImage.isNotEmpty
      return true;
    }

    if (textValue == 'ND' &&
        reportedCondition == 2 &&
        reportedDescription.isNotEmpty &&
        reportedRequest.isNotEmpty &&
        reportedImage.isNotEmpty) {
      //&& reportedImage.isNotEmpty
      return true;
    }

    if (getFormType() == FormType.range) {
      if (minValue.isNotEmpty && maxValue.isNotEmpty) {
        if ((AppUtil.isNumeric(textValue) &&
                (num.tryParse(textValue) ?? 0) <
                    (num.tryParse(minValue) ?? 0)) ||
            (num.tryParse(textValue) ?? 0) > (num.tryParse(maxValue) ?? 0)) {
          if (reportedCondition == 1 &&
              reportedDescription.isNotEmpty &&
              reportedImage.isNotEmpty) {
            //&& reportedImage.isNotEmpty
            return true;
          } else if (reportedCondition == 2 &&
              reportedDescription.isNotEmpty &&
              reportedRequest.isNotEmpty &&
              reportedImage.isNotEmpty) {
            //&& reportedImage.isNotEmpty
            return true;
          } else {
            return false;
          }
        } else {
          return true;
        }
      }
    } else if (getFormType() == FormType.max) {
      if (maxValue.isNotEmpty &&
          AppUtil.isNumeric(textValue) &&
          (num.tryParse(textValue) ?? 0) > (num.tryParse(maxValue) ?? 0)) {
        if (reportedCondition == 1 &&
            reportedDescription.isNotEmpty &&
            reportedImage.isNotEmpty) {
          //reportedImage.isNotEmpty
          return true;
        } else if (reportedCondition == 2 &&
            reportedDescription.isNotEmpty &&
            reportedRequest.isNotEmpty &&
            reportedImage.isNotEmpty) {
          // reportedImage.isNotEmpty
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    } else if (getFormType() == FormType.min) {
      if (minValue.isNotEmpty &&
          AppUtil.isNumeric(textValue) &&
          (num.tryParse(textValue) ?? 0) < (num.tryParse(minValue) ?? 0)) {
        if (reportedCondition == 1 &&
            reportedDescription.isNotEmpty &&
            reportedImage.isNotEmpty &&
            reportedImage.isNotEmpty) {
          // reportedImage.isNotEmpty
          return true;
        } else if (reportedCondition == 2 &&
            reportedDescription.isNotEmpty &&
            reportedRequest.isNotEmpty &&
            reportedImage.isNotEmpty &&
            reportedImage.isNotEmpty) {
          // reportedImage.isNotEmpty
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    } else if (getFormType() == FormType.options) {
      if (textValue.isNotEmpty && correctOption.contains(textValue)) {
        return true;
      } else if (textValue.isNotEmpty &&
          !correctOption.contains(textValue) &&
          textValue.toUpperCase() == "STOP") {
        if (textValue == 'STOP' && reportedCondition == 0) {
          return false;
        }

        if (textValue == 'STOP' &&
            (reportedCondition == 1 || reportedCondition == 2) &&
            reportedDescription.isEmpty) {
          return false;
        }

        if (textValue == 'STOP' &&
            (reportedCondition == 1 || reportedCondition == 2) &&
            reportedImage.isNotEmpty) {
          return false;
        }

        if (textValue == 'STOP' &&
            reportedCondition == 2 &&
            reportedRequest.isEmpty) {
          return false;
        }
        return false;
      } else {
        return false;
      }
    }
    return true;
  }

  bool isWarning() {
    if (textValue == 'ND') {
      return true;
    }

    if (getFormType() == FormType.range) {
      if (minValue.isNotEmpty && maxValue.isNotEmpty) {
        if ((AppUtil.isNumeric(textValue) &&
                (num.tryParse(textValue) ?? 0) <
                    (num.tryParse(minValue) ?? 0)) ||
            (num.tryParse(textValue) ?? 0) > (num.tryParse(maxValue) ?? 0)) {
          return true;
        } else {
          return false;
        }
      }
    } else if (getFormType() == FormType.max) {
      if (maxValue.isNotEmpty &&
          AppUtil.isNumeric(textValue) &&
          (num.tryParse(textValue) ?? 0) > (num.tryParse(maxValue) ?? 0)) {
        return true;
      } else {
        return false;
      }
    } else if (getFormType() == FormType.min) {
      if (minValue.isNotEmpty &&
          AppUtil.isNumeric(textValue) &&
          (num.tryParse(textValue) ?? 0) < (num.tryParse(minValue) ?? 0)) {
        return true;
      } else {
        return false;
      }
    } else if (getFormType() == FormType.options) {
      if (textValue.isNotEmpty &&
          !correctOption.contains(textValue) &&
          textValue.toUpperCase() == "STOP") {
        return false;
      } else if (textValue.isNotEmpty &&
          !correctOption.toLowerCase().contains(textValue.toLowerCase())) {
        return true;
      }
    }
    return false;
  }
}

extension TransactionModelExtension on TransactionModel {
  int getProgress(String codeCpl) {
    if (transactions.isEmpty) {
      return 0;
    }

    var list = transactions.where((e) => e.codeCpl == codeCpl).toList();
    var items = list.where((e) => e.isValidated()).toList();
    var result = (items.length / list.length) * 100;
    if (result.isNaN) {
      return 0;
    }
    return result.round();
  }

  List<Transaction> getTransactionByEquipment(
      String codeEquipment, User? signedUser) {
    if (transactions.isEmpty) {
      return [];
    } else {
      return transactions
          .where((e) =>
              e.codeEquipment == codeEquipment &&
              e.getShiftList().contains(signedUser?.shift))
          .toList();
    }
  }
}
