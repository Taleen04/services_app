import 'package:flutter/material.dart';
import 'package:trasport_ai/src/core/constants/app_colors.dart';
import 'package:trasport_ai/src/core/constants/app_text_styling.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // نموذج بيانات للإشعارات
  List<Map<String, String>> notifications = [
    {
      "title": "تمت إضافة طلب جديد",
      "subtitle": "رقم الطلب #12345",
      "time": "قبل 2 ساعة",
    },
    {
      "title": "تم تحديث حالة الطلب",
      "subtitle": "رقم الطلب #12344 تم التنفيذ",
      "time": "قبل 5 ساعات",
    },
    {
      "title": "رسالة جديدة من العميل",
      "subtitle": "العميل محمد أرسل رسالة",
      "time": "اليوم",
    },
    {
      "title": "تمت الموافقة على الطلب",
      "subtitle": "رقم الطلب #12343",
      "time": "أمس",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryText,
        elevation: 0,
        title: const Text(
          'الإشعارات',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.textWhite,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  // أيقونة الإشعار داخل دائرة ملونة
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primaryText.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          notifications.removeAt(index); // إزالة الإشعار من القائمة
                        });
                      },
                      icon: Icon(
                        Icons.visibility,
                        color: AppColors.primaryText,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          notification["title"]!,
                          textAlign: TextAlign.right,
                          style: AppTextStyling.font16W500TextInter.copyWith(
                            color: AppColors.primaryText,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          notification["subtitle"]!,
                          textAlign: TextAlign.right,
                          style: AppTextStyling.font14W600TextInter.copyWith(
                            color: AppColors.background.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification["time"]!,
                          textAlign: TextAlign.right,
                          style: AppTextStyling.font14W600TextInter.copyWith(
                            color: AppColors.background.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
