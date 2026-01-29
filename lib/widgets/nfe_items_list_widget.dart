import 'package:flutter/material.dart';
import '../models/nfe_item.dart';
import 'nfe_item_card.dart';

class NFeItemsListWidget extends StatefulWidget {
  final List<NFeItem> items;
  final VoidCallback onBackToInput;
  
  const NFeItemsListWidget({
    Key? key,
    required this.items,
    required this.onBackToInput,
  }) : super(key: key);

  @override
  State<NFeItemsListWidget> createState() => _NFeItemsListWidgetState();
}

class _NFeItemsListWidgetState extends State<NFeItemsListWidget> {
  late List<NFeItem> _items;
  
  @override
  void initState() {
    super.initState();
    _items = List.from(widget.items);
  }
  
  void _updateItemQuantidade(int index, double quantidade) {
    setState(() {
      _items[index] = _items[index].copyWith(quantidadeEmbalagem: quantidade);
    });
  }
  
  double get _totalGeral {
    return _items.fold(0.0, (sum, item) => sum + item.valorUnitario);
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Cabeçalho
        Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.blue.shade700,
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: widget.onBackToInput,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Itens Processados',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total de itens: ${_items.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Total: R\$ ${_totalGeral.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Lista de itens
        Expanded(
          child: _items.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhum item processado',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    return NFeItemCard(
                      item: _items[index],
                      onQuantidadeChanged: (quantidade) {
                        _updateItemQuantidade(index, quantidade);
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}
