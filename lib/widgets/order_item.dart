import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../providers/cart_item.dart';

class OrderItem extends StatefulWidget {
  final String id;
  final String name;
  final double price;
  final double priceOperator;
  final int minOrder;
  final String imageUrl;

  OrderItem(
    this.id,
    this.name,
    this.price,
    this.priceOperator,
    this.minOrder,
    this.imageUrl
  );

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  final _quantityController   = TextEditingController();
    

  @override
  void initState() {
    super.initState();

    _quantityController.hasListeners;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    _quantityController.dispose();
    // _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final foods = Provider.of<CartItem>(context);
    
    return Card(
      child: Center(
      child: ListTile(
        leading: FadeInImage(
              placeholder: AssetImage('assets/images/satay-vector.png'),
              image: NetworkImage(widget.imageUrl),
              height: 100,
              width: 80,
              fit: BoxFit.cover,
            ),
        //  Image.network(widget.imageUrl, height: 100,width: 80, fit: BoxFit.cover,),
        title: Text('${widget.name}'),
        subtitle: Text('RM ${widget.price}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: (){
                var _quantityValue  = _quantityController.text != '' ? _quantityController.text : '0';
                var reduceValue     = int.parse(_quantityValue) - 1; 

                if(reduceValue >= 0){

                  setState(() {
                  _quantityController.text = reduceValue.toString();
                  });
                
                  foods.reduceQuantity(widget.id);
                }

              },
            ),
            Container(
              width: 60,
              height: 50,
              color: Colors.black,
              child: Center(
                child: new TextField(
                  controller: _quantityController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    new LengthLimitingTextInputFormatter(2),// for mobile 
                  ],
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  decoration: InputDecoration(
                    filled: true,
                    hintText: '0',
                    border: InputBorder.none
                  ),
                  onTap: (){
                    setState(() {
                        _quantityController.text = widget.minOrder.toString();
                    });

                    foods.addItem(widget.id, widget.name, widget.price, int.parse(_quantityController.text), widget.minOrder);
                  },
                  onChanged: (value){
                    if(value.contains('-') || value.contains('.') || value.contains(',') ){
                      setState(() {
                        _quantityController.text = '';
                      });
                    }
                    
                    if(value.isEmpty || value == ''){
                      foods.removingSingleItem(widget.id);
                    }
                    if(value != '0'){
                      if(value == '00'){
                        return;
                      }
                      foods.addItem(widget.id, widget.name, widget.price, int.parse(value), widget.minOrder);
                    }

                  },
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: (){
                var _quantityValue  = _quantityController.text != '' ? _quantityController.text : '0';
                var addValue        = _quantityValue.length < 3 ? int.parse(_quantityValue) + 1 : int.parse(_quantityValue) ; 
                setState(() {
                  _quantityController.text = addValue.toString();
                });
               foods.addItem(widget.id, widget.name, widget.price, addValue, widget.minOrder);
              },
            )
          ],
        ),
      ),
    )
    );
  }
}