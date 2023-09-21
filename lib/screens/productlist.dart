import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:vetplanet/apicontrollers/shopcontroller.dart';
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/models/products.dart';
import 'package:vetplanet/screens/productsdetails.dart';
import 'package:vetplanet/screens/showcategories.dart';

import '../models/productcategorylist.dart';
import '../models/specieslist.dart';
import 'ExpandableList.dart';
import 'orderspage.dart';

class ProductList extends StatefulWidget {
  var shopid, pCategName, ShopName, rating, latitude, longitude;
  bool expandFlag = false;
  ProductList(this.shopid, {Key key}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList>
    with SingleTickerProviderStateMixin {
  List<Products> productlist;
  List<Specieslist> specieslist;
  List<ProductCategoryList> productCategoryList;
  TextEditingController editingController = TextEditingController();
  AnimationController _controller;
  Animation<Offset> _animation;
  var speciesId = 5, categoryid = 1;
  var liked = false;
  final bool expanded = true;
  final double collapsedHeight = 0.0;
  bool expandFlag = false;
  var isnotadded = true;
  var counter = 0;
  var isspeciesselected = true;
  var iscategoryselected = true;
  final double expandedHeight = 300.0;
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _animation = Tween<Offset>(begin: Offset(0, 1), end: Offset.zero)
        .animate(_controller);

    getspeciesList();

    // _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return products(speciesId, categoryid);
  }

  getspeciesList() async {
    await new ShopController().getSpeciesList(widget.shopid).then(
      (value) {
        specieslist = value;
        speciesId = specieslist[0].speciesId;
        getCategorylist(speciesId);
      },
    );
  }

  getCategorylist(var speciesid) {
    new ShopController().getProductCategoryList(widget.shopid, speciesid).then(
      (value) {
        productCategoryList = value;
        categoryid = productCategoryList[0].pcId;
        speciesId = productCategoryList[0].speciesId;
      },
    );
  }

  showProductsList(var speciesid, var categoryid) {
    if (speciesid != 0 && categoryid != 0) {
      return FutureBuilder(
          future: new ShopController()
              .getProductList(widget.shopid, categoryid, speciesid)
              .then((value) {
            productlist = value;
          }),
          builder: (BuildContext context, AsyncSnapshot<ProductList> snapshot) {
            if (productlist == null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Center(
                    child: Container(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(
                          color: appColor,
                        )),
                  ),
                ],
              );
            } else if (productlist == null && productlist.length == 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Center(
                    child: Container(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(
                          color: appColor,
                        )),
                  ),
                ],
              );
            } else {
              return Expanded(
                child: ListView.builder(
                  itemCount: productlist.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new Container(
                      margin: EdgeInsets.only(top: 10),
                      child: new Column(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              setState(() {
                                widget.expandFlag = !widget.expandFlag;
                              });
                            },
                            child: new Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(0)),
                              padding: new EdgeInsets.only(left: 10.0),
                              child: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new Text(
                                    productlist[index].subCatgName,
                                    style: new TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                        fontFamily: "Camphor",
                                        fontSize: 17),
                                  ),
                                  new IconButton(
                                      icon: new Container(
                                        height: 50.0,
                                        width: 50.0,
                                        child: new Center(
                                          child: new Icon(
                                            widget.expandFlag
                                                ? Icons.keyboard_arrow_up
                                                : Icons.keyboard_arrow_down,
                                            color: Colors.black,
                                            size: 30.0,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          widget.expandFlag =
                                              !widget.expandFlag;
                                        });
                                      }),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            child: new ExpandableContainer(
                                expanded: widget.expandFlag,
                                child: new ListView.builder(
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      color: Colors.white,
                                      child: InkWell(
                                          onTap: () {},
                                          child: Container(
                                            color: Colors.white,
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      left: 10, top: 0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .push(
                                                              MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProductDetails(
                                                                productlist[
                                                                        index]
                                                                    .shopPrdList[
                                                                        index]
                                                                    .productId,
                                                                widget
                                                                    .ShopName),
                                                      ));
                                                    },
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 2.0),
                                                          child: Text(
                                                            productlist[index]
                                                                .shopPrdList[
                                                                    index]
                                                                .prodName,
                                                            maxLines: 4,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: new TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    "camphor"),
                                                          ),
                                                        ),
                                                        // Padding(
                                                        //   padding:
                                                        //       const EdgeInsets
                                                        //           .all(2.0),
                                                        //   child: Text(
                                                        //     productlist[index]
                                                        //         .shopPrdList[
                                                        //             index]
                                                        //         .prodName
                                                        //         .substring(
                                                        //             9,
                                                        //             productlist[index]
                                                        //                     .shopPrdList[index]
                                                        //                     .prodName
                                                        //                     .length -
                                                        //                 1),
                                                        //     maxLines: 4,
                                                        //     overflow:
                                                        //         TextOverflow
                                                        //             .ellipsis,
                                                        //     style: new TextStyle(
                                                        //         fontSize: 16,
                                                        //         fontWeight:
                                                        //             FontWeight
                                                        //                 .w500,
                                                        //         color: Colors
                                                        //             .black,
                                                        //         fontFamily:
                                                        //             "camphor"),
                                                        //   ),
                                                        // ),

                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      2.0,
                                                                  vertical: 7),
                                                          child: Text(
                                                            "₹" +
                                                                productlist[
                                                                        index]
                                                                    .shopPrdList[
                                                                        index]
                                                                    .prodRate,
                                                            style: new TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    "camphor"),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child: Text(
                                                            productlist[index]
                                                                .shopPrdList[
                                                                    index]
                                                                .pCategName,
                                                            style: new TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .grey
                                                                    .shade600,
                                                                fontFamily:
                                                                    "camphor"),
                                                          ),
                                                        ),
                                                        Text(
                                                          productlist[index]
                                                              .shopPrdList[
                                                                  index]
                                                              .prodShortDesc,
                                                          style: new TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  "camphor"),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      height: 90,
                                                      width: 90,
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .push(
                                                                  MaterialPageRoute(
                                                            builder: (context) =>
                                                                ProductDetails(
                                                                    productlist[
                                                                            index]
                                                                        .shopPrdList[
                                                                            index]
                                                                        .productId,
                                                                    widget
                                                                        .ShopName),
                                                          ));
                                                        },
                                                        child: Image.network(
                                                          productlist[index]
                                                              .shopPrdList[
                                                                  index]
                                                              .prodImg,
                                                          fit: BoxFit.fitWidth,
                                                        ),
                                                      ),
                                                    ),
                                                    isnotadded
                                                        ? Container(
                                                            child:
                                                                ElevatedButton(
                                                              style:
                                                                  ButtonStyle(
                                                                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              25)),
                                                                      elevation:
                                                                          MaterialStateProperty.all(
                                                                              0),
                                                                      shape: MaterialStateProperty
                                                                          .all(
                                                                        RoundedRectangleBorder(
                                                                          side:
                                                                              BorderSide(color: appColor),
                                                                          borderRadius:
                                                                              BorderRadius.circular(10.0),
                                                                        ),
                                                                      ),
                                                                      backgroundColor:
                                                                          MaterialStateProperty.all(
                                                                              btnColorlight)),
                                                              onPressed: () {
                                                                if (isnotadded ==
                                                                    true) {
                                                                  setState(() {
                                                                    _controller
                                                                        .forward();
                                                                    counter++;
                                                                    isnotadded =
                                                                        false;
                                                                  });
                                                                }
                                                              },
                                                              child: Text(
                                                                "ADD",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    letterSpacing:
                                                                        1,
                                                                    color:
                                                                        appColor),
                                                              ),
                                                            ),
                                                          )
                                                        : showCountedItems()
                                                  ],
                                                )
                                              ],
                                            ),
                                          )),
                                    );
                                  },
                                  itemCount:
                                      productlist[index].shopPrdList.length,
                                )),
                          )
                        ],
                      ),
                    );
                  },
                ),
              );
            }
          });
    } else {
      return Text("No Data Found");
    }
  }

  addCart(var Counter) {
    return SlideTransition(
        position: _animation,
        child: Visibility(
          visible: Counter != 0,
          child: Container(
            decoration: BoxDecoration(
                //border: Border.all(color: appColorlight, width: 1),
                borderRadius: BorderRadius.circular(0),
                color: appColor),
            width: MediaQuery.of(context).size.width,
            // margin: EdgeInsets.only(
            //   left: 30,
            // ),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            alignment: Alignment.bottomCenter,
            //color: appColor,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "You have $Counter item saved in your bag",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Camphor",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 3),
                    padding: EdgeInsets.all(8),
                    // decoration: BoxDecoration(
                    //     border: Border.all(color: appColorlight),
                    //     borderRadius: BorderRadius.circular(14),
                    //     color: Colors.white),
                    child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => OrdersPage(widget.ShopName),
                          ));
                        },
                        child: Text(
                          "View Bag",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w800),
                        )),
                  ),
                ]),
          ),
        ));
  }

  searchhere() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: editingController,
        decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 15),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: appColor),
            ),
            hintText: "Search here....",
            hintStyle: TextStyle(
                color: Colors.grey.shade500,
                fontFamily: "Camphor",
                fontWeight: FontWeight.w600,
                fontSize: 16.0),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Icon(
                Icons.search,
                color: appColor,
                size: 25,
              ),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)))),
        onSubmitted: (value) async {
       
        },
        textInputAction: TextInputAction.search,
      ),
    );
  }

  showShopName() {
    return Container(
      color: appColor,
      height: 105,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 20, top: 15),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.ShopName,
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      width: 80,
                    ),
                    Text(
                      widget.pCategName,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Card(
                  color: Colors.white24,
                  elevation: 0,
                  child: Container(
                    height: 40,
                    width: 165,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(0),
                            topRight: Radius.circular(0),
                            bottomLeft: Radius.circular(10),
                            topLeft: Radius.circular(10))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton.icon(
                          onPressed: () {},
                          icon: Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 15,
                          ),
                          label: Text(
                            widget.rating.toStringAsFixed(1),
                            style:
                                TextStyle(color: Colors.yellow, fontSize: 12),
                          ),
                        ),
                        IconButton(
                          icon: liked
                              ? Image.asset(
                                  "assets/heartfill.png",
                                  color: Colors.red,
                                )
                              : Image.asset(
                                  "assets/heartIcon.png",
                                  color: Colors.white,
                                ),
                          onPressed: () {
                            if (liked == false) {
                              setState(() {
                                liked = true;
                              });
                            } else {
                              setState(() {
                                liked = false;
                              });
                            }
                          },
                        ),
                        SizedBox(
                          width: 0,
                        ),
                        IconButton(
                          icon: Image.asset(
                            "assets/Share.png",
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Share.share(
                                "Check out this product ${widget.ShopName} on vet Planet",
                                subject:
                                    "All About Pets: ${widget.pCategName}");
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            // Container(
            //   decoration: BoxDecoration(
            //     color: Colors.white24,
            //     border: Border.all(color: Colors.white),
            //     borderRadius: BorderRadius.only(
            //       topRight: Radius.circular(20.0),
            //       topLeft: Radius.circular(20.0),
            //     ),
            //   ),
            //   margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            //   padding: EdgeInsets.only(top: 10),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       ElevatedButton.icon(
            //           onPressed: () {},
            //           icon: Icon(
            //             Icons.star,
            //             color: Colors.yellow,
            //           ),
            //           label: Text(
            //             widget.rating.toStringAsFixed(1),
            //             style: TextStyle(fontSize: 12, color: Colors.white),
            //             textAlign: TextAlign.center,
            //           ),
            //           style: ButtonStyle(
            //               shape:
            //                   MaterialStateProperty.all(RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(2),
            //               )),
            //               elevation: MaterialStateProperty.all(0),
            //               backgroundColor: MaterialStateProperty.all<Color>(
            //                   Colors.transparent))),
            //       ElevatedButton.icon(
            //           onPressed: () {},
            //           icon: Icon(
            //             Icons.location_on,
            //             color: Colors.white,
            //           ),
            //           label: Text(
            //             "Location",
            //             style: TextStyle(fontSize: 12, color: Colors.white),
            //             textAlign: TextAlign.center,
            //           ),
            //           style: ButtonStyle(
            //               elevation: MaterialStateProperty.all(0),
            //               shape:
            //                   MaterialStateProperty.all(RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(2),
            //               )),
            //               backgroundColor: MaterialStateProperty.all<Color>(
            //                   Colors.transparent)))
            //     ],
            //   ),
            // ),
          ]),
    );
  }

  showSpecies() {
    return Container(
        margin: EdgeInsetsDirectional.all(4),
        color: Colors.transparent,
        height: 48,
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder(
            future: new ShopController()
                .getSpeciesList(widget.shopid)
                .then((value) {
              specieslist = value;
              getCategorylist(specieslist[0].speciesId);
            }),
            builder:
                (BuildContext context, AsyncSnapshot<Specieslist> snapshot) {
              if (specieslist == null || specieslist.length == 0) {
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
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    filterCard("Filter"),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //     crossAxisCount: 1,
                        //     crossAxisSpacing: 0.0,
                        //     mainAxisSpacing: 0.0),
                        itemCount: specieslist.length,
                        itemBuilder: (BuildContext context, int index) {
                          speciesId = specieslist[index].speciesId;
                          return categoryCard(specieslist[index].speciesName);
                        },
                      ),
                    ),
                  ],
                );
              }
            }));
  }

  categoryCard(String name) {
    return Container(
      height: 10,
      margin: EdgeInsets.only(top: 0),
      padding: EdgeInsets.all(10.0),
      child: isspeciesselected
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                  color: btnColorlight,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: appColor)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: TextStyle(color: Colors.black, fontSize: 13),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                      onTap: () {
                        setState(() {
                          isspeciesselected = false;
                        });
                      },
                      child: Icon(
                        Icons.cancel,
                        size: 15,
                      ))
                ],
              ),
            )
          : ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.grey.shade400))),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  elevation: MaterialStateProperty.all(0)),
              onPressed: () {
                setState(() {
                  isspeciesselected = true;
                });
              },
              child: Text(
                name,
                style: TextStyle(color: Colors.black, fontSize: 13),
              ),
            ),
    );
  }

  filterCard(String name) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (BuildContext bc) {
              return showFilter();
            });
      },
      child: Container(
        height: 30,
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade400)),
        child: InkWell(
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext bc) {
                  return showFilter();
                });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.filter_alt_rounded,
                size: 15,
                color: Colors.black,
              ),
              Text(
                name,
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
              Icon(
                Icons.arrow_drop_down,
                size: 15,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }

  showFilter() {
    return Container(
      decoration: BoxDecoration(
          borderRadius:BorderRadius.all(Radius.circular(20))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "",
                style: TextStyle(
                  fontSize: 21,
                  color: Colors.black,
                  fontFamily: "Camphor",
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0, top: 10, bottom: 5),
                child: Text(
                  "Filter",
                  style: TextStyle(
                    fontSize: 21,
                    color: Colors.black,
                    fontFamily: "Camphor",
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.cancel))
            ],
          ),
          Container(
            color: appColor,
            height: MediaQuery.of(context).size.height / 2,
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "Brand",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontFamily: "Camphor",
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: Divider(
                          color: Colors.grey,
                          height: 1,
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "Breed Size",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontFamily: "Camphor",
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: Divider(
                          color: Colors.grey,
                          height: 1,
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "Product Type`",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontFamily: "Camphor",
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: Divider(
                          color: Colors.grey,
                          height: 1,
                          thickness: 1,
                        ),
                      ),
                    ]),
                Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: VerticalDivider(
                      color: Colors.grey,
                      width: 1,
                    )),
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Text(
                      //   "Brand",
                      //   style: TextStyle(
                      //     fontSize: 18,
                      //     color: Colors.black,
                      //     fontFamily: "Camphor",
                      //     fontWeight: FontWeight.w500,
                      //   ),
                      //   textAlign: TextAlign.center,
                      // ),
                      // Text(
                      //   "Breed Size",
                      //   style: TextStyle(
                      //     fontSize: 18,
                      //     color: Colors.black,
                      //     fontFamily: "Camphor",
                      //     fontWeight: FontWeight.w500,
                      //   ),
                      //   textAlign: TextAlign.center,
                      // ),
                      // Text(
                      //   "Product Type`",
                      //   style: TextStyle(
                      //     fontSize: 18,
                      //     color: Colors.black,
                      //     fontFamily: "Camphor",
                      //     fontWeight: FontWeight.w500,
                      //   ),
                      //   textAlign: TextAlign.center,
                      // ),
                    ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  products(var speciesid, var categoryid) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appColor,
        title: Text(
          "Products",
          style: TextStyle(
              fontFamily: "Camphor",
              fontWeight: FontWeight.w600,
              fontSize: 20.0),
        ),
      ),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Color(0xfff4f6fb),
          child: Column(
            children: [
              // showShopName(),
              showSpecies(),
              Divider(
                color: Colors.grey,
                height: 1,
              ),
              speciesid != 0 && categoryid != 0
                  ? Container(
                      height: 600,
                      width: 500,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          showProductsList(speciesid, categoryid),
                          addCart(counter)
                        ],
                      ),
                    )
                  : Container(
                      child: Center(child: CircularProgressIndicator())),
            ],
          )),
      floatingActionButton: Container(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: counter != 0
                  ? EdgeInsets.only(left: 30, bottom: 32)
                  : EdgeInsets.only(
                      left: 30,
                    ),
              child: ElevatedButton(
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        // side: BorderSide(color: appColor)
                      )),
                      backgroundColor: MaterialStateProperty.all(Colors.black)),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext bc) {
                          return showcategories(
                              widget.shopid,
                              specieslist[0].speciesId,
                              categoryid,
                              iscategoryselected);
                        });
                  },
                  child: Text(
                    "Categories",
                    style: TextStyle(
                        fontFamily: "Camphor",
                        fontWeight: FontWeight.w700,
                        fontSize: 15.0,
                        color: Colors.white),
                  )),
            ),
            SizedBox(height: 10),
            // addCart(),
            // SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  showCountedItems() {
    return Container(
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
          color: appColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: appColorlight)),
      margin: EdgeInsets.only(top: 5),
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: InkWell(
                onTap: () {
                  setState(() {
                    setState(() {
                      counter--;
                      if (counter == 0) {
                        isnotadded = true;
                      }
                    });
                  });
                },
                child: Text(
                  "-",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Text(
                counter.toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: InkWell(
                onTap: () {
                  setState(() {
                    counter++;
                  });
                },
                child: Text(
                  "+",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ]),
    );
  }
}
