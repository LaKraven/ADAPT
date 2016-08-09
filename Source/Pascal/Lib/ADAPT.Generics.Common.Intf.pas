{
  AD.A.P.T. Library
  Copyright (C) 2014-2016, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Generics.Common.Intf;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes,
  {$ELSE}
    Classes,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Common, ADAPT.Common.Intf;

  {$I ADAPT_RTTI.inc}

type
  // Enums
  TADIterateDirection = (idLeft, idRight);

  // Callbacks
  {$IFDEF SUPPORTS_REFERENCETOMETHOD}
    TADListItemCallbackAnon<T> = reference to procedure(const AItem: T);
  {$ENDIF SUPPORTS_REFERENCETOMETHOD}
  TADListItemCallbackOfObject<T> = procedure(const AItem: T) of object;
  TADListItemCallbackUnbound<T> = procedure(const AItem: T);
  {$IFDEF SUPPORTS_REFERENCETOMETHOD}
    TADListPairCallbackAnon<TKey, TValue> = reference to procedure(const AKey: TKey; const AValue: TValue);
  {$ENDIF SUPPORTS_REFERENCETOMETHOD}
  TADListPairCallbackOfObject<TKey, TValue> = procedure(const AKey: TKey; const AValue: TValue) of object;
  TADListPairCallbackUnbound<TKey, TValue> = procedure(const AKey: TKey; const AValue: TValue);

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

  ///  <summary><c>Common Interface for any Iterable Collection.</c></summary>
  IADIterable<T> = interface(IADInterface)
  ['{910A3785-06C0-4512-A823-3AA4D77BDB18}'] // If we don't provide a GUID here, we cannot cast-reference Collections as "Iterables".
    // Iterators
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure Iterate(const ACallback: TADListItemCallbackAnon<T>; const ADirection: TADIterateDirection = idRight); overload;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure Iterate(const ACallback: TADListItemCallbackOfObject<T>; const ADirection: TADIterateDirection = idRight); overload;
    procedure Iterate(const ACallback: TADListItemCallbackUnbound<T>; const ADirection: TADIterateDirection = idRight); overload;
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure IterateBackward(const ACallback: TADListItemCallbackAnon<T>); overload;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure IterateBackward(const ACallback: TADListItemCallbackOfObject<T>); overload;
    procedure IterateBackward(const ACallback: TADListItemCallbackUnbound<T>); overload;
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure IterateForward(const ACallback: TADListItemCallbackAnon<T>); overload;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure IterateForward(const ACallback: TADListItemCallbackOfObject<T>); overload;
    procedure IterateForward(const ACallback: TADListItemCallbackUnbound<T>); overload;
  end;

  ///  <summary><c>Common Interface for any Iterable Pair Collection.</c></summary>
  IADIterablePair<TKey, TValue> = interface(IADInterface)
  ['{372E785D-D37D-4B12-88C7-195073061FA4}']
    // Iterators
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure Iterate(const ACallback: TADListPairCallbackAnon<TKey, TValue>; const ADirection: TADIterateDirection = idRight); overload;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure Iterate(const ACallback: TADListPairCallbackOfObject<TKey, TValue>; const ADirection: TADIterateDirection = idRight); overload;
    procedure Iterate(const ACallback: TADListPairCallbackUnbound<TKey, TValue>; const ADirection: TADIterateDirection = idRight); overload;
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure IterateBackward(const ACallback: TADListPairCallbackAnon<TKey, TValue>); overload;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure IterateBackward(const ACallback: TADListPairCallbackOfObject<TKey, TValue>); overload;
    procedure IterateBackward(const ACallback: TADListPairCallbackUnbound<TKey, TValue>); overload;
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure IterateForward(const ACallback: TADListPairCallbackAnon<TKey, TValue>); overload;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure IterateForward(const ACallback: TADListPairCallbackOfObject<TKey, TValue>); overload;
    procedure IterateForward(const ACallback: TADListPairCallbackUnbound<TKey, TValue>); overload;
  end;

  IADKeyValuePair<TKey, TValue> = interface(IADInterface)
    // Getters
    function GetKey: TKey;
    function GetValue: TValue;
    // Properties
    property Key: TKey read GetKey;
    property Value: TValue read GetValue;
  end;

implementation

end.
