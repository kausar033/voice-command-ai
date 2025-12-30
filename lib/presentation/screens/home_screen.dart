import 'package:flutter/material.dart';
import 'package:flutter_ai/core/services/stt_service.dart';
import 'package:flutter_ai/core/services/tts_service.dart';
import 'package:flutter_ai/core/services/notification_service.dart';
import 'package:flutter_ai/injection_container.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Services
  final SttService _sttService = sl<SttService>();
  final NotificationService _notificationService = sl<NotificationService>();
  final TextEditingController _textController = TextEditingController();

  // State
  bool _isListening = false;

  // Colors from design
  static const Color _primary = Color(0xFF13ec5b);
  static const Color _backgroundLight = Color(0xFFf6f8f6);
  static const Color _surfaceLight = Color(0xFFffffff);
  static const Color _textMain = Color(0xFF111813);
  static const Color _textSub = Color(0xFF61896f);

  @override
  void initState() {
    super.initState();
    _textController.text =
        "I'd like a cappuccino with oat milk, extra hot please.";
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _toggleListening() async {
    if (!_isListening) {
      bool available = await _sttService.init();
      if (available) {
        setState(() => _isListening = true);
        _textController.clear(); // Clear previous text when starting new listen
        _sttService.listen(
          onResult: (val) {
            setState(() {
              _textController.text = val;
            });
          },
          localeId: "en_US",
        );
      }
    } else {
      setState(() => _isListening = false);
      _sttService.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      _buildVoiceInputSection(),
                      _buildtranscriptionArea(),
                      const SizedBox(height: 24),
                      _buildPlaceOrderButton(),
                      const SizedBox(height: 32),
                      _buildRecentActivity(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: _surfaceLight,
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(50),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.arrow_back, color: _textMain, size: 24),
              ),
            ),
          ),
          Text(
            "New Order",
            style: GoogleFonts.inter(
              color: _textMain,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
              image: const DecorationImage(
                image: NetworkImage(
                  "https://lh3.googleusercontent.com/aida-public/AB6AXuD5HaGqbPper0Rpzm5tdaLe67VZISmFOqnCu4WmaJIA-nKBTtNql_MSxVaOiIY4T9GL2nKd_Z7BAXoxYYzL0FRuPNYkPFBseQVfF9O75Q8lUbW2BmrMu7zLhuwTg7OxfLMOWz7rK9-EUfMYPkm_UsFpIlCfIEvyBboPnw8ymuCCNfPRPFf7i8Oyx3TzIJEUBIUI-5iCXHVacLkmU5u0-nhH42JxOHbaLZeFWpXmTCEAmv1uSY48_ihuAVXT_4kMtLsUOIF_JIMy4Io",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceInputSection() {
    return Column(
      children: [
        const SizedBox(height: 24),
        Text(
          "What would you like?",
          style: GoogleFonts.inter(
            color: _textMain,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 32),
        AvatarGlow(
          animate: _isListening,
          glowColor: _primary,
          duration: const Duration(milliseconds: 2000),
          repeat: true,
          child: GestureDetector(
            onTap: _toggleListening,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: _primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _primary.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(Icons.mic, color: _textMain, size: 48),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          _isListening ? "Listening..." : "Tap to speak",
          style: GoogleFonts.inter(
            color: _textSub,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildtranscriptionArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            "Your Order",
            style: GoogleFonts.inter(
              color: _textSub,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: _surfaceLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2),
            ],
          ),
          child: Stack(
            children: [
              TextField(
                controller: _textController,
                maxLines: null,
                minLines: 4,
                style: GoogleFonts.inter(
                  color: _textMain,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                  hintText: "Listening...",
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: IconButton(
                  onPressed: () => _textController.clear(),
                  icon: const Icon(Icons.backspace, color: _textSub),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceOrderButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          _notificationService.showNotification(
            id: 0,
            title: 'Order Sent',
            body: 'Your order has been sent to the Office Assistant',
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _primary,
          foregroundColor: _textMain,
          elevation: 4,
          shadowColor: _primary.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Place Order",
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Recent Activity",
              style: GoogleFonts.inter(
                color: _textMain,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "View All",
                style: GoogleFonts.inter(
                  color: Colors
                      .green, // Fallback if primary is too bright for text
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildActivityItem(
          icon: Icons.coffee,
          title: "Double Espresso",
          time: "Today, 10:00 AM",
          status: "Pending",
          statusColor: Colors.orange,
          iconBgColor: Colors.orange.shade50,
          statusBgColor: Colors.orange.shade50,
        ),
        const SizedBox(height: 12),
        _buildActivityItem(
          icon: Icons.local_cafe,
          title: "Green Tea",
          time: "Yesterday",
          status: "Received",
          statusColor: Colors.green,
          iconBgColor: Colors.green.shade50,
          statusBgColor: _primary.withOpacity(0.1),
          isDone: true,
        ),
      ],
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String time,
    required String status,
    required Color statusColor,
    required Color iconBgColor,
    required Color statusBgColor,
    bool isDone = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surfaceLight,
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
                  title,
                  style: GoogleFonts.inter(
                    color: _textMain,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: GoogleFonts.inter(color: _textSub, fontSize: 12),
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
                  status,
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
}
