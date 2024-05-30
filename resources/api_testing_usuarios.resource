*** Settings ***
Library           RequestsLibrary
Library           String
Library           Collections

*** Variables ***
${NOME}             Fulano da Silva
${PASSWORD}         teste
${ADMINISTRADOR}    true

*** Keywords ***
Criar um usuário novo
    ${palavra_aleatria}    Generate Random String    4    [LETTERS]
    ${palavra_aleatria}    Convert To Lower Case    ${palavra_aleatria}
    Log   Palavra aleatoria: ${palavra_aleatria}@emailteste.com
    Set Test Variable    ${EMAIL_TESTE}    ${palavra_aleatria}@emailteste.com
    Log   Email teste: ${EMAIL_TESTE}

Cadastrar o usuário criado na ServerRest
    [Arguments]  ${email}   ${status_code}
    ${body}     Create Dictionary    
    ...         nome=${NOME}
    ...         email=${email}   
    ...         password=${PASSWORD}    
    ...         administrador=${ADMINISTRADOR}
    Log   Body: ${body}

    Criar Sessão na ServerRest

    ${response}     POST On Session    
    ...             ServerRest    
    ...             /usuarios    
    ...             json=${body}
    ...             expected_status=${status_code}
    Log   Response: ${response.json()}
    
    IF  ${status_code} == 201
    Set Test Variable    ${ID_USER}    ${response.json()["_id"]}
    END
    
    Set Test Variable    ${RESPONSE}    ${response.json()}

Criar Sessão na ServerRest
    ${headers}    Create Dictionary     accept=application/json   Content-Type=application/json
    Create Session   ServerRest    https://serverest.dev   headers=${headers}

Conferir se o usuário foi cadastrado corretamente
    Log   ${RESPONSE}
    Dictionary Should Contain Item    ${RESPONSE}    message    Cadastro realizado com sucesso
    Dictionary Should Contain Key     ${RESPONSE}    _id

Repetir o usuário criado na ServerRest
    Cadastrar o usuário criado na ServerRest   ${EMAIL_TESTE}   status_code=400 

Conferir se o usuário não foi cadastrado novamente
    Log   ${RESPONSE}
    Dictionary Should Contain Item    ${RESPONSE}    message    Este email já está sendo usado

Consultar os dados do usuário criado
    ${response}     GET On Session    
    ...             ServerRest    
    ...             /usuarios/${RESPONSE["_id"]}
    ...             expected_status=200
    Set Test Variable    ${get_response}    ${response.json()}

Conferir se os dados do usuário estão corretos
    Dictionary Should Contain Item    ${get_response}      nome             ${NOME}
    Dictionary Should Contain Item    ${get_response}      email            ${EMAIL_TESTE}
    Dictionary Should Contain Item    ${get_response}      password         ${PASSWORD}
    Dictionary Should Contain Item    ${get_response}      administrador    ${ADMINISTRADOR}
    Dictionary Should Contain Item    ${get_response}      _id              ${ID_USER}