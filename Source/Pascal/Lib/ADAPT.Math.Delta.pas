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
  TADDeltaFloat = class(TADObject, IADDeltaValue<ADFloat>)
  private
    FValues: IADMap<ADFloat, ADFloat>;
  protected
    // Getters
    { IADDeltaValue<T> }
    function GetValueAt(const ADelta: ADFloat): ADFloat; virtual;
    function GetValueNow: ADFloat;

    // Setters
    { IADDeltaValue<T> }
    procedure SetValueAt(const ADelta: ADFloat; const AValue: ADFloat); virtual;
    procedure SetValueNow(const AValue: ADFloat);

    // Overridables
    function CalculateValueAt(const ADelta: ADFloat): ADFloat; virtual;
  public
    constructor Create; overload; override;
    constructor Create(const AValueNow: ADFloat); reintroduce; overload;
    constructor Create(const ADelta: ADFloat; const AValue: ADFloat); reintroduce; overload;
    // Properties
    { IADDeltaValue<ADFloat> }
    property ValueAt[const ADelta: ADFloat]: ADFloat read GetValueAt write SetValueAt;
    property ValueNow: ADFloat read GetValueNow write SetValueNow;
  end;

///  <returns><c>The Current "Reference Time" used everywhere "Differential Time" (Delta) is calculated.</c></returns>
function ADReferenceTime: ADFloat;
///  <returns><c>A fresh Instance of a Delta Float.</c></returns>
function ADDeltaFloat: IADDeltaValue<ADFloat>;

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

function ADDeltaFloat: IADDeltaValue<ADFloat>;
begin
  Result := TADDeltaFloat.Create;
end;

{ TADDeltaFloat }

constructor TADDeltaFloat.Create;
begin
  inherited Create;
  FValues := TADMap<ADFloat, ADFloat>.Create(ADFloatComparer);
end;

constructor TADDeltaFloat.Create(const AValueNow: ADFloat);
begin
  Create;
  SetValueNow(AValueNow);
end;

constructor TADDeltaFloat.Create(const ADelta: ADFloat; const AValue: ADFloat);
begin
  Create;
  SetValueAt(ADelta, AValue);
end;

function TADDeltaFloat.CalculateValueAt(const ADelta: ADFloat): ADFloat;
var
  LDeltaDiff: ADFloat;
  LValueDiff: ADFloat;
begin
  Result := 0.00;

  if (FValues.Count < 2) then // Determine first whether or not we have enough Values to Interpolate/Extrapolate. 2 is the minimum.
    Exit; //TODO -oSJS -cDelta Value: Raise a rational exception here since we cannot calculate a result with less than two fixed Data Points.

  if (ADelta > FValues.Pairs[FValues.Count - 1].Key) then
  begin
    // Extrapolate (value is in the future)
    // Simple two-point Linear Extrapolation
    LDeltaDiff := (FValues.Pairs[FValues.Count - 1].Key - FValues.Pairs[FValues.Count - 2].Key);
    LValueDiff := FValues.Pairs[FValues.Count - 1].Value - FValues.Pairs[FValues.Count - 2].Value;
    LDeltaDiff := ADelta - FValues.Pairs[FValues.Count - 1].Key;
    Result := FValues.Pairs[FValues.Count - 1].Value + (LValueDiff * LDeltaDiff);
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
