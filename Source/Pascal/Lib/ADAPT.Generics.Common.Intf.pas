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
  TADSortedState = (ssUnknown, ssUnsorted, ssSorted);

  // Callbacks
  {$IFDEF SUPPORTS_REFERENCETOMETHOD}
    TADListItemCallbackAnon<T> = reference to procedure(const AItem: T);
  {$ENDIF SUPPORTS_REFERENCETOMETHOD}
  TADListItemCallbackOfObject<T> = procedure(const AItem: T) of object;
  TADListItemCallbackUnbound<T> = procedure(const AItem: T);
  {$IFDEF SUPPORTS_REFERENCETOMETHOD}
    TADListMapCallbackAnon<TKey, TValue> = reference to procedure(const AKey: TKey; const AValue: TValue);
  {$ENDIF SUPPORTS_REFERENCETOMETHOD}
  TADListMapCallbackOfObject<TKey, TValue> = procedure(const AKey: TKey; const AValue: TValue) of object;
  TADListMapCallbackUnbound<TKey, TValue> = procedure(const AKey: TKey; const AValue: TValue);

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
    // Properties
    property Key: TKey read GetKey;
    property Value: TValue read GetValue;
  end;

implementation

end.
