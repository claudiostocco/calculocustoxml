# Processador de NFe - Flutter

Aplicação Flutter para processar arquivos XML de NFe (modelos 55 e 65) e calcular custos de produtos.

## Funcionalidades

- ✅ Seleção de arquivo XML da NFe
- ✅ Aplicação de multiplicador ao valor unitário
- ✅ Soma automática do IPI ao valor
- ✅ Aplicação de percentual de frete
- ✅ Listagem de itens processados
- ✅ Cálculo dinâmico de custo por embalagem
- ✅ Interface responsiva e intuitiva

## Estrutura do Projeto

```
lib/
├── main.dart                          # Ponto de entrada da aplicação
├── models/
│   └── nfe_item.dart                  # Modelo de dados do item
├── services/
│   └── nfe_processor_service.dart     # Serviço de processamento XML
├── screens/
│   └── nfe_processor_screen.dart      # Tela principal
└── widgets/
    ├── nfe_input_widget.dart          # Widget de entrada de dados
    ├── nfe_items_list_widget.dart     # Widget de listagem
    └── nfe_item_card.dart             # Card individual do item
```

## Como Usar

### 1. Tela Inicial
- Clique em "Selecionar" para escolher o arquivo XML da NFe
- Opcionalmente, informe um multiplicador (será aplicado se > 1)
- Opcionalmente, informe o percentual do frete
- Clique em "Iniciar Processamento"

### 2. Tela de Itens Processados
- Visualize todos os itens da NFe processados
- Para cada item você verá:
  - Código do produto
  - Descrição
  - Valor unitário calculado (com multiplicador, IPI e frete aplicados)
  - Campo de quantidade de embalagem (padrão: 1)
  - Custo por embalagem (atualizado automaticamente)

### 3. Cálculo do Valor
O valor final de cada item é calculado da seguinte forma:

```
1. Valor base = vUnCom (do XML)
2. Se multiplicador > 1: Valor base = Valor base × Multiplicador
3. Valor com IPI = Valor base + vIPI (do XML, se existir)
4. Se percentual frete > 0: Valor final = Valor com IPI × (1 + percentual/100)
5. Custo por embalagem = Valor final / Quantidade de embalagem
```

## Dependências

- `xml: ^6.3.0` - Para processar arquivos XML
- `file_picker: ^6.1.1` - Para seleção de arquivos

## Instalação

1. Certifique-se de ter o Flutter instalado
2. Clone o projeto
3. Execute:
```bash
flutter pub get
```

## Execução

```bash
flutter run
```

## Tags XML Utilizadas

### Obrigatórias
- `<det>` - Detalhes dos itens
- `<prod>` - Dados do produto
- `<cProd>` - Código do produto
- `<xProd>` - Descrição do produto
- `<vUnCom>` - Valor unitário comercial

### Opcionais
- `<imposto>` - Impostos
- `<IPI>` - IPI
- `<vIPI>` - Valor do IPI

## Observações

- Todos os valores numéricos aceitam vírgula ou ponto como separador decimal
- O multiplicador só é aplicado se for maior que 1
- O frete só é aplicado se for maior que 0
- A quantidade de embalagem deve ser maior que 0
- O IPI é somado apenas se existir no XML e for maior que 0

## Possíveis Melhorias Futuras

- Exportação para Excel/CSV
- Salvamento de processamentos anteriores
- Filtros e ordenação na lista
- Edição do valor calculado
- Suporte a múltiplos XMLs simultaneamente
- Histórico de processamentos
- Validação mais robusta do XML
