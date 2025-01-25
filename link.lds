SECTIONS
{
  . = 0x400000;

  tiny : { *(.text) *(.data) }

  /DISCARD/ : { *(*) }
}

ENTRY(_start)
OUTPUT_FORMAT("elf64-x86-64")