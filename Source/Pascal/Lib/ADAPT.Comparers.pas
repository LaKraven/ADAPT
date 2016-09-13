{
  AD.A.P.T. Library
  Copyright (C) 2014-2016, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Comparers;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes, System.SysUtils,
  {$ELSE}
    Classes, SysUtils,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Common.Intf, ADAPT.Common;

  {$I ADAPT_RTTI.inc}

type
  IADCardinalComparer = IADComparer<Cardinal>;
  IADIntegerComparer = IADComparer<Integer>;
  IADFloatComparer = IADComparer<ADFloat>;
  IADStringComparer = IADComparer<String>;
  IADObjectComparer = IADComparer<TADObject>;
  IADInterfaceComparer = IADComparer<IADInterface>;

  ///  <summary><c>Abstract Base Class for Generic Comparers.</c></summary>
  TADComparer<T> = class abstract(TADObject, IADComparer<T>)
  public
    function AEqualToB(const A, B: T): Boolean; virtual; abstract;
    function AGreaterThanB(const A, B: T): Boolean; virtual; abstract;
    function AGreaterThanOrEqualToB(const A, B: T): Boolean; virtual; abstract;
    function ALessThanB(const A, B: T): Boolean; virtual; abstract;
    function ALessThanOrEqualToB(const A, B: T): Boolean; virtual; abstract;
  end;

  ///  <summary><c>Generic Comparer for any Class implementing the IADInterface Type.</c></summary>
  ///  <remarks>
  ///    <para><c>Uses the InstanceGUID for comparison.</c></para>
  ///  </remarks>
  TADInterfaceComparer<T: IADInterface> = class(TADComparer<T>)
  public
    function AEqualToB(const A, B: T): Boolean; override;
    function AGreaterThanB(const A, B: T): Boolean; override;
    function AGreaterThanOrEqualToB(const A, B: T): Boolean; override;
    function ALessThanB(const A, B: T): Boolean; override;
    function ALessThanOrEqualToB(const A, B: T): Boolean; override;
  end;

function ADCardinalComparer: IADCardinalComparer;
function ADIntegerComparer: IADIntegerComparer;
function ADFloatComparer: IADFloatComparer;
function ADStringComparer: IADStringComparer;
function ADObjectComparer: IADObjectComparer;
function ADInterfaceComparer: IADInterfaceComparer;

implementation

var
  GCardinalComparer: IADCardinalComparer;
  GIntegerComparer: IADIntegerComparer;
  GFloatComparer: IADFloatComparer;
  GStringComparer: IADStringComparer;
  GObjectComparer: IADObjectComparer;
  GADInterfaceComparer: IADInterfaceComparer;

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

  TADObjectComparer = class(TADComparer<TADObject>)
  public
    function AEqualToB(const A, B: TADObject): Boolean; override;
    function AGreaterThanB(const A, B: TADObject): Boolean; override;
    function AGreaterThanOrEqualToB(const A, B: TADObject): Boolean; override;
    function ALessThanB(const A, B: TADObject): Boolean; override;
    function ALessThanOrEqualToB(const A, B: TADObject): Boolean; override;
  end;

  TADInterfaceComparer = class(TADComparer<IADInterface>)
  public
    function AEqualToB(const A, B: IADInterface): Boolean; override;
    function AGreaterThanB(const A, B: IADInterface): Boolean; override;
    function AGreaterThanOrEqualToB(const A, B: IADInterface): Boolean; override;
    function ALessThanB(const A, B: IADInterface): Boolean; override;
    function ALessThanOrEqualToB(const A, B: IADInterface): Boolean; override;
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

function ADObjectComparer: IADObjectComparer;
begin
  Result := GObjectComparer;
end;

function ADInterfaceComparer: IADInterfaceComparer;
begin
  Result := GADInterfaceComparer;
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

{ TADObjectComparer }

function TADObjectComparer.AEqualToB(const A, B: TADObject): Boolean;
begin
  Result := (A.InstanceGUID = B.InstanceGUID);
end;

function TADObjectComparer.AGreaterThanB(const A, B: TADObject): Boolean;
begin
  {$IFDEF FPC}
    Result := (A.InstanceGUID > B.InstanceGUID);
  {$ELSE}
    Result := GUIDToString(A.InstanceGUID) > GUIDToString(B.InstanceGUID);
  {$ENDIF FPC}
end;

function TADObjectComparer.AGreaterThanOrEqualToB(const A, B: TADObject): Boolean;
begin
  {$IFDEF FPC}
    Result := (A.InstanceGUID >= B.InstanceGUID);
  {$ELSE}
    Result := GUIDToString(A.InstanceGUID) >= GUIDToString(B.InstanceGUID);
  {$ENDIF FPC}
end;

function TADObjectComparer.ALessThanB(const A, B: TADObject): Boolean;
begin
  {$IFDEF FPC}
    Result := (A.InstanceGUID < B.InstanceGUID);
  {$ELSE}
    Result := GUIDToString(A.InstanceGUID) < GUIDToString(B.InstanceGUID);
  {$ENDIF FPC}
end;

function TADObjectComparer.ALessThanOrEqualToB(const A, B: TADObject): Boolean;
begin
  {$IFDEF FPC}
    Result := (A.InstanceGUID <= B.InstanceGUID);
  {$ELSE}
    Result := GUIDToString(A.InstanceGUID) <= GUIDToString(B.InstanceGUID);
  {$ENDIF FPC}
end;

{ TADInterfaceComparer }

function TADInterfaceComparer.AEqualToB(const A, B: IADInterface): Boolean;
begin
  Result := (A.InstanceGUID = B.InstanceGUID);
end;

function TADInterfaceComparer.AGreaterThanB(const A, B: IADInterface): Boolean;
begin
  {$IFDEF FPC}
    Result := (A.InstanceGUID > B.InstanceGUID);
  {$ELSE}
    Result := GUIDToString(A.InstanceGUID) > GUIDToString(B.InstanceGUID);
  {$ENDIF FPC}
end;

function TADInterfaceComparer.AGreaterThanOrEqualToB(const A, B: IADInterface): Boolean;
begin
  {$IFDEF FPC}
    Result := (A.InstanceGUID >= B.InstanceGUID);
  {$ELSE}
    Result := GUIDToString(A.InstanceGUID) >= GUIDToString(B.InstanceGUID);
  {$ENDIF FPC}
end;

function TADInterfaceComparer.ALessThanB(const A, B: IADInterface): Boolean;
begin
  {$IFDEF FPC}
    Result := (A.InstanceGUID < B.InstanceGUID);
  {$ELSE}
    Result := GUIDToString(A.InstanceGUID) < GUIDToString(B.InstanceGUID);
  {$ENDIF FPC}
end;

function TADInterfaceComparer.ALessThanOrEqualToB(const A, B: IADInterface): Boolean;
begin
  {$IFDEF FPC}
    Result := (A.InstanceGUID <= B.InstanceGUID);
  {$ELSE}
    Result := GUIDToString(A.InstanceGUID) <= GUIDToString(B.InstanceGUID);
  {$ENDIF FPC}
end;

{ TADInterfaceComparer<T> }

function TADInterfaceComparer<T>.AEqualToB(const A, B: T): Boolean;
begin
  Result := (A.InstanceGUID = B.InstanceGUID);
end;

function TADInterfaceComparer<T>.AGreaterThanB(const A, B: T): Boolean;
begin
  {$IFDEF FPC}
    Result := (A.InstanceGUID > B.InstanceGUID);
  {$ELSE}
    Result := GUIDToString(A.InstanceGUID) > GUIDToString(B.InstanceGUID);
  {$ENDIF FPC}
end;

function TADInterfaceComparer<T>.AGreaterThanOrEqualToB(const A, B: T): Boolean;
begin
  {$IFDEF FPC}
    Result := (A.InstanceGUID >= B.InstanceGUID);
  {$ELSE}
    Result := GUIDToString(A.InstanceGUID) >= GUIDToString(B.InstanceGUID);
  {$ENDIF FPC}
end;

function TADInterfaceComparer<T>.ALessThanB(const A, B: T): Boolean;
begin
  {$IFDEF FPC}
    Result := (A.InstanceGUID < B.InstanceGUID);
  {$ELSE}
    Result := GUIDToString(A.InstanceGUID) < GUIDToString(B.InstanceGUID);
  {$ENDIF FPC}
end;

function TADInterfaceComparer<T>.ALessThanOrEqualToB(const A, B: T): Boolean;
begin
  {$IFDEF FPC}
    Result := (A.InstanceGUID <= B.InstanceGUID);
  {$ELSE}
    Result := GUIDToString(A.InstanceGUID) <= GUIDToString(B.InstanceGUID);
  {$ENDIF FPC}
end;

initialization
  GCardinalComparer := TADCardinalComparer.Create;
  GIntegerComparer := TADIntegerComparer.Create;
  GFloatComparer := TADFloatComparer.Create;
  GStringComparer := TADStringComparer.Create;
  GObjectComparer := TADObjectComparer.Create;
  GADInterfaceComparer := TADInterfaceComparer.Create;
end.
