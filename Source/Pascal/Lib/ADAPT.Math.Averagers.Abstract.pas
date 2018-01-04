{
  AD.A.P.T. Library
  Copyright (C) 2014-2018, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Math.Averagers.Abstract;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes,
  {$ELSE}
    Classes,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT, ADAPT.Intf,
  ADAPT.Collections.Intf,
  ADAPT.Math.Common.Intf,
  ADAPT.Math.Averagers.Intf;

  {$I ADAPT_RTTI.inc}

type
  TADAverager<T> = class abstract(TADObject, IADAverager<T>)
  protected
    procedure CheckSorted(const ASeries: IADListReader<T>); overload;
    procedure CheckSorted(const ASortedState: TADSortedState); overload;
  public
    function CalculateAverage(const ASeries: IADListReader<T>): T; overload; virtual; abstract;
    function CalculateAverage(const ASeries: Array of T; const ASortedState: TADSortedState): T; overload; virtual; abstract;
  end;

implementation


{ TADAverager<T> }

procedure TADAverager<T>.CheckSorted(const ASeries: IADListReader<T>);
begin
  CheckSorted(ASeries.SortedState);
end;

procedure TADAverager<T>.CheckSorted(const ASortedState: TADSortedState);
begin
  if ASortedState <> ssSorted then
    raise EADMathAveragerListNotSorted.Create('Series MUST be Sorted.');
end;

end.
