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
  TADDeltaValueBase<T> = class(TADObject, IADDeltaValueReader<T>, IADDeltaValue<T>)
  private
    FValues: IADMap<ADFloat, T>;
    // Getters
    { IADDeltaValue<T> }
    function GetReader: IADDeltaValueReader<T>;
  protected
    // Getters
    { IADDeltaValueReader<T> }
    function GetValueAt(const ADelta: ADFloat): T; virtual;
    function GetValueNow: T;

    // Setters
    { IADDeltaValue<T> }
    procedure SetValueAt(const ADelta: ADFloat; const AValue: T); virtual;
    procedure SetValueNow(const AValue: T);

    // Management Methods
    function GetNearestNeighbour(const ADelta: ADFloat): Integer;

    // Overridables
    function CalculateValueAt(const ADelta: ADFloat): T; virtual; abstract;
  public
    constructor Create(const AHistoryToKeep: Integer = 5); reintroduce; overload; virtual;
    constructor Create(const AValueNow: T; const AHistoryToKeep: Integer = 5); reintroduce; overload;
    constructor Create(const ADelta: ADFloat; const AValue: T; const AHistoryToKeep: Integer = 5); reintroduce; overload;
    // Properties
    { IADDeltaValue<ADFloat> }
    property ValueAt[const ADelta: ADFloat]: T read GetValueAt write SetValueAt; default;
    property ValueNow: T read GetValueNow write SetValueNow;
  end;

  ///  <summary><c>A Delta Float provides the means to Interpolate and Extrapolate Estimated Values based on multiple Absolute Values</c></summary>
  TADDeltaFloat = class(TADDeltaValueBase<ADFloat>)
  private
    function Extrapolate(const ADelta: ADFloat): ADFloat;
    function Interpolate(const ADelta: ADFloat): ADFloat;
  protected
    // Overridables
    function CalculateValueAt(const ADelta: ADFloat): ADFloat; override;
  end;

///  <returns><c>The Current "Reference Time" used everywhere "Differential Time" (Delta) is calculated.</c></returns>
function ADReferenceTime: ADFloat;
///  <returns><c>A fresh Instance of a Delta Float.</c></returns>
function ADDeltaFloat(const AHistoryToKeep: Integer = 5): IADDeltaValue<ADFloat>; overload;
///  <returns><c>A fresh Instance of a Delta Float with a Value defined for right now.</c></returns>
function ADDeltaFloat(const AValueNow: ADFloat; const AHistoryToKeep: Integer = 5): IADDeltaValue<ADFloat>; overload;
///  <returns><c>A fresh instance of a Delta float with a Value defined for the given Delta Time.</c></returns>
function ADDeltaFloat(const ADelta: ADFloat; const AValue: ADFloat; const AHistoryToKeep: Integer = 5): IADDeltaValue<ADFloat>; overload;

implementation

uses
  ADAPT.Comparers,
  ADAPT.Collections;

var
  ReferenceWatch: TStopwatch;

function ADReferenceTime: ADFloat;
begin
  Result := TStopwatch.GetTimeStamp / TStopwatch.Frequency;
end;

function ADDeltaFloat(const AHistoryToKeep: Integer = 5): IADDeltaValue<ADFloat>;
begin
  Result := TADDeltaFloat.Create(AHistoryToKeep);
end;

function ADDeltaFloat(const AValueNow: ADFloat; const AHistoryToKeep: Integer = 5): IADDeltaValue<ADFloat>;
begin
  Result := TADDeltaFloat.Create(AValueNow, AHistoryToKeep);
end;

function ADDeltaFloat(const ADelta: ADFloat; const AValue: ADFloat; const AHistoryToKeep: Integer = 5): IADDeltaValue<ADFloat>;
begin
  Result := TADDeltaFloat.Create(ADelta, AValue, AHistoryToKeep);
end;

{ TADDeltaValueBase<T> }

constructor TADDeltaValueBase<T>.Create(const AHistoryToKeep: Integer);
begin
  inherited Create;
  if AHistoryToKeep < 2 then // If the number to keep is defined as less than 2, we'll keep EVERYTHING
    FValues := TADMap<ADFloat, T>.Create(ADFloatComparer)
  else
    FValues := TADCircularMap<ADFloat, T>.Create(ADFloatComparer, AHistoryToKeep);
end;

constructor TADDeltaValueBase<T>.Create(const AValueNow: T; const AHistoryToKeep: Integer);
begin
  Create(AHistoryToKeep);
  SetValueNow(AValueNow);
end;

constructor TADDeltaValueBase<T>.Create(const ADelta: ADFloat; const AValue: T; const AHistoryToKeep: Integer);
begin
  Create(AHistoryToKeep);
  SetValueAt(ADelta, AValue);
end;

function TADDeltaValueBase<T>.GetNearestNeighbour(const ADelta: ADFloat): Integer;
var
  LIndex, LLow, LHigh: Integer;
  LComparer: IADComparer<ADFloat>;
