*** Settings ***
Library           SeleniumLibrary

*** Variables ***
${URL}                        https://ultimateqa.com/complicated-page
${FORM_SELECTOR}              css=#et_pb_contact_form_0 form
${NAME_FIELD}                 css=#et_pb_contact_name_0
${EMAIL_FIELD}                css=#et_pb_contact_email_0
${MESSAGE_FIELD}              css=#et_pb_contact_message_0
${CAPTCHA_FIELD}              css=#et_pb_contact_form_0 form > div input
${SUBMIT_BUTTON}              css=#et_pb_contact_form_0 button
${EXPECTED_TITLE}             Complicated Page - Ultimate QA

*** Test Cases ***
Dado que o navegador está configurado com a viewport desejada
    Configurar Navegador

Quando o usuário navega para a página complicada do Ultimate QA
    Navegar Para Página Complicada

E o usuário preenche o formulário de contato com nome, email e mensagem
    Preencher Formulário De Contato    Teste    Teste3    Teste campo maior

E o usuário resolve o captcha e submete o formulário
    Resolver Captcha E Submeter Formulário    13

Então o título da página deve ser "Complicated Page - Ultimate QA"
    Verificar Título Da Página

*** Keywords ***
Configurar Navegador
    Open Browser    about:blank    browser=chrome
    Set Window Size    1920    1080

Navegar Para Página Complicada
    Go To    ${URL}
    Title Should Be    ${EXPECTED_TITLE}

Preencher Formulário De Contato
    [Arguments]    ${name}    ${email}    ${message}
    Wait Until Element Is Visible    ${FORM_SELECTOR}
    Input Text    ${NAME_FIELD}    ${name}
    Input Text    ${EMAIL_FIELD}    ${email}
    Input Text    ${MESSAGE_FIELD}    ${message}

Resolver Captcha E Submeter Formulário
    [Arguments]    ${captcha_solution}
    Wait Until Element Is Visible    ${CAPTCHA_FIELD}
    Input Text    ${CAPTCHA_FIELD}    ${captcha_solution}
    Click Button    ${SUBMIT_BUTTON}

Verificar Título Da Página
    Title Should Be    ${EXPECTED_TITLE}