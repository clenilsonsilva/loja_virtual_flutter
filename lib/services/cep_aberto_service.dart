import 'dart:io';

import 'package:dio/dio.dart';

import '../models/cep_aberto_address.dart';

const token = '7b3037d94d8691c632a1fb65e3a8752b';

class CepAbertoService {
  Future<CepAbertoAddress?> getAddressFromCep(String cep) async {
    final cleanCep = cep.replaceAll('.', '').replaceAll('-', '');
    final endPoint = "https://www.cepaberto.com/api/v3/cep?cep=$cleanCep";

    final dio = Dio();

    dio.options.headers[HttpHeaders.authorizationHeader] = 'Token token=$token';

    try {
      final response = await dio.get<Map<String, dynamic>>(endPoint);

      if (response.data != null) {
        if (response.data!.isEmpty) {
          return Future.error('Cep Invalido');
        }
      }
      if (response.data != null) {
        final address = CepAbertoAddress.fromMap(response.data!);
        return address;
      } else {
        return Future.error('Falha');
      }
    } on DioError catch (e) {
      return Future.error('Erro ao buscar cep: $e');
    }
  }
}
