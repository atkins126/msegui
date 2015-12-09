{ MSEgui Copyright (c) 1999-2015 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit mseformatstr;     //stringwandelroutinen 31.5.99 mse

{$ifdef FPC}{$mode objfpc}{$h+}{$interfaces corba}{$goto on}{$endif}

interface
uses
 classes,mclasses,msetypes,msestrings,SysUtils,msemacros,mseglob
 {$ifndef FPC},classes_del{$endif};
{$ifdef FPC}{$define hasqword}{$endif}
{$ifdef mswindows}{$define hasqword}{$endif}
type
 dateconvertty = (dc_none,dc_tolocal,dc_toutc);
 
  TMonthNameArraymse = array[1..12] of msestring;
  TWeekNameArraymse = array[1..7] of msestring;

  TFormatSettingsmse = record
    CurrencyFormat: Byte;
    NegCurrFormat: Byte;
    ThousandSeparator: mseChar;
    DecimalSeparator: mseChar;
    CurrencyDecimals: Byte;
    DateSeparator: mseChar;
    TimeSeparator: mseChar;
    ListSeparator: mseChar;
    CurrencyString: msestring;
    ShortDateFormat: msestring;
    LongDateFormat: msestring;
    TimeAMString: msestring;
    TimePMString: msestring;
    ShortTimeFormat: msestring;
    LongTimeFormat: msestring;
    ShortMonthNames: TMonthNameArraymse;
    LongMonthNames: TMonthNameArraymse;
    ShortDayNames: TWeekNameArraymse;
    LongDayNames: TWeekNameArraymse;
    TwoDigitYearCenturyWindow: Word;
  end;

 tformatmacrolist = class(tmacrolist)
  public
   procedure addmac(const aname: msestring; const avalue: msestring;
                                      const ahandler: macrohandlerty = nil);
 end;

var
 DefaultFormatSettingsmse : TFormatSettingsmse = (
   CurrencyFormat: 1;
   NegCurrFormat: 5;
   ThousandSeparator: ',';
   DecimalSeparator: '.';
   CurrencyDecimals: 2;
   DateSeparator: '-';
   TimeSeparator: ':';
   ListSeparator: ',';
   CurrencyString: '$';
   ShortDateFormat: 'd/m/y';
   LongDateFormat: 'dd" "mmmm" "yyyy';
   TimeAMString: 'AM';
   TimePMString: 'PM';
   ShortTimeFormat: 'hh:nn';
   LongTimeFormat: 'hh:nn:ss';
   ShortMonthNames: ('Jan','Feb','Mar','Apr','May','Jun', 
                     'Jul','Aug','Sep','Oct','Nov','Dec');
   LongMonthNames: ('January','February','March','April','May','June',
                    'July','August','September','October','November',
                    'December');
   ShortDayNames: ('Sun','Mon','Tue','Wed','Thu','Fri','Sat');
   LongDayNames:  ('Sunday','Monday','Tuesday','Wednesday','Thursday','Friday',
                   'Saturday');
   TwoDigitYearCenturyWindow: 50;
 );

const
// noformatsettings = 14.5;    //rtlversion
 noformatsettings = 15;    //rtlversion
 fc_keinplatzchar = '*';
 nullen = '000000000000000000000000000000';
 msenullen = msestring('000000000000000000000000000000');
 msespace = msestring('                              ');
 
type
 numbasety = (nb_bin,nb_oct,nb_dec,nb_hex);

function lstring(const s: string; const minwidth: integer): string;
function rstring(const s: string; const minwidth: integer): string;

{$warnings off}
       // ${THEMACRO} checks formatmacros, macro name case sensitive
{$warnings on}
      
function formatdatetimemse(formatstr: msestring; const datetime: tdatetime;
            const formatsettings: tformatsettingsmse): msestring; overload;
//            'I' = ISO date, 'II' ISO datetime, 'III' ISO datetime + ms
function formatdatetimemse(const formatstr: msestring;
                          const datetime: tdatetime): msestring; overload;

function formatfloatmse(value: double; format: msestring; 
                         const formatsettings: tformatsettingsmse;
                         const dot: boolean = false): msestring; overload;
   //dot = true -> always '.' as decimal separator
   //formatstring:
   // formats for positive, negative and zero value can be separated by ;
   // ' and " qoted text as is
   // c -> currencyformat
   // C -> currencyformat without currencyname
   //
   // + 0 or number digit
   // |+ show defaultformatsettingsmse.thousandseparator
   // ||+ defaultformatsettingsmse.decimalseparator or '.' if dot = true
   // ||| removed if there are no fract digits
   // |||+ 0 or number digit
   // 0,.0
   //
   // + space or number digit
   // | + removed or number digit
   // #.#
   //
   //    + scientific notation with 'e'
   //    |+ remove '+' from positive exponent
   //    ||+++ 0 or exponent digit
   // 0.0e-000
   //
   //     + show '+' of positive exponent
   // 0.0e+
   //
   //    + scientific notation with 'E'
   // 0.0E
   //
   //    + engeneering notation with 'e', exponent = n*3
   //    |
   // 0.0f
   //
   //    ++++++ mantissa - 1 digits max
   // 0..000###f
   //    +++    mantissa - 1 digits min
   //
   //    + engeneering notation with 'E', exponent = n*3
   // 0.0F
   //
   //    + engeneering notation with metric system prefixes, exponent = n*3
   //    | no space for 10^0
   // 0.0g   
   //
   //    + engeneering notation with metric system prefixes, exponent = n*3
   //    | space for 10^0
   // 0.0G
   //
   // examples for value = 12345.678
   // '0.0'    ->  '12345.7'
   // '0.000e   ->  '1.235e4'
   // '0.000f   ->  '12.346e3'
   // '0.000g   ->  '12.346k'
   // '0.###f   ->  '12.35e3'

function formatfloatmse(const value: double; const format: msestring; 
                         const dot: boolean = false): msestring; overload;
function realtostrmse(const value: double;
                                const dot: boolean = false): msestring;
function realtytostrmse(const value: double;
                                const dot: boolean = false): msestring;

function inttostr(const value: integer): string;
function inttostr(const value: longword): string;
function inttostr(const value: int64): string;
function inttostr(const value: qword): string;

function inttostrmse(const value: integer): msestring; overload;
function inttostrmse(const value: longword): msestring; overload;
function inttostrmse(const value: int64): msestring; overload;
function inttostrmse(const value: qword): msestring; overload;

function trystrtodouble(const s: lstringty; out value: double; 
                             const decimalseparator: char): boolean; overload;
function trystrtodouble(const s: lmsestringty; out value: double; 
                             const decimalseparator: msechar): boolean; overload;
function trystrtodouble(const s: string; out value: double; 
                             const decimalseparator: char): boolean; overload;
function trystrtodouble(const s: msestring; out value: double; 
                             const decimalseparator: msechar): boolean; overload;
function strtodouble(const s: string;
                             const decimalseparator: char): double;
function strtodouble(const s: msestring;
                             const decimalseparator: msechar): double;
function trystrtodouble(const s: string; out value: double): boolean; overload;
function trystrtodouble(const s: msestring; out value: double): boolean; overload;
function strtodouble(const s: string): double;
function strtodouble(const s: msestring): double;
                                
function realtostr(const value: double): string;     //immer'.' als separator
function strtoreal(const s: string): double;   //immer'.' als separator
function trystrtoreal(const s: string; out value: real): boolean;
                                               //immer'.' als separator
function strtoreal(const s: msestring): double;   //immer'.' als separator
function trystrtoreal(const s: msestring; out value: real): boolean;
                                               //immer'.' als separator
function currencytostr(const avalue: currency): string; 
                         //always '.' as as decimal separator
function currencytostrmse(const avalue: currency): msestring;
                         //always '.' as as decimal separator

function trystrtorealty(const ein: msestring; out value: realty;
                             forcevalue: boolean = false): boolean;
function strtorealty(const ein: string; forcevalue: boolean = false): realty;
function strtorealty(const ein: msestring; forcevalue: boolean = false): realty;
function strtorealtydot(const ein: string): realty;
function strtorealtydot(const ein: msestring): realty;
function trystrtorealtydot(const ein: string; out value: realty): boolean;
function trystrtorealtydot(const ein: msestring; out value: realty): boolean;
//function realtytostr(const val: realty; const format: msestring = ''): msestring;
function realtytostr(const val: realty; const format: msestring = '';
                                            const scale: real = 1): msestring;
function realtytostrrange(const val: realty; const format: msestring = '';
                                            const range: real = 1;
                                            const offset: real = 0): msestring;
function realtytostrdot(const val: realty): string;
function realtytostrdotmse(const val: realty): msestring;

function wordtostr(const avalue: longword): string;

function bytetohex(const inp: byte): string;
 //wandelt byte in zwei ascii hexzeichen
function wordtohex(const inp: word; lsbfirst: boolean = false): string;
 //wandelt word in vier ascii hexzeichen
 
function valtohex(const avalue: byte): string; overload;
function valtohex(const avalue: word): string; overload;
function valtohex(const avalue: longword): string; overload;
function valtohex(const avalue: qword): string; overload;

function dectostr(const inp: integer; digits: integer): string; overload;
          //leading zeroes if digits < 0
function dectostr(const inp: int64; digits: integer): string; overload;
          //leading zeroes if digits < 0
function bintostr(inp: longword; digits: integer): string; overload;
   //convert longword to binstring, digits = bit count
function bintostr(inp: qword; digits: integer): string; overload;
   //convert longword to binstring, digits = bit count
function octtostr(inp: longword; digits: integer): string; overload;
   //convert longword to octaltring, digits = octet count
function octtostr(inp: qword; digits: integer): string; overload;
   //convert longword to octaltring, digits = octet count
function hextostr(inp: longword;
             digits: integer = 2*sizeof(longword)): string; overload;
   //convert longword to hexstring, digits = nibble count, 0 -> variable
function hextostr(inp: qword;
             digits: integer = 2*sizeof(qword)): string; overload;
   //convert qword to hexstring, digits = nibble count, 0 -> variable
function hextostr(const inp: pointer;
             digits: integer = 2*sizeof(pointer)): string; overload;
   //convert pointer to hexstring, digits = nibble count, 0 -> variable
function hextostrmse(inp: longword;
             digits: integer = 2*sizeof(longword)): msestring; overload;
   //convert longword to hexstring, digits = nibble count, 0 -> variable
function hextostrmse(inp: qword;
             digits: integer = 2*sizeof(qword)): msestring; overload;
   //convert qword to hexstring, digits = nibble count, 0 -> variable
function hextostrmse(const inp: pointer;
             digits: integer = 2*sizeof(pointer)): msestring; overload;
   //convert pointer to hexstring, digits = nibble count, 0 -> variable
function hextocstr(const inp: longword; stellen: integer): string; overload;
   //convert longword to 0x..., digits = nibble count, 0 -> variable
function hextocstr(const inp: qword; stellen: integer): string; overload;
   //convert longword to 0x..., digits = nibble count, 0 -> variable
function ptruinttocstr(inp: ptruint): string; overload;
   //convert ptruint to 0x...
function qwordtocstr(inp: qword): string; overload;
   //convert ptruint to 0x...
function intvaluetostr(const value: integer; const base: numbasety = nb_dec;
                          const bitcount: integer = 32): string; overload;
function intvaluetostr(const value: int64; const base: numbasety = nb_dec;
                          const bitcount: integer = 64): string; overload;

function trystrtoptruint(const inp: string; out value: ptruint): boolean;
function strtoptruint(const inp: string): ptruint;

function trystrtobin(const inp: string; out value: longword): boolean;
function strtobin(const inp: string): longword;
function trystrtooct(const inp: string; out value: longword): boolean;
function strtooct(const inp: string): longword;
function trystrtodec(const inp: string; out value: longword): boolean;
function strtodec(const inp: string): longword;
function trystrtohex(const inp: pchar; const len: int32;
                                                out value: longword): boolean;
function trystrtohex(const inp: lstringty; out value: longword): boolean;
function trystrtohex(const inp: string; out value: longword): boolean;
function trystrtohex(const inp: msestring; out value: longword): boolean;
function strtohex(const inp: string): longword;
function strtohex(const inp: msestring): longword;

function trystrtobin64(const inp: string; out value: qword): boolean;
function strtobin64(const inp: string): qword;
function trystrtooct64(const inp: string; out value: qword): boolean;
function strtooct64(const inp: string): qword;
function trystrtodec64(const inp: string; out value: qword): boolean;
function strtodec64(const inp: string): qword;
function trystrtohex64(const inp: string; out value: qword): boolean;
function strtohex64(const inp: string): qword;


function trystrtoint(const text: pchar; const len: int32; 
                                          out value: integer): boolean;
function trystrtoint(const text: lstringty; out value: integer): boolean;
function trystrtoint(const text: string; out value: integer): boolean;
function trystrtoint(const text: msestring; out value: integer): boolean;
function strtoint(const text: string): integer;
function strtoint(const text: msestring): integer;
function trystrtoint(const text: string; out value: longword): boolean;
function trystrtoint(const text: msestring; out value: longword): boolean;
function strtoint64(const text: string): int64;
function strtoint64(const text: msestring): int64;
function trystrtoint64(const text: lstringty; out value: int64): boolean;
function trystrtoint64(const text: string; out value: int64): boolean;
function trystrtoint64(const text: msestring; out value: int64): boolean;
function trystrtoqword(const text: string; out value: qword): boolean;
function trystrtoqword(const text: msestring; out value: qword): boolean;

function trystrtointvalue(const inp: string;
                            out value: longword): boolean; overload;
   //% prefix -> bin, & -> oct, # -> dez, $ -> hex 0x -> hex
function strtointvalue(const inp: string): longword; overload;
function trystrtointvalue(const text: msestring; base: numbasety;
                            out value: longword): boolean; overload;
function strtointvalue(const text: msestring; base: numbasety): longword; overload;

function trystrtointvalue64(const inp: string;
                            out value: qword): boolean; overload;
   //% prefix -> bin, & -> oct, # -> dez, $ -> hex 0x -> hex
function strtointvalue64(const inp: string): qword; overload;
function trystrtointvalue64(const text: msestring; base: numbasety;
                            out value: qword): boolean; overload;
function strtointvalue64(const text: msestring; base: numbasety): qword; overload;


function bytestrtostr(const inp: ansistring; base: numbasety = nb_hex;
                                          spacechar: char = #0): string;
   //wandelt bytefolge in ascii hexstring, spacechar #0 -> none
function bytestrtobin(const inp: ansistring; abstand: boolean): string;
   //wandelt bytefolge in ascii binstring,
   // letztes zeichen = anzahl gueltige bits in letztem byte
function bitmaske(const data: ansistring): integer; //anzahl gueltige bits in vorletztem byte
function bitcount(const data: ansistring): integer; //anzahl gueltige bits

function bcdtostr(inp: byte): string;
 //wandelt bcdwert in zwei ascii zeichen
function bytetobcd(inp: byte): word;
 //wandelt byte in bcdwert
function bcdtobyte(inp: byte): byte;
 //wandelt bcdbyte in byte
function strtobytestr(inp: string): ansistring;
 //wandelt hex asciistring in bytefolge
function strtobinstr(inp: string): ansistring;
 //wandelt bin asciistring in bytefolge
function strtobytes(const inp: string; out dest: bytearty): boolean;
//msb first, true if ok

function inttostrlen(inp: integer; len: integer;
     rechtsbuendig: boolean = true; fillchar: char = ' '): ansistring;
 //wandelt integer in string fester laenge
function inttostrlenmse(inp: integer; len: integer;
     rechtsbuendig: boolean = true; fillchar: msechar = ' '): msestring;
{
function filename(inp: string): string;
//bringt filenamen ohne pfad und extension
function replaceext(inp,ext: string): string;
//ersetzt fileextension
}
function bcdtoint(inp: byte): integer;
function inttobcd(inp: integer): byte;

function stringtotime(const avalue: msestring;
             const convert: dateconvertty = dc_none): tdatetime; overload;
function stringtotime(const avalue: msestring;
                              const aformat: msestring;
             const convert: dateconvertty = dc_none): tdatetime; overload;
function trystringtotime(const text: msestring;
                              out value: tdatetime;
               const convert: dateconvertty = dc_none): boolean;  overload;
function trystringtotime(const text: msestring;
                   const aformat: msestring; out value: tdatetime;
                   const convert: dateconvertty = dc_none): boolean;  overload;

function timetostring(const avalue: tdatetime; 
                          const format: msestring = 't'): msestring;
function datetostring(const avalue: tdatetime;
                          const format: msestring = 'c'): msestring;
function stringtodate(const avalue: msestring;
                               const convert: dateconvertty = dc_none): tdatetime;  overload;
function stringtodate(const avalue: msestring;
                              const aformat: msestring;
                               const convert: dateconvertty = dc_none): tdatetime;  overload;
function trystringtodate(const text: msestring; out value: tdatetime;
                               const convert: dateconvertty = dc_none): boolean;  overload;
function trystringtodate(const text: msestring;
                              const aformat: msestring;
                              out value: tdatetime;
                               const convert: dateconvertty = dc_none): boolean;  overload;
function datetimetostring(const avalue: tdatetime;
                          const format: msestring = 'c'): msestring;
function stringtodatetime(const avalue: msestring;
                               const convert: dateconvertty = dc_none): tdatetime; overload;
function stringtodatetime(const avalue: msestring;
                              const aformat: msestring;
                               const convert: dateconvertty = dc_none): tdatetime; overload;
function trystringtodatetime(const text: msestring;
                              out value: tdatetime;
                               const convert: dateconvertty = dc_none): boolean;  overload;
function trystringtodatetime(const text: msestring;
                              aformat: msestring;
                              out value: tdatetime;
                               const convert: dateconvertty = dc_none): boolean;  overload;
procedure checkdateconvert(const convert: dateconvertty; var value: tdatetime);
procedure checkdatereconvert(const convert: dateconvertty; var value: tdatetime);

function timemse(const value: tdatetime): tdatetime;
  //bringt timeanteil im mseformat

function cstringtostring(inp: pchar): string; overload;
function cstringtostring(const inp: string): string; overload;
function cstringtostringvar(var inp: pchar): string;
function stringtocstring(const inp: msestring): string; overload;
function stringtocstring(const inp: pmsechar;
                               const count: integer): string; overload;
function stringtopascalstring(const value: msestring): string;
function pascalstringtostring(const value: string): msestring;
function trypascalstringtostring(const value: string;
                                              out res: msestring ): boolean;
function getpascalstring(var value: pchar): msestring;

function encodebase64(const abinary: string;
      const maxlinelength: integer = defaultbase64linelength): string; overload;
function encodebase64(const abinary: pbyte; acount: integer;
      const maxlinelength: integer = defaultbase64linelength): string; overload;
function decodebase64(const atext: string): string;

{$ifndef FPC}
function TryStrToQWord(const S: string; out Value: QWord): Boolean;
{$endif}

procedure msestrtotvarrec(const value: ansistring; out varrec: tvarrec);
procedure msestrtotvarrec(const value: msestring; out varrec: tvarrec);

function tvarrectoansistring(const value: tvarrec): ansistring;
function tvarrectomsestring(const value: tvarrec): msestring;

function formatmacros: tformatmacrolist;
procedure clearformatmacros;

{$ifdef FPC}
 {$define withformatsettings}
{$endif}
{$ifdef mswindows}
 {$define withformatsettings}
{$endif}

var
 defaultformatsettingsdot: tformatsettings; //mit '.' als dezitrenner

const
 charhex: array[0..15] of char =
          ('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');
 charhexlower: array[0..15] of char =
          ('0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f');
 hexchars: array[char] of byte = (
  $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80, //0
  $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80, //1
  $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80, //2
  $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$80,$80,$80,$80,$80,$80, //3
  $80,$0A,$0B,$0C,$0D,$0E,$0F,$80,$80,$80,$80,$80,$80,$80,$80,$80, //4
  $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80, //5
  $80,$0a,$0b,$0c,$0d,$0e,$0f,$80,$80,$80,$80,$80,$80,$80,$80,$80, //6
  $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80, //7
  $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80, //8
  $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80, //9
  $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80, //a
  $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80, //b
  $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80, //c
  $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80, //d
  $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80, //e
  $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80);//f

 base64mask = $3f;
 base64encoding: array[0..63] of char = (
//0   1   2   3   4   5   6   7   8   9   a   b   c   d   e   f
 'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P', //00
 'Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f', //10
 'g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v', //20
 'w','x','y','z','0','1','2','3','4','5','6','7','8','9','+','/');//30

 base64decoding: array[0..255] of byte = (
//0   1   2   3   4   5   6   7   8   9   a   b   c   d   e   f
 $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff, //00
 $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff, //10
//                                            '+'            '/'
 $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$3e,$ff,$ff,$ff,$3f, //20
//'0','1','2','3','4','5','6','7','8','9',
 $34,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$ff,$ff,$ff,$ff,$ff,$ff, //30
//    'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O',
 $ff,$00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e, //40
//'P','Q','R','S','T','U','V','W','X','Y','Z',
 $0f,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$ff,$ff,$ff,$ff,$ff, //50
//    'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o',
 $ff,$1a,$1b,$1c,$1d,$1e,$1f,$20,$21,$22,$23,$24,$25,$26,$27,$28, //60
//'p','q','r','s','t','u','v','w','x','y','z',
 $29,$2a,$2b,$2c,$2d,$2e,$2f,$30,$31,$32,$33,$ff,$ff,$ff,$ff,$ff, //70
 $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff, //80
 $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff, //90
 $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff, //a0
 $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff, //b0
 $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff, //c0
 $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff, //d0
 $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff, //e0
 $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff);//f0

implementation

uses
 sysconst,msedate,msereal,Math,msefloattostr,msearrayutils,msesys,msebits;

function lstring(const s: string; const minwidth: integer): string;
var
 int1: integer;
begin
 int1:= length(s);
 if int1 < minwidth then begin
  result:= s + charstring(' ',minwidth-int1);
 end
 else begin
  result:= s;
 end;
end;

function rstring(const s: string; const minwidth: integer): string;
var
 int1: integer;
begin
 int1:= length(s);
 if int1 < minwidth then begin
  result:= charstring(' ',minwidth-int1) + s;
 end
 else begin
  result:= s;
 end;
end;

var
 fformatmacros: tformatmacrolist;

function formatmacros: tformatmacrolist;
begin
 if fformatmacros = nil then begin
  fformatmacros:= tformatmacrolist.create(
                                   [mao_curlybraceonly,mao_removeunknown]);
 end;
 result:= fformatmacros;
end;

procedure checkformatmacros(var format: msestring);
begin
 if (fformatmacros <> nil) and (findchar(format,'{') > 0) then begin
  fformatmacros.expandmacros1(format);
 end;
end;

{$ifndef FPC}
function trystrtoqword(const s: string; out value: qword): boolean;
begin
 result:= trystrtoint64(s,int64(value));
end;

function composedatetime(const adate: tdatetime; const atime: tdatetime): tdatetime;
begin
 if date < 0 then begin
  result := trunc(date) - abs(frac(time));
 end
 else begin
  result := trunc(date) + abs(frac(time));
 end;
end;
{$endif}

//copied from FPC dati.inc

function formatdatetimemse(formatstr: msestring; const datetime: tdatetime;
                  const formatsettings: tformatsettingsmse): msestring;
var
   ResultLen: integer;
   ResultBuffer: array[0..255] of msechar;
   ResultCurrent: pmsechar;

   procedure StoreStr(Str: pmsechar; Len: integer);
   begin
   if ResultLen + Len < SizeOf(ResultBuffer) div 2 then begin
      Move(Str^, ResultCurrent^, Len*sizeof(msechar));
      ResultCurrent := ResultCurrent + Len;
      ResultLen := ResultLen + Len;
      end ;
   end ;

   procedure StoreString(const Str: msestring);
   var Len: integer;
   begin
   Len := Length(Str);
   if ResultLen + Len < SizeOf(ResultBuffer) div 2 then begin // strmove not safe
      Move( pointer(Str)^,ResultCurrent^,Len*sizeof(msechar));
      ResultCurrent := ResultCurrent + Len;
      ResultLen := ResultLen + Len;
      end;
   end;

   procedure StoreInt(Value, Digits: integer);
   var S: msestring; Len: integer;
   begin
   S := IntToStrmse(Value);
   Len := Length(S);
   if Len < Digits then begin
      S := copy(msestring('0000'), 1, Digits - Len) + S;
      Len := Digits;
      end ;
   StoreStr(pmsechar(pointer(S)), Len);
   end ;

var
   Year, Month, Day, DayOfWeek, Hour, Minute, Second, MilliSecond: word;

   procedure StoreFormat(const FormatStr: msestring);
   var
      Token,lastformattoken: msechar;
      FormatCurrent: pmsechar;
      FormatEnd: pmsechar;
      Count: integer;
      Clock12: boolean;
      P: pmsechar;
      tmp:integer;

   begin
   with formatsettings do begin
    FormatCurrent := Pmsechar(pointer(FormatStr));
    FormatEnd := FormatCurrent + Length(FormatStr);
    Clock12 := false;
    P := FormatCurrent;
    while P < FormatEnd do begin
       Token := charUpperCase(P^);
       if (Token = '"') or (token =  '''') then begin
          P := P + 1;
          while (P < FormatEnd) and (P^ <> Token) do
             P := P + 1;
          end
       else if Token = 'A' then begin
          if (mseStrLIComp(P, 'A/P', 3) = 0) or
             (mseStrLIComp(P, 'AMPM', 4) = 0) or
             (mseStrLIComp(P, 'AM/PM', 5) = 0) then begin
             Clock12 := true;
             break;
             end ;
          end ;
       P := P + 1;
       end ;
    token:=#255;
    lastformattoken:=' ';
    while FormatCurrent < FormatEnd do
      begin
       Token := charUpperCase(FormatCurrent^);
       Count := 1;
       P := FormatCurrent + 1;
          case Token of
             '''', '"': begin
                while (P < FormatEnd) and (p^ <> Token) do
                   P := P + 1;
                P := P + 1;
                Count := P - FormatCurrent;
                StoreStr(FormatCurrent + 1, Count - 2);
                end ;
             'A': begin
                if mseStrLIComp(FormatCurrent, pmsechar(msestring('AMPM')), 4) = 0 then begin
                   Count := 4;
                   if Hour < 12 then StoreString(TimeAMString)
                   else StoreString(TimePMString);
                   end
                else if mseStrLIComp(FormatCurrent, 'AM/PM', 5) = 0 then begin
                   Count := 5;
                   if Hour < 12 then StoreStr('am', 2)
                   else StoreStr('pm', 2);
                   end
                else if mseStrLIComp(FormatCurrent, 'A/P', 3) = 0 then begin
                   Count := 3;
                   if Hour < 12 then StoreStr('a', 1)
                   else StoreStr('p', 1);
                   end
                else
//                  Raise EConvertError.Create('Illegal character in format string');
                end ;
             '/': StoreStr(@DateSeparator, 1);
             ':': StoreStr(@TimeSeparator, 1);
             ' ', 'C', 'D', 'H', 'I', 'M', 'N', 'S', 'T', 'Y','Z' :
               begin
                 while (P < FormatEnd) and (charUpperCase(P^) = Token) do
                   P := P + 1;
                 Count := P - FormatCurrent;
                 case Token of
                    ' ': StoreStr(FormatCurrent, Count);
                    'Y': begin
                          if Count>2 then
                            StoreInt(Year, 4)
                          else
                            StoreInt(Year mod 100, 2);
                         end;
                    'M': begin
                          if lastformattoken='H' then
                            begin
                              if Count = 1 then
                                StoreInt(Minute, 0)
                              else
                                StoreInt(Minute, 2);
 
                            end
                          else
                            begin
                              case Count of
                                 1: StoreInt(Month, 0);
                                 2: StoreInt(Month, 2);
                                 3: StoreString(ShortMonthNames[Month]);
                                 4: StoreString(LongMonthNames[Month]);
                              end;
                            end;
                       end;
                    'D': begin
                          case Count of
                             1: StoreInt(Day, 0);
                             2: StoreInt(Day, 2);
                             3: StoreString(ShortDayNames[DayOfWeek]);
                             4: StoreString(LongDayNames[DayOfWeek]);
                             5: StoreFormat(ShortDateFormat);
                             6: StoreFormat(LongDateFormat);
                          end ;
                       end ;
                    'H': begin
                       if Clock12 then begin
                          tmp:=hour mod 12;
                          if tmp=0 then tmp:=12;
                          if Count = 1 then StoreInt(tmp, 0)
                          else StoreInt(tmp, 2);
                          end
                       else begin
                          if Count = 1 then StoreInt(Hour, 0)
                          else StoreInt(Hour, 2);
                          end ;
                       end ;
                    'N': begin
                       if Count = 1 then StoreInt(Minute, 0)
                       else StoreInt(Minute, 2);
                       end ;
                    'S': begin
                       if Count = 1 then StoreInt(Second, 0)
                       else StoreInt(Second, 2);
                       end ;
                    'Z': begin
                       if Count = 1 then StoreInt(MilliSecond, 0)
                       else StoreInt(MilliSecond, 3);
                       end ;
                    'T': begin
                       if Count = 1 then StoreFormat(ShortTimeFormat)
                       else StoreFormat(LongTimeFormat);
                       end ;
                    'C': begin
                        StoreFormat(ShortDateFormat);
                        if (Hour<>0) or (Minute<>0) or (Second<>0) then
                         begin
                           StoreString(' ');
                           StoreFormat(LongTimeFormat);
                         end;
                    end;
                    'I': begin
                     case count of
                      1: begin
                       StoreFormat('YYYY-MM-DD');
                      end;
                      2: begin
                       StoreFormat('YYYY-MM-DD"T"HH:MM:SS');
                      end;
                      else begin
                       StoreFormat('YYYY-MM-DD"T"HH:MM:SS:ZZZ');
                      end;
                     end;
                    end;
                 end;
                 lastformattoken:=token;
               end;
             else
               StoreStr(@Token, 1);
          end ;
       FormatCurrent := FormatCurrent + Count;
       end ;
     end;
   end ;

begin
 checkformatmacros(formatstr);
  DecodeDateFully(DateTime, Year, Month, Day, DayOfWeek);
  DecodeTime(DateTime, Hour, Minute, Second, MilliSecond);
  ResultLen := 0;
  ResultCurrent := @ResultBuffer[0];
  StoreFormat(FormatStr);
//  ResultBuffer[ResultLen] := #0;
//  result := StrPas(@ResultBuffer[0]);
  setlength(result,resultlen);
  move(resultbuffer,pointer(result)^,resultlen*sizeof(msechar));
end ;

function formatdatetimemse(const formatstr: msestring;
                          const datetime: tdatetime): msestring;
begin
 result:= formatdatetimemse(formatstr,datetime,defaultformatsettingsmse);
end;

(* 
//copied from FPC sysstr.inc
//todo: optimize, use threadsave formatsettings

Function FloatToTextFmt(Buffer: PmseChar; Value: Extended; format: PmseChar;
                         const formatsettings: tformatsettingsmse): Integer;

Var
  Digits: String[40];                         { String Of Digits                 }
  Exponent: String[8];                        { Exponent strin                   }
  FmtStart, FmtStop: PmseChar;                { Start And End Of relevant part   }
                                              { Of format String                 }
  ExpFmt, ExpSize: Integer;                   { Type And Length Of               }
                                              { exponential format chosen        }
  Placehold: Array[1..4] Of Integer;          { Number Of placeholders In All    }
                                              { four Sections                    }
  thousand: Boolean;                          { thousand separators?             }
  UnexpectedDigits: Integer;                  { Number Of unexpected Digits that }
                                              { have To be inserted before the   }
                                              { First placeholder.               }
  DigitExponent: Integer;                     { Exponent Of First digit In       }
                                              { Digits Array.                    }

  { Find end of format section starting at P. False, if empty }

  Function GetSectionEnd(Var P: PmseChar): Boolean;
  Var
    C: mseChar;
    SQ, DQ: Boolean;
  Begin
    Result := False;
    SQ := False;
    DQ := False;
    C := P[0];
    While (C<>#0) And ((C<>';') Or SQ Or DQ) Do
      Begin
      Result := True;
      Case C Of
        #34: If Not SQ Then DQ := Not DQ;
        #39: If Not DQ Then SQ := Not SQ;
      End;
      Inc(P);
      C := P[0];
      End;
  End;

  { Find start and end of format section to apply. If section doesn't exist,
    use section 1. If section 2 is used, the sign of value is ignored.       }

  Procedure GetSectionRange(section: Integer);
  Var
    Sec: Array[1..3] Of PmseChar;
    SecOk: Array[1..3] Of Boolean;
  Begin
    Sec[1] := format;
    SecOk[1] := GetSectionEnd(Sec[1]);
    If section > 1 Then
      Begin
      Sec[2] := Sec[1];
      If Sec[2][0] <> #0 Then
        Inc(Sec[2]);
      SecOk[2] := GetSectionEnd(Sec[2]);
      If section > 2 Then
        Begin
        Sec[3] := Sec[2];
        If Sec[3][0] <> #0 Then
          Inc(Sec[3]);
        SecOk[3] := GetSectionEnd(Sec[3]);
        End;
      End;
    If Not SecOk[1] Then
      FmtStart := Nil
    Else
      Begin
      If Not SecOk[section] Then
        section := 1
      Else If section = 2 Then
        Value := -Value;   { Remove sign }
      If section = 1 Then FmtStart := format Else
        Begin
        FmtStart := Sec[section - 1];
        Inc(FmtStart);
        End;
      FmtStop := Sec[section];
      End;
  End;

  { Find format section ranging from FmtStart to FmtStop. }

  Procedure GetFormatOptions;
  Var
    Fmt: PmseChar;
    SQ, DQ: Boolean;
    area: Integer;
  Begin
    SQ := False;
    DQ := False;
    Fmt := FmtStart;
    ExpFmt := 0;
    area := 1;
    thousand := False;
    Placehold[1] := 0;
    Placehold[2] := 0;
    Placehold[3] := 0;
    Placehold[4] := 0;
    While Fmt < FmtStop Do
      Begin
      Case Fmt[0] Of
        #34:
          Begin
          If Not SQ Then
            DQ := Not DQ;
          Inc(Fmt);
          End;
        #39:
          Begin
          If Not DQ Then
            SQ := Not SQ;
          Inc(Fmt);
          End;
      Else
        { This was 'if not SQ or DQ'. Looked wrong... }
        If Not (SQ Or DQ) Then
          Begin
          Case Fmt[0] Of
            '0':
              Begin
              Case area Of
                1:
                  area := 2;
                4:
                  Begin
                  area := 3;
                  Inc(Placehold[3], Placehold[4]);
                  Placehold[4] := 0;
                  End;
              End;
              Inc(Placehold[area]);
              Inc(Fmt);
              End;

            '#':
              Begin
              If area=3 Then
                area:=4;
              Inc(Placehold[area]);
              Inc(Fmt);
              End;
            '.':
              Begin
              If area<3 Then
                area:=3;
              Inc(Fmt);
              End;
            ',':
              Begin
              thousand := True;
              Inc(Fmt);
              End;
            'e', 'E':
              If ExpFmt = 0 Then
                Begin
                If (Fmt[0]='E') Then
                  ExpFmt:=1
                Else
                  ExpFmt := 3;
                Inc(Fmt);
                If (Fmt<FmtStop) Then
                  Begin
                  Case Fmt[0] Of
                    '+':
                      Begin
                      End;
                    '-':
                      Inc(ExpFmt);
                  Else
                    ExpFmt := 0;
                  End;
                  If ExpFmt <> 0 Then
                    Begin
                    Inc(Fmt);
                    ExpSize := 0;
                    While (Fmt<FmtStop) And
                          (ExpSize<4) And
                          (fmt^ >= '0') and (fmt^ <= '9') do
//                          (Fmt[0] In ['0'..'9']) Do
                      Begin
                      Inc(ExpSize);
                      Inc(Fmt);
                      End;
                    End;
                  End;
                End
              Else
                Inc(Fmt);
          Else { Case }
            Inc(Fmt);
          End; { Case }
          End { Begin }
        Else 
          Begin
          Inc(Fmt)
          End;
      End; { Case }
      End; { While .. Begin }
  End;

  Procedure FloatToStr;

  Var
    I, J, Exp, Width, Decimals, DecimalPoint, len: Integer;

  Begin
    If ExpFmt = 0 Then
      Begin
      { Fixpoint }
      Decimals:=Placehold[3]+Placehold[4];
      Width:=Placehold[1]+Placehold[2]+Decimals;
      If (Decimals=0) Then
        Str(Value:Width:0,Digits)
      Else
        Str(Value:Width+1:Decimals,Digits);
      len:=Length(Digits);
      { Find the decimal point }
      If (Decimals=0) Then
        DecimalPoint:=len+1
      Else
        DecimalPoint:=len-Decimals;
      { If value is very small, and no decimal places
        are desired, remove the leading 0.            }
      If (Abs(Value) < 1) And (Placehold[2] = 0) Then
        Begin
        If (Placehold[1]=0) Then
          Delete(Digits,DecimalPoint-1,1)
        Else
          Digits[DecimalPoint-1]:=' ';
        End;

      { Convert optional zeroes to spaces. }
      I:=len;
      J:=DecimalPoint+Placehold[3];
      While (I>J) And (Digits[I]='0') Do
        Begin
        Digits[I] := ' ';
        Dec(I);
        End;
      { If integer value and no obligatory decimal
        places, remove decimal point. }
      If (DecimalPoint < len) And (Digits[DecimalPoint + 1] = ' ') Then
          Digits[DecimalPoint] := ' ';
      { Convert spaces left from obligatory decimal point to zeroes. }
      I:=DecimalPoint-Placehold[2];
      While (I<DecimalPoint) And (Digits[I]=' ') Do
        Begin
        Digits[I] := '0';
        Inc(I);
        End;
      Exp := 0;
      End
    Else
      Begin
      { Scientific: exactly <Width> Digits With <Precision> Decimals
        And adjusted Exponent. }
      If Placehold[1]+Placehold[2]=0 Then
        Placehold[1]:=1;
      Decimals := Placehold[3] + Placehold[4];
      Width:=Placehold[1]+Placehold[2]+Decimals;
      Str(Value:Width+8,Digits);
      { Find and cut out exponent. Always the
        last 6 characters in the string.
        -> 0000E+0000                         }
      I:=Length(Digits)-5;
      Val(Copy(Digits,I+1,5),Exp,J);
      Exp:=Exp+1-(Placehold[1]+Placehold[2]);
      Delete(Digits, I, 6);
      { Str() always returns at least one digit after the decimal point.
        If we don't want it, we have to remove it. }
      If (Decimals=0) And (Placehold[1]+Placehold[2]<= 1) Then
        Begin
        If (Digits[4]>='5') Then
          Begin
          Inc(Digits[2]);
          If (Digits[2]>'9') Then
            Begin
            Digits[2] := '1';
            Inc(Exp);
            End;
          End;
        Delete(Digits, 3, 2);
        DecimalPoint := Length(Digits) + 1;
        End
      Else
        Begin
        { Move decimal point at the desired position }
        Delete(Digits, 3, 1);
        DecimalPoint:=2+Placehold[1]+Placehold[2];
        If (Decimals<>0) Then
          Insert('.',Digits,DecimalPoint);
        End;

      { Convert optional zeroes to spaces. }
      I := Length(Digits);
      J := DecimalPoint + Placehold[3];
      While (I > J) And (Digits[I] = '0') Do
        Begin
        Digits[I] := ' ';
        Dec(I);
        End;

      { If integer number and no obligatory decimal paces, remove decimal point }

      If (DecimalPoint<Length(Digits)) And
         (Digits[DecimalPoint+1]=' ') Then
          Digits[DecimalPoint]:=' ';
      If (Digits[1]=' ') Then
        Begin
        Delete(Digits, 1, 1);
        Dec(DecimalPoint);
        End;
      { Calculate exponent string }
      Str(Abs(Exp), Exponent);
      While Length(Exponent)<ExpSize Do
        Insert('0',Exponent,1);
      If Exp >= 0 Then
        Begin
        If (ExpFmt In [1,3]) Then
          Insert('+', Exponent, 1);
        End
      Else
        Insert('-',Exponent,1);
      If (ExpFmt<3) Then
        Insert('E',Exponent,1)
      Else
        Insert('e',Exponent,1);
      End;
    DigitExponent:=DecimalPoint-2;
    If (Digits[1]='-') Then
      Dec(DigitExponent);
    UnexpectedDigits:=DecimalPoint-1-(Placehold[1]+Placehold[2]);
  End;

  Function PutResult: LongInt;

  Var
    SQ, DQ: Boolean;
    Fmt, Buf: PmseChar;
    Dig, N: Integer;

  Begin
   with formatsettings do begin
    SQ := False;
    DQ := False;
    Fmt := FmtStart;
    Buf := Buffer;
    Dig := 1;
    While (Fmt<FmtStop) Do
      Begin
      //Write(Fmt[0]);
      Case Fmt[0] Of
        #34:
          Begin
          If Not SQ Then
            DQ := Not DQ;
          Inc(Fmt);
          End;
        #39:
          Begin
          If Not DQ Then
            SQ := Not SQ;
          Inc(Fmt);
          End;
      Else
        If Not (SQ Or DQ) Then
          Begin
          Case Fmt[0] Of
            '0', '#', '.':
              Begin
              If (Dig=1) And (UnexpectedDigits>0) Then
                Begin
                { Everything unexpected is written before the first digit }
                For N := 1 To UnexpectedDigits Do
                  Begin
                  Buf[0] := widechar(Digits[N]);
                  Inc(Buf);
                  If thousand And (Digits[N]<>'-') Then
                    Begin
                    If (DigitExponent Mod 3 = 0) And (DigitExponent>0) Then
                      Begin
//                      Buf[0] := widechar(ThousandSeparator);
                      Buf[0] := ThousandSeparator;
                      Inc(Buf);
                      End;
                    Dec(DigitExponent);
                    End;
                  End;
                Inc(Dig, UnexpectedDigits);
                End;
              If (Digits[Dig]<>' ') Then
                Begin
                If (Digits[Dig]='.') Then
                  Buf[0] := DecimalSeparator
//                  Buf[0] := widechar(DecimalSeparator)
                Else
                  Buf[0] := widechar(Digits[Dig]);
                Inc(Buf);
                If thousand And (DigitExponent Mod 3 = 0) And (DigitExponent > 0) Then
                  Begin
//                  Buf[0] := widechar(ThousandSeparator);
                  Buf[0] := ThousandSeparator;
                  Inc(Buf);
                  End;
                End;
              Inc(Dig);
              Dec(DigitExponent);
              Inc(Fmt);
              End;
            'e', 'E':
              Begin
              If ExpFmt <> 0 Then
                Begin
                Inc(Fmt);
                If Fmt < FmtStop Then
                  Begin
//                  If Fmt[0] In ['+', '-'] Then
                  If (Fmt[0] = '+') or (fmt[0] = '-') Then
                    Begin
                    Inc(Fmt, ExpSize);
                    For N:=1 To Length(Exponent) Do
                      Buf[N-1] := widechar(Exponent[N]);
                    Inc(Buf,Length(Exponent));
                    ExpFmt:=0;
                    End;
                  Inc(Fmt);
                  End;
                End
              Else
                Begin
                { No legal exponential format.
                  Simply write the 'E' to the result. }
                Buf[0] := Fmt[0];
                Inc(Buf);
                Inc(Fmt);
                End;
              End;
          Else { Case }
            { Usual character }
            If (Fmt[0]<>',') Then
              Begin
              Buf[0] := Fmt[0];
              Inc(Buf);
              End;
            Inc(Fmt);
          End; { Case }
          End
        Else { IF }
          Begin
          { Character inside single or double quotes }
          Buf[0] := Fmt[0];
          Inc(Buf);
          Inc(Fmt);
          End;
      End; { Case }
    End; { While .. Begin }
//    Result:=PtrInt(Buf)-PtrInt(Buffer);
    result:= buf - buffer;
   end;
  End;

var
 int1: integer;
begin
 if value > 0 then begin
  getsectionrange(1);
 end
 else begin
  if (value < 0) then begin
   getsectionrange(2)
  end
  else begin
   getsectionrange(3);
  end;
 end;
 if fmtstart = nil then begin
 {$ifdef FPC}
  result:= floattotext(pchar(buffer),value,ffgeneral,15,4);
 {$else}
  result:= floattotext(pchar(buffer),value,fvextended,ffgeneral,15,4);
 {$endif}
 end
 else begin
  getformatoptions;
  if (expfmt = 0) and (abs(value) >= 1e18) then begin
 {$ifdef FPC}
   result:= floattotext(pchar(buffer),value,ffgeneral,15,4);
 {$else}
   result:= floattotext(pchar(buffer),value,fvextended,ffgeneral,15,4);
 {$endif}
  end
  else begin
   floattostr;
   result:= putresult;
   exit;
  end;
 end;
 for int1:= result - 1 downto 0 do begin
  pmsecharaty(buffer)^[int1]:= widechar(pcharaty(buffer)^[int1]);
             //convert to msestring
 end;
end;
*)

function cstringtostringvar(var inp: pchar): string;

const
 quotechar = '"';
 escapechar = '\';

var
 po1,po2: pchar;
 int1,int2: integer;
 ch1: char;

begin
 result:= '';
 if inp <> nil then begin
  po1:= inp;
  while true do begin
   while (po1^ = ' ') do begin //first quote
    inc(po1);
   end;
   if (po1^ <> quotechar) then begin
    break;  //end or no start quote
   end;
   inc(po1);
   po2:= po1;  //text
   while true do begin
    while (po1^ <> quotechar) and (po1^ <> escapechar) do begin
     if (po1^ = #0) then begin
      result:= '';
      inp:= nil;
      exit; //error: no end quote
     end;
     inc(po1);
    end;
    int1:= po1-po2; //text length
    int2:= length(result)+1;
    setlength(result,length(result) + int1);
    move(po2^,result[int2],int1); //add text
    if po1^ = escapechar then begin
     inc(po1);
     case po1^ of
      'a': ch1:= #$07;
      'b': ch1:= #$08;
      'f': ch1:= #$0c;
      'n': ch1:= #$0a;
      'r': ch1:= #$0d;
      't': ch1:= #$09;
      'v': ch1:= #$0b;
      '\': ch1:= '\';
      '''': ch1:= '''';
      '"': ch1:= '"';
      '?': ch1:= '?';
      '0'..'7': begin
       po2:= po1;
       for int1:= 0 to 2 do begin
        if (po1^ < '0') or (po1^ > '7') then begin
         break;
        end;
        inc(po1);
       end;
       ch1:= char(strtooct(psubstr(po2,po1)));
       dec(po1);
      end;
      'x','X': begin
       inc(po1);
       po2:= po1;
       while (po1^ >= '0') and (po1^ <= '9') or
             (po1^ >= 'a') and (po1^ <= 'f') or
             (po1^ >= 'A') and (po1^ <= 'F') do begin
        inc(po1);
       end;
       ch1:= char(strtohex(psubstr(po2,po1)));
       dec(po1);
      end;
      else begin
       ch1:= ' ';
      end;
     end;
     result:= result + ch1;
     inc(po1);
    end
    else begin
     inc(po1);
     break;
    end;
    po2:= po1; //past quote
   end;
  end;
  inp:= po1;
 end;
end;

function cstringtostring(inp: pchar): string;
begin
 result:= cstringtostringvar(inp);
end;

function cstringtostring(const inp: string): string;
var
 po1: pchar;
begin
 po1:= pchar(inp);
 result:= cstringtostringvar(po1);
end;

function stringtocstring(const inp: pmsechar;
                               const count: integer): string; overload;
var
 po1: pmsechar;
 innum: boolean;
 int1: integer;
begin
 result:= '"';
 po1:= inp;
 innum:= false;
 for int1:= count - 1 downto 0 do begin
//  if (po1^ < #$20) or (po1^ > #$ff) or (po1^ = #$7f) then begin
  if (po1^ < #$20) or (po1^ >= #$7f) then begin
   innum:= true;
   if po1^ < #$100 then begin
    result:= result + '\x'+hextostr(ord(po1^),2);
   end
   else begin
    result:= result + '\x'+hextostr(ord(po1^),4);
   end;
  end
  else begin
   if po1^ = '"' then begin
    result:= result + '\"';
    innum:= false;
   end
   else begin
    if innum then begin
     result:= result + '" "'+char(po1^);
     innum:= false;
    end
    else begin
     result:= result + char(po1^);
    end;
   end;
  end;
  inc(po1);
 end;
 result:= result + '"';
end;

function stringtocstring(const inp: msestring): string;
begin
 result:= stringtocstring(pmsechar(pointer(inp)),length(inp));
end;

function stringtopascalstring(const value: msestring): string;
var
 int1,int2: integer;
 po1: pchar;
 str1: string;
 asciimode: boolean;
begin
 if length(value) = 0 then begin
  result:= '''''';
 end
 else begin
  asciimode:= false;
  setlength(result,2+6*length(value)); // maxlength for single char: '#65535' = 2 + 6
  po1:= pchar(pointer(result));
//  int2:= 1;
  for int1:= 1 to length(value) do begin
   int2:= ord(value[int1]);
   if (int2 >= 32) and (int2 < 127) then begin
    if not asciimode then begin
     asciimode:= true;
     po1^:= '''';
     inc(po1);
    end;
    if char(int2) = '''' then begin
     po1^:= ''''; //double quote
     inc(po1);
    end;
    po1^:= char(int2);
    inc(po1);
   end
   else begin
    if asciimode then begin
     asciimode:= false;
     po1^:= '''';
     inc(po1);
    end;
    po1^:= '#';
    inc(po1);
    str1:= inttostr(int2);
    move(pchar(pointer(str1))^,po1^,length(str1));
    inc(po1,length(str1));
   end;
  end;
  if asciimode then begin
   po1^:= '''';
   inc(po1);
  end;
  setlength(result,po1-pchar(pointer(result)));
 end;
end;

function trypascalstringtostring(const value: string;
                                              out res: msestring ): boolean;

var
 po1: pmsechar;
 po2,po3: pmsechar;
 int1: integer;
 mstr1,source1: msestring;
begin
 result:= false;
 source1:= msestring(value);    //assume locale encoding
 setlength(res,length(source1)); //max length
 po1:= pmsechar(pointer(res)); 
 po2:= pmsechar(source1);
 while po2^ <> #0 do begin
  case po2^ of
   '#': begin
    inc(po2);
    if po2^ = '$' then begin
     inc(po2);
     po3:= po2;
     while po2^ in ['0'..'9','a'..'f','A'..'F'] do begin
      inc(po2);
     end;
     setstring(mstr1,po3,po2-po3);
     po1^:= msechar(strtohex(mstr1));
    end
    else begin
     po3:= po2;
     while (po2^ >= '0') and (po2^ <= '9') do begin
      inc(po2);
     end;
     setstring(mstr1,po3,po2-po3);
     po1^:= msechar(strtoint(mstr1));
    end;
    inc(po1);
   end;
   '''': begin               
    inc(po2);                  //'.....
    po3:= po2;
    while (po2^ <> '''') and (po2^ <> #0) do begin
     inc(po2)
    end;
    if po2^ <> #0 then begin   
     for int1:= 0 to po2 - po3 - 1 do begin //'abcd'......
      po1^:= msechar((po3+int1)^);
      inc(po1);
     end;
     inc(po2);
     if po2^ = '''' then begin //'abcd'?
      po1^:= '''';             //'abcd''
      inc(po1);                
     end;
    end
    else begin
     res:= '';
     exit;
    end;
   end;
   ' ',c_tab: begin
    inc(po2)
   end
   else begin
    res:= '';
    exit;
   end;
  end;
 end;
 setlength(res,po1-pmsechar(pointer(res)));
 result:= true;
end;

function pascalstringtostring(const value: string): msestring;
begin
 if not trypascalstringtostring(value,result) then begin
  raise exception.Create('Invalid pascalstring: "'+value+'".');
 end;
end;

function getpascalstring(var value: pchar): msestring;

var
 po2,po3: pchar;
// int1: integer;
 str1: string;
 charcount: integer;

 procedure addstring(const astr: msestring);
 var
  int1,int2: integer;
 begin
  int1:= length(astr);
  int2:= charcount;
  charcount:= charcount+int1;
  if length(result) < charcount then begin
   setlength(result,2*charcount+32);
  end;
  move(pointer(astr)^,(pmsechar(pointer(result))+int2)^,int1*sizeof(msechar));
 end;
 
begin
 result:= '';
 charcount:= 0;
 po2:= value;
 while po2^ <> #0 do begin
  case po2^ of
   '#': begin
    inc(po2);
    if po2^ = '$' then begin
     inc(po2);
     po3:= po2;
     while po2^ in ['0'..'9','a'..'f','A'..'F'] do begin
      inc(po2);
     end;
     setstring(str1,po3,po2-po3);
     addstring(msechar(strtohex(str1)));
    end
    else begin
     po3:= po2;
     while (po2^ >= '0') and (po2^ <= '9') do begin
      inc(po2);
     end;
     setstring(str1,po3,po2-po3);
     addstring(msechar(strtoint(str1)));
    end;
   end;
   '''': begin               
    inc(po2);                  //'.....
    po3:= po2;
    while (po2^ <> '''') and (po2^ <> #0) do begin
     inc(po2)
    end;
    if po2^ <> #0 then begin   
     setstring(str1,po3,po2-po3);
     addstring(msestring(str1));
     inc(po2);
     if po2^ = '''' then begin //'abcd'?
      addstring('''');             //'abcd''
     end;
    end
    else begin
     result:= '';
     exit;
    end;
   end;
   ' ',c_tab: begin
    inc(po2)
   end
   else begin
    break;
   end;
  end;
 end;
 setlength(result,charcount);
 value:= po2;
end;


function encodebase64(const abinary: pbyte; acount: integer;
                const maxlinelength: integer = defaultbase64linelength): string;
   //todo: optimize
var
 int1: integer;
 ps,pe: pbyte;
 pd,pline: pchar;
 tail,linestep: integer;
 by1: byte;
begin
 result:= '';
 if acount > 0 then begin
  int1:= ((acount+2) div 3)*4;
  linestep:= maxlinelength and $fffffffc; //do not cut 4 char boundary
  if maxlinelength > 0 then begin
   if linestep = 0 then begin
    linestep:= 4;
   end;
   int1:= int1 + 2*((int1+linestep-1)div linestep - 1); //return-linefeed
  end;
  setlength(result,int1);
  ps:= abinary;
  int1:= acount;
  tail:= int1 mod 3;
  pchar(pe):= pchar(ps)+int1-tail;
  pd:= pointer(result);
  if maxlinelength > 0 then begin
   pline:=  pd + linestep;
  end
  else begin
   pline:= pointer(not ptruint(0));
  end;
  while pchar(ps) < pchar(pe) do begin
   if pd >= pline then begin
    pd^:= c_return;
    inc(pd);
    pd^:= c_linefeed;
    inc(pd);
    pline:= pd+linestep;
   end;
   by1:= ps^;                                        //s0
   pd^:= base64encoding[by1 shr 2];                  //d0
   inc(ps);                                          //s1
   inc(pd);                                          //d1
   pd^:= base64encoding[((by1 shl 4) or (ps^ shr 4)) and base64mask];
   by1:= ps^ shl 2;
   inc(ps);                                          //s2
   inc(pd);                                          //d2
   pd^:= base64encoding[(by1 or (ps^ shr 6)) and base64mask];
   inc(pd);                                          //d3
   pd^:= base64encoding[ps^ and base64mask];
   inc(ps);
   inc(pd);                                          //d0
  end;
  if tail > 0 then begin
   if pd >= pline then begin
    pd^:= c_return;
    inc(pd);
    pd^:= c_linefeed;
    inc(pd);
   end;
   by1:= ps^;                                        //s0
   pd^:= base64encoding[by1 shr 2];                  //d0
   inc(pd);                                          //d1
   pd^:= base64encoding[(by1 shl 4) and base64mask];
   if tail > 1 then begin
    inc(ps);                                         //s1
    pd^:= base64encoding[((by1 shl 4) or (ps^ shr 4)) and base64mask];
    inc(pd);                                         //d2 
    pd^:= base64encoding[(ps^ shl 2) and base64mask];
   end
   else begin
    inc(pd);                                         //d2
    pd^:= '=';
   end;
   inc(pd);                                          //d3
   pd^:= '=';
  end;
 end;
end;

function encodebase64(const abinary: string;
              const maxlinelength: integer = defaultbase64linelength): string;
begin
 result:= encodebase64(pointer(abinary),length(abinary),maxlinelength);
end;

function decodebase64(const atext: string): string;
   //todo: optimize
label
 endlab;
var
 ps,pend: pchar;
 pd: pbyte;
 by1: byte;
begin
 setlength(result,length(atext)); //>max
 if atext <> '' then begin
  ps:= pointer(atext);
  pd:= pointer(result);
  pend:= ps+length(atext);
  while ps < pend do begin
   by1:= base64decoding[ord(ps^)];       //s0
   while shortint(by1) < 0 do begin
    inc(ps);
    if (ps >= pend) or (char(by1) = '=') then begin
     goto endlab;
    end;
    by1:= base64decoding[ord(ps^)];
   end;
   pd^:= by1 shl 2;                     //d0
   inc(ps);
   by1:= base64decoding[ord(ps^)];      //s1
   while shortint(by1) < 0 do begin
    inc(ps);
    if (ps >= pend) or (char(by1) = '=') then begin
     goto endlab;
    end;
    by1:= base64decoding[ord(ps^)];
   end;
   pd^:= pd^ or (by1 shr 4);
   inc(pd);                             //d1
   pd^:= by1 shl 4;
   inc(ps);
   by1:= base64decoding[ord(ps^)];      //s2
   while shortint(by1) < 0 do begin
    inc(ps);
    if (ps >= pend) or (char(by1) = '=') then begin
     goto endlab;
    end;
    by1:= base64decoding[ord(ps^)];
   end;
   pd^:= pd^ or by1 shr 2;
   inc(pd);                             //d2
   pd^:= by1 shl 6;
   inc(ps);
   by1:= base64decoding[ord(ps^)];      //s3
   while shortint(by1) < 0 do begin
    inc(ps);
    if (ps >= pend) or (char(by1) = '=') then begin
     goto endlab;
    end;
    by1:= base64decoding[ord(ps^)];
   end;
   pd^:= pd^ or by1;
   inc(pd);
   inc(ps);                            //s0
  end;
endlab:
  setlength(result,pchar(pointer(pd))-pchar(pointer(result)));
 end;
end;

procedure checkdateconvert(const convert: dateconvertty; var value: tdatetime);
begin
 if value <> emptydatetime then begin
  if convert = dc_toutc then begin
   value:= localtimetoutc(value);
  end
  else begin
   if convert = dc_tolocal then begin
    value:= utctolocaltime(value);
   end;
  end;
 end;
end;

procedure checkdatereconvert(const convert: dateconvertty; var value: tdatetime);
begin
 if value <> emptydatetime then begin
  if convert = dc_tolocal then begin
   value:= localtimetoutc(value);
  end
  else begin
   if convert = dc_toutc then begin
    value:= utctolocaltime(value);
   end;
  end;
 end;
end;
(*
function stringtotime(const text: msestring; out value: tdatetime;
                         const convert: dateconvertty = dc_none): boolean;
var
 mstr1: msestring;
 timesep: msechar;
begin
 result:= true;
 if text = ' ' then begin
  if convert = dc_toutc then begin
   value:= frac(nowutc);
  end
  else begin
   value:= frac(nowlocal);
  end;
 end
 else begin
  if text = '' then begin
   value:= emptydatetime;
  end
  else begin
   timesep:= defaultformatsettingsmse.timeseparator;
   if (countchars(text,timesep) = 0) and
      (countchars(text,defaultformatsettingsmse.timeseparator) = 0) then begin
    case length(text) of
     3,4: begin
      mstr1:= copy(text,1,2)+timesep+copy(text,3,2);
     end;
     5,6: begin
      mstr1:= copy(text,1,2)+timesep+copy(text,3,2)+timesep+
              copy(text,5,2);
     end;
     else begin
      mstr1:= text;
     end;
    end;
    result:= sysutils.trystrtotime(mstr1,value);
   end
   else begin
    result:= sysutils.trystrtotime(text,value);
   end;
   checkdateconvert(convert,value);
  end;
 end;
end;
*)
function timetostring(const avalue: tdatetime; const format: msestring = 't'): msestring;
begin
 if avalue = emptydatetime then begin
  result:= '';
 end
 else begin
  if format = '' then begin
   result:= formatdatetimemse('t',avalue,defaultformatsettingsmse);
  end
  else begin
   result:= formatdatetimemse(format,avalue,defaultformatsettingsmse);
  end;
 end;
end;

function datetimetostring(const avalue: tdatetime; const format: msestring = 'c'): msestring;
begin
 if avalue = emptydatetime then begin
  result:= '';
 end
 else begin
  if format = '' then begin
   result:= formatdatetimemse('c',avalue,defaultformatsettingsmse);
  end
  else begin
   result:= formatdatetimemse(format,avalue,defaultformatsettingsmse);
  end;
 end;
end;

function datetostring(const avalue: tdatetime; 
                                  const format: msestring = 'c'): msestring;
begin
 if avalue = emptydatetime then begin
  result:= '';
 end
 else begin
  result:= datetimetostring(trunc(avalue),format);
 end;
end;

procedure formaterror(const value: string);
begin
 raise exception.Create('Invalid value '''+value+'''.');
end;

procedure formaterror(const value: msestring);
begin
 formaterror(ansistring(value));
end;

type
 datetimeformattokenty = (
  dtft_default,        // c        shortdateformat + ' ' + longtimeformat
  dtft_day,            // d        day of month
  dtft_dayzero,        // dd       day of month (leading zero)
  dtft_dayabbr,        // ddd      day of week (abbreviation)
  dtft_dayfull,        // dddd     day of week (full)
  dtft_shortdate,      // ddddd    shortdateformat
  dtft_longdate,       // dddddd   longdateformat
  dtft_month,          // m        month
  dtft_monthzero,      // mm       month (leading zero)
  dtft_monthabbr,      // mmm      month (abbreviation)
  dtft_monthfull,      // mmmm     month (full)
  dtft_year,           // y        year (2 digits)
  dtft_yearzero,       // yy       year (two digits)
  dtft_yearcentury,    // yyyy     year (with century)
  dtft_hour,           // h        hour
  dtft_hourzero,       // hh       hour (leading zero)
  dtft_minute,         // n        minute
  dtft_minutezero,     // nn       minute (leading zero)
  dtft_second,         // s        second
  dtft_secondzero,     // ss       second (leading zero)
  dtft_shorttime,      // t        shorttimeformat
  dtft_longtime,       // tt       longtimeformat
  dtft_ampm,           // ampm     
  dtft_amspm,          // am/pm    use 12 hour clock and
                       //          display am and pm accordingly
  dtft_ap,             // a/p      use 12 hour clock and display 
                       //          a and p accordingly
  dtft_datesep,        // /        insert date seperator
  dtft_timesep,        // :        insert time seperator
  dtft_millisec        // z        milliseconds
 );

dttokengroupty = (dttg_none,dttg_millisec,dttg_sec,
                  dttg_min,dttg_hour,
                  dttg_day,dttg_mon,dttg_year);
dttokeninfoty = record
 token: datetimeformattokenty;
 group: dttokengroupty;
 chars: msestring;
end;

const
 tokeninfos: array[0..ord(high(datetimeformattokenty))] of dttokeninfoty =
  (                    //longest first
   (token: dtft_default;     group: dttg_none;     chars: 'C'),        //0
   (token: dtft_longdate;    group: dttg_none;     chars: 'DDDDDD'),   //1
   (token: dtft_shortdate;   group: dttg_none;     chars: 'DDDDD'),    //2
   (token: dtft_longtime;    group: dttg_none;     chars: 'TT'),       //3
   (token: dtft_shorttime;   group: dttg_none;     chars: 'T'),        //4
   (token: dtft_datesep;     group: dttg_none;     chars: '/'),        //5
   (token: dtft_timesep;     group: dttg_none;     chars: ':'),        //6

   (token: dtft_amspm;        group: dttg_none;     chars: 'AM/PM'),    //7
   (token: dtft_ampm;        group: dttg_none;     chars: 'AMPM'),     
   (token: dtft_dayfull;     group: dttg_day;      chars: 'DDDD'),     
   (token: dtft_monthfull;   group: dttg_mon;      chars: 'MMMM'),
   (token: dtft_yearcentury; group: dttg_year;     chars: 'YYYY'),
   (token: dtft_ap;          group: dttg_none;     chars: 'A/P'),      
   (token: dtft_dayabbr;     group: dttg_day;      chars: 'DDD'),
   (token: dtft_monthabbr;   group: dttg_mon;      chars: 'MMM'),
   (token: dtft_dayzero;     group: dttg_day;      chars: 'DD'),
   (token: dtft_monthzero;   group: dttg_mon;      chars: 'MM'),
   (token: dtft_yearzero;    group: dttg_year;     chars: 'YY'),
   (token: dtft_hourzero;    group: dttg_hour;     chars: 'HH'),
   (token: dtft_minutezero;  group: dttg_min;      chars: 'NN'),
   (token: dtft_secondzero;  group: dttg_sec;      chars: 'SS'),
   (token: dtft_day;         group: dttg_day;      chars: 'D'),
   (token: dtft_month;       group: dttg_mon;      chars: 'M'),
   (token: dtft_year;        group: dttg_year;     chars: 'Y'),
   (token: dtft_hour;        group: dttg_hour;     chars: 'H'),
   (token: dtft_minute;      group: dttg_min;      chars: 'N'),
   (token: dtft_second;      group: dttg_sec;      chars: 'S'),
   (token: dtft_millisec;    group: dttg_millisec; chars: 'Z')
  );

 startscan = 7;
 
//todo: use format cache

type
 scaninfoty = record
  index: integer;
  group: dttokengroupty;
 end;

function comparescan(const l,r): integer;
begin
 result:= scaninfoty(l).index - scaninfoty(r).index;
end;

function trystringtodatetime(const text: msestring;
                aformat: msestring; out value: tdatetime;
                               const convert: dateconvertty = dc_none): boolean;
 procedure removequotes(var astring: msestring);
 var
  po1: pmsechar;
 begin
  uniquestring(astring);
  po1:= pmsechar(astring);
  while po1^ <> #0 do begin
   case po1^ of 
    '"': begin
     repeat
      po1^:= ' ';
      inc(po1)
     until  (po1^ = '"') or (po1^ = #0 );
     if po1^ <> #0 then begin
      po1^:= ' ';
     end;
    end;
   end;
   case po1^ of 
    '''': begin
     repeat
      po1^:= ' ';
      inc(po1)
     until  (po1^ = '''') or (po1^ = #0 );
     if po1^ <> #0 then begin
      po1^:= ' ';
     end;
    end;
    else begin
     if (po1^ >= 'a') and (po1^ <= 'z') then begin
      dec(po1^,ord('a')-ord('A'));
     end;
     inc(po1);
    end;
   end;
  end;
 end; //removequotes
 
 procedure expand(var astring: msestring; const ainfo: dttokeninfoty;
                      const substitute: msestring);
 var
  mstr1,mstr2: msestring;
  int1,int2: integer;
 begin
  mstr1:= astring;
  mstr2:= substitute;
  removequotes(mstr2);
  int2:= length(ainfo.chars);
  int1:= 1;
  while true do begin
   int1:= mseposex(ainfo.chars,mstr1,int1); //no recursion
   if int1 = 0 then begin
    break;
   end;
   mstr1:= copy(mstr1,1,int1-1)+mstr2+copy(mstr1,int1+int2,bigint);
   int1:= int1 + int2;
  end;
  astring:= mstr1;
 end; //expand
 
var
 scanar: array of scaninfoty;
 scanindex: integer;
 
 procedure scan(var astring: msestring; const ainfo: dttokeninfoty);
 var
  po1: pmsecharaty;
  int1,int2,int3: integer;
 begin
  int1:= 1;
  while true do begin
   int1:= mseposex(ainfo.chars,astring,int1); //no recursion
   if int1 = 0 then begin
    break;
   end;
   with scanar[scanindex] do begin
    index:= int1;
    group:= ainfo.group;
   end;
   inc(scanindex);
   po1:= @astring[int1];
   int3:= length(ainfo.chars);
   for int2:= 0 to int3-1 do begin
    po1^[int2]:= ' ';
   end;
   int1:= int1 + int3;
  end;
 end; //scan

var
 dateorder: array[0..2] of dttokengroupty;
                 { = (dttg_none,dttg_none,dttg_none); does not work in delphi}

 function finddateorder(const agroup: dttokengroupty): integer;
 var
  int1: integer;
 begin
  result:= -1;
  for int1:= 0 to high(dateorder) do begin
   if agroup = dateorder[int1] then begin
    result:= int1;
    break;
   end;
  end;
 end;
  
var
 mstr1: msestring;
 int1,int2,int3,int4,int5: integer;
 dt1,dt2: tdatetime;
 grouporder: array of dttokengroupty;
 groupused: array[dttokengroupty] of boolean;
 ar1: msestringarty;
 datear,timear: integerarty;
 po1,po2: pmsechar;
 tisep: msechar;
 year,month,defmonth,day,hour,minute,second,millisecond: word;
 ispm,hasmonthname,hasdateformat,hastimeformat: boolean;
 refdate: tdatetime;
 defaultdateorder: array[0..2] of dttokengroupty;
                  { = (dttg_year,dttg_mon,dttg_day);}

begin
 checkformatmacros(aformat);
 result:= false;
 if text = '' then begin
  value:= emptydatetime;
  result:= true;
  exit;
 end
 else begin
  for int1:= 0 to high(dateorder) do begin
   dateorder[int1]:= dttg_none; //delphi compatibility
  end;
  defaultdateorder[0]:= dttg_year;
  defaultdateorder[1]:= dttg_mon;
  defaultdateorder[2]:= dttg_day;

  if convert = dc_toutc then begin
   refdate:= nowutc;
  end
  else begin
   refdate:= nowlocal;
  end;
  if aformat = '' then begin
   mstr1:= 'c';
  end
  else begin
   mstr1:= aformat;
  end;
  removequotes(mstr1);
  expand(mstr1,tokeninfos[0],defaultformatsettingsmse.shortdateformat + ' ' + 
                             defaultformatsettingsmse.longtimeformat); //c
  expand(mstr1,tokeninfos[1],defaultformatsettingsmse.longdateformat); //dddddd
  expand(mstr1,tokeninfos[2],defaultformatsettingsmse.shortdateformat);//ddddd
  expand(mstr1,tokeninfos[3],defaultformatsettingsmse.longtimeformat); //tt
  expand(mstr1,tokeninfos[4],defaultformatsettingsmse.shorttimeformat);//t
  allocuninitedarray(length(mstr1),sizeof(scaninfoty{scanar[0]}),scanar); //max
                                           //fpc 3.0 warning
  scanindex:= 0;
  for int1:= startscan to high(tokeninfos) do begin
   scan(mstr1,tokeninfos[int1]);
  end;
  setlength(scanar,scanindex);
  sortarray(scanar,sizeof(scanar[0]),@comparescan);
  fillchar(groupused,sizeof(groupused),0);
  allocuninitedarray(length(scanar),sizeof(scanar[0]),grouporder); //max
  int2:= 0;
  for int1:= 0 to high(scanar) do begin
   with scanar[int1] do begin
    if not groupused[group] then begin
     groupused[group]:= true;
     grouporder[int2]:= group;
     inc(int2);
    end;
   end;
  end;
  setlength(grouporder,int2);
  int2:= 0;
  hastimeformat:= false;
  for int1:= 0 to high(grouporder) do begin
   if grouporder[int1] in [dttg_hour,dttg_min,dttg_sec,dttg_millisec] then begin
    hastimeformat:= true;
   end;
  end;
  hasdateformat:= false;
  for int1:= 0 to high(grouporder) do begin
   if grouporder[int1] in [dttg_year,dttg_mon,dttg_day] then begin
    hasdateformat:= true;
    dateorder[int2]:= grouporder[int1];
    inc(int2);
    if int2 > high(dateorder) then begin
     break;
    end;
   end;
  end;
  for int1:= 0 to high(dateorder)do begin
   if dateorder[int1] = dttg_none then begin
    break;
   end;
   for int2:= high(defaultdateorder) downto 0 do begin
    if defaultdateorder[int2] = dateorder[int1] then begin
     defaultdateorder[int2]:= dttg_none;
     break;
    end;
   end;
  end;
  for int1:= high(dateorder) downto 0 do begin
   if dateorder[int1] <> dttg_none then begin
    break;
   end;
   for int2:= high(defaultdateorder) downto 0 do begin
    if defaultdateorder[int2] <> dttg_none then begin
     dateorder[int1]:= defaultdateorder[int2];
     defaultdateorder[int2]:= dttg_none;
     break;
    end;
   end;
  end;
  
  int2:= length(text);
  if (int2 > 2) and isnumber(text) then begin
   mstr1:= '';
   int1:= 1;
   while int1 <= int2 do begin
    mstr1:= mstr1+copy(text,int1,2)+' ';
    int1:= int1 + 2;
   end;
  end
  else begin
   mstr1:= struppercase(text);
  end;
  setlength(ar1,length(mstr1)); //max
  int2:= 0;
  po1:= pmsechar(mstr1);
  tisep:= defaultformatsettingsmse.timeseparator;
  while po1^ <> #0 do begin        //split numerals
   case po1^ of
    '0'..'9': begin
     po2:= po1;
     while (po1^ >= '0') and (po1^ <= '9') do begin
      inc(po1);
     end;
     int3:= po1-po2;
     setlength(ar1[int2],int3);
     move(po2^,pointer(ar1[int2])^,int3*sizeof(msechar));
     inc(int2);
     dec(po1);
    end;
    'A','P': begin
     setlength(ar1[int2],1);
     ar1[int2]:= po1^;
     inc(int2);
     inc(po1);
     if po1^ <> 'M' then begin
      dec(po1)
     end;
    end;
    else begin
     if po1^ = tisep then begin
      setlength(ar1[int2],1);
      ar1[int2]:= ':';
      inc(int2);
     end;
    end;
   end;
   inc(po1);
  end;
  setlength(ar1,int2);
  
  month:= 0;                       //check month names
  hasmonthname:= false;
  for int1:= 1 to 12 do begin
   if pos(struppercase(defaultformatsettingsmse.longmonthnames[int1]),
                                                        mstr1) <> 0 then begin
    month:= int1;
    hasmonthname:= true;
    break;
   end;
  end;
  if month = 0 then begin
   for int1:= 1 to 12 do begin
    if pos(struppercase(defaultformatsettingsmse.shortmonthnames[int1]),
                                                        mstr1) <> 0 then begin
     month:= int1;
     hasmonthname:= true;
     break;
    end;
   end;
  end;

  ispm:= false;                  //split date/time formats
  setlength(datear,length(ar1)); //max
  setlength(timear,length(ar1)); //max
  int2:= 0;
  int3:= 0;
  for int1:= 0 to high(ar1) do begin
   case ar1[int1][1] of
    'P': begin
     ispm:= true;
    end;
    '0'..'9': begin
     if (int1 > 0) and (ar1[int1-1][1] = ':') or 
        (int1 < high(ar1)) and (ar1[int1+1][1] = ':') then begin
      timear[int3]:= int1;
      inc(int3);
     end
     else begin
      datear[int2]:= int1;
      inc(int2);
     end;
    end;
   end;
  end;

  setlength(datear,int2);
  setlength(timear,int3);
  decodedate(refdate,year,defmonth,day);
//   decodetime(refdate,hour,minute,second,millisecond);
  if (high(timear) < 0) and not hasdateformat then begin
   timear:= datear;        //use entries for time
   datear:= nil;
  end;
  case high(datear) of
   -1: begin
   end;
   0: begin
    day:= strtoint(ar1[datear[0]]);
   end;
   1: begin
    if month = 0 then begin //no month name found
     if finddateorder(dttg_mon) > finddateorder(dttg_day) then begin
      day:= strtoint(ar1[datear[0]]);
      month:= strtoint(ar1[datear[1]]);
     end
     else begin
      day:= strtoint(ar1[datear[1]]);
      month:= strtoint(ar1[datear[0]]);
     end;
    end
    else begin
     if finddateorder(dttg_year) > finddateorder(dttg_day) then begin
      day:= strtoint(ar1[datear[0]]);
      year:= strtoint(ar1[datear[1]]);
     end
     else begin
      day:= strtoint(ar1[datear[1]]);
      year:= strtoint(ar1[datear[0]]);
     end;
    end;
   end;
   else begin //>= 2
    for int1:= 0 to 2 do begin
     mstr1:= ar1[datear[int1]];
     int2:= strtoint(mstr1);
     case dateorder[int1] of
      dttg_year: begin
       if length(mstr1) <= 2 then begin
        int3:= defaultformatsettingsmse.twodigityearcenturywindow;
        int4:= year-int3;    //window start
        int5:= int4 div 100; //century
        if (int3 <> 0) and ((int4 mod 100) > int2) then begin
         inc(int5);
        end;
        int2:= int2 + int5 * 100;
       end;
       year:= int2;
      end;
      dttg_mon: begin
       month:= int2;
      end;
      dttg_day: begin
       day:= int2;
      end;
     end;
    end;
   end;
  end;
  if month = 0 then begin 
   month:= defmonth;         //use current month
  end;
  int1:= high(timear);
  if int1 >= 0 then begin
   if int1 >= 3 then begin
    millisecond:= strtoint(ar1[timear[3]]);
   end
   else begin
    millisecond:= 0;
   end;
   if int1 >= 2 then begin
    second:= strtoint(ar1[timear[2]]);
   end
   else begin
    second:= 0;
   end;
   if int1 >= 1 then begin
    minute:= strtoint(ar1[timear[1]]);
   end
   else begin
    minute:= 0;
   end;
   hour:= strtoint(ar1[timear[0]]);
   if ispm and (hour < 12) then begin
    hour:= hour + 12;
   end;
   if high(datear) >= 0 then begin
    if not tryencodedate(year,month,day,dt1) then begin
     exit;
    end;
    if not tryencodetime(hour,minute,second,millisecond,dt2) then begin
     exit;
    end;
    value:= composedatetime(dt1,dt2);
    result:= true;
   end
   else begin
    if not tryencodetime(hour,minute,second,millisecond,value) then begin
     exit;
    end;
    result:= true;
   end;
  end
  else begin
   if (high(datear) >= 0) or hasmonthname then begin
    if not tryencodedate(year,month,day,value) then begin
     exit;
    end;
    result:= true;
   end
   else begin
    if text = ' ' then begin
     result:= true;
     if hasdateformat and hastimeformat or 
        not(hasdateformat or hastimeformat) then begin
      value:= refdate;
     end
     else begin
      if hasdateformat then begin
       value:= trunc(refdate);
      end
      else begin
       value:= frac(refdate);
      end;
     end;
     exit;
    end;
   end;
  end;
 end;
 if result then begin
  checkdateconvert(convert,value);
 end;
end;

function stringtodatetime(const avalue: msestring; const aformat: msestring;
                               const convert: dateconvertty = dc_none): tdatetime;
begin
 if not trystringtodatetime(avalue,aformat,result,convert) then begin
  formaterror(avalue);
 end;
end;

function trystringtodatetime(const text: msestring; out value: tdatetime;
                               const convert: dateconvertty = dc_none): boolean;
var
 mstr1: msestring;
 datsep: msechar;
begin
 result:= true;
 if text = '' then begin
  value:= emptydatetime;
 end
 else begin
  if text = ' ' then begin
   if convert = dc_toutc then begin
    value:= nowutc;
   end
   else begin
    value:= nowlocal;
   end;
  end
  else begin
   datsep:= defaultformatsettingsmse.dateseparator;
   if (countchars(text,datsep) = 0) and
      (countchars(text,defaultformatsettingsmse.timeseparator) = 0) then begin
    case length(text) of
     3,4: begin
      mstr1:= copy(text,1,2)+datsep+copy(text,3,2);
     end;
     5,6: begin
      mstr1:= copy(text,1,2)+datsep+copy(text,3,2)+datsep+
              copy(text,5,2);
     end;
     else begin
      mstr1:= text;
     end;
    end;
    result:= trystrtodatetime(ansistring(mstr1),value);
   end
   else begin
    result:= trystrtodatetime(ansistring(text),value);
   end;
   if result then begin
    checkdateconvert(convert,value);
   end;
  end;
 end;
end;

function stringtodatetime(const avalue: msestring;
                               const convert: dateconvertty = dc_none): tdatetime;
begin
 if not trystringtodatetime(avalue,result,convert) then begin
  formaterror(avalue);
 end;
end;

function trystringtodate(const text: msestring;
                const aformat: msestring; out value: tdatetime;
                               const convert: dateconvertty = dc_none): boolean;
begin
 if text = '' then begin
  value:= emptydatetime;
  result:= true;
 end
 else begin
  result:= trystringtodatetime(text,aformat,value,convert);
  if result then begin
   value:= trunc(value);
  end;
 end;
end;

function stringtodate(const avalue: msestring;
                              const aformat: msestring;
                               const convert: dateconvertty = dc_none): tdatetime;
begin
 if not trystringtodate(avalue,aformat,result,convert) then begin
  formaterror(avalue);
 end;
end;

function trystringtodate(const text: msestring; out value: tdatetime;
                               const convert: dateconvertty = dc_none): boolean;
begin
 if text = '' then begin
  value:= emptydatetime;
  result:= true;
 end
 else begin
  result:= trystringtodatetime(text,value,convert);
  if result then begin
   value:= trunc(value);
  end;
 end;
end;

function stringtodate(const avalue: msestring;
                               const convert: dateconvertty = dc_none): tdatetime;
begin
 if not trystringtodate(avalue,result,convert) then begin
  formaterror(avalue);
 end;
end;

function trystringtotime(const text: msestring;
                const aformat: msestring; out value: tdatetime;
                               const convert: dateconvertty = dc_none): boolean;
var
 mstr1: msestring;
begin
 if text = '' then begin
  value:= emptydatetime;
  result:= true;
 end
 else begin
  if aformat = '' then begin
   mstr1:= 'tt';
  end
  else begin
   mstr1:= aformat;
  end;
  result:= trystringtodatetime(text,mstr1,value,convert);
  if result then begin
   value:= frac(value);
  end;
 end;
end;

function stringtotime(const avalue: msestring;
                             const aformat: msestring;
                               const convert: dateconvertty = dc_none): tdatetime;
begin
 if not trystringtotime(avalue,aformat,result,convert) then begin
  formaterror(avalue);
 end; 
end;

function trystringtotime(const text: msestring; out value: tdatetime;
                               const convert: dateconvertty = dc_none): boolean;
//var
// mstr1: msestring;
begin
 if text = '' then begin
  value:= emptydatetime;
  result:= true;
 end
 else begin
  result:= trystringtodatetime(text,value,convert);
  if result then begin
   value:= frac(value);
  end;
 end;
end;

function stringtotime(const avalue: msestring;
                 const convert: dateconvertty = dc_none): tdatetime;
begin
 if not trystringtotime(avalue,result,convert) then begin
  formaterror(avalue);
 end;
end;

function timemse(const value: tdatetime): tdatetime;
  //bringt timeanteil im mseformat
begin
 result:= frac(value);
// if result = 0 then begin
//  result:= nulltime;
// end;
end;

function bcdtoint(inp: byte): integer;
begin
 result:= ((inp and $f0) shr 4) * 10 + (inp and $0f);
end;

function inttobcd(inp: integer): byte;
begin
 result:= byte(((inp div 10) shl 4) + (inp mod 10))
end;

function formatfloatmse(value: double; format: msestring;
                              const formatsettings: tformatsettingsmse;
                              const dot: boolean = false): msestring;

var
 po1,po2: pmsechar;
 expsign{,noexpsign}: boolean;

 procedure quote;
 begin
  case po2^ of
   '''': begin                    //'quoted string
    inc(po2);
    while po2^ <> #0 do begin
     if po2^ = '''' then begin
      inc(po2);
      if po2^ <> '''' then begin
       break;
      end;
     end;
     po1^:= po2^;
     inc(po1);
     inc(po2);
    end; 
   end;
   '"': begin                    //"quoted string
    inc(po2);
    while po2^ <> #0 do begin
     if po2^ = '"' then begin
      inc(po2);
      if po2^ <> '"' then begin
       break;
      end;
     end;
     po1^:= po2^;
     inc(po1);
     inc(po2);
    end; 
   end;
  end;
 end;
 
 procedure checkexp;
 begin
  if (po2+1)^ = '+' then begin
   expsign:= true;
   inc(po2);
  end
  else begin
   if (po2+1)^ = '-' then begin
    inc(po2);
   end;
  end;
 end;
   
var
 int1,int2,int3: integer;
 decimalsep,thousandsep: msechar;
 intopt,intmust,fracmust,fracopt,expopt,expmust: integer;
 decifound,doubledecifound,thousandfound,numberprinted,expofound,
 engfound,engsymfound,engsymnospacefound: boolean;
 mstr1: msestring;
 format1: msestring;
 mantissaend: integer;
 ar1: array[0..2] of integer;    //indexes positive, negative, zero
 expchar: msechar;
 bo1: boolean;
 po3,po4: pmsechar;

begin
 checkformatmacros(format);
 result:= '';
 ar1[0]:= 0;
 with formatsettings do begin
  if dot then begin
   decimalsep:= '.';
  end
  else begin
   decimalsep:= decimalseparator;
  end;
  bo1:= format = 'C';
  if (format = 'c') or bo1 then begin
   if bo1 then begin
    mstr1:= '';
   end
   else begin
    mstr1:= currencystring;
   end;
   if value < 0 then begin
    case negcurrformat of
     0: begin
      result:= '('+mstr1;
     end;
     1: begin
      result:= '-'+mstr1;
     end;
     2: begin
      result:= mstr1+'-';
     end;
     3: begin
      result:= mstr1;
     end;
     4,15: begin
      result:= '(';
     end;
     5,8: begin
      result:= '-';
     end;
     9: begin
      result:= '-'+mstr1+' ';
     end;
     11: begin
      result:= mstr1+' ';
     end;
     12: begin
      result:= mstr1+' -';
     end;
     14: begin
      result:= '('+mstr1+' ';
     end;
    end;
   end
   else begin
    case currencyformat of
     0: begin
      result:= mstr1;
     end;
     2: begin
      result:= mstr1 + ' ';
     end;
    end;
   end;
   result:= result+doubletostring(abs(value),currencydecimals,
                                fsm_fix,decimalsep,thousandseparator);
   if value < 0 then begin
    case negcurrformat of
     0,14: begin
      result:= result + ')';
     end;
     3,11: begin
      result:= result + '-';
     end;
     4: begin
      result:= result + mstr1 + ')';
     end;
     5: begin
      result:= result + mstr1;
     end;
     6: begin
      result:= result + '-' + mstr1;
     end;
     7: begin
      result:= result + mstr1 + '-';
     end;
     8: begin
      result:= result + ' ' + mstr1;
     end;
     10: begin
      result:= result + ' ' + mstr1 + '-';
     end;
     13: begin
      result:= result + '- ' + mstr1;
     end;
     15: begin
      result:= result + ' ' + mstr1 + ')'
     end;
    end;
   end
   else begin
    case currencyformat of
     1: begin
      result:= result + mstr1;
     end;
     3: begin
      result:= result + ' ' + mstr1;
     end;
    end;
   end;
   exit;
  end;
 end;
 expchar:= 'E';
 setlength(result,length(format)+50); //max
 numberprinted:= false;
 po1:= pmsechar(result);
 po2:= pmsechar(format);
 int1:= 0;                            //arrayindex
 while po2^ <> #0 do begin
  quote;
  if po2^ = ';' then begin
   ar1[int1]:= po2 - pmsechar(pointer(format));
   inc(int1);
   if int1 = 3 then begin
    break;
   end;
  end;
  inc(po2);
 end;
 if int1 < 3 then begin
  ar1[int1]:= length(format);
 end;  
 if (value = 0) and (int1 >= 2) then begin
  setlength(format1,ar1[2]-ar1[1]-1);
  move((pmsechar(pointer(format))+ar1[1]+1)^,pmsechar(pointer(format1))^,
                             (ar1[2]-ar1[1]-1)*sizeof(msechar));
  po2:= pmsechar(format1);
 end
 else begin
  if (value < 0) and (int1 >= 1) then begin
   setlength(format1,ar1[1]-ar1[0]-1);
   move((pmsechar(pointer(format))+ar1[0]+1)^,pmsechar(pointer(format1))^,
                              (ar1[1]-ar1[0]-1)*sizeof(msechar));
   po2:= pmsechar(format1);     
  end
  else begin
   setlength(format1,ar1[0]);
   move((pmsechar(pointer(format)))^,pmsechar(pointer(format1))^,
                              (ar1[0])*sizeof(msechar));
   po2:= pmsechar(format1);     
  end;
 end;
 if format1 = '' then begin
  result:= doubletostring(value,0,fsm_default,decimalsep);
 end
 else begin 
  if int1 > 0 then begin
   value:= abs(value); //no sign
  end;
  po1:= pmsechar(result);
  while po2^ <> #0 do begin
   quote;
   case po2^ of
    #0: begin    //was terminating quote
    end;
    ',','.','0','#': begin
     intopt:= 0;
     intmust:= 0;
     fracopt:= 0;
     fracmust:= 0;
     expopt:= 0;
     expmust:= 0;
     decifound:= false;
     doubledecifound:= false;
     thousandfound:= false;
     expofound:= false;
     engfound:= false;
     engsymfound:= false;
     engsymnospacefound:= false;
     expsign:= false;
     while po2^ <> #0 do begin
      case po2^ of
       '.': begin
        decifound:= true;
        if (po2+1)^ = '.' then begin
         doubledecifound:= true;
        end;
       end;
       ',': begin
        thousandfound:= true;
       end;
       'e','E': begin
        expofound:= true;
        expchar:= po2^;
        checkexp;
       end;
       'f','F': begin
        engfound:= true;
        expchar:= msechar(ord(po2^)-1);
        checkexp;
       end;
       'g','G': begin
        engsymfound:= true;
        engfound:= true;
        if po2^ = 'g' then begin
         engsymnospacefound:= true;
        end;
        expchar:= msechar(ord(po2^)-2);
        checkexp;
       end;
       '0': begin
        if expofound or engfound then begin
         inc(expmust);
        end
        else begin
         if decifound then begin
          inc(fracmust);
         end
         else begin
          inc(intmust);
         end;
        end;
       end;
       '#': begin
        if expofound or engfound then begin
         inc(expopt);
        end
        else begin
         if decifound then begin
          inc(fracopt);
         end
         else begin
          inc(intopt);
         end;
        end;
       end
       else begin
        break;
       end;
      end;
      inc(po2);
     end;
     if not numberprinted then begin
      numberprinted:= true;
      if thousandfound then begin
       thousandsep:= formatsettings.thousandseparator;
      end
      else begin
       thousandsep:= #0;
      end;
      if expofound then begin
       mstr1:= doubletostring(value,fracmust+fracopt,fsm_sci,decimalsep,
                                                                thousandsep);
      end
      else begin
       if engfound then begin
        if engsymfound then begin
         int1:= ord(fsm_engsymfix) - ord(fsm_engfix);
        end
        else begin
         int1:= 0;
        end;
        if not doubledecifound then begin
         mstr1:= doubletostring(value,fracopt+fracmust,
            floatstringmodety(ord(fsm_engfix)+int1),decimalsep,thousandsep);
        end
        else begin
         mstr1:= doubletostring(value,fracopt+fracmust,
            floatstringmodety(ord(fsm_engflo)+int1),decimalsep,thousandsep);
         if mstr1 <> '' then begin
          po3:= pointer(mstr1);
          if po3^ = '-' then begin
           inc(po3);
          end;
          po4:= po3;
          while (po3^ >= '0') and (po3^ <= '9') do begin
                                       //no thousandsep possible
           inc(po3);
          end;
          int1:= po3-po4-1;
          fracmust:= fracmust-int1;
          if fracmust < 0 then begin
           fracopt:= fracopt+fracmust;
           fracmust:= 0;
           if fracopt < 0 then begin
            fracopt:= 0;
           end;
          end;
         end;
        end;
       end
       else begin
        if intopt+intmust+fracmust+fracopt = 0 then begin
         mstr1:= doubletostring(value,0,fsm_default,decimalsep,thousandsep);
        end
        else begin
         mstr1:= doubletostring(value,fracmust+fracopt,fsm_fix,
                                                        decimalsep,thousandsep);
        end;
       end;       
      end;
      if expofound or engfound then begin     //format exponent
       if (length(mstr1) > 5) and (mstr1[length(mstr1)-4] = expochar) then begin
        if {noexpsign or} not expsign then begin   
         int1:= length(mstr1)-3;
         if mstr1[int1] = '+' then begin
          delete(mstr1,int1,1);                //remove exp sign
         end;
        end;
        expmust:= expmust+expopt;
        if expmust = 0 then begin
         expmust:= 1;
        end;
        int2:= length(mstr1)-expmust+1; //last zero
        int3:= length(mstr1)-2;         //firstzero
        for int1:= int3 to int2 do begin
         if mstr1[int1] <> '0' then begin
          int2:= int1;
          break;
         end;
        end;
        delete(mstr1,int3,int2-int3); //remove leading zeros      end;      
       end;
      end;

      int1:= findlastchar(mstr1,decimalsep)-1;  //format mantissa
      if int1 <= 0 then begin
       int1:= length(mstr1);
      end;
      int2:= 1;
      if mstr1[1] = '-' then begin
       inc(int2);                   //firstnumber
      end;
      if (intmust = 0) and (mstr1[int2] = '0') then begin
       delete(mstr1,int2,1);     //remove first 0
       dec(int1);
      end;
      int3:= intmust - int1 + int2 - 1;
      if int3 > 0 then begin
       insert(copy(msenullen,1,int3),mstr1,int2); //insert zeros
       inc(int1,int3);
      end;
      int3:= intmust + intopt - int1 + int2 - 1;
      if int3 > 0 then begin
       insert(copy(msespace,1,int3),mstr1,1);  //insert spaces
       inc(int1,int3);
      end;
      int2:= int1 + fracmust+1;
      mantissaend:= findchar(mstr1,expochar);     //ok for exa
      if (mantissaend > 0) and (mantissaend < length(mstr1)) then begin
                                             //not exa
       mstr1[mantissaend]:= expchar;
      end
      else begin
       if (mantissaend = 0) and engsymfound then begin
        mantissaend:= length(mstr1);
       end;
      end;
      dec(mantissaend);
      if mantissaend <= 0 then begin
       mantissaend:= length(mstr1);
      end;
      for int3:= mantissaend downto int2 do begin
       if (mstr1[int3] <> '0') then begin      //remove traling zeros   
        int2:= int3;
        break;
       end;
      end;
      if engsymnospacefound and (mstr1 <> '') and 
                                     (mstr1[length(mstr1)] = ' ') then begin
       setlength(mstr1,length(mstr1)-1);
      end;      
      if int2 < length(mstr1) then begin
       if mstr1[int2] = decimalsep then begin
        dec(int2);
       end;
       delete(mstr1,int2+1,mantissaend-int2);
      end;
      move(pointer(mstr1)^,po1^,length(mstr1)*sizeof(msechar));
      inc(po1,length(mstr1));
     end;
    end
    else begin
     po1^:= po2^;
     inc(po1);
     inc(po2);
    end;
   end;
  end;
  setlength(result,po1-pmsechar(result));
 end;
end;

function formatfloatmse(const value: double; const format: msestring; 
                         const dot: boolean = false): msestring; overload;
begin
 result:= formatfloatmse(value,format,defaultformatsettingsmse,dot);
end;

function realtostrmse(const value: double;
                                const dot: boolean = false): msestring;
var
 sep: msechar;
begin
 sep:= '.';
 if not dot then begin
  sep:= defaultformatsettingsmse.decimalseparator;
 end;
 result:= doubletostring(value,0,fsm_default,sep);
end;

function realtytostrmse(const value: double;
                                const dot: boolean = false): msestring;
begin
 if value = emptyreal then begin
  result:= '';
 end
 else begin
  result:= realtostrmse(value,dot);
 end;
end;

function inttostr(const value: integer): string;
var
 buffer: array[0..22] of char;
 int1,int2: integer;
 lwo1,lwo2: longword;
begin
 lwo1:= abs(value);
 if lwo1 = 0 then begin
  result:= '0';
  exit;
 end;
 int1:= high(buffer);
 while lwo1 > 0 do begin
  lwo2:= lwo1 div 10;
  buffer[int1]:= char(lwo1 - lwo2 * 10 + ord('0'));
  lwo1:= lwo2;
  dec(int1);
 end;
 if value < 0 then begin
  buffer[int1]:= char('-');
  dec(int1);
 end;
 int2:= (high(buffer))-int1;
 setlength(result,int2);
 move(buffer[int1+1],pointer(result)^,int2*sizeof(char));
end;

function inttostrmse(const value: integer): msestring;
var
 buffer: array[0..22] of msechar;
 int1,int2: integer;
 lwo1,lwo2: longword;
begin
 lwo1:= abs(value);
 if lwo1 = 0 then begin
  result:= '0';
  exit;
 end;
 int1:= high(buffer);
 while lwo1 > 0 do begin
  lwo2:= lwo1 div 10;
  buffer[int1]:= msechar(lwo1 - lwo2 * 10 + ord('0'));
  lwo1:= lwo2;
  dec(int1);
 end;
 if value < 0 then begin
  buffer[int1]:= msechar('-');
  dec(int1);
 end;
 int2:= (high(buffer))-int1;
 setlength(result,int2);
 move(buffer[int1+1],pointer(result)^,int2*sizeof(msechar));
end;

function inttostr(const value: longword): string;
var
 buffer: array[0..22] of char;
 int1,int2: integer;
 lwo1,lwo2: longword;
begin
 lwo1:= value;
 if lwo1 = 0 then begin
  result:= '0';
  exit;
 end;
 int1:= high(buffer);
 while lwo1 > 0 do begin
  lwo2:= lwo1 div 10;
  buffer[int1]:= char(lwo1 - lwo2 * 10 + ord('0'));
  lwo1:= lwo2;
  dec(int1);
 end;
 int2:= (high(buffer))-int1;
 setlength(result,int2);
 move(buffer[int1+1],pointer(result)^,int2*sizeof(char));
end;

function inttostrmse(const value: longword): msestring;
var
 buffer: array[0..22] of msechar;
 int1,int2: integer;
 lwo1,lwo2: longword;
begin
 lwo1:= value;
 if lwo1 = 0 then begin
  result:= '0';
  exit;
 end;
 int1:= high(buffer);
 while lwo1 > 0 do begin
  lwo2:= lwo1 div 10;
  buffer[int1]:= msechar(lwo1 - lwo2 * 10 + ord('0'));
  lwo1:= lwo2;
  dec(int1);
 end;
 int2:= (high(buffer))-int1;
 setlength(result,int2);
 move(buffer[int1+1],pointer(result)^,int2*sizeof(msechar));
end;

function inttostr(const value: int64): string;
var
 buffer: array[0..22] of char;
 int1,int2: integer;
 lwo1,lwo2: qword;
begin
 lwo1:= abs(value);
 if lwo1 = 0 then begin
  result:= '0';
  exit;
 end;
 int1:= high(buffer);
 while lwo1 > 0 do begin
  lwo2:= lwo1 div 10;
  buffer[int1]:= char(lwo1 - lwo2 * 10 + ord('0'));
  lwo1:= lwo2;
  dec(int1);
 end;
 if value < 0 then begin
  buffer[int1]:= char('-');
  dec(int1);
 end;
 int2:= (high(buffer))-int1;
 setlength(result,int2);
 move(buffer[int1+1],pointer(result)^,int2*sizeof(char));
end;

function inttostrmse(const value: int64): msestring;
var
 buffer: array[0..22] of msechar;
 int1,int2: integer;
 lwo1,lwo2: qword;
begin
 lwo1:= abs(value);
 if lwo1 = 0 then begin
  result:= '0';
  exit;
 end;
 int1:= high(buffer);
 while lwo1 > 0 do begin
  lwo2:= lwo1 div 10;
  buffer[int1]:= msechar(lwo1 - lwo2 * 10 + ord('0'));
  lwo1:= lwo2;
  dec(int1);
 end;
 if value < 0 then begin
  buffer[int1]:= msechar('-');
  dec(int1);
 end;
 int2:= (high(buffer))-int1;
 setlength(result,int2);
 move(buffer[int1+1],pointer(result)^,int2*sizeof(msechar));
end;

function inttostr(const value: qword): string;
var
 buffer: array[0..22] of char;
 int1,int2: integer;
 lwo1,lwo2: qword;
begin
 lwo1:= value;
 if lwo1 = 0 then begin
  result:= '0';
  exit;
 end;
 int1:= high(buffer);
 while lwo1 > 0 do begin
  lwo2:= lwo1 div 10;
  buffer[int1]:= char(lwo1 - lwo2 * 10 + ord('0'));
  lwo1:= lwo2;
  dec(int1);
 end;
 int2:= (high(buffer))-int1;
 setlength(result,int2);
 move(buffer[int1+1],pointer(result)^,int2*sizeof(char));
end;

function inttostrmse(const value: qword): msestring;
var
 buffer: array[0..22] of msechar;
 int1,int2: integer;
 lwo1,lwo2: qword;
begin
 lwo1:= value;
 if lwo1 = 0 then begin
  result:= '0';
  exit;
 end;
 int1:= high(buffer);
 while lwo1 > 0 do begin
  lwo2:= lwo1 div 10;
  buffer[int1]:= msechar(lwo1 - lwo2 * 10 + ord('0'));
  lwo1:= lwo2;
  dec(int1);
 end;
 int2:= (high(buffer))-int1;
 setlength(result,int2);
 move(buffer[int1+1],pointer(result)^,int2*sizeof(msechar));
end;
{
function formatfloatmse(const value: double; const format: msestring;
                                 const dot: boolean = false): msestring;
var
 int1: integer;
begin
 setlength(result,length(format)+200); //max
 int1:= floattotextfmt(pmsechar(result),value,pmsechar(format),
                                 defaultformatsettingsmse);
 setlength(result,int1);
 if dot then begin
//  replacechar1(result,widechar(decimalseparator),widechar('.'));
  replacechar1(result,defaultformatsettingsmse.decimalseparator,widechar('.'));
 end;
end;
}
function trystrtodouble(const s: lstringty; out value: double; 
                             const decimalseparator: char): boolean; overload;
var
 po1,decisep,mantstart,mantend: pchar;
 pend: pchar;
 neg,negexp: boolean;
 mant,do1: double;
 exp: integer;
begin
 result:= false;
 if s.len = 0 then begin
  exit;
 end;
 pend:= s.po+s.len;
 po1:= s.po;
 while ((po1^ = ' ') or (po1^ = c_tab)) do begin
  inc(po1);
  if po1 = pend then begin
   exit;
  end;
 end;
 neg:= po1^ = '-';
 if po1^ = '+' then begin
  inc(po1);
 end;
 if neg then begin
  inc(po1);
 end;
 decisep:= nil;
 mantstart:= po1;
 mant:= 0;
 exp:= 0;
 while true do begin
  case po1^ of
   '0'..'9': begin
     mant:= mant*10 + (byte(po1^)-byte('0'));
   end;
   'e','E': begin
    mantend:= po1;
    inc(po1);
    negexp:= po1^ = '-';
    if po1^ = '+' then begin
     inc(po1);
    end;
    if negexp then begin
     inc(po1);
    end;
    if (po1^ < '0') or (po1^ > '9') then begin
     exit;
    end;
    while true do begin
     case po1^ of 
      '0'..'9': begin
       exp:= exp * 10 + (byte(po1^)-byte('0'));
      end;
      else begin
       break;
      end;
     end;
     inc(po1);
     if po1 = pend then begin
      break;
     end;
    end;
    if negexp then begin
     exp:= -exp;
    end;
    break;
   end;
   else begin
    if po1^ = decimalseparator then begin
     if decisep <> nil then begin
      exit;
     end;
     decisep:= po1;
    end
    else begin
     mantend:= po1;
     break;
    end;
   end;
  end;
  inc(po1);
  if po1 = pend then begin
   mantend:= po1;
   break;
  end;
 end;
 if (mantstart = mantend) or (decisep = mantstart) and 
                                       (mantend-mantstart = 1) then begin
  exit; //empty
 end;
 if decisep <> nil then begin
  exp:= exp-(mantend-decisep)+1;
 end;
 while po1 <> pend do begin
  if not((po1^ = ' ') or (po1^ = c_tab)) then begin
   exit;
  end;
  inc(po1);
 end;
 if not tryintexp10(exp,do1) then begin
  exit;
 end;
 do1:= mant * do1;
 if neg then begin
  do1:= -do1;
 end;
 value:= do1;
 result:= true;
end;

function trystrtodouble(const s: lmsestringty; out value: double; 
                             const decimalseparator: msechar): boolean; overload;
var
 po1,decisep,mantstart,mantend: pmsechar;
 pend: pmsechar;
 neg,negexp: boolean;
 mant,do1: double;
 exp: integer;
begin
 result:= false;
 if s.len = 0 then begin
  exit;
 end;
 pend:= s.po+s.len;
 po1:= s.po;
 while ((po1^ = ' ') or (po1^ = c_tab)) do begin
  inc(po1);
  if po1 = pend then begin
   exit;
  end;
 end;
 neg:= po1^ = '-';
 if po1^ = '+' then begin
  inc(po1);
 end;
 if neg then begin
  inc(po1);
 end;
 decisep:= nil;
 mantstart:= po1;
 mant:= 0;
 exp:= 0;
 while true do begin
  case po1^ of
   '0'..'9': begin
     mant:= mant*10 + (byte(po1^)-byte('0'));
   end;
   'e','E': begin
    mantend:= po1;
    inc(po1);
    negexp:= po1^ = '-';
    if po1^ = '+' then begin
     inc(po1);
    end;
    if negexp then begin
     inc(po1);
    end;
    if (po1^ < '0') or (po1^ > '9') then begin
     exit;
    end;
    while true do begin
     case po1^ of 
      '0'..'9': begin
       exp:= exp * 10 + (byte(po1^)-byte('0'));
      end;
      else begin
       break;
      end;
     end;
     inc(po1);
     if po1 = pend then begin
      break;
     end;
    end;
    if negexp then begin
     exp:= -exp;
    end;
    break;
   end;
   else begin
    if po1^ = decimalseparator then begin
     if decisep <> nil then begin
      exit;
     end;
     decisep:= po1;
    end
    else begin
     mantend:= po1;
     break;
    end;
   end;
  end;
  inc(po1);
  if po1 = pend then begin
   mantend:= po1;
   break;
  end;
 end;
 if (mantstart = mantend) or (decisep = mantstart) and 
                                       (mantend-mantstart = 1) then begin
  exit; //empty
 end;
 if decisep <> nil then begin
  exp:= exp-(mantend-decisep)+1;
 end;
 while po1 <> pend do begin
  if not((po1^ = ' ') or (po1^ = c_tab)) then begin
   exit;
  end;
  inc(po1);
 end;
 if not tryintexp10(exp,do1) then begin
  exit;
 end;
 do1:= mant * do1;
 if neg then begin
  do1:= -do1;
 end;
 value:= do1;
 result:= true;
end;

function trystrtodouble(const s: string; out value: double; 
                             const decimalseparator: char): boolean; overload;
var
 lstr1: lstringty;
begin
 lstr1.po:= pointer(s);
 lstr1.len:= length(s);
 result:= trystrtodouble(lstr1,value,decimalseparator);
end;

function trystrtodouble(const s: msestring; out value: double; 
                             const decimalseparator: msechar): boolean; overload;
var
 lstr1: lmsestringty;
begin
 lstr1.po:= pointer(s);
 lstr1.len:= length(s);
 result:= trystrtodouble(lstr1,value,decimalseparator);
end;

function trystrtodouble(const s: string; out value: double): boolean;
begin
 result:= trystrtodouble(s,value,defaultformatsettingsmse.decimalseparator);
end;

function trystrtodouble(const s: msestring; out value: double): boolean;
begin
 result:= trystrtodouble(s,value,defaultformatsettingsmse.decimalseparator);
end;

function strtodouble(const s: string;
                             const decimalseparator: char): double;
begin
 if not trystrtodouble(s,result,decimalseparator) then begin
  raise EConvertError.CreateFmt(SInvalidFloat,[s]);
 end;
end;

function strtodouble(const s: msestring;
                             const decimalseparator: msechar): double;
begin
 if not trystrtodouble(s,result,decimalseparator) then begin
  raise EConvertError.CreateFmt(SInvalidFloat,[s]);
 end;
end;

function strtodouble(const s: string): double;
begin
 result:= strtodouble(s,defaultformatsettingsmse.decimalseparator);
end;

function strtodouble(const s: msestring): double;
begin
 result:= strtodouble(s,defaultformatsettingsmse.decimalseparator);
end;

function realToStr(const value: double): string;     //immer'.' als separator
begin
{$ifdef withformatsettings}
 result:= floattostr(value,defaultformatsettingsdot)
{$else}
 result:= replacechar(floattostr(value),decimalseparator,'.');
{$endif}
end;

function StrToreal(const S: string): double;   //immer'.' als separator
begin
 result:= strtodouble(s,'.');
end;

function trystrtoreal(const s: string; out value: real): boolean;
begin
 result:= trystrtodouble(s,double(value),'.');
end;

function StrToreal(const S: msestring): double;   //immer'.' als separator
begin
 result:= strtodouble(s,'.');
end;

function trystrtoreal(const s: msestring; out value: real): boolean;
begin
 result:= trystrtodouble(s,double(value),'.');
end;

function realtytostr(const val: realty; const format: msestring = '';
                                            const scale: real = 1): msestring;
var
 rea1: real;
begin
 if val = emptyreal then begin
  result:= emptyrealstring;
 end
 else begin
  if scale <> 0 then begin
   rea1:= val/scale;
  end
  else begin
   rea1:= val;
  end;
  result:= formatfloatmse(rea1,format,defaultformatsettingsmse);
 end;
end;

function currencytostr(const avalue: currency): string; 
                         //always '.' as as decimal separator
var
 buffer: array[0..23] of char;
 int1,int2: integer;
 lwo1,lwo2: qword;
const
 dotpos = high(buffer)-4;
 
begin
 lwo1:= abs(int64(avalue));
 if lwo1 = 0 then begin
  result:= '0';
  exit;
 end;
 buffer[dotpos]:= '.';
 int1:= high(buffer);
 while (lwo1 > 0) or (int1 >= dotpos-1) do begin
  if int1 <> dotpos then begin
   lwo2:= lwo1 div 10;
   buffer[int1]:= msechar(lwo1 - lwo2 * 10 + ord('0'));
   lwo1:= lwo2;
  end;
  dec(int1);
 end;
 if int64(avalue) < 0 then begin
  buffer[int1]:= msechar('-');
  dec(int1);
 end;
 int2:= high(buffer);
 while buffer[int2] = '0' do begin
  dec(int2);
 end;
 if int2 = dotpos then begin
  dec(int2);
 end;
 int2:= int2-int1;
 setlength(result,int2);
 move(buffer[int1+1],pointer(result)^,int2*sizeof(char));
end;

function currencytostrmse(const avalue: currency): msestring;
                         //always '.' as as decimal separator
var
 buffer: array[0..23] of msechar;
 int1,int2: integer;
 lwo1,lwo2: qword;
const
 dotpos = high(buffer)-4;
 
begin
 lwo1:= abs(int64(avalue));
 if lwo1 = 0 then begin
  result:= '0';
  exit;
 end;
 buffer[dotpos]:= '.';
 int1:= high(buffer);
 while (lwo1 > 0) or (int1 >= dotpos-1) do begin
  if int1 <> dotpos then begin
   lwo2:= lwo1 div 10;
   buffer[int1]:= msechar(lwo1 - lwo2 * 10 + ord('0'));
   lwo1:= lwo2;
  end;
  dec(int1);
 end;
 if int64(avalue) < 0 then begin
  buffer[int1]:= msechar('-');
  dec(int1);
 end;
 int2:= high(buffer);
 while buffer[int2] = '0' do begin
  dec(int2);
 end;
 if int2 = dotpos then begin
  dec(int2);
 end;
 int2:= int2-int1;
 setlength(result,int2);
 move(buffer[int1+1],pointer(result)^,int2*sizeof(msechar));
end;

function realtytostrrange(const val: realty; const format: msestring = '';
                       const range: real = 1; const offset: real = 0): msestring;
var
 rea1: real;
begin
 if val = emptyreal then begin
  result:= emptyrealstring;
 end
 else begin
  if range <> 0 then begin
   rea1:= val*range+offset;
  end
  else begin
   rea1:= val;
  end;
  result:= formatfloatmse(rea1,format,defaultformatsettingsmse);
 end;
end;

const
 expos: array[ord('A')..ord('z')] of shortint =
 //    A    B    C    D    E    F    G    H    I    J    K    L    M  
  (    0,   0,   0,   0, 6*3,   0, 3*3,   0,   0,   0,   0,   0, 2*3,
 //    N    O    P    Q    R    S    T    U    V    W    X    Y    Z  
       0,   0, 5*3,   0,   0,   0, 4*3,   0,   0,   0,   0, 8*3, 7*3,
 //[ \ ] ^ _ '
   0,0,0,0,0,0,
 //   a    b    c    d    e    f    g    h    i    j    k    l    m  
   -6*3,   0,   0,   0,   0,-5*3,   0,   0,   0,   0, 1*3,   0,-1*3,
 //   n    o    p    q    r    s    t    u    v    w    x    y    z  
   -3*3,   0,-4*3,   0,   0,   0,   0,-2*3,   0,   0,   0,-8*3,-7*3);
 
function trystrtorealty(const ein: string; out value: realty;
                             forcevalue: boolean = false): boolean;
var
 str1: string;
 ch1: char;
 sint1: shortint;
begin
 str1:= trim(ein);
 result:= true;
 if not forcevalue and (str1 = emptyrealstring) then begin
  value:= emptyreal;
 end
 else begin
  removechar(str1,{$ifdef FPC}defaultformatsettingsmse.{$endif}thousandseparator);
  if length(str1) > 0 then begin
   ch1:= str1[length(str1)];
   if (ch1 >= 'A') and (ch1 <= 'z') then begin
    sint1:= expos[ord(ch1)];
    if sint1 <> 0 then begin
     setlength(str1,length(str1)-1);
     str1:= str1 + 'E'+inttostr(sint1);
    end;
   end;
  end;
  result:= trystrtodouble(str1,double(value));
 end;
end;

function trystrtorealty(const ein: msestring; out value: realty;
                             forcevalue: boolean = false): boolean;
var
 str1: msestring;
 ch1: msechar;
 sint1: shortint;
begin
 str1:= trim(ein);
 result:= true;
 if not forcevalue and (str1 = emptyrealstring) then begin
  value:= emptyreal;
 end
 else begin
  removechar(str1,{$ifdef FPC}defaultformatsettingsmse.{$endif}thousandseparator);
  if length(str1) > 0 then begin
   ch1:= str1[length(str1)];
   if (ch1 >= 'A') and (ch1 <= 'z') then begin
    sint1:= expos[ord(ch1)];
    if sint1 <> 0 then begin
     setlength(str1,length(str1)-1);
     str1:= str1 + 'E'+inttostrmse(sint1);
    end;
   end;
  end;
  result:= trystrtodouble(str1,double(value));
 end;
end;

function strtorealty(const ein: string; forcevalue: boolean = false): realty;
begin
 if not trystrtorealty(ein,result,forcevalue) then begin
  raise EConvertError.CreateFmt(SInvalidFloat,[ein]);
 end;
end;

function strtorealty(const ein: msestring; forcevalue: boolean = false): realty;
begin
 if not trystrtorealty(ein,result,forcevalue) then begin
  raise EConvertError.CreateFmt(SInvalidFloat,[ein]);
 end;
end;

function realtytostrdot(const val: realty): string;
begin
 if val = emptyreal then begin
  result:= emptyrealstring;
 end
 else begin
  result:= ansistring(doubletostring(val));
(*
 {$ifdef withformatsettings}
  result:= floattostr(val,defaultformatsettingsdot);
 {$else}
  result:= replacechar(floattostr(val),decimalseparator,'.');
 {$endif}
 *)
 end;
end;

function realtytostrdotmse(const val: realty): msestring;
begin
 if val = emptyreal then begin
  result:= emptyrealstring;
 end
 else begin
  result:= doubletostring(val);
 end;
end;

function strtorealtydot(const ein: string): realty;

begin
 if trim(ein) = emptyrealstring then begin
  result:= emptyreal;
 end
 else begin
  result:= strtodouble(ein,'.');
 end;
end;

function strtorealtydot(const ein: msestring): realty;

begin
 if trim(ein) = emptyrealstring then begin
  result:= emptyreal;
 end
 else begin
  result:= strtodouble(ein,'.');
 end;
end;

function trystrtorealtydot(const ein: string; out value: realty): boolean;
begin
 result:= true;
 if trim(ein) = emptyrealstring then begin
  value:= emptyreal;
 end
 else begin
  result:= trystrtodouble(ein,double(value),'.');
 end;
end;

function trystrtorealtydot(const ein: msestring; out value: realty): boolean;
begin
 result:= true;
 if trim(ein) = emptyrealstring then begin
  value:= emptyreal;
 end
 else begin
  result:= trystrtodouble(ein,double(value),'.');
 end;
end;

function bcdtostr(inp: byte): string;
 //wandelt bcdwert in zwei ascii zeichen
begin
 result:= char(byte(inp shr byte(4)) + ord('0'))+
          char(byte(inp and $0f) + ord('0'));
end;

function bytetobcd(inp: byte): word;
 //wandelt byte in bcdwert
begin
 result:= (inp div 100 shl 8) or ((inp div 10) mod 10 shl 4) or (inp mod 10)
end;

function bcdtobyte(inp: byte): byte;
 //wandelt bcdbyte in byte
begin
 result:= (inp shr 4)*10 + inp and $0f;
end;

function wordtostr(const avalue: longword): string;
begin
 str(avalue,result);
end;

function bytetohex(const inp: byte): string;
 //wandelt byte in zwei ascii hexzeichen
var
 ch1,ch2: char;
begin
 ch1:= char((inp shr 4) + byte('0'));
 if ch1 > '9' then begin
  ch1:= char(byte(ch1) + byte('A')-byte('0')-10);
 end;
 ch2:= char((inp and $0f) + byte('0'));
 if ch2 > '9' then begin
  ch2:= char(byte(ch2) + byte('A')-byte('0')-10);
 end;
 result:= ch1 + ch2;
end;

function wordtohex(const inp: word; lsbfirst: boolean = false): string;
 //wandelt word in vier ascii hexzeichen
begin
 if lsbfirst then begin
  result:= bytetohex(inp) + bytetohex(inp shr 8);
 end
 else begin
  result:=  bytetohex(inp shr 8) + bytetohex(inp);
 end;
end;

function valtohex(const avalue: byte): string;
begin
 setlength(result,2);
 pchar(pointer(result))^:= charhexlower[avalue shr 4];
 pchar(pchar(pointer(result))+1)^:= charhexlower[avalue and $f];
end;

function valtohex(const avalue: word): string; overload;
begin
 setlength(result,4);
 pchar(pointer(result))^:= charhexlower[avalue shr 12];
 pchar(pchar(pointer(result))+1)^:= charhexlower[(avalue shr 8) and $f];
 pchar(pchar(pointer(result))+2)^:= charhexlower[(avalue shr 4) and $f];
 pchar(pchar(pointer(result))+3)^:= charhexlower[avalue and $f];
end;

function valtohex(const avalue: longword): string; overload;
begin
 setlength(result,8);
 pchar(pointer(result))^:= charhexlower[avalue shr 28];
 pchar(pchar(pointer(result))+1)^:= charhexlower[(avalue shr 24) and $f];
 pchar(pchar(pointer(result))+2)^:= charhexlower[(avalue shr 20) and $f];
 pchar(pchar(pointer(result))+3)^:= charhexlower[(avalue shr 16) and $f];
 pchar(pchar(pointer(result))+4)^:= charhexlower[(avalue shr 12) and $f];
 pchar(pchar(pointer(result))+5)^:= charhexlower[(avalue shr 8) and $f];
 pchar(pchar(pointer(result))+6)^:= charhexlower[(avalue shr 4) and $f];
 pchar(pchar(pointer(result))+7)^:= charhexlower[avalue and $f];
end;

function valtohex(const avalue: qword): string; overload;
begin
 result:= valtohex(avalue shr 32)+valtohex(avalue);
end;

function bytestrtostr(const inp: ansistring; base: numbasety = nb_hex;
                               spacechar: char = #0): string;
   //wandelt bytefolge in ascii hexstring
var
 int1: integer;
begin
 result:= '';
 for int1:= 1 to length(inp) do begin
  result:= result + intvaluetostr(byte(inp[int1]),base,8);
  if (spacechar <> #0) and (int1 <> length(inp)) then begin
    result:= result + spacechar;
  end;
 end;
end;

function strtobytestr(inp: string): ansistring;
 //wandelt hex asciistring in bytefolge
var
 int1,int2, int3: integer;
 str1: string;
begin
 result:= '';
 removechar(inp,' ');
 int2:= length(inp);
 if int2 > 0 then begin
  setlength(result,(int2+1) div 2);
  setlength(str1,2);
  int1:= 1;
  int3:= 1;
  while int1 <= int2 do begin
   str1[1]:= inp[int1];
   inc(int1);
   if int1 > int2 then begin
    setlength(str1,1);
   end
   else begin
    str1[2]:= inp[int1];
   end;
   result[int3]:= char(strtohex(str1));
   inc(int1);
   inc(int3);
  end;
 end;
end;

function strtobytes(const inp: string; out dest: bytearty): boolean;
var
 po1,po2: pchar;
 int1: integer;
 by1: shortint;
begin
 result:= false;
 int1:= length(inp)+1;
 setlength(dest,int1 div 2);
 po1:= @inp[int1];
 po2:= pchar(inp);
 int1:= high(dest);
 while po1 > po2 do begin
  dec(po1);
  by1:= hexchars[po1^];
  if by1 < 0 then begin
   exit;
  end;
  dest[int1]:= by1;

  if po1 = po2 then begin
   break;
  end;
  dec(po1);
  by1:= hexchars[po1^];
  if by1 < 0 then begin
   exit;
  end;
  dest[int1]:= dest[int1] or (by1 shl 4);
  dec(int1);
 end;
 result:= true;
end;

function bytestrtobin(const inp: ansistring; abstand: boolean): string;
   //wandelt bytefolge in ascii binstring,
   // letztes zeichen = anzahl gueltige bits in letztem byte
var
 int1,int2,int3,int4: integer;
// str1: string;
 by1,by2: byte;

begin
 result:= '';
 int2:= bitcount(inp)-1;
 int3:= 1;
 int4:= 0;
 while int2 >= 0 do begin
  by1:= byte(inp[int3]);
  by2:= $01;
  for int1:= 0 to 7 do begin
   if by1 and by2 <> 0 then begin
    result:= result + '1';
   end
   else begin
    result:= result + '0';
   end;
   if int4+int1 >= int2 then begin
    break;
   end;
   by2:= by2 shl 1;
  end;
  if int4+(int1 and $07) >= int2 then begin
   break;
  end;
  if abstand then begin
   result:= result + ' ';
  end;
  inc(int3);
  inc(int4,8);
 end;
end;

function strtobinstr(inp: string): ansistring;
 //wandelt bin asciistring in bytefolge,
 // letztes byte = anzahl gueltige bits in vorletztem byte
var
 int1,int2,int3: integer;
 by1,by2: byte;
 ch1: char;
begin
 result:= '';
 removechar(inp,' ');
 int1:= length(inp);
 int3:= 1;
 int2:= 0;
 while int3 <= int1 do begin
  by1:= 1;
  by2:= 0;
  for int2:= 0 to 7 do begin
   if int3 + int2 > int1 then begin
    break;
   end;
   ch1:= inp[int3+int2];
   if ch1 = '1' then begin
    by2:= by2 or by1;
   end
   else begin
    if ch1 <> '0' then begin
     raise EConvertError.CreateFmt(SInvalidInteger,[inp]);
    end;
   end;
   by1:= by1 shl 1;
  end;
  int3:= int3 + 8;
  result:= result + char(by2);
 end;
 if length(result) > 0 then begin
  result:= result + char(int2);
 end;
end;

function bitmaske(const data: ansistring): integer;
begin
 if length(data) > 1 then begin
  result:= byte(data[length(data)]);
  if result > 8 then begin
   result:= 8
  end;
 end
 else begin
  result:= 0;
 end;
end;

function bitcount(const data: ansistring): integer; //anzahl gueltige bits
var
 int1: integer;
begin
 int1:= length(data);
 if int1 > 1 then begin
  result:= 8*(int1-2) + bitmaske(data);
 end
 else begin
  result:= 0;
 end;
end;

function bintostr(inp: longword; digits: integer): string;
   //convert longword to binstring, digits = bit count
var
 int1: integer;
begin
 setlength(result,digits);
 for int1:= digits downto 1  do begin
  result[int1]:= char(ord('0') + (inp and $1));
  inp:= inp shr 1;
 end;
end;

function bintostr(inp: qword; digits: integer): string;
   //convert longword to binstring, digits = bit count
var
 int1: integer;
begin
 setlength(result,digits);
 for int1:= digits downto 1  do begin
  result[int1]:= char(ord('0') + (inp and $1));
  inp:= inp shr 1;
 end;
end;

function octtostr(inp: longword; digits: integer): string;
   //convert longword to octaltring, digits = octet count
var
 int1: integer;
begin
 setlength(result,digits);
 for int1:= digits downto 1  do begin
  result[int1]:= char(ord('0') + (inp and $7));
  inp:= inp shr 3;
 end;
end;

function octtostr(inp: qword; digits: integer): string;
   //convert longword to octaltring, digits = octet count
var
 int1: integer;
begin
 setlength(result,digits);
 for int1:= digits downto 1  do begin
  result[int1]:= char(ord('0') + (inp and $7));
  inp:= inp shr 3;
 end;
end;

function dectostr(const inp: integer; digits: integer): string;
          //leading zeroes if digits < 0
begin
 result:= inttostr(abs(inp));
 if digits < 0 then begin
  digits:= -digits;
  if digits > length(nullen) then begin
   digits:= length(nullen);
  end;
  result:= copy(nullen,1,digits-length(result)) + result;
 end;
 result:= copy(result,length(result)-digits+1,bigint);
 if inp < 0 then begin
  result:= '-' + result;
 end;
end;

function dectostr(const inp: int64; digits: integer): string;
          //leading zeroes if digits < 0
begin
 result:= inttostr(abs(inp));
 if digits < 0 then begin
  digits:= -digits;
  if digits > length(nullen) then begin
   digits:= length(nullen);
  end;
  result:= copy(nullen,1,digits-length(result)) + result;
 end;
 result:= copy(result,length(result)-digits+1,bigint);
 if (inp < 0) and (result[1] <> '-') then begin
  result:= '-' + result;
 end;
end;

function hextostr(inp: longword; digits: integer): string;
   //wandelt longword in hexstring, stellen = anzahl nibbles
var
 int1: integer;
begin
 if digits = 0 then begin
  digits:= (highestbit(inp)+4) div 4;
  if digits = 0 then begin
   digits:= 1;
  end;
 end;
 setlength(result,digits);
 for int1:= digits downto 1  do begin
  result[int1]:= char(ord('0') + (inp and $f));
  if result[int1] > '9' then begin
   inc(result[int1],ord('A')-ord('9')-1);
  end;
  inp:= inp shr 4;
 end;
end;

function hextostr(inp: qword; digits: integer): string;
   //wandelt longword in hexstring, stellen = anzahl nibbles
var
 int1: integer;
begin
 if digits = 0 then begin
  digits:= (highestbit64(inp)+4) div 4;
  if digits = 0 then begin
   digits:= 1;
  end;
 end;
 setlength(result,digits);
 for int1:= digits downto 1  do begin
  result[int1]:= char(ord('0') + (inp and $f));
  if result[int1] > '9' then begin
   inc(result[int1],ord('A')-ord('9')-1);
  end;
  inp:= inp shr 4;
 end;
end;

function hextostr(const inp: pointer;
             digits: integer = 2*sizeof(pointer)): string; overload;
   //convert pointer to hexstring, digits = nibble count
begin
 result:= hextostr(ptruint(inp),digits);
end;

function hextostrmse(inp: longword; digits: integer): msestring;
   //wandelt longword in hexstring, stellen = anzahl nibbles
var
 int1: integer;
begin
 if digits = 0 then begin
  digits:= (highestbit(inp)+4) div 4;
  if digits = 0 then begin
   digits:= 1;
  end;
 end;
 setlength(result,digits);
 for int1:= digits downto 1  do begin
  result[int1]:= msechar(ord('0') + (inp and $f));
  if result[int1] > '9' then begin
   inc(result[int1],ord('A')-ord('9')-1);
  end;
  inp:= inp shr 4;
 end;
end;

function hextostrmse(inp: qword; digits: integer): msestring;
   //wandelt longword in hexstring, stellen = anzahl nibbles
var
 int1: integer;
begin
 if digits = 0 then begin
  digits:= (highestbit64(inp)+4) div 4;
  if digits = 0 then begin
   digits:= 1;
  end;
 end;
 setlength(result,digits);
 for int1:= digits downto 1  do begin
  result[int1]:= msechar(ord('0') + (inp and $f));
  if result[int1] > '9' then begin
   inc(result[int1],ord('A')-ord('9')-1);
  end;
  inp:= inp shr 4;
 end;
end;

function hextostrmse(const inp: pointer;
             digits: integer = 2*sizeof(pointer)): msestring; overload;
   //convert pointer to hexstring, digits = nibble count
begin
 result:= hextostrmse(ptruint(inp),digits);
end;

function hextocstr(const inp: longword; stellen: integer): string;
begin
 result:= '0x' + hextostr(inp, stellen);
end;

function hextocstr(const inp: qword; stellen: integer): string;
begin
 result:= '0x' + hextostr(inp, stellen);
end;

function ptruinttocstr(inp: ptruint): string;
   //convert ptrint to 0x...
var
 int1: integer;
begin
 result:= '0x';
 setlength(result,2+sizeof(ptrint)*2);
 for int1:= length(result) downto 3  do begin
  result[int1]:= char(ord('0') + (inp and $f));
  if result[int1] > '9' then begin
   inc(result[int1],ord('A')-ord('9')-1);
  end;
  inp:= inp shr 4;
 end;
end;

function qwordtocstr(inp: qword): string;
   //convert qword to 0x...
var
 int1: integer;
begin
 result:= '0x';
 int1:= 8*2;
// if inp <= $ffffffff then begin
//  int1:= 4*2;
// end;
 setlength(result,2+int1);
 for int1:= length(result) downto 3  do begin
  result[int1]:= char(ord('0') + (inp and $f));
  if result[int1] > '9' then begin
   inc(result[int1],ord('A')-ord('9')-1);
  end;
  inp:= inp shr 4;
 end;
end;

function trystrtoint(const text: pchar; const len: int32; 
                                          out value: integer): boolean;
const
 max = maxint div 10;
var
 po1,pe: pchar;
 neg: boolean;
begin
 result:= false;
 neg:= false;
 value:= 0;
 if len > 0 then begin
  po1:= text;
  pe:= po1 + len;
  while ((po1^ = ' ') or (po1^ = c_tab)) and (po1 < pe) do begin
   inc(po1);
  end;
  neg:= po1^ = char('-');
  if not neg then begin
   if po1^ = '+' then begin
    inc(po1);
   end;
  end
  else begin
   inc(po1);
  end;
  if po1 >= pe then begin
   exit;
  end;
  while po1 < pe do begin
   if (po1^ < '0') or (po1^ > '9')  then begin
    exit;
   end;
   if value < 0 then begin
    exit;
   end;
   if value > max then begin
    exit;
   end;
   value:= value * 10 + (byte(po1^) - byte('0'));
   inc(po1);
  end;
 end;
 if neg then begin
  if (value < 0) and (value <> minint) then begin
   exit;
  end;  
  value:= -value;
 end
 else begin
  if value < 0 then begin
   exit;
  end;
 end;
 result:= true;
end;

function trystrtoint(const text: lstringty; out value: integer): boolean;
begin
 result:= trystrtoint(text.po,text.len,value);
end;

function trystrtoint(const text: string; out value: integer): boolean;
begin
 result:= trystrtoint(pointer(text),length(text),value);
end;

function strtoint(const text: string): integer;
begin
 if not trystrtoint(pointer(text),length(text),result) then begin
  raise EConvertError.CreateFmt(SInvalidInteger,[text]);
 end;
end;

function trystrtoint(const text: msestring; out value: integer): boolean;
const
 max = maxint div 10;
var
 po1: pmsechar;
 neg: boolean;
begin
 result:= false;
 neg:= false;
 value:= 0;
 if text <> '' then begin
  po1:= pointer(text);
  while (po1^ = ' ') or (po1^ = c_tab) do begin
   inc(po1);
  end;
  neg:= po1^ = msechar('-');
  if not neg then begin
   if po1^ = '+' then begin
    inc(po1);
   end;
  end
  else begin
   inc(po1);
  end;
  if po1^ = #0 then begin
   exit;
  end;
  while po1^ <> #0 do begin
   if (po1^ < '0') or (po1^ > '9')  then begin
    exit;
   end;
   if value < 0 then begin
    exit;
   end;
   if value > max then begin
    exit;
   end;
   value:= value * 10 + (word(po1^) - word('0'));
   inc(po1);
  end;
 end;
 if neg then begin
  if (value < 0) and (value <> minint) then begin
   exit;
  end;  
  value:= -value;
 end
 else begin
  if value < 0 then begin
   exit;
  end;
 end;
 result:= true;
end;

function strtoint(const text: msestring): integer;
begin
 if not trystrtoint(text,result) then begin
  raise EConvertError.CreateFmt(SInvalidInteger,[string(text)]);
 end;
end;

function trystrtoint(const text: string; out value: longword): boolean;
const
 max = $ffffffff div 10;
var
 po1: pchar;
begin
 result:= false;
 value:= 0;
 if text <> '' then begin
  po1:= pointer(text);
  while (po1^ = ' ') or (po1^ = c_tab) do begin
   inc(po1);
  end;
  if po1^ = '+' then begin
   inc(po1);
  end;
  if po1^ = #0 then begin
   exit;
  end;
  while po1^ <> #0 do begin
   if (po1^ < '0') or (po1^ > '9')  then begin
    exit;
   end;
   if value > max then begin
    exit;
   end;
   value:= value * longword(10) + longword(byte(po1^) - byte('0'));
   inc(po1);
  end;
 end;
 result:= true;
end;

function trystrtoint(const text: msestring; out value: longword): boolean;
const
 max = $ffffffff div 10;
var
 po1: pmsechar;
// neg: boolean;
begin
 result:= false;
 value:= 0;
 if text <> '' then begin
  po1:= pointer(text);
  while (po1^ = ' ') or (po1^ = c_tab) do begin
   inc(po1);
  end;
//  neg:= po1^ = msechar('-');
//  if not neg then begin
  if po1^ = '+' then begin
   inc(po1);
  end;
//  end
//  else begin
//   inc(po1);
//  end;
  if po1^ = #0 then begin
   exit;
  end;
  while po1^ <> #0 do begin
   if (po1^ < '0') or (po1^ > '9')  then begin
    exit;
   end;
//   if value < 0 then begin
//    exit;
//   end;
   if value > max then begin
    exit;
   end;
   value:= value * longword(10) + longword(word(po1^) - word('0'));
   inc(po1);
  end;
 end;
// if neg then begin
//  if (value < 0) and (value <> minint) then begin
//   exit;
//  end;  
//  value:= -value;
// end
// else begin
//  if value < 0 then begin
//   exit;
//  end;
// end;
 result:= true;
end;

function trystrtoint64(const text: lstringty; out value: int64): boolean;
const
 max = maxint64 div 10;
var
 po1,pe: pchar;
 neg: boolean;
begin
 result:= false;
 neg:= false;
 value:= 0;
 if text.len > 0 then begin
  po1:= text.po;
  pe:= po1 + text.len;
  while ((po1^ = ' ') or (po1^ = c_tab)) and (po1 < pe) do begin
   inc(po1);
  end;
  neg:= po1^ = char('-');
  if not neg then begin
   if po1^ = '+' then begin
    inc(po1);
   end;
  end
  else begin
   inc(po1);
  end;
  if po1 >= pe then begin
   exit;
  end;
  while po1 < pe do begin
   if (po1^ < '0') or (po1^ > '9')  then begin
    exit;
   end;
   if value < 0 then begin
    exit;
   end;
   if value > max then begin
    exit;
   end;
   value:= value * 10 + (ord(po1^) - ord('0'));
   inc(po1);
  end;
 end;
 if neg then begin
  if (value < 0) and (value <> $8000000000000000) then begin
   exit;
  end;  
  value:= -value;
 end
 else begin
  if value < 0 then begin
   exit;
  end;
 end;
 result:= true;
end;

function trystrtoint64(const text: string; out value: int64): boolean;
begin
 result:= trystrtoint64(stringtolstring(text),value);
end;

function strtoint64(const text: string): int64;
begin
 if not trystrtoint64(text,result) then begin
  raise EConvertError.CreateFmt(SInvalidInteger,[text]);
 end;
end;

function strtoint64(const text: msestring): int64;
begin
 if not trystrtoint64(text,result) then begin
  raise EConvertError.CreateFmt(SInvalidInteger,[string(text)]);
 end;
end;

function trystrtoint64(const text: msestring; out value: int64): boolean;
const
 max = maxint64 div 10;
var
 po1: pmsechar;
 neg: boolean;
begin
 result:= false;
 neg:= false;
 value:= 0;
 if text <> '' then begin
  po1:= pointer(text);
  while (po1^ = ' ') or (po1^ = c_tab) do begin
   inc(po1);
  end;
  neg:= po1^ = msechar('-');
  if not neg then begin
   if po1^ = '+' then begin
    inc(po1);
   end;
  end
  else begin
   inc(po1);
  end;
  if po1^ = #0 then begin
   exit;
  end;
  while po1^ <> #0 do begin
   if (po1^ < '0') or (po1^ > '9')  then begin
    exit;
   end;
   if value < 0 then begin
    exit;
   end;
   if value > max then begin
    exit;
   end;
   value:= value * 10 + (ord(po1^) - ord('0'));
   inc(po1);
  end;
 end;
 if neg then begin
  if (value < 0) and (value <> $8000000000000000) then begin
   exit;
  end;  
  value:= -value;
 end
 else begin
  if value < 0 then begin
   exit;
  end;
 end;
 result:= true;
end;

function trystrtoqword(const text: string; out value: qword): boolean;
const
 max = 1844674407370955161;
var
 po1: pchar;
 bo1: boolean;
begin
 result:= false;
 value:= 0;
 if text <> '' then begin
  po1:= pointer(text);
  while (po1^ = ' ') or (po1^ = c_tab) do begin
   inc(po1);
  end;
  if po1^ = #0 then begin
   exit;
  end;
  while po1^ <> #0 do begin
   if (po1^ < '0') or (po1^ > '9')  then begin
    exit;
   end;
   if value > max then begin
    exit;
   end;
   value:= value * 10;
   bo1:= int64(value) < 0;
   value:= value + (ord(po1^) - ord('0'));
   if bo1 and (int64(value) >= 0) then begin
    exit;
   end;
   inc(po1);
  end;
 end;
 result:= true;
end;

function trystrtoqword(const text: msestring; out value: qword): boolean;
const
 max = 1844674407370955161;
var
 po1: pmsechar;
 bo1: boolean;
begin
 result:= false;
 value:= 0;
 if text <> '' then begin
  po1:= pointer(text);
  while (po1^ = ' ') or (po1^ = c_tab) do begin
   inc(po1);
  end;
  if po1^ = #0 then begin
   exit;
  end;
  while po1^ <> #0 do begin
   if (po1^ < '0') or (po1^ > '9')  then begin
    exit;
   end;
   if value > max then begin
    exit;
   end;
   value:= value * 10;
   bo1:= int64(value) < 0;
   value:= value + (ord(po1^) - ord('0'));
   if bo1 and (int64(value) >= 0) then begin
    exit;
   end;
   inc(po1);
  end;
 end;
 result:= true;
end;

function trystrtointvalue(const text: msestring; base: numbasety;
                     out value: longword): boolean;
var
 str1: string;
begin
 str1:= ansistring(trim(text));
 case base of
  nb_bin: begin
   result:= trystrtobin(str1,value);
  end;
  nb_oct: begin
   result:= trystrtooct(str1,value);
  end;
  nb_hex: begin
   result:= trystrtohex(str1,value);
  end
  else begin //nb_dec
   result:= trystrtodec(str1,value);
  end;
 end;
end;

function trystrtointvalue64(const text: msestring; base: numbasety;
                     out value: qword): boolean; overload;
var
 str1: string;
begin
 str1:= ansistring(trim(text));
 case base of
  nb_bin: begin
   result:= trystrtobin64(str1,value);
  end;
  nb_oct: begin
   result:= trystrtooct64(str1,value);
  end;
  nb_hex: begin
   result:= trystrtohex64(str1,value);
  end
  else begin //nb_dec
   result:= trystrtodec64(str1,value);
  end;
 end;
end;

function strtointvalue(const text: msestring; base: numbasety): longword;
begin
 if not trystrtointvalue(text,base,result) then begin
  formaterror(text);
 end;
end;

function strtointvalue64(const text: msestring; base: numbasety): qword;
begin
 if not trystrtointvalue64(text,base,result) then begin
  formaterror(text);
 end;
end;

function intvaluetostr(const value: integer; const base: numbasety = nb_dec;
                          const bitcount: integer = 32): string;
begin
 case base of
  nb_bin: begin
   result:= bintostr(longword(value),abs(bitcount));
  end;
  nb_oct: begin
   result:= octtostr(longword(value),(abs(bitcount)+2) div 3);
  end;
  nb_hex: begin
   result:= hextostr(longword(value),(abs(bitcount)+3) div 4);
  end;
  else begin //nb_dec
   result:= dectostr(value,sign(bitcount)*(abs(bitcount)*100+331) div 332);
  end;
 end;
end;

function intvaluetostr(const value: int64; const base: numbasety = nb_dec;
                          const bitcount: integer = 64): string;
begin
 case base of
  nb_bin: begin
   result:= bintostr(uint64(value),abs(bitcount));
  end;
  nb_oct: begin
   result:= octtostr(uint64(value),(abs(bitcount)+2) div 3);
  end;
  nb_hex: begin
   result:= hextostr(uint64(value),(abs(bitcount)+3) div 4);
  end;
  else begin //nb_dec
   result:= dectostr(value,sign(bitcount)*(abs(bitcount)*100+331) div 332);
  end;
 end;
end;

function strtobin1(const inp: string; out value: longword): boolean;
   //wandelt 1..0-string in longword)
var
 int1: integer;
 lwo1: longword;
begin
 result:= false;
 if inp <> '' then begin
  value:= 0;
  lwo1:= 1;
  for int1:= length(inp) downto 1 do begin
   if inp[int1] = '1' then begin
    value:= value + lwo1;
   end
   else begin
    if inp[int1] <> '0' then begin
     exit;
    end;
   end;
   lwo1:= lwo1 shl 1;
  end;
  result:= true;
 end;
end;

function strtobin164(const inp: string; out value: qword): boolean;
   //wandelt 1..0-string in longword)
var
 int1: integer;
 lwo1: qword;
begin
 result:= false;
 if inp <> '' then begin
  value:= 0;
  lwo1:= 1;
  for int1:= length(inp) downto 1 do begin
   if inp[int1] = '1' then begin
    value:= value + lwo1;
   end
   else begin
    if inp[int1] <> '0' then begin
     exit;
    end;
   end;
   lwo1:= lwo1 shl 1;
  end;
  result:= true;
 end;
end;

function trystrtobin(const inp: string; out value: longword): boolean;
begin
 result:= strtobin1(inp,value);
 if not result then begin
  result:= trystrtointvalue(inp,value);
 end;
end;

function trystrtobin64(const inp: string; out value: qword): boolean;
begin
 result:= strtobin164(inp,value);
 if not result then begin
  result:= trystrtointvalue64(inp,value);
 end;
end;

function strtobin(const inp: string): longword;
   //wandelt 0..1-string in longword)
begin
 if not trystrtobin(inp,result) then begin
  formaterror(inp);
 end;
end; 

function strtobin64(const inp: string): qword;
   //wandelt 0..1-string in longword)
begin
 if not trystrtobin64(inp,result) then begin
  formaterror(inp);
 end;
end; 

function strtooct1(const inp: string; out value: longword): boolean;
var
 int1: integer;
 ca1: longword;
 ch1: char;
begin
 result:= false;
 if inp <> '' then begin
  value:= 0;
  ca1:= 0;
  for int1:= length(inp) downto 1 do begin
   ch1:= inp[int1];
   if (ch1 < '0') or (ch1 > '7') then begin
    exit;
   end;
   value:= value + longword(((ord(ch1) - ord('0'))) shl ca1);
   inc(ca1,3);
  end;
  result:= true;
 end;
end;

function strtooct164(const inp: string; out value: qword): boolean;
var
 int1: integer;
 ca1: longword;
 ch1: char;
begin
 result:= false;
 if inp <> '' then begin
  value:= 0;
  ca1:= 0;
  for int1:= length(inp) downto 1 do begin
   ch1:= inp[int1];
   if (ch1 < '0') or (ch1 > '7') then begin
    exit;
   end;
   value:= value + qword(((ord(ch1) - ord('0'))) shl ca1);
   inc(ca1,3);
  end;
  result:= true;
 end;
end;

function trystrtooct(const inp: string; out value: longword): boolean;
begin
 result:= strtooct1(inp,value);
 if not result then begin
  result:= trystrtointvalue(inp,value);
 end;
end;

function trystrtooct64(const inp: string; out value: qword): boolean;
begin
 result:= strtooct164(inp,value);
 if not result then begin
  result:= trystrtointvalue64(inp,value);
 end;
end;

function strtooct(const inp: string): longword;
   //wandelt 1..0-string in longword)
begin
 if not trystrtooct(inp,result) then begin
  formaterror(inp);
 end;
end;

function strtooct64(const inp: string): qword;
   //wandelt 1..0-string in longword)
begin
 if not trystrtooct64(inp,result) then begin
  formaterror(inp);
 end;
end;

function strtodec1(const inp: string; out value: longword): boolean;
begin
 result:= trystrtoint(inp,integer(value));
end;

function strtodec164(const inp: string; out value: qword): boolean;
begin
 result:= trystrtoint64(inp,int64(value));
end;

function trystrtodec(const inp: string; out value: longword): boolean;
begin
 result:= strtodec1(inp,value);
 if not result then begin
  result:= trystrtointvalue(inp,value);
 end; 
end;

function trystrtodec64(const inp: string; out value: qword): boolean;
begin
 result:= strtodec164(inp,value);
 if not result then begin
  result:= trystrtointvalue64(inp,value);
 end; 
end;

function strtodec(const inp: string): longword;
   //wandelt 0..9-string in longword)
begin
 if not trystrtodec(inp,result) then begin
  formaterror(inp);
 end;
end;

function strtodec64(const inp: string): qword;
   //wandelt 0..9-string in longword)
begin
 if not trystrtodec64(inp,result) then begin
  formaterror(inp);
 end;
end;

function trystrtohex(const inp: pchar; const len: int32;
                                                out value: longword): boolean;
var
 po1,pe: pchar;
 ch1: char;
begin
 value:= 0;
 result:= (len > 0) and (len <= 8);
 if result then begin
  po1:= inp;
  pe:= po1+len;
  while po1 < pe do begin
   ch1:= po1^;
   value:= value shl 4;
   if (ch1 >= '0') and (ch1 <= '9') then begin
    value:= value + ord(ch1) - ord('0');
   end
   else begin
    if (ch1 >= 'a') and (ch1 <= 'f') then begin
     value:= value + ord(ch1) - (ord('a')-10);
    end
    else begin
     if (ch1 >= 'A') and (ch1 <= 'F') then begin
      value:= value + ord(ch1) - (ord('A')-10);
     end
     else begin
      result:= false;
      break;
     end;
    end;
   end;
   inc(po1);
  end;
 end;
// result:= trystrtoint('$'+inp,integer(value));
end;

function strtohex1(const inp: msestring; out value: longword): boolean;
var
 po1: pmsechar;
 ch1: msechar;
 int1: integer;
begin
 value:= 0;
 int1:= length(inp);
 result:= (int1 > 0) and (int1 <= 8);
 if result then begin
  po1:= pointer(inp);
  while true do begin
   ch1:= po1^;
   if ch1 = #0 then begin
    break;
   end;
   value:= value shl 4;
   if (ch1 >= '0') and (ch1 <= '9') then begin
    value:= value + ord(ch1) - ord('0');
   end
   else begin
    if (ch1 >= 'a') and (ch1 <= 'f') then begin
     value:= value + ord(ch1) - (ord('a')-10);
    end
    else begin
     if (ch1 >= 'A') and (ch1 <= 'F') then begin
      value:= value + ord(ch1) - (ord('A')-10);
     end
     else begin
      result:= false;
      break;
     end;
    end;
   end;
   inc(po1);
  end;
 end;
end;

function strtohex164(const inp: string; out value: qword): boolean;
var
 po1: pchar;
 ch1: char;
 int1: integer;
begin
 value:= 0;
 int1:= length(inp);
 result:= (int1 > 0) and (int1 <= 16);
 if result then begin
  po1:= pointer(inp);
  while true do begin
   ch1:= po1^;
   if ch1 = #0 then begin
    break;
   end;
   value:= value shl 4;
   if (ch1 >= '0') and (ch1 <= '9') then begin
    value:= value + ord(ch1) - ord('0');
   end
   else begin
    if (ch1 >= 'a') and (ch1 <= 'f') then begin
     value:= value + ord(ch1) - (ord('a')-10);
    end
    else begin
     if (ch1 >= 'A') and (ch1 <= 'F') then begin
      value:= value + ord(ch1) - (ord('A')-10);
     end
     else begin
      result:= false;
      break;
     end;
    end;
   end;
   inc(po1);
  end;
 end;
// result:= trystrtoint64('$'+inp,int64(value));
end;

function trystrtohex(const inp: lstringty; out value: longword): boolean;
begin
 result:= trystrtohex(inp.po,inp.len,value);
end;

function trystrtohex(const inp: string; out value: longword): boolean;
begin
 result:= trystrtohex(pointer(inp),length(inp),value);
 if not result then begin
  result:= trystrtointvalue(inp,value);
 end;
end;

function trystrtohex(const inp: msestring; out value: longword): boolean;
begin
 result:= strtohex1(inp,value);
 if not result then begin
  result:= trystrtointvalue(ansistring(inp),value);
 end;
end;

function trystrtohex64(const inp: string; out value: qword): boolean;
begin
 result:= strtohex164(inp,value);
 if not result then begin
  result:= trystrtointvalue64(inp,value);
 end;
end;

function strtohex(const inp: string): longword;
begin
 if not trystrtohex(inp,result) then begin
  formaterror(inp);
 end;
end;

function strtohex(const inp: msestring): longword;
begin
 if not trystrtohex(inp,result) then begin
  formaterror(inp);
 end;
end;

function strtohex64(const inp: string): qword;
begin
 if not trystrtohex64(inp,result) then begin
  formaterror(inp);
 end;
end;

function trystrtointvalue(const inp: string; out value: longword): boolean;
var
 lint1: int64;
begin
 result:= false;
 if length(inp) > 0 then begin
  case inp[1] of
  '%': result:= strtobin1(copy(inp,2,length(inp)-1),value);
  '&': result:= strtooct1(copy(inp,2,length(inp)-1),value);
  '#': result:= strtodec1(copy(inp,2,length(inp)-1),value);
  '$': result:= trystrtohex(copy(inp,2,length(inp)-1),value);
   else begin
    if (length(inp) > 2) and
           ((inp[2] = 'x') or (inp[2] = 'X')) and (inp[1] = '0') then begin
     result:= trystrtohex(copy(inp,3,length(inp)-2),value);
    end
    else begin
     result:= trystrtoint64(inp,lint1);
     if result then begin
      value:= lint1;
     end;
    end;
   end;
  end;
 end;
end;

function trystrtointvalue64(const inp: string; out value: qword): boolean;
var
 lint1: int64;
begin
 result:= false;
 if length(inp) > 0 then begin
  case inp[1] of
  '%': result:= strtobin164(copy(inp,2,length(inp)-1),value);
  '&': result:= strtooct164(copy(inp,2,length(inp)-1),value);
  '#': result:= strtodec164(copy(inp,2,length(inp)-1),value);
  '$': result:= strtohex164(copy(inp,2,length(inp)-1),value);
   else begin
    if (length(inp) > 2) and
           ((inp[2] = 'x') or (inp[2] = 'X')) and (inp[1] = '0') then begin
     result:= strtohex164(copy(inp,3,length(inp)-2),value);
    end
    else begin
     if (inp <> '') and (inp[1] = '-') then begin
      result:= trystrtoint64(inp,lint1);
     end
     else begin
      result:= trystrtoqword(inp,qword(lint1));
     end;
     if result then begin
      value:= lint1;
     end;
    end;
   end;
  end;
 end;
end;

function strtointvalue(const inp: string): longword;
begin
 if not trystrtointvalue(inp,result) then begin
  formaterror(inp);
 end;
end;

function strtointvalue64(const inp: string): qword;
begin
 if not trystrtointvalue64(inp,result) then begin
  formaterror(inp);
 end;
end;

//todo: 64bit

function strtoptruint(const inp: string): ptruint;
begin
 result:= strtointvalue(inp);
end;

function trystrtoptruint(const inp: string; out value: ptruint): boolean;
begin
 {$ifdef CPU64}
 result:= trystrtointvalue64(inp,qword(value));
 {$else}
 result:= trystrtointvalue(inp,longword(value));
 {$endif}
end;

function inttostrlen(inp: integer; len: integer;
     rechtsbuendig: boolean = true; fillchar: char = ' '): ansistring;
 //wandelt integer in string fester laenge
var
 int1: integer;
begin
 result:= inttostr(inp);
 int1:= length(result);
 setlength(result,len);
 if int1 < len then begin
  if rechtsbuendig then begin
   move(result[1],result[len-int1+1],int1);
   system.fillchar(result[1],len-int1,fillchar);
  end
  else begin
   system.fillchar(result[int1+1],len-int1,fillchar);
  end;
 end
 else begin
  if int1 > len then begin
   system.fillchar(result[1],len,fc_keinplatzchar);
  end;
 end;
end;

function inttostrlenmse(inp: integer; len: integer;
     rechtsbuendig: boolean = true; fillchar: msechar = ' '): msestring;
 //wandelt integer in string fester laenge
var
 int1: integer;
begin
 result:= inttostrmse(inp);
 int1:= length(result);
 setlength(result,len);
 if int1 < len then begin
  if rechtsbuendig then begin
   move(result[1],result[len-int1+1],int1*sizeof(msechar));
   system.fillword(result[1],len-int1,card16(fillchar));
  end
  else begin
   system.fillword(result[int1+1],len-int1,card16(fillchar));
  end;
 end
 else begin
  if int1 > len then begin
   system.fillword(result[1],len,card16(msechar(fc_keinplatzchar)));
  end;
 end;
end;

procedure msestrtotvarrec(const value: ansistring; out varrec: tvarrec);
begin
 varrec.vtype:= vtansistring;
 varrec.vansistring:= pointer(value);
end;

procedure msestrtotvarrec(const value: msestring; out varrec: tvarrec);
begin
{$ifdef mse_hasvtunicodestring}
 varrec.vtype:= vtunicodestring;
 varrec.vunicodestring:= pointer(value); //msestringimplementation
{$else}
 varrec.vtype:= vtwidestring;
 varrec.vwidestring:= pointer(value); //msestringimplementation
{$endif}
end;

function tvarrectoansistring(const value: tvarrec): ansistring;
begin
 with value do begin
  case vtype of
   vtAnsiString: begin
    result:= ansistring(VAnsiString);
   end;
   vtInteger: begin
    result:= inttostr(VInteger);
   end;
   vtBoolean: begin
    result:= booltostr(VBoolean);
   end;
   vtChar: begin
    result:= VChar;
   end;
   vtWideChar: begin
    result:= ansistring(VWideChar);
   end;
   vtExtended: begin
    result:= ansistring(doubletostring(VExtended^));
   end;
   vtString: begin
    result:= VString^;
   end;
   vtPointer: begin
    result:= hextostr(VPointer);
   end;
   vtPChar: begin
    result:= VPChar;
   end;
   vtObject: begin
    result:= hextostr(VObject);
   end;
   vtClass: begin
    result:= hextostr(VClass);
   end;
   vtPWideChar: begin
    result:= ansistring(unicodestring(VPWideChar));
   end;
   vtCurrency: begin
    result:= currtostr(VCurrency^);
   end;
   vtVariant: begin
    result:= VVariant^;
   end;
   vtInterface: begin
    result:= hextostr(VInterface);
   end;
   vtWideString: begin
    result:= ansistring(widestring(VWideString));
   end;
   vtInt64: begin
    result:= inttostr(VInt64^);
   end;
   vtUnicodeString: begin
    result:= ansistring(unicodestring(VUnicodeString));
   end;
   vtQWord: begin
    result:= inttostr(VQWord^);
   end
   else begin
    result:= '';
   end;
  end;
 end;
end;

function tvarrectomsestring(const value: tvarrec): msestring;
begin
 with value do begin
  case vtype of
   vtUnicodeString: begin
    result:= unicodestring(VUnicodeString);
   end;
   vtInteger: begin
    result:= inttostrmse(VInteger);
   end;
   vtBoolean: begin
    result:= msestring(booltostr(VBoolean));
   end;
   vtChar: begin
    result:= msestring(VChar);
   end;
   vtWideChar: begin
    result:= VWideChar;
   end;
   vtExtended: begin
    result:= doubletostring(VExtended^);
   end;
   vtString: begin
    result:= msestring(VString^);
   end;
   vtPointer: begin
    result:= msestring(hextostr(VPointer));
   end;
   vtPChar: begin
    result:= VPChar;
   end;
   vtObject: begin
    result:= msestring(hextostr(VObject));
   end;
   vtClass: begin
    result:= msestring(hextostr(VClass));
   end;
   vtPWideChar: begin
    result:= unicodestring(VPWideChar);
   end;
   vtAnsiString: begin
    result:= msestring(ansistring(VAnsiString));
   end;
   vtCurrency: begin
    result:= msestring(currtostr(VCurrency^));
   end;
   vtVariant: begin
    result:= VVariant^;
   end;
   vtInterface: begin
    result:= msestring(hextostr(VInterface));
   end;
   vtWideString: begin
    result:= widestring(VWideString);
   end;
   vtInt64: begin
    result:= inttostrmse(VInt64^);
   end;
   vtQWord: begin
    result:= inttostrmse(VQWord^);
   end
   else begin
    result:= '';
   end;
  end;
 end;
end;

{ tformatmacrolist }

procedure tformatmacrolist.addmac(const aname: msestring;
               const avalue: msestring; const ahandler: macrohandlerty = nil);
begin
 add([aname],[avalue],[ahandler]);
end;

procedure clearformatmacros;
begin
 freeandnil(fformatmacros);
end;

initialization
{$ifndef FPC}
 {$ifdef mswindows}
 getlocaleformatsettings(0,defaultformatsettingsdot);
 {$else}
 defaultformatsettingsdot:= defaultformatsettings;
 {$endif}
{$else}
 defaultformatsettingsdot:= sysutils.defaultformatsettings;
{$endif}
 defaultformatsettingsdot.DecimalSeparator:= '.';
finalization
 clearformatmacros;
end.
