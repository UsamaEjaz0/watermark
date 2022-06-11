import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:watermark/dialogs/add_order.dart';
import 'package:watermark/dialogs/view_order.dart';
import 'package:watermark/dialogs/view_order_custom.dart';
import 'package:watermark/models/custom_order.dart';
import 'package:watermark/models/order.dart';
import 'package:watermark/utils/app_config.dart';
import 'package:watermark/widgets/custom_list_item.dart';

class PendingTasks extends StatefulWidget {
  @override
  _PendingTasksState createState() => _PendingTasksState();
}

class _PendingTasksState extends State<PendingTasks> {
  final key = GlobalKey<AnimatedListState>();

  CollectionReference ref = FirebaseFirestore.instance.collection('CustomData');


  @override
  Widget build(BuildContext ctxt) {
    SizeConfig().init(ctxt);
    return Container(
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

                            Map<String, dynamic> doc = snapshot.data.docs[index].data();
                            if (doc['status'] == "pending"){
                              return buildItem(
                                  new CustomOrder(doc
                                  ),
                                  index, snapshot.data.docs[index].reference);

                            }else{
                              return SizedBox(height: 0,);
                            }


                          },
                        )
                      : Center(child: Text("No data found")));
            }),
      ]),
    );
  }

  // @override
  // void didUpdateWidget(DataEntry oldWidget) {
  //   rebuildAllChildren(context);
  //   print("Updated");
  // }

  Widget buildItem(CustomOrder item, int index, DocumentReference docRef) {
    return ListItemWidget(
      item: item,
      // onIconClicked: () => null,
      onItemClicked: (item) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return ViewOrderCustom(order: item, docRef: docRef,);
            });
      },
    );
  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }
// void editItem(int index, Order item) {
//   removeItem(index);
//   items.insert(0, item);
//   key.currentState.insertItem(0);
// }
//
// void insertItem(Order item) {
//   items.insert(0, item);
//   key.currentState.insertItem(0);
//   optionCount++;
// }
//
// void removeItem(int index) {
//   final item = items.removeAt(index);
//
//   key.currentState.removeItem(
//     index,
//     (context, animation) => buildItem(item, index, animation),
//   );
//   if (items.length == 0) {
//     setState(() {});
//     optionCount = 1;
//   }
// }
}
