import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:trasport_ai/src/core/constants/app_colors.dart';
import 'package:trasport_ai/src/core/constants/app_gradients.dart';
import 'package:trasport_ai/src/core/constants/app_text_styling.dart';
import 'package:trasport_ai/src/core/generated/l10n/app_localizations.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  Future<String> fetchTerms() async {
    final response = await http.get(
      Uri.parse('https://parking.engmahmoudali.com/api/terms-and-conditions'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["data"]["Terms_And_Conditions"] ?? "";
    } else {
      throw Exception("فشل في جلب البيانات");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.termsAndPolicies,
          style: AppTextStyling.font16W500TextInter.copyWith(
            color: AppColors.textWhite,
            fontSize: 20,
          ),
        ),

        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppGradients.orangeGradient),
        ),
      ),
      body: FutureBuilder<String>(
        future: fetchTerms(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("خطأ: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("لا توجد بيانات"));
          } else {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Html(
                  data: snapshot.data,
                  style: {
                    "body": Style.fromTextStyle(
                      AppTextStyling.font16W500TextInter,
                    ).copyWith(
                      textAlign: TextAlign.right, // النص من جهة اليمين
                    ),
                    "p": Style.fromTextStyle(
                      AppTextStyling.font16W500TextInter,
                    ).copyWith(textAlign: TextAlign.right),
                    "h1": Style.fromTextStyle(
                      AppTextStyling.font16W500TextInter.copyWith(fontSize: 22),
                    ).copyWith(textAlign: TextAlign.right),
                    "h2": Style.fromTextStyle(
                      AppTextStyling.font16W500TextInter.copyWith(fontSize: 20),
                    ).copyWith(textAlign: TextAlign.right),
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
