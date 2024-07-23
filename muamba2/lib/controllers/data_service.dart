import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/table_status.dart';

class DataService {
  final ValueNotifier<Map<String, dynamic>> tableStateNotifier =
      ValueNotifier({'status': TableStatus.idle, 'dataObjects': []});

  void carregar(int index, String code) {
    final funcoes = [carregarRastreio(code)];
    tableStateNotifier.value = {'status': TableStatus.loading, 'dataObjects': []};
    funcoes[index];
  }

  void carregarRastreio(String code) async {
    const user = 'guilherme.medeiros.706@ufrn.edu.br';
    const token = '2fdf7f9a5561535d82f7157c30075e21577f17b3b50b2107cff71a7f644eb75c';
    try {
      var rastreioUri = Uri(
        scheme: 'https',
        host: 'api.linketrack.com',
        path: 'track/json',
        queryParameters: {'codigo': code, 'token': token, 'user': user},
      );
      var jsonString = await http.read(rastreioUri);
      var trackJson = jsonDecode(jsonString);
      tableStateNotifier.value = {
        'status': TableStatus.ready,
        'dataObjects': trackJson,
        'propertyNames': ["host", "eventos", "data", "hora", "local", "status"],
      };
    } catch (error) {
      tableStateNotifier.value = {'status': TableStatus.error};
    }
  }
}

final dataService = DataService();
