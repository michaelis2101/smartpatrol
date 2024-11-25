import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:smart_patrol/data/data_sync_models/transaction_special.dart';
import 'user.dart';

class DataSyncModelsSpecial extends Equatable {
  final User? user;
  final List<TransactionDataSyncSpecial>? transactions;
  const DataSyncModelsSpecial({this.user, this.transactions});

  factory DataSyncModelsSpecial.fromMap(Map<String, dynamic> data) {
    return DataSyncModelsSpecial(
      user: data['user'] == null
          ? null
          : User.fromMap(data['user'] as Map<String, dynamic>),
      transactions: (data['transactions'] as List<dynamic>?)
          ?.map((e) => TransactionDataSyncSpecial.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'user': user?.toMap(),
        'transactions': transactions?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [DataSyncModelsSpecial].
  factory DataSyncModelsSpecial.fromJson(String data) {
    return DataSyncModelsSpecial.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [DataSyncModelsSpecial] to a JSON string.
  String toJson() => json.encode(toMap());

  DataSyncModelsSpecial copyWith({
    User? user,
    List<TransactionDataSyncSpecial>? transactions,
  }) {
    return DataSyncModelsSpecial(
      user: user ?? this.user,
      transactions: transactions ?? this.transactions,
    );
  }

  @override
  List<Object?> get props => [user, transactions];
}
