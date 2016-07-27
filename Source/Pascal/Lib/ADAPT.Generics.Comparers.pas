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
  ///  <summary><c>Abstract Base Class for Generic Comparers.</c></summary>
  TADComparer<T> = class abstract(TADObject, IADComparer<T>)
  public
    function AEqualToB(const A, B: T): Boolean; virtual; abstract;
    function AGreaterThanB(const A, B: T): Boolean; virtual; abstract;
    function AGreaterThanOrEqualToB(const A, B: T): Boolean; virtual; abstract;
    function ALessThanB(const A, B: T): Boolean; virtual; abstract;
    function ALessThanOrEqualToB(const A, B: T): Boolean; virtual; abstract;
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

  ///  <summary><c>Specialized Comparer for ADFloat values.</c></summary>
  TADFloatComparer = class(TADComparer<ADFloat>)
  public
    function AEqualToB(const A, B: ADFloat): Boolean; override;
    function AGreaterThanB(const A, B: ADFloat): Boolean; override;
    function AGreaterThanOrEqualToB(const A, B: ADFloat): Boolean; override;
    function ALessThanB(const A, B: ADFloat): Boolean; override;
    function ALessThanOrEqualToB(const A, B: ADFloat): Boolean; override;
  end;

implementation

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


end.
