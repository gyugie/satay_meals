import 'package:flutter/material.dart';
import 'package:satay_meals/screens/tracking_order_screen.dart';
import 'package:satay_meals/widgets/custom_notification.dart';
import '../screens/detail_order_screen.dart';


enum FilterOptions {
  Delivered,
  Tracking,
  Detail,
  Complain
}

class HistoryItem extends StatefulWidget {
  final String noTransaction;
  final String orderId;
  final String statusOrder;
  final String total;
  final String createdAt;
  final String tableName;
  final String vendor;
  final String rider;
  final Function confirmOrder;

  HistoryItem({
    @required this.noTransaction,
    @required this.orderId,
    @required this.statusOrder,
    @required this.createdAt,
    @required this.total,
    @required this.tableName,
    this.vendor,
    this.rider,
    this.confirmOrder
  });

  @override
  _HistoryItemState createState() => _HistoryItemState();
}

class _HistoryItemState extends State<HistoryItem> {
   Color setLabelColors;

  @override
  Widget build(BuildContext context) {
    final deviceSize        = MediaQuery.of(context).size;
    final orientation       = MediaQuery.of(context).orientation;
    switch (widget.statusOrder) {
      case 'Cancelled':
            setLabelColors = Colors.red;
        break;
      case 'Searching Vendor':
          setLabelColors = Colors.orange;
        break;
      case 'Deliveried':
          setLabelColors = Colors.orange[700];
        break;
      case 'Delivering':
          setLabelColors = Colors.deepOrange;
        break;
      case 'Serving':
          setLabelColors = Colors.orangeAccent;
        break;
      case 'Delivered':
          setLabelColors = Colors.blue;
        break;
      case 'Searching Rider':
          setLabelColors = Colors.orange;
        break;
      case 'Waiting':
          setLabelColors = Colors.orange;
        break;
      default:
        setLabelColors = Colors.white;
    }

    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Card(
        elevation: 5,
        child: Container(
        height: orientation == Orientation.portrait ? deviceSize.height * 0.25 : deviceSize.height * 0.4 ,
        padding: EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: deviceSize.width * 0.45,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: setLabelColors,
                    ),
                    child: Center(
                      child: Text('${widget.statusOrder == 'Cancelled' ? 'Canceled' : widget.statusOrder}', style: Theme.of(context).textTheme.body1),
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text('#${widget.noTransaction}', style: Theme.of(context).textTheme.title),
                        Theme(
                          data: Theme.of(context).copyWith(
                            cardColor: Colors.grey
                          ),
                          child: PopupMenuButton(
                            elevation: 30,
                            onSelected: (FilterOptions selectedValue){
                              if(selectedValue == FilterOptions.Detail)
                              //push data with arguments
                               Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailOrder(
                                        orderId: widget.orderId,
                                        tableName: widget.tableName,
                                        vendor: widget.vendor,
                                        rider: widget.rider,
                                    )),
                                );
                              if(selectedValue == FilterOptions.Delivered)
                                widget.confirmOrder(widget.orderId);
                              if(selectedValue == FilterOptions.Complain)
                                CustomNotif.alertComplainOrder(context, Icons.cancel, "Complain this order?", 'please call +60 11-1220 3708 to complain your order\n Are you sure want to cancel this order', widget.orderId);
                              if(selectedValue == FilterOptions.Tracking)
                          
                              Navigator.push(
                                context, 
                                MaterialPageRoute(
                                  builder: (context) => TrackingOrderScreen(orderID: widget.orderId)
                                ));
                            },
                            icon: Icon(
                              Icons.more_vert,
                              color: Colors.white,
                            ),
                            itemBuilder: (_) => [
                              if( widget.statusOrder == 'Deliveried')
                              PopupMenuItem(child: Text('Complete delivery '), value: FilterOptions.Delivered),
                              if( widget.statusOrder == 'Deliveried')
                              PopupMenuItem(child: Text('Complain this order! '), value: FilterOptions.Complain),
                              if( widget.statusOrder == 'Delivering')
                              PopupMenuItem(child: Text('Track Order'), value: FilterOptions.Tracking),
                              PopupMenuItem(child: Text('Detail'), value: FilterOptions.Detail),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),                  
                ],
              ),

              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                   Text('Purchase On', style: Theme.of(context).textTheme.title),
                   Text('${widget.createdAt}', style: Theme.of(context).textTheme.title),
                ],
              ),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                   Text('Total Payment', style: Theme.of(context).textTheme.title),
                   Text('${widget.total}', style: Theme.of(context).textTheme.title),
                ],
              )
            ],
          ),
        )
      )
    );
  }
}