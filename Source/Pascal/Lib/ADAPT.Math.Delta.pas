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
  ///  <summary><c>A Delta Float provides the means to Interpolate and Extrapolate Estimated Values based on multiple Absolute Values</c></summary>
  TADDeltaFloat = class(TADObject, IADDeltaValueReader<ADFloat>, IADDeltaValue<ADFloat>)
  private
    FValues: IADMap<ADFloat, ADFloat>;
    // Getters
    { IADDeltaValue<T> }
    function GetReader: IADDeltaValueReader<ADFloat>;

    function Extrapolate(const ADelta: ADFloat): ADFloat;
    function Interpolate(const ADelta: ADFloat): ADFloat;
    function GetNearestNeighbour(const ADelta: ADFloat): Integer;
  protected
    // Getters
    { IADDeltaValueReader<T> }
    function GetValueAt(const ADelta: ADFloat): ADFloat; virtual;
    function GetValueNow: ADFloat;

    // Setters
    { IADDeltaValue<T> }
    procedure SetValueAt(const ADelta: ADFloat; const AValue: ADFloat); virtual;
    procedure SetValueNow(const AValue: ADFloat);

    // Overridables
    function CalculateValueAt(const ADelta: ADFloat): ADFloat; virtual;
  public
    constructor Create(const AHistoryToKeep: Integer = 5); reintroduce; overload;
    constructor Create(const AValueNow: ADFloat; const AHistoryToKeep: Integer = 5); reintroduce; overload;
    constructor Create(const ADelta: ADFloat; const AValue: ADFloat; const AHistoryToKeep: Integer = 5); reintroduce; overload;
    // Properties
    { IADDeltaValue<ADFloat> }
    property ValueAt[const ADelta: ADFloat]: ADFloat read GetValueAt write SetValueAt; default;
    property ValueNow: ADFloat read GetValueNow write SetValueNow;
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

{ TADDeltaFloat }

constructor TADDeltaFloat.Create(const AHistoryToKeep: Integer = 5);
begin
  inherited Create;
  if AHistoryToKeep < 2 then // If the number to keep is defined as less than 2, we'll keep EVERYTHING
    FValues := TADMap<ADFloat, ADFloat>.Create(ADFloatComparer)
  else
    FValues := TADCircularMap<ADFloat, ADFloat>.Create(ADFloatComparer, AHistoryToKeep);
end;

constructor TADDeltaFloat.Create(const AValueNow: ADFloat; const AHistoryToKeep: Integer = 5);
begin
  Create(AHistoryToKeep);
  SetValueNow(AValueNow);
end;

constructor TADDeltaFloat.Create(const ADelta: ADFloat; const AValue: ADFloat; const AHistoryToKeep: Integer = 5);
begin
  Create(AHistoryToKeep);
  SetValueAt(ADelta, AValue);
end;

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
  LNearestNeighbour := GetNearestNeighbour(ADelta) - 2;
  LNearestDelta := FValues.Pairs[LNearestNeighbour].Key;
  LFirstValue := FValues.Pairs[LNearestNeighbour].Value;
  LSecondValue := FValues.Pairs[LNearestNeighbour + 1].Value;
  // Calculate Value Difference between them
  LDeltaDiff := ADelta - LNearestDelta;
  LValueDiff := LSecondValue - LFirstValue;
  Result := LFirstValue + (LValueDiff * lDeltaDiff);
end;

function TADDeltaFloat.GetNearestNeighbour(const ADelta: ADFloat): Integer;
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
      if LComparer.ALessThanOrEqualToB(ADelta, FValues[LIndex]) then
        LHigh := LIndex
      else
        LLow := LIndex;
    end;
  end;
  if LComparer.ALessThanB(FValues[LHigh], ADelta) then
    Result := LHigh + 1
  else if LComparer.ALessThanB(FValues[LLow], ADelta) then
    Result := LLow + 1
  else
    Result := LLow;
end;

function TADDeltaFloat.GetReader: IADDeltaValueReader<ADFloat>;
begin
  Result := IADDeltaValueReader<ADFloat>(Self);
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

function TADDeltaFloat.GetValueAt(const ADelta: ADFloat): ADFloat;
begin
  if FValues.Contains(ADelta) then  // If we already have an exact value for the given Delta...
  begin
    Result := FValues.Items[ADelta]; // ... simply return it.
    Exit;
  end;

  Result := CalculateValueAt(ADelta);
end;

function TADDeltaFloat.GetValueNow: ADFloat;
begin
  Result := GetValueAt(ADReferenceTime);
end;

procedure TADDeltaFloat.SetValueAt(const ADelta: ADFloat; const AValue: ADFloat);
begin
  if FValues.Contains(ADelta) then
    FValues.Items[ADelta] := AValue
  else
    FValues.Add(ADelta, AValue);
end;

procedure TADDeltaFloat.SetValueNow(const AValue: ADFloat);
begin
  SetValueAt(ADReferenceTime, AValue);
end;

initialization
  ReferenceWatch := TStopwatch.Create;

end.
