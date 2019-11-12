import 'package:flutter/material.dart';

enum FilterOptions {
  Delivered,
  Tracking,
  Detail,
}

class HistoryItem extends StatefulWidget {
  @override
  _HistoryItemState createState() => _HistoryItemState();
}

class _HistoryItemState extends State<HistoryItem> {

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Card(
        child: Container(
        height: MediaQuery.of(context).orientation == Orientation.portrait ? deviceSize.height * 0.2 : deviceSize.height * 0.4 ,
        padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: deviceSize.height * 0.15,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.green,
                    ),
                    child: Center(
                      child: Text('Delivered', style: Theme.of(context).textTheme.body1),
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text('#1024', style: Theme.of(context).textTheme.title),
                        // IconButton(
                        //   icon: Icon(Icons.more_vert, color: Colors.white),
                        //   onPressed: (){},
                        // )
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
                              PopupMenuItem(child: Text('Get your satay ? '), value: FilterOptions.Delivered),
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
                   Text('14/jan/20', style: Theme.of(context).textTheme.title),
                ],
              ),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                   Text('Total Payment', style: Theme.of(context).textTheme.title),
                   Text('RM 54.00', style: Theme.of(context).textTheme.title),
                ],
              )
            ],
          ),
        )
      )
    );
  }
}