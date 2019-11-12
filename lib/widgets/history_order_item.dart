import 'package:flutter/material.dart';


enum FilterOptions {
  Delivered,
  Tracking,
  Detail,
}

class HistoryItem extends StatefulWidget {
  final String noTransaction;
  final String orderId;
  final String statusOrder;
  final String total;
  final String createdAt;

  HistoryItem({
    @required this.noTransaction,
    @required this.orderId,
    @required this.statusOrder,
    @required this.createdAt,
    @required this.total,
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
      case 'Delivered':
          setLabelColors = Colors.green;
        break;
      case 'Delivering':
          setLabelColors = Colors.deepOrange;
        break;
      case 'Serving':
          setLabelColors = Colors.orangeAccent;
        break;
      case 'Served':
          setLabelColors = Colors.blue;
        break;
      case 'Sercing Driver':
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
        child: Container(
        height: orientation == Orientation.portrait ? deviceSize.height * 0.2 : deviceSize.height * 0.4 ,
        padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: deviceSize.width * 0.35,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: setLabelColors,
                    ),
                    child: Center(
                      child: Text('${widget.statusOrder}', style: Theme.of(context).textTheme.body1),
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
                              
                          
                            },
                            icon: Icon(
                              Icons.more_vert,
                              color: Colors.white,
                            ),
                            itemBuilder: (_) => [
                              // if(widget.statusOrder == 'Serving' || widget.statusOrder == 'Delivered' || widget.statusOrder == 'Delivering')
                              PopupMenuItem(child: Text('Get your satay ? '), value: FilterOptions.Delivered),
                              // if(widget.statusOrder == 'Serving' || widget.statusOrder == 'Delivered' || widget.statusOrder == 'Delivering')
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