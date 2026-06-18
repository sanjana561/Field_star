import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RateServicePage extends StatefulWidget {
  const RateServicePage({super.key});

  @override
  State<RateServicePage> createState() => _RateServicePageState();
}

class _RateServicePageState extends State<RateServicePage> {
  int rating = 1;

  final List<String> tags = [
    "Quick Response",
    "Professional",
    "Problem Solved",
    "Friendly",
    "On Time",
    "Clean Work",
    "Fair Pricing",
    "Good Communication",
  ];

  final List<int> _selectedTags = [];

  String get _ratingLabel {
    switch (rating) {
      case 1: return 'Poor';
      case 2: return 'Fair';
      case 3: return 'Good';
      case 4: return 'Great';
      case 5: return 'Excellent';
      default: return '';
    }
  }

  Color get _ratingColor {
    switch (rating) {
      case 1: return const Color(0xFFEF4444);
      case 2: return const Color(0xFFF97316);
      case 3: return const Color(0xFFF59E0B);
      case 4: return const Color(0xFF22C55E);
      case 5: return const Color(0xFF10B981);
      default: return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(14, 22, 14, 100),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 25,
                backgroundColor: Color(0xFFFFF1E6),
                child: Icon(
                  Icons.thumb_up_alt_outlined,
                  color: Colors.deepOrange,
                  size: 28,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                "Rate Your Experience",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              const Text(
                "How was your service with Rajesh Kumar?",
                style: TextStyle(fontSize: 13, color: Colors.blueGrey),
              ),

              const SizedBox(height: 42),

              const Text(
                "Tap to rate",
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final selected = index < rating;
                  return GestureDetector(
                    onTap: () => setState(() => rating = index + 1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        selected ? Icons.star_rounded : Icons.star_outline_rounded,
                        color: selected ? Colors.deepOrange : const Color(0xFFD1D5DB),
                        size: 40,
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 8),

              // label that changes with rating
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  _ratingLabel,
                  key: ValueKey(rating),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _ratingColor,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "What did you like?",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 10,
                  children: List.generate(tags.length, (i) {
                    final picked = _selectedTags.contains(i);
                    return GestureDetector(
                      onTap: () => setState(() {
                        picked ? _selectedTags.remove(i) : _selectedTags.add(i);
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: picked ? const Color(0xFFFFF1E6) : Colors.white,
                          border: Border.all(
                            color: picked ? Colors.deepOrange : const Color(0xFFE5E7EB),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          tags[i],
                          style: TextStyle(
                            fontSize: 12,
                            color: picked ? Colors.deepOrange : const Color(0xFF475569),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 28),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Additional Comments (Optional)",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Share more details about your experience...",
                  hintStyle: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 13,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.deepOrange),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Service Summary",
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 14),
                    _SummaryRow(label: "Ticket ID:", value: "TCK-2451"),
                    _SummaryRow(label: "Equipment:", value: "Commercial Deep Fryer"),
                    _SummaryRow(label: "Technician:", value: "Rajesh Kumar"),
                    _SummaryRow(label: "Service Date:", value: "May 25, 2026"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(14),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => context.go('/finalpage'),
                child: const Text("Skip", style: TextStyle(color: Colors.blueGrey)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () => context.go('/finalpage'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                child: const Text(
                  "Submit Rating",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}