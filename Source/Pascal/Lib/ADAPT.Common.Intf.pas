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
