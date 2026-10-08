// ignore_for_file: public_member_api_docs, sort_constructors_first
class Connection {
  final int id;
  final String name;
  final String commentary;
  final int intervalInDays;
  final DateTime lastContactedDate;

  Connection({
    required this.id,
    required this.name,
    this.commentary = '',
    required this.intervalInDays,
    required this.lastContactedDate,
  });

  Map<String, dynamic> toMap({bool includeId = true}) {
    final map = {
      'name': name,
      'details': commentary,
      'intervalInDays': intervalInDays,
      'lastContactedDate': lastContactedDate.millisecondsSinceEpoch,
    };

    if (includeId && id != 0) {
      map['id'] = id;
    }

    return map;
  }

  factory Connection.fromMap(Map<String, dynamic> map) {
    return Connection(
      id: map['id'],
      name: map['name'],
      commentary: map['details'],
      intervalInDays: map['intervalInDays'],
      lastContactedDate:
          DateTime.fromMillisecondsSinceEpoch(map['lastContactedDate']),
    );
  }

  Connection copyWith({
    int? id,
    String? name,
    String? commentary,
    int? intervalInDays,
    DateTime? lastContactedDate,
  }) {
    return Connection(
      id: id ?? this.id,
      name: name ?? this.name,
      commentary: commentary ?? this.commentary,
      intervalInDays: intervalInDays ?? this.intervalInDays,
      lastContactedDate: lastContactedDate ?? this.lastContactedDate,
    );
  }

  @override
  bool operator ==(covariant Connection other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.commentary == commentary &&
        other.intervalInDays == intervalInDays &&
        other.lastContactedDate == lastContactedDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        commentary.hashCode ^
        intervalInDays.hashCode ^
        lastContactedDate.hashCode;
  }
}
