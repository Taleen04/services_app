
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trasport_ai/src/core/constants/app_colors.dart';
import 'package:trasport_ai/src/core/constants/app_spacing.dart';
import 'package:trasport_ai/src/core/constants/app_text_styling.dart';
import 'package:trasport_ai/src/core/generated/l10n/app_localizations.dart';
import 'package:trasport_ai/src/core/utils/snackbar_helper.dart';
import 'package:trasport_ai/src/feature/home/data/model/model_order.dart';
import 'package:trasport_ai/src/feature/home/presentation/view/view_model/bloc/order_bloc.dart';
import 'package:trasport_ai/src/feature/home/presentation/view/view_model/bloc/order_events.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestsList extends StatefulWidget {
  final List<Order> orders;
  final bool hasNextPage;

  const RequestsList({
    super.key,
    required this.orders,
    this.hasNextPage = false,
  });

  @override
  State<RequestsList> createState() => _RequestsListState();
}

class _RequestsListState extends State<RequestsList> {
  late final ScrollController _scrollController;

  // Future<void> getClientPhone(Map<String, dynamic> order) async {
  //   try {
  //     final client = order["client"];
  //     if (client != null) {
  //       final phone = client["phone"];
  //       log("Client phone: $phone");
  //     } else {
  //       log("No client data found");
  //     }
  //   } catch (e) {
  //     log("Error: $e");
  //   }
  // }

  Future<void> launchWhatsApp(String phone) async {
    final Uri url = Uri.parse("https://wa.me/$phone");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'لا يمكن فتح واتساب';
    }
  }

  Future<void> launchCall(String phone) async {
    final Uri url = Uri.parse("tel:$phone");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'لا يمكن إجراء مكالمة';
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isNearBottom && widget.hasNextPage) {
      context.read<OrderBloc>().add(LoadNextOrders());
    }
  }

  bool get _isNearBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  String _formatDateTime(String? dt) {
    if (dt == null) return '-';
    final dateTime = DateTime.tryParse(dt);
    if (dateTime == null) return dt;
    return "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  Widget _buildStarsWidget(int starsCount) {
    if (starsCount <= 0) {
      return Text(
        '0',
        style: AppTextStyling.font14W600TextInter.copyWith(
          color: AppColors.textWhite,
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      );
    }

    List<Widget> starWidgets = [];

    // إضافة العدد الإضافي إذا كان أكثر من 5 (في البداية للعربية)
    if (starsCount > 5) {
      starWidgets.add(
        Text(
          '+${starsCount - 5} ',
          style: AppTextStyling.font14W600TextInter.copyWith(
            color: AppColors.textWhite,
            fontSize: 12,
          ),
        ),
      );
    }

    // إضافة النجوم (أقصى 5 نجوم)
    int displayStars = starsCount > 5 ? 5 : starsCount;
    for (int i = 0; i < displayStars; i++) {
      starWidgets.add(const Icon(Icons.star, color: Colors.amber, size: 16));
    }

    return Row(mainAxisSize: MainAxisSize.min, children: starWidgets);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.orders.isEmpty) {
      return const Center(child: Text('لا توجد طلبات حالياً'));
    }

    final itemCount =
        widget.hasNextPage ? widget.orders.length + 1 : widget.orders.length;

    return ListView.builder(
      controller: _scrollController,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index >= widget.orders.length) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return _buildRequestCard(context, widget.orders[index]);
      },
    );
  }

  Widget _buildRequestCard(BuildContext context, Order order) {
    return Card(
      color: AppColors.backGroundIcon,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // الصف الأول: اسم العميل + تاريخ الطلب
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        PopupMenuButton<String>(
                          icon: const Icon(
                            Icons.more_vert,
                            color: AppColors.textWhite,
                          ),
                          onSelected: (value) {
                            final phone = order.clientPhone;
                            if (value == "whatsApp") {
                              launchWhatsApp(phone.toString());
                            }
                            if (value == "call") {
                              launchCall(phone.toString());
                            }
                          },
                          itemBuilder:
                              (context) => [
                                PopupMenuItem(
                                  value: "whatsApp",
                                  child: Text(AppLocalizations.of(context)!.sendWhatsapp),
                                ),
                                PopupMenuItem(
                                  value: "call",
                                  child: Text(AppLocalizations.of(context)!.call),
                                ),
                              ],
                        ),

                        const Icon(
                          Icons.calendar_month_outlined,
                          color: AppColors.primaryText,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDateTime(order.createdAt),
                          style: AppTextStyling.font14W600TextInter.copyWith(
                            color: AppColors.textWhite,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    // Row(
                    //   children: [
                    //     const Icon(
                    //       Icons.access_time,
                    //       color: AppColors.primaryText,
                    //       size: 16,
                    //     ),
                    //     const SizedBox(width: 4),
                    //     Text(
                    //       _formatDateTime(order.expectedToGoOutAt),
                    //       style: AppTextStyling.font14W600TextInter.copyWith(
                    //         color: AppColors.textWhite,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      order.clientName,
                      style: AppTextStyling.font14W600TextInter.copyWith(
                        color: AppColors.textWhite,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildStarsWidget(order.starsCount),
                  ],
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.sm),

            // التفاصيل أسفل الصف الأول
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'نوع الخدمة: ${order.serviceName}',
                  style: AppTextStyling.font14W600TextInter.copyWith(
                    color: AppColors.textWhite,
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'رقم السيارة: ${order.vehicleNumber}',
                  style: AppTextStyling.font14W600TextInter.copyWith(
                    color: AppColors.textWhite,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '${order.vehicleName} : نوع السيارة',
                  style: AppTextStyling.font14W600TextInter.copyWith(
                    color: AppColors.textWhite,
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: Text(
                        order.statusName,
                        style: AppTextStyling.font14W600TextInter.copyWith(
                          color: AppColors.textWhite,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),

                    Text(
                      ': الحالة',
                      style: AppTextStyling.font14W600TextInter.copyWith(
                        color: AppColors.textWhite,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            // زر القبول
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      context.read<OrderBloc>().add(AcceptOrder(order.id));
                     log("**************done");
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'قبول',
                      style: AppTextStyling.font14W600TextInter.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
