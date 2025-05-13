import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/colors.dart';
import '../controllers/payments_controller.dart';
import '../../data/models/payments_model.dart';

class PaymentsScreen extends StatefulWidget {
  final int studentId;

  const PaymentsScreen({super.key, required this.studentId});

  @override
  _PaymentsScreenState createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final PaymentController _paymentController = Get.put(PaymentController());

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _paymentController.fetchPayments(widget.studentId).then((_) {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Obx(() => _paymentController.isLoading.value
                ? _buildLoadingState()
                : _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppConstants.defaultPadding,
        horizontal: AppConstants.defaultPadding,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child:  Icon(
              Icons.arrow_back_ios,
              color: AppColors.background,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Payments',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 120,
              width: 120,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                strokeWidth: 6,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Loading payment data...',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_paymentController.errorMessage.isNotEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 60,
                color: AppColors.error,
              ),
              const SizedBox(height: 16),
              Text(
                _paymentController.errorMessage.value,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _paymentController.fetchPayments(widget.studentId),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_paymentController.paymentData.value == null) {
      return Expanded(
        child: Center(
          child: Text(
            'No payment data available',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }

    final paymentData = _paymentController.paymentData.value!;

    return Expanded(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.2),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _controller,
                curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
              )),
              child: FadeTransition(
                opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: _controller,
                    curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
                  ),
                ),
                child: _buildPaymentSummary(paymentData),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(
              left: AppConstants.defaultPadding,
              right: AppConstants.defaultPadding,
              top: AppConstants.defaultPadding,
              bottom: AppConstants.defaultPadding * 2,
            ),
            sliver: paymentData.invoices.isEmpty
                ? SliverToBoxAdapter(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    Text(
                      'No invoices available',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )
                : SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: _buildPaymentCard(paymentData, index),
                      ),
                    ),
                  );
                },
                childCount: paymentData.invoices.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummary(PaymentModel paymentData) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Row(
        children: [
          _buildSummaryCard(
            title: 'Paid Invoices',
            value: paymentData.totalPaidInvoices,
            color: AppColors.success,
            icon: Icons.check_circle_outline,
          ),
          _buildSummaryCard(
            title: 'Due Invoices',
            value: paymentData.totalPendingInvoices,
            color: AppColors.error,
            icon: Icons.warning_amber_outlined,
          ),
          _buildSummaryCard(
            title: 'Partial Paid',
            value: paymentData.totalPartialpaidInvoices,
            color: AppColors.warning,
            icon: Icons.timelapse_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required int value,
    required Color color,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
                const SizedBox(width: 6),
                Text(
                  value.toString(),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Map to keep track of expanded state for each invoice
  final Map<int, bool> _expandedItems = {};

  Widget _buildPaymentCard(PaymentModel paymentData, int index) {
    final invoice = paymentData.invoices[index];
    final isExpanded = _expandedItems[invoice.id] ?? false;

    Color statusColor;
    switch (invoice.status.toLowerCase()) {
      case 'paid':
        statusColor = AppColors.success;
        break;
      case 'pending':
      case 'due':
        statusColor = AppColors.error;
        break;
      case 'partial':
      case 'partialpaid':
        statusColor = AppColors.warning;
        break;
      default:
        statusColor = AppColors.info;
    }

    // Try to parse the amount as a number for display
    int amountValue;
    try {
      amountValue = int.parse(invoice.amount.replaceAll(RegExp(r'[^0-9]'), ''));
    } catch (e) {
      amountValue = 0;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        child: Material(
          color: Colors.transparent,
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _expandedItems[invoice.id] = !isExpanded;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: AppColors.primaryGradient,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            amountValue.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              invoice.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                invoice.status,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: statusColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0.0,
                        duration: AppConstants.animationDuration,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedSize(
                duration: AppConstants.animationDuration,
                curve: Curves.easeInOut,
                child: SizedBox(
                  height: isExpanded ? null : 0,
                  child: isExpanded
                      ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withOpacity(0.3),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(
                            AppConstants.defaultBorderRadius),
                        bottomRight: Radius.circular(
                            AppConstants.defaultBorderRadius),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow('Student', paymentData.student.name),
                        _buildDetailRow('Fee title', invoice.name),
                        _buildDetailRow('Total Fee', invoice.amount),
                        _buildDetailRow('Paid amount', invoice.amountPaid.toString()),
                        _buildDetailRow('Pending Fee', invoice.pendingAmount.toString()),
                        _buildDetailRow('Status', invoice.status),
                      ],
                    ),
                  )
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}