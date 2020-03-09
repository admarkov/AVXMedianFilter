section .text
global _kernel

    ; _update_median function updates the estimated median value as stated below:
    ;  Statement:
    ; Median value of 25 elements is the maximal value such that
    ; there are at least 13 greater or equal elements
    ;  Input:
    ; rbx  - the element in question
    ; ymm0 - array of elements extended to the size of 32 with zeroes
    ; ymm2 - array of the element in question repeated 32 times
    ;  Note:
    ; There is no instruction for comparing unsigned bytes in AVX2, so the vector
    ; element-wise comparison "greater or equal" is constructed as follows:
    ;  a >= b  <=>  b == min(a, b)

_update_median:
    vpminub     ymm3, ymm0, ymm2  ; ymm3[i] := min(ymm0[i], element in question)
    vpcmpeqb    ymm3, ymm3, ymm2  ; bytewise comparing if min(ymm0[i], element in question) == element in question
    vpmovmskb   rdx, ymm3         ; compress the mask above to edx register
    and         rdx, 0b11111111110111111111111111
    popcnt      rdx, rdx          ; count how many elements of ymm0 are greater or equal than the element in question
    cmp         rdx, 13           ; compare popcount with 13
    jl          exit_f            ; if popcount < 13 then exit
    cmp         rbx, rax          ; else (popcount >= 13) compare the element in question with previously found one
    jle         exit_f            ; if element in question <= previously found then exit
    mov         rax, rbx          ; else save the element in question as relevant option for median value
exit_f:         ret

_kernel:

    ; prepare registers
    push        rbx               ; save rbx and rcx registers
    push        rcx
    xor         rbx, rbx          ; clean rbx and rax registers
    xor         rax, rax
    vpxor       ymm0, ymm0, ymm0  ; clean ymm0 and ymm1 registers
    vpxor       ymm1, ymm1, ymm1

    ; then let's load kernel matrix to ymm0:

    pinsrd      xmm0, [rdi], 0    ; load the first line to xmm0[0-3, 12]
    pinsrb      xmm0, [rdi+4], 12

    add         rdi, rsi          ; load the second line to xmm0[4-7, 13]
    pinsrd      xmm0, [rdi], 1
    pinsrb      xmm0, [rdi + 4], 13

    add         rdi, rsi          ; load the third line to xmm0[8-11, 14]
    pinsrd      xmm0, [rdi], 2
    pinsrb      xmm0, [rdi + 4], 14

    add         rdi, rsi          ; load the fourth line to xmm1[0-3, 8]
    pinsrd      xmm1, [rdi], 0
    pinsrb      xmm1, [rdi + 4], 8

    add         rdi, rsi          ; load the fifth line to xmm1[4-7, 9]
    pinsrd      xmm1, [rdi], 1
    pinsrb      xmm1, [rdi + 4], 9

    sub         rdi, rsi          ; restore kernel matrix address in rdi ( rdi -= 4 * rsi )
    sub         rdi, rsi
    sub         rdi, rsi
    sub         rdi, rsi

    vinserti128 ymm0, ymm0, xmm1, 1     ; merge xmm0 and xmm1 into ymm0 = [xmm1:xmm0]

    ; now let's iterate over 5x5 kernel and find the median value
    ; (the code below is unrolled loop)

    mov             bl, byte[rdi]       ; load currently selected element of matrix to rbx
    vpbroadcastb    ymm2, byte[rdi]     ; load it to ymm2 repeated 32 times
    call            _update_median      ; call the median value update function
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
