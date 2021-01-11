import 'package:e_commerce_app/Services/FirebaseAuthServices.dart';
import 'package:e_commerce_app/Services/CloudFirestore.dart';
import 'package:e_commerce_app/Widgets/CustomActionBar.dart';
import 'package:e_commerce_app/Widgets/ImageSwipe.dart';
import 'package:e_commerce_app/Widgets/ProductSize.dart';
import 'package:e_commerce_app/constants.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  final String productId;
  ProductPage({this.productId});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  FirebaseService _firebaseService = FirebaseService();
  FirestoreServices _firebaseFirestore = FirestoreServices();

  String _selectedProductSize = "0";
  Future _addCart() {
    return _firebaseFirestore.usersRef
        .doc(_firebaseService.getUserId())
        .collection("Cart")
        .doc(widget.productId)
        .set(({"Size": _selectedProductSize}));
  }

  final SnackBar _snackBar =
      SnackBar(content: Text("Product added to the cart"));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        FutureBuilder(
          future: _firebaseFirestore.productsRef.doc(widget.productId).get(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text("Error: ${snapshot.error}"),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> documentData = snapshot.data.data();
              List imageList = documentData['images'];
              List productSizes = documentData['size'];
              _selectedProductSize = productSizes[0];
              return ListView(
                children: [
                  Padding(padding: EdgeInsets.all(0)),
                  ImageSwipe(
                    imageList: imageList,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 24.0, left: 24.0, right: 24.0, bottom: 4.0),
                    child: Text(
                      "${documentData['name']}" ?? "Product Name",
                      style: Constants.boldHeading,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 24.0),
                    child: Text(
                      "\$${documentData['price']}" ?? "Price",
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 24.0),
                    child: Text(
                      "${documentData['desc']}" ?? "Description",
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 24.0, horizontal: 24.0),
                    child:
                        Text("Select Size", style: Constants.regularDarkText),
                  ),
                  ProductSize(
                    productSizes: productSizes,
                    onSelected: (size) {
                      _selectedProductSize = size;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 100.0),
                          width: 65.0,
                          height: 65.0,
                          decoration: BoxDecoration(
                              color: Color(0xFFDCDCDC),
                              borderRadius: BorderRadius.circular(12.0)),
                          alignment: Alignment.center,
                          child: Image(
                            image: AssetImage("assets/icons/tab_saved.png"),
                            height: 22.0,
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              await _addCart();
                              Scaffold.of(context).showSnackBar(_snackBar);
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 16.0, top: 100.0),
                              height: 65.0,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(12.0)),
                              alignment: Alignment.center,
                              child: Text(
                                "Add To Cart",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            }
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
        CustomActionBar(
          hasBackArrow: true,
          hasTitle: false,
          hasBackground: false,
        )
      ],
    ));
  }
}
