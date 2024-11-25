part of 'eform_bloc.dart';

class EFormState extends Equatable {
  const EFormState(
      {this.status = EFormStatus.initial,
      this.section = const [],
      this.sectionByFormat = const [],
      this.formats = const [],
      this.areas = const [],
      this.areasBySection = const [],
      this.cpls = const [],
      this.kodeSection = '',
      this.kodeArea = '',
      this.kodeCpl = '',
      this.kodeNfc = '',
      this.tglPatrol = '',
      this.kodeEquipment = '',
      this.cplsByArea = const [],
      this.equipments = const [],
      this.equipmentsByCpl = const [],
      this.equipmentsByNfc = const [],
      this.services = const [],
      this.servicesByStep = const [],
      this.servicesBySearch = const [],
      this.servicesByEquipment = const [],
      this.autonomousService = const [],
      this.autonomousCpl = const [],
      this.autonomousEquipment = const [],
      this.specialJobCpl = const [],
      this.specialJobForm = const [],
      this.specialJobPosition = const [],
      this.transactions = const TransactionModel(transactions: []),
      this.transactionsSpecialJob = const TransactionModel(transactions: []),
      this.transactionsHistoryManual = const TransactionModel(transactions: []),
      this.transactionsHistorySpecial = const TransactionModel(transactions: []),
      this.nfcIsAvailable = false,
      this.steps = '',
      this.currentStep = 0});

  final EFormStatus status;
  final List<Section> section;
  final List<Section> sectionByFormat;
  final List<Formats> formats;
  final List<Area> areas, areasBySection;
  final String kodeSection;
  final String kodeArea;
  final String kodeCpl;
  final String kodeNfc;
  final String kodeEquipment;
  final String steps,tglPatrol;
  final int currentStep;
  final List<Cpl> cpls;
  final List<Cpl> cplsByArea;
  final List<Equipment> equipments;
  final List<Equipment> equipmentsByCpl;
  final List<Equipment> equipmentsByNfc;
  final List<Service> services;
  final List<Service> servicesBySearch;//untuk eform manual search
  final List<Service> servicesByEquipment;
  final List<Service> servicesByStep;
  final List<Equipment> autonomousEquipment;
  final List<Service> autonomousService;
  final List<Cpl> autonomousCpl;
  final List<Cpl> specialJobCpl;
  final List<Position> specialJobPosition;
  final List<SpecialJob> specialJobForm;
  final TransactionModel transactions;
  final TransactionModel transactionsSpecialJob;
  final TransactionModel transactionsHistoryManual;
  final TransactionModel transactionsHistorySpecial;

  final bool nfcIsAvailable;

  EFormState copyWith(
      {EFormStatus? status,
      List<Section>? section,
      List<Section>? sectionByFormat,
      List<Formats>? formats,
      List<Area>? areas,
      List<Area>? areasBySection,
      String? kodeArea,
      String? kodeSection,
      String? kodeCpl,
      String? kodeNfc,
      String? tglPatrol,
      String? kodeEquipment,
      List<Cpl>? cpls,
      List<Cpl>? cplsByArea,
      List<Equipment>? equipments,
      List<Equipment>? equipmentsByCpl,
      List<Equipment>? equipmentsByNfc,
      List<Service>? services,
      List<Service>? servicesByEquipment,
      List<Service>? servicesBySearch,
      List<Service>? servicesByStep,
      List<Equipment>? autonomousEquipment,
      List<Service>? autonomousService,
      List<Cpl>? autonomousCpl,
      List<Cpl>? specialJobCpl,
      List<Position>? specialJobPosition,
      List<SpecialJob>? specialJobForm,
      TransactionModel? transactions,
      TransactionModel? transactionsSpecialJob,transactionsHistorySpecial,transactionsHistoryManual,
      bool? nfcIsAvailable,
      String? steps,
      int? currentStep}) {
    return EFormState(
      status: status ?? this.status,
      formats: formats ?? this.formats,
      tglPatrol: tglPatrol ?? this.tglPatrol,
      section: section ?? this.section,
      sectionByFormat: sectionByFormat ?? this.sectionByFormat,
      areas: areas ?? this.areas,
      cpls: cpls ?? this.cpls,
      kodeSection: kodeSection ?? this.kodeSection,
      kodeArea: kodeArea ?? this.kodeArea,
      kodeCpl: kodeCpl ?? this.kodeCpl,
      kodeNfc: kodeNfc ?? this.kodeNfc,
      kodeEquipment: kodeEquipment ?? this.kodeEquipment,
      cplsByArea: cplsByArea ?? this.cplsByArea,
      equipments: equipments ?? this.equipments,
      equipmentsByCpl: equipmentsByCpl ?? this.equipmentsByCpl,
      equipmentsByNfc: equipmentsByNfc ?? this.equipmentsByNfc,
      services: services ?? this.services,
      servicesBySearch: servicesBySearch ?? this.servicesBySearch,
      servicesByEquipment: servicesByEquipment ?? this.servicesByEquipment,
      servicesByStep: servicesByStep ?? this.servicesByStep,
      autonomousCpl: autonomousCpl ?? this.autonomousCpl,
      autonomousEquipment: autonomousEquipment ?? this.autonomousEquipment,
      autonomousService: autonomousService ?? this.autonomousService,
      specialJobCpl: specialJobCpl ?? this.specialJobCpl,
      specialJobPosition: specialJobPosition ?? this.specialJobPosition,
      specialJobForm: specialJobForm ?? this.specialJobForm,
      transactions: transactions ?? this.transactions,
      transactionsSpecialJob: transactionsSpecialJob ?? this.transactionsSpecialJob,
      transactionsHistoryManual: transactionsHistoryManual ?? this.transactionsHistoryManual,
      transactionsHistorySpecial: transactionsHistorySpecial ?? this.transactionsHistorySpecial,
      nfcIsAvailable: nfcIsAvailable ?? this.nfcIsAvailable,
      steps: steps ?? this.steps,
      currentStep: currentStep ?? this.currentStep,
      areasBySection: areasBySection ?? this.areasBySection,
    );
  }

  @override
  List<Object?> get props => [
        status,
        section,
        tglPatrol,
        sectionByFormat,
        formats,
        areas,
        areasBySection,
        kodeSection,
        kodeArea,
        kodeCpl,
        kodeNfc,
        kodeEquipment,
        cpls,
        cplsByArea,
        equipments,
        equipmentsByCpl,
        equipmentsByNfc,
        services,
        servicesByEquipment,
        servicesByStep,
        servicesBySearch,
        autonomousCpl,
        autonomousEquipment,
        autonomousService,
        specialJobForm,
        specialJobPosition,
        specialJobCpl,
        nfcIsAvailable,
        transactions,
        transactionsSpecialJob,
        transactionsHistorySpecial,transactionsHistoryManual,
        steps,
        currentStep
      ];
}
