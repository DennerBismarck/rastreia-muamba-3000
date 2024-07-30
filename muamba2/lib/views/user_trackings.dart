import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muamba2/models/table_status.dart';
import '../controllers/user_track_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/data_service.dart';
import '../widgets/rastreio_widget.dart';
import 'package:muamba2/models/table_status.dart';

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
            return ValueListenableBuilder(
              valueListenable: dataService.tableStateNotifier,
              builder: (_, value, __) {
                if (value == null || value['status'] == null) {
                  return Text("Nenhum dado disponível.");
                }
                return ListView.builder(
                  itemCount: data.docs.length,
                  itemBuilder: (context, index) {
                    var trackingCode =
                        data.docs[index].data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(trackingCode['name']),
                      subtitle: Text(trackingCode['code']),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                          onPressed: () {
                         deleteTrackingCodeByCode(trackingCode['code']);
                        },
                      ),

                      onTap: () {
                        dataService.tableStateNotifier.value = {
                          'status': TableStatus.loading,
                          'dataObjects': []
                        };
                        dataService.tableStateNotifier.addListener(() {
                          if (dataService.tableStateNotifier.value['status'] == TableStatus.ready) {
                            final trackingDetails = dataService.tableStateNotifier.value['dataObjects'];
                            Get.to(RastreioDetailsScreen(data: trackingDetails));
                          } else if (dataService.tableStateNotifier.value['status'] == TableStatus.error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Erro ao carregar dados'))
                            );
                          }
                        });

                        // Carrega os dados de rastreamento
                        dataService.carregar(0, trackingCode['code']);
                      },
                    );
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

  RastreioDetailsScreen( {required this.data});

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
