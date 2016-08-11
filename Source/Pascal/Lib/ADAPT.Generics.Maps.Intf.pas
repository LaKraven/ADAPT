{
  AD.A.P.T. Library
  Copyright (C) 2014-2016, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Generics.Maps.Intf;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes,
  {$ELSE}
    Classes,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Common.Intf,
  ADAPT.Generics.Common.Intf;

  {$I ADAPT_RTTI.inc}

type
  ///  <summary><c>A Generic Sorted List.</c></summary>
  ///  <remarks>
  ///    <para><c>Sorted Lists utilize Sorted Insertion to ensure that all Lookups can be performed efficiently.</c></para>
  ///    <para><c>Sorted Lists are NOT a "Hashmap" or "Dictionary".</c></para>
  ///  </remarks>
  IADSortedList<T> = interface(IADInterface)
    // Getters
    ///  <returns><c>The nunmber of Items in the List.</c></returns>
    function GetCount: Integer;
    ///  <summary><c>Determines whether or not the List is Compact.</c></summary>
    ///  <returns>
    ///    <para>True<c> if the List is Compact.</c></para>
    ///    <para>False<c> if the List is NOT Compact.</c></para>
    ///  </returns>
    function GetIsCompact: Boolean;
    ///  <returns>
    ///    <para>True<c> if there are NO Items in the List.</c></para>
    ///    <para>False<c> if there are Items in the List.</c></para>
    ///  </returns>
    function GetIsEmpty: Boolean;
    ///  <returns><c>The Item at the given Index.</c></returns>
    function GetItem(const AIndex: Integer): T;

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
    ///  <summary><c>Removes all Items from the List.</c></summary>
    procedure Clear;
    ///  <summary><c>Compacts the size of the underlying Array to the minimum required Capacity.</c></summary>
    ///  <remarks>
    ///    <para><c>Note that any subsequent addition to the List will need to expand the Capacity and could lead to reallocation.</c></para>
    ///  </remarks>
    procedure Compact;
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
    ///  <summary><c>Deletes the Item at the given Index.</c></summary>
    procedure Delete(const AIndex: Integer); overload;
    ///  <summary><c>Deletes the Items from the Start Index to Start Index + Count.</c></summary>
    procedure DeleteRange(const AFromIndex, ACount: Integer); overload;
    ///  <summary><c>Compares each Item in this List against those in the Candidate List to determine Equality.</c></summary>
    ///  <returns>
    ///    <para>True<c> ONLY if the Candidate List contains ALL Items from this List, and NO additional Items.</c></para>
    ///    <para>False<c> if not all Items are present or if any ADDITIONAL Items are present.</c></para>
    ///  </returns>
    ///  <remarks>
    ///    <para><c>This ONLY compares Items, and does not include ANY other considerations.</c></para>
    ///  </remarks>
    function EqualItems(const AList: IADSortedList<T>): Boolean;
    ///  <summary><c>Retreives the Index of the given Item within the List.</c></summary>
    ///  <returns>
    ///    <para>-1<c> if the given Item is not in the List.</c></para>
    ///    <para>0 or Greater<c> if the given Item IS in the List.</c></para>
    ///  </returns>
    function IndexOf(const AItem: T): Integer;
    ///  <summary><c>Deletes the given Item from the List.</c></summary>
    ///  <remarks><c>Performs a Lookup to divine the given Item's Index.</c></remarks>
    procedure Remove(const AItem: T);
    ///  <summary><c>Deletes the given Items from the List.</c></summary>
    ///  <remarks><c>Performs a Lookup for each Item to divine their respective Indexes.</c></remarks>
    procedure RemoveItems(const AItems: Array of T);

    // Properties
    ///  <returns><c>The nunmber of Items in the List.</c></returns>
    property Count: Integer read GetCount;
    ///  <returns>
    ///    <para>True<c> if the List is Compact.</c></para>
    ///    <para>False<c> if the List is NOT Compact.</c></para>
    ///  </returns>
    property IsCompact: Boolean read GetIsCompact;
    ///  <returns>
    ///    <para>True<c> if there are NO Items in the List.</c></para>
    ///    <para>False<c> if there are Items in the List.</c></para>
    ///  </returns>
    property IsEmpty: Boolean read GetIsEmpty;
    ///  <returns><c>The Item at the given Index.</c></returns>
    property Item[const AIndex: Integer]: T read GetItem; default;
  end;

  ///  <summary><c>A Generic Lookup List.</c></summary>
  ///  <remarks>
  ///    <para><c>Lookup Lists utilize Sorted Insertion based on the Key to ensure that all Lookups can be performed efficiently.</c></para>
  ///  </remarks>
  IADLookupList<TKey, TValue> = interface(IADInterface)
    // Getters
    ///  <returns><c>The nunmber of Items in the List.</c></returns>
    function GetCount: Integer;
    ///  <summary><c>Determines whether or not the List is Compact.</c></summary>
    ///  <returns>
    ///    <para>True<c> if the List is Compact.</c></para>
    ///    <para>False<c> if the List is NOT Compact.</c></para>
    ///  </returns>
    function GetIsCompact: Boolean;
    ///  <returns>
    ///    <para>True<c> if there are NO Items in the List.</c></para>
    ///    <para>False<c> if there are Items in the List.</c></para>
    ///  </returns>
    function GetIsEmpty: Boolean;
    ///  <returns><c>The Item corresponding to the given Key.</c></returns>
    function GetItem(const AKey: TKey): TValue;
    ///  <returns><c>The Key-Value Pair at the given Index.</c></returns>
    function GetPair(const AIndex: Integer): IADKeyValuePair<TKey, TValue>;

    // Setters

    // Management Methods
    ///  <summary><c>Adds the given Key-Value Pair into the List.</c></summary>
    ///  <returns>
    ///    <para><c>The Index of the Item in the List.</c></para>
    ///  </returns>
    function Add(const AItem: IADKeyValuePair<TKey, TValue>): Integer; overload;
    ///  <summary><c>Adds the given Key-Value Pair into the List.</c></summary>
    ///  <returns>
    ///    <para><c>The Index of the Item in the List.</c></para>
    ///  </returns>
    function Add(const AKey: TKey; const AValue: TValue): Integer; overload;
    ///  <summary><c>Adds multiple Items into the List.</c></summary>
    procedure AddItems(const AItems: Array of IADKeyValuePair<TKey, TValue>); overload;
    ///  <summary><c>Adds Items from the given List into this List.</c></summary>
    procedure AddItems(const AList: IADLookupList<TKey, TValue>); overload;
    ///  <summary><c>Removes all Items from the List.</c></summary>
    procedure Clear;
    ///  <summary><c>Compacts the size of the underlying Array to the minimum required Capacity.</c></summary>
    ///  <remarks>
    ///    <para><c>Note that any subsequent addition to the List will need to expand the Capacity and could lead to reallocation.</c></para>
    ///  </remarks>
    procedure Compact;
    ///  <summary><c>Performs a Lookup to determine whether the given Item is in the List.</c></summary>
    ///  <returns>
    ///    <para>True<c> if the Item is in the List.</c></para>
    ///    <para>False<c> if the Item is NOT in the List.</c></para>
    ///  </returns>
    function Contains(const AKey: TKey): Boolean;
    ///  <summary><c>Performs Lookups to determine whether the given Items are ALL in the List.</c></summary>
    ///  <returns>
    ///    <para>True<c> if ALL Items are in the List.</c></para>
    ///    <para>False<c> if NOT ALL Items are in the List.</c></para>
    ///  </returns>
    function ContainsAll(const AKeys: Array of TKey): Boolean;
    ///  <summary><c>Performs Lookups to determine whether ANY of the given Items are in the List.</c></summary>
    ///  <returns>
    ///    <para>True<c> if ANY of the Items are in the List.</c></para>
    ///    <para>False<c> if NONE of the Items are in the List.</c></para>
    ///  </returns>
    function ContainsAny(const AKeys: Array of TKey): Boolean;
    ///  <summary><c>Performs Lookups to determine whether ANY of the given Items are in the List.</c></summary>
    ///  <returns>
    ///    <para>True<c> if NONE of the Items are in the List.</c></para>
    ///    <para>False<c> if ANY of the Items are in the List.</c></para>
    function ContainsNone(const AKeys: Array of TKey): Boolean;
    ///  <summary><c>Deletes the Item at the given Index.</c></summary>
    procedure Delete(const AIndex: Integer); overload;
    ///  <summary><c>Deletes the Items from the Start Index to Start Index + Count.</c></summary>
    procedure DeleteRange(const AFromIndex, ACount: Integer); overload;
    ///  <summary><c>Compares each Item in this List against those in the Candidate List to determine Equality.</c></summary>
    ///  <returns>
    ///    <para>True<c> ONLY if the Candidate List contains ALL Items from this List, and NO additional Items.</c></para>
    ///    <para>False<c> if not all Items are present or if any ADDITIONAL Items are present.</c></para>
    ///  </returns>
    ///  <remarks>
    ///    <para><c>This ONLY compares Items, and does not include ANY other considerations.</c></para>
    ///  </remarks>
    function EqualItems(const AList: IADLookupList<TKey, TValue>): Boolean;
    ///  <summary><c>Retreives the Index of the given Item within the List.</c></summary>
    ///  <returns>
    ///    <para>-1<c> if the given Item is not in the List.</c></para>
    ///    <para>0 or Greater<c> if the given Item IS in the List.</c></para>
    ///  </returns>
    function IndexOf(const AKey: TKey): Integer;
    ///  <summary><c>Deletes the given Item from the List.</c></summary>
    ///  <remarks><c>Performs a Lookup to divine the given Item's Index.</c></remarks>
    procedure Remove(const AKey: TKey);
    ///  <summary><c>Deletes the given Items from the List.</c></summary>
    ///  <remarks><c>Performs a Lookup for each Item to divine their respective Indexes.</c></remarks>
    procedure RemoveItems(const AKeys: Array of TKey);

    // Properties
    ///  <returns><c>The nunmber of Items in the List.</c></returns>
    property Count: Integer read GetCount;
    ///  <returns>
    ///    <para>True<c> if the List is Compact.</c></para>
    ///    <para>False<c> if the List is NOT Compact.</c></para>
    ///  </returns>
    property IsCompact: Boolean read GetIsCompact;
    ///  <returns>
    ///    <para>True<c> if there are NO Items in the List.</c></para>
    ///    <para>False<c> if there are Items in the List.</c></para>
    ///  </returns>
    property IsEmpty: Boolean read GetIsEmpty;
    ///  <returns><c>The Item corresponding to the given Key.</c></returns>
    property Item[const AKey: TKey]: TValue read GetItem; default;
    ///  <returns><c>The Key-Value Pair at the given Index.</c></returns>
    property Pair[const AIndex: Integer]: IADKeyValuePair<TKey, TValue> read GetPair;
  end;

implementation

end.
