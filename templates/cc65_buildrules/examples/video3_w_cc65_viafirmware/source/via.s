;PURPOSE - defines the static register references for the via interface as provided by Ben Eater's videos https://eater.net/6502
;
;This file is an exact copy of https://github.com/dbuchwald/cc65-tools/blob/main/tutorial/03_blink/blink.s (aside from the comments)
;
;This first bit is important. It issues cc65 magic to get the start address of the VIA memory block defined in firmware.cfg
;Seeing the pattern? By defining memory spaces and static addresses in firmware.cfg, the rest of the code doesn't need to be aware
;of the actual static values
  .import __VIA_START__

  .export VIA_PORTB
  .export VIA_PORTA
  .export VIA_DDRB
  .export VIA_DDRA
  .export VIA_T1CL
  .export VIA_T1CH
  .export VIA_T1LL
  .export VIA_T1LH
  .export VIA_T2CL
  .export VIA_T2CH
  .export VIA_SR
  .export VIA_ACR
  .export VIA_PCR
  .export VIA_IFR
  .export VIA_IER
  .export VIA_PANH

VIA_REGISTER_PORTB = $00
VIA_REGISTER_PORTA = $01
VIA_REGISTER_DDRB  = $02
VIA_REGISTER_DDRA  = $03
VIA_REGISTER_T1CL  = $04
VIA_REGISTER_T1CH  = $05
VIA_REGISTER_T1LL  = $06
VIA_REGISTER_T1LH  = $07
VIA_REGISTER_T2CL  = $08
VIA_REGISTER_T2CH  = $09
VIA_REGISTER_SR    = $0a
VIA_REGISTER_ACR   = $0b
VIA_REGISTER_PCR   = $0c
VIA_REGISTER_IFR   = $0d
VIA_REGISTER_IER   = $0e
VIA_REGISTER_PANH  = $0f

VIA_PORTB = __VIA_START__ + VIA_REGISTER_PORTB
VIA_PORTA = __VIA_START__ + VIA_REGISTER_PORTA
VIA_DDRB  = __VIA_START__ + VIA_REGISTER_DDRB
VIA_DDRA  = __VIA_START__ + VIA_REGISTER_DDRA
VIA_T1CL  = __VIA_START__ + VIA_REGISTER_T1CL
VIA_T1CH  = __VIA_START__ + VIA_REGISTER_T1CH
VIA_T1LL  = __VIA_START__ + VIA_REGISTER_T1LL
VIA_T1LH  = __VIA_START__ + VIA_REGISTER_T1LH
VIA_T2CL  = __VIA_START__ + VIA_REGISTER_T2CL
VIA_T2CH  = __VIA_START__ + VIA_REGISTER_T2CH
VIA_SR    = __VIA_START__ + VIA_REGISTER_SR
VIA_ACR   = __VIA_START__ + VIA_REGISTER_ACR
VIA_PCR   = __VIA_START__ + VIA_REGISTER_PCR
VIA_IFR   = __VIA_START__ + VIA_REGISTER_IFR
VIA_IER   = __VIA_START__ + VIA_REGISTER_IER
VIA_PANH  = __VIA_START__ + VIA_REGISTER_PANH