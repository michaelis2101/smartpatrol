import 'dart:convert';

import 'package:equatable/equatable.dart';

class TransactionDataSync extends Equatable {
  final String? areaCode;
  final String? areaName;
  final String? documentCode;
  final String? documentName;
  final String? equipmentCode;
  final String? equipmentName;
  final String? idService;
  final String? serviceName;
  final String? parameter;
  final String? tag;
  final String? date;
  final String? formType;
  final String? minValue;
  final String? maxValue;
  final String? correctOption;
  final String? unit;
  final String? nfcCode;
  final String? userNik;
  final String? userName;
  final String? department;
  final String? shift;
  final String? input;
  final String? description;
  final String? foto, foto2;
  final String? status;
  final String? formatType;
  final String? steps;
  final String? to;
  final String? template;

  //special

  const TransactionDataSync(
      {
        this.template,
        this.areaCode,
      this.areaName,
      this.documentCode,
      this.documentName,
      this.equipmentCode,
      this.equipmentName,
      this.idService,
      this.serviceName,
      this.parameter,
      this.tag,
      this.date,
      this.formType,
      this.minValue,
      this.maxValue,
      this.correctOption,
      this.unit,
      this.nfcCode,
      this.userNik,
      this.userName,
      this.department,
      this.shift,
      this.input,
      this.description,
      this.foto,
      this.foto2,
      this.status,
      this.formatType,
      this.steps,
      this.to});

