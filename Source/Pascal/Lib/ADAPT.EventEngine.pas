{
  AD.A.P.T. Library
  Copyright (C) 2014-2016, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.EventEngine;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes,
  {$ELSE}
    Classes,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Common, ADAPT.Common.Intf,
  ADAPT.Generics.Common.Intf,
  ADAPT.Generics.Comparers.Intf,
  ADAPT.Generics.Sorters.Intf,
  ADAPT.Generics.Lists.Intf,
  ADAPT.Threads,
  ADAPT.EventEngine.Intf;

  {$I ADAPT_RTTI.inc}

type
  TADEvent = class(TADObject, IADEvent)
  private
    // Getters
    { IADEvent }
    function GetCreatedTime: ADFloat;
    function GetDelta: ADFloat;
    function GetDispatchAfter: ADFloat;
    function GetDispatchAt: ADFloat;
    function GetDispatchMethod: TADEventDispatchMethod;
    function GetDispatchTargets: TADEventDispatchTargets;
    function GetDispatchTime: ADFloat;
    function GetExpiresAfter: ADFloat;
    function GetEventOrigin: TADEventOrigin;
    function GetProcessedTime: ADFloat;
    function GetState: TADEventState;

    // Setters
  public

    // Management Methods
    { IADEvent }
    procedure Queue;
    procedure QueueSchedule(const AScheduleFor: ADFloat);
    procedure Stack;
    procedure StackSchedule(const AScheduleFor: ADFloat);

    // Properties
    { IADEvent }
    property CreatedTime: ADFloat read GetCreatedTime;
    property Delta: ADFloat read GetDelta;
    property DispatchAfter: ADFloat read GetDispatchAfter;
    property DispatchAt: ADFloat read GetDispatchAt;
    property DispatchMethod: TADEventDispatchMethod read GetDispatchMethod;
    property DispatchTargets: TADEventDispatchTargets read GetDispatchTargets;
    property DispatchTime: ADFloat read GetDispatchTime;
    property ExpiresAfter: ADFloat read GetExpiresAfter;
    property EventOrigin: TADEventOrigin read GetEventOrigin;
    property ProcessedTime: ADFloat read GetProcessedTime;
    property State: TADEventState read GetState;
  end;

  TADEventListener = class(TADObject, IADEventListener)
  private
    // Getters
    { IADEventListener }
    function GetEventThread: IADEventThread;
    function GetLastProcessed: ADFloat;
    function GetMaxAge: ADFloat;
    function GetNewestOnly: Boolean;

    // Setters
    { IADEventListener }
    procedure SetMaxAge(const AMaxAge: ADFloat);
    procedure SetNewestOnly(const ANewestOnly: Boolean);
  public
    // Management Methods
    { IADEventListener }
    procedure Register;
    procedure Unregister;

    // Properties
    { IADEventListener }
    property EventThread: IADEventThread read GetEventThread;
    property MaxAge: ADFloat read GetMaxAge write SetMaxAge;
    property NewestOnly: Boolean read GetNewestOnly write SetNewestOnly;
  end;

  TADEventListener<T: IADEvent> = class(TADEventListener, IADEventListener<T>)

  end;

  TADEventThread = class(TADPrecisionThread, IADEventThread, IADEventContainer)
  private
    // Getters
    { IADEventThread }
    function GetPauseOnNoEvent: Boolean;
    { IADEventContainer }
    function GetEventCount: Integer;
    function GetEventQueueCount: Integer;
    function GetEventStackCount: Integer;
    function GetMaxEventCount: Cardinal;

    // Setters
    { IADEventThread }
    procedure SetPauseOnNoEvent(const APauseOnNoEvent: Boolean);
    { IADEventContainer }
    procedure SetMaxEventCount(const AMaxEventCount: Cardinal);
  public
    // Management Methods
    { IADEventThread }
    procedure RegisterEventListener(const AEventListener: IADEventListener);
    procedure UnregisterEventListener(const AEventListener: IADEventListener);
    { IADEventContainer }
    procedure QueueEvent(const AEvent: IADEvent);
    procedure StackEvent(const AEVent: IADEvent);

    // Properties
    { IADEventThread }
    property PauseOnNoEvent: Boolean read GetPauseOnNoEvent write SetPauseOnNoEvent;
    { IADEventContainer }
    property EventCount: Integer read GetEventCount;
    property EventQueueCount: Integer read GetEventQueueCount;
    property EventStackCount: Integer read GetEventStackCount;
    property MaxEventCount: Cardinal read GetMaxEventCount write SetMaxEventCount;
  end;

function ADEventEngine: IADEventEngine;

implementation

uses
  ADAPT.Common.Threadsafe;

type
  TADEventEngine = class(TADObject, IADEventEngine, IADReadWriteLock)
  private
    FGlobalMaxEvents: Cardinal;
    FLock: TADReadWriteLock;
    // Getters
    function GetLock: IADReadWriteLock;
    { IADEventEngine }
    function GetGlobalMaxEvents: Cardinal;

    // Setters
    { IADEventEngine }
    procedure SetGlobalMaxEvents(const AGlobalMaxEvents: Cardinal);

  public
    constructor Create; override;
    destructor Destroy; override;
    // Management Methods
    { IADEventEngine }
    procedure QueueEvent(const AEvent: IADEvent);
    procedure StackEvent(const AEvent: IADEvent);

    // Properties
    property Lock: IADReadWriteLock read GetLock implements IADReadWriteLock;
    { IADEventEngine }
    property GlobalMaxEvents: Cardinal read GetGlobalMaxEvents write SetGlobalMaxEvents;
  end;

var
  GEventEngine: IADEventEngine;

function ADEventEngine: IADEventEngine;
begin
  Result := GEventEngine;
end;

{ TADEvent }

function TADEvent.GetCreatedTime: ADFloat;
begin

end;

function TADEvent.GetDelta: ADFloat;
begin

end;

function TADEvent.GetDispatchAfter: ADFloat;
begin

end;

function TADEvent.GetDispatchAt: ADFloat;
begin

end;

function TADEvent.GetDispatchMethod: TADEventDispatchMethod;
begin

end;

function TADEvent.GetDispatchTargets: TADEventDispatchTargets;
begin

end;

function TADEvent.GetDispatchTime: ADFloat;
begin

end;

function TADEvent.GetEventOrigin: TADEventOrigin;
begin

end;

function TADEvent.GetExpiresAfter: ADFloat;
begin

end;

function TADEvent.GetProcessedTime: ADFloat;
begin

end;

function TADEvent.GetState: TADEventState;
begin

end;

procedure TADEvent.Queue;
begin

end;

procedure TADEvent.QueueSchedule(const AScheduleFor: ADFloat);
begin

end;

procedure TADEvent.Stack;
begin

end;

procedure TADEvent.StackSchedule(const AScheduleFor: ADFloat);
begin

end;

{ TADEventListener }

function TADEventListener.GetEventThread: IADEventThread;
begin

end;

function TADEventListener.GetLastProcessed: ADFloat;
begin

end;

function TADEventListener.GetMaxAge: ADFloat;
begin

end;

function TADEventListener.GetNewestOnly: Boolean;
begin

end;

procedure TADEventListener.Register;
begin

end;

procedure TADEventListener.SetMaxAge(const AMaxAge: ADFloat);
begin

end;

procedure TADEventListener.SetNewestOnly(const ANewestOnly: Boolean);
begin

end;

procedure TADEventListener.Unregister;
begin

end;

{ TADEventThread }

function TADEventThread.GetEventCount: Integer;
begin

end;

function TADEventThread.GetEventQueueCount: Integer;
begin

end;

function TADEventThread.GetEventStackCount: Integer;
begin

end;

function TADEventThread.GetMaxEventCount: Cardinal;
begin

end;

function TADEventThread.GetPauseOnNoEvent: Boolean;
begin

end;

procedure TADEventThread.QueueEvent(const AEvent: IADEvent);
begin

end;

procedure TADEventThread.RegisterEventListener(const AEventListener: IADEventListener);
begin

end;

procedure TADEventThread.SetMaxEventCount(const AMaxEventCount: Cardinal);
begin

end;

procedure TADEventThread.SetPauseOnNoEvent(const APauseOnNoEvent: Boolean);
begin

end;

procedure TADEventThread.StackEvent(const AEVent: IADEvent);
begin

end;

procedure TADEventThread.UnregisterEventListener(const AEventListener: IADEventListener);
begin

end;

{ TADEventEngine }

constructor TADEventEngine.Create;
begin
  inherited;
  FGlobalMaxEvents := 0;
  FLock := TADReadWriteLock.Create(Self);
end;

destructor TADEventEngine.Destroy;
begin
  FLock.{$IFDEF SUPPORTS_DISPOSEOF}DisposeOf{$ELSE}Free{$ENDIF SUPPORTS_DISPOSEOF};
  inherited;
end;

function TADEventEngine.GetGlobalMaxEvents: Cardinal;
begin
  FLock.AcquireRead;
  try
    Result := FGlobalMaxEvents;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADEventEngine.GetLock: IADReadWriteLock;
begin
  Result := FLock;
end;

procedure TADEventEngine.QueueEvent(const AEvent: IADEvent);
begin

end;

procedure TADEventEngine.SetGlobalMaxEvents(const AGlobalMaxEvents: Cardinal);
begin
  FLock.AcquireWrite;
  try
    FGlobalMaxEvents := AGlobalMaxEvents;
  finally
    FLock.ReleaseWrite;
  end;
end;

procedure TADEventEngine.StackEvent(const AEvent: IADEvent);
begin

end;

initialization
  GEventEngine := TADEventEngine.Create;

end.
