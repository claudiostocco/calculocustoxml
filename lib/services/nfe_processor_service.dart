import 'dart:io';
import 'package:xml/xml.dart';
import '../models/nfe_item.dart';

class NFeProcessorService {
  Future<List<NFeItem>> processXml({
    required File xmlFile,
    double multiplicador = 1.0,
    double percentualFrete = 0.0,
  }) async {
    try {
      final xmlString = await xmlFile.readAsString();
      final document = XmlDocument.parse(xmlString);
      
      final itens = <NFeItem>[];
      
      // Buscar todos os itens (det) da NFe
      final detElements = document.findAllElements('det');
      
      for (var det in detElements) {
        // Extrair dados do produto
        final prod = det.findElements('prod').first;
        final codigo = prod.findElements('cProd').first.innerText;
        final descricao = prod.findElements('xProd').first.innerText;
        final vUnComString = prod.findElements('vUnCom').first.innerText;
        double vUnCom = double.parse(vUnComString.replaceAll(',', '.'));
        
        // Aplicar multiplicador se informado e maior que 1
        if (multiplicador > 1.0) {
          vUnCom *= multiplicador;
        }
        
        // Buscar valor do IPI se existir
        double vIPI = 0.0;
        final impostoElements = det.findElements('imposto');
        if (impostoElements.isNotEmpty) {
          final ipiElements = impostoElements.first.findAllElements('IPI');
          if (ipiElements.isNotEmpty) {
            final vIPIElements = ipiElements.first.findAllElements('vIPI');
            if (vIPIElements.isNotEmpty) {
              final vIPIString = vIPIElements.first.innerText;
              vIPI = double.parse(vIPIString.replaceAll(',', '.'));
            }
          }
        }
        
        // Somar IPI ao valor unitário
        double valorCalculado = vUnCom + vIPI;
        
        // Aplicar percentual de frete se informado e maior que 0
        if (percentualFrete > 0.0) {
          valorCalculado += valorCalculado * (percentualFrete / 100);
        }
        
        itens.add(NFeItem(
          codigo: codigo,
          descricao: descricao,
          valorUnitario: valorCalculado,
        ));
      }
      
      return itens;
    } catch (e) {
      throw Exception('Erro ao processar XML: $e');
    }
  }
}
