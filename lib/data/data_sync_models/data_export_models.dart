import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'transaction.dart';


class DataExportModels extends Equatable {

  final List<TransactionDataSync>? transactions;
  const DataExportModels(this.transactions);

  factory DataExportModels.fromMap(Map<String, dynamic> data) {
    return DataExportModels(
        (data as List<dynamic>?)?.map((e) => TransactionDataSync.fromMap(e as Map<String, dynamic>)).toList()
    );
  }

  List<dynamic>? toMap() => transactions?.map((e) => e.toMap()).toList();

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [DataSyncModels].
  factory DataExportModels.fromJson(String data) {
    return DataExportModels.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [DataSyncModels] to a JSON string.
  String toJson() => json.encode(toMap());

  DataExportModels copyWith(List<TransactionDataSync>? transactions) {
    return DataExportModels(transactions ?? this.transactions);
  }

  @override
  List<Object?> get props => [transactions];
}
