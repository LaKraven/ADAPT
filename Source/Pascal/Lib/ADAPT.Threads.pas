{
  AD.A.P.T. Library
  Copyright (C) 2014-2016, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT

  Formerlly known as "LaKraven Studios Standard Library" or "LKSL".
  "ADAPT" supercedes the former LKSL codebase as of 2016.

  License:
    - You may use this library as you see fit, including use within commercial applications.
    - You may modify this library to suit your needs, without the requirement of distributing
      modified versions.
    - You may redistribute this library (in part or whole) individually, or as part of any
      other works.
    - You must NOT charge a fee for the distribution of this library (compiled or in its
      source form). It MUST be distributed freely.
    - This license and the surrounding comment block MUST remain in place on all copies and
      modified versions of this source code.
    - Modified versions of this source MUST be clearly marked, including the name of the
      person(s) and/or organization(s) responsible for the changes, and a SEPARATE "changelog"
      detailing all additions/deletions/modifications made.

  Disclaimer:
    - Your use of this source constitutes your understanding and acceptance of this
      disclaimer.
    - Simon J Stuart, nor any other contributor, may be held liable for your use of this source
      code. This includes any losses and/or damages resulting from your use of this source
      code, be they physical, financial, or psychological.
    - There is no warranty or guarantee (implicit or otherwise) provided with this source
      code. It is provided on an "AS-IS" basis.

  Donations:
    - While not mandatory, contributions are always appreciated. They help keep the coffee
      flowing during the long hours invested in this and all other Open Source projects we
      produce.
    - Donations can be made via PayPal to PayPal [at] LaKraven (dot) Com
                                          ^  Garbled to prevent spam!  ^
}
unit ADAPT.Threads;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes, System.SysUtils, System.SyncObjs, System.Diagnostics, System.Math,
  {$ELSE}
    Classes, SysUtils, SyncObjs, {$IFDEF FPC}ADAPT.Stopwatch{$ELSE}Diagnostics{$ENDIF FPC},
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Common, ADAPT.Common.Intf, ADAPT.Common.Threadsafe,
  ADAPT.Performance.Intf,
  ADAPT.Threads.Intf;

  {$I ADAPT_RTTI.inc}

