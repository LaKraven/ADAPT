{
  AD.A.P.T. Library
  Copyright (C) 2014-2016, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Threadsafe;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes, System.SysUtils, System.SyncObjs,
  {$ELSE}
    Classes, SysUtils, SyncObjs,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Intf, ADAPT;

  {$I ADAPT_RTTI.inc}

type
  TADReadWriteLock = class;
  TADObjectTS = class;
  TADPersistentTS = class;


  ///  <summary><c>Multiple-Read, Exclusive Write Locking for Thread-Safety.</c></summary>
  TADReadWriteLock = class(TADAggregatedObject, IADReadWriteLock)
  private
    {$IFDEF ADAPT_LOCK_ALLEXCLUSIVE}
      FWriteLock: TCriticalSection;
    {$ELSE}
      FActiveThread: Cardinal; // ID of the current Thread holding the Write Lock
      FCountReads: {$IFDEF DELPHI}Int64{$ELSE}LongWord{$ENDIF DELPHI}; // Number of Read Operations in Progress
      FCountWrites: {$IFDEF DELPHI}Int64{$ELSE}LongWord{$ENDIF DELPHI}; // Number of Write Operations in Progress
      FLockState: Cardinal; // 0 = Waiting, 1 = Reading, 2 = Writing
      FWaitRead,
      FWaitWrite: TEvent;
      function GetLockState: TADReadWriteLockState;
      function GetThreadMatch: Boolean;
      procedure SetActiveThread;
      procedure SetLockState(const ALockState: TADReadWriteLockState);
      protected
        function AcquireReadActual: Boolean;
        function AcquireWriteActual: Boolean;
    {$ENDIF ADAPT_LOCK_ALLEXCLUSIVE}
  public
    constructor Create(const Controller: IInterface); override;
    destructor Destroy; override;
    procedure AcquireRead;
    procedure AcquireWrite;
    procedure ReleaseRead;
    procedure ReleaseWrite;
    function TryAcquireRead: Boolean;
    function TryAcquireWrite: Boolean;

    procedure WithRead(const ACallback: TADCallbackUnbound); overload;
    procedure WithRead(const ACallback: TADCallbackOfObject); overload;
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure WithRead(const ACallback: TADCallbackAnonymous); overload;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}

    procedure WithWrite(const ACallback: TADCallbackUnbound); overload;
    procedure WithWrite(const ACallback: TADCallbackOfObject); overload;
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure WithWrite(const ACallback: TADCallbackAnonymous); overload;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}

    {$IFNDEF ADAPT_LOCK_ALLEXCLUSIVE}
      property LockState: TADReadWriteLockState read GetLockState;
    {$ENDIF ADAPT_LOCK_ALLEXCLUSIVE}
  end;

  ///  <summary><c>Abstract Base Object Type containing a Threadsafe Lock.</c></summary>
  ///  <remarks><c>You only want to inherit from this if there is NO situation in which you would want a non-Threadsafe Instance.</c></remarks>
  TADObjectTS = class abstract(TADObject, IADReadWriteLock)
  protected
    FLock: TADReadWriteLock;
    function GetLock: IADReadWriteLock;
  public
    constructor Create; override;
    destructor Destroy; override;

    property Lock: IADReadWriteLock read GetLock implements IADReadWriteLock;
  end;

  ///  <summary><c>Abstract Base Persistent Type containing a Thread-Safe Lock.</c></summary>
  ///  <remarks><c>You only want to inherit from this if there is NO situation in which you would want a non-Threadsafe Instance.</c></remarks>
  TADPersistentTS = class abstract(TADPersistent, IADReadWriteLock)
  protected
    FLock: TADReadWriteLock;
    function GetLock: IADReadWriteLock;
  public
    constructor Create; override;
    destructor Destroy; override;

    property Lock: IADReadWriteLock read GetLock implements IADReadWriteLock;
  end;

  TADObjectHolderTS<T: class> = class(TADObjectHolder<T>, IADReadWriteLock)
  private
    FLock: TADReadWriteLock;
    function GetLock: IADReadWriteLock;
  protected
    // Getters
    { IADObjectOwner }
    function GetOwnership: TADOwnership; override;
    { IADObjectHolder<T> }
    function GetObject: T; override;

    // Setters
    { IADObjectOwner }
    procedure SetOwnership(const AOwnership: TADOwnership); override;
  public
    constructor Create(const AObject: T; const AOwnership: TADOwnership = oOwnsObjects); override;
    destructor Destroy; override;

    property Lock: IADReadWriteLock read GetLock implements IADReadWriteLock;
  end;

