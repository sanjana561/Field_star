class RaiseComplaintModel {
  final int? id;
  final String categoryName;
  final String? serviceRequired;
  final String? problem;
  final String? priorityLevel;
  final DateTime? date;
  final String tickectid;
  final String otp;
  final String? imageUrl;
  final String? audioUrl;
  final String? complaintStatus;
  final String? technicianName;
  final String? customerId;
  final String? customerName;
  final String? customerPhone;
  final String? customerLocation;
  final String? customerPlace;
  final String? customerHotelName;

  RaiseComplaintModel({
    this.id,
    required this.categoryName,
    this.serviceRequired,
    this.problem,
    this.priorityLevel,
    this.date,
    required this.tickectid,
    required this.otp,
    this.imageUrl,
    this.audioUrl,
    this.complaintStatus,
    this.technicianName,
    this.customerId,
    this.customerName,
    this.customerPhone,
    this.customerLocation,
    this.customerPlace,
    this.customerHotelName,
  });

  factory RaiseComplaintModel.fromMap(Map<String, dynamic> map) {
    return RaiseComplaintModel(
      id: map['id'],
      categoryName: map['Category_name'] ?? '',
      serviceRequired: map['service_required'],
      problem: map['problem'],
      priorityLevel: map['priority_level'],
      date: map['Date'] != null ? DateTime.parse(map['Date']) : null,
      tickectid: map['tickectid'] ?? '',
      otp: map['otp'] ?? '',
      imageUrl: map['image_url'],
      audioUrl: map['audio_url'],
      complaintStatus: map['complaint_status'],
      technicianName: map['technician_name'],
      customerId: map['customer_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Category_name': categoryName,
      'service_required': serviceRequired,
      'problem': problem,
      'priority_level': priorityLevel,
      'Date': date?.toIso8601String(),
      'tickectid': tickectid,
      'otp': otp,
      'image_url': imageUrl,
      'audio_url': audioUrl,
      'tech_status': complaintStatus,
      'technician_name': technicianName,
      'customer_id': customerId,
    };
  }
}