type
  { Class Forward Declarations }
  TADThread = class;
  TADPrecisionThread = class;

  ///  <summary><c>Abstract Base Type for all Threads in the ADAPT codebase.</c></summary>
  ///  <remarks>
  ///    <para><c>ALL Threads in the codebase have a Threadsafe Lock.</c></para>
  ///    <para><c>ALL Threads in the codebase are Interfaced Types.</c></para>
  ///  </remarks>
  TADThread = class abstract(TThread, IADInterface, IADThread, IADReadWriteLock)
  private
    FOwnerInterface: IInterface;
    { IInterface }
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    { IADInterface }
    function GetInstanceGUID: TGUID;
    { IADReadWriteLock }
    function GetLock: IADReadWriteLock;
  protected
    FInstanceGUID: TGUID;
    FLock: TADReadWriteLock;
  public
    constructor Create; reintroduce; overload; virtual;
    constructor Create(const ACreateSuspended: Boolean); reintroduce; overload; virtual;
    destructor Destroy; override;
    procedure AfterConstruction; override;

    { IADInterface }
    property InstanceGUID: TGUID read GetInstanceGUID;
    { IADReadWriteLock }
    property Lock: IADReadWriteLock read GetLock implements IADReadWriteLock;
  end;

  ///  <summary><c>Abstract Base Type for all Precision Threads in the ADAPT codebase.</c></summary>
  ///  <remarks>
  ///    <para><c>Provides extremely precise Delta Time between Ticks.</c></para>
  ///    <para><c>You can set a precise Tick Rate Limit.</c></para>
  ///  </remarks>
  TADPrecisionThread = class abstract(TADThread, IADPrecisionThread)
  private
    FNextTickTime: ADFloat;
    FPerformanceCounter: IADPerformanceCounter;
    FThreadState: TADThreadState;
    FTickRateDesired: ADFloat; // The DESIRED rate at which you want the Thread to Tick (minimum)
    FTickRateLimit: ADFloat; // The current Tick Rate Limit (in "Ticks per Second"), 0 = no limit.
    FThrottleInterval: Cardinal; // The current Throttling Interval (in Milliseconds)
    FWakeUp: TEvent;

    { Internal Methods }
    procedure AtomicIncrementNextTickTime(const AIncrementBy: ADFloat); inline;
    procedure InitializeTickVariables(var ACurrentTime, ALastAverageCheckpoint, ANextAverageCheckpoint, ATickRate: ADFloat; var AAverageTicks: Integer);
    procedure AtomicInitializeCycleValues(var ATickRateLimit, ATickRateDesired: ADFloat; var AThrottleInterval: Cardinal); inline;

    { Property Getters }
    function GetNextTickTime: ADFloat;
    function GetThreadState: TADThreadState;
    function GetTickRate: ADFloat;
    function GetTickRateAverage: ADFloat;
    function GetTickRateAverageOver: Cardinal;
    function GetTickRateDesired: ADFloat;
    function GetTickRateLimit: ADFloat;
    function GetThrottleInterval: Cardinal;

    { Property Setters }
    procedure SetThreadState(const AThreadState: TADThreadState);
    procedure SetTickRateAverageOver(const AAverageOver: Cardinal);
    procedure SetTickRateDesired(const ADesiredRate: ADFloat);
    procedure SetTickRateLimit(const ATickRateLimit: ADFloat);
    procedure SetThrottleInterval(const AThrottleInterval: Cardinal);
  protected
    ///  <summary><c>Override if you wish your inherited Type to enforce a Tick Rate Limit by Default.</c></summary>
    ///  <remarks>
    ///    <para>0 <c>= No Tick Rate Limit</c></para>
    ///    <para><c>Default = </c>0</para>
    ///  </remarks>
    function GetDefaultTickRateLimit: ADFloat; virtual;
    ///  <summary><c>Override if you wish to change the default Tick Rate Averaging Sample Count.</c></summary>
    ///  <remarks>
    ///    <para><c>Value is in Samples</c></para>
    ///    <para><c>Default = </c>10</para>
    ///  </remarks>
    function GetDefaultTickRateAverageOver: Cardinal; virtual;
    ///  <summary><c>Override if you wish your inherited Type to state a desired Tick Rate by Default.</c></summary>
    ///  <remarks>
    ///    <para>0 <c>= No Desired Rate</c></para>
    ///    <para><c>Default = </c>0</para>
    ///  </remarks>
    function GetDefaultTickRateDesired: ADFloat; virtual;
    ///  <summary><c>Override if you wish to define a different Throttling Interval (period in which to rest the Thread when waiting between Ticks)</c></summary>
    ///  <remarks>
    ///    <para><c>Minimum Value = </c>1</para>
    ///    <para><c>Default = </c>1</para>
    ///    <para><c>Values are in </c>MILLISECONDS</para>
    ///  </remarks>
    function GetDefaultThrottleInterval: Integer; virtual;
    ///  <summary><c>Defines whether the Thread should be Running or Paused upon Construction.</c></summary>
    ///  <remarks><c>Default = </c>tsRunning</remarks>
    function GetInitialThreadState: TADThreadState; virtual;
    ///  <summary><c>Calculates how much "Extra Time" is available for the current Tick.</c></summary>
    ///  <remarks><c>Could be a negative number of the Thread is performing BELOW the desired rate!</c></remarks>
    function CalculateExtraTime: ADFloat;

    ///  <summary><c>You must NOT override "Execute" on descendants. See </c><see DisplayName="Tick" cref="ADAPT.Threads|TADPrecisionThread.Tick"/><c> instead!</c></summary>
    procedure Execute; override; final;

    ///  <summary><c>Override to implement code you need your Thread to perform on EVERY cycle (regardless of any Tick Rate Limit).</c></summary>
    ///  <param name="ADelta"><c>The time differential ("Delta") between the current Tick and the previous Tick.</c></param>
    ///  <param name="AStartTime"><c>The Reference Time at which the current Tick began.</c></param>
    ///  <remarks>
    ///    <para><c>Used extensively by the Event Engine.</c></para>
    ///    <para><c>Ignores any Tick Rate Limits.</c></para>
    ///  </remarks>
    procedure PreTick(const ADelta, AStartTime: ADFloat); virtual;
    ///  <summary><c>Override to implement your Thread's operational code.</c></summary>
    ///  <param name="ADelta"><c>The time differential ("Delta") between the current Tick and the previous Tick.</c></param>
    ///  <param name="AStartTime"><c>The Reference Time at which the current Tick began.</c></param>
    procedure Tick(const ADelta, AStartTime: ADFloat); virtual; abstract;
  public
    ///  <summary><c>Puts a Thread to sleep ONLY if there's enough time!</c></summary>
    class function SmartSleep(const ATimeToWait: ADFloat; const AThreshold: Cardinal): Boolean;
    constructor Create(const ACreateSuspended: Boolean); override;
    destructor Destroy; override;

    procedure BeforeDestruction; override;

    ///  <summary><c>Forces the "Next Tick Time" to be bumped to RIGHT NOW. This will trigger the next Tick immediately regardless of any Rate Limit setting.</c></summary>
    procedure Bump;

    ///  <summary><c>Places the Thread in an Inactive state, waiting for the signal to </c><see DisplayName="Wake" cref="ADAPT.Threads|TADPrecisionThread.Wake"/><c> the Thread.</c></summary>
    procedure Rest;
    ///  <summary><c>Wakes the Thread if it is an Inactive state (see </c><see DisplayName="Rest" cref="ADAPT.Threads|TADPrecisionThread.Rest"/><c> for details)</c></summary>
    procedure Wake;

    ///  <summary><c>The Absolute Reference Time at which the next Tick will occur.</c></summary>
    property NextTickTime: ADFloat read GetNextTickTime;
    ///  <summary><c>The current State of the Thread (running or paused).</c></summary>
    property ThreadState: TADThreadState read GetThreadState write SetThreadState;
    ///  <summary><c>The Absolute Rate (in Ticks Per Second [T/s]) at which the Thread is executing its Tick method.</c></summary>
    property TickRate: ADFloat read GetTickRate;
    ///  <summary><c>The Running Average Rate (in Ticks Per Second [T/s]) at which the Thread is executing its Tick method.</c></summary>
    property TickRateAverage: ADFloat read GetTickRateAverage;
    ///  <summary><c>The Time (in Seconds) over which to calculate the Running Average.</c></summary>
    property TickRateAverageOver: Cardinal read GetTickRateAverageOver write SetTickRateAverageOver;
    ///  <summary><c>The number of Ticks Per Second [T/s] you would LIKE the Thread to operate at.</c></summary>
    ///  <remarks><c>This value is used to calculate how much "Extra Time" (if any) is available on the current Tick.</c></remarks>
    property TickRateDesired: ADFloat read GetTickRateDesired write SetTickRateDesired;
    ///  <summary><c>The Absolute Tick Rate (in Ticks Per Second [T/s]) at which you wish the Thread to operate.</c></summary>
    ///  <remarks><c>There is no guarantee that the rate you specify here will be achievable. Slow hardware or an overloaded running environment may mean the thread operates below the specified rate.</c></remarks>
    property TickRateLimit: ADFloat read GetTickRateLimit write SetTickRateLimit;
    ///  <summary><c>The minimum amount of time that must be available between Ticks in order to Rest the Thread.</c></summary>
    ///  <remarks>
    ///    <para><c>Value is in </c>MILLISECONDS<c> (1 = 0.001 seconds)</c></para>
    ///    <para><c>Minimum value = </c>1</para>
    ///  </remarks>
    property ThrottleInterval: Cardinal read GetThrottleInterval write SetThrottleInterval;
  end;

