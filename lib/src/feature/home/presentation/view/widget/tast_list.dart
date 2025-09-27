import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trasport_ai/src/core/constants/app_colors.dart';
import 'package:trasport_ai/src/core/constants/app_spacing.dart';
import 'package:trasport_ai/src/core/constants/app_text_styling.dart';
import 'package:trasport_ai/src/core/utils/snackbar_helper.dart';
import 'package:trasport_ai/src/feature/home/data/model/model_order.dart';
import 'package:trasport_ai/src/feature/home/presentation/view/view_model/bloc/order_bloc.dart';
import 'package:trasport_ai/src/feature/home/presentation/view/view_model/bloc/order_events.dart';

class TasksListWidget extends StatefulWidget {
  final List<Order> orders;
  final bool hasNextPage;

  const TasksListWidget({
    super.key,
    required this.orders,
    this.hasNextPage = false,
  });

  @override
  State<TasksListWidget> createState() => _TasksListWidgetState();
}

class _TasksListWidgetState extends State<TasksListWidget> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom && widget.hasNextPage) {
      context.read<OrderBloc>().add(LoadMoreAcceptedOrders());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9); // تحميل عند الوصول لـ 90%
  }

  String _formatDateTime(String? dt) {
    if (dt == null || dt.isEmpty) return '-';
    final dateTime = DateTime.tryParse(dt);
    if (dateTime == null) return dt;
    return "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  String _orDash(String? value) {
    if (value == null || value.isEmpty) return '-';
    return value;
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
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount:
          widget.hasNextPage ? widget.orders.length + 1 : widget.orders.length,
      itemBuilder: (context, index) {
        // عرض loading indicator في النهاية
        if (index >= widget.orders.length) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final order = widget.orders[index];

        // استخدام التاريخ المتوقع من الباك اند
        DateTime executionTime;
        try {
          executionTime = DateTime.parse(
            order.expectedToGoOutAt ?? DateTime.now().toString(),
          );
        } catch (_) {
          executionTime = DateTime.now();
        }

        Duration difference = executionTime.difference(DateTime.now());
        bool isNearExecution = difference.inDays < 1 && !difference.isNegative;

        return Card(
          color: AppColors.backGroundIcon,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // الصف العلوي (العميل والوقت)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_month_outlined,
                              size: 16,
                              color: AppColors.primaryText,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatDateTime(order.expectedToGoOutAt),
                              style: AppTextStyling.font14W600TextInter
                                  .copyWith(color: AppColors.textWhite),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        // Row(
                        //   children: [
                        //     const Icon(
                        //       Icons.access_time,
                        //       size: 16,
                        //       color: AppColors.primaryText,
                        //     ),
                        //     const SizedBox(width: 4),
                        //     Text(
                        //       _formatDateTime(order.acceptedAt),
                        //       style: AppTextStyling.font14W600TextInter
                        //           .copyWith(color: AppColors.textWhite),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                    // بيانات العميل
                    Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              _orDash(order.clientName),
                              style: AppTextStyling.font14W600TextInter
                                  .copyWith(color: AppColors.textWhite),
                            ),
                            const SizedBox(height: 4),
                            _buildStarsWidget(order.starsCount),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                // تفاصيل الطلب
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'نوع الخدمة: ${_orDash(order.serviceName)}',
                      style: AppTextStyling.font14W600TextInter.copyWith(
                        color: AppColors.textWhite,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'رقم السيارة: ${_orDash(order.vehicleNumber)}',
                      style: AppTextStyling.font14W600TextInter.copyWith(
                        color: AppColors.textWhite,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'نوع السيارة: ${_orDash(order.vehicleName)}',
                      style: AppTextStyling.font14W600TextInter.copyWith(
                        color: AppColors.textWhite,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.green,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.green),
                          ),
                          child: Text(
                            order.statusName,
                            style: AppTextStyling.font14W600TextInter.copyWith(
                              color: AppColors.textWhite,
                            ),
                          ),
                        ),
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

                // موعد التنفيذ
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.orange[200]!),
                    ),
                    child: Text(
                      "Deadline: ${_formatDateTime(order.expectedToGoOutAt)}",
                      style: TextStyle(
                        color: Colors.orange[700],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.sm),

                Row(
                  children: [
                    Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          color:
                              isNearExecution
                                  ? Colors.orangeAccent
                                  : Colors.green,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow:
                              isNearExecution
                                  ? [
                                    BoxShadow(
                                      color: Colors.orangeAccent.withOpacity(
                                        0.6,
                                      ),
                                      blurRadius: 12,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                  : [],
                        ),
                        child: TextButton(
                          onPressed: () {
                            context.read<OrderBloc>().add(
                              finishOrder(order.id),
                            );
                            SnackbarUtils.showSuccess(
                              context,
                              'تم انهاء الخدمة بنجاح',
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'تم',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
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
      },
    );
  }
}
