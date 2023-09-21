import 'package:flutter/material.dart';
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/models/products.dart';
import 'package:vetplanet/screens/productsdetails.dart';

class ExpandableListView extends StatefulWidget {
  Products productlist;
  var shopName;
  TickerFuture forward;
  ExpandableListView(
    this.shopName,
    this.productlist,
    this.forward, {
    Key key,
  }) : super(key: key);

  @override
  _ExpandableListViewState createState() => new _ExpandableListViewState();
}

class _ExpandableListViewState extends State<ExpandableListView> {
  bool expandFlag = false;
  var isnotadded = true;
  var counter = 0;
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
      child: new Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              setState(() {
                expandFlag = !expandFlag;
              });
            },
            child: new Container(
              decoration: BoxDecoration(
                  color: appColorlight,
                  borderRadius: BorderRadius.circular(10)),
              padding: new EdgeInsets.only(left: 10.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text(
                    widget.productlist.subCatgName,
                    style: new TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: "Camphor",
                        fontSize: 17),
                  ),
                  new IconButton(
                      icon: new Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: new BoxDecoration(
                          // color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                        child: new Center(
                          child: new Icon(
                            expandFlag
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.white,
                            size: 30.0,
                          ),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          expandFlag = !expandFlag;
                        });
                      }),
                ],
              ),
            ),
          ),
          new ExpandableContainer(
              expanded: expandFlag,
              child: new ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProductDetails(
                            widget.productlist.shopPrdList[index].productId,
                            widget.shopName),
                      ));
                    },
                    child: new Container(
                      //padding: EdgeInsets.only(top: 20),
                      // margin:
                      //     EdgeInsets.only(top: 5, left: 2, right: 2, bottom: 0),
                      decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border:
                              new Border.all(width: 1.0, color: appColorlight),
                          color: Colors.white),
                      child: new ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              // padding: isnotadded
                              //     ? EdgeInsets.only(top: 5, bottom: 0)
                              //     : EdgeInsets.only(top: 5, bottom: 10),
                              // margin: EdgeInsets.only(top: 12, left: 0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  new Text(
                                    widget.productlist.shopPrdList[index]
                                        .prodName,
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: appColorlight,
                                        fontFamily: "camphor"),
                                  ),
                                  new Text(
                                    widget.productlist.shopPrdList[index]
                                        .pCategName,
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: appColorlight,
                                        fontSize: 12,
                                        fontFamily: "camphor"),
                                  ),
                                  Text(
                                    "₹ " +
                                        widget.productlist.shopPrdList[index]
                                            .prodRate,
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: appColorlight,
                                        fontFamily: "camphor",
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  widget.productlist.shopPrdList[index].prodImg,
                                ),
                                isnotadded
                                    ? Container(
                                        //color: appColor,
                                        alignment: Alignment.bottomRight,
                                        padding: EdgeInsets.only(
                                            top: 2.0, bottom: 12, left: 10),
                                        child: ElevatedButton.icon(
                                          style: ButtonStyle(
                                              shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: appColorlight),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                              ),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.white)),
                                          onPressed: () {
                                            if (isnotadded == true) {
                                              setState(() {
                                                widget.forward;
                                                counter++;
                                                isnotadded = false;
                                              });
                                            }
                                          },
                                          label: Text(
                                            "Add",
                                            style:
                                                TextStyle(color: appColorlight),
                                          ),
                                          icon: Icon(
                                            Icons.add,
                                            color: appColorlight,
                                          ),
                                        ),
                                      )
                                    : showCountedItems(),
                              ],
                            )
                          ],
                        ),
                        // trailing: new Image.network(
                        //     widget.productlist.shopPrdList[index].prodImg,fit: BoxFit.fitWidth),
                      ),
                    ),
                  );
                },
                itemCount: widget.productlist.shopPrdList.length,
              ))
        ],
      ),
    );
  }

  showCountedItems() {
    return Container(
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: appColorlight)),
      margin: EdgeInsets.only(right: 0, left: 40),
      padding: EdgeInsets.only(left: 10, right: 15, top: 2, bottom: 2),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
                onTap: () {
                  setState(() {
                    counter++;
                  });
                },
                child: Icon(
                  Icons.add,
                  color: appColor,
                  size: 17,
                )),
            Text(
              counter.toString(),
              style: TextStyle(
                  color: appColor, fontSize: 15, fontWeight: FontWeight.w400),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  counter--;
                  if (counter == 0) {
                    isnotadded = true;
                  }
                });
              },
              child: Text(
                "-",
                style: TextStyle(
                    color: appColor, fontSize: 25, fontWeight: FontWeight.w400),
              ),
            ),
          ]),
    );
  }
}

class ExpandableContainer extends StatelessWidget {
  final bool expanded;
  final double collapsedHeight;
  final double expandedHeight;
  final Widget child;

  ExpandableContainer({
    @required this.child,
    this.collapsedHeight = 0.0,
    this.expandedHeight = 300.0,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return new AnimatedContainer(
      duration: new Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: screenWidth,
      height: expanded ? collapsedHeight : expandedHeight,
      child: new Container(
        child: child,
        decoration: new BoxDecoration(
            //   border: new Border.all(width: 1.0, color: appColor)
            ),
      ),
    );
  }
}
