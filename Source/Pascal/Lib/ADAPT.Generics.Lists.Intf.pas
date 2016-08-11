{
  AD.A.P.T. Library
  Copyright (C) 2014-2016, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Generics.Lists.Intf;

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
  ADAPT.Generics.Allocators.Intf,
  ADAPT.Generics.Comparers.Intf;

  {$I ADAPT_RTTI.inc}

type
  ///  <summary><c>Generic List Type</c></summary>
  IADList<T> = interface(IADCollection)
    // Getters
    ///  <returns><c>The Item at the given Index.</c></returns>
    function GetItem(const AIndex: Integer): T;

    // Setters
    procedure SetItem(const AIndex: Integer; const AItem: T);

    // Management Methods
    ///  <summary><c>Adds the given Item into the List.</c></summary>
    procedure Add(const AItem: T); overload;
    ///  <summary><c>Adds Items from the given List into this List.</c></summary>
    procedure Add(const AList: IADList<T>); overload;
    ///  <summary><c>Adds multiple Items into the List.</c></summary>
    procedure AddItems(const AItems: Array of T);
    ///  <summary><c>Compacts the size of the underlying Array to the minimum required Capacity.</c></summary>
    ///  <remarks>
    ///    <para><c>Note that any subsequent addition to the List will need to expand the Capacity and could lead to reallocation.</c></para>
    ///  </remarks>
    procedure Compact;
    ///  <summary><c>Deletes the Item at the given Index.</c></summary>
    procedure Delete(const AIndex: Integer);
    ///  <summary><c>Deletes the Items from the Start Index to Start Index + Count.</c></summary>
    procedure DeleteRange(const AFirst, ACount: Integer);
    ///  <summary><c>Insert the given Item at the specified Index.</c></summary>
    procedure Insert(const AItem: T; const AIndex: Integer);
    ///  <summary><c>Insert the given Items starting at the specified Index.</c></summary>
    procedure InsertItems(const AItems: Array of T; const AIndex: Integer);
    ///  <summary><c>Sort the List.</c></summary>
    procedure Sort(const AComparer: IADComparer<T>);

    // Properties
    property Items[const AIndex: Integer]: T read GetItem write SetItem; default;
  end;

  ///  <summary><c>A Generic Fixed-Capacity Revolving List</c></summary>
  ///  <remarks>
  ///    <para><c>When the current Index is equal to the Capacity, the Index resets to 0, and items are subsequently Replaced by new ones.</c></para>
  ///  </remarks>
  IADCircularList<T> = interface(IADCollection)
    // Getters
    function GetItem(const AIndex: Integer): T;
    function GetNewest: T;
    function GetNewestIndex: Integer;
    function GetOldest: T;
    function GetOldestIndex: Integer;
    // Setters
    procedure SetItem(const AIndex: Integer; const AItem: T);
    // Management Methods
    function Add(const AItem: T): Integer;
    procedure AddItems(const AItems: Array of T);
    procedure Delete(const AIndex: Integer);
    // Properties
    property Items[const AIndex: Integer]:  T read GetItem write SetItem;
    property Newest: T read GetNewest;
    property NewestIndex: Integer read GetNewestIndex;
    property Oldest: T read GetOldest;
    property OldestIndex: Integer read GetOldestIndex;
  end;

implementation

end.
