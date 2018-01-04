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
  ///  <summary><c>Generic Base class for Delta Value Types, providing the means to Interpolate and Extrapolate Estimated values based on multiple Absolute Values.</c></summary>
  TADDeltaValueBase<T> = class abstract(TADObject, IADDeltaValueReader<T>, IADDeltaValue<T>)
  private
    FExtrapolator: IADDeltaExtrapolator<T>;
    FInterpolator: IADDeltaInterpolator<T>;
    FValues: IADMap<ADFloat, T>;
    // Getters
    { IADDeltaValue<T> }
    function GetReader: IADDeltaValueReader<T>;
  protected
    // Getters
    { IADDeltaValueReader<T> }
    function GetExtrapolator: IADDeltaExtrapolator<T>;
    function GetInterpolator: IADDeltaInterpolator<T>;
    function GetValueAt(const ADelta: ADFloat): T; virtual;
    function GetValueNow: T;

    // Setters
    { IADDeltaValue<T> }
    procedure SetExtrapolator(const AExtrapolator: IADDeltaExtrapolator<T>);
    procedure SetInterpolator(const AInterpolator: IADDeltaInterpolator<T>);
    procedure SetValueAt(const ADelta: ADFloat; const AValue: T); virtual;
    procedure SetValueNow(const AValue: T);

    // Management Methods
    function GetNearestNeighbour(const ADelta: ADFloat): Integer;

    // Overridables
    function CalculateValueAt(const ADelta: ADFloat): T; virtual; abstract;
  public
    constructor Create(const AExtrapolator: IADDeltaExtrapolator<T>; const AInterpolator: IADDeltaInterpolator<T>; const AHistoryToKeep: Integer = 5); reintroduce; overload;
    // Properties
    { IADDeltaValue<ADFloat> }
    property ValueAt[const ADelta: ADFloat]: T read GetValueAt write SetValueAt; default;
    property ValueNow: T read GetValueNow write SetValueNow;
  end;

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

  ///  <summary><c>Abstract Base Class for all Delta Extrapolators.</c></summary>
  TADDeltaExtrapolatorBase<T> = class abstract(TADObject, IADDeltaExtrapolator<T>)
  private
    FMinimumKnownValues: Integer;
  protected
    // Getters
    function GetMinimumKnownValues: Integer; virtual;

    // Setters
    procedure SetMinimumKnownValues(const AMinimumKnownValues: Integer); virtual;
  public
    constructor Create; reintroduce; overload;
    constructor Create(const AMinimumKnownValues: Integer); reintroduce; overload;

    { IADDeltaExtrapolator<T> }
    function Extrapolate(const AMap: IADMapReader<ADFloat, T>; const ADelta: ADFloat): T; virtual; abstract;

    // Properties
    property MinimumKnownValues: Integer read GetMinimumKnownValues write SetMinimumKnownValues;
  end;

  ///  <summary><c>Abstract Base Class for all Delta Interpolators.</c></summary>
  TADDeltaInterpolatorBase<T> = class abstract(TADObject, IADDeltaInterpolator<T>)
  private
    FMinimumKnownValues: Integer;
  protected
    // Getters
    function GetMinimumKnownValues: Integer; virtual;

    // Setters
    procedure SetMinimumKnownValues(const AMinimumKnownValues: Integer); virtual;
  public
    constructor Create; reintroduce; overload;
    constructor Create(const AMinimumKnownValues: Integer); reintroduce; overload;

    { IADDeltaInterpolator<T> }
    function Interpolate(const AMap: IADMapReader<ADFloat, T>; const ANearestNeighbour: Integer; const ADelta: ADFloat): T; virtual; abstract;

    // Properties
    property MinimumKnownValues: Integer read GetMinimumKnownValues write SetMinimumKnownValues;
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

{ TADDeltaValueBase<T> }

constructor TADDeltaValueBase<T>.Create(const AExtrapolator: IADDeltaExtrapolator<T>; const AInterpolator: IADDeltaInterpolator<T>; const AHistoryToKeep: Integer);
begin
  inherited Create;
  if AHistoryToKeep < 2 then // If the number to keep is defined as less than 2, we'll keep EVERYTHING
    FValues := TADMap<ADFloat, T>.Create(ADFloatComparer)
  else
    FValues := TADCircularMap<ADFloat, T>.Create(ADFloatComparer, AHistoryToKeep);

  FExtrapolator := AExtrapolator;
  FInterpolator := AInterpolator;
end;

function TADDeltaValueBase<T>.GetExtrapolator: IADDeltaExtrapolator<T>;
begin
  Result := FExtrapolator;
end;

function TADDeltaValueBase<T>.GetInterpolator: IADDeltaInterpolator<T>;
begin
  Result := FInterpolator;
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

procedure TADDeltaValueBase<T>.SetExtrapolator(const AExtrapolator: IADDeltaExtrapolator<T>);
begin
  FExtrapolator := AExtrapolator;
end;

procedure TADDeltaValueBase<T>.SetInterpolator(const AInterpolator: IADDeltaInterpolator<T>);
begin
  FInterpolator := AInterpolator;
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

{ TADDeltaExtrapolatorBase<T> }

constructor TADDeltaExtrapolatorBase<T>.Create;
begin
  Create(2);
end;

constructor TADDeltaExtrapolatorBase<T>.Create(const AMinimumKnownValues: Integer);
begin
  inherited Create;
  FMinimumKnownValues := AMinimumKnownValues;
end;

function TADDeltaExtrapolatorBase<T>.GetMinimumKnownValues: Integer;
begin
  Result := FMinimumKnownValues;
end;

procedure TADDeltaExtrapolatorBase<T>.SetMinimumKnownValues(const AMinimumKnownValues: Integer);
begin
  FMinimumKnownValues := AMinimumKnownValues;
end;

{ TADDeltaInterpolatorBase<T> }

constructor TADDeltaInterpolatorBase<T>.Create;
begin
  Create(2);
end;

constructor TADDeltaInterpolatorBase<T>.Create(const AMinimumKnownValues: Integer);
begin
  inherited Create;
  FMinimumKnownValues := AMinimumKnownValues;
end;

function TADDeltaInterpolatorBase<T>.GetMinimumKnownValues: Integer;
begin
  Result := FMinimumKnownValues;
end;

procedure TADDeltaInterpolatorBase<T>.SetMinimumKnownValues(const AMinimumKnownValues: Integer);
begin
  FMinimumKnownValues := AMinimumKnownValues;
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
