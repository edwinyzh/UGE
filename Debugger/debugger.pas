{+-----------------------------------------------------------------------------+
 | Author:      Christian Hackbart
 | Description: basic Debugger functions 
 | Copyright (c) 2000 Christian Hackbart
 | last Changes: 31.10.2000
 |
 | http://www.tu-ilmenau.de/~hackbart
 +----------------------------------------------------------------------------+
 | This Unit is based on YaSE written by myself a few years ago.
 | It must be changed !! Because this debugger is based on a "real" Z80
 | ED-Instructions can be removed, also a few other instructions.
 +----------------------------------------------------------------------------+}

unit debugger;

{$MODE Delphi}

interface
type format=record {Fr opcodes}
             op:string[18];
             leng:shortint
            end;

const major:array[0..255] of format=(
(op:'nop';leng:0),
(op:'ld   bc,####';leng:2),
(op:'ld   bc,a';leng:0),
(op:'inc  bc';leng:0),
(op:'inc  b';leng:0),
(op:'dec  b';leng:0),
(op:'ld   b,##';leng:1),
(op:'rlc  a';leng:0),
(op:'ex   af,af''';leng:0),
(op:'add  hl,bc';leng:0),
(op:'ld   a,(bc)';leng:0),
(op:'dec  bc';leng:0),
(op:'inc  c';leng:0),
(op:'dec  c';leng:0),
(op:'ld   c,##';leng:1),
(op:'rrc  a';leng:0),
(op:'djnz ####';leng:-1),
(op:'ld   de,####';leng:2),
(op:'ld   (de),a';leng:0),
(op:'inc  de';leng:0),
(op:'inc  d';leng:0),
(op:'dec  d';leng:0),
(op:'ld   d,##';leng:1),
(op:'rla';leng:0),
(op:'jr   ####';leng:-1),
(op:'add  hl,de';leng:0),
(op:'ld   a,(de)';leng:0),
(op:'dec  de';leng:0),
(op:'inc  e';leng:0),
(op:'dec  e';leng:0),
(op:'ld   e,##';leng:1),
(op:'rra';leng:0),
(op:'jr   nz,####';leng:-1),
(op:'ld   hl,####';leng:2),
(op:'ld   (####),hl';leng:2),
(op:'inc  hl';leng:0),
(op:'inc  h';leng:0),
(op:'dec  h';leng:0),
(op:'ld   h,##';leng:1),
(op:'daa';leng:0),
(op:'jr   z,####';leng:-1),
(op:'add  hl,hl';leng:0),
(op:'ld   hl,(####)';leng:2),
(op:'dec  hl';leng:0),
(op:'inc  l';leng:0),
(op:'dec  l';leng:0),
(op:'ld   l,##';leng:1),
(op:'cpl';leng:0),
(op:'jr   nc,####';leng:-1),
(op:'ld   sp,####';leng:2),
(op:'ld   (####),a';leng:2),
(op:'inc  sp';leng:0),
(op:'inc  (hl)';leng:0),
(op:'dec  (hl)';leng:0),
(op:'ld   (hl),##';leng:1),
(op:'scf';leng:0),
(op:'jr   c,####';leng:-1),
(op:'add  hl,sp';leng:0),
(op:'ld   a,(####)';leng:2),
(op:'dec  sp';leng:0),
(op:'inc  a';leng:0),
(op:'dec  a';leng:0),
(op:'ld   a,##';leng:1),
(op:'ccf';leng:0),
(op:'ld   b,b';leng:0),
(op:'ld   b,c';leng:0),
(op:'ld   b,d';leng:0),
(op:'ld   b,e';leng:0),
(op:'ld   b,h';leng:0),
(op:'ld   b,l';leng:0),
(op:'ld   b,(hl)';leng:0),
(op:'ld   b,a';leng:0),
(op:'ld   c,b';leng:0),
(op:'ld   c,c';leng:0),
(op:'ld   c,d';leng:0),
(op:'ld   c,e';leng:0),
(op:'ld   c,h';leng:0),
(op:'ld   c,l';leng:0),
(op:'ld   c,(hl)';leng:0),
(op:'ld   c,a';leng:0),
(op:'ld   d,b';leng:0),
(op:'ld   d,c';leng:0),
(op:'ld   d,d';leng:0),
(op:'ld   d,e';leng:0),
(op:'ld   d,h';leng:0),
(op:'ld   d,l';leng:0),
(op:'ld   d,(hl)';leng:0),
(op:'ld   d,a';leng:0),
(op:'ld   e,b';leng:0),
(op:'ld   e,c';leng:0),
(op:'ld   e,d';leng:0),
(op:'ld   e,e';leng:0),
(op:'ld   e,h';leng:0),
(op:'ld   e,l';leng:0),
(op:'ld   e,(hl)';leng:0),
(op:'ld   e,a';leng:0),
(op:'ld   h,b';leng:0),
(op:'ld   h,c';leng:0),
(op:'ld   h,d';leng:0),
(op:'ld   h,e';leng:0),
(op:'ld   h,h';leng:0),
(op:'ld   h,l';leng:0),
(op:'ld   h,(hl)';leng:0),
(op:'ld   h,a';leng:0),
(op:'ld   l,b';leng:0),
(op:'ld   l,c';leng:0),
(op:'ld   l,d';leng:0),
(op:'ld   l,e';leng:0),
(op:'ld   l,h';leng:0),
(op:'ld   l,l';leng:0),
(op:'ld   l,(hl)';leng:0),
(op:'ld   l,a';leng:0),
(op:'ld   (hl),b';leng:0),
(op:'ld   (hl),c';leng:0),
(op:'ld   (hl),d';leng:0),
(op:'ld   (hl),e';leng:0),
(op:'ld   (hl),h';leng:0),
(op:'ld   (hl),l';leng:0),
(op:'halt';leng:0),
(op:'ld   (hl),a';leng:0),
(op:'ld   a,b';leng:0),
(op:'ld   a,c';leng:0),
(op:'ld   a,d';leng:0),
(op:'ld   a,e';leng:0),
(op:'ld   a,h';leng:0),
(op:'ld   a,l';leng:0),
(op:'ld   a,(hl)';leng:0),
(op:'ld   a,a';leng:0),
(op:'add  a,b';leng:0),
(op:'add  a,c';leng:0),
(op:'add  a,d';leng:0),
(op:'add  a,e';leng:0),
(op:'add  a,h';leng:0),
(op:'add  a,l';leng:0),
(op:'add  a,(hl)';leng:0),
(op:'add  a,a';leng:0),
(op:'adc  a,b';leng:0),
(op:'adc  a,c';leng:0),
(op:'adc  a,d';leng:0),
(op:'adc  a,e';leng:0),
(op:'adc  a,h';leng:0),
(op:'adc  a,l';leng:0),
(op:'adc  a,(hl)';leng:0),
(op:'adc  a,a';leng:0),
(op:'sub  b';leng:0),
(op:'sub  c';leng:0),
(op:'sub  d';leng:0),
(op:'sub  e';leng:0),
(op:'sub  h';leng:0),
(op:'sub  l';leng:0),
(op:'sub  (hl)';leng:0),
(op:'sub  a';leng:0),
(op:'sbc  a,b';leng:0),
(op:'sbc  a,c';leng:0),
(op:'sbc  a,d';leng:0),
(op:'sbc  a,e';leng:0),
(op:'sbc  a,h';leng:0),
(op:'sbc  a,l';leng:0),
(op:'sbc  a,(hl)';leng:0),
(op:'sbc  a,a';leng:0),
(op:'and  b';leng:0),
(op:'and  c';leng:0),
(op:'and  d';leng:0),
(op:'and  e';leng:0),
(op:'and  h';leng:0),
(op:'and  l';leng:0),
(op:'and  (hl)';leng:0),
(op:'and  a';leng:0),
(op:'xor  b';leng:0),
(op:'xor  c';leng:0),
(op:'xor  d';leng:0),
(op:'xor  e';leng:0),
(op:'xor  h';leng:0),
(op:'xor  l';leng:0),
(op:'xor  (hl)';leng:0),
(op:'xor  a';leng:0),
(op:'or   b';leng:0),
(op:'or   c';leng:0),
(op:'or   d';leng:0),
(op:'or   e';leng:0),
(op:'or   h';leng:0),
(op:'or   l';leng:0),
(op:'or   (hl)';leng:0),
(op:'or   a';leng:0),
(op:'cp   b';leng:0),
(op:'cp   c';leng:0),
(op:'cp   d';leng:0),
(op:'cp   e';leng:0),
(op:'cp   h';leng:0),
(op:'cp   l';leng:0),
(op:'cp   (hl)';leng:0),
(op:'cp   a';leng:0),
(op:'ret  nz';leng:0),
(op:'pop  bc';leng:0),
(op:'jp   nz,####';leng:2),
(op:'jp   ####';leng:2),
(op:'call nz,####';leng:2),
(op:'push bc';leng:0),
(op:'add  a,##';leng:1),
(op:'rst  0';leng:0),
(op:'ret  z';leng:0),
(op:'ret';leng:0),
(op:'jp   z,####';leng:2),
(op:'';leng:0),
(op:'call z,####';leng:2),
(op:'call ####';leng:2),
(op:'adc  a,##';leng:1),
(op:'rst  8';leng:0),
(op:'ret  nc';leng:0),
(op:'pop  de';leng:0),
(op:'jp   nc,####';leng:2),
(op:'out  (##),a';leng:1),
(op:'call nc,####';leng:2),
(op:'push de';leng:0),
(op:'sub  ##';leng:1),
(op:'rst  10h';leng:0),
(op:'ret  c';leng:0),
(op:'exx';leng:0),
(op:'jp   c,####';leng:2),
(op:'in   a,(##)';leng:1),
(op:'call c,####';leng:2),
(op:'';leng:1),
(op:'sbc  a,##';leng:1),
(op:'rst  18h';leng:0),
(op:'ret  po';leng:0),
(op:'pop  hl';leng:0),
(op:'jp   po,####';leng:2),
(op:'ex   (sp),hl';leng:0),
(op:'call po,####';leng:2),
(op:'push hl';leng:0),
(op:'and  ##';leng:1),
(op:'rst  20h';leng:0),
(op:'ret  pe';leng:0),
(op:'jp   (hl)';leng:0),
(op:'jp   pe,####';leng:2),
(op:'ex   de,hl';leng:0),
(op:'call pe,####';leng:2),
(op:'';leng:2),
(op:'xor  ##';leng:1),
(op:'rst  28h';leng:0),
(op:'ret  p';leng:0),
(op:'pop  af';leng:0),
(op:'jp   p,####';leng:2),
(op:'di';leng:0),
(op:'call p,####';leng:2),
(op:'push af';leng:0),
(op:'or   ##';leng:1),
(op:'rst  30h';leng:0),
(op:'ret  m';leng:0),
(op:'ld   sp,hl';leng:0),
(op:'jp   m,####';leng:2),
(op:'ei';leng:0),
(op:'call m,####';leng:2),
(op:'';leng:1),
(op:'cp   ##';leng:1),
(op:'rst  38h';leng:0));

