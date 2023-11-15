import 'dart:convert';

OrdersModel ordersFromJson(String str) =>
    OrdersModel.fromJson(json.decode(str));

String OrdersToJson(OrdersModel data) => json.encode(data.toJson());

class OrdersModel {
  int orderId;
  DateTime dateOrdered;
  int orderItemId;
  int supplierUserId;
  DateTime deliveryDate;
  int quantity;
  double pricePerItem;

  OrdersModel({
    required this.orderId,
    required this.dateOrdered,
    required this.orderItemId,
    required this.supplierUserId,
    required this.quantity,
    required this.deliveryDate,
    required this.pricePerItem,
  });

  // Receiving data from external JSON data into what flutter understands
  factory OrdersModel.fromJson(Map<String, dynamic> json) => OrdersModel(
        orderId: json["order_id"],
        dateOrdered: json["date_ordered"],
        orderItemId: json["order_item_id"],
        supplierUserId: json["supplier_user_id"],
        deliveryDate: json["delivery_date"],
        quantity: json["quantity"],
        pricePerItem: json["price_per_item"],
      );
  // Sending data from external JSON data into what flutter understands
  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "date_ordered": dateOrdered,
        "order_item_id": orderItemId,
        "supplier_user_id": supplierUserId,
        "delivery_date": deliveryDate,
        "quantity": quantity,
        "price_per_item": pricePerItem,
      };
}
