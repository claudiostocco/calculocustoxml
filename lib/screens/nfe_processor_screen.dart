import 'dart:io';
import 'package:flutter/material.dart';
import '../models/nfe_item.dart';
import '../services/nfe_processor_service.dart';
import '../widgets/nfe_input_widget.dart';
import '../widgets/nfe_items_list_widget.dart';

class NFeProcessorScreen extends StatefulWidget {
  const NFeProcessorScreen({super.key});

  @override
  State<NFeProcessorScreen> createState() => _NFeProcessorScreenState();
}

class _NFeProcessorScreenState extends State<NFeProcessorScreen> {
  final NFeProcessorService _processorService = NFeProcessorService();
  List<NFeItem>? _processedItems;
  bool _isLoading = false;

  Future<void> _processXml(File xmlFile, double multiplicador, double percentualFrete) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final items = await _processorService.processXml(xmlFile: xmlFile, multiplicador: multiplicador, percentualFrete: percentualFrete);

      setState(() {
        _processedItems = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        _showErrorDialog('Erro ao processar XML: $e');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erro'),
        content: Text(message),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
      ),
    );
  }

  void _backToInput() {
    setState(() {
      _processedItems = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Processando XML...', style: TextStyle(fontSize: 16)),
                ],
              ),
            )
          : _processedItems == null
          ? SingleChildScrollView(child: NFeInputWidget(onProcess: _processXml))
          : NFeItemsListWidget(items: _processedItems!, onBackToInput: _backToInput),
    );
  }
}
