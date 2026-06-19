class ServiceRatingModel {
  final String? id;
  final String ticketId;
  final String technicianId;
  final String technicianName;
  final String equipment;
  final String serviceDate;
  final int rating;
  final String ratingLabel;
  final List<String> selectedTags;
  final String? comments;
  final DateTime? createdAt;

  ServiceRatingModel({
    this.id,
    required this.ticketId,
    required this.technicianId,
    required this.technicianName,
    required this.equipment,
    required this.serviceDate,
    required this.rating,
    required this.ratingLabel,
    required this.selectedTags,
    this.comments,
    this.createdAt,
  });

  // Convert to JSON for Supabase insert
  Map<String, dynamic> toJson() {
    return {
      'ticket_id': ticketId,
      'technician_id': technicianId,
      'technician_name': technicianName,
      'equipment': equipment,
      'service_date': serviceDate,
      'rating': rating,
      'rating_label': ratingLabel,
      'selected_tags': selectedTags,
      'comments': comments ?? '',
    };
  }

  // Convert from Supabase response
  factory ServiceRatingModel.fromJson(Map<String, dynamic> json) {
    return ServiceRatingModel(
      id: json['id'],
      ticketId: json['ticket_id'],
      technicianId: json['technician_id'],
      technicianName: json['technician_name'],
      equipment: json['equipment'],
      serviceDate: json['service_date'],
      rating: json['rating'],
      ratingLabel: json['rating_label'],
      selectedTags: List<String>.from(json['selected_tags'] ?? []),
      comments: json['comments'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }
}