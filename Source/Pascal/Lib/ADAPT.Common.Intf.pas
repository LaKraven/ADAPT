{
  AD.A.P.T. Library
  Copyright (C) 2014-2016, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Common.Intf;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes;
  {$ELSE}
    Classes;
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}

  {$I ADAPT_RTTI.inc}

type
  ///  <summary><c>Defines the present State of a Read/Write Lock.</c></summary>
  TADReadWriteLockState = (lsWaiting, lsReading, lsWriting);

  ///  <summary><c>Typedef for an Unbound Parameterless Callback method.</c></summary>
  TADCallbackUnbound = procedure;
  ///  <summary><c>Typedef for an Object-Bound Parameterless Callback method.</c></summary>
  TADCallbackOfObject = procedure of object;
  {$IFDEF SUPPORTS_REFERENCETOMETHOD}
    ///  <summary><c>Typedef for an Anonymous Parameterless Callback method.</c></summary>
    TADCallbackAnonymous = reference to procedure;
  {$ENDIF SUPPORTS_REFERENCETOMETHOD}

  ///  <summary><c></c></summary>
  IADInterface = interface
  ['{FF2AF334-2A54-414B-AF23-D80EFA93715A}']
    function GetInstanceGUID: TGUID;

    property InstanceGUID: TGUID read GetInstanceGUID;
  end;

  ///  <summary><c>Multiple-Read, Exclusive Write Locking for Thread-Safety.</c></summary>
  IADReadWriteLock = interface(IADInterface)
  ['{F88991C1-0B3D-4427-9D6D-4A69C187CFAA}']
    procedure AcquireRead;
    procedure AcquireWrite;
    {$IFNDEF ADAPT_LOCK_ALLEXCLUSIVE}
      function GetLockState: TADReadWriteLockState;
    {$ENDIF ADAPT_LOCK_ALLEXCLUSIVE}
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


implementation

end.
