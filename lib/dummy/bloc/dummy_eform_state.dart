part of 'dummy_eform_bloc.dart';

abstract class DummyEformState extends Equatable {
  const DummyEformState(
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
      // this.nfcIsAvailable = false,
      this.steps = '',
      this.currentStep = 0
  });

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
  final String steps, tglPatrol;
  final int currentStep;
  final List<Cpl> cpls;
  final List<Cpl> cplsByArea;
  final List<Equipment> equipments;
  final List<Equipment> equipmentsByCpl;
  final List<Equipment> equipmentsByNfc;
  final List<Service> services;
  final List<Service> servicesBySearch; //untuk eform manual search
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
  
  @override
  List<Object> get props => [];
}

class DummyEformInitial extends DummyEformState {}
