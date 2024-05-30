*** Settings ***
Library           RequestsLibrary
Library           String
Library           Collections
Library           JSONLibrary

*** Test Cases ***

Cenário: Realizar autenticação e cadastrar um produto com sucesso
    Realizar autenticação na ServerRest
    Cadastrar um produto na ServerRest   status_code=201
    Conferir se o produto foi cadastrado corretamente

*** Variables ***
${EMAIL}             leaa@emailteste.com
${PASSWORD}          teste
${NOME_PRODUTO}      ${EMPTY}
${PRECO_PRODUTO}     470
${DESCRICAO_PRODUTO}    Mouse
${QUANTIDADE_PRODUTO}   381
${TOKEN}             ${EMPTY}

*** Keywords ***
Realizar autenticação na ServerRest
    ${body}    Create Dictionary    email=${EMAIL}    password=${PASSWORD}
    Log    Body: ${body}

    Criar Sessão na ServerRest

    ${response}    POST On Session
    ...            ServerRest
    ...            /login
    ...            json=${body}
    ...            expected_status=200
    Log    Response: ${response.json()}
    Set Test Variable    ${TOKEN}    ${response.json()["authorization"]}
    Log    Token: ${TOKEN}

Cadastrar um produto na ServerRest
    [Arguments]    ${status_code}
    ${NOME_PRODUTO}   Generate Random String    15    [LETTERS]
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${body}    Create Dictionary
    ...         nome=${NOME_PRODUTO}
    ...         preco=${PRECO_PRODUTO}
    ...         descricao=${DESCRICAO_PRODUTO}
    ...         quantidade=${QUANTIDADE_PRODUTO}
    Log    Body: ${body}

    ${response}    POST On Session
    ...            ServerRest
    ...            /produtos
    ...            headers=${headers}
    ...            json=${body}
    ...            expected_status=${status_code}
    Log    Response: ${response.json()}

    IF    ${status_code} == 201
    Set Test Variable    ${ID_PRODUTO}    ${response.json()["_id"]}
    END

    Set Test Variable    ${RESPONSE_PRODUTO}    ${response.json()}

Conferir se o produto foi cadastrado corretamente
    Log    ${RESPONSE_PRODUTO}
    Dictionary Should Contain Item    ${RESPONSE_PRODUTO}    message    Cadastro realizado com sucesso
    Dictionary Should Contain Key     ${RESPONSE_PRODUTO}    _id

Criar Sessão na ServerRest
    ${headers}    Create Dictionary    accept=application/json    Content-Type=application/json
    Create Session    ServerRest    https://serverest.dev    headers=${headers}