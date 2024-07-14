import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  List<_ChartData> dailyData = [];
  List<_ChartData> monthlyData = [];

  @override
  void initState() {
    super.initState();
    fetchDailyData();
    fetchMonthlyData();
  }

  Future<void> fetchDailyData() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.5/flutter/revenue.php'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      setState(() {
        dailyData = responseData.map((item) {
          final date = item['date'] as String? ?? '';
          final revenue = item['revenue'] != null
              ? double.parse(item['revenue'].toString())
              : 0.0;
          return _ChartData(date, revenue);
        }).toList();

        // Sắp xếp dữ liệu theo ngày
        dailyData.sort((a, b) => a.date.compareTo(b.date));
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> fetchMonthlyData() async {
    final response = await http
        .get(Uri.parse('http://192.168.1.5/flutter/revenueMonth.php'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      setState(() {
        monthlyData = responseData.map((item) {
          final date = item['date'] as String? ?? '';
          final revenue = item['revenue'] != null
              ? double.parse(item['revenue'].toString())
              : 0.0;
          return _ChartData(date, revenue);
        }).toList();

        // Sắp xếp dữ liệu theo tháng
        monthlyData.sort((a, b) => a.date.compareTo(b.date));
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[200],
        title: const Text('Thống Kê'),
      ),
      body: dailyData.isEmpty || monthlyData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(
                          // Hiển thị 3 phần tử cuối cùng
                          visibleMinimum:
                              dailyData.length > 3 ? dailyData.length - 3 : 0,
                          visibleMaximum: dailyData.length > 3
                              ? dailyData.length - 1
                              : dailyData.length - 1,
                        ),
                        title: ChartTitle(text: 'Doanh Thu Hàng Ngày'),
                        legend: Legend(isVisible: true),
                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: <ChartSeries<_ChartData, String>>[
                          ColumnSeries<_ChartData, String>(
                            dataSource: dailyData,
                            xValueMapper: (_ChartData sales, _) => sales.date,
                            yValueMapper: (_ChartData sales, _) =>
                                sales.revenue,
                            name: 'Doanh Thu',
                            dataLabelSettings:
                                DataLabelSettings(isVisible: true),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(
                          // Hiển thị 3 phần tử cuối cùng
                          visibleMinimum: monthlyData.length > 3
                              ? monthlyData.length - 3
                              : 0,
                          visibleMaximum: monthlyData.length > 3
                              ? monthlyData.length - 1
                              : monthlyData.length - 1,
                        ),
                        title: ChartTitle(text: 'Doanh Thu Hàng Tháng'),
                        legend: Legend(isVisible: true),
                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: <ChartSeries<_ChartData, String>>[
                          ColumnSeries<_ChartData, String>(
                            dataSource: monthlyData,
                            xValueMapper: (_ChartData sales, _) => sales.date,
                            yValueMapper: (_ChartData sales, _) =>
                                sales.revenue,
                            name: 'Doanh Thu',
                            dataLabelSettings:
                                DataLabelSettings(isVisible: true),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _ChartData {
  _ChartData(this.date, this.revenue);

  final String date;
  final double revenue;
}
