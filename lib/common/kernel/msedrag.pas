{ MSEgui Copyright (c) 1999-2014 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit msedrag;

{$ifdef FPC}{$mode objfpc}{$h+}{$interfaces corba}{$endif}

interface
uses
 msegraphutils,mseevent,classes,mseclasses,mseglob,mseguiglob,msedragglob,
 msegui,msetimer;
type
 idragcontroller = interface(inullinterface)
  function getwidget: twidget;
  function getdragrect(const apos: pointty): rectty;
 end;

type
 drageventty = procedure(const asender: tobject; const apos: pointty;
               var adragobject: tdragobject; var processed: boolean) of object;
 dragovereventty = procedure(const asender: tobject; const apos: pointty;
               var adragobject: tdragobject; var accept: boolean;
                                            var processed: boolean) of object;

 ttagdragobject = class(tdragobject)
  private
  protected
   ftag: integer;
  public
   constructor create(const asender: tobject; var instance: tdragobject;
            const apickpos: pointty; const tag: integer);
   function tag: integer;
 end;

 tobjectdragobject = class(tdragobject)
  private
  protected
   fdata: tobject;
  public
   constructor create(const asender: tobject; var instance: tdragobject;
                    const apickpos: pointty; const dataobject: tobject);
   property data: tobject read fdata;
 end;

 tstringdragobject = class(tdragobject)
  public
   data: string;
 end;

 dragstatety = (ds_clicked,ds_beginchecked,ds_cursorshapechanged,
                                                       ds_haddragobject);
 dragstatesty = set of dragstatety;

const
 dragstates = [ds_clicked,ds_beginchecked,ds_haddragobject];
 sdndexpiretime = 5000000; //5s
type
 drageventsty = record
  dragbegin: drageventty;
  dragover: dragovereventty;
  dragdrop: drageventty;
 end;

 sysdndinfoty = record
  dragobj: tdragobject;
//  expiretime: longword;
 end;

 dragoptionty = (do_child);
 dragoptionsty = set of dragoptionty;
 
 tcustomdragcontroller = class(tlinkedpersistent,ievent)
  private
   ftimer: tsimpletimer;
   foptions: dragoptionsty;
   procedure dokeypress(const sender: twidget; var info: keyeventinfoty);
   procedure initdraginfo(var info: draginfoty;
                         const eventkind: drageventkindty; const pos: pointty);
   function checkcandragdrop(const pos: pointty;
                                out sysdndpending: boolean): twidget;
  protected
   fpickpos: pointty;
   fpickrect: rectty;
   fdragobject: tdragobject;
   fstate: dragstatesty;
   fintf: idragcontroller;
   fsysdndobjects: array[0..3] of sysdndinfoty;
   flastwidget: twidget;
   procedure doexpiresdnd(const sender: tobject);
   function checkclickstate(const info: mouseeventinfoty): boolean; virtual;
   function checksysdnd(const aaction: sysdndactionty;
                                   const arect: rectty): boolean; virtual;
   function canbegindrag: boolean; virtual;
    //ievent
   procedure receiveevent(const aevent: tobjectevent); virtual;
  public
   constructor create(const aintf: idragcontroller); reintroduce;
   destructor destroy; override;
   function active: boolean;
   procedure enddrag; virtual;
   procedure mouseevent(var info: mouseeventinfoty); virtual;
   procedure clientmouseevent(var info: mouseeventinfoty); virtual;
   procedure childormouseevent(const sender: twidget;
                                  var info: mouseeventinfoty); virtual;
   function beforedragevent(var info: draginfoty): boolean; virtual; abstract;
    //true if processed
   function afterdragevent(var info: draginfoty): boolean; virtual; abstract;
    //true if processed
   property pickpos: pointty read fpickpos; //clientorigin
   property options: dragoptionsty read foptions
                                    write foptions default [];
 end;

 tdragcontroller = class(tcustomdragcontroller)
  private
   fonbefore,fonafter: drageventsty;
   function dodragevent(const events: drageventsty;
                                               var info: draginfoty): boolean;
  public
   function beforedragevent(var info: draginfoty): boolean; override;
    //true if processed
   function afterdragevent(var info: draginfoty): boolean; override;
    //true if processed
  published
   property onbeforedragbegin: drageventty read fonbefore.dragbegin 
                                  write fonbefore.dragbegin;
   property onbeforedragover: dragovereventty read fonbefore.dragover 
                                  write fonbefore.dragover;
   property onbeforedragdrop: drageventty read fonbefore.dragdrop 
                                  write fonbefore.dragdrop;
   property onafterdragbegin: drageventty read fonafter.dragbegin 
                                  write fonafter.dragbegin;
   property onafterdragover: dragovereventty read fonafter.dragover 
                                  write fonafter.dragover;
   property onafterdragdrop: drageventty read fonafter.dragdrop 
                                  write fonafter.dragdrop;
   property options;
 end;
 
function isobjectdrag(const dragobject: tdragobject;
                                                objectclass: tclass): boolean;

implementation
uses
 msebits,msepointer,msekeyboard,msesysdnd,sysutils,msesysutils,
 mseguiintf;
type
// tguiapplication1 = class(tguiapplication);
 tdragobject1 = class(tdragobject);

function isobjectdrag(const dragobject: tdragobject; 
                                                objectclass: tclass): boolean;
begin
 result:= (dragobject is tobjectdragobject) and
         (tobjectdragobject(dragobject).fdata is objectclass);
end;

{ tcustomdragcontroller }

constructor tcustomdragcontroller.create(const aintf: idragcontroller);
begin
 fintf:= aintf;
end;

destructor tcustomdragcontroller.destroy;
var
 int1: integer;
begin
 enddrag;
 ftimer.free;
 for int1:= 0 to high(fsysdndobjects) do begin
  freeandnil(fsysdndobjects[int1]);
 end;
 inherited;
end;

function tcustomdragcontroller.active: boolean;
begin
 result:= ds_clicked in fstate;
end;

procedure tcustomdragcontroller.doexpiresdnd(const sender: tobject);
var
 int1: integer;
begin
 for int1:= low(fsysdndobjects) to high(fsysdndobjects) do begin
  freeandnil(fsysdndobjects[int1].dragobj);
 end;
 freeandnil(ftimer);
end;

procedure tcustomdragcontroller.enddrag;
var
 int1,int2: integer;
begin
// checksysdnd(sdnda_finished,nullrect);
 if fdragobject <> nil then begin
  if dos_sysdroppending in tdragobject1(fdragobject).fstate then begin
   int2:= 0;
   for int1:= 0 to high(fsysdndobjects) do begin
    if fsysdndobjects[int1].dragobj = nil then begin
     int2:= int1;
     break;
    end;
   end;
   with fsysdndobjects[int2] do begin
    if dragobj <> nil then begin
     dragobj.destroy;
    end;
    tdragobject1(fdragobject).finstancepo:= @dragobj;
    dragobj:= fdragobject;
    if ftimer = nil then begin
     ftimer:= tsimpletimer.create(sdndexpiretime,{$ifdef FPC}@{$endif}doexpiresdnd,
                                                    true,[to_single]);
    end
    else begin
     ftimer.interval:= sdndexpiretime;
    end;
   end;   
   fdragobject:= nil;
  end
  else begin  
   fdragobject.free;
  end;
 end;
 if ds_haddragobject in fstate then begin
  application.cursorshape:= cr_default;
 end;
 application.unregisteronkeypress({$ifdef FPC}@{$endif}dokeypress);
 fstate:= fstate - dragstates;
end;

procedure tcustomdragcontroller.dokeypress(const sender: twidget; var info: keyeventinfoty);
begin
 if active and (info.key = key_escape) then begin
  enddrag;
  include(info.eventstate,es_processed);
 end;
end;

function tcustomdragcontroller.checkcandragdrop(const pos: pointty;
                                        out sysdndpending: boolean): twidget;
var
 window: twindow;
 pt1: pointty;
 info: draginfoty;
begin
 result:= nil;
 pt1:= translateclientpoint(pos,fintf.getwidget,nil);
 window:= application.windowatpos(pt1);
 if window <> nil then begin
  sysdndpending:= false;
  result:= window.owner.widgetatpos(translatewidgetpoint(pt1,nil,window.owner),
          [ws_visible,ws_enabled]);
  if (flastwidget <> result) then begin
   if (flastwidget <> nil) then begin
    initdraginfo(info,dek_leavewidget,
                          translateclientpoint(pt1,nil,flastwidget));
    flastwidget.dragevent(info);
   end;
   setlinkedvar(result,tmsecomponent(flastwidget));
  end;
  if result <> nil then begin
   initdraginfo(info,dek_check,translateclientpoint(pt1,nil,result));
   result.dragevent(info);
   if not info.accept then begin
    result:= nil;
   end;
  end
 end
 else begin
  sysdndpending:= checksysdnd(sdnda_check,mr(pt1,nullsize));
 end;
end;

procedure tcustomdragcontroller.initdraginfo(var info: draginfoty;
                    const eventkind: drageventkindty; const pos: pointty);
begin
 fillchar(info,sizeof(info),0);
 info.eventkind:= eventkind;
 info.pos:= pos;
 info.clientpickpos:= fpickpos;
 info.pickpos:= translateclientpoint(fpickpos,fintf.getwidget,nil);
 info.dragobjectpo:= @fdragobject;
end;

function tcustomdragcontroller.checkclickstate(
                                   const info: mouseeventinfoty): boolean;
begin
 result:= info.shiftstate - [ss_left] = [];
end;

procedure tcustomdragcontroller.clientmouseevent(var info: mouseeventinfoty);
var
 owner: twidget;
 widget1: twidget;
 draginfo: draginfoty;
 bo1: boolean;
begin
 owner:= fintf.getwidget;
 case info.eventkind of
  {ek_clientmouseleave,ek_mouseleave}ek_mousecaptureend: begin
   enddrag;
  end;
  ek_buttonpress: begin
   if checkclickstate(info) then begin
    fpickpos:= info.pos;
    fpickrect:= fintf.getdragrect(fpickpos);
    include(fstate,ds_clicked);
   end;
  end;
  ek_buttonrelease: begin
   try
    if fdragobject <> nil then begin
     fdragobject.droppos:= translateclientpoint(info.pos,owner,nil);
     include(info.eventstate,es_processed);
     widget1:= checkcandragdrop(info.pos,bo1);
     if widget1 <> nil then begin
      initdraginfo(draginfo,dek_drop,
                                 translateclientpoint(info.pos,owner,widget1));
      widget1.dragevent(draginfo);
     end
     else begin
      if bo1 then begin
       include(tdragobject1(fdragobject).fstate,dos_sysdroppending);
      end;
      checksysdnd(sdnda_drop,nullrect);
     end;
     if flastwidget <> nil then begin
      initdraginfo(draginfo,dek_leavewidget,
                            translateclientpoint(info.pos,owner,flastwidget));
      flastwidget.dragevent(draginfo);
      setlinkedvar(nil,tmsecomponent(flastwidget));
     end;
    end;
   finally
    enddrag;
   end;
  end;
  ek_mousemove,ek_mousepark: begin
   if checkclickstate(info) then begin
    if (fstate * [ds_clicked,ds_beginchecked] = [ds_clicked]) and
      (fdragobject = nil) and not pointinrect(info.pos,fpickrect)
      {(distance(info.pos,fpickpos) > mindragdist)} then begin
     include(fstate,ds_beginchecked);
     if canbegindrag then begin
      application.registeronkeypress({$ifdef FPC}@{$endif}dokeypress);
      initdraginfo(draginfo,dek_begin,fpickpos);
      owner.dragevent(draginfo);
      checksysdnd(sdnda_begin,nullrect);
     end;
    end;
    if (fdragobject <> nil) then begin
     include(fstate,ds_haddragobject);
     tdragobject1(fdragobject).feventintf:= ievent(self);
     include(info.eventstate,es_processed);
     if checkcandragdrop(info.pos,bo1) <> nil then begin
      application.cursorshape:= cr_drag;
      fdragobject.acepted(translateclientpoint(info.pos,owner,nil));
     end
     else begin
      if not bo1 then begin
       application.cursorshape:= cr_forbidden;
       fdragobject.refused(translateclientpoint(info.pos,owner,nil));
      end;
     end;
    end;
   end
   else begin
    enddrag;
   end;
  end;
 end;
 if fdragobject = nil then begin
  exclude(info.eventstate,es_drag);
 end
 else begin
  include(info.eventstate,es_drag);
 end;
end;

procedure tcustomdragcontroller.mouseevent(var info: mouseeventinfoty);
var
 po1: pointty;
begin
 po1:= fintf.getwidget.clientwidgetpos;
 subpoint1(info.pos,po1);
 clientmouseevent(info);
 addpoint1(info.pos,po1);
end;

function tcustomdragcontroller.checksysdnd(const aaction: sysdndactionty;
                                               const arect: rectty): boolean;
begin
 result:= false;
 if fdragobject <> nil then begin
  result:= tdragobject1(fdragobject).checksysdnd(aaction,arect);
 end;
end;

procedure tcustomdragcontroller.receiveevent(const aevent: tobjectevent);
begin
 if (fdragobject <> nil) and (aevent is tsysdndstatusevent) then begin
  with tsysdndstatusevent(aevent) do begin
   if ds_beginchecked in fstate then begin
    if accept then begin
     application.cursorshape:= cr_drag;
    end
    else begin
     application.cursorshape:= cr_forbidden;
    end;
   end;
  end;
 end;
end;

procedure tcustomdragcontroller.childormouseevent(const sender: twidget;
               var info: mouseeventinfoty);
var
 widget1: twidget;
 pt1: pointty;
begin
 if es_child in info.eventstate then begin
  widget1:= fintf.getwidget;
  if sender <> widget1 then begin
   if (do_child in foptions) and 
     (info.eventkind in [ek_buttonpress,ek_buttonrelease,ek_mousewheel,
                                        ek_mousemove,ek_mousepark]) then begin
    pt1:= info.pos;
    translatewidgetpoint1(info.pos,sender,widget1);
    try
     mouseevent(info);
    finally
     info.pos:= pt1;
    end;
   end;
  end
  else begin
   mouseevent(info);
  end;
 end
 else begin
  mouseevent(info);
 end; 
end;

function tcustomdragcontroller.canbegindrag: boolean;
begin
 result:= true;
end;

{ tdragcontroller }

function tdragcontroller.dodragevent(const events: drageventsty;
           var info: draginfoty): boolean;
begin
 with events,info do begin
  result:= false;
  case eventkind of
   dek_begin: begin
    if assigned(dragbegin) then begin
     dragbegin(fintf.getwidget,pos,dragobjectpo^,result);
    end;
   end;
   dek_check: begin
    if assigned(dragover) then begin
     dragover(fintf.getwidget,pos,dragobjectpo^,accept,result);
    end;
   end;
   dek_drop: begin
    if assigned(dragdrop) then begin
     dragdrop(fintf.getwidget,pos,dragobjectpo^,result);
    end;
   end;
  end;
 end;
end;

function tdragcontroller.beforedragevent(var info: draginfoty): boolean;
begin
 result:= dodragevent(fonbefore,info);
end;

function tdragcontroller.afterdragevent(var info: draginfoty): boolean;
begin
 result:= dodragevent(fonafter,info);
end;

{ tobjectdragobject }

constructor tobjectdragobject.create(const asender: tobject;
  var instance: tdragobject; const apickpos: pointty; const dataobject: tobject);
begin
 fdata:= dataobject;
 inherited create(asender,instance,apickpos);
end;

{ ttagdragobject }

constructor ttagdragobject.create(const asender: tobject;
  var instance: tdragobject; const apickpos: pointty; const tag: integer);
begin
 ftag:= tag;
 inherited create(asender,instance,apickpos);
end;

function ttagdragobject.tag: integer;
begin
 result:= ftag;
end;

end.
