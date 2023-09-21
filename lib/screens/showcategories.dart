import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:vetplanet/models/productcategorylist.dart';

import '../apicontrollers/shopcontroller.dart';
import '../constant/colors.dart';

class showcategories extends StatefulWidget {
  var shopid, speciesid, categoryid,iscategoryselected;
  List<ProductCategoryList> productcategorylist;
  showcategories(this.shopid, this.speciesid, this.categoryid, this.iscategoryselected, {Key key})
      : super(key: key);

  @override
  State<showcategories> createState() => _showcategoriesState();
}

class _showcategoriesState extends State<showcategories> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        width: 200,
        alignment: Alignment.bottomCenter,
        child: showCategoriesList());
  }

  showCategoriesList() {
    return FutureBuilder(
        future: new ShopController()
            .getProductCategoryList(widget.shopid, widget.speciesid)
            .then((value) {
          widget.productcategorylist = value;
        }),
        builder: (BuildContext context,
            AsyncSnapshot<ProductCategoryList> snapshot) {
          if (widget.productcategorylist == null ||
              widget.productcategorylist.length == 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    height: 5,
                    width: 5,
                    child: CircularProgressIndicator(
                      color: appColor,
                    )),
              ],
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text(
                    "Show Categories",
                    style: TextStyle(
                        fontFamily: "Camphor",
                        fontWeight: FontWeight.w600,
                        fontSize: 20.0),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //     crossAxisCount: 1,
                    //     crossAxisSpacing: 0.0,
                    //     mainAxisSpacing: 0.0),
                    itemCount: widget.productcategorylist.length,
                    itemBuilder: (BuildContext context, int index) {
                      return widget.productcategorylist.length != 0 ||
                              widget.productcategorylist != null
                          ? InkWell(
                              onTap: () {
                                widget.categoryid =
                                    widget.productcategorylist[index].pcId;
                              },
                              child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        widget.productcategorylist[index]
                                            .pCategName,
                                        style: TextStyle(
                                            color: appColor,
                                            fontFamily: "Camphor",
                                            fontWeight: FontWeight.w400,
                                            fontSize: 20.0),
                                      ),
                                    ],
                                  )),
                            )
                          : CircularProgressIndicator();
                    },
                  ),
                ),
              ],
            );
          }
        });
  }
}
