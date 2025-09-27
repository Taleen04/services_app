// home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trasport_ai/src/core/constants/app_colors.dart';
import 'package:trasport_ai/src/core/constants/app_text_styling.dart';
import 'package:trasport_ai/src/core/generated/l10n/app_localizations.dart';
import 'package:trasport_ai/src/feature/home/presentation/view/widget/custom_sliver_app_bar.dart';
import 'package:trasport_ai/src/feature/home/presentation/view/widget/requests_list.dart';
import 'package:trasport_ai/src/feature/home/presentation/view/widget/tast_list.dart';
import 'package:trasport_ai/src/feature/home/presentation/view/view_model/bloc/order_bloc.dart';
import 'package:trasport_ai/src/feature/home/presentation/view/view_model/bloc/order_events.dart';
import 'package:trasport_ai/src/feature/home/presentation/view/view_model/bloc/order_state.dart';
import 'package:trasport_ai/src/feature/home/presentation/repo/order_home_repo.dart';
import 'package:trasport_ai/src/feature/home/data/data_sourse.dart/order_data_sourse.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  late OrderBloc _requestsBloc;
  late OrderBloc _tasksBloc;
  bool _hasLoadedTasks = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // إنشاء البلوك للطلبات وتحميل البيانات تلقائياً عند تشغيل التطبيق
    _requestsBloc = OrderBloc(OrderHomeRepo(OrderDataSourse()))
      ..add(FetchOrders());

    // إنشاء البلوك للمهام بدون تحميل البيانات
    _tasksBloc = OrderBloc(OrderHomeRepo(OrderDataSourse()));

    // إضافة مستمع لتغيير التبويبات
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    // إذا انتقل المستخدم إلى تبويب المهام (الفهرس 1) ولم يتم تحميل البيانات بعد
    if (_tabController.index == 1 && !_hasLoadedTasks) {
      _tasksBloc.add(FetchAcceptedOrders());
      _hasLoadedTasks = true;
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _requestsBloc.close();
    _tasksBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backGroundPrimary,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBarCustom(), // الهيدر الخاص فيك
        ),
        body: Column(
          children: [
            Container(
              color: AppColors.backGroundIcon,
              child: TabBar(
                controller: _tabController,
                labelColor: AppColors.primaryText,
                unselectedLabelColor: AppColors.primaryText,
                indicatorColor: AppColors.primaryText,
                indicatorWeight: 3,
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox),
                        SizedBox(width: 6),
                        Text(
                         AppLocalizations.of(context)!.orders,
                          style: AppTextStyling.font14W600TextInter.copyWith(
                            color: AppColors.textWhite,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.assignment),
                        SizedBox(width: 6),
                        Text(
                         AppLocalizations.of(context)!.tasks,
                          style: AppTextStyling.font14W600TextInter.copyWith(
                            color: AppColors.textWhite,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: NeverScrollableScrollPhysics(), // يمنع السحب
                children: [
                  // تبويب الطلبات - يحمل البيانات تلقائياً عند تشغيل التطبيق
                  BlocProvider.value(
                    value: _requestsBloc,
                    child: BlocBuilder<OrderBloc, OrderState>(
                      builder: (context, state) {
                        if (state is OrderLoading) {
                          return Center(child: CircularProgressIndicator());
                        } else if (state is OrderLoaded) {
                          return RequestsList(
                            orders: state.currentOrders,
                            hasNextPage: state.hasNextPage,
                          );
                        } else if (state is OrderError) {
                          return Center(child: Text(state.message));
                        } else {
                          return Center(child: Text('لا توجد طلبات'));
                        }
                      },
                    ),
                  ),
                  // تبويب المهام - يحمل البيانات فقط عند الضغط عليه
                  BlocProvider.value(
                    value: _tasksBloc,
                    child: BlocBuilder<OrderBloc, OrderState>(
                      builder: (context, state) {
                        if (state is OrderLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is OrderLoaded) {
                          return Column(
                            children: [
                              Expanded(
                                child: TasksListWidget(
                                  orders: state.currentOrders,
                                  hasNextPage: state.hasNextPage,
                                ),
                              ),
                            ],
                          );
                        } else if (state is OrderError) {
                          return Center(child: Text(state.message));
                        } else if (state is OrderInitial) {
                          // عرض رسالة عند عدم تحميل البيانات بعد
                          return const Center(
                            child: Text(
                              'اضغط على المهام لتحميل البيانات',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        } else {
                          return const Center(child: Text('لا توجد مهام'));
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
