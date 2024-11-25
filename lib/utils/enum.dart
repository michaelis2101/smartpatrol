enum EFormStatus { initial, loading, empty, failure, loaded, login }

enum EFormType { standard, autonomous, special }

enum FormType {
  min(1, "min"),
  max(2, "max"),
  range(3, "range"),
  options(4, "options");

  final int id;
  final String type;

  const FormType(this.id, this.type);
}

enum SpecialJobType {newTrx,continueTrx,finishTrx}
