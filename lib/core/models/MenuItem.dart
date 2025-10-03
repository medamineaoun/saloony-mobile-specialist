// ==================== APPOINTMENT MODEL ====================
class Appointment {
  final String id;
  final String clientName;
  final String clientImage;
  final String date;
  final String time;
  final int servicesCount;
  final double price;

  Appointment({
    required this.id,
    required this.clientName,
    required this.clientImage,
    required this.date,
    required this.time,
    required this.servicesCount,
    required this.price,
  });

  Appointment copyWith({
    String? id,
    String? clientName,
    String? clientImage,
    String? date,
    String? time,
    int? servicesCount,
    double? price,
  }) {
    return Appointment(
      id: id ?? this.id,
      clientName: clientName ?? this.clientName,
      clientImage: clientImage ?? this.clientImage,
      date: date ?? this.date,
      time: time ?? this.time,
      servicesCount: servicesCount ?? this.servicesCount,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientName': clientName,
      'clientImage': clientImage,
      'date': date,
      'time': time,
      'servicesCount': servicesCount,
      'price': price,
    };
  }

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as String,
      clientName: json['clientName'] as String,
      clientImage: json['clientImage'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      servicesCount: json['servicesCount'] as int,
      price: (json['price'] as num).toDouble(),
    );
  }
}

// ==================== MESSAGE MODEL ====================
class Message {
  final String id;
  final String senderName;
  final String senderImage;
  final String content;
  final String time;
  final int unreadCount;

  Message({
    required this.id,
    required this.senderName,
    required this.senderImage,
    required this.content,
    required this.time,
    required this.unreadCount,
  });

  Message copyWith({
    String? id,
    String? senderName,
    String? senderImage,
    String? content,
    String? time,
    int? unreadCount,
  }) {
    return Message(
      id: id ?? this.id,
      senderName: senderName ?? this.senderName,
      senderImage: senderImage ?? this.senderImage,
      content: content ?? this.content,
      time: time ?? this.time,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderName': senderName,
      'senderImage': senderImage,
      'content': content,
      'time': time,
      'unreadCount': unreadCount,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      senderName: json['senderName'] as String,
      senderImage: json['senderImage'] as String,
      content: json['content'] as String,
      time: json['time'] as String,
      unreadCount: json['unreadCount'] as int,
    );
  }
}

// ==================== PENDING REQUEST MODEL ====================
class PendingRequest {
  final String id;
  final String clientName;
  final String clientImage;
  final double price;
  final int servicesCount;
  final String date;
  final String time;
  final String timeUntil;

  PendingRequest({
    required this.id,
    required this.clientName,
    required this.clientImage,
    required this.price,
    required this.servicesCount,
    required this.date,
    required this.time,
    required this.timeUntil,
  });

  PendingRequest copyWith({
    String? id,
    String? clientName,
    String? clientImage,
    double? price,
    int? servicesCount,
    String? date,
    String? time,
    String? timeUntil,
  }) {
    return PendingRequest(
      id: id ?? this.id,
      clientName: clientName ?? this.clientName,
      clientImage: clientImage ?? this.clientImage,
      price: price ?? this.price,
      servicesCount: servicesCount ?? this.servicesCount,
      date: date ?? this.date,
      time: time ?? this.time,
      timeUntil: timeUntil ?? this.timeUntil,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientName': clientName,
      'clientImage': clientImage,
      'price': price,
      'servicesCount': servicesCount,
      'date': date,
      'time': time,
      'timeUntil': timeUntil,
    };
  }

  factory PendingRequest.fromJson(Map<String, dynamic> json) {
    return PendingRequest(
      id: json['id'] as String,
      clientName: json['clientName'] as String,
      clientImage: json['clientImage'] as String,
      price: (json['price'] as num).toDouble(),
      servicesCount: json['servicesCount'] as int,
      date: json['date'] as String,
      time: json['time'] as String,
      timeUntil: json['timeUntil'] as String,
    );
  }
}

// ==================== BENEFITS SUMMARY MODEL ====================
class BenefitsSummary {
  final double total;
  final int percentageChange;
  final String period;

  BenefitsSummary({
    required this.total,
    required this.percentageChange,
    required this.period,
  });

  BenefitsSummary copyWith({
    double? total,
    int? percentageChange,
    String? period,
  }) {
    return BenefitsSummary(
      total: total ?? this.total,
      percentageChange: percentageChange ?? this.percentageChange,
      period: period ?? this.period,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'percentageChange': percentageChange,
      'period': period,
    };
  }

  factory BenefitsSummary.fromJson(Map<String, dynamic> json) {
    return BenefitsSummary(
      total: (json['total'] as num).toDouble(),
      percentageChange: json['percentageChange'] as int,
      period: json['period'] as String,
    );
  }
}