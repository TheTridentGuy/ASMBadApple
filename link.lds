SECTIONS
{
  . = 0x8048000 + SIZEOF_HEADERS;

  tiny : { *(.text) *(.data) }

  /DISCARD/ : { *(*) }
}

ENTRY(_start)
OUTPUT_FORMAT("elf64-x86-64")