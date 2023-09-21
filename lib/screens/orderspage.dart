import 'package:flutter/material.dart';
import 'package:vetplanet/constant/colors.dart';

class OrdersPage extends StatefulWidget {
  var shopName,counter;
   OrdersPage(this.shopName, {Key key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        title: Text("Your Order"),
      ),
      body: Container(
       
        child: Column(
          children: [
           ordersList()
        ]),
      ),
    );
  }
  
  ordersList() {
    return Container(
      height: MediaQuery.of(context).size.height/2,
      width: double.infinity,
      margin: EdgeInsets.all(20),
     // color: appColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.shopName,style: TextStyle(color: Colors.black),),
          ),
          Divider(height:5,color: appColor,),
          ListView.builder(
           
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) { 
              return ordersCard();
           },)
        ],),
    );
  }
  
  ordersCard() {
    return Row(
       mainAxisAlignment: MainAxisAlignment.center,
       crossAxisAlignment: CrossAxisAlignment.center,
      children: [
          Text("Soft Toy"),
          Text("₹450")
      ],
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
                    widget.counter++;
                  });
                },
                child: Icon(
                  Icons.add,
                  color: appColor,
                  size: 17,
                )),
            Text(
              widget.counter.toString(),
              style: TextStyle(
                  color: appColor, fontSize: 15, fontWeight: FontWeight.w400),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  widget.counter--;
                  if (widget.counter <= 0) {
                    widget.counter=0;
                    //isnotadded = true;
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