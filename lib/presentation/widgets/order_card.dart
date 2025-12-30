import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_ai/models/order_model.dart';
import 'package:intl/intl.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isDone = order.status == OrderStatus.received;
    final statusColor = isDone ? Colors.green : Colors.orange;
    final statusBgColor = isDone
        ? const Color(0xFF13ec5b).withOpacity(0.1)
        : Colors.orange.shade50;
    final iconBgColor = isDone ? Colors.green.shade50 : Colors.orange.shade50;
    final statusText = isDone ? "Received" : "Pending";
    final icon = isDone ? Icons.emoji_food_beverage : Icons.coffee;

    // Relative time logic or formatted date
    final timeStr = _formatDate(order.timestamp);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: statusColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.item,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF111813),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  timeStr,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF61896f),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusBgColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                if (!isDone)
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                if (isDone)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Icon(Icons.done_all, size: 16, color: statusColor),
                  ),
                Text(
                  statusText,
                  style: GoogleFonts.inter(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    if (DateUtils.isSameDay(date, DateTime.now())) {
      return "Today, ${DateFormat('h:mm a').format(date)}";
    } else if (DateUtils.isSameDay(
      date,
      DateTime.now().subtract(const Duration(days: 1)),
    )) {
      return "Yesterday, ${DateFormat('h:mm a').format(date)}";
    }
    return DateFormat('MMM d, h:mm a').format(date);
  }
}