function ADReadWriteLock(const Controller: IInterface): TADReadWriteLock;

implementation

function ADReadWriteLock(const Controller: IInterface): TADReadWriteLock;
begin
  Result := TADReadWriteLock.Create(Controller);
end;

{ TADReadWriteLock }

procedure TADReadWriteLock.AcquireRead;
{$IFNDEF ADAPT_LOCK_ALLEXCLUSIVE}
  var
    LAcquired: Boolean;
{$ENDIF ADAPT_LOCK_ALLEXCLUSIVE}
begin
  {$IFDEF ADAPT_LOCK_ALLEXCLUSIVE}
    FWriteLock.Enter;
  {$ELSE}
    repeat
      LAcquired := AcquireReadActual;
    until LAcquired;

  {$ENDIF ADAPT_LOCK_ALLEXCLUSIVE}
end;

{$IFNDEF ADAPT_LOCK_ALLEXCLUSIVE}
  function TADReadWriteLock.AcquireReadActual: Boolean;
  begin
    Result := False;
    case GetLockState of
      lsWaiting, lsReading: begin
                              FWaitRead.ResetEvent;
                              SetLockState(lsReading);
                              {$IFDEF DELPHI}AtomicIncrement{$ELSE}InterlockedIncrement{$ENDIF DELPHI}(FCountReads);
                              Result := True;
                            end;
      lsWriting: begin
                   Result := GetThreadMatch;
                   if (not Result) then
                     FWaitWrite.WaitFor(500)
                   else
                     {$IFDEF DELPHI}AtomicIncrement{$ELSE}InterlockedIncrement{$ENDIF DELPHI}(FCountReads);
                 end;
    end;
  end;
{$ENDIF ADAPT_LOCK_ALLEXCLUSIVE}

procedure TADReadWriteLock.AcquireWrite;
{$IFNDEF ADAPT_LOCK_ALLEXCLUSIVE}
  var
    LAcquired: Boolean;
{$ENDIF ADAPT_LOCK_ALLEXCLUSIVE}
begin
  {$IFDEF ADAPT_LOCK_ALLEXCLUSIVE}
    FWriteLock.Enter;
  {$ELSE}
    repeat
      LAcquired := AcquireWriteActual;
    until LAcquired;
  {$ENDIF ADAPT_LOCK_ALLEXCLUSIVE}
end;

{$IFNDEF ADAPT_LOCK_ALLEXCLUSIVE}
  function TADReadWriteLock.AcquireWriteActual: Boolean;
  begin
    Result := False;
    case GetLockState of
      lsWaiting: begin
                   FWaitWrite.ResetEvent;
                   SetActiveThread;
                   SetLockState(lsWriting);
                   {$IFDEF DELPHI}AtomicIncrement{$ELSE}InterlockedIncrement{$ENDIF DELPHI}(FCountWrites);
                   Result := True;
                 end;
      lsReading: FWaitRead.WaitFor(500);
      lsWriting: begin
                   Result := GetThreadMatch;
                   if Result then
                     {$IFDEF DELPHI}AtomicIncrement{$ELSE}InterlockedIncrement{$ENDIF DELPHI}(FCountWrites);
                 end;
    end;
  end;
{$ENDIF ADAPT_LOCK_ALLEXCLUSIVE}

constructor TADReadWriteLock.Create(const Controller: IInterface);
begin
  inherited Create(Controller);
  {$IFDEF ADAPT_LOCK_ALLEXCLUSIVE}
    FWriteLock := TCriticalSection.Create;
  {$ELSE}
    FWaitRead := TEvent.Create(nil, True, True, '');
    FWaitWrite := TEvent.Create(nil, True, True, '');
    FActiveThread := 0; // Since there's no Thread yet
    FCountReads := 0;
    FCountWrites := 0;
    FLockState := 0; // Waiting by default
  {$ENDIF ADAPT_LOCK_ALLEXCLUSIVE}
end;

