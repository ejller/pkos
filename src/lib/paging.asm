global pg_start

pg_start:
 MOV                  EAX, 0

    DIR                  EQU 0x00100000
    MOV                  EDX, DIR

    NUM_ALL_ENTRIES      EQU 1024 + 1024 * 1024
    MOV                  ECX, NUM_ALL_ENTRIES

    REP                  STOSD

    ; Map kernel
    ; Add an entry for kernel to page directory

    SIZE_TABLE           EQU 0x1000
    TABLE_KERNEL         EQU DIR + SIZE_TABLE
    SIZE_ENTRY           EQU 4
    DIR_ENTRY_KERNEL     EQU DIR + 0x300 * SIZE_ENTRY
    PAGE_EXISTS          EQU 1
    MOV                  DWORD[DWORD DIR_ENTRY_KERNEL], TABLE_KERNEL | PAGE_EXISTS

    ; Map kernel to page table.
    ADDRESS_KERNEL      EQU 0x00501000
    MOV                 EAX, ADDRESS_KERNEL

    SIZE_KERNEL         EQU 512 * 1024
    MOV                 ECX, SIZE_KERNEL
    MOV                 EDI, TABLE_KERNEL
    CALL                map_entries

    ; Add a page table entry for stack.
    ADDRESS_STACK       EQU 0x00582000
    TABLE_ENTRY_STACK   EQU TABLE_KERNEL + SIZE_KERNEL / 1024
    MOV                 DWORD[DWORD TABLE_ENTRY_STACK], ADDRESS_STACK | PAGE_EXISTS

    ; Add an entry for below 1MB to page directory.
    TABLE_BELOW_1MB     EQU DIR + SIZE_TABLE * 2
    MOV                 DWORD[DWORD DIR], TABLE_BELOW_1MB | PAGE_EXISTS

    ; Map below 1MB to page table.
    MOV                 EAX, 0
    MOV                 ECX, 1024 * 1024
    MOV                 EDI, TABLE_BELOW_1MB
    CALL                map_entries

    MOV                 EAX, DIR
    MOV                 CR3, EAX

    MOV                 EAX, CR0
    OR                  EAX, 0x80000000
    MOV                 CR0, EAX

    JMP                 end_page_settings

    ; Function

map_entries:
    ; EAX: Starting address of physical memories.
    ; ECX: Number of bytes to map.
    ; EDI: Starting address of entries of page table.
    PUSH                EBP
    MOV                 EBP, ESP

    ; Number of needed entries = ECX / 4096
    ;                          = ECX >> 12
    SHR                 ECX, 12

loop_map_entries:
    CMP                 ECX, 0
    JBE                 end_map_entries

    OR                  EAX, PAGE_EXISTS
    MOV                 [EDI], EAX
    ADD                 EAX, 0x1000
    ADD                 EDI, SIZE_ENTRY
    DEC                 ECX

    JMP                 loop_map_entries

end_map_entries:
    MOV                 ESP, EBP
    POP                 EBP
    RET

end_page_settings: