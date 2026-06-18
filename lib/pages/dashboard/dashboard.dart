import 'package:field_star_customer_app/component/equipment_card.dart';
import 'package:field_star_customer_app/component/jobsummary.dart';
import 'package:field_star_customer_app/component/recentservice_history.dart';
import 'package:field_star_customer_app/model/raise_complaint_model.dart';
import 'package:field_star_customer_app/pages/Raisecomplaint/raise_complaint.dart';
import 'package:field_star_customer_app/service/raise_complaint_db.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Dashboard extends StatefulWidget {
  final String tickedID;
  final String categoryName;
  final String equipmentName;
  final String problemDescription;
  const Dashboard({
    super.key,
    required this.tickedID,
    required this.categoryName,
    required this.equipmentName,
    required this.problemDescription,
  });

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final repo= RaiseComplaintDb();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //======================Heading===========================================
            const Text(
              'Dashboard',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              //=========================UserName=======================================
              children: [
                Text(
                  'Grand Hyatt, Mumbai',
                  style: TextStyle(color: Colors.black87, fontSize: 12),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.black.withOpacity(0.08),
                  ),
                  child: const Icon(
                    Icons.notifications_active,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  //   Container(height: 200, color: Colors.white70),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
 //========================Raise Complaint button=============================
                        SizedBox(
                          width: 500,
                          child: Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RaiseComplaintPage(
                                      tickedID: widget.tickedID,
                                      categoryName: widget.categoryName,
                                      equipmentName: widget.equipmentName,
                                      problemDescription:
                                          widget.problemDescription,
                                    ),
                                  ),
                                );
                              },
                              style: btnStyle(Colors.deepOrange),
                              child: Row(
                                spacing: 15,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.add, color: Colors.white70),
                                  const Text('Raise New Compaint'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              //=====================================jobsummary card==============================
              SizedBox(height: 20),
              Text(
                'Active complaints',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              FutureBuilder<List<RaiseComplaintModel>>(
                future:repo.Fetchcomplaints(),
                builder:(context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Error
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  // Empty
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text('No complaints found'),
                      ),
                    );
                  }
                   final complaints = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: complaints.length,
                    itemBuilder: (context, index) {
                      final c = complaints[index];
                      return JobSummaryCard(
                        ticketId: 'TCK-${c.tickectid ?? index}',
                        status: c.priorityLevel ?? 'Pending',
                        equipment: c.serviceRequired ?? '',
                        issue: c.problem ?? '',
                        technician: c.technicianName ?? '',                    
                        onTap: () => context.go('/jobdescription',
                        extra: c.tickectid),
                      );
                    },

              );
             
                },
              ),
                
              SizedBox(height: 15),
              Text(
                'Your Equipment',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              //============================Equipment card==============================
              Row(
                children: [
                  Expanded(
                    child: EquipmentCard(
                      title: 'Commercial Deep Fryer',
                      model: 'Pitco SE14',
                      location: 'Main Kitchen',
                      lastService: '2026-04-10',
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: EquipmentCard(
                      title: 'Commercial Deep Fryer',
                      model: 'Pitco SE14',
                      location: 'Main Kitchen',
                      lastService: '2026-04-10',
                    ),
                  ),
                ],
              ),
              //========================Recent service==============================
              const SizedBox(height: 15),
              Row(
                children: [
                  const Icon(Icons.history, size: 18, color: Colors.black87),
                  const SizedBox(width: 6),
                  const Text(
                    'Recent Service History',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                children: [
                  RecentServiceHistoryCard(
                    equipmentName: "Conveyor Dishwasher",
                    ticketId: "TCK-2442",
                    serviceDate: "2026-05-20",
                  ),
                  RecentServiceHistoryCard(
                    equipmentName: "Industrial Oven",
                    ticketId: "TCK-2435",
                    serviceDate: "2026-05-15",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ButtonStyle btnStyle(Color color) => ElevatedButton.styleFrom(
    backgroundColor: color,
    foregroundColor: Colors.white,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );
}
