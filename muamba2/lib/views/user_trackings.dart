import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_track_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/data_service.dart';
import '../widgets/rastreio_widget.dart';

class TrackingCodesScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Trackings'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getTrackingCodes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data;

          if (data != null && data.docs.isNotEmpty) {
            return ListView.builder(
              itemCount: data.docs.length,
              itemBuilder: (context, index) {
                var trackingCode =
                    data.docs[index].data() as Map<String, dynamic>;
                return ListTile(
                  title: Text(trackingCode['code']),
                  onTap: () {
                    dataService.carregar(0, trackingCode['code']);
                    Get.to(RastreioDetailsScreen(
                        data: dataService
                            .tableStateNotifier.value['dataObjects']));
                  },
                );
              },
            );
          } else {
            return Center(child: Text('No tracking codes found'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/newtrack');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class RastreioDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  RastreioDetailsScreen({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Rastreio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RastreioWidget(data: data),
      ),
    );
  }
}
