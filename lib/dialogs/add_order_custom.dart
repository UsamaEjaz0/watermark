import 'dart:collection';
import 'dart:ui';
import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Utils/app_config.dart';

// ignore: must_be_immutable
class AddOrderCustom extends StatefulWidget {

  @override
  _AddOrderCustomState createState() => _AddOrderCustomState();
}

class _AddOrderCustomState extends State<AddOrderCustom> {
  var textController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  CollectionReference ref = FirebaseFirestore.instance.collection('Test');
  String value = "";
  TextEditingController _orderDateController= TextEditingController();

  Map<String, Object> fields = new HashMap();


  Map<String, String> values = new HashMap();

  _AddOrderCustomState(){
    values['status'] = "pending";
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
        height: SizeConfig.safeBlockVertical * 85,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(9),
        ),
        child: SingleChildScrollView(
          child: Column(
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
                          "Create Order",
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
                height: SizeConfig.safeBlockVertical * 67,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      SizeConfig.safeBlockHorizontal * 3.5,
                      SizeConfig.safeBlockVertical * 2.5,
                      SizeConfig.safeBlockHorizontal * 2.5,
                      SizeConfig.safeBlockVertical * 3.5),
                  child:  Form(
                    key: _formKey,
                    child: StreamBuilder(
                      stream: ref.snapshots(),
                      builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {

                        if (snapshot.hasData)
                        for (int i=0; i < snapshot.data.docs.length; i++){
                          Map<String, dynamic> doc  = snapshot.data.docs[i].data();
                          print(doc.keys);
                          fields[doc.keys.toString()] = doc[doc.keys];
                          // fields[]
                        }
                        return snapshot.hasData? Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: fields.entries.map((entry) {
                            Widget w;
                            w = SizedBox(
                              height: SizeConfig.safeBlockVertical * 7,
                              child: TextFormField(
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


                        ) :
                            Text("Loading");
                      }
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
                          //   "clientName" : clientName,
                          //   "orderDate": orderDate,
                          //   "jobTitle" : jobTitle,
                          //   "jobNature" : jobNature,
                          //   "orderQuantity" : orderQuantity,
                          //   "size" : size,
                          //   "status" : "pending",
                          //   "type": dropdownvalue
                          // };

                          CollectionReference collectionReference = FirebaseFirestore.instance.collection('CustomData');
                          collectionReference.add(values);
                          Navigator.pop(context, true);
                        }

                      },
                      child: Text(
                        "Save",
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
          ),
        ),
      ),
    );
  }


}
