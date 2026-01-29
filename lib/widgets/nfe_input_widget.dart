import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';

class NFeInputWidget extends StatefulWidget {
  final Function(File xmlFile, double multiplicador, double percentualFrete) onProcess;
  
  const NFeInputWidget({
    Key? key,
    required this.onProcess,
  }) : super(key: key);

  @override
  State<NFeInputWidget> createState() => _NFeInputWidgetState();
}

class _NFeInputWidgetState extends State<NFeInputWidget> {
  File? _selectedFile;
  final _multiplicadorController = TextEditingController();
  final _freteController = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _multiplicadorController.dispose();
    _freteController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xml'],
      );

      if (result != null) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      _showErrorDialog('Erro ao selecionar arquivo: $e');
    }
  }

  void _processFile() {
    if (_selectedFile == null) {
      _showErrorDialog('Selecione um arquivo XML');
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      double multiplicador = 1.0;
      if (_multiplicadorController.text.isNotEmpty) {
        multiplicador = double.parse(_multiplicadorController.text.replaceAll(',', '.'));
      }

      double percentualFrete = 0.0;
      if (_freteController.text.isNotEmpty) {
        percentualFrete = double.parse(_freteController.text.replaceAll(',', '.'));
      }

      widget.onProcess(_selectedFile!, multiplicador, percentualFrete);
    } catch (e) {
      _showErrorDialog('Erro nos valores informados: $e');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erro'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Processador de NFe',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          
          // Seleção de arquivo
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Arquivo XML da NFe:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedFile?.path.split('/').last ?? 'Nenhum arquivo selecionado',
                          style: TextStyle(
                            color: _selectedFile != null ? Colors.green : Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: _pickFile,
                        icon: const Icon(Icons.folder_open),
                        label: const Text('Selecionar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Multiplicador
          TextField(
            controller: _multiplicadorController,
            decoration: const InputDecoration(
              labelText: 'Multiplicador (opcional)',
              hintText: 'Ex: 1.5',
              border: OutlineInputBorder(),
              helperText: 'Aplicado ao valor unitário se maior que 1',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,4}')),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Percentual de frete
          TextField(
            controller: _freteController,
            decoration: const InputDecoration(
              labelText: 'Percentual do Frete (opcional)',
              hintText: 'Ex: 5.5',
              border: OutlineInputBorder(),
              suffixText: '%',
              helperText: 'Percentual aplicado ao valor calculado',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Botão processar
          ElevatedButton(
            onPressed: _isProcessing ? null : _processFile,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isProcessing
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'Iniciar Processamento',
                    style: TextStyle(fontSize: 16),
                  ),
          ),
        ],
      ),
    );
  }
}
