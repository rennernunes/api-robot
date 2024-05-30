*** Settings ***
Resource          ../resources/api_testing_usuarios.resource


*** Variables ***


*** Test Cases ***

Cenário 01: Cadastrar um novo usuário com sucesso
    Criar um usuário novo
    Cadastrar o usuário criado na ServerRest    ${EMAIL_TESTE}  status_code=201
    Conferir se o usuário foi cadastrado corretamente

Cenário 02: Cadastrar um usuário já existente
    Criar um usuário novo
    Cadastrar o usuário criado na ServerRest   ${EMAIL_TESTE}   status_code=201
    Repetir o usuário criado na ServerRest
    Conferir se o usuário não foi cadastrado novamente

Cenário 03: Consultar os dados de um novo usuário cadastrado
    [Tags]   consulta
    Criar um usuário novo
    Cadastrar o usuário criado na ServerRest   ${EMAIL_TESTE}   status_code=201
    Consultar os dados do usuário criado
    Conferir se os dados do usuário estão corretos