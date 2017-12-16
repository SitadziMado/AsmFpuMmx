.model flat, C

.stack

.data

.code

public calc_explicit
public calc_iterative

calc_explicit proc \
    $x : QWORD
                ; y = ln(1 / (2 + 2x + x^2))
                fld $x      ; x
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
                
                fld1        ; 1, 1 / (2 + 2x + x^2)
                fxch st(1)  ; 1 / (2 + 2x + x^2), 1
                fyl2x       ; log2(1 / (2 + 2x + x^2))
                fldl2e      ; log2(e), log2(1 / (2 + 2x + x^2))
                
                fdiv        ; log2(1 / (2 + 2x + x^2)) / log2(e) 
                
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
                fld1                ; 1.0, x
                fadd                ; 1.0 + x
                fld st(0)           ; 1.0 + x, 1.0 + x
                fmul                ; (1.0 + x) ^ 2
                fchs                ; -(1.0 + x) ^ 2
                
                fld1                ; n = 1.0, -(1.0 + x) ^ 2
                fldz                ; a = 0.0, n, -(1.0 + x) ^ 2
                fld1                ; b = 1.0, a, n, -(1.0 + x) ^ 2
                
    compute:    fmul st(0), st(3)   ; b' = b * (-(1.0 + x) ^ 2), a, n, -(1.0 + x) ^ 2
                fld st(0)           ; b', b', a, n, -(1.0 + x) ^ 2
                fdiv st(0), st(3)   ; b' / n, b', a, n, -(1.0 + x) ^ 2
                fld1                ; 1.0, b' / n, b', a, n, -(1.0 + x) ^ 2
                faddp st(4), st(0)  ; b' / n, b', a, ++n, -(1.0 + x) ^ 2
                faddp st(2), st(0)  ; b', a' = a + b' / n, ++n, -(1.0 + x) ^ 2
    
                loop compute
                
                fdecstp
                fxch st(2)
                fdecstp
                fdecstp
                
                jmp exit
                
    zero:       fldz
                
    exit:       ret

calc_iterative endp
    
end