function GetReferenceTime: ADFloat;

implementation

uses
  ADAPT.Performance.Threadsafe;
  {$I ADAPT_RTTI.inc}

var
  ReferenceWatch: TStopwatch;

function GetReferenceTime: ADFloat;
begin
  Result := TStopwatch.GetTimeStamp / TStopwatch.Frequency;
end;

{ TADThread }

constructor TADThread.Create;
begin
  Create(False);
end;

constructor TADThread.Create(const ACreateSuspended: Boolean);
begin
  inherited Create(ACreateSuspended);
  CreateGUID(FInstanceGUID);
  FLock := TADReadWriteLock.Create(IADThread(Self));
end;

destructor TADThread.Destroy;
begin
  FLock.{$IFDEF SUPPORTS_DISPOSEOF}DisposeOf{$ELSE}Free{$ENDIF SUPPORTS_DISPOSEOF};
  inherited;
end;

function TADThread.GetInstanceGUID: TGUID;
begin
  Result := FInstanceGUID;
end;

function TADThread.GetLock: IADReadWriteLock;
begin
  Result := FLock;
end;

function TADThread.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
if GetInterface(IID, Obj) then Result := 0 else Result := E_NOINTERFACE;
end;

function TADThread._AddRef: Integer;
begin
  if FOwnerInterface <> nil then
    Result := FOwnerInterface._AddRef else
    Result := -1;
end;

function TADThread._Release: Integer;
begin
  if FOwnerInterface <> nil then
    Result := FOwnerInterface._Release else
    Result := -1;
end;

procedure TADThread.AfterConstruction;
begin
  inherited;
  GetInterface(IInterface, FOwnerInterface);
end;

{ TADThreadPrecision }

