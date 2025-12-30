import 'package:flutter/material.dart';
import 'package:flutter_ai/models/order_model.dart';
import 'package:flutter_ai/presentation/widgets/order_card.dart';
import 'package:google_fonts/google_fonts.dart';

class AllOrdersScreen extends StatelessWidget {
  final List<OrderModel> orders;

  const AllOrdersScreen({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6f8f6),
      appBar: AppBar(
        title: Text(
          "Order History",
          style: GoogleFonts.inter(
            color: const Color(0xFF111813),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF111813)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          // Sort or assume sorted? Home screen will probably pass them sorted (newest first).
          // But just in case, we display as is.
          return OrderCard(order: orders[index]);
        },
      ),
    );
  }
}
