.model flat, C

.stack

.data

MMX_LEN_LOG2 EQU 3
MMX_LEN EQU 8
ONES EQU 0FFFFFFFFh

.code

@test_edi_len macro

                mov ecx, $len
                bsf eax, ecx
                jz null
                
                cmp eax, MMX_LEN_LOG2
                jb null
                
                shr ecx, MMX_LEN_LOG2
    
                mov edi, $dst
                test edi, edi
                jz null
                
                mov eax, edi

endm

@prologue macro

                @test_edi_len
                
                mov esi, $src
                test esi, esi
                jz null
                
                
    @@:         movq mm0, [edi]
                movq mm1, [esi]
                
                add esi, MMX_LEN

endm

@epilogue macro

                movq [edi], mm0
                
                add edi, MMX_LEN
                
                loop @B
                
                emms
                
                jmp exit
                
    null: xor eax, eax
    
    exit: ret

endm

public mmx_add_bytes
public mmx_add_words
public mmx_sub_bytes
public mmx_sub_words
public mmx_mul_words_by_power_of_two
public mmx_div_words_by_power_of_two
public mmx_are_bytes_eq
public mmx_are_bytes_gt

mmx_add_bytes proc \
    $dst : PTR QWORD, \
    $src : PTR QWORD, \
    $len : DWORD

                @prologue
                paddb mm0, mm1
                @epilogue
    
mmx_add_bytes endp

mmx_add_words proc \
    $dst : PTR QWORD, \
    $src : PTR QWORD, \
    $len : DWORD

                @prologue
                paddsw mm0, mm1
                @epilogue
    
mmx_add_words endp

mmx_sub_bytes proc \
    $dst : PTR QWORD, \
    $src : PTR QWORD, \
    $len : DWORD

                @prologue
                psubb mm0, mm1
                @epilogue
    
mmx_sub_bytes endp

mmx_sub_words proc \
    $dst : PTR QWORD, \
    $src : PTR QWORD, \
    $len : DWORD

                @prologue
                psubsw mm0, mm1
                @epilogue
    
mmx_sub_words endp

mmx_mul_words_by_power_of_two proc \
    $dst : PTR QWORD, \
    $len : DWORD, \
    $power_of_two : DWORD

                @test_edi_len
                
                mov eax, $power_of_two
                movd mm1, eax
                
    @@:         psllw mm0, mm1
                
                @epilogue
    
mmx_mul_words_by_power_of_two endp

mmx_div_words_by_power_of_two proc \
    $dst : PTR QWORD, \
    $len : DWORD, \
    $power_of_two : DWORD

                @test_edi_len
                
                mov eax, $power_of_two
                movd mm1, eax
                
    @@:         psraw mm0, mm1
                
                @epilogue
    
mmx_div_words_by_power_of_two endp

mmx_are_bytes_eq proc \
    $dst : PTR QWORD, \
    $src : PTR QWORD, \
    $len : DWORD

                @prologue
                
                pcmpeqb mm0, mm1
                movd eax, mm0
                psrlq mm0, 32
                movd ebx, mm0
                
                and eax, ebx
                cmp eax, ONES
                jnz null
                
                loop @B
                
                mov eax, 1
                jmp exit
                
    null:       xor eax, eax
    
    exit:       ret
    
mmx_are_bytes_eq endp

mmx_are_bytes_gt proc \
    $dst : PTR QWORD, \
    $src : PTR QWORD, \
    $len : DWORD

                @prologue
                
                pcmpgtb mm0, mm1
                movd eax, mm0
                psrlq mm0, 32
                movd ebx, mm0
                
                and eax, ebx
                cmp eax, ONES
                jnz null
                
                loop @B
                
                mov eax, 1
                jmp exit
                
    null:       xor eax, eax
    
    exit:       ret
    
mmx_are_bytes_gt endp


end