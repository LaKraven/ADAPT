{
  AD.A.P.T. Library
  Copyright (C) 2014-2018, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Math.Delta;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes, System.Diagnostics,
  {$ELSE}
    Classes, {$IFDEF FPC}ADAPT.Stopwatch{$ELSE}Diagnostics{$ENDIF FPC},
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT, ADAPT.Intf,
  ADAPT.Collections.Intf,
  ADAPT.Comparers.Intf,
  ADAPT.Math.Common.Intf,
  ADAPT.Math.Delta.Intf;

  {$I ADAPT_RTTI.inc}

type
  TADDeltaValue<T> = class(TADObject, IADDeltaValue<T>)
  private
    FComparer: IADOrdinalComparer<T>;
    FValues: IADMap<ADFloat, T>;
  protected
    // Getters
    { IADDeltaValue<T> }
    function GetValueAt(const ADelta: ADFloat): T; virtual;
    function GetValueNow: T;

    // Setters
    { IADDeltaValue<T> }
    procedure SetValueAt(const ADelta: ADFloat; const AValue: T); virtual;
    procedure SetValueNow(const AValue: T);

    // Overridables
    function CalculateValueAt(const ADelta: ADFloat): T; virtual;
  public
    constructor Create(const AOrdinalComparer: IADOrdinalComparer<T>); reintroduce; overload;
    constructor Create(const AOrdinalComparer: IADOrdinalComparer<T>; const AValueNow: T); reintroduce; overload;
    constructor Create(const AOrdinalComparer: IADOrdinalComparer<T>; const ADelta: ADFloat; const AValue: T); reintroduce; overload;
    // Properties
    { IADDeltaValue<T> }
    property ValueAt[const ADelta: ADFloat]: T read GetValueAt write SetValueAt;
    property ValueNow: T read GetValueNow write SetValueNow;
  end;

///  <returns><c>The Current "Reference Time" used everywhere "Differential Time" (Delta) is calculated.</c></returns>
function ADReferenceTime: ADFloat;
///  <returns><c>A fresh Instance of a Delta Float.</c></returns>
function ADDeltaFloat: IADDeltaValue<ADFloat>;
///  <returns><c>A fresh Instance of a Delta Integer.</c></returns>
function ADDeltaInteger: IADDeltaValue<Integer>;
///  <returns><c>A fresh Instance of a Delta Int64.</c></returns>
function ADDeltaInt64: IADDeltaValue<Int64>;
///  <returns><c>A fresh Instance of a Delta Cardinal.</c></returns>
function ADDeltaCardinal: IADDeltaValue<Cardinal>;

implementation

uses
  ADAPT.Comparers,
  ADAPT.Collections;

var
  ReferenceWatch: TStopwatch;

type
  TADDeltaFloat = class(TADDeltaValue<ADFloat>);
  TADDeltaInteger = class(TADDeltaValue<Integer>);
  TADDeltaInt64 = class(TADDeltaValue<Int64>);
  TADDeltaCardinal = class(TADDeltaValue<Cardinal>);

function ADReferenceTime: ADFloat;
begin
  Result := TStopwatch.GetTimeStamp / TStopwatch.Frequency;
end;

function ADDeltaFloat: IADDeltaValue<ADFloat>;
begin
  Result := TADDeltaFloat.Create;
end;

function ADDeltaInteger: IADDeltaValue<Integer>;
begin
  Result := TADDeltaInteger.Create;
end;

function ADDeltaInt64: IADDeltaValue<Int64>;
begin
  Result := TADDeltaInt64.Create;
end;

function ADDeltaCardinal: IADDeltaValue<Cardinal>;
begin
  Result := TADDeltaCardinal.Create;
end;

{ TADDeltaValue<T> }

constructor TADDeltaValue<T>.Create(const AOrdinalComparer: IADOrdinalComparer<T>);
begin
  inherited Create;
  FComparer := AOrdinalComparer;
  FValues := TADMap<ADFloat, T>.Create(ADFloatComparer);
end;

constructor TADDeltaValue<T>.Create(const AOrdinalComparer: IADOrdinalComparer<T>; const AValueNow: T);
begin
  Create(AOrdinalComparer);
  SetValueNow(AValueNow);
end;

constructor TADDeltaValue<T>.Create(const AOrdinalComparer: IADOrdinalComparer<T>; const ADelta: ADFloat; const AValue: T);
begin
  Create(AOrdinalComparer);
  SetValueAt(ADelta, AValue);
end;

function TADDeltaValue<T>.CalculateValueAt(const ADelta: ADFloat): T;
var
  LDeltaDiff, LDeltaFactor: ADFloat;
  LValueDiff: T;
begin
  Result := Default(T);
  if (FValues.Count < 2) then
    Exit; //TODO -oSJS -cDelta Value: Raise a rational exception here since we cannot calculate a result with less than two fixed Data Points.
  if (ADelta > FValues.Pairs[FValues.Count - 1].Key) then
  begin
    // Extrapolate (value is in the future)
    // Simple two-point Linear Extrapolation
    LDeltaDiff := (FValues.Pairs[FValues.Count - 1].Key - FValues.Pairs[FValues.Count - 2].Key);
    LValueDiff := FComparer.Subtract(FValues.Pairs[FValues.Count - 1].Value, FValues.Pairs[FValues.Count - 2].Value);
    LDeltaFactor := ADelta / LDeltaDiff;
  end
  else
  begin
    // Interpolate (value is either in the past, or between the range
    if (ADelta < FValues.Pairs[0].Key) then
    begin
      // Value is in the past.
    end
    else
    begin
      // Value is between the range.
    end;
  end;
end;

function TADDeltaValue<T>.GetValueAt(const ADelta: ADFloat): T;
begin
  if FValues.Contains(ADelta) then  // If we already have an exact value for the given Delta...
  begin
    Result := FValues.Items[ADelta]; // ... simply return it.
    Exit;
  end;

  Result := CalculateValueAt(ADelta);
end;

function TADDeltaValue<T>.GetValueNow: T;
begin
  Result := GetValueAt(ADReferenceTime);
end;

procedure TADDeltaValue<T>.SetValueAt(const ADelta: ADFloat; const AValue: T);
begin
  if FValues.Contains(ADelta) then
    FValues.Items[ADelta] := AValue
  else
    FValues.Add(ADelta, AValue);
end;

procedure TADDeltaValue<T>.SetValueNow(const AValue: T);
begin
  SetValueAt(ADReferenceTime, AValue);
end;

initialization
  ReferenceWatch := TStopwatch.Create;

end.
