import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:trasport_ai/src/core/constants/app_colors.dart';
import 'package:trasport_ai/src/core/constants/app_spacing.dart';
import 'package:trasport_ai/src/core/constants/app_text_styling.dart';
import 'package:trasport_ai/src/core/generated/l10n/app_localizations.dart';
import 'package:trasport_ai/src/feature/calender/domain/model/calender_model.dart';
import 'package:trasport_ai/src/feature/calender/presentation/view_model/bloc/calender_bloc.dart';
import 'package:trasport_ai/src/feature/calender/presentation/view_model/bloc/calender_event.dart';
import 'package:trasport_ai/src/feature/calender/presentation/view_model/bloc/calender_state.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  final RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;
  bool _hasExplicitSelection = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // تحميل بيانات اليوم الحالي فقط عند الحاجة
    _rangeStart = null;
    _rangeEnd = null;
    _hasExplicitSelection = false;

    // تحميل البيانات بعد بناء الواجهة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CalendarBloc>().add(
          FetchCalendarEvent(_selectedDay, _selectedDay),
        );
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryText,
        title: Align(
          alignment: Alignment.topRight,
          child:  Text(
           AppLocalizations.of(context)!.calendarAndServices,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs:  [
            Tab(text: AppLocalizations.of(context)!.donee),
            Tab(text: AppLocalizations.of(context)!.notDone),
            Tab(text: AppLocalizations.of(context)!.reports),
          ],
          labelColor: AppColors.textWhite,
        ),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(DateTime.now().year, 1, 1),
            lastDay: DateTime.now(), // منع اختيار تواريخ مستقبلية
            focusedDay: _focusedDay,
            selectedDayPredicate:
                (day) => _hasExplicitSelection && isSameDay(_selectedDay, day),
            rangeSelectionMode: _rangeSelectionMode,
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            onDaySelected: (selectedDay, focusedDay) {
              // منع اختيار تواريخ مستقبلية
              if (selectedDay.isAfter(DateTime.now())) {
                return;
              }
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _rangeStart = null;
                _rangeEnd = null;
                _hasExplicitSelection = true;
              });
              context.read<CalendarBloc>().add(
                FetchCalendarEvent(selectedDay, selectedDay),
              );
            },
            onRangeSelected: (start, end, focusedDay) {
              // منع اختيار تواريخ مستقبلية في المدى
              if (start != null && start.isAfter(DateTime.now())) {
                return;
              }
              if (end != null && end.isAfter(DateTime.now())) {
                end = DateTime.now(); // تحديد النهاية لليوم الحالي كحد أقصى
              }

              setState(() {
                _rangeStart = start;
                _rangeEnd = end;
                _focusedDay = focusedDay;
                _hasExplicitSelection = false;
              });
              if (start != null && end != null) {
                context.read<CalendarBloc>().add(
                  FetchCalendarEvent(start, end),
                );
              } else if (start != null && end == null) {
                // عرض يوم واحد عند اختيار بداية فقط
                context.read<CalendarBloc>().add(
                  FetchCalendarEvent(start, start),
                );
              }
            },
            headerStyle: const HeaderStyle(
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              formatButtonVisible: false,
              leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
              rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: Colors.white),
              weekendStyle: TextStyle(color: Colors.white),
            ),
            calendarStyle: CalendarStyle(
              // إزالة تمييز يوم اليوم
              todayDecoration: const BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              // تغيير لون التحديد إلى أصفر
              selectedDecoration: const BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.circle,
              ),
              rangeHighlightColor: Colors.amber.withOpacity(0.2),
              rangeStartDecoration: const BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.circle,
              ),
              rangeEndDecoration: const BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.circle,
              ),
              defaultTextStyle: const TextStyle(color: Colors.white),
              weekendTextStyle: const TextStyle(color: Colors.white),
            ),
            calendarFormat: CalendarFormat.month,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<CalendarBloc, CalendarState>(
              builder: (context, state) {
                if (state is CalendarLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CalendarLoaded) {
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _buildTaskList(state.finishedOrders), // تم تنفيذها
                      _buildTaskList(state.cancelledOrders), // لم يتم تنفيذ
                      _buildReportsList(
                        state.allOrders,
                        state.finishedOrders,
                        state.cancelledOrders,
                        state.acceptedOrders,
                      ), // التقارير مجمعة
                    ],
                  );
                } else if (state is CalendarError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(
    List<ServiceOrderModel> tasks, {
    bool shrinkWrap = false,
    ScrollPhysics? physics,
  }) {
    if (tasks.isEmpty) {
      return Center(
        child: Text(
          "لا توجد خدمات",
          style: AppTextStyling.font14W600TextInter.copyWith(
            color: AppColors.textWhite,
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: ListTile(
            title: Align(
              alignment: Alignment.topRight, // النصوص الرئيسية عاليمين
              child: Text(
                task.serviceName,
                style: AppTextStyling.font16W500TextInter.copyWith(
                  color: AppColors.backGroundIcon,
                ),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.sm),
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${task.vehicleNumber} :رقم المركبة",
                        style: AppTextStyling.font14W600TextInter.copyWith(
                          color: AppColors.backGroundIcon,
                        ),
                      ),
                      const SizedBox(height: 4),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            () {
                              Color statusColor;
                              IconData statusIcon;
                              switch (task.status) {
                                case 3:
                                  statusColor = Colors.green;
                                  statusIcon = Icons.check_circle;
                                  break;
                                case 4:
                                  statusColor = Colors.red;
                                  statusIcon = Icons.cancel;
                                  break;
                                case 2:
                                  statusColor = Colors.amber;
                                  statusIcon = Icons.hourglass_bottom;
                                  break;
                                default:
                                  statusColor = Colors.grey;
                                  statusIcon = Icons.info_outline;
                              }
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: statusColor,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      statusIcon,
                                      size: 18,
                                      color: statusColor,
                                    ),
                                    Text(
                                      " ${task.statusName} :الحالة",
                                      style: AppTextStyling.font14W600TextInter
                                          .copyWith(
                                            color: statusColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(width: 6),
                                  ],
                                ),
                              );
                            }(),
                            Text(
                              "${task.vehicleName} :اسم المركبة",
                              style: AppTextStyling.font14W600TextInter
                                  .copyWith(color: AppColors.backGroundIcon),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "اسم العميل:${task.clientName} ",
                        style: AppTextStyling.font14W600TextInter.copyWith(
                          color: AppColors.backGroundIcon,
                        ),
                      ),
                      const SizedBox(height: 10),
                      () {
                        String label;
                        DateTime? dateValue;
                        String? overrideText;
                        if (task.status == 2) {
                          label = 'تاريخ القبول';
                          dateValue = task.acceptedAt ?? task.createdAt;
                        } else if (task.status == 3) {
                          label = 'تاريخ الإتمام';
                          dateValue = task.updatedAt;
                        } else if (task.status == 4) {
                          if (task.cancelledAt != null) {
                            label = 'تاريخ الإلغاء';
                            dateValue = task.cancelledAt;
                          } else {
                            overrideText = 'لم يتم كنسلته لسا';
                            label = '';
                          }
                        } else {
                          label = 'تاريخ الطلب';
                          dateValue = task.createdAt;
                        }

                        if (overrideText != null) {
                          return Text(
                            overrideText,
                            style: AppTextStyling.font14W600TextInter.copyWith(
                              color: AppColors.backGroundIcon,
                            ),
                          );
                        }

                        String formatted = dateValue!.toString();
                        final dotIndex = formatted.indexOf('.');
                        if (dotIndex != -1) {
                          formatted = formatted.substring(0, dotIndex);
                        }

                        return Text(
                          "$formatted :$label",
                          style: AppTextStyling.font14W600TextInter.copyWith(
                            color: AppColors.backGroundIcon,
                          ),
                        );
                      }(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReportsList(
    List<ServiceOrderModel> all,
    List<ServiceOrderModel> finished,
    List<ServiceOrderModel> cancelled,
    List<ServiceOrderModel> accepted,
  ) {
    // Fallback: إذا لم ترجع المقبولة من API، استخرجها من all
    List<ServiceOrderModel> acceptedDisplay = accepted;
    if (acceptedDisplay.isEmpty && all.isNotEmpty) {
      acceptedDisplay = all.where((o) => o.status == 2).toList();
      print(
        'Using fallback: found ${acceptedDisplay.length} accepted from all orders',
      );
    }

    // تحقق من وجود أي بيانات في أي قسم
    final hasAnyData =
        finished.isNotEmpty ||
        cancelled.isNotEmpty ||
        acceptedDisplay.isNotEmpty;

    if (!hasAnyData) {
      return Center(
        child: Text(
          "لا توجد خدمات في التاريخ المحدد",
          style: AppTextStyling.font14W600TextInter.copyWith(
            color: AppColors.textWhite,
          ),
        ),
      );
    }

    return ListView(
      children: [
        // عرض تم تنفيذها فقط إذا كان يحتوي على بيانات
        if (finished.isNotEmpty)
          _buildReportSection(
            title: 'تم تنفيذها (${finished.length})',
            color: Colors.green,
            tasks: finished,
          ),
        // عرض لم يتم تنفيذها فقط إذا كان يحتوي على بيانات
        if (cancelled.isNotEmpty)
          _buildReportSection(
            title: 'لم يتم تنفيذها (${cancelled.length})',
            color: Colors.red,
            tasks: cancelled,
          ),
        // عرض المقبولة فقط إذا كان يحتوي على بيانات
        if (acceptedDisplay.isNotEmpty)
          _buildReportSection(
            title: 'مقبولة / قيد التنفيذ (${acceptedDisplay.length})',
            color: Colors.amber,
            tasks: acceptedDisplay,
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildReportSection({
    required String title,
    required Color color,
    required List<ServiceOrderModel> tasks,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color, width: 1),
                ),
                child: Row(
                  children: [
                    Icon(Icons.circle, size: 10, color: color),
                    const SizedBox(width: 6),
                    Text(
                      title,
                      style: AppTextStyling.font14W600TextInter.copyWith(
                        color: AppColors.backGroundIcon,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (tasks.isEmpty)
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'لا يوجد عناصر',
                style: AppTextStyling.font14W600TextInter.copyWith(
                  color: AppColors.textWhite,
                ),
              ),
            )
          else
            _buildTaskList(
              tasks,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
