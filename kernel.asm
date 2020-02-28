section .text
global _kernel

    ;  Statement:
    ; Median value of 25 elements is the minimal value such that
    ; there is at most 12 bigger elements
    ;  Input:
    ; rbx  - chosen element
    ; ymm0 - array of elements extended to the size of 32 with zeroes
    ; ymm2 - array of 32 times repeated chosen element of source array

_update_median:
    vpminub     ymm3, ymm0, ymm2  ; compare for every byte if ymm0[i] > ymm2[i]
    vpcmpeqb    ymm3, ymm3, ymm2
    vpmovmskb   edx, ymm3         ; compress the mask above to rdx register
    popcnt      edx, edx          ; count hom many elements of ymm0 are strictly bigger than chosen one
    cmp         edx, 13           ; compare popcount and 12
    jl          exit_f            ; if popcount > 12 then exit
    cmp         rbx, rax          ; else (popcount <= 12) compare chosen element and earlier found one
    jle         exit_f            ; if chosen element >= current then exit
    mov         rax, rbx          ; else save chosen element as candidate to be median
exit_f:         ret

_kernel:
    ; prepare registers

    push        rbx               ; save rbx and rcx registers
    push        rcx
    xor         rbx, rbx
    xor         rax, rax
    vpxor       ymm0, ymm0, ymm0  ; clean ymm0 and ymm1 registers
    vpxor       ymm1, ymm1, ymm1

    ; then let's load kernel matrix to ymm0:

    pinsrq      xmm0, [rdi], 0    ; load the first line to xmm0[0-3, 12]
    pinsrb      xmm0, [rdi+4], 12

    add         rdi, rsi          ; load the second line to xmm0[4-7, 13]
    pinsrq      xmm0, [rdi], 1
    pinsrb      xmm0, [rdi + 4], 13

    add         rdi, rsi          ; load the third line to xmm0[8-11, 14]
    pinsrq      xmm0, [rdi], 2
    pinsrb      xmm0, [rdi + 4], 14

    add         rdi, rsi          ; load the fourth line to xmm1[0-3, 8]
    pinsrq      xmm1, [rdi], 0
    pinsrb      xmm1, [rdi + 4], 8

    add         rdi, rsi          ; load the fifth line to xmm1[4-7, 9]
    pinsrq      xmm1, [rdi], 1
    pinsrb      xmm1, [rdi + 4], 9

    sub         rdi, rsi          ; restore kernel matrix address in rdi ( rdi -= 4 * rsi )
    sub         rdi, rsi
    sub         rdi, rsi
    sub         rdi, rsi

    vinserti128 ymm0, ymm0, xmm1, 1     ; merge xmm0 and xmm1 to ymm0 = [xmm1:xmm0]

    ; now let's iterate over 5x5 kernel and find median value
    ; (the code below is unrolled loop)

    mov             bl, byte[rdi]       ; load currently selected element of matrix to rbx
    vpbroadcastb    ymm2, byte[rdi]     ; load it to ymm2 repeated 32 times
    call            _update_median      ; call median value update function
    mov             bl, byte[rdi + 1]   ; and so on...
    vpbroadcastb    ymm2, byte[rdi + 1]
    call            _update_median
    mov             bl, byte[rdi + 2]
    vpbroadcastb    ymm2, byte[rdi + 2]
    call            _update_median
    mov             bl, byte[rdi + 3]
    vpbroadcastb    ymm2, byte[rdi + 3]
    call            _update_median
    mov             bl, byte[rdi + 4]
    vpbroadcastb    ymm2, byte[rdi + 4]
    call            _update_median

    add             rdi, rsi
    mov             bl, byte[rdi]
    vpbroadcastb    ymm2, byte[rdi]
    call            _update_median
    mov             bl, byte[rdi + 1]
    vpbroadcastb    ymm2, byte[rdi + 1]
    call            _update_median
    mov             bl, byte[rdi + 2]
    vpbroadcastb    ymm2, byte[rdi + 2]
    call            _update_median
    mov             bl, byte[rdi + 3]
    vpbroadcastb    ymm2, byte[rdi + 3]
    call            _update_median
    mov             bl, byte[rdi + 4]
    vpbroadcastb    ymm2, byte[rdi + 4]
    call            _update_median

    add             rdi, rsi
    mov             bl, byte[rdi]
    vpbroadcastb    ymm2, byte[rdi]
    call            _update_median
    mov             bl, byte[rdi + 1]
    vpbroadcastb    ymm2, byte[rdi + 1]
    call            _update_median
    mov             bl, byte[rdi + 2]
    vpbroadcastb    ymm2, byte[rdi + 2]
    call            _update_median
    mov             bl, byte[rdi + 3]
    vpbroadcastb    ymm2, byte[rdi + 3]
    call            _update_median
    mov             bl, byte[rdi + 4]
    vpbroadcastb    ymm2, byte[rdi + 4]
    call            _update_median

    add             rdi, rsi
    mov             bl, byte[rdi]
    vpbroadcastb    ymm2, byte[rdi]
    call            _update_median
    mov             bl, byte[rdi + 1]
    vpbroadcastb    ymm2, byte[rdi + 1]
    call            _update_median
    mov             bl, byte[rdi + 2]
    vpbroadcastb    ymm2, byte[rdi + 2]
    call            _update_median
    mov             bl, byte[rdi + 3]
    vpbroadcastb    ymm2, byte[rdi + 3]
    call            _update_median
    mov             bl, byte[rdi + 4]
    vpbroadcastb    ymm2, byte[rdi + 4]
    call            _update_median

    add             rdi, rsi
    mov             bl, byte[rdi]
    vpbroadcastb    ymm2, byte[rdi]
    call            _update_median
    mov             bl, byte[rdi + 1]
    vpbroadcastb    ymm2, byte[rdi + 1]
    call            _update_median
    mov             bl, byte[rdi + 2]
    vpbroadcastb    ymm2, byte[rdi + 2]
    call            _update_median
    mov             bl, byte[rdi + 3]
    vpbroadcastb    ymm2, byte[rdi + 3]
    call            _update_median
    mov             bl, byte[rdi + 4]
    vpbroadcastb    ymm2, byte[rdi + 4]
    call            _update_median

    ; and restore saved registers rbx and rcx

    pop rcx
    pop rbx
    ret

section .data
