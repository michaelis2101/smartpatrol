class HistoryModel {
  const HistoryModel(
      {required this.cplName,
      required this.equipmentName,
      required this.equipmentCode,
      required this.cplCode,
      required this.opName,
      required this.dateCreated,
      required this.shift,
      required this.template,
      required this.uuid,
      required this.isSync,
      this.finishJob = false,
      this.toSelected = '',
      this.shipName = '',
      this.control = '',
      this.amount ='',
      required this.tipeCpl,
      required this.warning});

  final String cplName,
      cplCode,
      equipmentName,
      equipmentCode,
      opName,
      amount,
      shipName,
      template,
      dateCreated,
      uuid,
      shift,
      tipeCpl,toSelected,control;
  final int warning, isSync;
  final bool finishJob;
}
