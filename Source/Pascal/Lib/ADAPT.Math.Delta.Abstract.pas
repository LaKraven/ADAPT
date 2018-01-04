{
  AD.A.P.T. Library
  Copyright (C) 2014-2018, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Math.Delta.Abstract;

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
    // Getters
    { IADDeltaValue<T> }
    function GetReader: IADDeltaValueReader<T>;
  protected
    FExtrapolator: IADDeltaExtrapolator<T>;
    FInterpolator: IADDeltaInterpolator<T>;
    FValues: IADMap<ADFloat, T>;
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

  ///  <summary><c>Common Abstract Base Class for all Delta Extrapolator and Interpolator Classes.</c></summary>
  TADDeltaPolatorBase<T> = class abstract(TADObject, IADDeltaPolator<T>)
  protected
    FMinimumKnownValues: Integer;
    // Getters
    function GetMinimumKnownValues: Integer; virtual;

    // Setters
    procedure SetMinimumKnownValues(const AMinimumKnownValues: Integer); virtual;
  public
    constructor Create; reintroduce; overload;
    constructor Create(const AMinimumKnownValues: Integer); reintroduce; overload; virtual;

    // Properties
    property MinimumKnownValues: Integer read GetMinimumKnownValues write SetMinimumKnownValues;
  end;

  ///  <summary><c>Abstract Base Class for all Delta Extrapolators.</c></summary>
  TADDeltaExtrapolatorBase<T> = class abstract(TADDeltaPolatorBase<T>, IADDeltaExtrapolator<T>)
  protected

  public
    { IADDeltaExtrapolator<T> }
    function Extrapolate(const AMap: IADMapReader<ADFloat, T>; const ADelta: ADFloat): T; virtual; abstract;
  end;

  ///  <summary><c>Abstract Base Class for all Delta Interpolators.</c></summary>
  TADDeltaInterpolatorBase<T> = class abstract(TADDeltaPolatorBase<T>, IADDeltaInterpolator<T>)
  public
    { IADDeltaInterpolator<T> }
    function Interpolate(const AMap: IADMapReader<ADFloat, T>; const ANearestNeighbour: Integer; const ADelta: ADFloat): T; virtual; abstract;
  end;

implementation

uses
  ADAPT.Comparers,
  ADAPT.Collections,
  ADAPT.Math.Delta; // This reference is only required because we need to call ADReferenceTime, and that function is defined in there.

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

{ TADDeltaPolatorBase<T> }

constructor TADDeltaPolatorBase<T>.Create;
begin
  Create(2);
end;

constructor TADDeltaPolatorBase<T>.Create(const AMinimumKnownValues: Integer);
begin
  inherited Create;
  FMinimumKnownValues := AMinimumKnownValues;
end;

function TADDeltaPolatorBase<T>.GetMinimumKnownValues: Integer;
begin
  Result := FMinimumKnownValues;
end;

procedure TADDeltaPolatorBase<T>.SetMinimumKnownValues(const AMinimumKnownValues: Integer);
begin
  FMinimumKnownValues := AMinimumKnownValues;
end;

end.
