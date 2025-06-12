import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:demo2/Api_Metrimony/Api_server.dart';

class ApiChart extends StatefulWidget {
  @override
  State<ApiChart> createState() => _ApiChartState();
}

class _ApiChartState extends State<ApiChart> with SingleTickerProviderStateMixin {
  final ApiService _databaseService = ApiService();
  late List<dynamic>? _allUsers;
  bool _isLoading = true;
  double femaleAmount = 0;
  double maleAmount = 0;
  int totalAmount = 0;
  Map<String, double> genderDataMap = {};

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      List<dynamic> users = await _databaseService.getUsers(context);

      setState(() {
        _allUsers = users;
        totalAmount = _allUsers!.length;

        femaleAmount = _allUsers!
            .where((user) => user['Column_gender'].toString().toLowerCase() == "female")
            .length
            .toDouble();

        maleAmount = _allUsers!
            .where((user) => user['Column_gender'].toString().toLowerCase() == "male")
            .length
            .toDouble();

        if (totalAmount == 0) {
          femaleAmount = 0.01;
          maleAmount = 0.01;
        }

        addDetail();
        _isLoading = false;
      });

      _controller.forward();
    } catch (e) {
      print("Error fetching users: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  final genderColorList = <Color>[
    Colors.blue,
    Colors.pinkAccent,
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void addDetail() {
    genderDataMap = {
      "Male": maleAmount > 0 ? maleAmount : 0.01,
      "Female": femaleAmount > 0 ? femaleAmount : 0.01,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("chart",style: TextStyle(color: Colors.black),),
      ),
      backgroundColor: Color(0xFFF5F5F5),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB3E5FC), Color(0xFFA88CE5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _isLoading
            ? Center(
          child: CircularProgressIndicator(),
        )
            : _allUsers == null || _allUsers!.isEmpty
            ? Center(
          child: Text("No data available"),
        )
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildCard(
                title: 'Gender Distribution',
                pieChart: PieChart(
                  dataMap: genderDataMap.isNotEmpty ? genderDataMap : {"No Data": 1.0},
                  animationDuration: Duration(milliseconds: 800),
                  chartLegendSpacing: 32,
                  chartRadius: MediaQuery.of(context).size.width / 4,
                  colorList: genderColorList,
                  chartType: ChartType.ring,
                  ringStrokeWidth: 32,
                  legendOptions: LegendOptions(showLegends: false),
                  chartValuesOptions: ChartValuesOptions(
                    showChartValueBackground: true,
                    showChartValues: true,
                    showChartValuesInPercentage: true,
                    showChartValuesOutside: false,
                    decimalPlaces: 1,
                  ),
                ),
                legend: Column(
                  children: [
                    _buildLegendItem(
                      icon: Icons.male,
                      color: Colors.blue,
                      label: "Male: ${(maleAmount / totalAmount * 100).toStringAsFixed(1)}%",
                    ),
                    SizedBox(height: 8),
                    _buildLegendItem(
                      icon: Icons.female,
                      color: Colors.pinkAccent,
                      label: "Female: ${(femaleAmount / totalAmount * 100).toStringAsFixed(1)}%",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required Widget pieChart, required Widget legend}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: EdgeInsets.all(12),
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 0,
                    child: pieChart,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: SingleChildScrollView(
                      child: legend,
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

  Widget _buildLegendItem({required IconData icon, required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24),
        SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
