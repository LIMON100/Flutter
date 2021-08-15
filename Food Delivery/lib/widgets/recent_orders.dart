import 'package:flutter/material.dart';

class RecentOrders extends StatelessWidget {

  _buildRecentOrder(BuildContext context, Order order){
    return Container(
      margin: EdgeInsets.all(10.0),
    width: 320.0,
    decoration: BoxDecoration(color: Colors.white,
    borderRadius: BorderRadius.circular(15.0),
    border: Border.all(width: 1.0, color: Colors.grey[200],
    ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
                  child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                  child: Image(
                  height: 100.0,
                  width: 100.0,
                  image: AssetImage(order.food.imageUrl),
                  fit: BoxFit.cover,
                  ),
              ),
              Expanded(
                            child: Container(
            margin: EdgeInsets.all(12.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    order.food.name,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    order.restaurant.name,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    order.food.name,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.0),
            ],
            ),
          ),
              ),
            ],
          ),
        ),
        Container(margin: EdgeInsets.only(right: 20.0),
        width: 48.0,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: IconButton(
          icon: Icon(Icons.add),
          iconSize: 30.0,
          color: Colors.white,
          onPressed: (){}),
        )
      ],
    ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            "Recent Orders",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          height: 120.0,
          color: Colors.blueAccent,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(left: 10.0),
            scrollDirection: Axis.horizontal,
            itemCount: currentUser.orders.lenght,
            itemBuilder: (BuildContext context, int index) {
              Order order = currentUser.orders[index],
              return _buildRecentOrder(context, order);
            },
          ),
        ),
      ],
    );
  }
}
