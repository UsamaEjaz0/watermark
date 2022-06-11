import 'dart:collection';
import 'dart:ui';
import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:watermark/models/order.dart';
import '../Utils/app_config.dart';
import '../models/custom_order.dart';

// ignore: must_be_immutable
class ViewOrderCustom extends StatefulWidget {
  CustomOrder order;
  DocumentReference docRef;

  ViewOrderCustom({this.order, this.docRef});

  @override
  _ViewOrderCustomState createState() => _ViewOrderCustomState();
}

class _ViewOrderCustomState extends State<ViewOrderCustom> {
  var textController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Map<String, Object> fields = new HashMap();

  CollectionReference ref = FirebaseFirestore.instance.collection('CustomData');

  Map<String, String> values = new HashMap();
  String value = "";

  Map<String, TextEditingController> controllers= new HashMap();

  @override
  initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: SizeConfig.safeBlockHorizontal * 92,
        height: SizeConfig.safeBlockVertical * 80,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(9),
        ),
        child: SingleChildScrollView(
          child: StreamBuilder(
              stream: ref.snapshots(),
              builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
                // for (int i=0; i < snapshot.data.docs.length; i++){
                //   Map<String, dynamic> doc  = snapshot.data.docs[i].data();
                //
                //   fields[doc.keys.] = doc[doc.keys];
                //   print(doc);
                //   // fields[]
                // }

              return  snapshot.hasData? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                                SizeConfig.safeBlockHorizontal * 3.2,
                                SizeConfig.safeBlockVertical * 1.5,
                                0,
                                SizeConfig.safeBlockVertical * 2),
                            child: Text(
                              widget.order.props[widget.order.props.keys.first],
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Color(0xff717171),
                              ),
                            ),
                          )),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: Icon(
                            Icons.close,
                          ),
                          iconSize: 20,
                          color: Color(0xff717171),
                          splashColor: Colors.purple,
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: SizeConfig.safeBlockHorizontal * 88,
                    height: SizeConfig.safeBlockVertical * 65,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          SizeConfig.safeBlockHorizontal * 3.5,
                          SizeConfig.safeBlockVertical * 2.5,
                          SizeConfig.safeBlockHorizontal * 2.5,
                          SizeConfig.safeBlockVertical * 3.5),
                      child:  Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: widget.order.props.entries.map((entry) {
                            //
                            controllers[entry.key] = new TextEditingController();
                            controllers[entry.key].text = widget.order.props[entry.key];

                            Widget w;
                            w = SizedBox(
                              height: SizeConfig.safeBlockVertical * 7,
                              child: TextFormField(
                                controller: controllers[entry.key],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                onChanged: (val){
                                  setState(() {
                                    values[entry.key] = val;
                                  });

                                },
                                decoration:  InputDecoration(
                                  labelText: entry.key,
                                  labelStyle: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xffB7B7B7)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color:  Color(0xff1C52DB), width: 2.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xffB7B7B7), width: 2.0),
                                  ),
                                ),
                              ),
                            );

                            return w;
                          }).toList(),
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Color(0xffF6F6F6),
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          0,
                          SizeConfig.safeBlockVertical * 1.5,
                          SizeConfig.safeBlockHorizontal * 2.5,
                          0),
                      child: Container(
                        width: SizeConfig.safeBlockHorizontal * 28,
                        height: SizeConfig.safeBlockVertical * 5.5,
                        child: TextButton(
                          onPressed: () {

                            if (_formKey.currentState.validate()) {
                              // Map<String, dynamic> data = {
                              //   "clientName" : _clientNameController.text,
                              //   "orderDate": _orderDateController.text,
                              //   "jobTitle" : _jobTitleController.text,
                              //   "jobNature" : _jobNatureController.text,
                              //   "orderQuantity" : _orderQuantityController.text,
                              //   "size" : _sizeController.text,
                              //   "status" : "complete"
                              // };

                              values['status'] = "completed";
                              widget.docRef.update(values).whenComplete(() => Navigator.pop(context, true));


                            }

                          },
                          child: Text(
                            "Complete",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(Color(0xff1C52DB))),
                        ),
                      ),
                    ),
                  )
                ],
              ) :
              Text("Nothing bs aese hee");
            }
          ),
        ),
      ),
    );
  }


}
