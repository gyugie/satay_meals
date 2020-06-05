import 'package:flutter/widgets.dart';

class Item {
  final String productId;
  final String name;
  final double price;
  final double subTotal;
  final int minOrder;
  final int quantity;

  Item({ this.productId, this.name, this.price, this.quantity, this.subTotal, this.minOrder});
}

class CartItem with ChangeNotifier {
  Map<String, Item> _items = {};

  Map<String, Item> get item{
    return {..._items};
  }

  double get getTotal {
    var total = 0.0;
    _items.forEach( (key, cartItem){
      total += cartItem.quantity * cartItem.price;
    });

    return total;
  }

//
// Adding item & update item if axist item
//
  void addItem(String foodId, String foodName, double foodPrice, int quantity, int minOrder){
    if(!_items.containsKey(foodId)){

      _items.putIfAbsent(
        foodId, () => Item(
            productId: foodId,
            name: foodName,
            price: foodPrice,
            quantity: quantity,
            minOrder: minOrder,
            subTotal: quantity * foodPrice
          ));

    } else {

      _items.update(
        foodId, (existingItem) => Item(
            productId: existingItem.productId,
            name: existingItem.name,
            price: existingItem.price,
            quantity: quantity,
            minOrder: minOrder,
            subTotal: quantity * foodPrice
          ));
         
    } 
   
    notifyListeners();
  
  }

 //
 // Reduce quantity
 // @param id
 //
  void reduceQuantity(String foodId){
    if(!_items.containsKey(foodId) && _items[foodId].quantity < 1){
      return;
    } 

      if(_items[foodId].quantity > 1){
      _items.update(
        foodId, 
        (existingItem) => Item(
          productId: existingItem.productId,
          name: existingItem.name,
          price: existingItem.price,
          quantity: existingItem.quantity - 1,
          minOrder: existingItem.minOrder,
          subTotal: (existingItem.quantity - 1) * existingItem.price
        ));
      } else {
        removingSingleItem(foodId);
      }

    notifyListeners();

  }

  //
  // quantity 0 deleting item
  // @param String id
  //
  void removingSingleItem(String foodId){

    if(!_items.containsKey(foodId)){
      return;
    } 
    
    _items.remove(foodId);
    notifyListeners();
  }

  /**
   * Clear Cart item
   */

  void clearCartItem(){
    _items = {};
  }

}