procedure TADPrecisionThread.AtomicIncrementNextTickTime(const AIncrementBy: ADFloat);
begin
  FLock.AcquireWrite;
  try
    FNextTickTime := FNextTickTime + AIncrementBy;
  finally
    FLock.ReleaseWrite;
  end;
end;

procedure TADPrecisionThread.AtomicInitializeCycleValues(var ATickRateLimit, ATickRateDesired: ADFloat; var AThrottleInterval: Cardinal);
begin
  FLock.AcquireWrite;
  try
    ATickRateLimit := FTickRateLimit;
    ATickRateDesired := FTickRateDesired;
    AThrottleInterval := FThrottleInterval;
  finally
    FLock.ReleaseWrite;
  end;
end;

procedure TADPrecisionThread.BeforeDestruction;
begin
  inherited;
  FWakeUp.SetEvent;
  if not Terminated then
  begin
    Terminate;
    WaitFor;
  end;
end;

procedure TADPrecisionThread.Bump;
begin
  FLock.AcquireWrite;
  try
    FNextTickTime := GetReferenceTime;
  finally
    FLock.ReleaseWrite;
  end;
end;

function TADPrecisionThread.CalculateExtraTime: ADFloat;
begin
  Result := NextTickTime - GetReferenceTime;
end;

constructor TADPrecisionThread.Create(const ACreateSuspended: Boolean);
const
  THREAD_STATES: Array[TADThreadState] of Boolean = (True, False);
begin
  inherited Create(ACreateSuspended);
  FPerformanceCounter := TADPerformanceCounterTS.Create(GetDefaultTickRateAverageOver);
  FThrottleInterval := GetDefaultThrottleInterval;
  FreeOnTerminate := False;
  FThreadState := GetInitialThreadState;
  FTickRateLimit := GetDefaultTickRateLimit;
  FTickRateDesired := GetDefaultTickRateDesired;
  FWakeUp := TEvent.Create(nil, True, THREAD_STATES[FThreadState], '');
end;

destructor TADPrecisionThread.Destroy;
begin
  FWakeUp.{$IFDEF SUPPORTS_DISPOSEOF}DisposeOf{$ELSE}Free{$ENDIF SUPPORTS_DISPOSEOF};
  FPerformanceCounter := nil;
  inherited;
end;

procedure TADPrecisionThread.Execute;
var
  LDelta, LCurrentTime: ADFloat;
  LTickRate, LTickRateLimit, LTickRateDesired: ADFloat;
  LLastAverageCheckpoint, LNextAverageCheckpoint: ADFloat;
  LAverageTicks: Integer;
  LThrottleInterval: Cardinal;
begin
  InitializeTickVariables(LCurrentTime, LLastAverageCheckpoint, LNextAverageCheckpoint, LTickRate, LAverageTicks);
  while (not Terminated) do
  begin
    if ThreadState = tsRunning then
    begin
      LCurrentTime := GetReferenceTime;
      AtomicInitializeCycleValues(LTickRateLimit, LTickRateDesired, LThrottleInterval);
      LDelta := (LCurrentTime - FNextTickTime);

      // Rate Limiter
      if ((LTickRateLimit > 0)) and (LDelta < ( 1 / LTickRateLimit)) then
        LDelta := (1 / LTickRateLimit);

      // Calculate INSTANT Tick Rate
      if LDelta > 0 then
      begin
        LTickRate := 1 / LDelta; // Calculate the current Tick Rate
        FPerformanceCounter.RecordSample(LTickRate);
      end;

      // Call "PreTick"
      PreTick(LDelta, LCurrentTime);

      // Tick or Wait...
      if ((LCurrentTime >= FNextTickTime) and (LTickRateLimit > 0)) or (LTickRateLimit = 0) then
      begin
        AtomicIncrementNextTickTime(LDelta);
        Tick(LDelta, LCurrentTime);
      end else
      begin
        if (FNextTickTime - GetReferenceTime >= LThrottleInterval / 1000) then
          TThread.Sleep(LThrottleInterval);
      end;
    end else
      FWakeUp.WaitFor(INFINITE);
  end;
end;

function TADPrecisionThread.GetDefaultThrottleInterval: Integer;
begin
  Result := 1;
end;

function TADPrecisionThread.GetDefaultTickRateAverageOver: Cardinal;
begin
  Result := 10;
end;

function TADPrecisionThread.GetDefaultTickRateDesired: ADFloat;
begin
  Result := 0;
end;

function TADPrecisionThread.GetDefaultTickRateLimit: ADFloat;
begin
  Result := 0;
end;

function TADPrecisionThread.GetInitialThreadState: TADThreadState;
begin
  Result := tsRunning;
