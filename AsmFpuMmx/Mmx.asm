.model flat, C

.stack

.data

.code

@bfunc macro \
    @name, \
    @prefix, \
    @op, \
    @len
    
    public @prefix&_&@name

    @prefix&_&@name proc \
        $dst : PTR QWORD, \
        $src : PTR QWORD, \
        $len : DWORD
        
                    mov ecx, $len
                    bsf eax, ecx
                    jz @name&null
                    
                    cmp eax, @len
                    jb @name&null
                    
                    shr ecx, @len
        
                    mov esi, $src
                    mov edi, $dst
                    
                    test esi, esi
                    jz @name&null
                    test edi, edi
                    jz @name&null
                    
                    mov eax, esi
                    
        @@:         movq mm0, [edi]
                    movq mm1, [esi]
    
                    @op mm0, mm1
    
                    movq [edi], mm0
                    
                    loop @B
                    
                    emms
                    
                    jmp @name&exit
                    
        @name&null: xor eax, eax
        
        @name&exit: ret
        
    @prefix&_&@name endp

endm

@mmx_bin_funcs macro \
    @op

    &@bfunc @op&_bytes, mmx, p&@op&b, 3
    &@bfunc @op&_bytes_signed_saturation, mmx, p&@op&sb, 3
    &@bfunc @op&_bytes_unsigned_saturation, mmx, p&@op&usb, 3

@mmx_bin_funcs endm

end