import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intelli_hire/core/service/api_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/entities/report_entity.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/views/widget/point_text.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/views/widget/status_card.dart';

class ReportCard extends StatelessWidget {
  const ReportCard({
    super.key,
    required this.report,
    this.isreviewSession = false,
  });

  final ReportEntity report;
  final bool? isreviewSession;

  List<String> _parsePoints(String? points) {
    if (points == null || points.isEmpty || points == "Not provided") return [];
    return points
        .split(' | ')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  // 🔴 دالة التحميل المحدثة بدون Snackbars
  Future<void> _downloadReport(String sessionId) async {
    try {
      Directory dir = await getApplicationDocumentsDirectory();
      String savePath = "${dir.path}/Report_$sessionId.pdf";

      await ApiService().download(
        endPoint: "api/Employer/$sessionId/download/report",
        savePath: savePath,
      );

      await OpenFilex.open(savePath);
    } catch (e) {
      debugPrint("Report Download Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final strengths = _parsePoints(report.strengthPoints);
    final weaknesses = _parsePoints(report.weaknessesPoints);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xffF0F4F8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isreviewSession == false)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "AI Interview Report",
                    style: AppTextStyle.textstyle16.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColor.darkBlue,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    // نمرر الـ sessionId فقط
                    _downloadReport(report.sessionId);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: SvgPicture.asset("assets/image/icon svg/download.svg"),
                  label: Text(
                    "PDF Report",
                    style: AppTextStyle.textstyle12.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: StatusCard(
                  title: 'Avg. Response',
                  value: report.averageResponseTime ?? "N/A",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatusCard(
                  title: "Accuracy",
                  value:
                      "${report.accuracyPercent?.toStringAsFixed(1) ?? "0.0"}%",
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            "Strength Points",
            style: TextStyle(
              color: Color(0xff22C55E),
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          if (strengths.isEmpty)
            const Text(
              "No strengths noted.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ...strengths.map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PointText(text: s),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Weakness Points",
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          if (weaknesses.isEmpty)
            const Text(
              "No weaknesses noted.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ...weaknesses.map(
            (w) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PointText(text: w),
            ),
          ),
        ],
      ),
    );
  }
}