destructor TADReadWriteLock.Destroy;
begin
  {$IFDEF ADAPT_LOCK_ALLEXCLUSIVE}
    FWriteLock.{$IFDEF SUPPORTS_DISPOSEOF}DisposeOf{$ELSE}Free{$ENDIF SUPPORTS_DISPOSEOF};
  {$ELSE}
    FWaitRead.SetEvent;
    FWaitWrite.SetEvent;
    FWaitRead.{$IFDEF SUPPORTS_DISPOSEOF}DisposeOf{$ELSE}Free{$ENDIF SUPPORTS_DISPOSEOF};
    FWaitWrite.{$IFDEF SUPPORTS_DISPOSEOF}DisposeOf{$ELSE}Free{$ENDIF SUPPORTS_DISPOSEOF};
  {$ENDIF ADAPT_LOCK_ALLEXCLUSIVE}
  inherited;
end;

{$IFNDEF ADAPT_LOCK_ALLEXCLUSIVE}
  function TADReadWriteLock.GetLockState: TADReadWriteLockState;
  const
    LOCK_STATES: Array[0..2] of TADReadWriteLockState = (lsWaiting, lsReading, lsWriting);
  begin
    Result := LOCK_STATES[{$IFDEF DELPHI}AtomicIncrement{$ELSE}InterlockedExchangeAdd{$ENDIF DELPHI}(FLockState, 0)];
  end;

  function TADReadWriteLock.GetThreadMatch: Boolean;
  begin
    Result := {$IFDEF DELPHI}AtomicIncrement{$ELSE}InterlockedExchangeAdd{$ENDIF DELPHI}(FActiveThread, 0) = TThread.CurrentThread.ThreadID;
  end;
{$ENDIF ADAPT_LOCK_ALLEXCLUSIVE}

procedure TADReadWriteLock.ReleaseRead;
begin
  {$IFDEF ADAPT_LOCK_ALLEXCLUSIVE}
    FWriteLock.Leave;
  {$ELSE}
    case GetLockState of
      lsWaiting: raise Exception.Create('Lock State not Read, cannot Release Read on a Waiting Lock!');
      lsReading: begin
                   if {$IFDEF DELPHI}AtomicDecrement{$ELSE}InterlockedDecrement{$ENDIF DELPHI}(FCountReads) = 0 then
                   begin
                     SetLockState(lsWaiting);
                     FWaitRead.SetEvent;
                   end;
                 end;
      lsWriting: begin
                   if (not GetThreadMatch) then
                     raise Exception.Create('Lock State not Read, cannot Release Read on a Write Lock!');
                 end;
    end;
  {$ENDIF ADAPT_LOCK_ALLEXCLUSIVE}
end;

procedure TADReadWriteLock.ReleaseWrite;
begin
  {$IFDEF ADAPT_LOCK_ALLEXCLUSIVE}
    FWriteLock.Leave;
  {$ELSE}
    case GetLockState of
      lsWaiting: raise Exception.Create('Lock State not Write, cannot Release Write on a Waiting Lock!');
      lsReading: begin
                   if (not GetThreadMatch) then
                     raise Exception.Create('Lock State not Write, cannot Release Write on a Read Lock!');
                 end;
      lsWriting: begin
                   if GetThreadMatch then
                   begin
                     if {$IFDEF DELPHI}AtomicDecrement{$ELSE}InterlockedDecrement{$ENDIF DELPHI}(FCountWrites) = 0 then
                     begin
                       SetLockState(lsWaiting);
                       {$IFDEF DELPHI}AtomicExchange{$ELSE}InterlockedExchange{$ENDIF DELPHI}(FActiveThread, 0);
                       FWaitWrite.SetEvent;
                     end;
                   end;
                 end;
    end;
  {$ENDIF ADAPT_LOCK_ALLEXCLUSIVE}
end;

{$IFNDEF ADAPT_LOCK_ALLEXCLUSIVE}
  procedure TADReadWriteLock.SetActiveThread;
  begin
    {$IFDEF DELPHI}AtomicExchange{$ELSE}InterlockedExchange{$ENDIF DELPHI}(FActiveThread, TThread.CurrentThread.ThreadID);
  end;

  procedure TADReadWriteLock.SetLockState(const ALockState: TADReadWriteLockState);
  const
    LOCK_STATES: Array[TADReadWriteLockState] of Integer = (0, 1, 2);
  begin
    {$IFDEF DELPHI}AtomicExchange{$ELSE}InterlockedExchange{$ENDIF DELPHI}(FLockState, LOCK_STATES[ALockState]);
  end;
{$ENDIF ADAPT_LOCK_ALLEXCLUSIVE}

