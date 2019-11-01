import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class ProductItem extends StatelessWidget {
  int index;
  ProductItem(this.index);

  @override
  Widget build(BuildContext context) {
    
    final product     = Provider.of<Product>(context, listen: false);
    final _isLeftImage = index % 2 == 0 ? true : false;
   
    return _isLeftImage ? 
    _widgetLeftImage(context, product.id, product.name, product.price, product.priceOperator ,product.imageUrl) : 
    _widgetRightImage(context, product.id, product.name, product.price, product.priceOperator ,product.imageUrl);

  }
  Widget _widgetLeftImage(BuildContext context, String id, String productName, double productPrice, double operatorPrice, String imageUrl){
    final deviceSize  = MediaQuery.of(context).size;
    return  Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Container(
            height: deviceSize.height * 0.30,
            child: Image.network('${imageUrl}', fit: BoxFit.cover,),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            height: deviceSize.height * 0.30,
            color: Theme.of(context).accentColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('${productName}', style: Theme.of(context).textTheme.display1),
                SizedBox(height: 5),
                Text('RM ${productPrice}', style: Theme.of(context).textTheme.title),
                SizedBox(height: 5),
                SizedBox(
                  width: 150,
                  child: FlatButton(
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('Order'.toUpperCase(), style: Theme.of(context).textTheme.title),
                    onPressed: (){

                    },
                  )
                ),
              ],
            ),
          ),
        ),
      ],
    );
  } 

  Widget _widgetRightImage(BuildContext context, String id, String productName, double productPrice, double operatorPrice, String imageUrl){
    final deviceSize  = MediaQuery.of(context).size;
    return  Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Container(
            height: deviceSize.height * 0.30,
            color: Theme.of(context).accentColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('${productName}', style: Theme.of(context).textTheme.display1),
                SizedBox(height: 5),
                Text('RM ${productPrice}', style: Theme.of(context).textTheme.title),
                SizedBox(height: 5),
                SizedBox(
                  width: 150,
                  child: FlatButton(
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('Order'.toUpperCase(), style: Theme.of(context).textTheme.title),
                    onPressed: (){

                    },
                  )
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            height: deviceSize.height * 0.30,
            child: Image.network('${imageUrl}', fit: BoxFit.cover,),
          ),
        ),
      ],
    );
  } 
}