const minor:array[0..3,0..255] of format=((
(op:'rlc  b';leng:0),
(op:'rlc  c';leng:0),
(op:'rlc  d';leng:0),
(op:'rlc  e';leng:0),
(op:'rlc  h';leng:0),
(op:'rlc  l';leng:0),
(op:'rlc  (hl)';leng:0),
(op:'rlc  a';leng:0),
(op:'rrc  b';leng:0),
(op:'rrc  c';leng:0),
(op:'rrc  d';leng:0),
(op:'rrc  e';leng:0),
(op:'rrc  h';leng:0),
(op:'rrc  l';leng:0),
(op:'rrc  (hl)';leng:0),
(op:'rrc  a';leng:0),
(op:'rl   b';leng:0),
(op:'rl   c';leng:0),
(op:'rl   d';leng:0),
(op:'rl   e';leng:0),
(op:'rl   h';leng:0),
(op:'rl   l';leng:0),
(op:'rl   (hl)';leng:0),
(op:'rl   a';leng:0),
(op:'rr   b';leng:0),
(op:'rr   c';leng:0),
(op:'rr   d';leng:0),
(op:'rr   e';leng:0),
(op:'rr   h';leng:0),
(op:'rr   l';leng:0),
(op:'rr   (hl)';leng:0),
(op:'rr   a';leng:0),
(op:'sla  b';leng:0),
(op:'sla  c';leng:0),
(op:'sla  d';leng:0),
(op:'sla  e';leng:0),
(op:'sla  h';leng:0),
(op:'sla  l';leng:0),
(op:'sla  (hl)';leng:0),
(op:'sla  a';leng:0),
(op:'sra  b';leng:0),
(op:'sra  c';leng:0),
(op:'sra  d';leng:0),
(op:'sra  e';leng:0),
(op:'sra  h';leng:0),
(op:'sra  l';leng:0),
(op:'sra  (hl)';leng:0),
(op:'sra  a';leng:0),
(op:'slai b';leng:0),
(op:'slai c';leng:0),
(op:'slai d';leng:0),
(op:'slai e';leng:0),
(op:'slai h';leng:0),
(op:'slai l';leng:0),
(op:'slai (hl)';leng:0),
(op:'slai a';leng:0),
(op:'srl  b';leng:0),
(op:'srl  c';leng:0),
(op:'srl  d';leng:0),
(op:'srl  e';leng:0),
(op:'srl  h';leng:0),
(op:'srl  l';leng:0),
(op:'srl  (hl)';leng:0),
(op:'srl  a';leng:0),
(op:'bit  0,b';leng:0),
(op:'bit  0,c';leng:0),
(op:'bit  0,d';leng:0),
(op:'bit  0,e';leng:0),
(op:'bit  0,h';leng:0),
(op:'bit  0,l';leng:0),
(op:'bit  0,(hl)';leng:0),
(op:'bit  0,a';leng:0),
(op:'bit  1,b';leng:0),
(op:'bit  1,c';leng:0),
(op:'bit  1,d';leng:0),
(op:'bit  1,e';leng:0),
(op:'bit  1,h';leng:0),
(op:'bit  1,l';leng:0),
(op:'bit  1,(hl)';leng:0),
(op:'bit  1,a';leng:0),
(op:'bit  2,b';leng:0),
(op:'bit  2,c';leng:0),
(op:'bit  2,d';leng:0),
(op:'bit  2,e';leng:0),
(op:'bit  2,h';leng:0),
(op:'bit  2,l';leng:0),
(op:'bit  2,(hl)';leng:0),
(op:'bit  2,a';leng:0),
(op:'bit  3,b';leng:0),
(op:'bit  3,c';leng:0),
(op:'bit  3,d';leng:0),
(op:'bit  3,e';leng:0),
(op:'bit  3,h';leng:0),
(op:'bit  3,l';leng:0),
(op:'bit  3,(hl)';leng:0),
(op:'bit  3,a';leng:0),
(op:'bit  4,b';leng:0),
(op:'bit  4,c';leng:0),
(op:'bit  4,d';leng:0),
(op:'bit  4,e';leng:0),
(op:'bit  4,h';leng:0),
(op:'bit  4,l';leng:0),
(op:'bit  4,(hl)';leng:0),
(op:'bit  4,a';leng:0),
(op:'bit  5,b';leng:0),
(op:'bit  5,c';leng:0),
(op:'bit  5,d';leng:0),
(op:'bit  5,e';leng:0),
(op:'bit  5,h';leng:0),
(op:'bit  5,l';leng:0),
(op:'bit  5,(hl)';leng:0),
(op:'bit  5,a';leng:0),
(op:'bit  6,b';leng:0),
(op:'bit  6,c';leng:0),
(op:'bit  6,d';leng:0),
(op:'bit  6,e';leng:0),
(op:'bit  6,h';leng:0),
(op:'bit  6,l';leng:0),
(op:'bit  6,(hl)';leng:0),
(op:'bit  6,a';leng:0),
(op:'bit  7,b';leng:0),
(op:'bit  7,c';leng:0),
(op:'bit  7,d';leng:0),
(op:'bit  7,e';leng:0),
(op:'bit  7,h';leng:0),
(op:'bit  7,l';leng:0),
(op:'bit  7,(hl)';leng:0),
(op:'bit  7,a';leng:0),
(op:'res  0,b';leng:0),
(op:'res  0,c';leng:0),
(op:'res  0,d';leng:0),
(op:'res  0,e';leng:0),
(op:'res  0,h';leng:0),
(op:'res  0,l';leng:0),
(op:'res  0,(hl)';leng:0),
(op:'res  0,a';leng:0),
(op:'res  1,b';leng:0),
(op:'res  1,c';leng:0),
(op:'res  1,d';leng:0),
(op:'res  1,e';leng:0),
(op:'res  1,h';leng:0),
(op:'res  1,l';leng:0),
(op:'res  1,(hl)';leng:0),
(op:'res  1,a';leng:0),
(op:'res  2,b';leng:0),
(op:'res  2,c';leng:0),
(op:'res  2,d';leng:0),
(op:'res  2,e';leng:0),
(op:'res  2,h';leng:0),
(op:'res  2,l';leng:0),
(op:'res  2,(hl)';leng:0),
(op:'res  2,a';leng:0),
(op:'res  3,b';leng:0),
(op:'res  3,c';leng:0),
(op:'res  3,d';leng:0),
(op:'res  3,e';leng:0),
(op:'res  3,h';leng:0),
(op:'res  3,l';leng:0),
(op:'res  3,(hl)';leng:0),
(op:'res  3,a';leng:0),
(op:'res  4,b';leng:0),
(op:'res  4,c';leng:0),
(op:'res  4,d';leng:0),
(op:'res  4,e';leng:0),
(op:'res  4,h';leng:0),
(op:'res  4,l';leng:0),
(op:'res  4,(hl)';leng:0),
(op:'res  4,a';leng:0),
(op:'res  5,b';leng:0),
(op:'res  5,c';leng:0),
(op:'res  5,d';leng:0),
(op:'res  5,e';leng:0),
(op:'res  5,h';leng:0),
(op:'res  5,l';leng:0),
(op:'res  5,(hl)';leng:0),
(op:'res  5,a';leng:0),
(op:'res  6,b';leng:0),
(op:'res  6,c';leng:0),
(op:'res  6,d';leng:0),
(op:'res  6,e';leng:0),
(op:'res  6,h';leng:0),
(op:'res  6,l';leng:0),
(op:'res  6,(hl)';leng:0),
(op:'res  6,a';leng:0),
(op:'res  7,b';leng:0),
(op:'res  7,c';leng:0),
(op:'res  7,d';leng:0),
(op:'res  7,e';leng:0),
(op:'res  7,h';leng:0),
(op:'res  7,l';leng:0),
(op:'res  7,(hl)';leng:0),
(op:'res  7,a';leng:0),
(op:'set  0,b';leng:0),
(op:'set  0,c';leng:0),
(op:'set  0,d';leng:0),
(op:'set  0,e';leng:0),
(op:'set  0,h';leng:0),
(op:'set  0,l';leng:0),
(op:'set  0,(hl)';leng:0),
(op:'set  0,a';leng:0),
(op:'set  1,b';leng:0),
(op:'set  1,c';leng:0),
(op:'set  1,d';leng:0),
(op:'set  1,e';leng:0),
(op:'set  1,h';leng:0),
(op:'set  1,l';leng:0),
(op:'set  1,(hl)';leng:0),
(op:'set  1,a';leng:0),
(op:'set  2,b';leng:0),
(op:'set  2,c';leng:0),
(op:'set  2,d';leng:0),
(op:'set  2,e';leng:0),
(op:'set  2,h';leng:0),
(op:'set  2,l';leng:0),
(op:'set  2,(hl)';leng:0),
(op:'set  2,a';leng:0),
(op:'set  3,b';leng:0),
(op:'set  3,c';leng:0),
(op:'set  3,d';leng:0),
(op:'set  3,e';leng:0),
(op:'set  3,h';leng:0),
(op:'set  3,l';leng:0),
(op:'set  3,(hl)';leng:0),
(op:'set  3,a';leng:0),
(op:'set  4,b';leng:0),
(op:'set  4,c';leng:0),
(op:'set  4,d';leng:0),
(op:'set  4,e';leng:0),
(op:'set  4,h';leng:0),
(op:'set  4,l';leng:0),
(op:'set  4,(hl)';leng:0),
(op:'set  4,a';leng:0),
(op:'set  5,b';leng:0),
(op:'set  5,c';leng:0),
(op:'set  5,d';leng:0),
(op:'set  5,e';leng:0),
(op:'set  5,h';leng:0),
(op:'set  5,l';leng:0),
(op:'set  5,(hl)';leng:0),
(op:'set  5,a';leng:0),
(op:'set  6,b';leng:0),
(op:'set  6,c';leng:0),
(op:'set  6,d';leng:0),
(op:'set  6,e';leng:0),
(op:'set  6,h';leng:0),
(op:'set  6,l';leng:0),
(op:'set  6,(hl)';leng:0),
(op:'set  6,a';leng:0),
(op:'set  7,b';leng:0),
(op:'set  7,c';leng:0),
(op:'set  7,d';leng:0),
(op:'set  7,e';leng:0),
(op:'set  7,h';leng:0),
(op:'set  7,l';leng:0),
(op:'set  7,(hl)';leng:0),
(op:'set  7,a';leng:0)),(
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'addix,bc';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'add  ix,de';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'ld   ix,####';leng:2),
(op:'ld   (####),ix';leng:2),
(op:'inc  ix';leng:0),
(op:'inc  ixh';leng:0),
(op:'dec  ixh';leng:0),
(op:'ld   ixh,##';leng:1),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'add  ix,ix';leng:0),
(op:'ld   ix,(####)';leng:2),
(op:'dec  ix';leng:0),
(op:'inc  ixl';leng:0),
(op:'dec  ixl';leng:0),
(op:'ld   ixl,##';leng:1),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'inc  (ix+##)';leng:1),
(op:'dec  (ix+##)';leng:1),
(op:'ld   (ix+##),##';leng:2),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'add  ix,sp';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'ld   b,ixh';leng:0),
(op:'ld   b,ixl';leng:0),
(op:'ld   b,(ix+##)';leng:1),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'ld   c,ixh';leng:0),
(op:'ld   c,ixl';leng:0),
(op:'ld   c,(ix+##)';leng:1),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'ld   d,ixh';leng:0),
(op:'ld   d,ixl';leng:0),
(op:'ld   d,(ix+##)';leng:1),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'ld   e,ixh';leng:0),
(op:'ld   e,ixl';leng:0),
(op:'ld   e,(ix+##)';leng:1),
(op:'undefined';leng:0),
(op:'ld   ixh,b';leng:0),
(op:'ld   ixh,c';leng:0),
(op:'ld   ixh,d';leng:0),
(op:'ld   ixh,e';leng:0),
(op:'ld   ixh,ixh';leng:0),
(op:'ld   ixh,ixl';leng:0),
(op:'ld   h,(ix+##)';leng:1),
(op:'ld   ixh,a';leng:0),
(op:'ld   ixl,b';leng:0),
(op:'ld   ixl,c';leng:0),
(op:'ld   ixl,d';leng:0),
(op:'ld   ixl,e';leng:0),
(op:'ld   ixl,ixh';leng:0),
(op:'ld   ixl,ixh';leng:0),
(op:'ld   l,(ix+##)';leng:1),
(op:'ld   ixl,a';leng:0),
(op:'ld   (ix+##),b';leng:1),
(op:'ld   (ix+##),c';leng:1),
(op:'ld   (ix+##),d';leng:1),
(op:'ld   (ix+##),e';leng:1),
(op:'ld   (ix+##),h';leng:1),
(op:'ld   (ix+##),l';leng:1),
(op:'undefined';leng:0),
(op:'ld   (ix+##),a';leng:1),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'ld   a,ixh';leng:0),
(op:'ld   a,ixl';leng:0),
(op:'ld   a,(ix+##)';leng:1),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'add  a,ixh';leng:0),
(op:'add  a,ixl';leng:0),
(op:'add  a,(ix+##)';leng:1),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'adc  a,ixh';leng:0),
(op:'adc  a,ixl';leng:0),
(op:'adc  a,(ix+##)';leng:1),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'sub  a,ixh';leng:0),
(op:'sub  a,ixl';leng:0),
(op:'sub  (ix+##)';leng:1),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'sbc  a,ixh';leng:0),
(op:'sbc  a,ixl';leng:0),
(op:'sbc  a,(ix+##)';leng:1),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'and  a,ixh';leng:0),
(op:'and  a,ixl';leng:0),
(op:'and  a,(ix+##)';leng:1),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'xor  a,ixh';leng:0),
(op:'xor  a,ixl';leng:0),
(op:'xor  a,(ix+##)';leng:1),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'or   a,ixh';leng:0),
(op:'or   a,ixl';leng:0),
(op:'or   a,(ix+##)';leng:1),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'cp   a,ixh';leng:0),
(op:'cp   a,ixl';leng:0),
(op:'cp   a,(ix+##)';leng:1),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'';leng:3),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'pop  ix';leng:0),
(op:'undefined';leng:0),
(op:'ex   (sp),ix';leng:0),
(op:'undefined';leng:0),
(op:'push ix';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'jp   (ix)';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'ld   sp,ix';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0)),
(
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'in   b,(c)';leng:0),
(op:'out  (c),b';leng:0),
(op:'sbc  hl,bc';leng:0),
(op:'ld   (####),bc';leng:2),
(op:'neg';leng:0),
(op:'retn';leng:0),
(op:'im   ';leng:0),
(op:'ld   i,a';leng:0),
(op:'in   c,(c)';leng:0),
(op:'out  (c),c';leng:0),
(op:'adc  hl,bc';leng:0),
(op:'ld   bc,(####)';leng:2),
(op:'neg';leng:0),
(op:'reti';leng:0),
(op:'im   0';leng:0),
(op:'ld   r,a';leng:0),
(op:'in   d,(c)';leng:0),
(op:'out  (c),d';leng:0),
(op:'sbc  hl,de';leng:0),
(op:'ld   (####),de';leng:2),
(op:'neg';leng:0),
(op:'retn';leng:0),
(op:'im   1';leng:0),
(op:'ld   a,i';leng:0),
(op:'in   e,(c)';leng:0),
(op:'out  (c),e';leng:0),
(op:'adc  hl,de';leng:0),
(op:'ld   de,(####)';leng:2),
(op:'neg';leng:0),
(op:'retn';leng:0),
(op:'im   2';leng:0),
(op:'ld   a,r';leng:0),
(op:'in   h,(c)';leng:0),
(op:'out  (c),h';leng:0),
(op:'sbc  hl,hl';leng:0),
(op:'ld   (####),hl';leng:0),
(op:'neg';leng:0),
(op:'retn';leng:0),
(op:'im   0';leng:0),
(op:'rrd';leng:0),
(op:'in   l,(c)';leng:0),
(op:'out  (c),l';leng:0),
(op:'adc  hl,hl';leng:0),
(op:'ld   hl,(####)';leng:0),
(op:'neg';leng:0),
(op:'retn';leng:0),
(op:'im   0';leng:0),
(op:'rld';leng:0),
(op:'in   f,(c)';leng:0),
(op:'out  (c),0';leng:0),
(op:'sbc  hl,sp';leng:0),
(op:'ld   (####),sp';leng:2),
(op:'neg';leng:0),
(op:'retn';leng:0),
(op:'im   1';leng:0),
(op:'nop';leng:0),
(op:'in   a,(c)';leng:0),
(op:'out  (c),a';leng:0),
(op:'adc  hl,sp';leng:0),
(op:'ld   sp,(####)';leng:2),
(op:'neg';leng:0),
(op:'retn';leng:0),
(op:'im   2';leng:0),
(op:'nop';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'ldi';leng:0),
(op:'cpi';leng:0),
(op:'ini';leng:0),
(op:'outi';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'ldd';leng:0),
(op:'cpd';leng:0),
(op:'ind';leng:0),
(op:'outd';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'ldir';leng:0),
(op:'cpir';leng:0),
(op:'inir';leng:0),
(op:'otir';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'lddr';leng:0),
(op:'cpdr';leng:0),
(op:'indr';leng:0),
(op:'otdr';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0),
(op:'undefined';leng:0)),
(
(op:'rlc  (ix+##),b';leng:-2),
(op:'rlc  (ix+##),c';leng:-2),
(op:'rlc  (ix+##),d';leng:-2),
(op:'rlc  (ix+##),e';leng:-2),
(op:'rlc  (ix+##),h';leng:-2),
(op:'rlc  (ix+##),l';leng:-2),
(op:'rlc  (ix+##)';leng:-2),
(op:'rlc  (ix+##),a';leng:-2),
(op:'rrc  (ix+##),b';leng:-2),
(op:'rrc  (ix+##),c';leng:-2),
(op:'rrc  (ix+##),d';leng:-2),
(op:'rrc  (ix+##),e';leng:-2),
(op:'rrc  (ix+##),h';leng:-2),
(op:'rrc  (ix+##),l';leng:-2),
(op:'rrc  (ix+##)';leng:-2),
(op:'rrc  (ix+##),a';leng:-2),
(op:'rl   (ix+##),b';leng:-2),
(op:'rl   (ix+##),c';leng:-2),
(op:'rl   (ix+##),d';leng:-2),
(op:'rl   (ix+##),e';leng:-2),
(op:'rl   (ix+##),h';leng:-2),
(op:'rl   (ix+##),l';leng:-2),
(op:'rl   (ix+##)';leng:-2),
(op:'rl   (ix+##),a';leng:-2),
(op:'rr   (ix+##),b';leng:-2),
(op:'rr   (ix+##),c';leng:-2),
(op:'rr   (ix+##),d';leng:-2),
(op:'rr   (ix+##),e';leng:-2),
(op:'rr   (ix+##),h';leng:-2),
(op:'rr   (ix+##),l';leng:-2),
(op:'rr   (ix+##)';leng:-2),
(op:'rr   (ix+##),a';leng:-2),
(op:'sla  (ix+##),b';leng:-2),
(op:'sla  (ix+##),c';leng:-2),
(op:'sla  (ix+##),d';leng:-2),
(op:'sla  (ix+##),e';leng:-2),
(op:'sla  (ix+##),h';leng:-2),
(op:'sla  (ix+##),l';leng:-2),
(op:'sla  (ix+##)';leng:-2),
(op:'sla  (ix+##),a';leng:-2),
(op:'sra  (ix+##),b';leng:-2),
(op:'sra  (ix+##),c';leng:-2),
(op:'sra  (ix+##),d';leng:-2),
(op:'sra  (ix+##),e';leng:-2),
(op:'sra  (ix+##),h';leng:-2),
(op:'sra  (ix+##),l';leng:-2),
(op:'sra  (ix+##)';leng:-2),
(op:'sra  (ix+##),a';leng:-2),
(op:'slai (ix+##),b';leng:-2),
(op:'slai (ix+##),c';leng:-2),
(op:'slai (ix+##),d';leng:-2),
(op:'slai (ix+##),e';leng:-2),
(op:'slai (ix+##),h';leng:-2),
(op:'slai (ix+##),l';leng:-2),
(op:'slai (ix+##)';leng:-2),
(op:'slai (ix+##),a';leng:-2),
(op:'srl  (ix+##),b';leng:-2),
(op:'srl  (ix+##),c';leng:-2),
(op:'srl  (ix+##),d';leng:-2),
(op:'srl  (ix+##),e';leng:-2),
(op:'srl  (ix+##),h';leng:-2),
(op:'srl  (ix+##),l';leng:-2),
(op:'srl  (ix+##)';leng:-2),
(op:'srl  (ix+##),a';leng:-2),
(op:'bit  0,(ix+##)';leng:-2),
(op:'bit  0,(ix+##)';leng:-2),
(op:'bit  0,(ix+##)';leng:-2),
(op:'bit  0,(ix+##)';leng:-2),
(op:'bit  0,(ix+##)';leng:-2),
(op:'bit  0,(ix+##)';leng:-2),
(op:'bit  0,(ix+##)';leng:-2),
(op:'bit  0,(ix+##)';leng:-2),
(op:'bit  1,(ix+##)';leng:-2),
(op:'bit  1,(ix+##)';leng:-2),
(op:'bit  1,(ix+##)';leng:-2),
(op:'bit  1,(ix+##)';leng:-2),
(op:'bit  1,(ix+##)';leng:-2),
(op:'bit  1,(ix+##)';leng:-2),
(op:'bit  1,(ix+##)';leng:-2),
(op:'bit  1,(ix+##)';leng:-2),
(op:'bit  2,(ix+##)';leng:-2),
(op:'bit  2,(ix+##)';leng:-2),
(op:'bit  2,(ix+##)';leng:-2),
(op:'bit  2,(ix+##)';leng:-2),
(op:'bit  2,(ix+##)';leng:-2),
(op:'bit  2,(ix+##)';leng:-2),
(op:'bit  2,(ix+##)';leng:-2),
(op:'bit  2,(ix+##)';leng:-2),
(op:'bit  3,(ix+##)';leng:-2),
(op:'bit  3,(ix+##)';leng:-2),
(op:'bit  3,(ix+##)';leng:-2),
(op:'bit  3,(ix+##)';leng:-2),
(op:'bit  3,(ix+##)';leng:-2),
(op:'bit  3,(ix+##)';leng:-2),
(op:'bit  3,(ix+##)';leng:-2),
(op:'bit  3,(ix+##)';leng:-2),
(op:'bit  4,(ix+##)';leng:-2),
(op:'bit  4,(ix+##)';leng:-2),
(op:'bit  4,(ix+##)';leng:-2),
(op:'bit  4,(ix+##)';leng:-2),
(op:'bit  4,(ix+##)';leng:-2),
(op:'bit  4,(ix+##)';leng:-2),
(op:'bit  4,(ix+##)';leng:-2),
(op:'bit  4,(ix+##)';leng:-2),
(op:'bit  5,(ix+##)';leng:-2),
(op:'bit  5,(ix+##)';leng:-2),
(op:'bit  5,(ix+##)';leng:-2),
(op:'bit  5,(ix+##)';leng:-2),
(op:'bit  5,(ix+##)';leng:-2),
(op:'bit  5,(ix+##)';leng:-2),
(op:'bit  5,(ix+##)';leng:-2),
(op:'bit  5,(ix+##)';leng:-2),
(op:'bit  6,(ix+##)';leng:-2),
(op:'bit  6,(ix+##)';leng:-2),
(op:'bit  6,(ix+##)';leng:-2),
(op:'bit  6,(ix+##)';leng:-2),
(op:'bit  6,(ix+##)';leng:-2),
(op:'bit  6,(ix+##)';leng:-2),
(op:'bit  6,(ix+##)';leng:-2),
(op:'bit  6,(ix+##)';leng:-2),
(op:'bit  7,(ix+##)';leng:-2),
(op:'bit  7,(ix+##)';leng:-2),
(op:'bit  7,(ix+##)';leng:-2),
(op:'bit  7,(ix+##)';leng:-2),
(op:'bit  7,(ix+##)';leng:-2),
(op:'bit  7,(ix+##)';leng:-2),
(op:'bit  7,(ix+##)';leng:-2),
(op:'bit  7,(ix+##)';leng:-2),
(op:'res  0,(ix+##),b';leng:-2),
(op:'res  0,(ix+##),c';leng:-2),
(op:'res  0,(ix+##),d';leng:-2),
(op:'res  0,(ix+##),e';leng:-2),
(op:'res  0,(ix+##),h';leng:-2),
(op:'res  0,(ix+##),l';leng:-2),
(op:'res  0,(ix+##)';leng:-2),
(op:'res  0,(ix+##),a';leng:-2),
(op:'res  1,(ix+##),b';leng:-2),
(op:'res  1,(ix+##),c';leng:-2),
(op:'res  1,(ix+##),d';leng:-2),
(op:'res  1,(ix+##),e';leng:-2),
(op:'res  1,(ix+##),h';leng:-2),
(op:'res  1,(ix+##),l';leng:-2),
(op:'res  1,(ix+##)';leng:-2),
(op:'res  1,(ix+##),a';leng:-2),
(op:'res  2,(ix+##),b';leng:-2),
(op:'res  2,(ix+##),c';leng:-2),
(op:'res  2,(ix+##),d';leng:-2),
(op:'res  2,(ix+##),e';leng:-2),
(op:'res  2,(ix+##),h';leng:-2),
(op:'res  2,(ix+##),l';leng:-2),
(op:'res  2,(ix+##)';leng:-2),
(op:'res  2,(ix+##),a';leng:-2),
(op:'res  3,(ix+##),b';leng:-2),
(op:'res  3,(ix+##),c';leng:-2),
(op:'res  3,(ix+##),d';leng:-2),
(op:'res  3,(ix+##),e';leng:-2),
(op:'res  3,(ix+##),h';leng:-2),
(op:'res  3,(ix+##),l';leng:-2),
(op:'res  3,(ix+##)';leng:-2),
(op:'res  3,(ix+##),a';leng:-2),
(op:'res  4,(ix+##),b';leng:-2),
(op:'res  4,(ix+##),c';leng:-2),
(op:'res  4,(ix+##),d';leng:-2),
(op:'res  4,(ix+##),e';leng:-2),
(op:'res  4,(ix+##),h';leng:-2),
(op:'res  4,(ix+##),l';leng:-2),
(op:'res  4,(ix+##)';leng:-2),
(op:'res  4,(ix+##),a';leng:-2),
(op:'res  5,(ix+##),b';leng:-2),
(op:'res  5,(ix+##),c';leng:-2),
(op:'res  5,(ix+##),d';leng:-2),
(op:'res  5,(ix+##),e';leng:-2),
(op:'res  5,(ix+##),h';leng:-2),
(op:'res  5,(ix+##),l';leng:-2),
(op:'res  5,(ix+##)';leng:-2),
(op:'res  5,(ix+##),a';leng:-2),
(op:'res  6,(ix+##),b';leng:-2),
(op:'res  6,(ix+##),c';leng:-2),
(op:'res  6,(ix+##),d';leng:-2),
(op:'res  6,(ix+##),e';leng:-2),
(op:'res  6,(ix+##),h';leng:-2),
(op:'res  6,(ix+##),l';leng:-2),
(op:'res  6,(ix+##)';leng:-2),
(op:'res  6,(ix+##),a';leng:-2),
(op:'res  7,(ix+##),b';leng:-2),
(op:'res  7,(ix+##),c';leng:-2),
(op:'res  7,(ix+##),d';leng:-2),
(op:'res  7,(ix+##),e';leng:-2),
(op:'res  7,(ix+##),h';leng:-2),
(op:'res  7,(ix+##),l';leng:-2),
(op:'res  7,(ix+##)';leng:-2),
(op:'res  7,(ix+##),a';leng:-2),
(op:'set  0,(ix+##),b';leng:-2),
(op:'set  0,(ix+##),c';leng:-2),
(op:'set  0,(ix+##),d';leng:-2),
(op:'set  0,(ix+##),e';leng:-2),
(op:'set  0,(ix+##),h';leng:-2),
(op:'set  0,(ix+##),l';leng:-2),
(op:'set  0,(ix+##)';leng:-2),
(op:'set  0,(ix+##),a';leng:-2),
(op:'set  1,(ix+##),b';leng:-2),
(op:'set  1,(ix+##),c';leng:-2),
(op:'set  1,(ix+##),d';leng:-2),
(op:'set  1,(ix+##),e';leng:-2),
(op:'set  1,(ix+##),h';leng:-2),
(op:'set  1,(ix+##),l';leng:-2),
(op:'set  1,(ix+##)';leng:-2),
(op:'set  1,(ix+##),a';leng:-2),
(op:'set  2,(ix+##),b';leng:-2),
(op:'set  2,(ix+##),c';leng:-2),
(op:'set  2,(ix+##),d';leng:-2),
(op:'set  2,(ix+##),e';leng:-2),
(op:'set  2,(ix+##),h';leng:-2),
(op:'set  2,(ix+##),l';leng:-2),
(op:'set  2,(ix+##)';leng:-2),
(op:'set  2,(ix+##),a';leng:-2),
(op:'set  3,(ix+##),b';leng:-2),
(op:'set  3,(ix+##),c';leng:-2),
(op:'set  3,(ix+##),d';leng:-2),
(op:'set  3,(ix+##),e';leng:-2),
(op:'set  3,(ix+##),h';leng:-2),
(op:'set  3,(ix+##),l';leng:-2),
(op:'set  3,(ix+##)';leng:-2),
(op:'set  3,(ix+##),a';leng:-2),
(op:'set  4,(ix+##),b';leng:-2),
(op:'set  4,(ix+##),c';leng:-2),
(op:'set  4,(ix+##),d';leng:-2),
(op:'set  4,(ix+##),e';leng:-2),
(op:'set  4,(ix+##),h';leng:-2),
(op:'set  4,(ix+##),l';leng:-2),
(op:'set  4,(ix+##)';leng:-2),
(op:'set  4,(ix+##),a';leng:-2),
(op:'set  5,(ix+##),b';leng:-2),
(op:'set  5,(ix+##),c';leng:-2),
(op:'set  5,(ix+##),d';leng:-2),
(op:'set  5,(ix+##),e';leng:-2),
(op:'set  5,(ix+##),h';leng:-2),
(op:'set  5,(ix+##),l';leng:-2),
(op:'set  5,(ix+##)';leng:-2),
(op:'set  5,(ix+##),a';leng:-2),
(op:'set  6,(ix+##),b';leng:-2),
(op:'set  6,(ix+##),c';leng:-2),
(op:'set  6,(ix+##),d';leng:-2),
(op:'set  6,(ix+##),e';leng:-2),
(op:'set  6,(ix+##),h';leng:-2),
(op:'set  6,(ix+##),l';leng:-2),
(op:'set  6,(ix+##)';leng:-2),
(op:'set  6,(ix+##),a';leng:-2),
(op:'set  7,(ix+##),b';leng:-2),
(op:'set  7,(ix+##),c';leng:-2),
(op:'set  7,(ix+##),d';leng:-2),
(op:'set  7,(ix+##),e';leng:-2),
(op:'set  7,(ix+##),h';leng:-2),
(op:'set  7,(ix+##),l';leng:-2),
(op:'set  7,(ix+##)';leng:-2),
(op:'set  7,(ix+##),a';leng:-2)));

