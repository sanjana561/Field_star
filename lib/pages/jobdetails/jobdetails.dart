import 'package:field_star_customer_app/model/raise_complaint_model.dart';
import 'package:field_star_customer_app/model/tech_model.dart';
import 'package:field_star_customer_app/model/timeline.dart';
import 'package:field_star_customer_app/service/raise_complaint_db.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timelines_plus/timelines_plus.dart';

class Jobdetails extends StatefulWidget {
  final String ticketId;
  const Jobdetails({super.key, required this.ticketId});

  @override
  State<Jobdetails> createState() => _JobdetailsState();
}

class _JobdetailsState extends State<Jobdetails> {
  final repo = RaiseComplaintDb();

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
            FutureBuilder<TechModel?>(
              future: repo.fetchTechDetails(widget.ticketId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text('Technician not assigned'));
                }

                final techDetails = snapshot.data!;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Technician ID: ${techDetails.techId}',
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'In Progress',
                        style: const TextStyle(
                          color: Colors.deepPurple,
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
                FutureBuilder<TechModel?>(
                  future: repo.fetchTechDetails(widget.ticketId),
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
                              //======================Button call & message======================
                              SizedBox(height: 15),
                              Row(
                                spacing: 15,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {

                                    },
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
                                    onPressed: () {

                                    },
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

                //===========================2nd Container===============================
                SizedBox(height: 20),
                FutureBuilder<RaiseComplaintModel?>(
                  future: repo.fetchComplaintByTicketId(widget.ticketId),
                  builder: (context, snapshot) {
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
                      complaint.complaintStatus ?? 'Pending',
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

                //======================Activity Item==========================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Recent Activity",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Activity 1
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Technician has accepted the service request",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  "10:22 AM",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      //==================== Activity =============================
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Complaint registered successfully",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  "10:15 AM",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      context.go('/payment'
                      ,extra: widget.ticketId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2C313A),
                      elevation: 0,
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
        time: status == "In Progress" || status == "Completed"
            ? "Completed"
            : "Pending",
        completed: status == "In Progress" || status == "Completed",
      ),
      TimelineItem(
        title: "Service Completed",
        time: status == "Completed" ? "Completed" : "Pending",
        completed: status == "Completed",
      ),
    ];
  }
}