begin
  LComparer := (FValues as IADComparable<ADFloat>).Comparer;
  Result := 0;
  LLow := 0;
  LHigh := FValues.Count - 1;
  if LHigh = -1 then
    Exit;
  if LLow < LHigh then
  begin
    while (LHigh - LLow > 1) do
    begin
      LIndex := (LHigh + LLow) div 2;
      if LComparer.ALessThanOrEqualToB(ADelta, FValues.Pairs[LIndex].Key) then
        LHigh := LIndex
      else
        LLow := LIndex;
    end;
  end;
  if LComparer.ALessThanB(FValues.Pairs[LHigh].Key, ADelta) then
    Result := LHigh + 1
  else if LComparer.ALessThanB(FValues.Pairs[LLow].Key, ADelta) then
    Result := LLow + 1
  else
    Result := LLow;
end;

function TADDeltaValueBase<T>.GetReader: IADDeltaValueReader<T>;
begin
  Result := IADDeltaValueReader<T>(Self);
end;

function TADDeltaValueBase<T>.GetValueAt(const ADelta: ADFloat): T;
begin
  if FValues.Contains(ADelta) then  // If we already have an exact value for the given Delta...
  begin
    Result := FValues.Items[ADelta]; // ... simply return it.
    Exit;
  end;

  Result := CalculateValueAt(ADelta);
end;

function TADDeltaValueBase<T>.GetValueNow: T;
begin
  Result := GetValueAt(ADReferenceTime);
end;

procedure TADDeltaValueBase<T>.SetValueAt(const ADelta: ADFloat; const AValue: T);
begin
  if FValues.Contains(ADelta) then
    FValues.Items[ADelta] := AValue
  else
    FValues.Add(ADelta, AValue);
end;

procedure TADDeltaValueBase<T>.SetValueNow(const AValue: T);
begin
  SetValueAt(ADReferenceTime, AValue);
end;

{ TADDeltaFloat }

function TADDeltaFloat.Extrapolate(const ADelta: ADFloat): ADFloat;
var
  LFirstValue, LSecondValue, LNearestDelta: ADFloat;
  LDeltaDiff: ADFloat;
  LValueDiff: ADFloat;
begin
  LFirstValue := ADFLOAT_ZERO;
  LSecondValue := ADFLOAT_ZERO;
  LDeltaDiff := ADFLOAT_ZERO;

  if (ADelta > FValues.Pairs[FValues.Count - 1].Key) then
  begin
    LFirstValue := FValues.Pairs[FValues.Count - 1].Value;
    LSecondValue := FValues.Pairs[FValues.Count - 2].Value;
    LNearestDelta := FValues.Pairs[FValues.Count - 1].Key;
    LDeltaDiff := ADelta - LNearestDelta;
  end
  else if (ADelta < FValues.Pairs[0].Key) then
  begin
    LFirstValue := FValues.Pairs[0].Value;
    LSecondValue := FValues.Pairs[1].Value;
    LNearestDelta := FValues.Pairs[0].Key;
    LDeltaDiff := LNearestDelta - ADelta;
  end;

  LValueDiff := LFirstValue - LSecondValue;
  Result := LFirstValue + (LValueDiff * LDeltaDiff);
end;

function TADDeltaFloat.Interpolate(const ADelta: ADFloat): ADFloat;
var
  LNearestNeighbour: Integer;
  LFirstValue, LSecondValue, LNearestDelta: ADFloat;
  LDeltaDiff: ADFloat;
  LValueDiff: ADFloat;
begin
  // Interpolate (Value is between the range.)
  LNearestNeighbour := GetNearestNeighbour(ADelta) - 1;
  LNearestDelta := FValues.Pairs[LNearestNeighbour].Key;
  LFirstValue := FValues.Pairs[LNearestNeighbour].Value;
  LSecondValue := FValues.Pairs[LNearestNeighbour + 1].Value;
  // Calculate Value Difference between them
  LDeltaDiff := ADelta - LNearestDelta;
  LValueDiff := LSecondValue - LFirstValue;
  Result := LFirstValue + (LValueDiff * lDeltaDiff);
end;

function TADDeltaFloat.CalculateValueAt(const ADelta: ADFloat): ADFloat;
begin
  Result := ADFLOAT_ZERO;

  if (FValues.Count < 2) then // Determine first whether or not we have enough Values to Interpolate/Extrapolate. 2 is the minimum.
    Exit; //TODO -oSJS -cDelta Value: Raise a rational exception here since we cannot calculate a result with less than two fixed Data Points.

  if (ADelta > FValues.Pairs[FValues.Count - 1].Key) or (ADelta < FValues.Pairs[0].Key) then
    Result := Extrapolate(ADelta)
  else
    Result := Interpolate(ADelta);
end;

initialization
  ReferenceWatch := TStopwatch.Create;

end.
