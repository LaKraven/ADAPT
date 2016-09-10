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
