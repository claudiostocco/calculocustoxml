class NFeItem {
  final String codigo;
  final String descricao;
  final double valorUnitario;
  double quantidadeEmbalagem;
  
  NFeItem({
    required this.codigo,
    required this.descricao,
    required this.valorUnitario,
    this.quantidadeEmbalagem = 1.0,
  });
  
  double get custoPorEmbalagem {
    if (quantidadeEmbalagem <= 0) return 0.0;
    return valorUnitario / quantidadeEmbalagem;
  }
  
  NFeItem copyWith({
    String? codigo,
    String? descricao,
    double? valorUnitario,
    double? quantidadeEmbalagem,
  }) {
    return NFeItem(
      codigo: codigo ?? this.codigo,
      descricao: descricao ?? this.descricao,
      valorUnitario: valorUnitario ?? this.valorUnitario,
      quantidadeEmbalagem: quantidadeEmbalagem ?? this.quantidadeEmbalagem,
    );
  }
}
