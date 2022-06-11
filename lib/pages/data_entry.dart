import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:watermark/dialogs/add_order.dart';
import 'package:watermark/dialogs/add_order_custom.dart';
import 'package:watermark/models/custom_order.dart';
import 'package:watermark/models/order.dart';
import 'package:watermark/utils/app_config.dart';
import 'package:watermark/widgets/custom_list_item.dart';

class DataEntry extends StatefulWidget {
  @override
  _DataEntryState createState() => _DataEntryState();
}

class _DataEntryState extends State<DataEntry> {
  final key = GlobalKey<AnimatedListState>();
  final key2 = GlobalKey<AnimatedListState>();

  CollectionReference ref = FirebaseFirestore.instance.collection('CustomData');

  @override
  Widget build(BuildContext ctxt) {

    SizeConfig().init(ctxt);
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Expanded(
            child: Scaffold(
              // appBar: TabBar(
              //   labelColor: Colors.black,
              //   tabs: [
              //     Tab(
              //       text: "Offset",
              //     ),
              //     Tab(
              //       text: "Packages",
              //     ),
              //   ],
              // ),
              body: TabBarView(
                children: [
                  Center(
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(children: [
                        StreamBuilder(
                            stream: ref.snapshots(),
                            builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
                              return Expanded(
                                  child: snapshot.hasData
                                      ? ListView.builder(
                                    key: key,

                                    itemCount: snapshot.data.docs.length,

                                    itemBuilder: (context, index) {
                                      Map<String, dynamic> doc =
                                      snapshot.data.docs[index].data();
                                        return buildItem(
                                            new CustomOrder(
                                                doc
                                            ),
                                            index);

                                      // return SizedBox(height: 0,);
                                    },
                                  )
                                      : Center(child: Text("No data found")));
                            }),

                      ]),
                    ),
                  ),
                  Center(
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(children: [
                        StreamBuilder(
                            stream: ref.snapshots(),
                            builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
                              return Expanded(
                                  child: snapshot.hasData
                                      ? ListView.builder(
                                    key: key2,

                                    itemCount: snapshot.data.docs.length,

                                    itemBuilder: (context, index) {
                                      Map<String, dynamic> doc =
                                      snapshot.data.docs[index].data();

                                        return buildItem(
                                            new CustomOrder(
                                                doc
                                            ),
                                            index);

                                      // return SizedBox(height: 0,);

                                    },
                                  )
                                      : Center(child: Text("No data found")));
                            }),
                      ]),
                    ),
                  ),

                ],
              ),
            ),
          ),
          Container(
            width: SizeConfig.safeBlockHorizontal * 95,
            height: SizeConfig.safeBlockHorizontal * 11,
            margin: EdgeInsets.fromLTRB(
                SizeConfig.safeBlockHorizontal * 2,
                SizeConfig.safeBlockVertical * 2,
                SizeConfig.safeBlockHorizontal * 2,
                SizeConfig.safeBlockVertical * 2),
            decoration: BoxDecoration(
                border: Border.all(
                  width: 3,
                  color: Color(0xff1C52DB),
                ),
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3.0),
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Color(0xff1C52DB).withOpacity(0.5);
                    },
                  ),
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AddOrderCustom();
                      });
                },
                child: Text(
                  "Create a new order",
                  style: TextStyle(
                    color: Color(0xff1C52DB),
                    fontFamily: "Montserrat",
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildItem(item, int index) =>
      ListItemWidget(
        item: item,
        // onIconClicked: () => null,
        onItemClicked: (item) {
          // openOptionDialog(index: index, item: item);
          print("clicked");
        },
      );

}



