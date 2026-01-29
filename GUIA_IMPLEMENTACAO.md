# Guia de Implementação - Processador de NFe Flutter

## Visão Geral
Aplicação Flutter desenvolvida para processar arquivos XML de Notas Fiscais Eletrônicas (NFe) modelos 55 e 65, calculando custos de produtos com base em multiplicadores, IPI e frete.

## Arquitetura e Organização

### 1. Models (`lib/models/`)
**nfe_item.dart** - Modelo de dados que representa um item processado
- Propriedades: código, descrição, valorUnitario, quantidadeEmbalagem
- Getter computado: `custoPorEmbalagem` (calcula automaticamente)
- Método `copyWith` para atualização imutável

### 2. Services (`lib/services/`)
**nfe_processor_service.dart** - Serviço responsável pelo processamento do XML
- Método `processXml()` que:
  - Lê o arquivo XML
  - Itera pelos elementos `<det>`
  - Extrai dados: cProd, xProd, vUnCom
  - Aplica multiplicador (se > 1)
  - Busca e soma vIPI (se existir)
  - Aplica percentual de frete (se > 0)
  - Retorna lista de NFeItem

### 3. Widgets (`lib/widgets/`)

#### **nfe_input_widget.dart**
Widget de entrada inicial com:
- Botão para seleção de arquivo XML (file_picker)
- TextField para multiplicador (opcional)
- TextField para percentual de frete (opcional)
- Botão "Iniciar Processamento"
- Validações e tratamento de erros
- Estado de loading durante processamento

#### **nfe_items_list_widget.dart**
Widget de listagem com:
- Cabeçalho com total de itens e valor total
- ListView.builder para renderizar itens
- Botão de voltar para tela inicial
- Gerenciamento de estado dos itens

#### **nfe_item_card.dart**
Card individual para cada item com:
- Código e descrição do produto
- Valor unitário calculado (destacado)
- Campo editável de quantidade de embalagem
- Custo por embalagem (atualizado automaticamente)
- Layout responsivo e visualmente organizado

### 4. Screens (`lib/screens/`)
**nfe_processor_screen.dart** - Tela principal que gerencia o fluxo
- Alterna entre tela de input e listagem
- Gerencia estado de loading
- Coordena o serviço de processamento
- Tratamento de erros com dialogs

### 5. Main (`lib/main.dart`)
Configuração da aplicação:
- Tema Material 3
- Configurações de estilo (cards, botões, inputs)
- Ponto de entrada da aplicação

## Fluxo de Funcionamento

### Fase 1: Entrada de Dados
1. Usuário seleciona arquivo XML da NFe
2. Opcionalmente informa multiplicador (se > 1, será aplicado)
3. Opcionalmente informa percentual de frete
4. Clica em "Iniciar Processamento"

### Fase 2: Processamento
```
Para cada item do XML:
  1. Ler vUnCom (valor unitário)
  2. Se multiplicador > 1: valor = vUnCom × multiplicador
  3. Se existe vIPI: valor = valor + vIPI
  4. Se percentual_frete > 0: valor = valor × (1 + percentual/100)
  5. Criar NFeItem com valor calculado
```

### Fase 3: Visualização
1. Exibe lista de todos os itens processados
2. Cada item mostra:
   - Código e descrição
   - Valor unitário calculado
   - Campo de quantidade de embalagem (padrão: 1)
   - Custo por embalagem (valor ÷ quantidade)
3. Ao alterar quantidade, recalcula custo automaticamente

## Fórmula de Cálculo

```dart
// 1. Valor base
double valor = vUnCom;

// 2. Aplicar multiplicador
if (multiplicador > 1.0) {
  valor = valor * multiplicador;
}

// 3. Somar IPI
if (vIPI > 0) {
  valor = valor + vIPI;
}

// 4. Aplicar frete
if (percentualFrete > 0) {
  valor = valor * (1 + percentualFrete/100);
}

// 5. Custo por embalagem
custoPorEmbalagem = valor / quantidadeEmbalagem;
```

## Tags XML Utilizadas

### Obrigatórias
- `<det>` - Nó de detalhamento dos itens
- `<prod>` - Dados do produto
  - `<cProd>` - Código do produto
  - `<xProd>` - Descrição do produto
  - `<vUnCom>` - Valor unitário comercial

### Opcionais
- `<imposto>` - Nó de impostos
  - `<IPI>` - IPI
    - `<vIPI>` - Valor do IPI

## Dependências

```yaml
dependencies:
  xml: ^6.3.0          # Processamento de XML
  file_picker: ^6.1.1  # Seleção de arquivos
```

## Como Executar

```bash
# 1. Instalar dependências
flutter pub get

# 2. Executar aplicação
flutter run

# 3. Para testes, use o arquivo exemplo_nfe.xml incluído
```

## Exemplo de Uso

### Cenário 1: NFe com multiplicador e frete
- Arquivo: nfe.xml
- Multiplicador: 1.2
- Frete: 5%

Item no XML:
- vUnCom: R$ 100,00
- vIPI: R$ 10,00

Cálculo:
1. Base: R$ 100,00
2. Com multiplicador: R$ 100,00 × 1.2 = R$ 120,00
3. Com IPI: R$ 120,00 + R$ 10,00 = R$ 130,00
4. Com frete: R$ 130,00 × 1.05 = R$ 136,50

Resultado: R$ 136,50 por unidade

Se quantidade de embalagem = 12:
Custo por embalagem = R$ 136,50 ÷ 12 = R$ 11,38

## Características de Destaque

✅ **Separação de Responsabilidades**: Models, Services, Widgets e Screens bem definidos
✅ **Widgets Reutilizáveis**: Componentes pequenos e focados
✅ **Estado Reativo**: Atualização automática do custo por embalagem
✅ **Validações**: Inputs numéricos com formatação adequada
✅ **UX/UI**: Interface intuitiva com feedback visual
✅ **Tratamento de Erros**: Try-catch e dialogs informativos
✅ **Flexibilidade**: Multiplicador e frete opcionais

## Possíveis Extensões

1. **Exportação**: Adicionar export para Excel/CSV
2. **Persistência**: Salvar processamentos com SharedPreferences
3. **Filtros**: Adicionar busca e filtros na lista
4. **Batch**: Processar múltiplos XMLs simultaneamente
5. **Edição**: Permitir ajuste manual de valores
6. **Histórico**: Manter histórico de processamentos
7. **Validação**: Validação de schema XML mais robusta
8. **Compartilhamento**: Compartilhar resultados

## Observações Importantes

- Todos os valores aceitam vírgula ou ponto como decimal
- Multiplicador só é aplicado se > 1
- Frete só é aplicado se > 0
- IPI só é somado se existir e > 0
- Quantidade de embalagem deve ser > 0
- Suporta NFe modelos 55 e 65
