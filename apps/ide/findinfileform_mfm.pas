unit findinfileform_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface

implementation
uses
 mseclasses,findinfileform;

const
 objdata: record size: integer; data: array[0..2967] of byte end =
      (size: 2968; data: (
  84,80,70,48,13,116,102,105,110,100,105,110,102,105,108,101,102,111,12,102,
  105,110,100,105,110,102,105,108,101,102,111,15,102,114,97,109,101,46,103,114,
  105,112,95,115,105,122,101,2,10,18,102,114,97,109,101,46,103,114,105,112,
  95,111,112,116,105,111,110,115,11,14,103,111,95,99,108,111,115,101,98,117,
  116,116,111,110,16,103,111,95,102,105,120,115,105,122,101,98,117,116,116,111,
  110,12,103,111,95,116,111,112,98,117,116,116,111,110,0,11,102,114,97,109,
  101,46,100,117,109,109,121,2,0,7,118,105,115,105,98,108,101,8,8,98,
  111,117,110,100,115,95,120,3,36,2,8,98,111,117,110,100,115,95,121,2,
  115,9,98,111,117,110,100,115,95,99,120,3,113,1,9,98,111,117,110,100,
  115,95,99,121,3,198,0,16,99,111,110,116,97,105,110,101,114,46,98,111,
  117,110,100,115,1,2,0,2,0,3,103,1,3,198,0,0,22,100,114,97,
  103,100,111,99,107,46,115,112,108,105,116,116,101,114,95,115,105,122,101,2,
  0,16,100,114,97,103,100,111,99,107,46,99,97,112,116,105,111,110,6,11,
  70,105,110,100,114,101,115,117,108,116,115,20,100,114,97,103,100,111,99,107,
  46,111,112,116,105,111,110,115,100,111,99,107,11,10,111,100,95,115,97,118,
  101,112,111,115,13,111,100,95,115,97,118,101,122,111,114,100,101,114,10,111,
  100,95,99,97,110,109,111,118,101,11,111,100,95,99,97,110,102,108,111,97,
  116,10,111,100,95,99,97,110,100,111,99,107,11,111,100,95,112,114,111,112,
  115,105,122,101,0,7,111,112,116,105,111,110,115,11,10,102,111,95,115,97,
  118,101,112,111,115,13,102,111,95,115,97,118,101,122,111,114,100,101,114,0,
  8,115,116,97,116,102,105,108,101,7,22,109,97,105,110,102,111,46,112,114,
  111,106,101,99,116,115,116,97,116,102,105,108,101,7,99,97,112,116,105,111,
  110,6,20,70,105,110,100,32,105,110,32,102,105,108,101,32,114,101,115,117,
  108,116,115,21,105,99,111,110,46,116,114,97,110,115,112,97,114,101,110,116,
  99,111,108,111,114,4,6,0,0,128,10,105,99,111,110,46,105,109,97,103,
  101,10,172,8,0,0,0,0,0,0,0,0,0,0,24,0,0,0,24,0,
  0,0,120,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,245,245,
  245,1,243,243,243,1,242,242,242,1,240,240,240,1,238,238,238,1,237,237,
  237,1,235,235,235,1,234,234,234,1,232,232,232,1,230,230,230,1,229,229,
  229,1,227,227,227,1,226,226,226,1,224,224,224,1,223,223,223,1,221,221,
  221,1,219,219,219,1,218,218,218,1,216,216,216,1,215,215,215,1,213,213,
  213,1,211,211,211,1,210,210,210,1,208,208,208,1,245,245,245,1,243,243,
  243,1,242,242,242,1,240,240,240,1,238,238,238,1,237,237,237,1,235,235,
  235,1,234,234,234,1,232,232,232,1,224,224,224,1,211,211,211,1,221,221,
  221,1,226,226,226,1,224,224,224,1,223,223,223,1,221,221,221,1,219,219,
  219,1,218,218,218,1,216,216,216,1,215,215,215,1,213,213,213,1,211,211,
  211,1,210,210,210,1,208,208,208,1,245,245,245,1,243,243,243,1,242,242,
  242,1,240,240,240,1,238,238,238,1,237,237,237,1,217,217,217,1,180,180,
  180,1,163,163,163,1,153,153,153,3,162,162,162,1,175,175,175,1,204,204,
  204,1,219,219,219,2,218,218,218,1,216,216,216,1,215,215,215,1,213,213,
  213,1,211,211,211,1,210,210,210,1,208,208,208,1,245,245,245,1,243,243,
  243,1,242,242,242,1,240,240,240,1,235,235,235,1,191,191,191,1,154,154,
  154,1,162,160,160,1,187,180,180,1,208,199,200,1,225,210,212,1,209,196,
  197,1,188,179,180,1,162,159,159,1,154,154,154,1,169,169,169,1,210,210,
  210,1,217,217,217,1,216,216,216,1,215,215,215,1,213,213,213,1,211,211,
  211,1,210,210,210,1,208,208,208,1,245,245,245,1,243,243,243,1,242,242,
  242,1,234,234,234,1,167,167,167,1,153,153,153,1,193,183,183,1,246,226,
  228,1,253,235,237,1,255,235,237,1,255,232,235,1,255,230,233,1,255,227,
  230,1,251,222,225,1,196,182,184,1,153,153,153,2,198,198,198,1,213,213,
  213,1,215,215,215,1,213,213,213,1,211,211,211,1,210,210,210,1,208,208,
  208,1,245,245,245,1,243,243,243,1,242,242,242,1,185,185,185,1,154,154,
  154,1,219,202,203,1,250,228,230,1,253,233,235,1,255,235,238,1,255,233,
  235,1,255,230,233,1,255,228,231,1,255,225,229,1,255,223,226,1,255,220,
  224,1,225,198,202,1,153,153,153,1,141,141,141,1,182,182,182,1,212,212,
  212,1,213,213,213,1,211,211,211,1,210,210,210,1,208,208,208,1,245,245,
  245,1,243,243,243,1,215,215,215,1,153,153,153,1,198,186,187,1,249,227,
  228,1,252,232,234,1,255,236,238,1,207,190,192,1,116,105,106,1,47,42,
  43,1,73,65,66,1,190,166,169,1,255,221,225,1,255,218,222,1,255,216,
  220,1,202,182,184,1,153,153,153,1,129,129,129,1,198,198,198,1,212,212,
  212,1,211,211,211,1,210,210,210,1,208,208,208,1,245,245,245,1,243,243,
  243,1,167,166,166,1,169,165,166,1,246,225,226,1,251,231,232,1,254,236,
  238,1,241,221,223,1,15,14,14,1,122,110,111,1,207,183,187,1,124,109,
  110,1,10,9,9,1,238,204,208,1,255,216,221,1,255,214,218,1,253,211,
  216,1,170,163,164,1,147,146,146,1,145,145,145,1,205,205,205,1,211,211,
  211,1,210,210,210,1,208,208,208,1,245,245,245,1,237,237,237,1,153,153,
  153,1,203,191,192,1,250,230,231,1,253,235,237,1,255,235,237,1,146,133,
  135,1,46,41,42,1,255,227,230,1,255,225,228,1,255,222,226,1,55,47,
  48,1,140,119,121,1,255,214,219,1,255,212,217,2,207,184,187,1,153,153,
  153,1,109,109,109,1,180,180,180,1,209,209,209,1,210,210,210,1,208,208,
  208,1,245,245,245,1,218,218,218,1,153,153,153,1,223,207,209,1,253,233,
  235,1,255,235,238,1,255,233,235,1,255,230,233,1,251,224,227,1,255,225,
  229,1,255,223,226,1,249,215,219,1,42,36,37,1,149,126,129,1,255,212,
  217,3,227,196,199,1,153,153,153,1,115,115,115,1,154,154,154,1,207,207,
  207,1,210,210,210,1,208,208,208,1,245,245,245,1,202,202,202,1,153,153,
  153,1,243,225,227,1,255,236,238,1,255,233,236,1,255,231,234,1,255,228,
  231,1,255,226,229,1,255,223,227,1,250,217,221,1,82,70,71,1,56,47,
  48,1,246,205,210,1,255,212,217,3,246,207,211,1,153,153,153,1,125,125,
  125,1,132,132,132,1,205,205,205,1,210,210,210,1,208,208,208,1,245,245,
  245,1,209,209,209,1,153,153,153,1,236,221,223,1,255,234,236,1,255,232,
  234,1,255,229,232,1,255,226,230,1,255,224,227,1,255,221,225,1,101,87,
  88,1,47,40,41,1,235,197,201,1,255,212,217,4,237,202,206,1,153,153,
  153,1,119,119,119,1,112,112,112,1,204,204,204,1,210,210,210,1,208,208,
  208,1,245,245,245,1,227,227,227,1,153,153,153,1,217,204,206,1,255,232,
  235,1,255,230,232,1,255,227,230,1,255,224,228,1,255,222,226,1,249,214,
  218,1,3,3,3,1,208,175,179,1,255,212,217,5,217,190,193,1,153,153,
  153,1,107,107,107,1,112,112,112,1,204,204,204,1,210,210,210,1,208,208,
  208,1,245,245,245,1,242,242,242,1,156,156,156,1,195,186,187,1,255,230,
  233,1,255,228,231,1,255,225,228,1,255,223,226,1,255,220,224,1,238,203,
  207,1,103,87,88,1,247,205,210,1,255,212,217,5,195,177,180,1,152,152,
  152,1,101,101,101,1,131,131,131,1,204,204,204,1,210,210,210,1,208,208,
  208,1,245,245,245,1,243,243,243,1,183,183,183,1,155,154,154,1,236,214,
  216,1,255,226,229,1,255,223,227,1,255,221,225,1,255,218,222,1,239,202,
  206,1,167,139,143,1,242,201,206,1,255,212,217,4,236,201,205,1,154,153,
  153,1,133,133,133,1,101,101,101,1,152,152,152,1,207,207,207,1,210,210,
  210,1,208,208,208,1,245,245,245,1,243,243,243,1,232,232,232,1,158,158,
  158,1,171,166,167,1,253,223,226,1,255,221,225,1,255,219,223,1,255,216,
  221,1,208,174,178,1,0,0,0,1,215,179,183,1,255,212,217,3,253,211,
  216,1,171,163,164,1,150,151,152,1,88,128,147,1,105,107,108,1,178,178,
  178,1,209,209,209,1,210,210,210,1,208,208,208,1,245,245,245,1,243,243,
  243,1,242,242,242,1,206,206,206,1,153,153,153,1,178,170,171,1,243,211,
  215,1,255,217,221,1,255,214,219,1,255,212,217,5,243,205,210,1,178,167,
  169,1,153,153,153,1,140,173,190,1,102,164,195,1,84,136,162,1,183,185,
  186,1,211,211,211,1,210,210,210,1,208,208,208,1,245,245,245,1,243,243,
  243,1,242,242,242,1,239,239,239,1,192,192,192,1,153,152,152,1,157,155,
  155,1,211,188,191,1,241,204,208,1,255,212,217,3,241,204,208,1,211,187,
  189,1,157,155,155,1,152,152,153,1,150,176,189,1,167,202,221,1,134,183,
  208,1,103,164,195,1,84,137,163,1,190,192,193,1,210,210,210,1,208,208,
  208,1,245,245,245,1,243,243,243,1,242,242,242,1,240,240,240,1,234,234,
  234,1,191,191,191,1,147,146,146,1,153,153,153,2,157,155,156,1,172,163,
  164,1,157,155,156,1,153,153,153,2,140,139,139,1,97,139,160,1,116,172,
  201,1,148,191,213,1,167,202,221,1,135,183,208,1,103,164,195,1,87,139,
  165,1,185,187,188,1,208,208,208,1,245,245,245,1,243,243,243,1,242,242,
  242,1,240,240,240,1,238,238,238,1,233,233,233,1,213,213,213,1,151,151,
  151,1,129,129,129,1,135,135,135,1,142,142,142,1,133,133,133,1,123,123,
  123,1,114,114,114,1,106,106,106,1,105,111,114,1,90,147,176,1,116,172,
  200,1,148,191,213,1,167,202,221,1,135,183,208,1,103,164,195,1,84,137,
  163,1,183,185,186,1,245,245,245,1,243,243,243,1,242,242,242,1,240,240,
  240,1,238,238,238,1,237,237,237,1,234,234,234,1,226,226,226,1,192,192,
  192,1,162,162,162,1,137,137,137,1,117,117,117,1,116,116,116,1,134,134,
  134,1,157,157,157,1,183,183,183,1,192,198,201,1,93,150,179,1,116,172,
  200,1,148,191,213,1,167,202,221,1,135,183,208,1,103,164,195,1,95,135,
  155,1,245,245,245,1,243,243,243,1,242,242,242,1,240,240,240,1,238,238,
  238,1,237,237,237,1,235,235,235,1,234,234,234,1,229,229,229,1,225,225,
  225,1,222,222,222,1,218,218,218,1,217,217,217,2,219,219,219,1,218,218,
  218,1,219,219,219,1,199,205,208,1,94,151,180,1,116,172,200,1,148,191,
  213,1,167,203,221,1,134,182,205,1,98,115,124,1,245,245,245,1,243,243,
  243,1,242,242,242,1,240,240,240,1,238,238,238,1,237,237,237,1,235,235,
  235,1,234,234,234,1,232,232,232,1,230,230,230,1,229,229,229,1,227,227,
  227,1,226,226,226,1,224,224,224,1,223,223,223,1,221,221,221,1,219,219,
  219,1,218,218,218,1,197,203,206,1,94,151,179,1,116,172,200,1,147,189,
  210,1,117,128,134,1,94,94,94,1,245,245,245,1,243,243,243,1,242,242,
  242,1,240,240,240,1,238,238,238,1,237,237,237,1,235,235,235,1,234,234,
  234,1,232,232,232,1,230,230,230,1,229,229,229,1,227,227,227,1,226,226,
  226,1,224,224,224,1,223,223,223,1,221,221,221,1,219,219,219,1,218,218,
  218,1,216,216,216,1,196,202,205,1,105,149,171,1,108,124,133,1,95,95,
  95,1,125,125,125,1,15,109,111,100,117,108,101,99,108,97,115,115,110,97,
  109,101,6,9,116,100,111,99,107,102,111,114,109,0,10,116,116,97,98,119,
  105,100,103,101,116,4,116,97,98,115,8,98,111,117,110,100,115,95,120,2,
  0,8,98,111,117,110,100,115,95,121,2,0,9,98,111,117,110,100,115,95,
  99,120,3,103,1,9,98,111,117,110,100,115,95,99,121,3,198,0,7,97,
  110,99,104,111,114,115,11,0,11,116,97,98,95,111,112,116,105,111,110,115,
  11,15,116,97,98,111,95,100,114,97,103,115,111,117,114,99,101,13,116,97,
  98,111,95,100,114,97,103,100,101,115,116,13,116,97,98,111,95,111,112,112,
  111,115,105,116,101,23,116,97,98,111,95,100,98,108,99,108,105,99,107,101,
  100,116,97,98,102,105,114,115,116,20,116,97,98,111,95,104,105,110,116,99,
  108,105,112,112,101,100,116,101,120,116,0,21,116,97,98,95,102,114,97,109,
  101,46,98,117,116,116,111,110,115,108,97,115,116,9,8,116,97,98,95,115,
  105,122,101,2,18,0,0,0)
 );

initialization
 registerobjectdata(@objdata,tfindinfilefo,'');
end.
