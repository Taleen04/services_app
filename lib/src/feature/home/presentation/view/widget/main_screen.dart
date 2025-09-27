import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trasport_ai/src/feature/calender/data/calender_data_sourse.dart';
import 'package:trasport_ai/src/feature/calender/presentation/repo/calender_repo.dart';

import 'package:trasport_ai/src/feature/calender/presentation/view/calender.dart';
import 'package:trasport_ai/src/feature/calender/presentation/view_model/bloc/calender_bloc.dart';
import 'package:trasport_ai/src/feature/home/presentation/view/home_screen.dart';
import 'package:trasport_ai/src/feature/home/presentation/view/view_model/bloc/bloc_nav_bar.dart';
import 'package:trasport_ai/src/feature/home/presentation/view/view_model/bloc/bloc_nav_bar_event.dart';
import 'package:trasport_ai/src/feature/home/presentation/view/view_model/bloc/bloc_nav_bar_state.dart';
import 'package:trasport_ai/src/feature/home/presentation/view/widget/my_bottom_nav_bar.dart';
import 'package:trasport_ai/src/feature/profile/presentation/view/profile.dart';
import 'package:trasport_ai/src/feature/profile/presentation/view_model.dart/bloc/info_profile_bloc.dart';
import 'package:trasport_ai/src/feature/profile/repo/profile_repo.dart';
import 'package:trasport_ai/src/feature/profile/data/data_sourse/profile.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  CalendarBloc? _calendarBloc;
  late final InfoProfileBloc _infoProfileBloc;
  late final CalendarRepository _calendarRepository;

  @override
  void initState() {
    super.initState();
    _calendarRepository = CalendarRepository(CalendarDataSource());
    _infoProfileBloc = InfoProfileBloc(ProfileRepository(InfoProfile()))
      ..add(FetchProfile());
  }

  @override
  void dispose() {
    _calendarBloc?.close();
    _infoProfileBloc.close();
    super.dispose();
  }

  void _initializeCalendarBlocIfNeeded() {
    if (_calendarBloc == null) {
      _calendarBloc = CalendarBloc(_calendarRepository);
      print('تم إنشاء CalendarBloc جديد');
    }
  }

  void _disposeCalendarBlocIfNotNeeded(int currentIndex) {
    // تنظيف CalendarBloc عند الخروج من شاشة التقويم (اختياري)
    if (currentIndex != 2 && _calendarBloc != null) {
      // يمكن تفعيل هذا إذا كنت تريد توفير ذاكرة أكثر
      // _calendarBloc?.close();
      // _calendarBloc = null;
      // print('تم إغلاق CalendarBloc لتوفير الذاكرة');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _infoProfileBloc,
      child: BlocBuilder<NavBloc, NavState>(
        builder: (context, state) {
          // إنشاء CalendarBloc فقط عند الانتقال إلى شاشة التقويم
          Widget calendarWidget;
          if (state.selectedIndex == 2) {
            _initializeCalendarBlocIfNeeded();
            calendarWidget = BlocProvider.value(
              value: _calendarBloc!,
              child: const CalendarScreen(),
            );
          } else {
            calendarWidget = const SizedBox.shrink(); // شاشة فارغة
          }

          return Scaffold(
            body: IndexedStack(
              index: state.selectedIndex,
              children: [
                Profile(), // حسابي
                HomeScreen(), // الرئيسية
                calendarWidget, // التقويم (يتم إنشاؤه عند الحاجة)
              ],
            ),
            bottomNavigationBar: MyBottomNavBar(
              selectedIndex: state.selectedIndex,
              onTap: (index) {
                // تنظيف CalendarBloc إذا لم نعد بحاجة إليه (اختياري)
                _disposeCalendarBlocIfNotNeeded(index);

                context.read<NavBloc>().add(NavChanged(index));
              },
            ),
          );
        },
      ),
    );
  }
}
