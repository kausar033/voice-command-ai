import 'package:flutter/material.dart';
import 'package:flutter_ai/core/services/stt_service.dart';
import 'package:flutter_ai/core/services/notification_service.dart';
import 'package:flutter_ai/core/services/wake_word_service.dart';
import 'package:flutter_ai/injection_container.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_ai/models/order_model.dart';
import 'package:flutter_ai/presentation/widgets/order_card.dart';
import 'package:flutter_ai/presentation/screens/all_orders_screen.dart';
import 'package:porcupine_flutter/porcupine_error.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Services
  final SttService _sttService = sl<SttService>();
  final NotificationService _notificationService = sl<NotificationService>();
  final WakeWordService _wakeWordService = sl<WakeWordService>();
  final TextEditingController _textController = TextEditingController();

  // State
  bool _isListening = false;
  final List<OrderModel> _orders = [];

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
    _initDummyOrders();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await Permission.microphone.request();
    // After permission is handled (or if already granted), start wake word
    _initWakeWord();
  }

  Future<void> _initWakeWord() async {
    try {
      await _wakeWordService.init(() async {
        // Pause wake word listening via service or just toggle
        await _wakeWordService.stopListening();
        if (mounted) {
          _toggleListening();
        }
      });
      // Start listening for wake word immediately
      await _wakeWordService.startListening();
    } on PorcupineActivationLimitException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Wake word limit reached. Try a new AccessKey."),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Wake word error: $e"),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  void _initDummyOrders() {
    _orders.add(
      OrderModel(
        id: '1',
        item: 'Double Espresso',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        status: OrderStatus.pending,
      ),
    );
    _orders.add(
      OrderModel(
        id: '2',
        item: 'Green Tea',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        status: OrderStatus.received,
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _wakeWordService.dispose();
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
      await _stopListening(restartWakeWord: true);
    }
  }

  Future<void> _stopListening({bool restartWakeWord = true}) async {
    setState(() => _isListening = false);
    await _sttService.stop();
    if (restartWakeWord) {
      await _wakeWordService.startListening();
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
          SizedBox(width: 8),
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
            ),
            child: Icon(Icons.person, color: _textMain),
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
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                  hintText: _isListening ? "Listening..." : "Tap to speak",
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
        onPressed: () async {
          await _stopListening(restartWakeWord: true);
          if (_textController.text.trim().isEmpty) return;

          final newOrder = OrderModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            item: _textController.text.trim(),
            timestamp: DateTime.now(),
            status: OrderStatus.pending,
          );

          setState(() {
            _orders.insert(0, newOrder);
            _textController.clear();
          });

          _notificationService.showNotification(
            id: 0,
            title: 'Order Sent',
            body: 'Ordered: ${newOrder.item}',
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllOrdersScreen(orders: _orders),
                  ),
                );
              },
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
        if (_orders.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "No recent orders",
              style: GoogleFonts.inter(color: _textSub),
            ),
          )
        else
          ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _orders.length > 3 ? 3 : _orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return OrderCard(order: _orders[index]);
            },
          ),
      ],
    );
  }
}
