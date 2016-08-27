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
  ///  <remarks>
  ///    <para><c>Accessible in Read-Only Mode.</c></para>
  ///  </remarks>
  IADListReader<T> = interface(IADCollection)
    // Getters
    ///  <returns><c>The Item at the given Index.</c></returns>
    function GetItem(const AIndex: Integer): T;

    // Properties
    property Items[const AIndex: Integer]: T read GetItem; default;
  end;

  ///  <summary><c>Generic List Type</c></summary>
  ///  <remarks>
  ///    <para><c>Accessible in Read-Write Mode.</c></para>
  ///  </remarks>
  IADList<T> = interface(IADListReader<T>)
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
  ///    <para><c>Accessible in Read-Only Mode.</c></para>
  ///  </remarks>
  IADCircularListReader<T> = interface(IADListReader<T>)
    // Getters
    function GetNewest: T;
    function GetNewestIndex: Integer;
    function GetOldest: T;
    function GetOldestIndex: Integer;

    // Properties
    property Newest: T read GetNewest;
    property NewestIndex: Integer read GetNewestIndex;
    property Oldest: T read GetOldest;
    property OldestIndex: Integer read GetOldestIndex;
  end;

  ///  <summary><c>A Generic Fixed-Capacity Revolving List</c></summary>
  ///  <remarks>
  ///    <para><c>Accessible in Read-Write Mode.</c></para>
  ///  </remarks>
  IADCircularList<T> = interface(IADCircularListReader<T>)
    // Management Methods
    function Add(const AItem: T): Integer;
    procedure AddItems(const AItems: Array of T);
    procedure Delete(const AIndex: Integer);

    // Properties
    property Items[const AIndex: Integer]:  T read GetItem; default;
  end;

  ///  <summary><c>A Generic Sorted List.</c></summary>
  ///  <remarks>
  ///    <para><c>Sorted Lists utilize Sorted Insertion to ensure that all Lookups can be performed efficiently.</c></para>
  ///    <para><c>Sorted Lists are NOT a "Hashmap" or "Dictionary".</c></para>
  ///    <para><c>Accessible in Read-Only Mode.</c></para>
  ///  </remarks>
  IADSortedListReader<T> = interface(IADListReader<T>)
    // Management Methods
    ///  <summary><c>Performs a Lookup to determine whether the given Item is in the List.</c></summary>
    ///  <returns>
    ///    <para>True<c> if the Item is in the List.</c></para>
    ///    <para>False<c> if the Item is NOT in the List.</c></para>
    ///  </returns>
    function Contains(const AItem: T): Boolean;
    ///  <summary><c>Performs Lookups to determine whether the given Items are ALL in the List.</c></summary>
    ///  <returns>
    ///    <para>True<c> if ALL Items are in the List.</c></para>
    ///    <para>False<c> if NOT ALL Items are in the List.</c></para>
    ///  </returns>
    function ContainsAll(const AItems: Array of T): Boolean;
    ///  <summary><c>Performs Lookups to determine whether ANY of the given Items are in the List.</c></summary>
    ///  <returns>
    ///    <para>True<c> if ANY of the Items are in the List.</c></para>
    ///    <para>False<c> if NONE of the Items are in the List.</c></para>
    ///  </returns>
    function ContainsAny(const AItems: Array of T): Boolean;
    ///  <summary><c>Performs Lookups to determine whether ANY of the given Items are in the List.</c></summary>
    ///  <returns>
    ///    <para>True<c> if NONE of the Items are in the List.</c></para>
    ///    <para>False<c> if ANY of the Items are in the List.</c></para>
    function ContainsNone(const AItems: Array of T): Boolean;
    ///  <summary><c>Compares each Item in this List against those in the Candidate List to determine Equality.</c></summary>
    ///  <returns>
    ///    <para>True<c> ONLY if the Candidate List contains ALL Items from this List, and NO additional Items.</c></para>
    ///    <para>False<c> if not all Items are present or if any ADDITIONAL Items are present.</c></para>
    ///  </returns>
    ///  <remarks>
    ///    <para><c>This ONLY compares Items, and does not include ANY other considerations.</c></para>
    ///  </remarks>
    function EqualItems(const AList: IADSortedListReader<T>): Boolean;
    ///  <summary><c>Retreives the Index of the given Item within the List.</c></summary>
    ///  <returns>
    ///    <para>-1<c> if the given Item is not in the List.</c></para>
    ///    <para>0 or Greater<c> if the given Item IS in the List.</c></para>
    ///  </returns>
    function IndexOf(const AItem: T): Integer;
  end;

  ///  <summary><c>A Generic Sorted List.</c></summary>
  ///  <remarks>
  ///    <para><c>Sorted Lists utilize Sorted Insertion to ensure that all Lookups can be performed efficiently.</c></para>
  ///    <para><c>Sorted Lists are NOT a "Hashmap" or "Dictionary".</c></para>
  ///    <para><c>Accessible in Read-Write Mode.</c></para>
  ///  </remarks>
  IADSortedList<T> = interface(IADSortedListReader<T>)
    // Setters

    // Management Methods
    ///  <summary><c>Adds the given Item into the List.</c></summary>
    ///  <returns>
    ///    <para><c>The Index of the Item in the List.</c></para>
    ///  </returns>
    function Add(const AItem: T): Integer;
    ///  <summary><c>Adds multiple Items into the List.</c></summary>
    procedure AddItems(const AItems: Array of T); overload;
    ///  <summary><c>Adds Items from the given List into this List.</c></summary>
    procedure AddItems(const AList: IADSortedList<T>); overload;
    ///  <summary><c>Compacts the size of the underlying Array to the minimum required Capacity.</c></summary>
    ///  <remarks>
    ///    <para><c>Note that any subsequent addition to the List will need to expand the Capacity and could lead to reallocation.</c></para>
    ///  </remarks>
    procedure Compact;
    ///  <summary><c>Deletes the Item at the given Index.</c></summary>
    procedure Delete(const AIndex: Integer); overload;
    ///  <summary><c>Deletes the Items from the Start Index to Start Index + Count.</c></summary>
    procedure DeleteRange(const AFromIndex, ACount: Integer); overload;
    ///  <summary><c>Deletes the given Item from the List.</c></summary>
    ///  <remarks><c>Performs a Lookup to divine the given Item's Index.</c></remarks>
    procedure Remove(const AItem: T);
    ///  <summary><c>Deletes the given Items from the List.</c></summary>
    ///  <remarks><c>Performs a Lookup for each Item to divine their respective Indexes.</c></remarks>
    procedure RemoveItems(const AItems: Array of T);
  end;

implementation

end.
