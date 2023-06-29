<h1>Gestão de Cartões e Pagamentos 💸 💳</h1> 

<p align="center">
  <img src="http://img.shields.io/static/v1?label=Ruby&message=3.1.2&color=red&style=for-the-badge&logo=ruby"/>
  <img src="http://img.shields.io/static/v1?label=Ruby%20On%20Rails%20&message=7.0.5.1&color=red&style=for-the-badge&logo=ruby"/>
   <img src="http://img.shields.io/static/v1?label=STATUS&message=EM%20DESENVOLVIMENTO&color=RED&style=for-the-badge"/>
</p>

> Status do Projeto: ⚠️ Projeto em Desenvolvimento
## Sobre o Projeto
<p>

Projeto final do time de Cartões e Pagamentos da turma 10 do [TreinaDev](https://treinadev.com.br/), realizado pela [Campus Code](https://www.campuscode.com.br/).
Esta é a terceira aplicação do projeto Clube de Compras que envolve mais 2 aplicações integradas ([Gestão de Empresas](https://github.com/TreinaDev/GestaoEmpresasTD10) e 
[Loja do Clube](https://github.com/TreinaDev/LojaClubeTD10)), por isso certifique-se de que tenha os 3 projetos rodando, para total funcionamento da aplicação do projeto Clube de Compras.

</p>

## Sumário
1. [Configurações ⚙️](#configurações)
    * [Pré Requisitos](#pré-requisitos)
    * [Principais Gems](#principais-gems)
    * [Como baixar o projeto](#como-baixar-o-projeto)
    * [Como rodar a aplicação](#como-rodar-a-aplicação)
    * [Como rodar os testes](#como-rodar-os-testes)
    * [Como executar o app](#como-executar-o-app)
    * [Rodando as outras aplicações](#rodando-as-outras-aplicações)
2. [Funcionalidades 🔧](#funcionalidades)
    * ✔️ [Controle de Usuários](#controle-de-usuários)
    * ✔️ [Gestão de Tipos de Cartão](#gestão-de-tipos-de-cartão)
    * ✔️ [Emissão de cartões](#emissão-de-cartões)
    * ✔️ [Controle de pontos](#controle-de-pontos)
    * ✔️ [Cashback](#cashback)
3. [Endpoints 🎯](#endpoints) 
    * ✔️ [Consulta de tipos de cartão disponíveis](#consulta-de-tipos-de-cartão-disponíveis)
    * ✔️ [Solicitar emissão de cartão](#solicitar-emissão-de-cartão)
    * ✔️ [Solicitar upgrade do cartão](#solicitar-upgrade-do-cartão)
    * ✔️ [Solicitar desativação do cartão](#solicitar-desativação-do-cartão)
    * ✔️ [Solicitar ativação do cartão](#solicitar-ativação-do-cartão)
    * ✔️ [Solicitar bloqueio definitivo do cartão](#solicitar-bloqueio-definitivo-do-cartão)
    * ✔️ [Consulta de dados do cartão ](#consulta-de-dados-do-cartão)
    * ✔️ [Consulta do extrato do cartão](#consulta-do-extrato-do-cartão)
    * ✔️ [Recarga de cartões](#recarga-de-cartões)
    * ✔️ [Gerar Pedido de pagamento](#gerar-pedido-de-pagamento)
    * ✔️ [Consulta pagamento](#consulta-pagamento)
4. [Equipe 🤓](#equipe)

## Configurações
### Pré-requisitos
⚠️ [Ruby](https://github.com/ruby/ruby) </br>
⚠️ [Ruby On Rails](https://github.com/rails/rails)
### Principais Gems
⚠️ [Devise](https://github.com/heartcombo/devise) </br>
⚠️ [Faraday](https://github.com/lostisland/faraday) </br>
⚠️ [Bootstrap](https://github.com/twbs/bootstrap-rubygem) </br>
⚠️ [Capybara](https://github.com/teamcapybara/capybara) </br>
⚠️ [Rspec](https://github.com/rspec/rspec-rails) </br>
⚠️ [Simplecov](https://github.com/simplecov-ruby/simplecov) </br>
⚠️ [Rubocop 🚓 💀](https://github.com/rubocop/rubocop) </br>

### Como baixar o projeto
 No terminal, faça um clone do projeto com o código abaixo:
 ```
 git clone git@github.com:TreinaDev/CartoesEPagamentosTD10.git
 ```
### Como rodar a aplicação
No terminal, entre na pasta do projeto e digite:
```
bin/setup
```
Logo após:
```
rails db:seed
```
#### Sobre as seeds
As seeds irão popular a aplicação com dados já prontos para facilitar a interação do usuário com ela.
1. Usuários previamente cadastrados:
    * ``admin@punti.com`` e ``luana@punti.com``, ambos com a senha ``123456``
2. Tipos de cartões pré-cadastrados:

    |Nome|Pontos|Status de Emissão|
    |----|------|-----------------|
    |Gold|100|Ativo|
    |Platinum|200|Ativo|
    |Black|300|Inativo|
3. Cartões Pré Cadastrados:

    |Id|CPF|Status|
    |--|---|------|
    |1|30383993024|Ativo|
    |2|40247099090|Ativo|
    |3|52399436059|Ativo|
    |4|62222694000|Inativo|
4. Pagamentos Pré Cadastrados:

    |Id do cartão|Número do Pedido|
    |------------|----------------|
    |1|12345678912|
    |1|35241568212|
    |Inexistente|56812547891|
    |4|87512456988|
    |2|92548741589|
    |4|41589925487|

<br>

### Como rodar os testes

No terminal, abra a pasta do projeto e digite:

```
$ rspec
```

### Como executar o app

No terminal e dentro da página do projeto, digite:
```
bin/dev
```
No navegador, utilize a seguinte URL:
```
http://localhost:4000/
```

### Rodando as outras aplicações
Baixe o clone das outras duas aplicações e repita o mesmo processo descrito acima. 
```
https://github.com/TreinaDev/LojaClubeTD10.git
```
```
https://github.com/TreinaDev/GestaoEmpresasTD10.git
```
⚠️ **Observação**: A aplicação de gestão de empresas irá rodar na porta 3000 e a da loja na porta 5000 

<br>

## Funcionalidades
### **Controle de Usuários**

A aplicação tem um único perfil administrador responsável por todas as operações e deve ter e-mail com domínio ``punti.com``.
### **Gestão de Tipos de Cartão**

Um administrador pode gerenciar ``tipos diferentes de cartões`` que contém um ``nome``, um ``ícone`` e um ``total de pontos pré-estabelecido``. O administrador é capaz de indicar quais tipos de cartões devem estar disponíveis para cada uma das empresas parceiras do clube.

Um tipo de cartão pode ser desativado para novas emissões e os cartões já emitidos para este tipo não devem sofreram nenhum tipo de mudança. Somente a emissão de novos cartões fica suspensa.

### **Emissão de cartões**
A aplicação de Empresas e Benefícios pode solicitar a emissão de cartões para um funcionário, informando seu CPF e o tipo de cartão desejado. 

Cada cartão emitido tem um ``número único`` e ``aleatório com 20 caracteres`` e é abastecido com os pontos pré-estabelecidos de acordo com seu tipo.

A aplicação de Empresas também pode solicitar o upgrade do cartão de um funcionário informando o CPF. O upgrade só poderá ocorrer caso o novo tipo de cartão a ser emitido esteja disponível para a empresa atual do funcionário. Ela também pode solicitar o bloqueio definitivo de um cartão e o mesmo não poderá mais ser usado.

### **Controle de pontos**
Todos os pagamentos feitos no projeto são baseados em pontos. Será possível consultar a pontuação e o extrato do cartão, além de solicitar recargas para os cartões de funcionários.

As compras feitas na aplicação da Loja do Clube são sempre convertidas de reais para pontos e a taxa de conversão de cada empresa é gerenciada pelos administradores da aplicação de cartões e pagamentos.

### **Pagamentos**

Após finalizar um pedido na loja, um pagamento é gerado com um ``código aleatório`` e um ``status pendente``. Esse pagamento pode ser consultado, pelo time da loja, através do seu código para verificar o status do mesmo.

Após a criação de um pagamento, ele passa por validações automáticas inicias de: cartão válido, CPF associado ao cartão, saldo suficiente e ficam disponiveis para aprovação ou reprovação final pelo administrador. 
As aprovações finais pelo administrador só serão aceitas se o cartão tiver saldo suficiente e as reprovações geram uma mensagem de erro que é retornada em consultas feitas pela loja.

### **Cashback**
Um administrador pode definir regras de cashback para tipos de cartões que variam de acordo com cada empresa. As regras de cashback definem um valor mínimo para o pedido em pontos e o percentual de cashback a ser restituído.

Quando um pagamento é aprovado, caso existam regras de cashback é gerado um valor calculado como cashback. Este valor é descrito como resultado de um cashback.

Os pontos gerados como cashback tem uma data limite para utilização e no momento de aprovar um pagamento, caso existam, os pontos com data limite de utilização devem ser priorizados.
## Endpoints
### **Consulta de tipos de cartão disponíveis**
<details>
<summary>📄</summary>

* Exemplo de chamada da API
```
GET http://localhost:4000/api/v1/company_card_types?cnpj=cnpj_da_empresa
```
* Exemplo de resposta
    - **Observações**: ``start points`` são os pontos iniciais do cartão e ``company_card_type_id`` é o id do tipo de cartão vinculado ao cartão
```
[
    {
        "company_card_type_id": 1,
        "name": "Gold",
        "icon": "http://localhost:4000/gold.svg",
        "start_points": 100,
        "conversion_tax": 20.0
    },
    {
        "company_card_type_id": 4,
        "name": "Platinum",
        "icon": "http://localhost:4000/premium.svg",
        "start_points": 200,
        "conversion_tax": 12.0
    }
]
```
<details>
<summary>Imagem ilustrativa da resposta</summary>
<br>
<img src='https://i.imgur.com/H1I9mu3.png'/>
</details>
<br>

</details>
<br>

### **Solicitar emissão de cartão**
<details>
<summary>📄</summary>

* Exemplo de chamada da API
```
POST http://localhost:4000/api/v1/cards
```
* Exemplo de corpo da requisição
    - **Observação**: o ```company_card_type_id``` é fornecido pela API de consulta de tipos de cartão da empresa
```
{
    "cpf": "cpf_funcionario",
    "company_card_type_id": 1
}
```
<details>
<summary>Imagem ilustrativa da resposta</summary>
<br>
<img src='https://i.imgur.com/yHZV6kc.png'/>
</details>
<br>

</details>
<br>

### **Solicitar upgrade do cartão**
<details>
<summary>📄</summary>

* Exemplo de chamada da API

```
POST http://localhost:4000/api/v1/cards/upgrade
```
- **Observação**: após o upgrade, o cartão anterior é bloqueado
<details>
<summary>Imagem ilustrativa da resposta</summary>
<br>
<img src='https://i.imgur.com/Pkjf5CI.png'/>
</details>
<br>

</details>
<br>

### **Solicitar desativação do cartão**
<details>
<summary>📄</summary>

* Exemplo de chamada da API

```
PATCH http://localhost:4000/api/v1/cards/id_cartao/deactivate
```
<details>
<summary>Imagem ilustrativa da resposta</summary>
<br>
<img src='https://i.imgur.com/n85KCZr.png'/>
</details>
<br>

</details>
<br>

### **Solicitar ativação do cartão**
<details>
<summary>📄</summary>

* Exemplo de chamada da API

```
PATCH http://localhost:4000/api/v1/cards/id_cartao/activate
```
<details>
<summary>Imagem ilustrativa da resposta</summary>
<br>
<img src='https://i.imgur.com/DsXs2Yo.png'/>
</details>
<br>

</details>
<br>

### **Solicitar bloqueio definitivo do cartão**
<details>
<summary>📄</summary>

* Exemplo de chamada da API

```
DELETE http://localhost:4000/api/v1/cards/id_cartao/block
```
<details>
<summary>Imagem ilustrativa da resposta</summary>
<br>
<img src='https://i.imgur.com/uQ7HwWV.png'/>
</details>
<br>

</details>
<br>

### **Consulta de dados do cartão**
<details>
<summary>📄</summary>

* Exemplo de chamada da API

```
GET http://localhost:4000/api/v1/cards/cpf_funcionario
```
<details>
<summary>Imagem ilustrativa da resposta</summary>
<br>
<img src='https://i.imgur.com/6aReGQz.png'/>
</details>
<br>

</details>
<br>

### **Consulta do extrato do cartão**
<details>
<summary>📄</summary>

* Exemplo de chamada da API

```
GET http://localhost:4000/api/v1/extracts?card_number=card_number
```
- **Observação**: o ``value`` retornado é em pontos, usando a taxa de conversão vinculada ao cartão

<details>
<summary>Imagem ilustrativa da resposta</summary>
<br>
<img src='https://i.imgur.com/KAQ61gC.png'/>
</details>
<br>

</details>
<br>

### **Recarga de cartões**
<details>
<summary>📄</summary>

* Exemplo de chamada da API
```
PATCH http://localhost:4000/api/v1/cards/recharge
```
* Exemplo de corpo da requisição
    - **Observação**: O ``value`` deve ser em reais
```
{
   "recharge":[
      {
         "cpf":"cpf_funcionario",
         "value":15
      },
      {
         "cpf":"cpf_funcionario",
         "value":25
      }
   ]
}
```
<details>
<summary>Imagem ilustrativa da resposta</summary>
<br>
<img src='https://i.imgur.com/8L9v6ER.png'/>
</details>
<br>

</details>
<br>

### **Gerar Pedido de pagamento**
<details>
<summary>📄</summary>

* Exemplo de chamada da API
```
POST http://localhost:4000/api/v1/payments
```
* Exemplo de corpo da requisição
- **Observação**: o ``total_value``, ``descount_amount`` e  ``final_value`` devem estar em reais
```
{
   "order_number":"123246",
   "total_value":300,
   "descount_amount":50,
   "final_value":250,
   "cpf":"cpf_funcionario",
   "card_number":"12345678912345678912",
   "payment_date":"2023-06-27"
}
```
<details>
<summary>Imagem ilustrativa da resposta</summary>
<br>
<img src='https://i.imgur.com/IINWoKE.png'/>
</details>
<br>

</details>
<br>

### **Consulta pagamento**
<details>
<summary>📄</summary>

* Exemplo de chamada da API
    - **Observação**: o ``code`` é fornecido na criação de um pedido de pagamento
```
GET http://localhost:4000/api/v1/payments/code
```
<details>
<summary>Imagem ilustrativa da resposta</summary>
<br>
<img src='https://i.imgur.com/HVgsO0J.png'/>
</details>
<br>

</details>
<br>

## Equipe
### Projeto Desenvolvido Por:

|Erick Palombo|Natalia Oliveira|Gustavo Alberto|Rafael de Jesus|Luiz Quintanilha|Thiago Firmino|Pedro Monteiro|
|------------|----------------|---------------|----------------|---------------|----------------|---------------|
|<img src="https://github.com/Degorous.png" alt="Erick Palombo" width="75">|<img src="https://github.com/noliv197.png" alt="Natalia Oliveira" width="75">|<img src="https://github.com/ga9br1.png" alt="Gustavo Alberto" width="75">|<img src="https://github.com/rafaeldejesusl.png" alt="Rafael de Jesus" width="75">|<img src="https://github.com/LuizQuintanilha.png" alt="Luiz Quintanilha" width="75">|<img src="https://github.com/ThiagoDFi.png" alt="Thiago" width="75">|<img src="https://github.com/montteiropedro.png" alt="Pedro Monteiro" width="75">|
|[@Degorous](https://github.com/Degorous)|[@noliv197](https://github.com/noliv197)|[@ga9br1](https://github.com/ga9br1)|[@rafaeldejesusl](https://github.com/rafaeldejesusl)|[@LuizQuintanilha](https://github.com/LuizQuintanilha)|[@ThiagoDFi](https://github.com/ThiagoDFi)|[@montteiropedro](https://github.com/montteiropedro)|

<br>

### Em conjunto com:
[Campus Code](https://www.campuscode.com.br/)<br>
[Time de Gestão de Empresas](https://github.com/TreinaDev/GestaoEmpresasTD10)<br>
[Time da Loja](https://github.com/TreinaDev/LojaClubeTD10)
