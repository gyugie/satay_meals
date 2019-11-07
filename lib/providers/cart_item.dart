import 'package:flutter/widgets.dart';

class Item {
  final String product_id;
  final double price;
  final int quantity;

  Item({this.product_id, this.price, this.quantity});
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
  /**
   * Adding item & update item if axist item
   */
  void addItem(String foodId, double foodPrice, int quantity){
    if(!_items.containsKey(foodId)){

      _items.putIfAbsent(foodId, () => Item(
            product_id: foodId,
            price: foodPrice,
            quantity: quantity
          ));

    } else {

      _items.update(
        foodId, (existingItem) => Item(
            product_id: existingItem.product_id,
            price: existingItem.price,
            quantity: quantity
          ));
         
    } 

    notifyListeners();
  
  }

/**
 * Reduce quantity
 * @param id
 */
  void reduceQuantity(String foodId){
    if(!_items.containsKey(foodId) && _items[foodId].quantity < 1){
      return;
    } 

      if(_items[foodId].quantity > 1){
      _items.update(
        foodId, 
        (existingItem) => Item(
          product_id: existingItem.product_id,
          price: existingItem.price,
          quantity: existingItem.quantity - 1
        ));
      } else {
        removingSingleItem(foodId);
      }

    notifyListeners();

  }

/**
 * 
 * quantity 0 deleting item
 * @param String id
 */
  void removingSingleItem(String foodId){

    if(!_items.containsKey(foodId)){
      return;
    } 
    
    _items.remove(foodId);
    notifyListeners();
  }

}