# Funcionalidade

Aplicação que recebe um arquivo XML da NFe modelo 55 ou 65, processa o XML e gera uma lista de todos os produtos com o custo. Deve ter a possibilidade de informar um multiplicador para o valor unitário e o valor do frete, caso seja externo à NFe.

## Caracteristicas construtivas

- Deve ter opção para selecionar o arquivo XML da NFe;
- Deve ter um TextField para informar um multiplicador, este multiplicador é aplicado ao valor unitário na NFe (Tag <vUnCom>) caso seja informado e maior que 1;
- Deve somar o valor do IPI presente na NFe (Tag <vIPI>), caso maior que 0;
- Deve ter um TextField para informar o percentual do frete por fora da NFe.
- Um botão para iniciar o processamento;
- Deve ter uma tela para listar os itens processados, nesta tela, para cada item deve ter o código do produto e a descrição lidos do XML, o valor unitária calculado, um campo para informar a quantidade de embalagem, que já vem preenchido com o valor 1 e o valor e o custo por embalagem.

## Orientações

A aplicação deve ser desenvolvida em Flutter e não é necessário criar toda a aplicação, somente os arquivos das funcionalidades, é preferível separar em Widgets menores para melhor organização do código.
O comportamento da aplicação deve ser o seguinte, aguardar que o operador selecione o XML, informe o valor do multiplicador e o percentual do frete, estes dois ultimos não são obrigatórios. Ao clicar no botão Iniciar processamento, a aplicação deve iterar pelos itens da NFe e para cada item pegar o valor unitário do item (Tag <vUnCom>), multiplicar pelo multiplicador caso seja informado e maior que 1, o resultado deve ser somado ao valor do IPI do item (Tag <vIPI>, verificar se existe a tag para evitar erro), por fim aplica-se ao resultado o valor do frete caso seja informado e maior que 0. 
Terminada o processamento do XML, deve apresentar a tela listando os itens processados, na qual, para cada item deve ter um campo para informar a quantidade de embalagem, que já vem preenchido com o valor 1 e se mudar essa quantidade de embalagem já altera o campo custo por embalagem, dividindo o resultado calculo do valor unitário pela quantidade de embalagem.

