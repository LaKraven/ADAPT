{
  AD.A.P.T. Library
  Copyright (C) 2014-2016, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Generics.Sorters;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes,
  {$ELSE}
    Classes,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Common, ADAPT.Common.Intf,
  ADAPT.Generics.Common.Intf,
  ADAPT.Generics.Collections.Intf;

  {$I ADAPT_RTTI.inc}

type
  { List Sorters }
  ///  <summary><c>Abstract Base Class for all List Sorters.</c></summary>
  TADListSorter<T> = class abstract(TADObject, IADListSorter<T>)
  public
    procedure Sort(const AArray: IADArray<T>; const AComparer: IADComparer<T>; AFrom, ATo: Integer); overload; virtual; abstract;
    procedure Sort(AArray: Array of T; const AComparer: IADComparer<T>; AFrom, ATo: Integer); overload; virtual; abstract;
  end;

  ///  <summary><c>Sorter for Lists using the Quick Sort implementation.</c></summary>
  TADListSorterQuick<T> = class(TADListSorter<T>)
  public
    procedure Sort(const AArray: IADArray<T>; const AComparer: IADComparer<T>; AFrom, ATo: Integer); overload; override;
    procedure Sort(AArray: Array of T; const AComparer: IADComparer<T>; AFrom, ATo: Integer); overload; override;
  end;

  { Map Sorters }
  ///  <summary><c>Abstract Base Class for all Map Sorters.</c></summary>
  TADMapSorter<TKey, TValue> = class abstract(TADObject, IADMapSorter<TKey, TValue>)
  public
    procedure Sort(const AArray: IADArray<IADKeyValuePair<TKey,TValue>>; const AComparer: IADComparer<TKey>; AFrom, ATo: Integer); overload; virtual; abstract;
    procedure Sort(AArray: Array of IADKeyValuePair<TKey,TValue>; const AComparer: IADComparer<TKey>; AFrom, ATo: Integer); overload; virtual; abstract;
  end;

  ///  <summary><c>Sorter for Maps using the Quick SOrt implementation.</c></summary>
  TADMapSorterQuick<TKey, TValue> = class(TADMapSorter<TKey, TValue>)
  public
    procedure Sort(const AArray: IADArray<IADKeyValuePair<TKey,TValue>>; const AComparer: IADComparer<TKey>; AFrom, ATo: Integer); overload; override;
    procedure Sort(AArray: Array of IADKeyValuePair<TKey,TValue>; const AComparer: IADComparer<TKey>; AFrom, ATo: Integer); overload; override;
  end;

implementation

{ TADListSorterQuick<T> }

procedure TADListSorterQuick<T>.Sort(const AArray: IADArray<T>; const AComparer: IADComparer<T>; AFrom, ATo: Integer);
var
  I, J: Integer;
  LPivot, LTemp: T;
begin
  repeat
    I := AFrom;
    J := ATo;
    LPivot := AArray[AFrom + (ATo - AFrom) shr 1];
    repeat

      while AComparer.ALessThanB(AArray[I], LPivot) do
        Inc(I);
      while AComparer.AGreaterThanB(AArray[J], LPivot) do
        Dec(J);

      if I <= J then
      begin
        if I <> J then
        begin
          LTemp := AArray[I];
          AArray[I] := AArray[J];
          AArray[J] := LTemp;
        end;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if AFrom < J then
      Sort(AArray, AComparer, AFrom, J);
    AFrom := I;
  until I >= ATo;
end;

procedure TADListSorterQuick<T>.Sort(AArray: array of T; const AComparer: IADComparer<T>; AFrom, ATo: Integer);
var
  I, J: Integer;
  LPivot, LTemp: T;
begin
  repeat
    I := AFrom;
    J := ATo;
    LPivot := AArray[AFrom + (ATo - AFrom) shr 1];
    repeat

      while AComparer.ALessThanB(AArray[I], LPivot) do
        Inc(I);
      while AComparer.AGreaterThanB(AArray[J], LPivot) do
        Dec(J);

      if I <= J then
      begin
        if I <> J then
        begin
          LTemp := AArray[I];
          AArray[I] := AArray[J];
          AArray[J] := LTemp;
        end;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if AFrom < J then
      Sort(AArray, AComparer, AFrom, J);
    AFrom := I;
  until I >= ATo;
end;

{ TMapSorterQuick<TKey, TValue> }

procedure TADMapSorterQuick<TKey, TValue>.Sort(const AArray: IADArray<IADKeyValuePair<TKey, TValue>>; const AComparer: IADComparer<TKey>; AFrom, ATo: Integer);
var
  I, J: Integer;
  LPivot: TKey;
  LTemp: IADKeyValuePair<TKey, TValue>;
begin
  repeat
    I := AFrom;
    J := ATo;
    LPivot := AArray[AFrom + (ATo - AFrom) shr 1].Key;
    repeat

      while AComparer.ALessThanB(AArray[I].Key, LPivot) do
        Inc(I);
      while AComparer.AGreaterThanB(AArray[J].Key, LPivot) do
        Dec(J);

      if I <= J then
      begin
        if I <> J then
        begin
          LTemp := AArray[I];
          AArray[I] := AArray[J];
          AArray[J] := LTemp;
        end;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if AFrom < J then
      Sort(AArray, AComparer, AFrom, J);
    AFrom := I;
  until I >= ATo;
end;

procedure TADMapSorterQuick<TKey, TValue>.Sort(AArray: array of IADKeyValuePair<TKey, TValue>; const AComparer: IADComparer<TKey>; AFrom, ATo: Integer);
var
  I, J: Integer;
  LPivot: TKey;
  LTemp: IADKeyValuePair<TKey, TValue>;
begin
  repeat
    I := AFrom;
    J := ATo;
    LPivot := AArray[AFrom + (ATo - AFrom) shr 1].Key;
    repeat

      while AComparer.ALessThanB(AArray[I].Key, LPivot) do
        Inc(I);
      while AComparer.AGreaterThanB(AArray[J].Key, LPivot) do
        Dec(J);

      if I <= J then
      begin
        if I <> J then
        begin
          LTemp := AArray[I];
          AArray[I] := AArray[J];
          AArray[J] := LTemp;
        end;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if AFrom < J then
      Sort(AArray, AComparer, AFrom, J);
    AFrom := I;
  until I >= ATo;
end;

end.
