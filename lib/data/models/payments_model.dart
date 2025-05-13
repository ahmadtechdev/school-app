// payment_model.dart
class PaymentModel {
  final bool success;
  final Student student;
  final List<Invoice> invoices;
  final int totalPaidInvoices;
  final int totalPendingInvoices;
  final int totalPartialpaidInvoices;

  PaymentModel({
    required this.success,
    required this.student,
    required this.invoices,
    required this.totalPaidInvoices,
    required this.totalPendingInvoices,
    required this.totalPartialpaidInvoices,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      success: json['success'] ?? false,
      student: Student.fromJson(json['student']),
      invoices: (json['invoices'] as List)
          .map((invoice) => Invoice.fromJson(invoice))
          .toList(),
      totalPaidInvoices: json['total_paid_invoices'] ?? 0,
      totalPendingInvoices: json['total_pending_invoices'] ?? 0,
      totalPartialpaidInvoices: json['total_partialpaid_invoices'] ?? 0,
    );
  }
}

class Student {
  final int id;
  final String name;
  final String image;

  Student({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class Invoice {
  final int id;
  final String name;
  final String amount;
  final int amountPaid;
  final int pendingAmount;
  final String status;

  Invoice({
    required this.id,
    required this.name,
    required this.amount,
    required this.amountPaid,
    required this.pendingAmount,
    required this.status,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      amount: json['amount'] ?? '0.00',
      amountPaid: json['amount_paid'] ?? 0,
      pendingAmount: json['pending_amount'] ?? 0,
      status: json['status'] ?? '',
    );
  }
}