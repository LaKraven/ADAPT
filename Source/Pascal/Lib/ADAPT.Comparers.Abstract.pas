{
  AD.A.P.T. Library
  Copyright (C) 2014-2018, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Comparers.Abstract;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes, System.SysUtils,
  {$ELSE}
    Classes, SysUtils,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Intf, ADAPT,
  ADAPT.Comparers.Intf;

  {$I ADAPT_RTTI.inc}

type
  ///  <summary><c>Abstract Base Class for Generic Comparers.</c></summary>
  TADComparer<T> = class abstract(TADObject, IADComparer<T>)
  public
    function AEqualToB(const A, B: T): Boolean; virtual; abstract;
    function AGreaterThanB(const A, B: T): Boolean; virtual; abstract;
    function AGreaterThanOrEqualToB(const A, B: T): Boolean; virtual; abstract;
    function ALessThanB(const A, B: T): Boolean; virtual; abstract;
    function ALessThanOrEqualToB(const A, B: T): Boolean; virtual; abstract;
  end;

  ///  <summary><c>Abstract Base Class for Generic Ordinal Comparers.</c></summary>
  TADOrdinalComparer<T> = class abstract(TADComparer<T>, IADOrdinalComparer<T>)
  public
    function Add(const A, B: T): T; virtual; abstract;
    function AddAll(const Values: Array of T): T;
    function Difference(const A, B: T): T;
    function Divide(const A, B: T): T; virtual; abstract;
    function Multiply(const A, B: T): T; virtual; abstract;
    function Subtract(const A, B: T): T; virtual; abstract;
  end;

implementation

{ TADOrdinalComparer<T> }

function TADOrdinalComparer<T>.AddAll(const Values: array of T): T;
var
  I: Integer;
begin
  Result := Default(T);
  for I := Low(Values) to High(Values) do
    if I = Low(Values) then
      Result := Values[I]
    else
      Result := Add(Result, Values[I]);
end;

function TADOrdinalComparer<T>.Difference(const A, B: T): T;
begin
  Result := Subtract(A, B);
end;

end.
