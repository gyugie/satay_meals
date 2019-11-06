import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OrderItem extends StatefulWidget {
  final String id;
  final String name;
  final double price;
  final double priceOperator;
  final String imageUrl;

  OrderItem(
    this.id,
    this.name,
    this.price,
    this.priceOperator,
    this.imageUrl
  );

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _quantityValue  = TextEditingController();
  Map<String, String> _itemOrders = {};

  void addItemOrder(String foodsId, String foodsName, int foodsQuantity, double foodsPrice){
    if(!_itemOrders.containsKey(foodsId)){
      _itemOrders.putIfAbsent(foodsId, (){
       ({ 
         'id': foodsId,
        'name': foodsName,
        'quantity': foodsQuantity,
        'price': foodsPrice});
      });
    } else {

    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
      child: ListTile(
        leading: Image.network(widget.imageUrl, height: 100,width: 100, fit: BoxFit.cover,),
        title: Text('${widget.name}'),
        subtitle: Text('RM ${widget.price}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: (){

              },
            ),
            Container(
              width: 60,
              height: 50,
              color: Colors.black,
              child: Center(
                child: TextFormField(
                  controller: _quantityValue,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  decoration: InputDecoration(
                    filled: true,
                    hintText: '0',
                    border: InputBorder.none
                  ),
                  onFieldSubmitted: (value){
                    
                  },
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: (){
                
              },
            )
          ],
        ),
      ),
    )
    );
  }
}