import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_font.dart';

class PerformanceLineChart extends StatefulWidget {
  final List<double> scores;
  final List<int> examsTakenList; // number of exams taken each day
  final List<String> weekDays;
  final int todayIndex;

  const PerformanceLineChart({
    super.key,
    required this.scores,
    required this.examsTakenList,
    required this.weekDays,
    this.todayIndex = -1,
  });

  @override
  State<PerformanceLineChart> createState() => _PerformanceLineChartState();
}

class _PerformanceLineChartState extends State<PerformanceLineChart> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: LineChart(mainData()),
      ),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) => Colors.white,

          fitInsideHorizontally: true,
          fitInsideVertically: true,

          tooltipPadding: const EdgeInsets.all(8),
          tooltipBorder: BorderSide(color: Colors.white),
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              final index = spot.x.toInt();
              final exams = widget.examsTakenList.length > index
                  ? widget.examsTakenList[index]
                  : 0;
              return LineTooltipItem(
                '',
                const TextStyle(),
                children: [
                  TextSpan(text: 'Exams Taken: $exams\n'),

                  TextSpan(text: 'Avg Score: '),
                  TextSpan(
                    text: '${spot.y.toInt()}%',
                    style: const TextStyle(
                      color: Color(0xFF10B981),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            }).toList();
          },
        ),
      ),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        horizontalInterval: 25,
        checkToShowHorizontalLine: (value) => true,
        getDrawingHorizontalLine: (value) =>
            FlLine(color: Color(0xFF55627B), strokeWidth: 1),
        drawVerticalLine: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: 25,
            getTitlesWidget: (value, meta) {
              if (value > 100) {
                return const SizedBox.shrink(); // إخفاء العناوين فوق 100%
              }
              return Text(
                '${value.toInt()}${' %'}',
                textAlign: TextAlign.start,
                style: const TextStyle(
                  color: Color(0xFF8F9DB2),
                  fontSize: 12,
                  fontFamily: AppFont.poppinsRegular,
                ),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 36,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index < 0 || index >= widget.weekDays.length) {
                return const SizedBox.shrink();
              }
              final isToday = index == widget.todayIndex;
              final dayText = widget.weekDays[index];

              if (isToday) {
                return Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF0F172A), Color(0xFF28355F)],
                      ),
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.15),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        dayText,
                        style: const TextStyle(
                          fontFamily: AppFont.interBold,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  dayText,
                  style: const TextStyle(
                    color: Color(0xFF8F9DB2),
                    fontSize: 14,
                    fontFamily: AppFont.poppinsSemiBold,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 105,
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(
            widget.scores.length,
            (i) => FlSpot(i.toDouble(), widget.scores[i]),
          ),
          isCurved: true,
          color: const Color(0xFF37CD6E),
          barWidth: 3,
          dotData: const FlDotData(show: true, getDotPainter: _getDotPainter),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF10B981).withOpacity(0.3),
                const Color(0xFF10B981).withOpacity(0.0),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static FlDotPainter _getDotPainter(
    FlSpot spot,
    double xPercentage,
    LineChartBarData bar,
    int index,
  ) {
    return FlDotCirclePainter(
      radius: 4,
      color: Color(0xFF1A2441),
      strokeWidth: 3,
      strokeColor: Color(0xFF37CD6E),
    );
  }
}
