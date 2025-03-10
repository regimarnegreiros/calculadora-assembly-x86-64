section .data
    menu_msg db 'Escolha uma opcao:', 10
             db '1 - Soma', 10
             db '2 - Subtracao', 10
             db '3 - Multiplicacao', 10
             db '4 - Divisao', 10
             db 'Opcao: ', 0

    opcao_escolhida_msg db 'Opcao escolhida: ', 0
    
    erro_msg db 'Opcao invalida, escolha novamente.', 10
             db 'Opcao: ', 0

    num1_msg db 'Digite o o numero A: ', 0
    num2_msg db 'Digite o o numero B: ', 0
    
    soma_msg db ' + ', 0
    subtracao_msg db ' - ', 0
    multiplicacao_msg db ' * ', 0 
    divisao_msg db ' / ', 0
    resultado_msg db ' = ', 0

section .bss
    opcao resb 2                  ; resb 2 para armazenar o numero e o \n quando o usuario apertar enter
    num1 resb 16
    num2 resb 16
    resultado resb 16

section .text
    global _start

_start:
    mov rdi, menu_msg             ; Passa o endereço de menu_mgs para o parâmetro (rdi)
    call print_string             ; Chama a função print_message

    call coletar_opcao            ; Chama a função que coleta a opção
    call verificar_opcao          ; Verifica a opcao escolhida
    
    mov rdi, opcao_escolhida_msg
    call print_string
    
    mov rdi, opcao
    call print_string

    call ler_numeros

    mov al, [opcao]
    cmp al, '1'
    je soma
    cmp al, '2'
    je subtracao
    cmp al, '3'
    je multiplicacao
    cmp al, '4'
    je divisao

    call finalizar_programa       ; Finaliza o programa

; Funcao print_string: Imprime uma string no terminal
; Parametros:
;   rdi -> Ponteiro para a string a ser impressa
print_string:
    ; Calcula o comprimento da string
    xor rdx, rdx                  ; rdx sera o comprimento da string (inicializa o registrador com 0)

    .prox_char:
        ; Loop que conta a quantidade de caracteres de uma string
        mov al, byte [rdi + rdx]  ; Carrega o próximo byte da string (rdi: endereco inicial, rdx: tamanho da string)
        test al, al               ; Faz um E lógico entre 'al' e 'al' (verifica se 'al' é zero)
        jz .tam_encontrado        ; Se 'al' for zero, salta para .tam_encontrado
        inc rdx                   ; Incrementa rdx (rdx++)
        jmp .prox_char            ; Volta para o inicio de .prox_char fazendo um loop

    .tam_encontrado:
        ; Chama a sys_write para imprimir a string
        mov rsi, rdi              ; Ponteiro para a string que ja esta em rdi
        mov rdi, 1                ; Saída padrão (1 = STDOUT)
        mov rax, 1                ; Número da chamada sys_write
        syscall                   ; Chamada de sistema para escrever
        ret                       ; Retorna para onde a funcao foi chamada

coletar_opcao:
    mov rdi, 0                    ; Leitura da entrada padrão (0 = STDIN)
    mov rsi, opcao                ; Ponteiro para a variável opcao
    mov rdx, 2                    ; Número de bytes a serem lidos (apenas 1 caractere para a opção)
    mov rax, 0                    ; Número da chamada sys_read
    syscall                       ; Chama o sistema para ler a entrada
    ret

verificar_opcao:
    ; Verifica se a opção está entre '1' e '4'
    mov al, [opcao]               ; Simblozado por [] o valor e passado para al, um registrador de 1 byte
    cmp al, '1'                   ; Compara com o valor '1'
    je .opcao_valida              ; Se for igual a '1', pula para .opcao_valida
    cmp al, '2'
    je .opcao_valida
    cmp al, '3'
    je .opcao_valida
    cmp al, '4'
    je .opcao_valida

    ; Se nao for uma opcao valida ele mostra uma mensagem de erro e pede para o usuario digitar novamente
    mov rdi, erro_msg
    call print_string
    call coletar_opcao            ; Pede para o usuário inserir novamente
    call verificar_opcao          ; Valida a nova opção

    .opcao_valida:
        ret

; Funcao ler_string: Armazena a string em uma variavel
; Parametros:
;   rsi -> Ponteiro para a variavel que sera armazenada a string
ler_string:
    mov rdi, 0                    ; Leitura da entrada padrão (0 = STDIN)
    mov rdx, 16                   ; Número de bytes a serem lidos
    mov rax, 0                    ; Número da chamada sys_read
    syscall                       ; Chama o sistema para ler a entrada
    ret

converte_para_int:
    ret

ler_numeros:
    mov rdi, num1_msg
    call print_string

    mov rsi, num1
    call ler_string

    mov rdi, num2_msg
    call print_string

    mov rsi, num2
    call ler_string
    ret

soma:
    mov rdi, num1
    call print_string

    mov rdi, soma_msg
    call print_string

    mov rdi, num2
    call print_string

    mov rdi, resultado_msg
    call print_string

    jmp finalizar_programa

subtracao:
    mov rdi, num1
    call print_string

    mov rdi, subtracao_msg
    call print_string

    mov rdi, num2
    call print_string

    mov rdi, resultado_msg
    call print_string

    jmp finalizar_programa

multiplicacao:
    mov rdi, num1
    call print_string

    mov rdi, multiplicacao_msg
    call print_string

    mov rdi, num2
    call print_string

    mov rdi, resultado_msg
    call print_string

    jmp finalizar_programa

divisao:
    mov rdi, num1
    call print_string

    mov rdi, divisao_msg
    call print_string

    mov rdi, num2
    call print_string

    mov rdi, resultado_msg
    call print_string

    jmp finalizar_programa

; Funcao finalizar_programa: Finaliza o programa e retorna 0 (sucesso)
finalizar_programa:
    mov rax, 60                   ; Número da chamada sys_exit
    mov rdi, 0                    ; Código de saída (0 = sucesso)
    syscall                       ; Chamada de sistema para sair
    ret