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
unit ADAPT.Common;

{$I ADAPT.inc}

{$IFDEF FPC}
  {$IFNDEF ADAPT_SUPPRESS_VERSION_WARNING}
    {.$IF FPC_VERSION < 3}
      {.$ERROR 'FreePascal (FPC) 3.0 or above is required for the ADAPT.'}
      {.$DEFINE ADAPT_WARNING_VERSION}
    {.$IFEND FPC_VERSION}
  {$ENDIF ADAPT_SUPPRESS_VERSION_WARNING}
{$ELSE}
  {$IFNDEF ADAPT_SUPPRESS_VERSION_WARNING}
    {$IFNDEF DELPHIXE2_UP}
      {$MESSAGE WARN 'Delphi 2010 and XE are not regularly tested with the ADAPT. Please report any issues on https://github.com/LaKraven/ADAPT'}
      {$DEFINE ADAPT_WARNING_VERSION}
    {$ENDIF DELPHIXE2_UP}
  {$ENDIF ADAPT_SUPPRESS_VERSION_WARNING}
{$ENDIF FPC}

{$IFDEF ADAPT_WARNING_VERSION}
  {$MESSAGE HINT 'Define "ADAPT_SUPPRESS_VERSION_WARNING" in your project options to get rid of these messages'}
  {$UNDEF ADAPT_WARNING_VERSION}
{$ENDIF ADAPT_WARNING_VERSION}

{$IFNDEF ADAPT_SUPPRESS_DEPRECATION_WARNING}
  // Nothing deprecated to warn about at this moment
  {$IFDEF ADAPT_WARNING_DEPRECATION}
    {$MESSAGE HINT 'Define "ADAPT_SUPPRESS_DEPRECATION_WARNING" in your project options to get rid of these messages'}
  {$ENDIF ADAPT_WARNING_DEPRECATION}
{$ENDIF ADAPT_SUPPRESS_DEPRECATION_WARNING}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes, System.SysUtils, System.SyncObjs,
  {$ELSE}
    Classes, SysUtils, SyncObjs,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Common.Intf;

  {$I ADAPT_RTTI.inc}

type
  { Class Forward Declarations }
  TADObject = class;
  TADPersistent = class;
  TADAggregatedObject = class;
  TADReadWriteLock = class;
  TADObjectTS = class;
  TADPersistentTS = class;

  { Enums }
  ///  <summary><c>Defines the Ownership role of a container.</c></summary>
  TADOwnership = (oOwnsObjects, oNotOwnsObjects);

  {$IFDEF ADAPT_FLOAT_SINGLE}
    ///  <summary><c>Single-Precision Floating Point Type.</c></summary>
    ADFloat = Single;
  {$ELSE}
    {$IFDEF ADAPT_FLOAT_EXTENDED}
      ///  <summary><c>Extended-Precision Floating Point Type.</c></summary>
      ADFloat = Extended;
    {$ELSE}
      ///  <summary><c>Double-Precision Floating Point Type.</c></summary>
      ADFloat = Double; // This is our default
    {$ENDIF ADAPT_FLOAT_DOUBLE}
  {$ENDIF ADAPT_FLOAT_SINGLE}

  ///  <summary><c>ADAPT Base Excpetion Type.</c></summary>
  EADException = class abstract(Exception);

  ///  <summary><c>ADAPT Base Object Type.</c></summary>
  ///  <remarks><c>All Classes in ADAPT are Interfaced unless otherwise stated.</c></remarks>
  TADObject = class abstract(TInterfacedObject, IADInterface)
  private
    function GetInstanceGUID: TGUID;
  protected
    FInstanceGUID: TGUID;
  public
    constructor Create; virtual;
    property InstanceGUID: TGUID read GetInstanceGUID;
  end;

  ///  <summary><c>ADAPT Base Persistent Type.</c></summary>
  ///  <remarks>
  ///    <para><c>All Classes in ADAPT are Interfaced unless otherwise stated.</c></para>
  ///    <para><c>There is no Reference Counting on Persistent Types.</c></para>
  ///  </remarks>
  TADPersistent = class abstract(TInterfacedPersistent, IADInterface)
  private
    function GetInstanceGUID: TGUID;
  protected
    FInstanceGUID: TGUID;
  public
    constructor Create; virtual;
    property InstanceGUID: TGUID read GetInstanceGUID;
  end;

  ///  <summary><c>ADAPT Base Aggregated Object Type.</c></summary>
  ///  <remarks><c>All Classes in ADAPT are Interfaced unless otherwise stated.</c></remarks>
  TADAggregatedObject = class abstract(TAggregatedObject, IADInterface)
  private
    function GetInstanceGUID: TGUID;
  protected
    FInstanceGUID: TGUID;
  public
    constructor Create(const Controller: IInterface); reintroduce; virtual;
    property InstanceGUID: TGUID read GetInstanceGUID;
  end;

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

implementation

{ TADObject }

constructor TADObject.Create;
begin
  CreateGUID(FInstanceGUID);
end;

function TADObject.GetInstanceGUID: TGUID;
begin
  Result := FInstanceGUID;
end;

{ TADPersistent }

constructor TADPersistent.Create;
begin
  inherited Create;
  CreateGUID(FInstanceGUID);
end;

function TADPersistent.GetInstanceGUID: TGUID;
begin
  Result := FInstanceGUID;
end;

{ TADAggregatedObject }

constructor TADAggregatedObject.Create(const Controller: IInterface);
begin
  inherited Create(Controller);
  CreateGUID(FInstanceGUID);
end;

function TADAggregatedObject.GetInstanceGUID: TGUID;
begin
  Result := FInstanceGUID;
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
  FLock := TADReadWriteLock.Create(Self);
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
  FLock := TADReadWriteLock.Create(Self);
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

end.
