import 'package:equatable/equatable.dart';
import 'package:smart_patrol/utils/enum.dart';
import 'package:smart_patrol/utils/utils.dart';

class ServiceModel extends Equatable {
  const ServiceModel({this.service = const []});

  factory ServiceModel.fromJson(dynamic json) => ServiceModel(
      service: ((json['service'] as List?) ?? [])
          .map((e) => Service.fromJson(e))
          .toList());

  final List<Service> service;

  ServiceModel copyWith({List<Service>? service}) =>
      ServiceModel(service: service ?? this.service);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['service'] = service.map((v) => v.toJson()).toList();
    return map;
  }

  @override
  List<Object> get props => [service];
}

class Service extends Equatable {
  const Service({
    this.unit = '',
    this.tipeForm = '',
    this.kodeNfc = '',
    this.tag = '',
    this.namaService = '',
    this.parameter = '',
    this.idService = '',
    this.kodeEquipment = '',
    this.maxValue = '',
    this.minValue = '',
    this.correctOption = '',
    this.valueOption = '',
    this.textValue = '',
    this.checkBox = 0,
    this.reportedCondition = 0,
    this.reportedImage = '',
    this.reportedImage2 = '',
    this.reportedRequest = '',
    this.reportedDescription = '',
    this.to = '',
    this.selectedTo = '',
    this.controlTf = '',
    this.step = '',
    this.shift = '',
    this.shipName = '',
    this.description = '',
    this.amount = 0.0, //not
    //unloading
    this.editable = true, //not
     this.isSync = false, //not
    this.isContinue = true, //continue for step 2 on unloading
    this.fiA1Amount = 0.0, //not
    this.fiB1Amount = 0.0, //not
    this.fiB2Amount = 0.0, //not
    this.estUnloadingB1MinA = 0.0, //not
    this.estUnloadingB2MinA = 0.0, //not
    this.estUnloadingB2MinB1 = 0.0, //not
  });

  factory Service.fromJson(dynamic json) => Service(
        unit: json['unit'] ?? '',
        tipeForm: json['tipe_form'] ?? 'max',
        kodeNfc: json['kode_nfc'] ?? '',
        editable: json['editable'] ?? false,
        tag: json['tag'] ?? '',
        namaService: json['nama_service'] ?? '',
        idService: json['id_service'] ?? '',
        kodeEquipment: json['kode_equipment'] ?? '',
        parameter: json['parameter'] ?? '',
        correctOption: json['correct_option'] ?? '',
        valueOption: json['value_option'] ?? '',
        minValue: json['min_value'] ?? '',
        maxValue: json['max_value'] ?? '',
        textValue: json['text_value'] ?? '',
        checkBox: json['checkbox'] ?? 0,
        reportedCondition: json['reported_condition'] ?? 0,
        reportedImage: json['reported_image'] ?? '',
        reportedImage2: json['reported_image_2'] ?? '',
        reportedRequest: json['reported_request'] ?? '',
        reportedDescription: json['reported_description'] ?? '',
        step: json['steps'] ?? '',
        shift: json['shift'] ?? '',
        to: json['to'] ?? '',
        description: json['description'] ?? '',
        selectedTo: json['selected_to'] ?? '',
        controlTf: json['control_tf'] ?? '',
        shipName: json['ship_name'] ?? '',
        amount: json['amount'] ?? 0.0,
        fiA1Amount: json['a1_amount'] ?? 0.0,
        fiB1Amount: json['b1_amount'] ?? 0.0,
        fiB2Amount: json['b2_amount'] ?? 0.0,
        estUnloadingB1MinA: json['est_unloading_b1_a'] ?? 0.0,
        estUnloadingB2MinA: json['est_unloading_b2_a'] ?? 0.0,
        estUnloadingB2MinB1: json['est_unloading_b2_b1'] ?? 0.0,
        isContinue: json['isContinue'] ?? true,
        isSync: json['isSync'] ?? false,
      );

