import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageTimestampWidget extends StatelessWidget {
  final Timestamp timestamp;

  const MessageTimestampWidget({ 
    Key? key,
    required this.timestamp 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timestampFormatted = DateFormat('dd MMM yyyy, HH:mm').format(timestamp.toDate());

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Text(
        timestampFormatted,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
          fontStyle: FontStyle.italic
        ),
      ),
    );
  }
}