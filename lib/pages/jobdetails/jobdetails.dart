import 'package:field_star_customer_app/model/raise_complaint_model.dart';
import 'package:field_star_customer_app/model/tech_model.dart';
import 'package:field_star_customer_app/model/timeline.dart';
import 'package:field_star_customer_app/service/raise_complaint_db.dart';
import 'package:field_star_customer_app/service/techdetais_db.dart';
import 'package:field_star_customer_app/share.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timelines_plus/timelines_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class Jobdetails extends StatefulWidget {
  final String ticketId;

  const Jobdetails({super.key, required this.ticketId});

  @override
  State<Jobdetails> createState() => _JobdetailsState();
}

class _JobdetailsState extends State<Jobdetails> {
  TechModel? _techDetails;
  RaiseComplaintModel? _complaint;
  final repo = RaiseComplaintDb();
  final techdb = TechdetaisDb();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final tech = await techdb.fetchTechDetails(widget.ticketId);
    final complaint = await repo.fetchComplaintByTicketId(widget.ticketId);
    setState(() {
      _techDetails = tech;
      _complaint = complaint;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            context.go('/Home');
          },
        ),

        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Track Complaint',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
//===================Fetch techid and complaint status==================
           FutureBuilder<List<dynamic>>(
  future: Future.wait([
    techdb.fetchTechDetails(widget.ticketId),
    repo.fetchComplaintByTicketId(widget.ticketId),
  ]),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!snapshot.hasData) {
      return const Center(child: Text('Technician not assigned'));
    }

    final techDetails = snapshot.data![0] as TechModel?;
    final complaint = snapshot.data![1] as RaiseComplaintModel?;

    if (techDetails == null) {
      return const Center(child: Text('Technician not assigned'));
    }

    final status = complaint?.complaintStatus ?? 'Pending';

    // ✅ Color based on status
    Color statusColor;
    Color statusBgColor;
    switch (status) {
      case 'Completed':
        statusColor = Colors.green;
        statusBgColor = Colors.green.shade100;
        break;
      case 'In Progress':
        statusColor = Colors.deepPurple;
        statusBgColor = Colors.deepPurple.shade100;
        break;
      case 'Assigned':
        statusColor = Colors.blue;
        statusBgColor = Colors.blue.shade100;
        break;
      default:
        statusColor = Colors.orange;
        statusBgColor = Colors.orange.shade100;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Technician ID: ${techDetails.techId}',
          style: const TextStyle(color: Colors.black54, fontSize: 12),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: statusBgColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  },
),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
//=========================Fetch technician details============================
                FutureBuilder<TechModel?>(
                  future: techdb.fetchTechDetails(widget.ticketId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data == null) {
                      return const Center(
                        child: Text('Technician not assigned'),
                      );
                    }

                    final techDetails = snapshot.data!;
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.deepOrange,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 15,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 30,
                            child: Icon(
                              Icons.person,
                              size: 25,
                              color: Colors.deepOrange,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                techDetails.fullName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                'Technician ID: ${techDetails.techId}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 15),
                              Text(
                                techDetails.phone,
                                style: const TextStyle(color: Colors.white),
                              ),
  //======================Button call & message====================================
                              SizedBox(height: 15),
                              Row(
                                spacing: 15,
                                children: [
                                  ElevatedButton(
                                    onPressed: () =>
                                        _makeCall(techDetails.phone),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepOrange
                                          .withOpacity(0.5),
                                    ),
                                    child: Row(
                                      spacing: 10,
                                      children: [
                                        Icon(Icons.phone, color: Colors.white),
                                        Text(
                                          'Call',
                                          style: TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        _sendSms(techDetails.phone),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepOrange
                                          .withOpacity(0.5),
                                    ),
                                    child: Row(
                                      spacing: 10,
                                      children: [
                                        Icon(
                                          Icons.message,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          'SMS',
                                          style: TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),

  //===========================Track service completion===============================
                SizedBox(height: 20),
                FutureBuilder<RaiseComplaintModel?>(
                  future: repo.fetchComplaintByTicketId(widget.ticketId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (_complaint == null) {
                          setState(() => _complaint = snapshot.data);
                        }
                      });
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data == null) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text('No complaints found'),
                        ),
                      );
                    }

                    final complaint = snapshot.data!;

                    final timelineItems = getTimelineItems(
                      complaint.complaintStatus ?? '',
                    );

                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Service Timeline",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 16),

                          FixedTimeline.tileBuilder(
                            theme: TimelineThemeData(
                              nodePosition: 0,
                              connectorTheme: const ConnectorThemeData(
                                thickness: 2,
                              ),
                              indicatorTheme: const IndicatorThemeData(
                                size: 26,
                              ),
                            ),
                            builder: TimelineTileBuilder.connected(
                              itemCount: timelineItems.length,
                              connectionDirection: ConnectionDirection.before,
                              connectorBuilder: (_, index, __) {
                                return SolidLineConnector(
                                  color: timelineItems[index].completed
                                      ? const Color(0xFF10B981)
                                      : Colors.grey.shade300,
                                );
                              },
                              indicatorBuilder: (_, index) {
                                final item = timelineItems[index];

                                return DotIndicator(
                                  color: item.completed
                                      ? const Color(0xFF10B981)
                                      : Colors.grey.shade300,
                                  child: item.completed
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 16,
                                        )
                                      : null,
                                );
                              },
                              contentsBuilder: (_, index) {
                                final item = timelineItems[index];

                                return Padding(
                                  padding: const EdgeInsets.only(
                                    left: 14,
                                    bottom: 28,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: item.completed
                                              ? Colors.black
                                              : Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item.time,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: item.completed
                                              ? Colors.black54
                                              : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),
//========================= view invoice payment button========================
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_techDetails == null || _complaint == null) return;
                      context.go(
                        '/payment',
                        extra: {
                          'ticketId': widget.ticketId,
                          'technicianId': _techDetails!.techId,
                          'technicianName': _techDetails!.fullName,
                          'equipment': _complaint!.serviceRequired,
                          'serviceDate': _complaint!.date?.toString() ?? '',
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2C313A),
                      elevation: 0,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "View Invoice & Payment",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //===========================Helper function=================================
  List<TimelineItem> getTimelineItems(String status) {
    return [
      TimelineItem(
        title: "Complaint Registered",
        time: "Completed",
        completed: true,
      ),
      TimelineItem(
        title: "Technician Assigned",
        time:
            status == "Assigned" ||
                status == "In Progress" ||
                status == "Completed"
            ? "Completed"
            : "Pending",
        completed:
            status == "Assigned" ||
            status == "In Progress" ||
            status == "Completed",
      ),
      TimelineItem(
        title: "Service in Progress",
        time: status == "Assigned" || status == "Completed"
            ? "Completed"
            : "Pending",
        completed: status == "Assigned" || status == "Completed",
      ),
      TimelineItem(
        title: "Service Completed",
        time: status == "Completed" ? "Completed" : "pending",
        completed: status == "Completed",
      ),
    ];
  }

  //==============================Make a call======================================
  Future<void> _makeCall(String phone) async {
    final Uri uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not open dialer')));
    }
  }

  //=======================Send message=================================
  Future<void> _sendSms(String phone) async {
    final Uri uri = Uri(scheme: 'sms', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not open SMS app')));
    }
  }
}
