# Bonus Brilliance

# SISTEMA DE GESTÃO E PAGAMENTO DE BÔNUS — DEX INVEST

## 1. OBJETIVO DO PROJETO

Crie um sistema web profissional para automatizar, centralizar, calcular, conferir, aprovar e consolidar os pagamentos de bônus dos funcionários das lojas DEX Invest.

O sistema deve substituir o processo manual realizado atualmente em planilhas.

O objetivo principal é:

* reduzir erros de cálculo;

* eliminar cálculos manuais;

* acelerar o fechamento mensal;

* centralizar funcionários, lojas, metas, indicadores e regras;

* calcular automaticamente quanto cada funcionário deve receber;

* mostrar exatamente por que cada funcionário recebeu ou não recebeu bônus;

* permitir auditoria de todos os cálculos;

* permitir alteração das regras sem precisar alterar o código;

* gerar automaticamente o valor total a pagar por loja;

* gerar automaticamente o valor total a pagar por funcionário;

* gerar um consolidado financeiro para pagamento;

* permitir exportação para Excel/CSV;

* manter histórico mensal dos pagamentos.

IMPORTANTE:

O sistema deve possuir um MOTOR DE REGRAS configurável.

NÃO deixar valores, percentuais, cargos, critérios ou nomes fixos diretamente no código.

Todos os parâmetros devem poder ser alterados por um usuário administrador.

---

# 2. LOJAS DO GRUPO

Cadastrar inicialmente as seguintes lojas:

1. Vila Clementino

2. Parque Mandaqui

3. Jabaquara

4. Aclimação

5. Praia do Canto

6. Jardim Camburi

7. Guarulhos Gopoúva

8. Pinheiros

9. Campo Belo

10. Serra

11. Aeroporto GRU

12. Spoleto Jabaquara

Manter nome oficial da loja como campo editável.

Também permitir:

* ativar/inativar loja;

* alterar nome;

* cadastrar nova loja;

* excluir/inativar loja;

* definir região/estado;

* visualizar histórico da loja.

---

# 3. FUNCIONÁRIOS

Criar cadastro mestre de funcionários com:

* Nome completo

* Cargo

* Loja

* CPF ou identificador interno

* Status: Ativo/Inativo

* Data de admissão

* Data de desligamento

* Valor-base do bônus

* Histórico de alterações

* Observações

O funcionário deve estar vinculado a uma loja e a um cargo.

NÃO usar o nome como identificador único.

Criar um ID interno para cada funcionário.

---

# 4. FUNCIONÁRIOS IDENTIFICADOS NOS ARQUIVOS

## ACLIMAÇÃO

### Gerente

* Thales Owan Lima do Nascimento

### Trainee

* Taciano Lima de Araújo

### Operadores

* André Nicolas Mey

* Luciano Bruno Ferreira de Lima

---

## PARQUE MANDAQUI

### Gerente

* Grasielly Pinheiro

### Trainees

* Bianca Costa da Silva

* Mayara Nogueira da Silva

---

## JABAQUARA

### Gerente

* Laércio Marinho

### Trainee

* Naiza Andrade de Oliveira

### Operadores

* Carlos Eduardo Santos da Rocha

* Mikaelly Cristina Lima

---

## PINHEIROS

### Gerente

* Brenda Kenia de Castro

### Trainee

* Sabrina Angélica Ferreira Neves

### Operadores

* Denise Silva Santos

* Vinicius Silva de Souza

---

## VILA GOPOUVА / GUARULHOS GOPOÚVA

### Gerente

* Maria Suerlene Oliveira da Silva

### Trainees

* Carla Vitória Santos Munk

* Kyara Maria da Silva

### Operadores

* Geovana Carneiro de Jesus

* Luana Santos Ramos

---

## VILA CLEMENTINO

### Gerente

* Wendel Lima Paixão

### Trainee

* José Victor dos Santos Duarte

### Operadores

* Beatriz Medeiros Soares

* Jaqueline Araújo da Silva

---

## CAMPO BELO

### Gerente

* Ivanilda Batista de Jesus

### Trainees

* Emily Millena da Silva Viana

* Juliana Gomes de Carvalho

### Operadores

* Gabriel Lima da Silva

* Gisele Martinha de Alcantara

* Naiderson Saint Louis

---

## PRAIA DO CANTO

### Gerente

* Gisele

* Gizely

ATENÇÃO:

O material de origem apresenta divergência de nome para a gerente da loja. NÃO assumir automaticamente que Gisele e Gizely são a mesma pessoa.

