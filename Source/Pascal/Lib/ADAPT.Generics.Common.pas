{
  AD.A.P.T. Library
  Copyright (C) 2014-2016, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Generics.Common;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes,
  {$ELSE}
    Classes,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Common, ADAPT.Common.Intf,
  ADAPT.Generics.Common.Intf;

  {$I ADAPT_RTTI.inc}

type
  // Exceptions
  EADGenericsException = class(EADException);
      EADGenericsIterateException = class(EADGenericsException);
      EADGenericsIterateDirectionUnknownException = class(EADGenericsIterateException);
    EADGenericsRangeException = class(EADGenericsException);
    EADGenericsParameterInvalidException = class(EADGenericsException);
      EADGenericsCapacityLessThanCount = class(EADGenericsParameterInvalidException);
      EADGenericsCompactorNilException = class(EADGenericsParameterInvalidException);
      EADGenericsExpanderNilException = class(EADGenericsParameterInvalidException);

  TADKeyValuePair<TKey, TValue> = class(TADObject, IADKeyValuePair<TKey, TValue>)
  protected
    FKey: TKey;
    FValue: TValue;
    // Getters
    function GetKey: TKey;
    function GetValue: TValue;
  public
    constructor Create(const AKey: TKey; const AValue: TValue); reintroduce;
    // Properties
    property Key: TKey read GetKey;
    property Value: TValue read GetValue;
  end;

implementation

{ TADKeyValuePair<TKey, TValue> }

constructor TADKeyValuePair<TKey, TValue>.Create(const AKey: TKey; const AValue: TValue);
begin
  inherited Create;
  FKey := AKey;
  FValue := AValue;
end;

function TADKeyValuePair<TKey, TValue>.GetKey: TKey;
begin
  Result := FKey;
end;

function TADKeyValuePair<TKey, TValue>.GetValue: TValue;
begin
  Result := FValue;
end;

end.
