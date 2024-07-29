import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/chart_service.dart';
import 'package:qixer_seller/utils/constant_colors.dart';
import 'package:qixer_seller/utils/responsive.dart';

class ChartDashboard extends StatefulWidget {
  const ChartDashboard({super.key});

  @override
  _ChartDashboardState createState() => _ChartDashboardState();
}

class _ChartDashboardState extends State<ChartDashboard> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChartService>(
      builder: (context, provider, child) => Stack(
        children: <Widget>[
          provider.chartDataListMap.isNotEmpty
              ? AspectRatio(
                  aspectRatio: 1.70,
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(18),
                        ),
                        // color: Color(0xff232d37)
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 18.0, left: 12.0, top: 24, bottom: 12),
                      child: LineChart(
                        mainData(provider.chartDataListMap, provider.constValue,
                            provider.maxValue),
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  LineChartData mainData(monthAndValue, constValue, maxValue) {
    ConstantColors cc = ConstantColors();
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            // color: const Color(0xff37434d),
            color: Colors.grey.withOpacity(.2),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            // color: const Color(0xff37434d),
            color: Colors.grey.withOpacity(.2),
            strokeWidth: 1,
          );
        },
      ),
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) {
            return cc.primaryColor;
          },
          getTooltipItems: (touchedSpots) {
            return touchedSpots
                .map((e) => LineTooltipItem(
                    asProvider.getString("Order") +
                        ': ' +
                        (e.y.toDouble() * constValue).toStringAsFixed(0),
                    Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.white)))
                .toList();
          },
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (double value, TitleMeta meta) {
              const style = TextStyle(
                color: Color(0xff68737d),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              );
              Widget text = Text(
                  asProvider
                      .getString(monthAndValue[value.toInt()]['monthName']),
                  style: style);

              return SideTitleWidget(
                axisSide: meta.axisSide,
                space: 8.0,
                child: text,
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            // getTitlesWidget: leftTitleWidgets,
            reservedSize:
                (maxValue.toDouble().toStringAsFixed(0).length * 12).toDouble(),
            getTitlesWidget: (value, meta) {
              const style = TextStyle(
                color: Color(0xff68737d),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              );
              Widget text =
                  Text((value * constValue).toStringAsFixed(0), style: style);

              return SideTitleWidget(
                axisSide: meta.axisSide,
                space: 8.0,
                child: text,
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(
              // color: const Color(0xff37434d),
              color: Colors.grey.withOpacity(.3),
              width: 1)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: Iterable.generate(12)
              .map(
                (e) => FlSpot(e.toDouble(), monthAndValue[e]['orders']),
              )
              .toList(),
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ],
    );
  }
}
