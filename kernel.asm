section .text
global _kernel


_kernel:
    mov al, [rdi]
    ret
