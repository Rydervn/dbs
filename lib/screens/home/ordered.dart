import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Orders {
  final String productId;
  final String pharmacyName;
  final DateTime createdAt;
  final double total;

  Orders({
    required this.productId,
    required this.pharmacyName,
    required this.createdAt,
    required this.total,
  });

  factory Orders.fromFirestore(DocumentSnapshot doc) {
    return Orders(
      productId: doc['productId'],
      pharmacyName: doc['pharmacyName'],
      createdAt: (doc['createdAt'] as Timestamp).toDate(),
      total: doc['total'] as double,
    );
  }
}

class Ordered1 extends StatelessWidget {
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Orders"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('user.id', isEqualTo: userId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
              children: snapshot.data!.docs.map((document) {
            final DocumentSnapshot docSnapshot = document;
            return Card(
              child: ListTile(
                title: Text(
                  'Product ID: ${docSnapshot['product.title']}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Pharmacy   Name: ${docSnapshot['product.pharmacy_info.title']}'),
                    Text('Created At: ${docSnapshot['created_at'].toDate()}'),
                    Text('Total: \₵${docSnapshot['total']}'),
                  ],
                ),
              ),
            );
          }).toList());
        },
      ),
    );
  }
}
