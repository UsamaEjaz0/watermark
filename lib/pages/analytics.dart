import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Analytics extends StatefulWidget {
  @override
  _AnalyticsState createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  List<OrderBarData> ordersBarChartData = [];
  List<SalesBarData> salesBarChartData = [];

  final Map<int, int> ordersMap = HashMap();
  final Map<int, int> salesMap = HashMap();

  final Map<int, String> monthMap = {
    1: 'Jan',
    2: 'Feb',
    3: 'Mar',
    4: 'Apr',
    5: 'May',
    6: 'Jun',
    7: 'Jul',
    8: 'Aug',
    9: 'Sep',
    10: 'Oct',
    11: 'Nov',
    12: 'Dec',
  };

  CollectionReference ref = FirebaseFirestore.instance.collection('CustomData');

  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Orders')),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(context) {
    return StreamBuilder(
        stream: ref.snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          ordersMap.addAll({
            1: 0,
            2: 0,
            3: 0,
            4: 0,
            5: 0,
            6: 0,
            7: 0,
            8: 0,
            9: 0,
            10: 0,
            11: 0,
            12: 0,
          });
          salesMap.addAll({
            1: 0,
            2: 0,
            3: 0,
            4: 0,
            5: 0,
            6: 0,
            7: 0,
            8: 0,
            9: 0,
            10: 0,
            11: 0,
            12: 0,
          });
          if (snapshot.hasData) {
            Iterable<QueryDocumentSnapshot<Object>> docs =
                snapshot.data.docs.map((element) {
              return element;
            });
            int month;
            docs.forEach((element) => {
                  month = element["(Order Date)"].substring(4, 5) == '/' ?
                  int.parse(element["(Order Date)"].substring(3, 4)) :
                  int.parse(element["(Order Date)"].substring(3, 5)),
                  ordersMap.update(month, (value) => ordersMap[month] + 1),
                  salesMap.update(month, (value) => salesMap[month] + int.parse(element["(Order Price)"])) //int.parse(element[""])
                });

            ordersMap.forEach((key, value) {
              ordersBarChartData.add(
                  OrderBarData(month: monthMap[key], orders: ordersMap[key]));
            });
            salesMap.forEach((key, value) {
              salesBarChartData.add(
                  SalesBarData(month: monthMap[key], sales: salesMap[key]));
            });
          } else {
            return LinearProgressIndicator();
          }

          return Scaffold(
            body: Column(children: [
              MonthlyOrderChart(
                data: ordersBarChartData,
              ),
              MonthlySalesChart(
                data: salesBarChartData,
              )
            ]),
          );
        });
  }
}

class OrderBarData {
  final String month;
  final int orders;
  OrderBarData({this.month, this.orders});
}

class SalesBarData {
  final String month;
  final int sales;
  SalesBarData({this.month, this.sales});
}

class MonthlyOrderChart extends StatelessWidget {
  final List<OrderBarData> data;

  MonthlyOrderChart({@required this.data});

  Widget build(BuildContext context) {
    List<charts.Series<OrderBarData, String>> series = [
      charts.Series(
          id: 'orders',
          data: data,
          domainFn: (OrderBarData bardata, _) => bardata.month,
          measureFn: (OrderBarData bardata, _) => bardata.orders)
    ];

    return Container(
        height: 260,
        padding: EdgeInsets.all(20),
        child: Card(
          child: Padding(
              padding: EdgeInsets.all(4),
              child: Column(
                children: <Widget>[
                  Text('Monthly Orders'),
                  Expanded(
                      child: charts.BarChart(
                    series,
                    animate: true,
                  )),
                ],
              )),
        ));
  }
}

class MonthlySalesChart extends StatelessWidget {
  final List<SalesBarData> data;

  MonthlySalesChart({@required this.data});

  Widget build(BuildContext context) {
    List<charts.Series<SalesBarData, String>> series = [
      charts.Series(
          id: 'sales',
          data: data,
          domainFn: (SalesBarData bardata, _) => bardata.month,
          measureFn: (SalesBarData bardata, _) => bardata.sales)
    ];

    return Container(
        height: 260,
        padding: EdgeInsets.all(20),
        child: Card(
          child: Padding(
              padding: EdgeInsets.all(4),
              child: Column(
                children: <Widget>[
                  Text('Monthly Sales'),
                  Expanded(
                      child: charts.BarChart(
                    series,
                    animate: true,
                  )),
                ],
              )),
        ));
  }
}