O sistema deve permitir que o administrador faça a confirmação/correção.

### Operador

* Kaylane

---

## JARDIM CAMBURI

### Gerente

* Alexandre

---

## SERRA

### Gerente

* Monique

---

## AEROPORTO GRU

### Gerente

* Natalia Barbosa de Oliveira

Não assumir automaticamente que não existem outros funcionários. O cadastro deve permitir inclusão posterior.

---

## SPOLETO JABAQUARA

### Gerente

* Amanda Maria de Souza

### Operadores

* Nicole Anthoneli Vince de Andrade

* Sthefanny Kerolainy Felipe da Silva

* Victor da Silva Amorim

* Raika Carine Lima Oliveira

---

# 5. CARGOS E VALORES-BASE DO BÔNUS

Criar tabela de parâmetros de cargos.

## GERENTE

Valor máximo/base do bônus:

R$ 600,00

## TRAINEE

Valor máximo/base do bônus:

R$ 500,00

## OPERADOR

Valor máximo/base do bônus:

R$ 400,00

IMPORTANTE:

Esses valores NÃO devem ficar fixos no código.

Criar tela:

CONFIGURAÇÕES > CARGOS E VALORES

Onde o administrador possa alterar:

* cargo;

* valor máximo;

* critérios;

* pesos;

* valores individuais;

* vigência;

* regras específicas.

---

# 6. REGRA PRINCIPAL — GATILHO DE FATURAMENTO

O primeiro filtro para pagamento é o faturamento da loja.

A regra atual utiliza:

GATILHO DE 90% DO FATURAMENTO.

Calcular:

ATINGIMENTO = FATURAMENTO REALIZADO / META DE FATURAMENTO

Exemplo:

Meta = R$ 200.000,00

Realizado = R$ 180.000,00

Atingimento = 90%

Resultado:

GATILHO ATINGIDO.

Se o atingimento for inferior a 90%:

STATUS = SEM GATILHO

Valor de bônus = R$ 0,00

Se atingir ou superar 90%:

STATUS = GATILHO ATINGIDO

O funcionário passa para a próxima etapa da avaliação.

A meta deve ser cadastrada por loja e por período.

Campos:

* Mês/Ano

* Loja

* Meta

* Realizado

* Atingimento %

* Gatilho mínimo

* Elegível

---

# 7. CRITÉRIO ELIMINATÓRIO

Depois do gatilho de faturamento, verificar o campo:

CRITÉRIO ELIMINATÓRIO

Valores:

SIM

NÃO

Se:

Critério Eliminatório = SIM

Então:

STATUS = ELIMINADO

VALOR DO BÔNUS = R$ 0,00

Se:

Critério Eliminatório = NÃO

O funcionário continua no cálculo.

O sistema deve obrigatoriamente mostrar o motivo da eliminação.

Exemplo:

❌ ELIMINADO

Motivo: Critério eliminatório identificado.

Não mostrar apenas "R$ 0,00".

Mostrar a causa.

---

# 8. CRITÉRIOS DE AVALIAÇÃO

Os critérios utilizados nos arquivos são:

* CMV

* Taxa de Entrega

* Efetivo

* Nota iFood

* Cancelamentos/Chamados

* NPS

* Koncluí

* Unidômino's

* Pratos

* Presenteísmo

Nem todos os cargos utilizam todos os critérios.

O sistema deve permitir definir quais critérios pertencem a cada cargo.

---

# 9. REGRA DE PAGAMENTO — GERENTE

Valor máximo:

R$ 600,00

Critérios identificados na tabela de referência:

### Financeiro

* CMV — R$ 80,00

* Taxa de Entrega — R$ 80,00

* Efetivo — R$ 80,00

### Clientes

* Nota iFood — R$ 60,00

* Cancelamentos/Chamados — R$ 60,00

* NPS — R$ 30,00

### Processos

* Koncluí — R$ 120,00

### Pessoas

* Unidômino's — R$ 90,00

TOTAL DE REFERÊNCIA:

R$ 600,00

O sistema deve permitir marcar cada critério como:

ATINGIU

NÃO ATINGIU

NÃO APLICÁVEL

Cada critério atingido soma seu respectivo valor ao bônus.

---

# 10. REGRA DE PAGAMENTO — TRAINEE

Valor máximo:

R$ 500,00

Critérios identificados:

* Nota iFood — R$ 50,00

* Cancelamentos/Chamados — R$ 50,00

* NPS — R$ 50,00

