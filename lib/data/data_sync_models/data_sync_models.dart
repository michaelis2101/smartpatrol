import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'transaction.dart';
import 'user.dart';

class DataSyncModels extends Equatable {
  final User? user;
  final List<TransactionDataSync>? transactions;
  const DataSyncModels({this.user, this.transactions});

  factory DataSyncModels.fromMap(Map<String, dynamic> data) {
    return DataSyncModels(
      user: data['user'] == null
          ? null
          : User.fromMap(data['user'] as Map<String, dynamic>),
      transactions: (data['transactions'] as List<dynamic>?)
          ?.map((e) => TransactionDataSync.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'user': user?.toMap(),
        'transactions': transactions?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [DataSyncModels].
  factory DataSyncModels.fromJson(String data) {
    return DataSyncModels.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [DataSyncModels] to a JSON string.
  String toJson() => json.encode(toMap());

  DataSyncModels copyWith({
    User? user,
    List<TransactionDataSync>? transactions,
  }) {
    return DataSyncModels(
      user: user ?? this.user,
      transactions: transactions ?? this.transactions,
    );
  }

  @override
  List<Object?> get props => [user, transactions];
}