function TADReadWriteLock.TryAcquireRead: Boolean;
begin
  {$IFDEF ADAPT_LOCK_ALLEXCLUSIVE}
    Result := FWriteLock.TryEnter;
  {$ELSE}
    Result := AcquireReadActual;
  {$ENDIF ADAPT_LOCK_ALLEXCLUSIVE}
end;

function TADReadWriteLock.TryAcquireWrite: Boolean;
begin
  {$IFDEF ADAPT_LOCK_ALLEXCLUSIVE}
    Result := FWriteLock.TryEnter;
  {$ELSE}
    Result := AcquireWriteActual;
  {$ENDIF ADAPT_LOCK_ALLEXCLUSIVE}
end;

procedure TADReadWriteLock.WithRead(const ACallback: TADCallbackUnbound);
begin
  AcquireRead;
  try
    ACallback;
  finally
    ReleaseRead;
  end;
end;

procedure TADReadWriteLock.WithRead(const ACallback: TADCallbackOfObject);
begin
  AcquireRead;
  try
    ACallback;
  finally
    ReleaseRead;
  end;
end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADReadWriteLock.WithRead(const ACallback: TADCallbackAnonymous);
  begin
    AcquireRead;
    try
      ACallback;
    finally
      ReleaseRead;
    end;
  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADReadWriteLock.WithWrite(const ACallback: TADCallbackUnbound);
begin
  AcquireWrite;
  try
    ACallback;
  finally
    ReleaseWrite;
  end;
end;

procedure TADReadWriteLock.WithWrite(const ACallback: TADCallbackOfObject);
begin
  AcquireWrite;
  try
    ACallback;
  finally
    ReleaseWrite;
  end;
end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADReadWriteLock.WithWrite(const ACallback: TADCallbackAnonymous);
  begin
    AcquireWrite;
    try
      ACallback;
    finally
      ReleaseWrite;
    end;
  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

{ TADObjectTS }

constructor TADObjectTS.Create;
begin
  inherited;
  FLock := ADReadWriteLock(Self);
end;

destructor TADObjectTS.Destroy;
begin
  FLock.{$IFDEF SUPPORTS_DISPOSEOF}DisposeOf{$ELSE}Free{$ENDIF SUPPORTS_DISPOSEOF};
  inherited;
end;

function TADObjectTS.GetLock: IADReadWriteLock;
begin
  Result := FLock;
end;

{ TADPersistentTS }

constructor TADPersistentTS.Create;
begin
  inherited;
  FLock := ADReadWriteLock(Self);
end;

destructor TADPersistentTS.Destroy;
begin
  FLock.{$IFDEF SUPPORTS_DISPOSEOF}DisposeOf{$ELSE}Free{$ENDIF SUPPORTS_DISPOSEOF};
  inherited;
end;

function TADPersistentTS.GetLock: IADReadWriteLock;
begin
  Result := FLock;
end;

{ TADObjectHolderTS<T> }

constructor TADObjectHolderTS<T>.Create(const AObject: T; const AOwnership: TADOwnership);
begin
  inherited;
  FLock := ADReadWriteLock(Self);
end;

destructor TADObjectHolderTS<T>.Destroy;
begin
  FLock.{$IFDEF SUPPORTS_DISPOSEOF}DisposeOf{$ELSE}Free{$ENDIF SUPPORTS_DISPOSEOF};
  inherited;
end;

function TADObjectHolderTS<T>.GetLock: IADReadWriteLock;
begin
  Result := FLock;
end;

function TADObjectHolderTS<T>.GetObject: T;
begin
  FLock.AcquireRead;
  try
    Result := inherited;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADObjectHolderTS<T>.GetOwnership: TADOwnership;
begin
  FLock.AcquireRead;
  try
    Result := inherited;
  finally
    FLock.ReleaseRead;
  end;
end;

procedure TADObjectHolderTS<T>.SetOwnership(const AOwnership: TADOwnership);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

end.