* Koncluí — R$ 100,00

* Presenteísmo — R$ 250,00

TOTAL:

R$ 500,00

Cada critério deve possuir status:

ATINGIU

NÃO ATINGIU

NÃO APLICÁVEL

O sistema soma automaticamente os critérios atingidos.

---

# 11. REGRA DE PAGAMENTO — OPERADOR

Valor máximo:

R$ 400,00

Critérios identificados:

* Nota iFood — R$ 40,00

* Cancelamentos/Chamados — R$ 40,00

* NPS — R$ 40,00

* Koncluí — R$ 80,00

* Presenteísmo — R$ 200,00

TOTAL:

R$ 400,00

Cada critério deve possuir status:

ATINGIU

NÃO ATINGIU

NÃO APLICÁVEL

O sistema soma automaticamente os critérios atingidos.

---

# 12. IMPORTANTE — NÃO INVENTAR PESOS

Os arquivos possuem campos de categoria e peso percentual.

Entretanto, existem combinações que aparentam não fechar matematicamente em 100%.

Por isso:

NÃO corrigir automaticamente os pesos.

NÃO assumir que os pesos estão corretos.

NÃO substituir os valores da fonte por regras inventadas.

Criar uma tela:

CONFIGURAÇÃO > REGRAS

com:

* Categoria

* Critério

* Peso %

* Valor R$

* Cargo

* Vigência

* Status

E mostrar alerta administrativo quando os pesos não totalizarem 100%.

Exemplo:

⚠️ ATENÇÃO

Os pesos configurados para este cargo totalizam 105%.

Revise antes de aprovar o fechamento.

---

# 13. MOTOR DE CÁLCULO

O cálculo deve seguir exatamente esta ordem:

ETAPA 1

Identificar funcionário.

ETAPA 2

Identificar cargo.

ETAPA 3

Identificar loja.

ETAPA 4

Identificar período.

ETAPA 5

Buscar meta da loja.

ETAPA 6

Buscar faturamento realizado.

ETAPA 7

Calcular:

Realizado ÷ Meta × 100

ETAPA 8

Verificar gatilho mínimo de 90%.

Se < 90%:

SEM GATILHO

Bônus = R$ 0,00

Se >= 90%:

CONTINUA

ETAPA 9

Verificar critério eliminatório.

Se SIM:

ELIMINADO

Bônus = R$ 0,00

Se NÃO:

CONTINUA

ETAPA 10

Identificar regras do cargo.

ETAPA 11

Avaliar cada indicador.

ETAPA 12

Somar os valores dos critérios atingidos.

ETAPA 13

Aplicar eventuais regras adicionais de presenteísmo.

ETAPA 14

Calcular valor final.

ETAPA 15

Gerar status:

APROVADO

ELIMINADO

SEM GATILHO

PENDENTE

EM REVISÃO

---

# 14. EXEMPLO DE CÁLCULO

Funcionário:

João

Cargo:

Operador

Loja:

Exemplo

Meta:

R$ 200.000

Realizado:

R$ 190.000

Atingimento:

95%

Gatilho:

SIM

Critério eliminatório:

NÃO

Indicadores:

Nota iFood = Atingiu → R$ 40

Cancelamentos/Chamados = Atingiu → R$ 40

NPS = Não atingiu → R$ 0

Koncluí = Atingiu → R$ 80

Presenteísmo = Atingiu → R$ 200

Bônus final:

R$ 360,00

Status:

APROVADO

O sistema deve mostrar o cálculo detalhadamente.

---

# 15. TELA PRINCIPAL — DASHBOARD

Criar dashboard executivo.

Cards:

* Total de funcionários

* Total de lojas

* Funcionários elegíveis

* Funcionários eliminados

* Funcionários sem gatilho

* Total de bônus

* Total aprovado para pagamento

* Total pendente

* Média de bônus por funcionário

Gráficos:

* Bônus por loja

* Bônus por cargo

* Funcionários aprovados x eliminados

* Evolução mensal do bônus

* Atingimento das metas por loja

---

# 16. TELA — FECHAMENTO MENSAL

Selecionar:

Mês/Ano

Exemplo:

MAIO/2026

O sistema deve gerar automaticamente:

| Funcionário | Cargo | Loja | Meta | Realizado | Atingimento | Gatilho | Eliminatório | Bônus |

| ----------- | ----- | ---- | ---: | --------: | ----------: | ------- | ------------ | ----: |

Permitir filtros por:

* Loja

* Cargo

* Status

