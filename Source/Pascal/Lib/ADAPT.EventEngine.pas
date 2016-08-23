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
  IADEventComparer = IADComparer<TADEventBaseClass>;

  TADEvent = class abstract(TADEventBase)
  private
    FCreatedTime: ADFloat;
    FDispatchAfter: ADFloat;
    FDispatchAt: ADFloat;
    FDispatchMethod: TADEventDispatchMethod;
    FDispatchTargets: TADEventDispatchTargets;
    FDispatchTime: ADFloat;
    FExpiresAfter: ADFloat;
    FHolder: IADEventHolder;
    FLock: TADReadWriteLock;
    FOrigin: TADEventOrigin;
    FProcessedTime: ADFloat;
    FState: TADEventState;
    procedure Schedule(const AScheduleFor: ADFloat);
    procedure SetDispatchMethod(const ADispatchMethod: TADEventDispatchMethod);
  protected
    // Getters
    { IADEvent }
    function GetCreatedTime: ADFloat; override; final;
    function GetDelta: ADFloat; override; final;
    function GetDispatchAfter: ADFloat; override; final;
    function GetDispatchAt: ADFloat; override; final;
    function GetDispatchMethod: TADEventDispatchMethod; override; final;
    function GetDispatchTargets: TADEventDispatchTargets; override; final;
    function GetDispatchTime: ADFloat; override; final;
    function GetExpiresAfter: ADFloat; override; final;
    function GetEventOrigin: TADEventOrigin; override; final;
    function GetHolder: IADEventHolder; override; final;
    function GetProcessedTime: ADFloat; override; final;
    function GetState: TADEventState; override; final;
    ///  <summary><c>Override if you want to define a default Dispatch Schedule for this Event Type.</c></summary>
    ///  <returns><c>The Default Dispatch Schedule for this Event Type.</c></returns>
    ///  <remarks><c>Default = </c>0.00<c> (instant dispatch)</c></remarks>
    class function GetDefaultDispatchAfter: ADFloat; virtual;
    ///  <summary><c>Override if you want to define a Default Expiry Time for this Event Type.</c></summary>
    ///  <returns><c>The Default Expiry Time for this Event Type.</c></returns>
    ///  <remarks><c>Default = </c>0.00<c> (never expires)</c></remarks>
    class function GetDefaultExpiresAfter: ADFloat; virtual;
  public
    constructor Create; override;
    destructor Destroy; override;
    // Management Methods
    { IADEvent }
    procedure Queue; overload; override; final;
    procedure Queue(const AExpiresAfter: ADFloat); overload; override; final;
    procedure QueueSchedule(const AScheduleFor: ADFloat); override; final;
    procedure Stack; overload; override; final;
    procedure Stack(const AExpiresAfter: ADFloat); overload; override; final;
    procedure StackSchedule(const AScheduleFor: ADFloat); override; final;
  end;

  TADEventListener = class abstract(TADObjectTS, IADEventListener)
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
  protected
    ///  <summary><c>Override if you want a custom Default Max Age time.</c></summary>
    ///  <returns><c>The Default Maximum Age of an Event before the Listener will no longer process it.</c></returns>
    ///  <remarks>0.00<c> No Max Age.</c></remarks>
    class function GetDefaultMaxAge: ADFloat; virtual;
    ///  <summary><c>Override if you want a custom Default Newest Only setting.</c></summary>
    ///  <returns>
    ///    <para>True<c> if you want this Listener to only process an Event if it is Newer than the last Event processed.</c></para>
    ///    <para>False<c> if you want this Listener to process an EVent regardless of the order in which it was received.</c></para>
    ///  </returns>
    ///  <remarks><c>Default is </c>False</remarks>
    class function GetDefaultNewestOnly: Boolean; virtual;
  public
    constructor Create(const AEventThread: IADEventThread; const ARegistrationMode: TADEventListenerRegistrationMode = elrmAutomatic); reintroduce; virtual;
    // Management Methods
    { IADEventListener }
    procedure ExecuteEvent(const AEvent: TADEventBase); virtual; abstract;
    procedure Register;
    procedure Unregister;

    // Properties
    { IADEventListener }
    property EventThread: IADEventThread read GetEventThread;
    property MaxAge: ADFloat read GetMaxAge write SetMaxAge;
    property NewestOnly: Boolean read GetNewestOnly write SetNewestOnly;
  end;

  TADEventListener<T: TADEventBase> = class(TADEventListener)
  private
    FOnEvent: TADEventCallback<T>;
  public
    constructor Create(const AEventThread: IADEventThread; const AOnEvent: TADEventCallback<T>; const ARegistrationMode: TADEventListenerRegistrationMode = elrmAutomatic); reintroduce;
    // Management Methods
    { IADEventListener }
    procedure ExecuteEvent(const AEvent: TADEventBase); override;

    // Properties
    { IADEventListener<T> }
    property OnEvent: TADEventCallback<T> read FOnEvent;
  end;

  TADEventContainer = class abstract(TADPrecisionThread, IADEventContainer)
  private
    FEventQueue: IADEventList;
    FEventStack: IADEventList;
    FMaxEventCount: Cardinal;
    // Getters
    { IADEventContainer }
    function GetEventCount: Integer;
    function GetEventQueueCount: Integer;
    function GetEventStackCount: Integer;
    function GetMaxEventCount: Cardinal;

    // Setters
    { IADEventContainer }
    procedure SetMaxEventCount(const AMaxEventCount: Cardinal);
  public
    constructor Create; override;
    // Management Methods
    { IADEventContainer }
    procedure QueueEvent(const AEvent: TADEventBase);
    procedure StackEvent(const AEvent: TADEventBase);

    // Properties
    { IADEventContainer }
    property EventCount: Integer read GetEventCount;
    property EventQueueCount: Integer read GetEventQueueCount;
    property EventStackCount: Integer read GetEventStackCount;
    property MaxEventCount: Cardinal read GetMaxEventCount write SetMaxEventCount;
  end;

  TADEventThread = class(TADEventContainer, IADEventThread)
  private
    FListeners: IADEventListenerMap;
    FPauseOnNoEvent: Boolean;
    // Getters
    { IADEventThread }
    function GetPauseOnNoEvent: Boolean;

    // Setters
    { IADEventThread }
    procedure SetPauseOnNoEvent(const APauseOnNoEvent: Boolean);
  protected
    ///  <summary><c>Creates an Event Listener for the given Event Type (Parameter "T") with the given Callback Method to invoke.</c></summary>
    ///  <returns><c>A reference to the Event Listener so that you can Unregister it whenever you wish.</c></returns>
    function HookEvent<T: TADEventBase>(const ACallback: TADEventCallback<T>): IADEventListener;
  public
    constructor Create; override;
    // Management Methods
    { IADEventThread }
    procedure RegisterEventListener(const AEventListener: IADEventListener);
    procedure UnregisterEventListener(const AEventListener: IADEventListener);

    // Properties
    { IADEventThread }
    property PauseOnNoEvent: Boolean read GetPauseOnNoEvent write SetPauseOnNoEvent;
  end;

