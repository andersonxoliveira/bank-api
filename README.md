# Bank API
A aplicação trata as movimentações que um cliente pode fazer ao chegar no caixa de um banco.

**O cliente pode fazer**
* Cadastrar, Editar e Encerrar sua Conta
* Realizar Depósitos
* Realizar Saques
* Realizar Transferências entre Contas
* Solicitar Saldo
* Solicitar Extrato Filtrando por Data Início e Final

# Enpoint

## Abertura (Cadastro) de Conta
POST /accounts

*Formato de requisição*
```json
{
    "data": {
        "attributes": {
            "user-attributes": {
                "name": "anderson Oliveira",
                "email": "anderson@gmail.com",
                "password": "1234",
                "password_confirmation": "1234"
            }
        }
    }
}
```
*Obs*: Nessa rota os valores defaul são colocados dentro da model de Account.

## Editar informações da Conta
PUT  /auth
```json
{
    "name": "Anderson Novo"
}
```
*Obs*: Basta passar os campos que deseja alterar no body da requisição.

## Encerrar a Conta
PUT  /accounts/disable

*Formato de resposta*
```json
{
  "message": "Conta desativada com sucesso!"
}
```

## Realizar Depósitos
POST  /transactions
*Formato de requisição*
```json
{
    "data": {
        "attributes": {
            "value": 100,
            "transaction-type": 0
        }
    }
}
```
*Obs*: `transaction-type` é o código da transação.


## Realizar Saques
POST  /transactions
*Formato de requisição*
```json
{
    "data": {
        "attributes": {
            "value": 50,
            "transaction-type": 1
        }
    }
}
```
*Obs*: `transaction-type` é o código da transação.


## Realizar Transferências entre Contas
POST  /transactions
*Formato de requisição*
```json
{
    "data": {
        "attributes": {
            "value": 30,
            "transaction-type": 2,
            "destination-account-id": 9
        }
    }
}
```
*Obs*: `transaction-type` é o código da transação.


## Solicitar Saldo
GET  /accounts
*Formato de requisição*
```json
{
    "data": {
        "id": "7",
        "type": "account",
        "attributes": {
            "id": 7,
            "code": "2106724",
            "status": "active",
            "score": 33.0,
            "user": {
                "id": 6,
                "provider": "email",
                "uid": "igor@gmail.com",
                "allow_password_change": false,
                "name": "Igor Silva",
                "email": "igor@gmail.com",
                "created_at": "2022-07-25T01:13:46.368Z",
                "updated_at": "2022-07-25T18:11:54.098Z",
                "user_type": "normal"
            }
        }
    }
}
```
*Obs*: O campo do saldo é o `score`.


## Solicitar Extrato Filtrando por Data Início e Final
GET  /transactions?filter[initial_date]=2022-07-24&filter[end_date]=2022-07-26
*Formato de requisição*
```json
{
    "data": [
        {
            "id": "24",
            "type": "transaction",
            "attributes": {
                "id": 24,
                "value": 50.0,
                "status": null,
                "transaction-type": "transfers_between_accounts",
                "account": {
                    "id": 7,
                    "user_id": 6,
                    "code": "2106724",
                    "status": "active",
                    "score": 33.0,
                    "created_at": "2022-07-25T01:13:46.370Z",
                    "updated_at": "2022-07-25T02:35:57.823Z"
                },
                "destination-account": {
                    "id": 9,
                    "user_id": 8,
                    "code": "9769392",
                    "status": "active",
                    "score": 10.0,
                    "created_at": "2022-07-25T01:58:32.608Z",
                    "updated_at": "2022-07-25T02:35:57.814Z"
                }
            }
        },
        ...
        {
            "id": "27",
            "type": "transaction",
            "attributes": {
                "id": 27,
                "value": 10.0,
                "status": null,
                "transaction-type": "transfers_between_accounts",
                "account": {
                    "id": 7,
                    "user_id": 6,
                    "code": "2106724",
                    "status": "active",
                    "score": 33.0,
                    "created_at": "2022-07-25T01:13:46.370Z",
                    "updated_at": "2022-07-25T02:35:57.823Z"
                },
                "destination-account": {
                    "id": 9,
                    "user_id": 8,
                    "code": "9769392",
                    "status": "active",
                    "score": 10.0,
                    "created_at": "2022-07-25T01:58:32.608Z",
                    "updated_at": "2022-07-25T02:35:57.814Z"
                }
            }
        }
    ]
}
```
*Obs*: Não tive tempo para fazer um checkup de segurança, como por exemplo, para o um usuário não ver o saldo da conta que não é dele.