end;

function TADPrecisionThread.GetNextTickTime: ADFloat;
begin
  FLock.AcquireRead;
  try
    Result := FNextTickTime;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADPrecisionThread.GetThreadState: TADThreadState;
begin
  FLock.AcquireRead;
  try
    Result := FThreadState;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADPrecisionThread.GetThrottleInterval: Cardinal;
begin
  FLock.AcquireRead;
  try
    Result := FThrottleInterval;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADPrecisionThread.GetTickRate: ADFloat;
begin
  Result := FPerformanceCounter.InstantRate;
end;

function TADPrecisionThread.GetTickRateAverage: ADFloat;
begin
  Result := FPerformanceCounter.AverageRate;
end;

function TADPrecisionThread.GetTickRateAverageOver: Cardinal;
begin
  Result := FPerformanceCounter.AverageOver;
end;

function TADPrecisionThread.GetTickRateDesired: ADFloat;
begin
  FLock.AcquireRead;
  try
    Result := FTickRateDesired;
  finally
    FLock.ReleaseRead;
  end
end;

function TADPrecisionThread.GetTickRateLimit: ADFloat;
begin
  FLock.AcquireRead;
  try
    Result := FTickRateLimit;
  finally
    FLock.ReleaseRead;
  end;
end;

procedure TADPrecisionThread.InitializeTickVariables(var ACurrentTime, ALastAverageCheckpoint, ANextAverageCheckpoint, ATickRate: ADFloat; var AAverageTicks: Integer);
begin
  ACurrentTime := GetReferenceTime;
  FLock.AcquireWrite;
  try
  FNextTickTime := ACurrentTime;
  finally
    FLock.ReleaseWrite;
  end;
  ALastAverageCheckpoint := 0;
  ANextAverageCheckpoint := 0;
  ATickRate := 0;
  AAverageTicks := 0;
end;

procedure TADPrecisionThread.PreTick(const ADelta, AStartTime: ADFloat);
begin
  // Do nothing by default
end;

procedure TADPrecisionThread.Rest;
begin
  FLock.AcquireWrite;
  try
    FThreadState := tsPaused;
    FWakeUp.ResetEvent;
  finally
    FLock.ReleaseWrite;
  end;end;

procedure TADPrecisionThread.SetThreadState(const AThreadState: TADThreadState);
begin
  FLock.AcquireWrite;
  try
    FThreadState := AThreadState;
    case AThreadState of
      tsRunning: FWakeUp.SetEvent;
      tsPaused: FWakeUp.ResetEvent;
    end;
  finally
    FLock.ReleaseWrite;
  end;
end;

procedure TADPrecisionThread.SetThrottleInterval(const AThrottleInterval: Cardinal);
begin
  FLock.AcquireWrite;
  try
    if AThrottleInterval > 0 then
      FThrottleInterval := AThrottleInterval
    else
      FThrottleInterval := 1;
  finally
    FLock.ReleaseWrite;
  end;
end;

procedure TADPrecisionThread.SetTickRateAverageOver(const AAverageOver: Cardinal);
begin
  FPerformanceCounter.AverageOver := AAverageOver;
end;

procedure TADPrecisionThread.SetTickRateDesired(const ADesiredRate: ADFloat);
begin
  FLock.AcquireWrite;
  try
    FTickRateDesired := ADesiredRate;
  finally
    FLock.ReleaseWrite;
  end;
end;

procedure TADPrecisionThread.SetTickRateLimit(const ATickRateLimit: ADFloat);
begin
  FLock.AcquireWrite;
  try
    FTickRateLimit := ATickRateLimit;
    // If the Limit is LOWER than the defined "Desired" Rate, then we cannot desire MORE than the limit,
    // so we match the two.
    if (FTickRateLimit > 0) and (FTickRateLimit < FTickRateDesired) then
      FTickRateDesired := FTickRateLimit;
  finally
    FLock.ReleaseWrite;
  end;
end;

class function TADPrecisionThread.SmartSleep(const ATimeToWait: ADFloat; const AThreshold: Cardinal): Boolean;
begin
  Result := False;
  if (ATimeToWait >= AThreshold / 1000) then
  begin
    TThread.Sleep(AThreshold);
    Result := True;
  end;
end;

procedure TADPrecisionThread.Wake;
begin
  FLock.AcquireWrite;
  try
    FThreadState := tsRunning;
    FWakeUp.SetEvent;
  finally
    FLock.ReleaseWrite;
  end;
end;

initialization
  ReferenceWatch := TStopwatch.Create;

end.
