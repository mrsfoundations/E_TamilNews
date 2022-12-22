import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen(this.data,{Key? key}) : super(key: key);
final Map<String,dynamic>data;
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text(
            'Id:${widget.data['user_id']}',
          ),
          SizedBox(height: 5,),
          Text(
            'Name:${widget.data['user_name']}',
          ),
          SizedBox(height: 5,),
          Text(
            'Email:${widget.data['email_id']}',
          ),
        ],
      ),
    );
  }
}
