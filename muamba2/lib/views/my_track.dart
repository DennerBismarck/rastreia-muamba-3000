import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transparent_image/transparent_image.dart';
import '../widgets/new_app_bar.dart';
import '../controllers/data_service.dart';
import '../models/table_status.dart';
import '../widgets/rastreio_widget.dart';
import '../controllers/user_track_data.dart';

class NewTrack extends StatelessWidget {
  final TextEditingController _codigoController = TextEditingController();
  final TextEditingController _nomeEncomendaController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NewAppBar(nometela: "Novo Rastreio"),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _nomeEncomendaController,
                  decoration: InputDecoration(labelText: 'Nome do Pacote'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _codigoController,
                  decoration: InputDecoration(labelText: 'Código de Rastreio'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () {
                    dataService.carregar(0, _codigoController.text);
                  },
                  child: Text("Procurar"),
                ),
              ),
              SingleChildScrollView(
                child: ValueListenableBuilder(
                  valueListenable: dataService.tableStateNotifier,
                  builder: (_, value, __) {
                    if (value['status'] == null) {
                      return Text("Nenhum dado disponível.");
                    }

                    switch (value['status']) {
                      case TableStatus.idle:
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: 'https://i.imgur.com/zVkjVgc.png',
                                height: 300.0,
                                width: 300.0,
                              ),
                            ),
                            Text("Coloque um código para rastreio..."),
                          ],
                        );
                      case TableStatus.loading:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      case TableStatus.error:
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Ocorreu um erro ao carregar os dados."),
                              ElevatedButton(
                                onPressed: () {
                                  dataService.carregar(
                                      0, _codigoController.text);
                                },
                                child: Text("Tentar Novamente"),
                              ),
                            ],
                          ),
                        );
                       case TableStatus.ready:
                        return Column(
                          children: [
                            RastreioWidget(data: value['dataObjects']),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  addTrackingCode(_codigoController.text, _nomeEncomendaController.text);
                                  Get.toNamed("/mytrack");

                                },
                                child: Text("Salvar Código"),
                                ),
                            ),
                          ],
                        );
                      default:
                        return Text("Estado desconhecido.");
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}