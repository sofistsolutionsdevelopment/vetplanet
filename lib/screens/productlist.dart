import 'package:flutter/material.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key key}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(),
            Expanded(
              child: Column(
                children: [
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    shrinkWrap: true,
                    children: List.generate(3, (index) {
                      return Container(
                        child: Image.asset("assets/OST_1.webp"),
                      );
                    }),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
