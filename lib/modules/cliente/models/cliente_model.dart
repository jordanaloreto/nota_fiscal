import 'package:objectbox/objectbox.dart';

@Entity()
class Cliente {
  @Id()
  int? id;
  String nomeCliente;
  String cnpjCpf;
  double valor;

  Cliente({
    this.id,
    required this.nomeCliente,
    required this.cnpjCpf,
    required this.valor,
  });

  Cliente copyWith({
    int? id,
    String? nomeCliente,
    String? cnpjCpf,
    double? valor,
  }) {
    return Cliente(
      id: id ?? this.id,
      nomeCliente: nomeCliente ?? this.nomeCliente,
      cnpjCpf: cnpjCpf ?? this.cnpjCpf,
      valor: valor ?? this.valor,
    );
  }

  @override
  String toString() {
    return 'Cliente(id: $id, nomeCliente: $nomeCliente, cnpj: $cnpjCpf,  valor: $valor)';
  }

  @override
  bool operator ==(covariant Cliente other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.nomeCliente == nomeCliente &&
        other.cnpjCpf == cnpjCpf &&
        other.valor == valor;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nomeCliente.hashCode ^
        cnpjCpf.hashCode ^
        valor.hashCode;
  }
}
