import 'dart:ui';
import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:watermark/models/order.dart';
import '../Utils/app_config.dart';

// ignore: must_be_immutable
class ViewOrder extends StatefulWidget {
  Order order;
  DocumentReference docRef;

  ViewOrder({this.order, this.docRef});

  @override
  _ViewOrderState createState() => _ViewOrderState();
}

class _ViewOrderState extends State<ViewOrder> {
  var textController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String value = "";
  TextEditingController _clientNameController= TextEditingController();
  TextEditingController _orderDateController= TextEditingController();
  TextEditingController _jobTitleController= TextEditingController();
  TextEditingController _jobNatureController= TextEditingController();
  TextEditingController _orderQuantityController= TextEditingController();
  TextEditingController _sizeController= TextEditingController();

  @override
  initState(){
    _clientNameController.text = widget.order.clientName;
    _orderDateController.text = widget.order.orderDate;
    _jobTitleController.text = widget.order.jobTitle;
    _jobNatureController.text = widget.order.jobNature;
    _orderQuantityController.text = widget.order.orderQuantity;
    _sizeController.text = widget.order.size;

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
        height: SizeConfig.safeBlockVertical * 72,
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
                          widget.order.clientName,
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
                height: SizeConfig.safeBlockVertical * 55,
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
                      children: <Widget>[
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 7,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.datetime,
                            controller: _orderDateController..text,
                            decoration:  InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2019, 1),
                                      lastDate: DateTime(2025,12),
                                      builder: (context,picker){
                                        return picker;
                                      }

                                  ).then((selectedDate) {
                                    if(selectedDate!=null){
                                      String orderDate = (selectedDate.day.toString() + "/" + selectedDate.month.toString() + "/" + selectedDate.year.toString());
                                      _orderDateController.text = orderDate;
                                    }
                                  });
                                },
                                icon: Icon(Icons.calendar_today,
                                  color: Color(0xff1C52DB),
                                ),
                              ),
                              labelText: 'Order Date',
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
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 7,
                          child: Container(
                            child: TextFormField(

                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              controller: _jobTitleController..text,
                              decoration:  InputDecoration(
                                labelText: 'Job Title',
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
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 7,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            controller: _jobNatureController..text,
                            decoration:  InputDecoration(
                              labelText: 'Job Nature',
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
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 7,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            controller: _orderQuantityController..text,
                            keyboardType: TextInputType.number,
                            decoration:  InputDecoration(

                              labelText: 'Order Quantity',
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
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 7,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            controller: _sizeController..text,
                            keyboardType: TextInputType.number,
                            decoration:  InputDecoration(

                              labelText: 'Size',
                              labelStyle: TextStyle(
                                  fontSize: 16,
                                  color:Color(0xffB7B7B7)
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color:  Color(0xff1C52DB), width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xffB7B7B7), width: 2.0),
                              ),
                            ),
                          ),
                        ),
                      ],
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
                          Map<String, dynamic> data = {
                            "clientName" : _clientNameController.text,
                            "orderDate": _orderDateController.text,
                            "jobTitle" : _jobTitleController.text,
                            "jobNature" : _jobNatureController.text,
                            "orderQuantity" : _orderQuantityController.text,
                            "size" : _sizeController.text,
                            "status" : "complete"
                          };

                          widget.docRef.update(data).whenComplete(() => Navigator.pop(context, true));


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
          ),
        ),
      ),
    );
  }


}
