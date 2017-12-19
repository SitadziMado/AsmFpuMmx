.model flat, C

.stack

.data

.code

public calc_explicit
public calc_iterative
public calc_epsilon

calc_ln_arg: ; $x
                fld st(0)   ; x, x
                fld st(0)   ; x, x, x
                fmul        ; x^2, x
                
                fxch st(1)  ; x, x^2
                fld st(0)   ; x, x, x^2
                fadd        ; 2x, x^2
                
                fld1        ; 1, 2x, x^2
                fld1        ; 1, 1, 2x, x^2
                fadd        ; 2, 2x, x^2
                fadd        ; 2 + 2x, x^2
                fadd        ; 2 + 2x + x^2
                
                fld1        ; 1, 2 + 2x + x^2
                fdivr       ; 1 / (2 + 2x + x^2)
                retn

calc_explicit proc \
    $x : QWORD
                ; y = ln(1 / (2 + 2x + x^2))
                fld $x              ; x
                call calc_ln_arg    ; 1 / (2 + 2x + x^2)
                
                fld1                ; 1, 1 / (2 + 2x + x^2)
                fxch st(1)          ; 1 / (2 + 2x + x^2), 1
                fyl2x               ; log2(1 / (2 + 2x + x^2))
                fldl2e              ; log2(e), log2(1 / (2 + 2x + x^2))
                
                fdiv                ; log2(1 / (2 + 2x + x^2)) / log2(e) 
                
                ret
                
calc_explicit endp

calc_iterative proc \
    $x : QWORD,
    $n : DWORD
    
                ; a[i + 1] = a[i] + b[i + 1] / i
                ; a[0] = 0
                ; where b[i + 1] =  b[i] * (-(1 + x)^ 2)
                ;       b[0] = 1
                ;       i = 1..n
                mov ecx, $n
                jecxz zero
                
                fld $x              ; x
                call calc_ln_arg    ; 1 / (2 + 2x + x^2)
                fld1                ; 1.0, 1 / (2 + 2x + x^2)
                fchs                ; -1.0, 1 / (2 + 2x + x^2)
                fadd                ; -1.0 + 1 / (2 + 2x + x^2)
                fchs                ; c = -(-1.0 + 1 / (2 + 2x + x^2))
                
                fld1                ; n = 1.0, c
                fldz                ; a = 0.0, n, c
                fld1                ; b = 1.0, a, n, c
                
    compute:    fmul st(0), st(3)   ; b' = b * c, a, n, c
                fld st(0)           ; b', b', a, n, c
                fdiv st(0), st(3)   ; b' / n, b', a, n, c
                fld1                ; 1.0, b' / n, b', a, n, c
                faddp st(4), st(0)  ; b' / n, b', a, ++n, c
                faddp st(2), st(0)  ; b', a' = a + b' / n, ++n, c
    
                loop compute
                
                fstp st(0)
                fxch st(2)
                fstp st(0)
                fstp st(0)
                
                fchs
                
                jmp exit
                
    zero:       fldz
                
    exit:       ret

calc_iterative endp
    
calc_epsilon proc \
    $x : QWORD,
    $eps : QWORD
    
                ; a[i + 1] = a[i] + b[i + 1] / i
                ; a[0] = 0
                ; where b[i + 1] =  b[i] * (-(1 + x)^ 2)
                ;       b[0] = 1
                ;       i = 1..n
				fld $eps
                
                fld $x              ; x
                call calc_ln_arg    ; 1 / (2 + 2x + x^2)
                fld1                ; 1.0, 1 / (2 + 2x + x^2)
                fchs                ; -1.0, 1 / (2 + 2x + x^2)
                fadd                ; -1.0 + 1 / (2 + 2x + x^2)
                fchs                ; c = -(-1.0 + 1 / (2 + 2x + x^2))
                
                fld1                ; n = 1.0, c
                fldz                ; a = 0.0, n, c
                fld1                ; b = 1.0, a, n, c
                
    compute:    fmul st(0), st(3)   ; b' = b * c, a, n, c
                fld st(0)           ; b', b', a, n, c
                fdiv st(0), st(3)   ; b' / n, b', a, n, c
                fld1                ; 1.0, b' / n, b', a, n, c
                faddp st(4), st(0)  ; b' / n, b', a, ++n, c
                
                fld st(0)
                fabs
                fld st(6)
                fcompp
                fstsw ax
                
                faddp st(2), st(0)  ; b', a' = a + b' / n, ++n, c
    
                sahf
                jb compute
                
                fstp st(0)
                fxch st(2)
                fstp st(0)
                fstp st(0)
                
                fxch st(1)
                fstp st(0)
                
                fchs
                
                jmp exit
                
    zero:       fldz
                
    exit:       ret

calc_epsilon endp
    
end