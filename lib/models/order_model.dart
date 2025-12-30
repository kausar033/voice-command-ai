enum OrderStatus { pending, received }

class OrderModel {
  final String id;
  final String item;
  final DateTime timestamp;
  final OrderStatus status;

  OrderModel({
    required this.id,
    required this.item,
    required this.timestamp,
    required this.status,
  });
}
