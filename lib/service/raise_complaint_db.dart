import 'dart:io';
import 'package:field_star_customer_app/model/raise_complaint_model.dart';
import 'package:field_star_customer_app/model/service_rating_model.dart';
import 'package:field_star_customer_app/model/tech_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RaiseComplaintDb {
  final _supabase = Supabase.instance.client;

  //=====================Submit complaint=============================
Future<void> submitFullComplaint(RaiseComplaintModel model) async {
  try {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    await _supabase.from('customer').upsert({
      'id': user.id,            
      'cust_name': model.customerName,
      'cust_phno': model.customerPhone,
      'cust_location': model.customerLocation,
      'cust_place': model.customerPlace,
      'cust_hotelname': model.customerHotelName,
    });

    final data = model.toMap();
    data['customer_id'] = user.id;

    await _supabase.from('Raise_complaint').insert(data);

  } catch (e) {
    throw Exception('Failed to insert: $e');
  }
}
  //============================fetch complaint============================================
 Future<List<RaiseComplaintModel>> Fetchcomplaints() async {
  try {
    final user = _supabase.auth.currentUser;

    if (user == null) throw Exception('User not logged in');

    final response = await _supabase
        .from('Raise_complaint')
        .select()
        .eq('customer_id', user.id)         
        .order('created_at', ascending: false);

    return (response as List)
        .map((item) => RaiseComplaintModel.fromMap(item))
        .toList();
  } catch (e) {
    throw Exception('Failed to fetch: $e');
  }

  
}

Future<List<RaiseComplaintModel>> fetchCompletedComplaints() async {
  final userId = Supabase.instance.client.auth.currentUser?.id;
  
  final response = await Supabase.instance.client
      .from('Raise_complaint')
      .select()
      .eq('customer_id', userId!)
      .eq('complaint_status', 'Completed');

  return (response as List)
      .map((e) => RaiseComplaintModel.fromMap(e))
      .toList();
}

//==================Upload Images===================================
    Future<String?> uploadImage(File imageFile) async {
    try {
      final fileName = '${DateTime.now().microsecondsSinceEpoch}.jpg';
      final path = 'uploads/$fileName';

      await _supabase.storage
          .from('images')
          .upload(path, imageFile);

      final url = _supabase.storage
          .from('images')
          .getPublicUrl(path);

      return url;
    } catch (e) {
      throw Exception('Image upload failed: $e');
    }
  }

  //====================== Upload audio ===================================
  Future<String?> uploadAudio(String audioFilePath) async {
    try {
      final fileName = '${DateTime.now().microsecondsSinceEpoch}.wav';
      final path = 'uploads/$fileName';
      final audioFile = File(audioFilePath);

      await _supabase.storage
          .from('complaint-audio')
          .upload(path, audioFile);

      final url = _supabase.storage
          .from('complaint-audio')
          .getPublicUrl(path);

      return url;
    } catch (e) {
      throw Exception('Audio upload failed: $e');
    }
  }
//=================================FetchComplaints by ID================================
  Future<RaiseComplaintModel?> fetchComplaintByTicketId(String ticketId) async {
  final response = await _supabase
      .from('Raise_complaint')
      .select()
      .eq('tickectid', ticketId)
      .maybeSingle();

  if (response == null) return null;

  return RaiseComplaintModel.fromMap(response);
}

  // =============================Fetch rating by ticket ID ========================================
  Future<ServiceRatingModel?> fetchRatingByTicketId(String ticketId) async {
    final response = await _supabase
        .from('service_ratings')
        .select()
        .eq('ticket_id', ticketId)
        .maybeSingle();

    if (response == null) return null;
    return ServiceRatingModel.fromJson(response);
  }

  //======================Save Rating==========================
  Future<void> submitRating(ServiceRatingModel model) async {
  await Supabase.instance.client
      .from('service_ratings')
      .insert(model.toMap());
 await Supabase.instance.client
      .from('Raise_complaint') 
      .update({'complaint_status': 'Completed'})
      .eq('tickectid', model.ticketId);
}

  }