  final String unit;
  final String tipeForm;
  final String kodeNfc;
  final String tag;
  final String namaService;
  final String idService;
  final String kodeEquipment;
  final String maxValue;
  final String minValue;
  final String correctOption;
  final String valueOption;
  final String textValue;
  final String parameter;
  final int checkBox;
  final String reportedImage;
  final String reportedImage2;
  final int reportedCondition;
  final String reportedRequest;
  final String reportedDescription;
  final String step, shift;
  final String to, selectedTo, controlTf;
  final String shipName, description;
  //special job
  final bool editable, isContinue,isSync;
  final double amount;
  final double fiA1Amount;
  final double fiB1Amount;
  final double fiB2Amount;
  final double estUnloadingB1MinA; //b1-A
  final double estUnloadingB2MinB1; //b2-b1
  final double estUnloadingB2MinA; //b2-A
  Service copyWith({
    bool? isSync,
    bool? editable,
    bool? isContinue,
    String? unit,
    String? tipeForm,
    String? kodeNfc,
    String? tag,
    String? namaService,
    String? idService,
    String? kodeEquipment,
    String? parameter,
    String? maxValue,
    String? minValue,
    String? correctOption,
    String? valueOption,
    String? textValue,
    int? checkBox,
    String? reportedImage,
    String? reportedImage2,
    int? reportedCondition,
    String? reportedRequest,
    String? description,
    String? reportedDescription,
    String? step,
    String? shift,
    String? to,
    String? controlTf,
    String? selectedTo,
    String? shipName,
    double? amount,
    double? fiA1Amount, //not
    double? fiB1Amount, //not
    double? fiB2Amount, //not
    double? estUnloadingB1MinA, //not
    double? estUnloadingB2MinA, //not
    double? estUnloadingB2MinB1, //not
  }) =>
      Service(
        unit: unit ?? this.unit,
        // tipeForm: tipeForm ?? this.tipeForm,
        tipeForm:
            tipeForm == null && this.tipeForm != null ? this.tipeForm : 'max',
        kodeNfc: kodeNfc ?? this.kodeNfc,
        tag: tag ?? this.tag,
        namaService: namaService ?? this.namaService,
        idService: idService ?? this.idService,
        kodeEquipment: kodeEquipment ?? this.kodeEquipment,
        parameter: parameter ?? this.parameter,
        maxValue: maxValue ?? this.maxValue,
        minValue: minValue ?? this.minValue,
        correctOption: correctOption ?? this.correctOption,
        valueOption: valueOption ?? this.valueOption,
        textValue: textValue ?? this.textValue,
        checkBox: checkBox ?? this.checkBox,
        reportedRequest: reportedRequest ?? this.reportedRequest,
        reportedImage: reportedImage ?? this.reportedImage,
        reportedImage2: reportedImage2 ?? this.reportedImage2,
        reportedCondition: reportedCondition ?? this.reportedCondition,
        reportedDescription: reportedDescription ?? this.reportedDescription,
        step: step ?? this.step,
        shift: shift ?? this.shift,
        to: to ?? this.to,
        description: description ?? this.description,
        selectedTo: selectedTo ?? this.selectedTo,
        controlTf: controlTf ?? this.controlTf,
        shipName: shipName ?? this.shipName,
        amount: amount ?? this.amount,
        fiA1Amount: fiA1Amount ?? this.fiA1Amount,
        fiB1Amount: fiB1Amount ?? this.fiB1Amount,
        fiB2Amount: fiB2Amount ?? this.fiB2Amount,
        editable: editable ?? this.editable,
        isSync: isSync ?? this.isSync,
        isContinue: isContinue ?? this.isContinue,
        estUnloadingB1MinA: estUnloadingB1MinA ?? this.estUnloadingB1MinA,
        estUnloadingB2MinA: estUnloadingB2MinA ?? this.estUnloadingB2MinA,
        estUnloadingB2MinB1: estUnloadingB2MinB1 ?? this.estUnloadingB2MinB1,
      );

  Map<String, dynamic> toJson() {

    final map = <String, dynamic>{};

    map['unit'] = unit.replaceAll('�', '');
    map['tipe_form'] = tipeForm;
    map['kode_nfc'] = kodeNfc;
    map['tag'] = tag;
    map['nama_service'] = namaService;
    map['id_service'] = idService;
    map['kode_equipment'] = kodeEquipment;
    map['parameter'] = parameter;
    map['max_value'] = maxValue;
    map['min_value'] = minValue;
    map['value_option'] = valueOption;
    map['correct_option'] = correctOption;
    map['text_value'] = textValue;
    map['checkbox'] = checkBox;
    map['reported_condition'] = reportedCondition;
    map['reported_image'] = reportedImage;
    map['reported_image_2'] = reportedImage2;
    map['reported_request'] = reportedRequest;
    map['reported_description'] = reportedDescription;
    map['steps'] = step;
    map['to'] = to;
    map['shift'] = shift;
    map['control_tf'] = controlTf;
    map['selected_to'] = selectedTo;
    map['ship_name'] = shipName;
    map['editable'] = editable;
    map['isSync'] = isSync;
    map['is_continue'] = isContinue;
    map['amount'] = amount;
    map['description'] = description;
    map['a1_amount'] = fiA1Amount;
    map['b1_amount'] = fiB1Amount;
    map['b2_amount'] = fiB2Amount;
    map['est_unloading_b1_a'] = estUnloadingB1MinA;
    map['est_unloading_b2_a'] = estUnloadingB2MinA;
    map['est_unloading_b2_b1'] = estUnloadingB2MinB1;
    return map;
  }