function place(s:Format;value:string):String;
function Disassemble(Var str:String;pc:Word):Word;
FUNCTION byte2hex (W : Byte) : String;
FUNCTION word2hex (W : Word) : String;

implementation uses machine;
function place(s:Format;value:string):String;
var i,j: byte;
begin
 j:=1;
 for i:=1 to length(s.op) do
  if (s.op[i]='#') and (j<=length(value)) then
   begin s.op[i]:=value[j];inc(j);end;
  place:=s.op;
end;

Const h     : String = ('0123456789ABCDEF');
FUNCTION byte2hex (W : Byte) : String;
BEGIN
  result := h [W Div 16 + 1] + h [W Mod 16 + 1];
END;

FUNCTION word2hex (W : Word) : String;
BEGIN
  result := byte2hex (Hi (W) ) + byte2hex (Lo (W) );
END;

function Disassemble(Var str:String;pc:Word):Word;
var firstByte, i, j:integer;
    code:format;
begin
firstByte:= speekb(pc);
i:=firstbyte;
inc(pc);
if major[i].op='' then
begin
j:= major[i].leng;
i:= speekb(pc);
inc(pc);
if minor[j][i].op='' then
begin
 j:= minor[j][i].leng;
 i:= speekb(pc + 1);
end;

 code:= minor[j][i];
end
else code:= major[i];

case (code.leng) of
2: begin str:=place(code,word2hex(wordpeek(pc)));inc(pc,2); end;
1: begin str:=place(code,byte2hex(speekb(pc))); inc(pc); end;
0: str:=code.op;
-1: begin
     str:=place(code,word2hex((pc + 1 + shortint(speekb(pc)) and $ffff)));
     inc(pc);
    end;
-2: begin
     str:=place(code,byte2hex(speekb(pc)));inc(pc,2);
    end;
end;
if (firstByte = $fd) then
 for i:=4 to length(str) do if str[i]='x' then str[i]:='y';
disassemble:=pc;
end;

end.