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
  ///  <summary><c>Defines the Ownership role of a container.</c></summary>
  TADOwnership = (oOwnsObjects, oNotOwnsObjects);
  ///  <summary><c>Defines the direction of an Iteration operation.</c></summary>
  TADIterateDirection = (idLeft, idRight);
  ///  <summary><c>Defines the Sorted State of a Collection.</c></summary>
  TADSortedState = (ssUnknown, ssUnsorted, ssSorted);

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
  ///  <summary><c>A Collection that can Own Objects.</c></summary>
  IADObjectOwner = interface(IADInterface)
  ['{5756A232-26B6-4395-9F1D-CCCC071E5701}']
    // Getters
    function GetOwnership: TADOwnership;
    // Setters
    procedure SetOwnership(const AOwnership: TADOwnership);
    // Properties
    property Ownership: TADOwnership read GetOwnership write SetOwnership;
  end;

  ///  <summary><c>A Generic Object Holder that can Own the Object it Holds.</c></summary>
  IADObjectHolder<T: class> = interface(IADObjectOwner)
    // Getters
    function GetObject: T;
    // Properties
    property HeldObject: T read GetObject;
  end;

  ///  <summary><c>A Generic Value Holder.</c></summary>
  IADValueHolder<T> = interface(IADInterface)
    // Getters
    function GetValue: T;
    // Properties
    property Value: T read GetValue;
  end;

  ///  <summary><c>A simple associative Pair consisting of a Key and a Value.</c></summary>
  IADKeyValuePair<TKey, TValue> = interface(IADInterface)
    // Getters
    function GetKey: TKey;
    function GetValue: TValue;
    // Setters
    procedure SetValue(const AValue: TValue);
    // Properties
    property Key: TKey read GetKey;
    property Value: TValue read GetValue write SetValue;
  end;

  ///  <summary><c>Used to Compare two Generic Values.</c></summary>
  IADComparer<T> = interface(IADInterface)
    function AEqualToB(const A, B: T): Boolean;
    function AGreaterThanB(const A, B: T): Boolean;
    function AGreaterThanOrEqualToB(const A, B: T): Boolean;
    function ALessThanB(const A, B: T): Boolean;
    function ALessThanOrEqualToB(const A, B: T): Boolean;
  end;

  ///  <summary><c>Provides Getter and Setter for any Type utilizing a Comparer Type.</c></summary>
  IADComparable<T> = interface(IADInterface)
  ['{88444CD4-80FD-495C-A3D7-121CA14F7AC7}'] // If we don't provide a GUID here, we cannot cast-reference Collections as "Comparables".
    // Getters
    function GetComparer: IADComparer<T>;
    // Setters
    procedure SetComparer(const AComparer: IADComparer<T>);
    // Properties
    property Comparer: IADComparer<T> read GetComparer write SetComparer;
  end;

implementation

end.