function ADEventEngine: IADEventEngine;
function ADEventComparer: IADEventComparer;

implementation

uses
  ADAPT.Generics.Common,
  ADAPT.Generics.Comparers,
  ADAPT.Generics.Lists,
  ADAPT.Generics.Maps;

type
  { Generic Collections }
  TADEventList = class(TADList<IADEventHolder>);
  TADEventListenerMap = class(TADMap<TADEventBaseClass, IADEventListener>);
  TADEventHolder = class(TADObjectHolder<TADEventBase>);

  TADEventEngine = class(TADObjectTS, IADEventEngine, IADReadWriteLock)
  private
    FGlobalMaxEvents: Cardinal;
    // Getters
    { IADEventEngine }
    function GetGlobalMaxEvents: Cardinal;

    // Setters
    { IADEventEngine }
    procedure SetGlobalMaxEvents(const AGlobalMaxEvents: Cardinal);

    // Internal Methods
    function ScheduleIfRequired(const AEvent: IADEvent): Boolean;
  public
    constructor Create; override;
    destructor Destroy; override;
    // Management Methods
    { IADEventEngine }
    procedure QueueEvent(const AEvent: IADEvent);
    procedure StackEvent(const AEvent: IADEvent);

    // Properties
    { IADEventEngine }
    property GlobalMaxEvents: Cardinal read GetGlobalMaxEvents write SetGlobalMaxEvents;
  end;

  TADEventComparer = class(TADComparer<TADEventBaseClass>)
  public
    function AEqualToB(const A, B: TADEventBaseClass): Boolean; override;
    function AGreaterThanB(const A, B: TADEventBaseClass): Boolean; override;
    function AGreaterThanOrEqualToB(const A, B: TADEventBaseClass): Boolean; override;
    function ALessThanB(const A, B: TADEventBaseClass): Boolean; override;
    function ALessThanOrEqualToB(const A, B: TADEventBaseClass): Boolean; override;
  end;

