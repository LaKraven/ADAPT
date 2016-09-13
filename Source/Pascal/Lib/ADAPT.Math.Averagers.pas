{
  AD.A.P.T. Library
  Copyright (C) 2014-2016, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Math.Averagers;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes,
  {$ELSE}
    Classes,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Common, ADAPT.Common.Intf,
  ADAPT.Collections.Intf,
  ADAPT.Math.Common.Intf,
  ADAPT.Math.Averagers.Intf;

  {$I ADAPT_RTTI.inc}

type
  TADAverager<T> = class abstract(TADObject, IADAverager<T>)
  protected
    procedure CheckSorted(const ASeries: IADCollectionList<T>); overload;
    procedure CheckSorted(const ASortedState: TADSortedState); overload;
  public
    function CalculateAverage(const ASeries: IADCollectionList<T>): T; overload; virtual; abstract;
    function CalculateAverage(const ASeries: Array of T; const ASortedState: TADSortedState): T; overload; virtual; abstract;
  end;

  TADAveragerFloat = class abstract(TADAverager<ADFloat>);
  TADAveragerInteger = class abstract(TADAverager<Integer>);
  TADAveragerInt64 = class abstract(TADAverager<Int64>);
  TADAveragerCardinal = class abstract(TADAverager<Cardinal>);

// Float Averagers
///  <returns><c>An Arithmetic Mean Averager for Float Values.</c></returns>
function ADAveragerFloatMean: IADAverager<ADFloat>;
///  <returns><c>A Median Averager for Float Values.</c></returns>
function ADAveragerFloatMedian: IADAverager<ADFloat>;
///  <returns><c>A Range Averager for Float Values.</c></returns>
function ADAveragerFloatRange: IADAverager<ADFloat>;
// Integer Averagers
///  <returns><c>An Arithmetic Mean Averager for Integer Values.</c></returns>
function ADAveragerIntegerMean: IADAverager<Integer>;
///  <returns><c>A Median Averager for Integer Values.</c></returns>
function ADAveragerIntegerMedian: IADAverager<Integer>;
///  <returns><c>A Range Averager for Integer Values.</c></returns>
function ADAveragerIntegerRange: IADAverager<Integer>;
// Int64 Averagers
///  <returns><c>An Arithmetic Mean Averager for Int64 Values.</c></returns>
function ADAveragerInt64Mean: IADAverager<Int64>;
///  <returns><c>A Median Averager for Int64 Values.</c></returns>
function ADAveragerInt64Median: IADAverager<Int64>;
///  <returns><c>A Range Averager for Int64 Values.</c></returns>
function ADAveragerInt64Range: IADAverager<Int64>;
// Cardinal Averagers
///  <returns><c>An Arithmetic Mean Averager for Cardinal Values.</c></returns>
function ADAveragerCardinalMean: IADAverager<Cardinal>;
///  <returns><c>A Median Averager for Cardinal Values.</c></returns>
function ADAveragerCardinalMedian: IADAverager<Cardinal>;
///  <returns><c>A Range Averager for Cardinal Values.</c></returns>
function ADAveragerCardinalRange: IADAverager<Cardinal>;

implementation

type
  { Float Averagers }
  TADAveragerFloatMean = class(TADAveragerFloat)
    function CalculateAverage(const ASeries: IADCollectionList<ADFloat>): ADFloat; overload; override;
    function CalculateAverage(const ASeries: Array of ADFloat; const ASortedState: TADSortedState): ADFloat; overload; override;
  end;

  TADAveragerFloatMedian = class(TADAveragerFloat)
    function CalculateAverage(const ASeries: IADCollectionList<ADFloat>): ADFloat; overload; override;
    function CalculateAverage(const ASeries: Array of ADFloat; const ASortedState: TADSortedState): ADFloat; overload; override;
  end;

  TADAveragerFloatRange = class(TADAveragerFloat)
    function CalculateAverage(const ASeries: IADCollectionList<ADFloat>): ADFloat; overload; override;
    function CalculateAverage(const ASeries: Array of ADFloat; const ASortedState: TADSortedState): ADFloat; overload; override;
  end;

  { Integer Averagers}
  TADAveragerIntegerMean = class(TADAveragerInteger)
    function CalculateAverage(const ASeries: IADCollectionList<Integer>): Integer; overload; override;
    function CalculateAverage(const ASeries: Array of Integer; const ASortedState: TADSortedState): Integer; overload; override;
  end;

  TADAveragerIntegerMedian = class(TADAveragerInteger)
    function CalculateAverage(const ASeries: IADCollectionList<Integer>): Integer; overload; override;
    function CalculateAverage(const ASeries: Array of Integer; const ASortedState: TADSortedState): Integer; overload; override;
  end;

  TADAveragerIntegerRange = class(TADAveragerInteger)
    function CalculateAverage(const ASeries: IADCollectionList<Integer>): Integer; overload; override;
    function CalculateAverage(const ASeries: Array of Integer; const ASortedState: TADSortedState): Integer; overload; override;
  end;

  { Int64 Averagers }
  TADAveragerInt64Mean = class(TADAveragerInt64)
    function CalculateAverage(const ASeries: IADCollectionList<Int64>): Int64; overload; override;
    function CalculateAverage(const ASeries: Array of Int64; const ASortedState: TADSortedState): Int64; overload; override;
  end;

  TADAveragerInt64Median = class(TADAveragerInt64)
    function CalculateAverage(const ASeries: IADCollectionList<Int64>): Int64; overload; override;
    function CalculateAverage(const ASeries: Array of Int64; const ASortedState: TADSortedState): Int64; overload; override;
  end;

  TADAveragerInt64Range = class(TADAveragerInt64)
    function CalculateAverage(const ASeries: IADCollectionList<Int64>): Int64; overload; override;
    function CalculateAverage(const ASeries: Array of Int64; const ASortedState: TADSortedState): Int64; overload; override;
  end;

  { Cardinal Averagers }
  TADAveragerCardinalMean = class(TADAveragerCardinal)
    function CalculateAverage(const ASeries: IADCollectionList<Cardinal>): Cardinal; overload; override;
    function CalculateAverage(const ASeries: Array of Cardinal; const ASortedState: TADSortedState): Cardinal; overload; override;
  end;

  TADAveragerCardinalMedian = class(TADAveragerCardinal)
    function CalculateAverage(const ASeries: IADCollectionList<Cardinal>): Cardinal; overload; override;
    function CalculateAverage(const ASeries: Array of Cardinal; const ASortedState: TADSortedState): Cardinal; overload; override;
  end;

  TADAveragerCardinalRange = class(TADAveragerCardinal)
    function CalculateAverage(const ASeries: IADCollectionList<Cardinal>): Cardinal; overload; override;
    function CalculateAverage(const ASeries: Array of Cardinal; const ASortedState: TADSortedState): Cardinal; overload; override;
  end;

var
  // Float Averagers
  GAveragerFloatMean: IADAverager<ADFloat>;
  GAveragerFloatMedian: IADAverager<ADFloat>;
  GAveragerFloatRange: IADAverager<ADFloat>;
  // Integer Averagers
  GAveragerIntegerMean: IADAverager<Integer>;
  GAveragerIntegerMedian: IADAverager<Integer>;
  GAveragerIntegerRange: IADAverager<Integer>;
  // Int64 Averagers
  GAveragerInt64Mean: IADAverager<Int64>;
  GAveragerInt64Median: IADAverager<Int64>;
  GAveragerInt64Range: IADAverager<Int64>;
  // Cardinal Averagers
  GAveragerCardinalMean: IADAverager<Cardinal>;
  GAveragerCardinalMedian: IADAverager<Cardinal>;
  GAveragerCardinalRange: IADAverager<Cardinal>;

{ Float Averagers }

function ADAveragerFloatMean: IADAverager<ADFloat>;
begin
  Result := GAveragerFloatMean;
end;

function ADAveragerFloatMedian: IADAverager<ADFloat>;
begin
  Result := GAveragerFloatMedian;
end;

function ADAveragerFloatRange: IADAverager<ADFloat>;
begin
  Result := GAveragerFloatRange;
end;

{ Integer Averagers }

function ADAveragerIntegerMean: IADAverager<Integer>;
begin
  Result := GAveragerIntegerMean
end;

function ADAveragerIntegerMedian: IADAverager<Integer>;
begin
  Result := GAveragerIntegerMedian;
end;

function ADAveragerIntegerRange: IADAverager<Integer>;
begin
  Result := GAveragerIntegerRange;
end;

{ Int64 Averagers }

function ADAveragerInt64Mean: IADAverager<Int64>;
begin
  Result := GAveragerInt64Mean
end;

function ADAveragerInt64Median: IADAverager<Int64>;
begin
  Result := GAveragerInt64Median;
end;

function ADAveragerInt64Range: IADAverager<Int64>;
begin
  Result := GAveragerInt64Range;
end;

{ Cardinal Averagers }

function ADAveragerCardinalMean: IADAverager<Cardinal>;
begin
  Result := GAveragerCardinalMean
end;

function ADAveragerCardinalMedian: IADAverager<Cardinal>;
begin
  Result := GAveragerCardinalMedian;
end;

function ADAveragerCardinalRange: IADAverager<Cardinal>;
begin
  Result := GAveragerCardinalRange;
end;

{ TADAverager<T> }

procedure TADAverager<T>.CheckSorted(const ASeries: IADCollectionList<T>);
begin
  CheckSorted(ASeries.SortedState);
end;

procedure TADAverager<T>.CheckSorted(const ASortedState: TADSortedState);
begin
  if ASortedState <> ssSorted then
    raise EADMathAveragerListNotSorted.Create('Series MUST be Sorted.');
end;

{ TADAveragerFloatMean }

function TADAveragerFloatMean.CalculateAverage(const ASeries: IADCollectionList<ADFloat>): ADFloat;
var
  I: Integer;
begin
  Result := ADFLOAT_ZERO;
  for I := 0 to ASeries.Count - 1 do
    Result := Result + ASeries[I];

  Result := Result / ASeries.Count;
end;

function TADAveragerFloatMean.CalculateAverage(const ASeries: array of ADFloat; const ASortedState: TADSortedState): ADFloat;
var
  I: Integer;
begin
  Result := ADFLOAT_ZERO;
  for I := Low(ASeries) to High(ASeries) do
    Result := Result + ASeries[I];

  Result := Result / Length(ASeries);
end;

{ TADAveragerFloatMedian }

function TADAveragerFloatMedian.CalculateAverage(const ASeries: IADCollectionList<ADFloat>): ADFloat;
begin
  CheckSorted(ASeries);
  Result := ASeries[(ASeries.Count div 2) - 1];
end;

function TADAveragerFloatMedian.CalculateAverage(const ASeries: array of ADFloat; const ASortedState: TADSortedState): ADFloat;
begin
  CheckSorted(ASortedState);
  Result := ASeries[(Length(ASeries) div 2) - 1];
end;

{ TADAveragerFloatRange }

function TADAveragerFloatRange.CalculateAverage(const ASeries: IADCollectionList<ADFloat>): ADFloat;
begin
  CheckSorted(ASeries);
  Result := ASeries[ASeries.Count - 1] - ASeries[0];
end;

function TADAveragerFloatRange.CalculateAverage(const ASeries: array of ADFloat; const ASortedState: TADSortedState): ADFloat;
begin
  CheckSorted(ASortedState);
  Result := ASeries[High(ASeries)] - ASeries[0];
end;

{ TADAveragerIntegerMean }

function TADAveragerIntegerMean.CalculateAverage(const ASeries: IADCollectionList<Integer>): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to ASeries.Count - 1 do
    Result := Result + ASeries[I];

  Result := Result div ASeries.Count;
end;

function TADAveragerIntegerMean.CalculateAverage(const ASeries: array of Integer; const ASortedState: TADSortedState): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := Low(ASeries) to High(ASeries) do
    Result := Result + ASeries[I];

  Result := Result div Length(ASeries);
end;

{ TADAveragerIntegerMedian }

function TADAveragerIntegerMedian.CalculateAverage(const ASeries: IADCollectionList<Integer>): Integer;
begin
  CheckSorted(ASeries);
  Result := ASeries[(ASeries.Count div 2) - 1];
end;

function TADAveragerIntegerMedian.CalculateAverage(const ASeries: array of Integer; const ASortedState: TADSortedState): Integer;
begin
  CheckSorted(ASortedState);
  Result := ASeries[(Length(ASeries) div 2) - 1];
end;

{ TADAveragerIntegerRange }

function TADAveragerIntegerRange.CalculateAverage(const ASeries: IADCollectionList<Integer>): Integer;
begin
  CheckSorted(ASeries);
  Result := ASeries[ASeries.Count - 1] - ASeries[0];
end;

function TADAveragerIntegerRange.CalculateAverage(const ASeries: array of Integer; const ASortedState: TADSortedState): Integer;
begin
  CheckSorted(ASortedState);
  Result := ASeries[High(ASeries)] - ASeries[0];
end;

{ TADAveragerInt64Mean }

function TADAveragerInt64Mean.CalculateAverage(const ASeries: IADCollectionList<Int64>): Int64;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to ASeries.Count - 1 do
    Result := Result + ASeries[I];

  Result := Result div ASeries.Count;
end;

function TADAveragerInt64Mean.CalculateAverage(const ASeries: array of Int64; const ASortedState: TADSortedState): Int64;
var
  I: Integer;
begin
  Result := 0;
  for I := Low(ASeries) to High(ASeries) do
    Result := Result + ASeries[I];

  Result := Result div Length(ASeries);
end;

{ TADAveragerInt64Median }

function TADAveragerInt64Median.CalculateAverage(const ASeries: IADCollectionList<Int64>): Int64;
begin
  CheckSorted(ASeries);
  Result := ASeries[(ASeries.Count div 2) - 1];
end;

function TADAveragerInt64Median.CalculateAverage(const ASeries: array of Int64; const ASortedState: TADSortedState): Int64;
begin
  CheckSorted(ASortedState);
  Result := ASeries[(Length(ASeries) div 2) - 1];
end;

{ TADAveragerInt64Range }

function TADAveragerInt64Range.CalculateAverage(const ASeries: IADCollectionList<Int64>): Int64;
begin
  CheckSorted(ASeries);
  Result := ASeries[ASeries.Count - 1] - ASeries[0];
end;

function TADAveragerInt64Range.CalculateAverage(const ASeries: array of Int64; const ASortedState: TADSortedState): Int64;
begin
  CheckSorted(ASortedState);
  Result := ASeries[High(ASeries)] - ASeries[0];
end;

{ TADAveragerCardinalMean }

function TADAveragerCardinalMean.CalculateAverage(const ASeries: IADCollectionList<Cardinal>): Cardinal;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to ASeries.Count - 1 do
    Result := Result + ASeries[I];

  Result := Result div Cardinal(ASeries.Count);
end;

function TADAveragerCardinalMean.CalculateAverage(const ASeries: array of Cardinal; const ASortedState: TADSortedState): Cardinal;
var
  I: Integer;
begin
  Result := 0;
  for I := Low(ASeries) to High(ASeries) do
    Result := Result + ASeries[I];

  Result := Result div Cardinal(Length(ASeries));
end;

{ TADAveragerCardinalMedian }

function TADAveragerCardinalMedian.CalculateAverage(const ASeries: IADCollectionList<Cardinal>): Cardinal;
begin
  CheckSorted(ASeries);
  Result := ASeries[(ASeries.Count div 2) - 1];
end;

function TADAveragerCardinalMedian.CalculateAverage(const ASeries: array of Cardinal; const ASortedState: TADSortedState): Cardinal;
begin
  CheckSorted(ASortedState);
  Result := ASeries[(Length(ASeries) div 2) - 1];
end;

{ TADAveragerCardinalRange }

function TADAveragerCardinalRange.CalculateAverage(const ASeries: IADCollectionList<Cardinal>): Cardinal;
begin
  CheckSorted(ASeries);
  Result := ASeries[ASeries.Count - 1] - ASeries[0];
end;

function TADAveragerCardinalRange.CalculateAverage(const ASeries: array of Cardinal; const ASortedState: TADSortedState): Cardinal;
begin
  CheckSorted(ASortedState);
  Result := ASeries[High(ASeries)] - ASeries[0];
end;

initialization
  // Float Averagers
  GAveragerFloatMean := TADAveragerFloatMean.Create;
  GAveragerFloatMedian := TADAveragerFloatMedian.Create;
  GAveragerFloatRange := TADAveragerFloatRange.Create;
  // Integer Averagers
  GAveragerIntegerMean := TADAveragerIntegerMean.Create;
  GAveragerIntegerMedian := TADAveragerIntegerMedian.Create;
  GAveragerIntegerRange := TADAveragerIntegerRange.Create;
  // Int64 Averagers
  GAveragerInt64Mean := TADAveragerInt64Mean.Create;
  GAveragerInt64Median := TADAveragerInt64Median.Create;
  GAveragerInt64Range := TADAveragerInt64Range.Create;
  // Cardinal Averagers
  GAveragerCardinalMean := TADAveragerCardinalMean.Create;
  GAveragerCardinalMedian := TADAveragerCardinalMedian.Create;
  GAveragerCardinalRange := TADAveragerCardinalRange.Create;

end.
