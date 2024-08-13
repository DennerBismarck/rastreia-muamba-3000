import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muamba2/models/table_status.dart';
import '../controllers/user_track_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/data_service.dart';
import '../widgets/rastreio_widget.dart';

class TrackingCodesScreen extends StatelessWidget {
  const TrackingCodesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Trackings'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getTrackingCodes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data;

          if (data != null && data.docs.isNotEmpty) {
            return ValueListenableBuilder(
              valueListenable: dataService.tableStateNotifier,
              builder: (_, value, __) {
                if (value['status'] == null) {
                  return const Text("Nenhum dado disponível.");
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
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          deleteTrackingCodeByCode(trackingCode['code']);
                        },
                      ),
                      onTap: () {
                        // Define o estado como carregando
                        dataService.tableStateNotifier.value = {
                          'status': TableStatus.loading,
                          'dataObjects': []
                        };

                        
                        void stateListener() {
                          if (dataService.tableStateNotifier.value['status'] == TableStatus.ready) {
                            final trackingDetails = dataService.tableStateNotifier.value['dataObjects'];
                            var result = Get.to(RastreioDetailsScreen(data: trackingDetails));
                            result?.then((_) {
                              
                              dataService.tableStateNotifier.value = {
                                'status': TableStatus.idle,
                                'dataObjects': []
                              };
                            });
                          } else if (dataService.tableStateNotifier.value['status'] == TableStatus.error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Erro ao carregar dados'))
                            );
                            
                            dataService.tableStateNotifier.value = {
                              'status': TableStatus.idle,
                              'dataObjects': []
                            };
                          }
                        }

                        dataService.tableStateNotifier.addListener(stateListener);

                        
                        dataService.carregar(0, trackingCode['code']);
                      },
                    );
                  },
                );
              },
            );
          } else {
            return const Center(child: Text('No tracking codes found'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/newtrack');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class RastreioDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const RastreioDetailsScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Rastreio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RastreioWidget(data: data),
      ),
    );
  }
}
