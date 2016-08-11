{
  AD.A.P.T. Library
  Copyright (C) 2014-2016, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Generics.Sorters.Intf;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes,
  {$ELSE}
    Classes,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Common.Intf,
  ADAPT.Generics.Common.Intf,
  ADAPT.Generics.Arrays.Intf,
  ADAPT.Generics.Comparers.Intf;

  {$I ADAPT_RTTI.inc}

type
  ///  <summary><c>Sorting Algorithm for Lists.</c></summary>
  IADListSorter<T> = interface(IADInterface)
    procedure Sort(const AArray: IADArray<T>; const AComparer: IADComparer<T>; AFrom, ATo: Integer); overload;
    procedure Sort(AArray: Array of T; const AComparer: IADComparer<T>; AFrom, ATo: Integer); overload;
  end;

  ///  <summary><c>An Object requiring a List Sorter.</c></summary>
  IADListSortable<T> = interface(IADInterface)
  ['{30FA0C51-81B8-4EF8-918E-A3563651010C}']
    // Getters
    function GetSorter: IADListSorter<T>;
    // Setters
    procedure SetSorter(const ASorter: IADListSorter<T>);
    // Properties
    property Sorter: IADListSorter<T> read GetSorter write SetSorter;
  end;

  ///  <summary><c>Sorting Algorithm for Maps.</c></summary>
  IADMapSorter<TKey, TValue> = interface(IADInterface)
    procedure Sort(const AArray: IADArray<IADKeyValuePair<TKey,TValue>>; const AComparer: IADComparer<TKey>; AFrom, ATo: Integer); overload;
    procedure Sort(AArray: Array of IADKeyValuePair<TKey,TValue>; const AComparer: IADComparer<TKey>; AFrom, ATo: Integer); overload;
  end;

  ///  <summary><c>An Object requiring a Map Sorter.</c></summary>
  IADMapSortable<TKey, TValue> = interface(IADInterface)
  ['{274DE930-1796-4313-A599-A331740BAA29}']
    // Getters
    function GetSorter: IADMapSorter<TKey, TValue>;
    // Setters
    procedure SetSorter(const ASorter: IADMapSorter<TKey, TValue>);
    // Properties
    property Sorter: IADMapSorter<TKey, TValue> read GetSorter write SetSorter;
  end;

implementation

end.
