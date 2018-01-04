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
  ADAPT.Math.Delta.Intf, ADAPT.Math.Delta.Abstract;

  {$I ADAPT_RTTI.inc}

type
  ///  <summary><c>A Delta Float provides the means to Interpolate and Extrapolate Estimated Values based on multiple Absolute Values.</c></summary>
  TADDeltaFloat = class(TADDeltaValueBase<ADFloat>)
  protected
    // Overridables
    function CalculateValueAt(const ADelta: ADFloat): ADFloat; override;
  public
    constructor Create(const AHistoryToKeep: Integer = 5); reintroduce; overload;
    constructor Create(const AExtrapolator: IADDeltaExtrapolator<ADFloat>; const AHistoryToKeep: Integer = 5); reintroduce; overload;
    constructor Create(const AInterpolator: IADDeltaInterpolator<ADFloat>; const AHistoryToKeep: Integer = 5); reintroduce; overload;
  end;

///  <returns><c>The Current "Reference Time" used everywhere "Differential Time" (Delta) is calculated.</c></returns>
function ADReferenceTime: ADFloat;
///  <returns><c>A fresh Instance of a Delta Float.</c></returns>
function ADDeltaFloat(const AHistoryToKeep: Integer = 5): IADDeltaValue<ADFloat>;
///  <returns><c>A fresh instance of a Delta Float Linear Extrapolator.</c></returns>
function ADDeltaFloatLinearExtrapolator(const AMinimumKnownValues: Integer = 2): IADDeltaExtrapolator<ADFloat>;
///  <returns><c>A fresh instance of a Delta Float Linear Interpolator.</c></returns>
function ADDeltaFloatLinearInterpolator(const AMinimumKnownValues: Integer = 2): IADDeltaInterpolator<ADFloat>;

implementation

uses
  ADAPT.Comparers,
  ADAPT.Collections;

type
  TADDeltaFloatLinearExtrapolator = class(TADDeltaExtrapolatorBase<ADFloat>)
    function Extrapolate(const AMap: IADMapReader<ADFloat, ADFloat>; const ADelta: ADFloat): ADFloat; override;
  end;

  TADDeltaFloatLinearInterpolator = class(TADDeltaInterpolatorBase<ADFloat>)
  public
    function Interpolate(const AMap: IADMapReader<ADFloat, ADFloat>; const ANearestNeighbour: Integer; const ADelta: ADFloat): ADFloat; override;
  end;

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

function ADDeltaFloatLinearExtrapolator(const AMinimumKnownValues: Integer = 2): IADDeltaExtrapolator<ADFloat>;
begin
  Result := TADDeltaFloatLinearExtrapolator.Create(AMinimumKnownValues);
end;

function ADDeltaFloatLinearInterpolator(const AMinimumKnownValues: Integer = 2): IADDeltaInterpolator<ADFloat>;
begin
  Result := TADDeltaFloatLinearInterpolator.Create(AMinimumKnownValues);
end;

{ TADDeltaFloat }

constructor TADDeltaFloat.Create(const AHistoryToKeep: Integer);
begin
  Create(ADDeltaFloatLinearExtrapolator, ADDeltaFloatLinearInterpolator, AHistoryToKeep);
end;

constructor TADDeltaFloat.Create(const AExtrapolator: IADDeltaExtrapolator<ADFloat>; const AHistoryToKeep: Integer);
begin
  Create(AExtrapolator, ADDeltaFloatLinearInterpolator, AHistoryToKeep);
end;

constructor TADDeltaFloat.Create(const AInterpolator: IADDeltaInterpolator<ADFloat>; const AHistoryToKeep: Integer);
begin
  Create(ADDeltaFloatLinearExtrapolator, AInterpolator, AHistoryToKeep);
end;

function TADDeltaFloat.CalculateValueAt(const ADelta: ADFloat): ADFloat;
begin
  Result := ADFLOAT_ZERO;

  if (FValues.Count < 2) then // Determine first whether or not we have enough Values to Interpolate/Extrapolate. 2 is the minimum.
    Exit; //TODO -oSJS -cDelta Value: Raise a rational exception here since we cannot calculate a result with less than two fixed Data Points.

  if (ADelta > FValues.Pairs[FValues.Count - 1].Key) or (ADelta < FValues.Pairs[0].Key) then
    Result := FExtrapolator.Extrapolate(FValues, ADelta)
  else
    Result := FInterpolator.Interpolate(FValues, GetNearestNeighbour(ADelta) - 1, ADelta);
end;

{ TADDeltaFloatLinearExtrapolator }

function TADDeltaFloatLinearExtrapolator.Extrapolate(const AMap: IADMapReader<ADFloat, ADFloat>; const ADelta: ADFloat): ADFloat;
var
  LFirstValue, LSecondValue, LNearestDelta: ADFloat;
  LDeltaDiff: ADFloat;
  LValueDiff: ADFloat;
begin
  LFirstValue := ADFLOAT_ZERO;
  LSecondValue := ADFLOAT_ZERO;
  LDeltaDiff := ADFLOAT_ZERO;

  if (ADelta > AMap.Pairs[AMap.Count - 1].Key) then
  begin
    LFirstValue := AMap.Pairs[AMap.Count - 1].Value;
    LSecondValue := AMap.Pairs[AMap.Count - 2].Value;
    LNearestDelta := AMap.Pairs[AMap.Count - 1].Key;
    LDeltaDiff := ADelta - LNearestDelta;
  end
  else if (ADelta < AMap.Pairs[0].Key) then
  begin
    LFirstValue := AMap.Pairs[0].Value;
    LSecondValue := AMap.Pairs[1].Value;
    LNearestDelta := AMap.Pairs[0].Key;
    LDeltaDiff := LNearestDelta - ADelta;
  end;

  LValueDiff := LFirstValue - LSecondValue;
  Result := LFirstValue + (LValueDiff * LDeltaDiff);
end;

{ TADDeltaFloatLinearInterpolator }

function TADDeltaFloatLinearInterpolator.Interpolate(const AMap: IADMapReader<ADFloat, ADFloat>; const ANearestNeighbour: Integer; const ADelta: ADFloat): ADFloat;
var
  LFirstValue, LSecondValue, LNearestDelta: ADFloat;
  LDeltaDiff: ADFloat;
  LValueDiff: ADFloat;
begin
  // Interpolate (Value is between the range.)
  LNearestDelta := AMap.Pairs[ANearestNeighbour].Key;
  LFirstValue := AMap.Pairs[ANearestNeighbour].Value;
  LSecondValue := AMap.Pairs[ANearestNeighbour + 1].Value;
  // Calculate Value Difference between them
  LDeltaDiff := ADelta - LNearestDelta;
  LValueDiff := LSecondValue - LFirstValue;
  Result := LFirstValue + (LValueDiff * lDeltaDiff);
end;

initialization
  ReferenceWatch := TStopwatch.Create;

end.