var
  GEventEngine: IADEventEngine;
  GEventComparer: IADEventComparer;

function ADEventEngine: IADEventEngine;
begin
  Result := GEventEngine;
end;

function ADEventComparer: IADEventComparer;
begin
  Result := GEventComparer;
end;

{ TADEvent }

constructor TADEvent.Create;
begin
  inherited;
  FLock := TADReadWriteLock.Create(Self);
  FCreatedTime := GetReferenceTime;
  FState := esNotDispatched;
  FDispatchAfter := GetDefaultDispatchAfter;
  FExpiresAfter := GetDefaultExpiresAfter;
  FHolder := TADEventHolder.Create(Self);
end;

destructor TADEvent.Destroy;
begin
  Holder.Ownership := oNotOwnsObjects;
  inherited;
end;

function TADEvent.GetCreatedTime: ADFloat;
begin
  Result := FCreatedTime; // No locking required as this value is only ever set on Construction.
end;

class function TADEvent.GetDefaultDispatchAfter: ADFloat;
begin
  Result := ADFLOAT_ZERO;
end;

class function TADEvent.GetDefaultExpiresAfter: ADFloat;
begin
  Result := ADFLOAT_ZERO;
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

function TADEvent.GetHolder: IADEventHolder;
begin
  Result := FHolder;
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
  SetDispatchMethod(dmQueue);
  GEventEngine.QueueEvent(Self);
end;

procedure TADEvent.Queue(const AExpiresAfter: ADFloat);
begin
  FExpiresAfter := AExpiresAfter;
  Queue;
end;

procedure TADEvent.QueueSchedule(const AScheduleFor: ADFloat);
begin
  Schedule(AScheduleFor);
  Queue;
end;

procedure TADEvent.Stack;
begin
  SetDispatchMethod(dmStack);
  GEventEngine.StackEvent(Self);
end;

procedure TADEvent.Schedule(const AScheduleFor: ADFloat);
begin
  FLock.AcquireWrite;
  try
    FDispatchAt := GetReferenceTime + AScheduleFor;
    FState := esScheduled;
  finally
    FLock.ReleaseWrite;
  end;
end;

procedure TADEvent.SetDispatchMethod(const ADispatchMethod: TADEventDispatchMethod);
begin
  FLock.AcquireWrite;
  try
    FDispatchMethod := ADispatchMethod;
  finally
    FLock.ReleaseWrite;
  end;
end;

procedure TADEvent.Stack(const AExpiresAfter: ADFloat);
begin
  FExpiresAfter := AExpiresAfter;
  Stack;
end;

procedure TADEvent.StackSchedule(const AScheduleFor: ADFloat);
begin
  Schedule(AScheduleFor);
  Stack;
end;

{ TADEventListener }

constructor TADEventListener.Create(const AEventThread: IADEventThread; const ARegistrationMode: TADEventListenerRegistrationMode);
begin
  inherited Create;
  FEventThread := @AEventThread; // Weak Reference
  if ARegistrationMode = elrmAutomatic then
    Register;
end;

class function TADEventListener.GetDefaultMaxAge: ADFloat;
begin
  Result := ADFLOAT_ZERO;
end;

class function TADEventListener.GetDefaultNewestOnly: Boolean;
begin
  Result := False;
end;

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

{ TADEventListener<T> }

constructor TADEventListener<T>.Create(const AEventThread: IADEventThread; const AOnEvent: TADEventCallback<T>; const ARegistrationMode: TADEventListenerRegistrationMode = elrmAutomatic);
begin
  if (not Assigned(AOnEvent)) then
    raise EADEventEngineEventListenerCallbackUnassigned.Create('Event Callback Cannot be Unassigned or Nil.');
  FOnEvent := AOnEvent;
  inherited Create(AEventThread);
end;

