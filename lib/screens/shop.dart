
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vetplanet/apicontrollers/shopcontroller.dart';
import 'package:vetplanet/screens/productlist.dart';
import 'package:vetplanet/transitions/slide_route.dart';

import '../constant/colors.dart';
import '../models/shoplist.dart';
import 'orderspage.dart';

class ShopPage extends StatefulWidget {
  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  TextEditingController editingController = TextEditingController();
  List<ShopList> shoplist;
  void rebuildPage() {
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentLocation();
    new ShopController().getShopList(0.0,0.0).then((value) {
      shoplist=value;
    },);
  }

  //final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Position _currentPosition;
  String _currentAddress = "null";
  String _latitude = "";
  String _longitude = "";
  double lat_d;
  double long_d;
  String _searchshops = "";

  _getCurrentLocation() {
    Geolocator
.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      if (_currentPosition != null) {
        _latitude = "72.8428757";
        //_currentPosition.latitude.toString();
        _longitude = "19.019282";
        //_currentPosition.longitude.toString();
        lat_d = double.parse(_latitude);
        long_d = double.parse(_longitude);
      }
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return
        //shop()
        shop();
  }

  shopsnearme() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 3.2,
            height: 1,
            color: Colors.grey.shade300,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(
              "Shops Near Me",
              style: TextStyle(
                  color: Colors.grey.shade600,
                  fontFamily: "Camphor",
                  fontWeight: FontWeight.w700,
                  fontSize: 14.0),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 3.2,
            height: 1,
            color: Colors.grey.shade300,
          )
        ],
      ),
    );
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

            suffixIcon: InkWell(
              onTap: () async {
                _searchshops = editingController.text.toString().trim();
                print(_searchshops.toString());
                List<String> matchQuery = [];
                for (var shops in shoplist) {
                  if (shops.shopName.contains(_searchshops)) {
                    matchQuery.add(shops.shopName);
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Icon(
                  Icons.search,
                  color: appColor,
                  size: 25,
                ),
              ),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)))),
        onSubmitted: (value) async {
          String lat = "0";
          String long = "0";
          FocusScope.of(context).requestFocus(FocusNode());
        },
        textInputAction: TextInputAction.search,
      ),
    );
  }

  shopscard(ShopList shoplist, var addtofavorite) {
    addtofavorite = shoplist.favourite;
    return InkWell(
      onTap: () => {
      //   Navigator.push(context, SlideLeftRoute(page:ProductList(shoplist.shopId,shoplist.pCategName,shoplist.shopName,shoplist.rating,shoplist.latitude,shoplist.longitude),
      //   ))
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => ProductList(shoplist.shopId,shoplist.pCategName,shoplist.shopName,shoplist.rating,shoplist.latitude,shoplist.longitude),
       
        // ))
        // Navigator.of(context).push(MaterialPageRoute(
        //                     builder: (context) => OrdersPage("widget.ShopName"),
        //                   ))
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 3.9,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Container(
                alignment: Alignment.topRight,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(shoplist.img), fit: BoxFit.fill)),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          height: 40,
                          width: 35,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          margin: const EdgeInsets.only(top: 20.0, left: 50,right: 10),
                          child: IconButton(
                            icon: addtofavorite == 0
                                ? Image.asset(
                                    "assets/heart.png",
                                  )
                                : Image.asset(
                                    "assets/heartfill.png",
                                    color: Colors.red,
                                  ),
                            onPressed: () {},
                          )),
                      SizedBox(
                        height: 50,
                      ),
                  // Container(
                  //       padding: EdgeInsets.only(bottom: 15.0, right: 15),
                      //   child: ElevatedButton.icon(
                      //       style: ButtonStyle(
                      //           backgroundColor:
                      //               MaterialStateProperty.all(Colors.white),
                      //           shape: MaterialStateProperty.all(
                      //               RoundedRectangleBorder(
                      //                   borderRadius:
                      //                       BorderRadius.circular(20)))),
                      //       onPressed: () {
                      //         navigateTo(double.parse(shoplist.latitude),
                      //             double.parse(shoplist.longitude));
                      //       },
                      //       icon: Image.asset("assets/googlemaps.png"),
                      //       label: Text(
                      //         'Get Direction',
                      //         style: TextStyle(
                      //             color: Colors.black,
                      //             fontFamily: "Camphor",
                      //             fontWeight: FontWeight.w300,
                      //             fontSize: 14.0),
                      //       )),
                      // )
                    ]),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 15, right: 10, left: 10),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              shoplist.shopName,
                              style: TextStyle(
                                  fontFamily: "Camphor",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.0),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              shoplist.pCategName,
                              style: TextStyle(
                                  fontFamily: "Camphor",
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11.0),
                            )
                          ],
                        ),
                        Container(
                          width: 70,
                          height: 30,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(50)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                shoplist.rating.toStringAsFixed(1),
                                style: TextStyle(
                                    fontFamily: "Camphor",
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15.0),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 18,
                              )
                            ],
                          ),
                        )
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

 

  shop() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        title: Text(
          "Shop",
          style: TextStyle(
              fontFamily: "Camphor",
              fontWeight: FontWeight.w600,
              fontSize: 20.0),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.fitHeight,
          image: AssetImage("assets/dashbg.png"),
        )),
        child: Column(children: [
          SizedBox(
            height: 5,
          ),
          //search here
          searchhere(),
          SizedBox(height: 3),
          //shops near me
          shopsnearme(),
          //shops card list
          shopscardlist(),
        ]),
      ),
     
    );
  }
  
  shopscardlist() {
    return FutureBuilder(
        future: new ShopController()
            .getShopList("72.8428757", "19.019282")
            .then((value) {
          shoplist = value;
        }),
        builder: (BuildContext context, AsyncSnapshot<ShopList> snapshot) {
          if (shoplist == null) {
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
                itemCount: shoplist.length,
                itemBuilder: (BuildContext context, int index) {
                  var addtofavorite;
                  return shopscard(shoplist[index], addtofavorite);
                },
              ),
            );
          }
        });
 
  }
}
