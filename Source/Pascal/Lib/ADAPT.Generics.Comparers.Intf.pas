{
  AD.A.P.T. Library
  Copyright (C) 2014-2016, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Generics.Comparers.Intf;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes,
  {$ELSE}
    Classes,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Common.Intf;

  {$I ADAPT_RTTI.inc}

type
  IADComparer<T> = interface(IADInterface)
    function AEqualToB(const A, B: T): Boolean;
    function AGreaterThanB(const A, B: T): Boolean;
    function AGreaterThanOrEqualToB(const A, B: T): Boolean;
    function ALessThanB(const A, B: T): Boolean;
    function ALessThanOrEqualToB(const A, B: T): Boolean;
  end;

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