  @override
  List<Object> get props => [
        unit,
        isSync,
        tipeForm,
        isContinue,
        kodeNfc,
        tag,
        parameter,
        namaService,
        idService,
        kodeEquipment,
        maxValue,
        editable,
        minValue,
        correctOption,
        valueOption,
        textValue,
        checkBox,
        description,
        reportedCondition,
        reportedImage,
        reportedImage2,
        reportedRequest,
        reportedDescription,
        step,
        shift,
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
      ];
}

extension ServiceExtension on Service {
  FormType formType() => FormType.values.firstWhere((e) => e.type == tipeForm);

  String getRange() => minValue.isEmpty
      ? 'max $maxValue'
      : maxValue.isEmpty
          ? 'min $minValue'
          : 'min $minValue ~ max $maxValue';

  bool continueStep2() => estUnloadingB1MinA < 0;
  bool isEditableStep1() => fiA1Amount > 0;
  bool isEditableStep2() => fiB1Amount > 0;
  bool disableStep2() =>
      isEditableStep2() &&
      isContinue; // jika editable true dan iscontinue true maka disable
  bool isEditableStep3() =>
      estUnloadingB2MinB1 == 0 && fiB2Amount == 0; //must return false
  List<String> getValueOptions() => valueOption.split(',');

  List<String> getCorrectOptions() => correctOption.split(',');

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

  bool specialJobValidated() {
    if (textValue.isEmpty) {
      return false;
    }
    return true;
  }

