{
  AD.A.P.T. Library
  Copyright (C) 2014-2016, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Generics.Comparers;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes,
  {$ELSE}
    Classes,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Common.Intf, ADAPT.Common,
  ADAPT.Generics.Comparers.Intf;

  {$I ADAPT_RTTI.inc}

type
  IADCardinalComparer = IADComparer<Cardinal>;
  IADIntegerComparer = IADComparer<Integer>;
  IADFloatComparer = IADComparer<ADFloat>;
  IADStringComparer = IADComparer<String>;

  ///  <summary><c>Abstract Base Class for Generic Comparers.</c></summary>
  TADComparer<T> = class abstract(TADObject, IADComparer<T>)
  public
    function AEqualToB(const A, B: T): Boolean; virtual; abstract;
    function AGreaterThanB(const A, B: T): Boolean; virtual; abstract;
    function AGreaterThanOrEqualToB(const A, B: T): Boolean; virtual; abstract;
    function ALessThanB(const A, B: T): Boolean; virtual; abstract;
    function ALessThanOrEqualToB(const A, B: T): Boolean; virtual; abstract;
  end;

function ADCardinalComparer: IADCardinalComparer;
function ADIntegerComparer: IADIntegerComparer;
function ADFloatComparer: IADFloatComparer;
function ADStringComparer: IADStringComparer;

implementation

var
  GCardinalComparer: IADCardinalComparer;
  GIntegerComparer: IADIntegerComparer;
  GFloatComparer: IADFloatComparer;
  GStringComparer: IADStringComparer;

type
  ///  <summary><c>Specialized Comparer for Cardinal values.</c></summary>
  TADCardinalComparer = class(TADComparer<Cardinal>)
  public
    function AEqualToB(const A, B: Cardinal): Boolean; override;
    function AGreaterThanB(const A, B: Cardinal): Boolean; override;
    function AGreaterThanOrEqualToB(const A, B: Cardinal): Boolean; override;
    function ALessThanB(const A, B: Cardinal): Boolean; override;
    function ALessThanOrEqualToB(const A, B: Cardinal): Boolean; override;
  end;

  ///  <summary><c>Specialized Comparer for Integer values.</c></summary>
  TADIntegerComparer = class(TADComparer<Integer>)
  public
    function AEqualToB(const A, B: Integer): Boolean; override;
    function AGreaterThanB(const A, B: Integer): Boolean; override;
    function AGreaterThanOrEqualToB(const A, B: Integer): Boolean; override;
    function ALessThanB(const A, B: Integer): Boolean; override;
    function ALessThanOrEqualToB(const A, B: Integer): Boolean; override;
  end;

  ///  <summary><c>Specialized Comparer for ADFloat values.</c></summary>
  TADFloatComparer = class(TADComparer<ADFloat>)
  public
    function AEqualToB(const A, B: ADFloat): Boolean; override;
    function AGreaterThanB(const A, B: ADFloat): Boolean; override;
    function AGreaterThanOrEqualToB(const A, B: ADFloat): Boolean; override;
    function ALessThanB(const A, B: ADFloat): Boolean; override;
    function ALessThanOrEqualToB(const A, B: ADFloat): Boolean; override;
  end;

  ///  <summary><c>Specialized Comparer for String values.</c></summary>
  TADStringComparer = class(TADComparer<String>)
  public
    function AEqualToB(const A, B: String): Boolean; override;
    function AGreaterThanB(const A, B: String): Boolean; override;
    function AGreaterThanOrEqualToB(const A, B: String): Boolean; override;
    function ALessThanB(const A, B: String): Boolean; override;
    function ALessThanOrEqualToB(const A, B: String): Boolean; override;
  end;

{ Singleton Getters }

function ADCardinalComparer: IADCardinalComparer;
begin
  Result := GCardinalComparer;
end;

function ADIntegerComparer: IADIntegerComparer;
begin
  Result := GIntegerComparer;
end;

function ADFloatComparer: IADFloatComparer;
begin
  Result := GFloatComparer;
end;

function ADStringComparer: IADStringComparer;
begin
  Result := GStringComparer;
end;

{ TADCardinalComparer }

function TADCardinalComparer.AEqualToB(const A, B: Cardinal): Boolean;
begin
  Result := (A = B);
end;

function TADCardinalComparer.AGreaterThanB(const A, B: Cardinal): Boolean;
begin
  Result := (A > B);
end;

function TADCardinalComparer.AGreaterThanOrEqualToB(const A, B: Cardinal): Boolean;
begin
  Result := (A >= B);
end;

function TADCardinalComparer.ALessThanB(const A, B: Cardinal): Boolean;
begin
  Result := (A < B);
end;

function TADCardinalComparer.ALessThanOrEqualToB(const A, B: Cardinal): Boolean;
begin
  Result := (A <= B);
end;

{ TADIntegerComparer }

function TADIntegerComparer.AEqualToB(const A, B: Integer): Boolean;
begin
  Result := (A = B);
end;

function TADIntegerComparer.AGreaterThanB(const A, B: Integer): Boolean;
begin
  Result := (A > B);
end;

function TADIntegerComparer.AGreaterThanOrEqualToB(const A, B: Integer): Boolean;
begin
  Result := (A >= B);
end;

function TADIntegerComparer.ALessThanB(const A, B: Integer): Boolean;
begin
  Result := (A < B);
end;

function TADIntegerComparer.ALessThanOrEqualToB(const A, B: Integer): Boolean;
begin
  Result := (A <= B);
end;

{ TADFloatComparer }

function TADFloatComparer.AEqualToB(const A, B: ADFloat): Boolean;
begin
  Result := (A = B);
end;

function TADFloatComparer.AGreaterThanB(const A, B: ADFloat): Boolean;
begin
  Result := (A > B);
end;

function TADFloatComparer.AGreaterThanOrEqualToB(const A, B: ADFloat): Boolean;
begin
  Result := (A >= B);
end;

function TADFloatComparer.ALessThanB(const A, B: ADFloat): Boolean;
begin
  Result := (A < B);
end;

function TADFloatComparer.ALessThanOrEqualToB(const A, B: ADFloat): Boolean;
begin
  Result := (A <= B);
end;

{ TADStringComparer }

function TADStringComparer.AEqualToB(const A, B: String): Boolean;
begin
  Result := (A = B);
end;

function TADStringComparer.AGreaterThanB(const A, B: String): Boolean;
begin
  Result := (A > B);
end;

function TADStringComparer.AGreaterThanOrEqualToB(const A, B: String): Boolean;
begin
  Result := (A >= B);
end;

function TADStringComparer.ALessThanB(const A, B: String): Boolean;
begin
  Result := (A < B);
end;

function TADStringComparer.ALessThanOrEqualToB(const A, B: String): Boolean;
begin
  Result := (A <= B);
end;

initialization
  GIntegerComparer := TADIntegerComparer.Create;
  GFloatComparer := TADFloatComparer.Create;
  GStringComparer := TADStringComparer.Create;

end.
