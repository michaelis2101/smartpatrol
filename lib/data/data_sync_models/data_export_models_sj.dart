import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:smart_patrol/data/data_sync_models/transaction_special.dart';

class DataExportModelsSpecial extends Equatable {
  final List<TransactionDataSyncSpecial>? transactions;
  const DataExportModelsSpecial(this.transactions);

  factory DataExportModelsSpecial.fromMap(Map<String, dynamic> data) {
    return DataExportModelsSpecial(
        (data as List<dynamic>?)?.map((e) => TransactionDataSyncSpecial.fromMap(e as Map<String, dynamic>)).toList()
    );
  }

  List<dynamic>? toMap() => transactions?.map((e) => e!.toMap()).toList();


  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [DataSyncModelsSpecial].
  factory DataExportModelsSpecial.fromJson(String data) {
    return DataExportModelsSpecial.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [DataSyncModelsSpecial] to a JSON string.
  String toJson() => json.encode(toMap());

  DataExportModelsSpecial copyWith(List<TransactionDataSyncSpecial>? transactions) {
    return DataExportModelsSpecial(transactions ?? this.transactions);
  }

  @override
  List<Object?> get props => [transactions];
}
