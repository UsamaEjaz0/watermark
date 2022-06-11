import 'dart:ui';
import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Utils/app_config.dart';
import 'dart:collection';

// ignore: must_be_immutable
class Settings extends StatefulWidget {

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var textController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String value = "";
  TextEditingController _orderDateController= TextEditingController();


  String dropdownvalue = 'Offset';
  var _currentSelectedValue = "Text";

  // List of items in our dropdown menu
  var items = [
    'Offset',
    'Packages'
  ];
  var _currencies = [
    "Text",
    "Number",
    "Date",
  ];

  Map<String, Object> fields = new HashMap();

  var textFieldName;




  @override
  Widget build(BuildContext context) {
    CollectionReference ref = FirebaseFirestore.instance.collection('Test');

    final key = GlobalKey<AnimatedListState>();
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(title: Text("Customize Form"),),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Container(
            height: SizeConfig.safeBlockVertical * 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top:30),
                  child: Text("Customize Text Fields"),
                ),
                StreamBuilder(
                  stream: ref.snapshots(),
                  builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {

                    if (snapshot.hasData)
                    for (int i=0; i < snapshot.data.docs.length; i++){
                      Map<String, dynamic> doc  = snapshot.data.docs[i].data();
                      print(doc.keys);
                      fields[doc.keys.toString()] = doc[doc.keys];
                        // fields[]
                    }
                    return snapshot.hasData?
                     Column(
                      children: fields.entries.map((entry) {
                        Widget w;
                        switch (entry.value){
                          case "Text":
                            w = SizedBox(
                              width: SizeConfig.safeBlockHorizontal * 65,
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                onChanged: (val){
                                  // setState(() {
                                  //   textFieldName = val;
                                  // });
                                },
                                decoration:  InputDecoration(
                                  labelText: entry.key,
                                  labelStyle: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xffB7B7B7)
                                  ),

                                ),
                              ),
                            );
                            break;

                          case "Number":
                            w = SizedBox(
                              width: SizeConfig.safeBlockHorizontal * 65,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                onChanged: (val){
                                  // setState(() {
                                  //   textFieldName = val;
                                  // });
                                },
                                decoration:  InputDecoration(
                                  labelText: entry.key,
                                  labelStyle: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xffB7B7B7)
                                  ),

                                ),
                              ),
                            );
                            break;


                          default:
                            w = SizedBox(
                              width: SizeConfig.safeBlockHorizontal * 65,
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                onChanged: (val){
                                  // setState(() {
                                  //   textFieldName = val;
                                  // });
                                },
                                decoration:  InputDecoration(
                                  labelText: entry.key,
                                  labelStyle: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xffB7B7B7)
                                  ),

                                ),
                              ),
                            );
                            break;


                        }

                        return w;
                      }).toList(),
                    )
                    :
                     Text("Hi");
                  }
                ),
                Center(
                  child: ElevatedButton(onPressed: (){
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text("Add Field"),
                        content: Container(
                          height: 140,
                          child: Column(
                            children:  [
                              SizedBox(
                                width: SizeConfig.safeBlockHorizontal * 65,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  onChanged: (val){
                                    setState(() {
                                      textFieldName = val;
                                    });
                                  },
                                  decoration:  InputDecoration(
                                    labelText: 'Enter TextField Title',
                                    labelStyle: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xffB7B7B7)
                                    ),

                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: SizeConfig.safeBlockHorizontal * 65,
                                child: FormField<String>(
                                  builder: (FormFieldState<String> state) {
                                    return InputDecorator(
                                      decoration: InputDecoration(
                                          errorStyle: TextStyle(color: Colors.redAccent, fontSize: 12.0),
                                          hintText: 'Please select option',
                                          ),

                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: _currentSelectedValue,
                                          isDense: true,
                                          onChanged: (String newValue) {
                                            setState(() {
                                              _currentSelectedValue = newValue;
                                              state.didChange(newValue);
                                            });
                                          },
                                          items: _currencies.map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () async {

                              Navigator.of(ctx).pop();
                              print(fields.keys);
                              Map<String, String> oneField = new HashMap();
                              oneField[textFieldName] = _currentSelectedValue;
                              CollectionReference collectionReference = FirebaseFirestore.instance.collection('Test');
                              collectionReference.add(oneField);
                            },
                            child: Text("Add"),
                          ),
                        ],
                      ),
                    );
                  }, child: Text("+")),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


}
