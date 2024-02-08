class Transaksi {
  int? id;
  int type, total;
  String name, createdAt, updatedAt;

  Transaksi({
    this.id,
    required this.type,
    required this.total,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  String toString() {
    return 'Transaksi{name: $name, type: $type, total: $total, createdAt: $createdAt, updatedAt: $updatedAt}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'total': total,
      'name': name,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory Transaksi.fromMap(Map<String, dynamic> map) {
    return Transaksi(
      id: map['id'],
      type: map['type'],
      total: map['total'],
      name: map['name'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }
}
