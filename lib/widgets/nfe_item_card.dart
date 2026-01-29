import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/nfe_item.dart';

class NFeItemCard extends StatefulWidget {
  final NFeItem item;
  final Function(double) onQuantidadeChanged;

  const NFeItemCard({super.key, required this.item, required this.onQuantidadeChanged});

  @override
  State<NFeItemCard> createState() => _NFeItemCardState();
}

class _NFeItemCardState extends State<NFeItemCard> {
  late TextEditingController _quantidadeController;

  @override
  void initState() {
    super.initState();
    _quantidadeController = TextEditingController(text: widget.item.quantidadeEmbalagem.toString());
  }

  @override
  void dispose() {
    _quantidadeController.dispose();
    super.dispose();
  }

  void _onQuantidadeChanged(String value) {
    if (value.isEmpty) return;

    try {
      double quantidade = double.parse(value.replaceAll(',', '.'));
      if (quantidade > 0) {
        widget.onQuantidadeChanged(quantidade);
      }
    } catch (e) {
      // Ignora valores inválidos
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Código e descrição
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(4)),
                  child: Text(
                    widget.item.codigo,
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade900),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(widget.item.descricao, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ],
            ),

            const SizedBox(height: 2),

            // Valor unitário calculado
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  const Icon(Icons.attach_money, size: 20),
                  const SizedBox(width: 8),
                  const Text('Valor Unitário:', style: TextStyle(fontWeight: FontWeight.w500)),
                  const Spacer(),
                  Text(
                    'R\$ ${widget.item.valorUnitario.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 2),

            // Quantidade de embalagem e custo por embalagem
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _quantidadeController,
                    decoration: const InputDecoration(labelText: 'Qtd. Embalagem', border: OutlineInputBorder(), isDense: true),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,4}'))],
                    onChanged: _onQuantidadeChanged,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Custo/Embalagem', style: TextStyle(fontSize: 12, color: Colors.green.shade900)),
                        const SizedBox(height: 2),
                        Text(
                          'R\$ ${widget.item.custoPorEmbalagem.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green.shade900),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