* Funcionário

---

# 17. TELA — PAGAMENTO

Criar uma tela específica chamada:

PAGAR BÔNUS

Mostrar:

## TOTAL GERAL

R$ XX.XXX,XX

## POR LOJA

Vila Clementino

R$ XXXX

Parque Mandaqui

R$ XXXX

Jabaquara

R$ XXXX

Aclimação

R$ XXXX

Praia do Canto

R$ XXXX

Jardim Camburi

R$ XXXX

Guarulhos Gopoúva

R$ XXXX

Pinheiros

R$ XXXX

Campo Belo

R$ XXXX

Serra

R$ XXXX

Aeroporto GRU

R$ XXXX

Spoleto Jabaquara

R$ XXXX

---

# 18. PAGAMENTO POR FUNCIONÁRIO

Criar tabela:

Funcionário

Cargo

Loja

Valor do bônus

Status

Forma de pagamento

Data prevista

Data de pagamento

Observação

Permitir marcar:

PAGO

PENDENTE

BLOQUEADO

EM REVISÃO

---

# 19. CONSOLIDADO FINANCEIRO

Criar relatório:

CONSOLIDADO PARA FINANCEIRO

Colunas:

* Competência

* Loja

* Funcionário

* Cargo

* Valor bônus

* Status

* Motivo

* Forma de pagamento

* Identificador interno

Criar botão:

EXPORTAR EXCEL

Criar botão:

EXPORTAR CSV

Criar botão:

GERAR RELATÓRIO PDF

---

# 20. HISTÓRICO

Cada fechamento mensal deve ser congelado.

Exemplo:

MAIO/2026

JUNHO/2026

JULHO/2026

AGOSTO/2026

Depois de aprovado, o sistema não deve recalcular silenciosamente um período antigo se as regras forem alteradas.

Criar versionamento das regras.

Exemplo:

Regra vigente em maio/2026:

Operador = R$ 400

Regra vigente em setembro/2026:

Operador = R$ 450

O histórico de maio deve continuar calculado com a regra de maio.

---

# 21. AUDITORIA

Cada cálculo deve possuir memória de cálculo.

Ao clicar no valor:

R$ 320,00

abrir:

MEMÓRIA DE CÁLCULO

* Meta da loja

* Faturamento realizado

* % atingimento

* Gatilho

* Critério eliminatório

* Critérios atingidos

* Critérios não atingidos

* Valor de cada critério

* Total bruto

* Ajustes

* Valor final

* Usuário responsável

* Data/hora do cálculo

* Versão da regra utilizada

---

# 22. ALERTAS AUTOMÁTICOS

O sistema deve identificar:

⚠️ Meta não cadastrada

⚠️ Faturamento não informado

⚠️ Indicador não informado

⚠️ Funcionário sem cargo

⚠️ Funcionário sem loja

⚠️ Regra sem valor

⚠️ Pesos diferentes de 100%

⚠️ Funcionário duplicado

⚠️ Loja sem gerente

⚠️ Funcionário com dados conflitantes

⚠️ Regra alterada após fechamento

NUNCA calcular silenciosamente quando houver informação crítica faltando.

---

# 23. IMPORTAÇÃO DE DADOS

Criar função:

IMPORTAR EXCEL

Permitir importar:

* funcionários;

* lojas;

* metas;

* faturamento;

* indicadores;

* critérios;

* pagamentos.

O sistema deve validar a planilha antes de importar.

Mostrar:

REGISTROS VÁLIDOS

REGISTROS COM ERRO

REGISTROS DUPLICADOS

E permitir correção antes da confirmação.

---

# 24. BANCO DE DADOS

Estruturar o banco de dados, preferencialmente utilizando Supabase/PostgreSQL.

Criar entidades:

stores

employees

roles

bonus_rules

rule_versions

monthly_targets

monthly_revenue

monthly_indicators

employee_bonus_results

bonus_payments

audit_logs

users

Relacionamentos:

LOJA → FUNCIONÁRIOS

CARGO → REGRAS

CARGO + REGRA → VALOR

LOJA + PERÍODO → META

LOJA + PERÍODO → FATURAMENTO

FUNCIONÁRIO + PERÍODO → RESULTADO DO BÔNUS

---

# 25. SEGURANÇA E PERMISSÕES

Criar perfis:

ADMINISTRADOR

GESTOR

FINANCEIRO

CONSULTA

ADMINISTRADOR:

Pode alterar regras, funcionários, lojas e valores.

GESTOR:

Pode lançar indicadores e consultar resultados.

FINANCEIRO:

Pode consultar, aprovar e exportar pagamentos.

CONSULTA:

Somente visualização.

Toda alteração de regra deve gerar registro de auditoria.

---

# 26. INTERFACE

Criar interface profissional, limpa e corporativa.

Priorizar:

* azul;

* vermelho;

* branco;

* cinza;

* elementos visuais inspirados no ambiente Domino's, sem copiar identidade visual protegida indevidamente.

Layout:

Sidebar lateral.

Menu:

Dashboard

Lojas

Funcionários

Cargos

Metas

Indicadores

Fechamento Mensal

Pagar Bônus

Financeiro

Histórico

Regras

Auditoria

Configurações

---

# 27. REGRA FUNDAMENTAL DO SISTEMA

O sistema não deve simplesmente mostrar um número.

Ele deve explicar:

POR QUE O FUNCIONÁRIO RECEBEU?

POR QUE RECEBEU ESSE VALOR?

POR QUE NÃO RECEBEU MAIS?

POR QUE FOI ELIMINADO?

POR QUE NÃO TEVE GATILHO?

Isso é fundamental para evitar erros e discussões no fechamento.

---

# 28. CONCILIAÇÃO COM OS DADOS EXISTENTES

Os arquivos atuais devem ser tratados como fonte inicial de dados.

Existem planilhas separadas por loja, gerentes, trainees, financeiro e consolidado. O sistema deve transformar essas informações em uma base única.

Os arquivos apresentam exemplos de status como:

APROVADO

ELIMINADO

SEM GATILHO

e campos como:

Gatilho 90% Fat

Critério Eliminatório

CMV

Taxa Entrega

Efetivo

Nota iFood

Canc./Chamados

NPS

Koncluí

Unidômino's

Presenteísmo

Total

Esses campos devem ser incorporados ao sistema.

---

# 29. NÃO FAZER

NÃO criar cálculos manuais.

NÃO deixar valores fixos no frontend.

NÃO deixar regras espalhadas no código.

NÃO apagar histórico quando uma regra mudar.

NÃO alterar nomes automaticamente.

NÃO assumir que dois nomes parecidos são a mesma pessoa.

NÃO considerar funcionário sem dados como aprovado.

NÃO calcular bônus se faltar informação essencial.

NÃO permitir pagamento sem memória de cálculo.

NÃO permitir alteração retroativa sem registrar auditoria.

---

# 30. RESULTADO ESPERADO

Quero um sistema em que o processo mensal seja:

1. Cadastrar/importar metas.

2. Importar faturamento.

3. Importar indicadores.

4. Sistema identifica funcionários.

5. Sistema identifica cargos.

6. Sistema aplica o gatilho de 90%.

7. Sistema verifica critérios eliminatórios.

8. Sistema aplica regras do cargo.

9. Sistema calcula automaticamente o bônus.

10. Sistema mostra a memória de cálculo.

11. Gestor revisa.

12. Financeiro aprova.

13. Sistema gera consolidado de pagamento.

14. Financeiro exporta Excel/CSV.

15. Sistema grava o fechamento.

16. Histórico permanece disponível.

O objetivo é transformar o processo atual de planilhas em um verdadeiro SISTEMA DE CÁLCULO, CONFERÊNCIA E PAGAMENTO DE BÔNUS.

Antes de finalizar a implementação, faça uma validação de todas as regras encontradas nos dados importados e sinalize qualquer inconsistência, divergência de nomes, pesos que não fecham em 100%, valores que não fecham com o total do cargo ou funcionários sem cadastro completo.

NÃO invente informações para preencher lacunas.

Quando houver dúvida, sinalize a inconsistência para decisão do administrador.

This project was built with [Lovable](https://lovable.dev).

**Live app**: https://bonus-wise-logic.lovable.app

## Build with Lovable

Continue developing this project in the [Lovable editor](https://lovable.dev/projects/f5cd5f2b-d284-4a32-8c86-6a99e3411dc1).

- **Ship faster**: describe what you want to build and Lovable handles the code.
- **Stay in sync**: every change made in Lovable is committed straight to this repository.
- **Full ownership**: this code is yours. Push to `main` on GitHub and your changes sync back into Lovable, ready for your next prompt.

## Development

Prefer working locally? You need Node.js and npm — [install with nvm](https://github.com/nvm-sh/nvm#installing-and-updating).

```sh
git clone <this-repository-url>
cd <repository-name>
npm i
npm run dev
```
