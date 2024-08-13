import 'package:flutter/material.dart';

class RastreioWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const RastreioWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data['eventos'] == null) {
      return const Center(child: Text("Nenhum evento encontrado."));
    }

    List eventos = data['eventos'];

    return ListView.builder(
      shrinkWrap: true,
      itemCount: eventos.length,
      itemBuilder: (context, index) {
        var evento = eventos[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: ListTile(
            title: Text(evento['status'] ?? 'Status desconhecido'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Data: ${evento['data'] ?? 'Data desconhecida'}"),
                Text("Hora: ${evento['hora'] ?? 'Hora desconhecida'}"),
                Text("Local: ${evento['local'] ?? 'Local desconhecido'}"),
                if (evento['subStatus'] != null)
                  ...List<Widget>.from(evento['subStatus']
                      .map<Widget>((subStatus) => Text(subStatus))
                      .toList()),
              ],
            ),
          ),
        );
      },
    );
  }
}