procedure TADEventListener<T>.ExecuteEvent(const AEvent: TADEventBase);
begin
  FOnEvent(AEvent);
end;

{ TADEventContainer }

constructor TADEventContainer.Create;
begin
  inherited;
  FEventQueue := TADEventList.Create;
  FEventStack := TADEventList.Create;
end;

function TADEventContainer.GetEventCount: Integer;
begin
  FLock.AcquireRead;
  try
    Result := FEventQueue.Count + FEventStack.Count;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADEventContainer.GetEventQueueCount: Integer;
begin
  FLock.AcquireRead;
  try
    Result := FEventQueue.Count;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADEventContainer.GetEventStackCount: Integer;
begin
  FLock.AcquireRead;
  try
    Result := FEventStack.Count;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADEventContainer.GetMaxEventCount: Cardinal;
begin
  FLock.AcquireRead;
  try
    Result := FMaxEventCount;
  finally
    FLock.ReleaseRead;
  end;
end;

procedure TADEventContainer.QueueEvent(const AEvent: TADEventBase);
begin
  FEventQueue.Add(AEvent.Holder);
end;

procedure TADEventContainer.SetMaxEventCount(const AMaxEventCount: Cardinal);
begin
  FLock.AcquireRead;
  try
    FMaxEventCount := AMaxEventCount;
  finally
    FLock.ReleaseRead;
  end;
end;

procedure TADEventContainer.StackEvent(const AEvent: TADEventBase);
begin
  FEventStack.Add(AEvent.Holder);
end;

{ TADEventThread }

constructor TADEventThread.Create;
begin
  inherited;
  FListeners := TADEventListenerMap.Create(ADEventComparer);
end;

function TADEventThread.GetPauseOnNoEvent: Boolean;
begin
  FLock.AcquireRead;
  try
    Result := FPauseOnNoEvent;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADEventThread.HookEvent<T>(const ACallback: TADEventCallback<T>): IADEventListener;
begin
  Result := TADEventListener<T>.Create(Self, ACallback);
end;

procedure TADEventThread.RegisterEventListener(const AEventListener: IADEventListener);
begin

end;

procedure TADEventThread.SetPauseOnNoEvent(const APauseOnNoEvent: Boolean);
begin
  FLock.AcquireRead;
  try
    FPauseOnNoEvent := APauseOnNoEvent;
  finally
    FLock.ReleaseRead;
  end;
end;

procedure TADEventThread.UnregisterEventListener(const AEventListener: IADEventListener);
begin

end;

{ TADEventEngine }

constructor TADEventEngine.Create;
begin
  inherited;
  FGlobalMaxEvents := 0;
end;

destructor TADEventEngine.Destroy;
begin

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

procedure TADEventEngine.QueueEvent(const AEvent: IADEvent);
begin
  if (not ScheduleIfRequired(AEvent)) then
  begin

  end;
end;

function TADEventEngine.ScheduleIfRequired(const AEvent: IADEvent): Boolean;
begin
  Result := AEvent.DispatchAfter > 0;
  Result := False; // TODO -oDaniel -cEvent Engine Scheduler: Handle Scheduled Events.
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
  if (not ScheduleIfRequired(AEvent)) then
  begin

  end;
end;

{ TADEventComparer }

function TADEventComparer.AEqualToB(const A, B: TADEventBaseClass): Boolean;
begin
  Result := (A = B);
end;

function TADEventComparer.AGreaterThanB(const A, B: TADEventBaseClass): Boolean;
begin
  Result := (Cardinal(A.ClassInfo) > Cardinal(B.ClassInfo));
end;

function TADEventComparer.AGreaterThanOrEqualToB(const A, B: TADEventBaseClass): Boolean;
begin
  Result := (Cardinal(A.ClassInfo) >= Cardinal(B.ClassInfo));
end;

function TADEventComparer.ALessThanB(const A, B: TADEventBaseClass): Boolean;
begin
  Result := (Cardinal(A.ClassInfo) < Cardinal(B.ClassInfo));
end;

function TADEventComparer.ALessThanOrEqualToB(const A, B: TADEventBaseClass): Boolean;
begin
  Result := (Cardinal(A.ClassInfo) <= Cardinal(B.ClassInfo));
end;

initialization
  GEventComparer := TADEventComparer.Create;
  GEventEngine := TADEventEngine.Create;

end.
