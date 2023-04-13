class CepAbertoAddress {
  final double altitude, latitude, longitude;
  final String cep, logradouro, bairro;
  final Cidade cidade;
  final Estado estado;

  CepAbertoAddress.fromMap(Map<String, dynamic> map)
      : altitude = map['altitude'] as double,
        cep = map['cep'] as String,
        latitude = double.tryParse(map['latitude'] as String) ?? 0,
        longitude = double.tryParse(map['longitude'] as String) ?? 0,
        logradouro = map['logradouro'] as String,
        bairro = map['bairro'] as String,
        cidade = Cidade.fromMap(map['cidade'] as Map<String, dynamic>),
        estado = Estado.fromMap(map['estado'] as Map<String, dynamic>);

  @override
  String toString() {
    return 'CepAbertoAddress{altitude=$altitude, latitude=$latitude, longitude=$longitude, cep=$cep, logradouro=$logradouro, bairro=$bairro, cidade=$cidade, estado=$estado}';
  }
}

class Cidade {
  final String ibge, nome;
  final int ddd;

  Cidade.fromMap(Map<String, dynamic> map)
      : ddd = map['ddd'] as int,
        ibge = map['ibge'] as String,
        nome = map['nome'] as String;

  @override
  String toString() {
    return 'Cidade{ddd=$ddd, ibge=$ibge, nome=$nome}';
  }
}

class Estado {
  final String sigla;
  Estado.fromMap(Map<String, dynamic> map) : sigla = map['sigla'] as String;

  @override
  String toString() {
    return 'Estado{sigla=$sigla}';
  }
}
