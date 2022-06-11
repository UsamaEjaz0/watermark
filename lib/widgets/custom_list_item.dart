import 'package:flutter/material.dart';
import 'package:watermark/models/custom_order.dart';
import 'package:watermark/models/order.dart';
import 'package:watermark/utils/app_config.dart';

class ListItemWidget extends StatelessWidget {
  final CustomOrder item;
  // final VoidCallback onIconClicked;
  final Function onItemClicked;

  const ListItemWidget({
    @required this.item,
    // @required this.onIconClicked,
    @required this.onItemClicked,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      height: SizeConfig.safeBlockVertical * 6.5,
      margin: EdgeInsets.fromLTRB(
          SizeConfig.safeBlockHorizontal * 2,
          SizeConfig.safeBlockVertical * 2,
          SizeConfig.safeBlockHorizontal * 2,
          SizeConfig.safeBlockVertical * 0),

      child: Material(
        child: Ink(
          decoration: BoxDecoration(
        borderRadius: BorderRadius.all(const Radius.circular(4.0)),

            color: Color(0xff1C52DB),
    ),
          child: InkWell(
            onTap: () {
              onItemClicked(item);
            },
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: Text(
                          "${item.props[item.props.keys.first]}",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  item.props['status'] == "complete" ? IconButton(
                    icon: Icon(Icons.check_circle,
                        color: Colors.white, size: 23),
                    onPressed: null,
                  ) : IconButton(
                    icon: Icon(Icons.assignment_late_rounded,
                        color: Colors.white, size: 23),
                    onPressed: null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
