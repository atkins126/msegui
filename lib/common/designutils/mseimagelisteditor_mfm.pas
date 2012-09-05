unit mseimagelisteditor_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface

implementation
uses
 mseclasses,mseimagelisteditor;

const
 objdata: record size: integer; data: array[0..3969] of byte end =
      (size: 3970; data: (
  84,80,70,48,18,116,105,109,97,103,101,108,105,115,116,101,100,105,116,111,
  114,102,111,17,105,109,97,103,101,108,105,115,116,101,100,105,116,111,114,102,
  111,13,111,112,116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,95,
  97,114,114,111,119,102,111,99,117,115,15,111,119,95,97,114,114,111,119,102,
  111,99,117,115,105,110,16,111,119,95,97,114,114,111,119,102,111,99,117,115,
  111,117,116,11,111,119,95,115,117,98,102,111,99,117,115,17,111,119,95,100,
  101,115,116,114,111,121,119,105,100,103,101,116,115,9,111,119,95,104,105,110,
  116,111,110,0,7,118,105,115,105,98,108,101,8,8,98,111,117,110,100,115,
  95,120,3,220,0,8,98,111,117,110,100,115,95,121,3,41,1,9,98,111,
  117,110,100,115,95,99,120,3,45,1,9,98,111,117,110,100,115,95,99,121,
  3,103,1,23,99,111,110,116,97,105,110,101,114,46,111,112,116,105,111,110,
  115,119,105,100,103,101,116,11,13,111,119,95,109,111,117,115,101,102,111,99,
  117,115,11,111,119,95,116,97,98,102,111,99,117,115,13,111,119,95,97,114,
  114,111,119,102,111,99,117,115,15,111,119,95,97,114,114,111,119,102,111,99,
  117,115,105,110,16,111,119,95,97,114,114,111,119,102,111,99,117,115,111,117,
  116,11,111,119,95,115,117,98,102,111,99,117,115,19,111,119,95,109,111,117,
  115,101,116,114,97,110,115,112,97,114,101,110,116,17,111,119,95,100,101,115,
  116,114,111,121,119,105,100,103,101,116,115,0,29,99,111,110,116,97,105,110,
  101,114,46,102,114,97,109,101,46,122,111,111,109,119,105,100,116,104,115,116,
  101,112,2,1,30,99,111,110,116,97,105,110,101,114,46,102,114,97,109,101,
  46,122,111,111,109,104,101,105,103,104,116,115,116,101,112,2,1,16,99,111,
  110,116,97,105,110,101,114,46,98,111,117,110,100,115,1,2,0,2,0,3,
  45,1,3,103,1,0,7,111,112,116,105,111,110,115,11,13,102,111,95,99,
  108,111,115,101,111,110,101,115,99,17,102,111,95,108,111,99,97,108,115,104,
  111,114,116,99,117,116,115,15,102,111,95,97,117,116,111,114,101,97,100,115,
  116,97,116,16,102,111,95,97,117,116,111,119,114,105,116,101,115,116,97,116,
  10,102,111,95,115,97,118,101,112,111,115,12,102,111,95,115,97,118,101,115,
  116,97,116,101,0,8,115,116,97,116,102,105,108,101,7,9,115,116,97,116,
  102,105,108,101,49,7,99,97,112,116,105,111,110,6,15,73,109,97,103,101,
  108,105,115,116,101,100,105,116,111,114,15,109,111,100,117,108,101,99,108,97,
  115,115,110,97,109,101,6,8,116,109,115,101,102,111,114,109,0,9,116,108,
  105,115,116,118,105,101,119,4,100,105,115,112,14,111,112,116,105,111,110,115,
  119,105,100,103,101,116,49,11,19,111,119,49,95,102,111,110,116,103,108,121,
  112,104,104,101,105,103,104,116,0,8,98,111,117,110,100,115,95,120,2,0,
  8,98,111,117,110,100,115,95,121,2,0,9,98,111,117,110,100,115,95,99,
  120,3,45,1,9,98,111,117,110,100,115,95,99,121,3,47,1,7,97,110,
  99,104,111,114,115,11,6,97,110,95,116,111,112,9,97,110,95,98,111,116,
  116,111,109,0,10,99,101,108,108,104,101,105,103,104,116,2,62,11,111,112,
  116,105,111,110,115,103,114,105,100,11,12,111,103,95,99,111,108,115,105,122,
  105,110,103,12,111,103,95,114,111,119,115,105,122,105,110,103,19,111,103,95,
  102,111,99,117,115,99,101,108,108,111,110,101,110,116,101,114,10,111,103,95,
  119,114,97,112,114,111,119,10,111,103,95,119,114,97,112,99,111,108,12,111,
  103,95,97,117,116,111,112,111,112,117,112,0,7,111,112,116,105,111,110,115,
  11,12,108,118,111,95,114,101,97,100,111,110,108,121,15,108,118,111,95,109,
  111,117,115,101,109,111,118,105,110,103,13,108,118,111,95,107,101,121,109,111,
  118,105,110,103,8,108,118,111,95,104,111,114,122,13,108,118,111,95,100,114,
  97,119,102,111,99,117,115,15,108,118,111,95,102,111,99,117,115,115,101,108,
  101,99,116,15,108,118,111,95,109,111,117,115,101,115,101,108,101,99,116,13,
  108,118,111,95,107,101,121,115,101,108,101,99,116,15,108,118,111,95,109,117,
  108,116,105,115,101,108,101,99,116,10,108,118,111,95,108,111,99,97,116,101,
  0,19,105,116,101,109,108,105,115,116,46,99,97,112,116,105,111,110,112,111,
  115,7,9,99,112,95,98,111,116,116,111,109,18,105,116,101,109,108,105,115,
  116,46,105,109,97,103,101,108,105,115,116,7,9,105,109,97,103,101,108,105,
  115,116,19,105,116,101,109,108,105,115,116,46,105,109,97,103,101,119,105,100,
  116,104,2,16,20,105,116,101,109,108,105,115,116,46,105,109,97,103,101,104,
  101,105,103,104,116,2,16,15,111,110,108,97,121,111,117,116,99,104,97,110,
  103,101,100,7,13,108,97,121,111,117,116,99,104,97,110,103,101,100,11,111,
  110,105,116,101,109,101,118,101,110,116,7,15,100,105,115,112,111,110,105,116,
  101,109,101,118,101,110,116,12,111,110,105,116,101,109,115,109,111,118,101,100,
  7,16,100,105,115,112,111,110,105,116,101,109,115,109,111,118,101,100,13,114,
  101,102,102,111,110,116,104,101,105,103,104,116,2,14,0,0,9,116,108,97,
  121,111,117,116,101,114,10,116,108,97,121,111,117,116,101,114,49,19,102,114,
  97,109,101,46,102,114,97,109,101,105,95,98,111,116,116,111,109,2,5,16,
  102,114,97,109,101,46,108,111,99,97,108,112,114,111,112,115,11,12,102,114,
  108,95,102,105,98,111,116,116,111,109,0,11,102,114,97,109,101,46,100,117,
  109,109,121,2,0,8,116,97,98,111,114,100,101,114,2,1,8,98,111,117,
  110,100,115,95,120,2,0,8,98,111,117,110,100,115,95,121,3,50,1,9,
  98,111,117,110,100,115,95,99,120,3,39,1,9,98,111,117,110,100,115,95,
  99,121,2,53,7,97,110,99,104,111,114,115,11,7,97,110,95,108,101,102,
  116,9,97,110,95,98,111,116,116,111,109,0,12,111,112,116,105,111,110,115,
  115,99,97,108,101,11,11,111,115,99,95,101,120,112,97,110,100,120,11,111,
  115,99,95,115,104,114,105,110,107,120,11,111,115,99,95,101,120,112,97,110,
  100,121,11,111,115,99,95,115,104,114,105,110,107,121,0,7,108,105,110,107,
  116,111,112,7,4,100,105,115,112,8,100,105,115,116,95,116,111,112,2,3,
  7,111,112,116,105,111,110,115,11,15,115,112,97,111,95,103,108,117,101,98,
  111,116,116,111,109,0,0,9,116,108,97,121,111,117,116,101,114,3,108,97,
  50,8,116,97,98,111,114,100,101,114,2,1,8,98,111,117,110,100,115,95,
  120,2,0,8,98,111,117,110,100,115,95,121,2,27,9,98,111,117,110,100,
  115,95,99,120,3,39,1,9,98,111,117,110,100,115,95,99,121,2,21,7,
  97,110,99,104,111,114,115,11,6,97,110,95,116,111,112,0,12,111,112,116,
  105,111,110,115,115,99,97,108,101,11,11,111,115,99,95,101,120,112,97,110,
  100,120,11,111,115,99,95,115,104,114,105,110,107,120,11,111,115,99,95,101,
  120,112,97,110,100,121,11,111,115,99,95,115,104,114,105,110,107,121,0,8,
  100,105,115,116,95,116,111,112,2,4,13,111,112,116,105,111,110,115,108,97,
  121,111,117,116,11,10,108,97,111,95,97,108,105,103,110,121,0,0,9,116,
  108,97,121,111,117,116,101,114,10,116,108,97,121,111,117,116,101,114,50,8,
  116,97,98,111,114,100,101,114,2,1,8,98,111,117,110,100,115,95,120,2,
  80,8,98,111,117,110,100,115,95,121,2,0,9,98,111,117,110,100,115,95,
  99,120,3,215,0,9,98,111,117,110,100,115,95,99,121,2,21,12,111,112,
  116,105,111,110,115,115,99,97,108,101,11,11,111,115,99,95,101,120,112,97,
  110,100,120,11,111,115,99,95,115,104,114,105,110,107,120,11,111,115,99,95,
  101,120,112,97,110,100,121,11,111,115,99,95,115,104,114,105,110,107,121,0,
  8,100,105,115,116,95,116,111,112,2,3,13,111,112,116,105,111,110,115,108,
  97,121,111,117,116,11,10,108,97,111,95,112,108,97,99,101,120,0,13,112,
  108,97,99,101,95,109,105,110,100,105,115,116,2,5,13,112,108,97,99,101,
  95,109,97,120,100,105,115,116,2,5,0,7,116,98,117,116,116,111,110,2,
  111,107,14,111,112,116,105,111,110,115,119,105,100,103,101,116,49,11,19,111,
  119,49,95,102,111,110,116,103,108,121,112,104,104,101,105,103,104,116,13,111,
  119,49,95,97,117,116,111,115,99,97,108,101,13,111,119,49,95,97,117,116,
  111,119,105,100,116,104,0,8,116,97,98,111,114,100,101,114,2,2,8,98,
  111,117,110,100,115,95,120,2,110,8,98,111,117,110,100,115,95,121,2,1,
  9,98,111,117,110,100,115,95,99,120,2,50,9,98,111,117,110,100,115,95,
  99,121,2,20,12,98,111,117,110,100,115,95,99,120,109,105,110,2,50,5,
  115,116,97,116,101,11,10,97,115,95,100,101,102,97,117,108,116,15,97,115,
  95,108,111,99,97,108,100,101,102,97,117,108,116,15,97,115,95,108,111,99,
  97,108,99,97,112,116,105,111,110,0,7,99,97,112,116,105,111,110,6,3,
  38,79,75,11,109,111,100,97,108,114,101,115,117,108,116,7,5,109,114,95,
  111,107,13,114,101,102,102,111,110,116,104,101,105,103,104,116,2,14,0,0,
  7,116,98,117,116,116,111,110,6,99,97,110,99,101,108,14,111,112,116,105,
  111,110,115,119,105,100,103,101,116,49,11,19,111,119,49,95,102,111,110,116,
  103,108,121,112,104,104,101,105,103,104,116,13,111,119,49,95,97,117,116,111,
  115,99,97,108,101,13,111,119,49,95,97,117,116,111,119,105,100,116,104,0,
  8,116,97,98,111,114,100,101,114,2,3,8,98,111,117,110,100,115,95,120,
  3,165,0,8,98,111,117,110,100,115,95,121,2,1,9,98,111,117,110,100,
  115,95,99,120,2,50,9,98,111,117,110,100,115,95,99,121,2,20,12,98,
  111,117,110,100,115,95,99,120,109,105,110,2,50,5,115,116,97,116,101,11,
  15,97,115,95,108,111,99,97,108,99,97,112,116,105,111,110,0,7,99,97,
  112,116,105,111,110,6,7,38,67,97,110,99,101,108,11,109,111,100,97,108,
  114,101,115,117,108,116,7,9,109,114,95,99,97,110,99,101,108,13,114,101,
  102,102,111,110,116,104,101,105,103,104,116,2,14,0,0,7,116,98,117,116,
  116,111,110,5,99,108,101,97,114,14,111,112,116,105,111,110,115,119,105,100,
  103,101,116,49,11,19,111,119,49,95,102,111,110,116,103,108,121,112,104,104,
  101,105,103,104,116,13,111,119,49,95,97,117,116,111,115,99,97,108,101,13,
  111,119,49,95,97,117,116,111,119,105,100,116,104,0,8,116,97,98,111,114,
  100,101,114,2,1,8,98,111,117,110,100,115,95,120,2,55,8,98,111,117,
  110,100,115,95,121,2,1,9,98,111,117,110,100,115,95,99,120,2,50,9,
  98,111,117,110,100,115,95,99,121,2,20,12,98,111,117,110,100,115,95,99,
  120,109,105,110,2,50,5,115,116,97,116,101,11,15,97,115,95,108,111,99,
  97,108,99,97,112,116,105,111,110,17,97,115,95,108,111,99,97,108,111,110,
  101,120,101,99,117,116,101,0,7,99,97,112,116,105,111,110,6,6,67,38,
  108,101,97,114,9,111,110,101,120,101,99,117,116,101,7,14,99,108,101,97,
  114,111,110,101,120,101,99,117,116,101,13,114,101,102,102,111,110,116,104,101,
  105,103,104,116,2,14,0,0,7,116,98,117,116,116,111,110,3,97,100,100,
  14,111,112,116,105,111,110,115,119,105,100,103,101,116,49,11,19,111,119,49,
  95,102,111,110,116,103,108,121,112,104,104,101,105,103,104,116,13,111,119,49,
  95,97,117,116,111,115,99,97,108,101,13,111,119,49,95,97,117,116,111,119,
  105,100,116,104,0,8,98,111,117,110,100,115,95,120,2,0,8,98,111,117,
  110,100,115,95,121,2,1,9,98,111,117,110,100,115,95,99,120,2,50,9,
  98,111,117,110,100,115,95,99,121,2,20,12,98,111,117,110,100,115,95,99,
  120,109,105,110,2,50,5,115,116,97,116,101,11,15,97,115,95,108,111,99,
  97,108,99,97,112,116,105,111,110,17,97,115,95,108,111,99,97,108,111,110,
  101,120,101,99,117,116,101,0,7,99,97,112,116,105,111,110,6,4,38,65,
  100,100,9,111,110,101,120,101,99,117,116,101,7,12,97,100,100,111,110,101,
  120,101,99,117,116,101,13,114,101,102,102,111,110,116,104,101,105,103,104,116,
  2,14,0,0,0,12,116,98,111,111,108,101,97,110,101,100,105,116,7,115,
  116,114,101,116,99,104,13,102,114,97,109,101,46,99,97,112,116,105,111,110,
  6,8,38,115,116,114,101,116,99,104,11,102,114,97,109,101,46,100,117,109,
  109,121,2,0,16,102,114,97,109,101,46,111,117,116,101,114,102,114,97,109,
  101,1,2,0,2,1,2,40,2,2,0,8,98,111,117,110,100,115,95,120,
  2,6,8,98,111,117,110,100,115,95,121,2,3,9,98,111,117,110,100,115,
  95,99,120,2,53,9,98,111,117,110,100,115,95,99,121,2,16,8,115,116,
  97,116,102,105,108,101,7,9,115,116,97,116,102,105,108,101,49,5,118,97,
  108,117,101,9,0,0,0,9,116,108,97,121,111,117,116,101,114,3,108,97,
  49,8,98,111,117,110,100,115,95,120,2,0,8,98,111,117,110,100,115,95,
  121,2,0,9,98,111,117,110,100,115,95,99,120,3,30,1,9,98,111,117,
  110,100,115,95,99,121,2,24,12,111,112,116,105,111,110,115,115,99,97,108,
  101,11,11,111,115,99,95,101,120,112,97,110,100,120,11,111,115,99,95,115,
  104,114,105,110,107,120,11,111,115,99,95,101,120,112,97,110,100,121,11,111,
  115,99,95,115,104,114,105,110,107,121,0,10,108,105,110,107,98,111,116,116,
  111,109,7,3,108,97,50,11,100,105,115,116,95,98,111,116,116,111,109,2,
  3,13,111,112,116,105,111,110,115,108,97,121,111,117,116,11,10,108,97,111,
  95,97,108,105,103,110,121,0,0,10,116,99,111,108,111,114,101,100,105,116,
  16,116,114,97,110,115,112,97,114,101,110,116,99,111,108,111,114,13,102,114,
  97,109,101,46,99,97,112,116,105,111,110,6,18,38,84,114,97,110,115,112,
  97,114,101,110,116,32,99,111,108,111,114,16,102,114,97,109,101,46,99,97,
  112,116,105,111,110,112,111,115,7,8,99,112,95,114,105,103,104,116,18,102,
  114,97,109,101,46,98,117,116,116,111,110,46,119,105,100,116,104,2,13,18,
  102,114,97,109,101,46,98,117,116,116,111,110,46,99,111,108,111,114,4,2,
  0,0,128,25,102,114,97,109,101,46,98,117,116,116,111,110,101,108,108,105,
  112,115,101,46,119,105,100,116,104,2,13,25,102,114,97,109,101,46,98,117,
  116,116,111,110,101,108,108,105,112,115,101,46,99,111,108,111,114,4,2,0,
  0,128,27,102,114,97,109,101,46,98,117,116,116,111,110,101,108,108,105,112,
  115,101,46,105,109,97,103,101,110,114,2,17,16,102,114,97,109,101,46,111,
  117,116,101,114,102,114,97,109,101,1,2,0,2,0,2,100,2,0,0,8,
  116,97,98,111,114,100,101,114,2,1,8,98,111,117,110,100,115,95,120,2,
  80,8,98,111,117,110,100,115,95,121,2,4,9,98,111,117,110,100,115,95,
  99,120,3,206,0,8,115,116,97,116,102,105,108,101,7,9,115,116,97,116,
  102,105,108,101,49,5,118,97,108,117,101,4,1,0,0,128,16,100,114,111,
  112,100,111,119,110,46,111,112,116,105,111,110,115,11,16,100,101,111,95,97,
  117,116,111,100,114,111,112,100,111,119,110,15,100,101,111,95,107,101,121,100,
  114,111,112,100,111,119,110,0,13,114,101,102,102,111,110,116,104,101,105,103,
  104,116,2,14,0,0,12,116,98,111,111,108,101,97,110,101,100,105,116,6,
  109,97,115,107,101,100,13,102,114,97,109,101,46,99,97,112,116,105,111,110,
  6,7,38,109,97,115,107,101,100,11,102,114,97,109,101,46,100,117,109,109,
  121,2,0,16,102,114,97,109,101,46,111,117,116,101,114,102,114,97,109,101,
  1,2,0,2,1,2,48,2,2,0,8,98,111,117,110,100,115,95,120,2,
  6,8,98,111,117,110,100,115,95,121,2,7,9,98,111,117,110,100,115,95,
  99,120,2,61,9,98,111,117,110,100,115,95,99,121,2,16,5,118,97,108,
  117,101,9,0,0,0,0,10,116,105,109,97,103,101,108,105,115,116,9,105,
  109,97,103,101,108,105,115,116,16,116,114,97,110,115,112,97,114,101,110,116,
  99,111,108,111,114,4,1,0,0,128,4,108,101,102,116,2,24,3,116,111,
  112,3,176,0,0,0,11,116,102,105,108,101,100,105,97,108,111,103,10,102,
  105,108,101,100,105,97,108,111,103,8,115,116,97,116,102,105,108,101,7,9,
  115,116,97,116,102,105,108,101,49,4,108,101,102,116,2,112,3,116,111,112,
  3,176,0,0,0,9,116,115,116,97,116,102,105,108,101,9,115,116,97,116,
  102,105,108,101,49,8,102,105,108,101,110,97,109,101,6,15,105,109,97,103,
  101,108,105,115,116,101,100,105,116,111,114,7,111,112,116,105,111,110,115,11,
  10,115,102,111,95,109,101,109,111,114,121,0,4,108,101,102,116,3,200,0,
  3,116,111,112,3,176,0,0,0,0)
 );

initialization
 registerobjectdata(@objdata,timagelisteditorfo,'');
end.