  factory TransactionDataSync.fromMap(Map<String, dynamic> data) =>
      TransactionDataSync(
        template: data['template'] as String?,
        areaCode: data['area_code'] as String?,
        areaName: data['area_name'] as String?,
        documentCode: data['document_code'] as String?,
        documentName: data['document_name'] as String?,
        equipmentCode: data['equipment_code'] as String?,
        equipmentName: data['equipment_name'] as String?,
        idService: data['id_service'] as String?,
        serviceName: data['service_name'] as String?,
        parameter: data['parameter'] as String?,
        tag: data['tag'] as String?,
        date: data['date'] as String?,
        formType: data['form_type'] as String?,
        minValue: data['min_value'] as String?,
        maxValue: data['max_value'] as String?,
        correctOption: data['correct_option'] as String?,
        unit: data['unit'] as String?,
        nfcCode: data['nfc_code'] as String?,
        userNik: data['user_nik'] as String?,
        userName: data['user_name'] as String?,
        department: data['department'] as String?,
        shift: data['shift'] as String?,
        input: data['input'] as String?,
        description: data['description'] as String?,
        foto: data['foto'] as String?,
        foto2: data['foto_2'] as String?,
        status: data['status'] as String?,
        formatType: data['format_type'] as String?,
        steps: data['step'] as String?,
        to: data['to'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'area_code': areaCode,
        'area_name': areaName,
        'document_code': documentCode,
        'document_name': documentName,
        'equipment_code': equipmentCode,
        'equipment_name': equipmentName,
        'id_service': idService,
        'service_name': serviceName,
        'parameter': parameter,
        'tag': tag,
        'date': date,
        'form_type': formType,
        'min_value': minValue,
        'max_value': maxValue,
        'correct_option': correctOption,
        'unit': unit,
        'nfc_code': nfcCode,
        'user_nik': userNik,
        'user_name': userName,
        'department': department,
        'shift': shift,
        'input': input,
        'description': description,
        'foto': foto,
        'foto_2': foto2,
        'status': status,
        'format_type': formatType,
        'step': steps,
        'to': to,
      };

  factory TransactionDataSync.fromJson(String data) {
    return TransactionDataSync.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  factory TransactionDataSync.fromJsonExport(dynamic data) =>
      TransactionDataSync(
        template: data['template'] as String?,
        areaCode: data['area_code'] as String?,
        areaName: data['area_name'] as String?,
        documentCode: data['document_code'] as String?,
        documentName: data['document_name'] as String?,
        equipmentCode: data['equipment_code'] as String?,
        equipmentName: data['equipment_name'] as String?,
        idService: data['id_service'] as String?,
        serviceName: data['service_name'] as String?,
        parameter: data['parameter'] as String?,
        tag: data['tag'] as String?,
        date: data['date'] as String?,
        formType: data['form_type'] as String?,
        minValue: data['min_value'] as String?,
        maxValue: data['max_value'] as String?,
        correctOption: data['correct_option'] as String?,
        unit: data['unit'] as String?,
        nfcCode: data['nfc_code'] as String?,
        userNik: data['user_nik'] as String?,
        userName: data['user_name'] as String?,
        department: data['department'] as String?,
        shift: data['shift'] as String?,
        input: data['input'] as String?,
        description: data['description'] as String?,
        foto: data['foto'] as String?,
        foto2: data['foto_2'] as String?,
        status: data['status'] as String?,
        formatType: data['format_type'] as String?,
        steps: data['step'] as String?,
        to: data['to'] as String?,
      );

  String toJson() => json.encode(toMap());

  TransactionDataSync copyWith({
    String? template,
    String? areaCode,
    String? areaName,
    String? documentCode,
    String? documentName,
    String? equipmentCode,
    String? equipmentName,
    String? idService,
    String? serviceName,
    String? parameter,
    String? tag,
    String? date,
    String? formType,
    String? minValue,
    String? maxValue,
    String? correctOption,
    String? unit,
    String? nfcCode,
    String? userNik,
    String? userName,
    String? department,
    String? shift,
    String? input,
    String? description,
    String? foto,
    String? foto2,
    String? status,
    String? formatType,
    String? steps,
    String? to,
  }) {
    return TransactionDataSync(
      template: template ?? this.template,
      areaCode: areaCode ?? this.areaCode,
      areaName: areaName ?? this.areaName,
      documentCode: documentCode ?? this.documentCode,
      documentName: documentName ?? this.documentName,
      equipmentCode: equipmentCode ?? this.equipmentCode,
      equipmentName: equipmentName ?? this.equipmentName,
      idService: idService ?? this.idService,
      serviceName: serviceName ?? this.serviceName,
      parameter: parameter ?? this.parameter,
      tag: tag ?? this.tag,
      date: date ?? this.date,
      formType: formType ?? this.formType,
      minValue: minValue ?? this.minValue,
      maxValue: maxValue ?? this.maxValue,
      correctOption: correctOption ?? this.correctOption,
      unit: unit ?? this.unit,
      nfcCode: nfcCode ?? this.nfcCode,
      userNik: userNik ?? this.userNik,
      userName: userName ?? this.userName,
      department: department ?? this.department,
      shift: shift ?? this.shift,
      input: input ?? this.input,
      description: description ?? this.description,
      foto: foto ?? this.foto,
      foto2: foto2 ?? this.foto2,
      status: status ?? this.status,
      formatType: formatType ?? this.formatType,
      steps: steps ?? this.steps,
      to: steps ?? this.to,
    );
  }

  @override
  List<Object?> get props {
    return [
      template,
      areaCode,
      areaName,
      documentCode,
      documentName,
      equipmentCode,
      equipmentName,
      idService,
      serviceName,
      parameter,
      tag,
      date,
      formType,
      minValue,
      maxValue,
      correctOption,
      unit,
      nfcCode,
      userNik,
      userName,
      department,
      shift,
      input,
      description,
      foto,
      foto2,
      status,
      formatType,
      steps,
      to,
    ];
  }
}

class TransactionSpecialDataSync extends Equatable {
  final String? areaCode;
  final String? areaName;
  final String? documentCode;
  final String? documentName;
  final String? equipmentCode;
  final String? equipmentName;
  final String? idService;
  final String? serviceName;
  final String? parameter;
  final String? tag;
  final String? date;
  final String? formType;
  final String? minValue;
  final String? maxValue;
  final String? correctOption;
  final String? unit;
  final String? nfcCode;
  final String? userNik;
  final String? userName;
  final String? department;
  final String? shift;
  final String? input;
  final String? description;
  final String? foto, foto2;
  final String? status;
  final String? formatType;
  final String? steps;
  final String? to;
  final String? shipName;
  final String? amount;
  final String? a1Amount;
  final String? b1Amount;
  final String? b2Amount;
  final String? estUnloadingB1A;
  final String? estUnloadingB2A;
  final String? estUnloadingB2B1;
  final String? controlSelected;
  final String? toSelected;

  //special

  const TransactionSpecialDataSync(
      {this.areaCode,
      this.areaName,
      this.documentCode,
      this.documentName,
      this.equipmentCode,
      this.equipmentName,
      this.idService,
      this.serviceName,
      this.parameter,
      this.tag,
      this.date,
      this.formType,
      this.minValue,
      this.maxValue,
      this.correctOption,
      this.unit,
      this.nfcCode,
      this.userNik,
      this.userName,
      this.department,
      this.shift,
      this.input,
      this.description,
      this.foto,
      this.foto2,
      this.status,
      this.formatType,
      this.steps,
      this.to,
      this.shipName,
      this.amount,
      this.a1Amount,
      this.b1Amount,
      this.b2Amount,
      this.estUnloadingB1A,
      this.estUnloadingB2A,
      this.estUnloadingB2B1,
      this.controlSelected,
      this.toSelected});

  factory TransactionSpecialDataSync.fromMap(Map<String, dynamic> data) =>
      TransactionSpecialDataSync(
          areaCode: data['area_code'] as String?,
          areaName: data['area_name'] as String?,
          documentCode: data['document_code'] as String?,
          documentName: data['document_name'] as String?,
          equipmentCode: data['equipment_code'] as String?,
          equipmentName: data['equipment_name'] as String?,
          idService: data['id_service'] as String?,
          serviceName: data['service_name'] as String?,
          parameter: data['parameter'] as String?,
          tag: data['tag'] as String?,
          date: data['date'] as String?,
          formType: data['form_type'] as String?,
          minValue: data['min_value'] as String?,
          maxValue: data['max_value'] as String?,
          correctOption: data['correct_option'] as String?,
          unit: data['unit'] as String?,
          nfcCode: data['nfc_code'] as String?,
          userNik: data['user_nik'] as String?,
          userName: data['user_name'] as String?,
          department: data['department'] as String?,
          shift: data['shift'] as String?,
          input: data['input'] as String?,
          description: data['description'] as String?,
          foto: data['foto'] as String?,
          foto2: data['foto_2'] as String?,
          status: data['status'] as String?,
          formatType: data['format_type'] as String?,
          steps: data['step'] as String?,
          to: data['to'] as String?,
          shipName: data['ship_name'],
          amount: data['amount'],
          a1Amount: data['a1_amount'],
          b1Amount: data['b1_amount'],
          b2Amount: data['b2_amount'],
          estUnloadingB1A: data['est_unloading_b1_a'],
          estUnloadingB2A: data['est_unloading_b2_a'],
          estUnloadingB2B1: data['est_unloading_b2_b1'],
          controlSelected: data['control_selected'],
          toSelected: data['to_selected']);

  Map<String, dynamic> toMap() => {
        'area_code': areaCode,
        'area_name': areaName,
        'document_code': documentCode,
        'document_name': documentName,
        'equipment_code': equipmentCode,
        'equipment_name': equipmentName,
        'id_service': idService,
        'service_name': serviceName,
        'parameter': parameter,
        'tag': tag,
        'date': date,
        'form_type': formType,
        'min_value': minValue,
        'max_value': maxValue,
        'correct_option': correctOption,
        'unit': unit,
        'nfc_code': nfcCode,
        'user_nik': userNik,
        'user_name': userName,
        'department': department,
        'shift': shift,
        'input': input,
        'description': description,
        'foto': foto,
        'foto_2': foto2,
        'status': status,
        'format_type': formatType,
        'step': steps,
        'to': to,
        'ship_name': shipName,
        'amount': amount,
        'a1_amount': a1Amount,
        'b1_amount': b1Amount,
        'b2_amount': b2Amount,
        'est_unloading_b1_a': estUnloadingB1A,
        'est_unloading_b2_a': estUnloadingB2A,
        'est_unloading_b2_b1': estUnloadingB2B1,
        'control_selected': controlSelected,
        'to_selected': toSelected,
      };

  factory TransactionSpecialDataSync.fromJson(String data) {
    return TransactionSpecialDataSync.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  factory TransactionSpecialDataSync.fromJsonExport(dynamic data) =>
      TransactionSpecialDataSync(
        areaCode: data['area_code'] as String?,
        areaName: data['area_name'] as String?,
        documentCode: data['document_code'] as String?,
        documentName: data['document_name'] as String?,
        equipmentCode: data['equipment_code'] as String?,
        equipmentName: data['equipment_name'] as String?,
        idService: data['id_service'] as String?,
        serviceName: data['service_name'] as String?,
        parameter: data['parameter'] as String?,
        tag: data['tag'] as String?,
        date: data['date'] as String?,
        formType: data['form_type'] as String?,
        minValue: data['min_value'] as String?,
        maxValue: data['max_value'] as String?,
        correctOption: data['correct_option'] as String?,
        unit: data['unit'] as String?,
        nfcCode: data['nfc_code'] as String?,
        userNik: data['user_nik'] as String?,
        userName: data['user_name'] as String?,
        department: data['department'] as String?,
        shift: data['shift'] as String?,
        input: data['input'] as String?,
        description: data['description'] as String?,
        foto: data['foto'] as String?,
        foto2: data['foto_2'] as String?,
        status: data['status'] as String?,
        formatType: data['format_type'] as String?,
        steps: data['step'] as String?,
        to: data['to'] as String?,
        shipName: data['ship_name'],
        amount: data['amount'],
        a1Amount: data['a1_amount'],
        b1Amount: data['b1_amount'],
        b2Amount: data['b2_amount'],
        estUnloadingB1A: data['est_unloading_b1_a'],
        estUnloadingB2A: data['est_unloading_b2_a'],
        estUnloadingB2B1: data['est_unloading_b2_b1'],
        controlSelected: data['control_selected'],
        toSelected: data['to_selected'],
      );

  String toJson() => json.encode(toMap());

  TransactionSpecialDataSync copyWith({
    String? areaCode,
    String? areaName,
    String? documentCode,
    String? documentName,
    String? equipmentCode,
    String? equipmentName,
    String? idService,
    String? serviceName,
    String? parameter,
    String? tag,
    String? date,
    String? formType,
    String? minValue,
    String? maxValue,
    String? correctOption,
    String? unit,
    String? nfcCode,
    String? userNik,
    String? userName,
    String? department,
    String? shift,
    String? input,
    String? description,
    String? foto,
    String? foto2,
    String? status,
    String? formatType,
    String? steps,
    String? to,
    String? shipName,
    String? amount,
    String? a1Amount,
    String? b1Amount,
    String? b2Amount,
    String? estUnloadingB1A,
    String? estUnloadingB2A,
    String? estUnloadingB2B1,
    String? controlSelected,
    String? toSelected,
  }) {
    return TransactionSpecialDataSync(
      areaCode: areaCode ?? this.areaCode,
      areaName: areaName ?? this.areaName,
      documentCode: documentCode ?? this.documentCode,
      documentName: documentName ?? this.documentName,
      equipmentCode: equipmentCode ?? this.equipmentCode,
      equipmentName: equipmentName ?? this.equipmentName,
      idService: idService ?? this.idService,
      serviceName: serviceName ?? this.serviceName,
      parameter: parameter ?? this.parameter,
      tag: tag ?? this.tag,
      date: date ?? this.date,
      formType: formType ?? this.formType,
      minValue: minValue ?? this.minValue,
      maxValue: maxValue ?? this.maxValue,
      correctOption: correctOption ?? this.correctOption,
      unit: unit ?? this.unit,
      nfcCode: nfcCode ?? this.nfcCode,
      userNik: userNik ?? this.userNik,
      userName: userName ?? this.userName,
      department: department ?? this.department,
      shift: shift ?? this.shift,
      input: input ?? this.input,
      description: description ?? this.description,
      foto: foto ?? this.foto,
      foto2: foto2 ?? this.foto2,
      status: status ?? this.status,
      formatType: formatType ?? this.formatType,
      steps: steps ?? this.steps,
      to: steps ?? this.to,
      shipName: shipName ?? this.shipName,
      amount: amount ?? this.amount,
      a1Amount: a1Amount ?? this.a1Amount,
      b1Amount: b1Amount ?? this.b1Amount,
      b2Amount: b2Amount ?? this.b2Amount,
      estUnloadingB1A: estUnloadingB1A ?? this.estUnloadingB1A,
      estUnloadingB2A: estUnloadingB2A ?? this.estUnloadingB2A,
      estUnloadingB2B1: estUnloadingB2B1 ?? this.estUnloadingB2B1,
      controlSelected: controlSelected ?? this.controlSelected,
      toSelected: toSelected ?? this.toSelected,
    );
  }

  @override
  List<Object?> get props {
    return [
      areaCode,
      areaName,
      documentCode,
      documentName,
      equipmentCode,
      equipmentName,
      idService,
      serviceName,
      parameter,
      tag,
      date,
      formType,
      minValue,
      maxValue,
      correctOption,
      unit,
      nfcCode,
      userNik,
      userName,
      department,
      shift,
      input,
      description,
      foto,
      foto2,
      status,
      formatType,
      steps,
      to,
      shipName,
      amount,
      a1Amount,
      b1Amount,
      b2Amount,
      estUnloadingB1A,
      estUnloadingB2A,
      estUnloadingB2B1,
      controlSelected,
      toSelected
    ];
  }
}
