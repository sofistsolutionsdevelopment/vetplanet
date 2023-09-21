// ignore: implementation_imports
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:vetplanet/constant/colors.dart';

import '../apicontrollers/shopcontroller.dart';
import '../models/ProductDetail.dart';

class ProductDetails extends StatefulWidget {
  var productId, shopName;
  List<ProductDetail> productDetailslist;
  ProductDetails(this.productId, this.shopName, {Key key}) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  var counter = 0;
  var isnotadded = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appColor,
          title: Text("Product Details"),
        ),
        body: FutureBuilder(
            future: new ShopController()
                .GetProductDetails(widget.productId)
                .then((value) {
              widget.productDetailslist = value;
            }),
            builder:
                (BuildContext context, AsyncSnapshot<ProductDetails> snapshot) {
              if (widget.productDetailslist == null) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
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
                return Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 500,height: 600,
                      child: ListView.builder(
                        itemCount: widget.productDetailslist.length,
                        itemBuilder: (BuildContext context, int index) {
                          return productDetailsCard(
                              widget.productDetailslist[index]);
                        },
                      ),
                    ),
                    Container(
                        //width: 500,
                        height: 50,
                        //margin: EdgeInsets.only(top: 100),
                        color: appColor,
                        alignment: Alignment.bottomCenter,
                        // margin: EdgeInsets.symmetric(horizontal: 20,vertical: 50),
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(appColor)),
                          onPressed: () {},
                          child: Text(
                            "Add To Bag",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Camphor",
                                fontWeight: FontWeight.w700,
                                fontSize: 20.0),
                          ),
                        ),
                      )
                
                  ],
                );
              }
            }));
  }

  Widget productDetailsCard(ProductDetail productDetailslist) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: [
            Container(
                padding: EdgeInsets.all(5),
                height: MediaQuery.of(context).size.height / 3,
                child: Image.network(
                  productDetailslist.prodImg,
                  fit: BoxFit.fill,
                )),
            Container(
              margin: EdgeInsets.only(left: 5, right: 5, top: 10),
              decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: new Border.all(width: 1.0, color: appColorlight),
                  color: Colors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        productDetailslist.prodName,
                        style: TextStyle(
                            color: appColor,
                            fontFamily: "Camphor",
                            fontWeight: FontWeight.w700,
                            fontSize: 18.0),
                      )),
                  Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        productDetailslist.weight,
                        style: TextStyle(
                            color: appColor,
                            fontFamily: "Camphor",
                            fontWeight: FontWeight.w700,
                            fontSize: 12.0),
                      )),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 5, right: 5, top: 10),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            // Container(
            //     alignment: Alignment.topLeft,
            //     padding: EdgeInsets.all(5),
            //     margin: EdgeInsets.only(left: 5, right: 5, top: 10),
            //     child: Text(
            //       widget.shopName,
            //       style: TextStyle(
            //           color: appColor,
            //           fontFamily: "Camphor",
            //           fontWeight: FontWeight.w700,
            //           fontSize: 15.0),
            //     )),
            Container(
                margin: EdgeInsets.only(left: 5, right: 5, top: 10),
                alignment: Alignment.topLeft,
                padding: EdgeInsets.all(5),
                child: Text(
                  productDetailslist.prodDesc,
                  style: TextStyle(
                      color: appColor,
                      fontFamily: "Camphor",
                      fontWeight: FontWeight.w700,
                      fontSize: 15.0),
                )),
            Container(
                margin: EdgeInsets.only(left: 5, right: 5, top: 10),
                alignment: Alignment.topLeft,
                padding: EdgeInsets.all(5),
                child: Text(
                  productDetailslist.prodShortDesc,
                  style: TextStyle(
                      color: appColor,
                      fontFamily: "Camphor",
                      fontWeight: FontWeight.w700,
                      fontSize: 15.0),
                )),
            Container(
              margin: EdgeInsets.only(left: 5, right: 5, top: 10),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 5, right: 5, top: 10),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.all(5),
                      child: Text(
                        "₹ " + productDetailslist.prodRate,
                        style: TextStyle(
                            color: appColor,
                            fontFamily: "Camphor",
                            fontWeight: FontWeight.w700,
                            fontSize: 20.0),
                      )),
                  showCountedItems()
                ],
              ),
            ),
          ]),
        ],
      ),
    );
  }

  showCountedItems() {
    return Container(
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: appColor)),
      margin: EdgeInsets.only(right: 0, left: 0),
      padding: EdgeInsets.symmetric(horizontal: 20),
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
            SizedBox(
              width: 20,
            ),
            Text(
              counter.toString(),
              style: TextStyle(
                  color: appColor, fontSize: 15, fontWeight: FontWeight.w400),
            ),
            SizedBox(
              width: 20,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  counter--;
                  if (counter <= 0) {
                    counter = 0;
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
