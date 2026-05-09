class RunModel {
  final String id;
  final String userId;
  final DateTime date;
  final double distanceKm;
  final int durationMinutes;

  const RunModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.distanceKm,
    required this.durationMinutes,
  });

  double get pace => distanceKm > 0 ? durationMinutes / distanceKm : 0;

  int get calories => (distanceKm * 62).round();

  String get paceFormatted {
    if (distanceKm <= 0) return '-';
    final p = pace;
    final mins = p.floor();
    final secs = ((p - mins) * 60).round();
    return "$mins'${secs.toString().padLeft(2, '0')}\"";
  }

  String get durationFormatted {
    final h = durationMinutes ~/ 60;
    final m = durationMinutes % 60;
    if (h > 0) return '${h}j ${m}m';
    return '${m}m';
  }

  String get distanceFormatted => '${distanceKm.toStringAsFixed(1)} km';

  RunModel copyWith({
    DateTime? date,
    double? distanceKm,
    int? durationMinutes,
  }) =>
      RunModel(
        id: id,
        userId: userId,
        date: date ?? this.date,
        distanceKm: distanceKm ?? this.distanceKm,
        durationMinutes: durationMinutes ?? this.durationMinutes,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'date': date.toIso8601String(),
        'distanceKm': distanceKm,
        'durationMinutes': durationMinutes,
      };

  factory RunModel.fromJson(Map<String, dynamic> json) => RunModel(
        id: json['id'] as String,
        userId: json['userId'] as String,
        date: DateTime.parse(json['date'] as String),
        distanceKm: (json['distanceKm'] as num).toDouble(),
        durationMinutes: json['durationMinutes'] as int,
      );
}