  bool isValidated() {
    if (textValue.isEmpty) {
      return false;
    }

    if (formType() == FormType.options) {
      if (textValue.isNotEmpty &&
          !correctOption.contains(textValue) &&
          (textValue.toUpperCase() == "STOP" ||
              textValue.toUpperCase() == "SKIP")) {
        if (textValue == 'STOP' && reportedCondition == 0) {
          return true;
        }

        if ((textValue.toUpperCase() == "STOP" ||
                textValue.toUpperCase() == "SKIP") &&
            (reportedCondition == 1 || reportedCondition == 2) &&
            reportedDescription.isEmpty) {
          return false;
        }

        if ((textValue.toUpperCase() == "STOP" ||
                textValue.toUpperCase() == "SKIP") &&
            (reportedCondition == 1 || reportedCondition == 2)) {
          return false;
        }

        if ((textValue.toUpperCase() == "STOP" ||
                textValue.toUpperCase() == "SKIP") &&
            reportedCondition == 2 &&
            reportedRequest.isEmpty) {
          return false;
        }
      }
    } else {
      if ((textValue.toUpperCase() == "STOP" ||
              textValue.toUpperCase() == "SKIP") &&
          checkBox == 1) {
        return true;
      }
    }

    if ((textValue.toUpperCase() == "ND") && reportedCondition == 0) {
      return false;
    }
    if (textValue.toUpperCase() == "SKIP" && reportedCondition == 0) {
      return true;
    }
    if ((textValue.toUpperCase() == "ND" ||
            textValue.toUpperCase() == "SKIP") &&
        (reportedCondition == 1 || reportedCondition == 2) &&
        reportedDescription.isEmpty) {
      return false;
    }

    if ((textValue.toUpperCase() == "ND" ||
            textValue.toUpperCase() == "SKIP") &&
        (reportedCondition == 1 || reportedCondition == 2)) {
      return true;
    }

    if ((textValue.toUpperCase() == "ND" ||
            textValue.toUpperCase() == "SKIP") &&
        reportedCondition == 2 &&
        reportedRequest.isEmpty) {
      return false;
    }

    if ((textValue.toUpperCase() == "ND" ||
            textValue.toUpperCase() == "SKIP") &&
        reportedCondition == 1 &&
        reportedDescription.isNotEmpty &&
        reportedImage.isNotEmpty) {
      return true;
    }

    if ((textValue.toUpperCase() == "ND" ||
            textValue.toUpperCase() == "SKIP") &&
        reportedCondition == 2 &&
        reportedDescription.isNotEmpty &&
        reportedRequest.isNotEmpty &&
        reportedImage.isNotEmpty) {
      return true;
    }

    if (formType() == FormType.range) {
      if (minValue.isNotEmpty && maxValue.isNotEmpty) {
        if ((AppUtil.isNumeric(textValue) &&
                (num.tryParse(textValue) ?? 0) <
                    (num.tryParse(minValue) ?? 0)) ||
            (num.tryParse(textValue) ?? 0) > (num.tryParse(maxValue) ?? 0)) {
          if (reportedCondition == 1 &&
              reportedDescription.isNotEmpty &&
              (reportedImage.isNotEmpty || reportedImage2.isNotEmpty)) {
            return true;
          } else if (reportedCondition == 2 &&
              reportedDescription.isNotEmpty &&
              reportedRequest.isNotEmpty &&
              reportedImage.isNotEmpty) {
            return true;
          } else {
            return false;
          }
        } else {
          return true;
        }
      }
    } else if (formType() == FormType.max) {
      if (maxValue.isNotEmpty &&
          AppUtil.isNumeric(textValue) &&
          (num.tryParse(textValue) ?? 0) > (num.tryParse(maxValue) ?? 0)) {
        if (reportedCondition == 1 &&
            reportedDescription.isNotEmpty &&
            reportedImage.isNotEmpty) {
          return true;
        } else if (reportedCondition == 2 &&
            reportedDescription.isNotEmpty &&
            reportedRequest.isNotEmpty &&
            reportedImage.isNotEmpty) {
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    } else if (formType() == FormType.min) {
      if (minValue.isNotEmpty &&
          AppUtil.isNumeric(textValue) &&
          (num.tryParse(textValue) ?? 0) < (num.tryParse(minValue) ?? 0)) {
        if (reportedCondition == 1 &&
            reportedDescription.isNotEmpty &&
            reportedImage.isNotEmpty) {
          return true;
        } else if (reportedCondition == 2 &&
            reportedDescription.isNotEmpty &&
            reportedRequest.isNotEmpty &&
            reportedImage.isNotEmpty) {
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    } else if (formType() == FormType.options) {
      if (textValue.isNotEmpty && (correctOption.toLowerCase().contains(textValue.toLowerCase()))) {
        return true;
      } else if (textValue.isNotEmpty && !correctOption.toLowerCase().contains(textValue) && textValue.toUpperCase() == "STOP") {
        if (textValue == 'STOP' && reportedCondition == 0) {
          return false;
        }

        if (textValue == 'STOP' &&
            (reportedCondition == 1 || reportedCondition == 2) &&
            reportedDescription.isEmpty) {
          return false;
        }

        if (textValue == 'STOP' &&
            (reportedCondition == 1 || reportedCondition == 2)) {
          return false;
        }

        if (textValue == 'STOP' &&
            reportedCondition == 2 &&
            reportedRequest.isEmpty) {
          return false;
        }
      }
    }
    return true;
  }

  bool isWarning() {
    if (textValue == 'ND') {
      return true;
    }

    if (formType() == FormType.range) {
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
    } else if (formType() == FormType.max) {
      if (maxValue.isNotEmpty &&
          AppUtil.isNumeric(textValue) &&
          (num.tryParse(textValue) ?? 0) > (num.tryParse(maxValue) ?? 0)) {
        return true;
      } else {
        return false;
      }
    } else if (formType() == FormType.min) {
      if (minValue.isNotEmpty &&
          AppUtil.isNumeric(textValue) &&
          (num.tryParse(textValue) ?? 0) < (num.tryParse(minValue) ?? 0)) {
        return true;
      } else {
        return false;
      }
    } else if (formType() == FormType.options) {
      //false adalah tidak warning
      if (textValue.isNotEmpty && (correctOption.toLowerCase().contains(textValue.toLowerCase()))) {
        return false;
      } else {
         if (textValue.contains("STOP") || textValue.contains("SKIP")) {
          return false;
        }
        return true;
      }
    }
    return false;
  }
}
