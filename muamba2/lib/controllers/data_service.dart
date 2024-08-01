import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/table_status.dart';

class DataService {
  final ValueNotifier<Map<String, dynamic>> tableStateNotifier =
      ValueNotifier({'status': TableStatus.idle, 'dataObjects': []});

  void carregar(int index, String code) {
    final funcoes = [carregarRastreio];
    tableStateNotifier.value = {'status': TableStatus.loading, 'dataObjects': []};
    funcoes[index](code);
  }

  Future<void> carregarRastreio(String code) async {
    const user = 'guilherme.medeiros.706@ufrn.edu.br';
    const token = '2fdf7f9a5561535d82f7157c30075e21577f17b3b50b2107cff71a7f644eb75c';
    try {
      var rastreioUri = Uri(
        scheme: 'https',
        host: 'api.linketrack.com',
        path: 'track/json',
        queryParameters: {'codigo': code, 'token': token, 'user': user},
      );
      var response = await http.get(rastreioUri);
      if (response.statusCode == 200) {
        var trackJson = jsonDecode(response.body);
        tableStateNotifier.value = {
          'status': TableStatus.ready,
          'dataObjects': trackJson,
        };
      } else {
        tableStateNotifier.value = {'status': TableStatus.error};
      }
    } catch (error) {
      tableStateNotifier.value = {'status': TableStatus.error};
    }
  }
}

final dataService = DataService();
