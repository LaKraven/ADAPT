{
  AD.A.P.T. Library
  Copyright (C) 2014-2018, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Comparers.Intf;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes,
  {$ELSE}
    Classes,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Intf;

  {$I ADAPT_RTTI.inc}

type
  ///  <summary><c>Used to Compare two Values of a Generic Type.</c></summary>
  IADComparer<T> = interface(IADInterface)
    function AEqualToB(const A, B: T): Boolean;
    function AGreaterThanB(const A, B: T): Boolean;
    function AGreaterThanOrEqualToB(const A, B: T): Boolean;
    function ALessThanB(const A, B: T): Boolean;
    function ALessThanOrEqualToB(const A, B: T): Boolean;
  end;

  ///  <summary><c>Used to compare two Values of a Generic Ordinal Type.</c></summary>
  ///  <remarks><c>Provides basic Mathematical Functions as well as Equality Comparers.</c></summary>
  IADOrdinalComparer<T> = interface(IADComparer<T>)
    ///  <returns><c>The Sum of both given Values.<c></returns>
    function Add(const A, B: T): T;
    ///  <returns><c>The Sum of ALL given Values.</c></returns>
    function AddAll(const Values: Array of T): T;
    ///  <returns><c>The Difference between the two given Values.</c></returns>
    function Difference(const A, B: T): T;
    ///  <returns><c>Value A divided by Value B.</c></returns>
    function Divide(const A, B: T): T;
    ///  <returns><c>Value A multiplied by Value B.</c></returns>
    function Multiply(const A, B: T): T;
    ///  <returns><c>Value B Subtracted from Value A.</c></returns>
    function Subtract(const A, B: T): T;
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

  IADOrdinalComparable<T> = interface(IADInterface)
  ['{A745312E-B645-4645-8A72-5CD50B263067}']
    // Getters
    function GetComparer: IADOrdinalComparer<T>;
    // Setters
    procedure SetComparer(const AComparer: IADOrdinalComparer<T>);
    // Properties
    property Comparer: IADOrdinalComparer<T> read GetComparer write SetComparer;
  end;


implementation

end.
