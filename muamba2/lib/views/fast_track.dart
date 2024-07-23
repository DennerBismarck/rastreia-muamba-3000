import 'package:flutter/material.dart';
import '../widgets/new_app_bar.dart';
import '../controllers/data_service.dart';
import '../models/table_status.dart';

class FastTrack extends StatefulWidget {
  @override
  State<FastTrack> createState() => _FastTrackState();
}

class _FastTrackState extends State<FastTrack> {
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NewAppBar(nometela: 'Fast Track'),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _codeController,
              decoration: InputDecoration(
                labelText: 'Enter tracking code',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              dataService.carregar(0, _codeController.text);
            },
            child: Text('Track'),
          ),
          ValueListenableBuilder(
            valueListenable: dataService.tableStateNotifier,
            builder: (context, value, child) {
              if (value['status'] == TableStatus.loading) {
                return CircularProgressIndicator();
              } else if (value['status'] == TableStatus.ready) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: value['dataObjects'].length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(value['dataObjects'][index]['status']),
                        subtitle: Text(value['dataObjects'][index]['data']),
                      );
                    },
                  ),
                );
              } else if (value['status'] == TableStatus.error) {
                return Text('Error loading tracking information');
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}
