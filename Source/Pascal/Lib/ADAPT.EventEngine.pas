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
  ADAPT.Common, ADAPT.Common.Intf, ADAPT.Common.Threadsafe,
  ADAPT.Generics.Common.Intf,
  ADAPT.Generics.Comparers.Intf,
  ADAPT.Generics.Sorters.Intf,
  ADAPT.Generics.Lists.Intf,
  ADAPT.Threads,
  ADAPT.EventEngine.Intf;

  {$I ADAPT_RTTI.inc}

type
  TADEvent = class(TADObjectTS, IADEvent, IADReadWriteLock)
  private
    FCreatedTime: ADFloat;
    FDispatchAfter: ADFloat;
    FDispatchAt: ADFloat;
    FDispatchMethod: TADEventDispatchMethod;
    FDispatchTargets: TADEventDispatchTargets;
    FDispatchTime: ADFloat;
    FExpiresAfter: ADFloat;
    FLock: TADReadWriteLock;
    FOrigin: TADEventOrigin;
    FProcessedTime: ADFloat;
    FState: TADEventState;
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
    constructor Create; override;
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

  TADEventListener = class(TADObjectTS, IADEventListener)
  private
    FEventThread: Pointer; // Weak Reference
    FLastProcessed: ADFloat;
    FMaxAge: ADFloat;
    FNewestOnly: Boolean;
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

constructor TADEvent.Create;
begin
  inherited;
  FLock := TADReadWriteLock.Create(Self);
  FCreatedTime := GetReferenceTime;
  FState := esNotDispatched;
end;

function TADEvent.GetCreatedTime: ADFloat;
begin
  Result := FCreatedTime; // No locking required as this value is only ever set on Construction.
end;

function TADEvent.GetDelta: ADFloat;
begin
  FLock.AcquireRead;
  try
    Result := GetReferenceTime - FDispatchTime;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADEvent.GetDispatchAfter: ADFloat;
begin
  FLock.AcquireRead;
  try
    Result := FDispatchAfter;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADEvent.GetDispatchAt: ADFloat;
begin
  FLock.AcquireRead;
  try
    Result := FDispatchAt;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADEvent.GetDispatchMethod: TADEventDispatchMethod;
begin
  FLock.AcquireRead;
  try
    Result := FDispatchMethod;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADEvent.GetDispatchTargets: TADEventDispatchTargets;
begin
  FLock.AcquireRead;
  try
    Result := FDispatchTargets;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADEvent.GetDispatchTime: ADFloat;
begin
  FLock.AcquireRead;
  try
    Result := FDispatchTime;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADEvent.GetEventOrigin: TADEventOrigin;
begin
  FLock.AcquireRead;
  try
    Result := FOrigin;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADEvent.GetExpiresAfter: ADFloat;
begin
  FLock.AcquireRead;
  try
    Result := FExpiresAfter;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADEvent.GetProcessedTime: ADFloat;
begin
  FLock.AcquireRead;
  try
    Result := FProcessedTime;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADEvent.GetState: TADEventState;
begin
  FLock.AcquireRead;
  try
    Result := FState;
  finally
    FLock.ReleaseRead;
  end;
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
  FLock.AcquireRead;
  try
    Result := IADEventThread(FEventThread^);
  finally
    FLock.ReleaseRead;
  end;
end;

function TADEventListener.GetLastProcessed: ADFloat;
begin
  FLock.AcquireRead;
  try
    Result := FLastProcessed;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADEventListener.GetMaxAge: ADFloat;
begin
  FLock.AcquireRead;
  try
    Result := FMaxAge;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADEventListener.GetNewestOnly: Boolean;
begin
  FLock.AcquireRead;
  try
    Result := FNewestOnly;
  finally
    FLock.ReleaseRead;
  end;
end;

procedure TADEventListener.Register;
begin

end;

procedure TADEventListener.SetMaxAge(const AMaxAge: ADFloat);
begin
  FLock.AcquireWrite;
  try
    FMaxAge := AMaxAge;
  finally
    FLock.ReleaseWrite;
  end;
end;

procedure TADEventListener.SetNewestOnly(const ANewestOnly: Boolean);
begin
  FLock.AcquireWrite;
  try
    FNewestOnly := ANewestOnly;
  finally
    FLock.ReleaseWrite;
  end;
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
