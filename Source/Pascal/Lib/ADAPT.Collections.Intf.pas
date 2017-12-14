{
  AD.A.P.T. Library
  Copyright (C) 2014-2016, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Collections.Intf;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes,
  {$ELSE}
    Classes,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT, ADAPT.Intf;

  {$I ADAPT_RTTI.inc}

type
  // Callbacks
  {$IFDEF SUPPORTS_REFERENCETOMETHOD}
    TADListItemCallbackAnon<T> = reference to procedure(const AItem: T);
  {$ENDIF SUPPORTS_REFERENCETOMETHOD}
  TADListItemCallbackOfObject<T> = procedure(const AItem: T) of object;
  TADListItemCallbackUnbound<T> = procedure(const AItem: T);
  {$IFDEF SUPPORTS_REFERENCETOMETHOD}
    TADListMapCallbackAnon<TKey, TValue> = reference to procedure(const AKey: TKey; const AValue: TValue);
  {$ENDIF SUPPORTS_REFERENCETOMETHOD}
  TADListMapCallbackOfObject<TKey, TValue> = procedure(const AKey: TKey; const AValue: TValue) of object;
  TADListMapCallbackUnbound<TKey, TValue> = procedure(const AKey: TKey; const AValue: TValue);
  {$IFDEF SUPPORTS_REFERENCETOMETHOD}
    TADTreeNodeValueCallbackAnon<V> = reference to procedure(const Value: V);
  {$ENDIF SUPPORTS_REFERENCETOMETHOD}
  TADTreeNodeValueCallbackOfObject<V> = procedure(const Value: V) of object;
  TADTreeNodeValueCallbackUnbound<V> = procedure(const Value: V);

  {$IFDEF FPC}
    TArray<T> = Array of T; // FreePascal doesn't have this defined (yet)
  {$ENDIF FPC}

  ///  <summary><c>A Simple Generic Array with basic Management Methods (Read-Only Interface).</c></summary>
  IADArrayReader<T> = interface(IADInterface)
    // Getters
    ///  <returns><c>The current Allocated Capacity of this Array.</c></returns>
    function GetCapacity: Integer;
    ///  <returns><c>The Item from the Array at the given Index.</c></returns>
    function GetItem(const AIndex: Integer): T;
    // Properties
    ///  <returns><c>The current Allocated Capacity of this Array.</c></returns>
    property Capacity: Integer read GetCapacity;
    ///  <returns><c>The Item from the Array at the given Index.</c></returns>
    property Items[const AIndex: Integer]: T read GetItem; default;
  end;

  ///  <summary><c>A Simple Generic Array with basic Management Methods (Read/Write Interface).</c></summary>
  IADArray<T> = interface(IADArrayReader<T>)
    // Getters
    ///  <returns><c>Read-Only Interfaced Reference to this Array.</c></returns>
    function GetReader: IADArrayReader<T>;
    // Setters
    ///  <summary><c>Sets the Allocated Capacity to the given value.</c></summary>
    procedure SetCapacity(const ACapacity: Integer);
    ///  <summary><c>Assigns the given Item into the Array at the given Index.</c></summary>
    procedure SetItem(const AIndex: Integer; const AItem: T);
    // Management Methods
    ///  <summary><c>Empties the Array and sets it back to the original Capacity you specified in the Constructor.</c></summary>
    procedure Clear;
    ///  <summary><c>Finalizes the given Index and shifts subsequent Items to the Left.</c></summary>
    procedure Delete(const AIndex: Integer); overload;
    ///  <summary><c>Finalized the Items from the given Index and shifts all subsequent Items to the Left.</c></summary>
    procedure Delete(const AFirstIndex, ACount: Integer); overload;
    ///  <summary><c>Low-level Finalization of Items in the Array between the given </c>AIndex<c> and </c>AIndex + ACount<c>.</c></summary>
    procedure Finalize(const AIndex, ACount: Integer);
    ///  <summary><c>Shifts all subsequent Items to the Right to make room for the given Item.</c></summary>
    procedure Insert(const AItem: T; const AIndex: Integer);
    ///  <summary><c>Shifts the Items between </c>AFromIndex<c> and </c>AFromIndex + ACount<c> to the range </c>AToIndex<c> and </c>AToIndex + ACount<c> in a single (efficient) operation.</c></summary>
    procedure Move(const AFromIndex, AToIndex, ACount: Integer);
    // Properties
    ///  <summary><c>Sets the Allocated Capacity to the given value.</c></summary>
    ///  <returns><c>The current Allocated Capacity of this Array.</c></returns>
    property Capacity: Integer read GetCapacity write SetCapacity;
    ///  <summary><c>Assigns the given Item into the Array at the given Index.</c></summary>
    ///  <returns><c>The Item from the Array at the given Index.</c></returns>
    property Items[const AIndex: Integer]: T read GetItem write SetItem; default;
    ///  <returns><c>Read-Only Interfaced Reference to this Array.</c></returns>
    property Reader: IADArrayReader<T> read GetReader;
  end;

  ///  <summary><c>An Allocation Algorithm for Lists.</c></summary>
  ///  <remarks><c>Dictates how to grow an Array based on its current Capacity and the number of Items we're looking to Add/Insert.</c></remarks>
  IADExpander = interface(IADInterface)
  ['{B4742A80-74A7-408E-92BA-F854515B6D24}']
    function CheckExpand(const ACapacity, ACurrentcount, AAdditionalRequired: Integer): Integer;
  end;

  ///  <summary><c>A Geometric Allocation Algorithm for Lists.</c></summary>
  ///  <remarks>
  ///    <para><c>When the number of Vacant Slots falls below the Threshold, the number of Vacant Slots increases by the value of the current Capacity multiplied by the Mulitplier.</c></para>
  ///  </remarks>
  IADExpanderGeometric = interface(IADExpander)
  ['{CAF4B15C-9BE5-4A66-B31F-804AB752A102}']
    // Getters
    function GetCapacityMultiplier: Single;
    function GetCapacityThreshold: Integer;
    // Setters
    procedure SetCapacityMultiplier(const AMultiplier: Single);
    procedure SetCapacityThreshold(const AThreshold: Integer);
    // Properties
    property CapacityMultiplier: Single read GetCapacityMultiplier write SetCapacityMultiplier;
    property CapacityThreshold: Integer read GetCapacityThreshold write SetCapacityThreshold;
  end;

  ///  <summary><c>Provides Getter and Setter for any Type utilizing a Expander Type.</c></summary>
  IADExpandable = interface(IADInterface)
  ['{586ED0C9-E067-468F-B929-92F086E43D91}']
    // Getters
    function GetExpander: IADExpander;

    // Setters
    procedure SetExpander(const AExpander: IADExpander);

    // Properties
    property Expander: IADExpander read GetExpander write SetExpander;
  end;

  ///  <summary><c>A Deallocation Algorithm for Lists.</c></summary>
  ///  <remarks><c>Dictates how to shrink an Array based on its current Capacity and the number of Items we're looking to Delete.</c></remarks>
  IADCompactor = interface(IADInterface)
  ['{B7D577D4-8425-4C5D-9DDB-5864C3676199}']
    function CheckCompact(const ACapacity, ACurrentCount, AVacating: Integer): Integer;
  end;

  ///  <summary><c>Provides Getter and Setter for any Type utilizing a Compactor Type.</c></summary>
  IADCompactable = interface(IADInterface)
  ['{13208869-7530-4B3A-89D4-AFA2B164536B}']
    // Getters
    function GetCompactor: IADCompactor;

    // Setters
    procedure SetCompactor(const ACompactor: IADCompactor);

    // Management Method
    ///  <summary><c>Compacts the size of the underlying Array to the minimum required Capacity.</c></summary>
    ///  <remarks>
    ///    <para><c>Note that any subsequent addition to the List will need to expand the Capacity and could lead to reallocation.</c></para>
    ///  </remarks>
    procedure Compact;

    // Properties
    property Compactor: IADCompactor read GetCompactor write SetCompactor;
  end;

  ///  <summary><c>Common Behaviour for List and Map Sorters.</c></summary>
  IADSorter = interface(IADInterface)
  ['{C52DB3EA-FEF4-4BD8-8332-D867907CEACA}']

  end;

  ///  <summary><c>Sorting Alogirthm for Lists.</c></summary>
  IADListSorter<T> = interface(IADSorter)
    procedure Sort(const AArray: IADArray<T>; const AComparer: IADComparer<T>; AFrom, ATo: Integer); overload;
    procedure Sort(AArray: Array of T; const AComparer: IADComparer<T>; AFrom, ATo: Integer); overload;
  end;

  ///  <summary><c>Provides Getter and Setter for any Type utilizing a List Sorter Type.</c></summary>
  IADSortableList<T> = interface(IADInterface)
    // Getters
    function GetSorter: IADListSorter<T>;

    // Setters
    procedure SetSorter(const ASorter: IADListSorter<T>);

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
    function EqualItems(const AList: IADSortableList<T>): Boolean;
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
    ///  <summary><c>Sort the List.</c></summary>
    procedure Sort(const AComparer: IADComparer<T>);

    // Properties
    property Sorter: IADListSorter<T> read GetSorter write SetSorter;
  end;

  ///  <summary><c>Sorting Alogirthm for Maps.</c></summary>
  IADMapSorter<TKey, TValue> = interface(IADSorter)
    procedure Sort(const AArray: IADArray<IADKeyValuePair<TKey, TValue>>; const AComparer: IADComparer<TKey>; AFrom, ATo: Integer); overload;
    procedure Sort(AArray: Array of IADKeyValuePair<TKey, TValue>; const AComparer: IADComparer<TKey>; AFrom, ATo: Integer); overload;
  end;

  ///  <summary><c>Provides Getter and Setter for any Type utilizing a Map Sorter Type.</c></summary>
  IADSortableMap<TKey, TValue> = interface(IADInterface)
    // Getters
    function GetSorter: IADMapSorter<TKey, TValue>;

    // Setters
    procedure SetSorter(const ASorter: IADMapSorter<TKey, TValue>);

    // Properties
    property Sorter: IADMapSorter<TKey, TValue> read GetSorter write SetSorter;
  end;

  ///  <summary><c>Common Type-Insensitive Read-Only Interface for all Generic Collections.</c></summary>
  ///  <remarks>
  ///    <para><c>All Collection Classes should implement this Interface AS WELL AS their Context-Specific Interface(s).</c></para>
  ///  </remarks>
  IADCollectionReader = interface(IADInterface)
  ['{1083E5D0-8D0F-4ABB-9479-AEF8E26BE663}']
    // Getters
    ///  <returns><c>The present Capacity of the Collection.</c></returns>
    function GetCapacity: Integer;
    ///  <returns><c>The nunmber of Items in the Collection.</c></returns>
    function GetCount: Integer;
    ///  <returns><c>The initial Capacity of the Collection (at the point of Construction).</c></returns>
    function GetInitialCapacity: Integer;
    ///  <summary><c>Determines whether or not the List is Compact.</c></summary>
    ///  <returns>
    ///    <para>True<c> if the List is Compact.</c></para>
    ///    <para>False<c> if the List is NOT Compact.</c></para>
    ///  </returns>
    function GetIsCompact: Boolean;
    ///  <returns>
    ///    <para>True<c> if there are NO Items in the Collection.</c></para>
    ///    <para>False<c> if there are Items in the Collection.</c></para>
    ///  </returns>
    function GetIsEmpty: Boolean;
    ///  <returns>
    ///    <para>ssSorted<c> if the Collection is Sorted.</c></para>
    ///    <para>ssUnsorted<c> if the Collection is NOT Sorted.</c></para>
    ///    <para>ssUnknown<c> if the Sorted State of the Collection is Unknown.</c></para>
    ///  </returns>
    function GetSortedState: TADSortedState;

    // Properties
    ///  <returns><c>The present Capacity of the Collection.</c></returns>
    property Capacity: Integer read GetCapacity;
    ///  <returns><c>The nunmber of Items in the Collection.</c></returns>
    property Count: Integer read GetCount;
    ///  <returns><c>The initial Capacity of the Collection (at the point of Construction).</c></returns>
    property InitialCapacity: Integer read GetInitialCapacity;
    ///  <returns>
    ///    <para>True<c> if the Collection is Compact.</c></para>
    ///    <para>False<c> if the Collection is NOT Compact.</c></para>
    ///  </returns>
    property IsCompact: Boolean read GetIsCompact;
    ///  <returns>
    ///    <para>True<c> if there are NO Items in the Collection.</c></para>
    ///    <para>False<c> if there are Items in the Collection.</c></para>
    ///  </returns>
    property IsEmpty: Boolean read GetIsEmpty;
    ///  <returns>
    ///    <para>ssSorted<c> if the Collection is Sorted.</c></para>
    ///    <para>ssUnsorted<c> if the Collection is NOT Sorted.</c></para>
    ///    <para>ssUnknown<c> if the Sorted State of the Collection is Unknown.</c></para>
    ///  </returns>
    property SortedState: TADSortedState read GetSortedState;
  end;

  ///  <summary><c>Common Type-Insensitive Interface for all Generic Collections.</c></summary>
  ///  <remarks>
  ///    <para><c>All Collection Classes should implement this Interface AS WELL AS their Context-Specific Interface(s).</c></para>
  ///  </remarks>
  IADCollection = interface(IADCollectionReader)
  ['{B75BF54B-1400-4EFD-96A5-278E9F101B35}']
    // Getters
    ///  <returns><c>Read-Only Interfaced Reference to this Collection.</c></returns>
    function GetReader: IADCollectionReader;

    // Setters
    ///  <summary><c>Manually specify the Capacity of the Collection.</c></summary>
    ///  <remarks>
    ///    <para><c>Note that the Capacity should always be equal to or greater than the Count.</c></para>
    ///  </remarks>
    procedure SetCapacity(const ACapacity: Integer);

    // Management Methods
    ///  <summary><c>Removes all Items from the Collection.</c></summary>
    procedure Clear;

    // Properties
    ///  <summary><c>Manually specify the Capacity of the Collection.</c></summary>
    ///  <remarks>
    ///    <para><c>Note that the Capacity should always be equal to or greater than the Count.</c></para>
    ///  </remarks>
    ///  <returns><c>The present Capacity of the Collection.</c></returns>
    property Capacity: Integer read GetCapacity write SetCapacity;
    ///  <returns><c>Read-Only Interfaced Reference to this Collection.</c></returns>
    property Reader: IADCollectionReader read GetReader;
  end;

  {
    NOTE: Do NOT inherit any further Collection Interfaces from IADCollectionReader, IADCollection.
          These Interface Types are implemented by ALL COLLECTION CLASSES as well as their own respective Interfaces.
          The idea being you can cast any Collection to IADCollectionReader (for read-only) or IADCollection (for read-write)
          and these common methods/properties will operate identically on them all.
  }

  ///  <summary><c>Common Iterator Methods for all List-Type Collections.</c></summary>
  ///  <remarks>
  ///    <para><c>All List-Type Collection Classes should implement this Interface AS WELL AS their Context-Specific Interface(s).</c></para>
  ///  </remarks>
  IADIterableList<T> = interface(IADInterface)
    // Iterators
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure Iterate(const ACallback: TADListItemCallbackAnon<T>; const ADirection: TADIterateDirection = idRight); overload;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure Iterate(const ACallback: TADListItemCallbackOfObject<T>; const ADirection: TADIterateDirection = idRight); overload;
    procedure Iterate(const ACallback: TADListItemCallbackUnbound<T>; const ADirection: TADIterateDirection = idRight); overload;
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure IterateBackward(const ACallback: TADListItemCallbackAnon<T>); overload;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure IterateBackward(const ACallback: TADListItemCallbackOfObject<T>); overload;
    procedure IterateBackward(const ACallback: TADListItemCallbackUnbound<T>); overload;
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure IterateForward(const ACallback: TADListItemCallbackAnon<T>); overload;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure IterateForward(const ACallback: TADListItemCallbackOfObject<T>); overload;
    procedure IterateForward(const ACallback: TADListItemCallbackUnbound<T>); overload;
  end;

  ///  <summary><c>Common Iterator Methods for all Map-Type Collections.</c></summary>
  ///  <remarks>
  ///    <para><c>All Map-Type Collection Classes should implement this Interface AS WELL AS their Context-Specific Interface(s).</c></para>
  ///  </remarks>
  IADIterableMap<TKey, TValue> = interface(IADInterface)
    // Iterators
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure Iterate(const ACallback: TADListMapCallbackAnon<TKey, TValue>; const ADirection: TADIterateDirection = idRight); overload;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure Iterate(const ACallback: TADListMapCallbackOfObject<TKey, TValue>; const ADirection: TADIterateDirection = idRight); overload;
    procedure Iterate(const ACallback: TADListMapCallbackUnbound<TKey, TValue>; const ADirection: TADIterateDirection = idRight); overload;
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure IterateBackward(const ACallback: TADListMapCallbackAnon<TKey, TValue>); overload;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure IterateBackward(const ACallback: TADListMapCallbackOfObject<TKey, TValue>); overload;
    procedure IterateBackward(const ACallback: TADListMapCallbackUnbound<TKey, TValue>); overload;
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure IterateForward(const ACallback: TADListMapCallbackAnon<TKey, TValue>); overload;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure IterateForward(const ACallback: TADListMapCallbackOfObject<TKey, TValue>); overload;
    procedure IterateForward(const ACallback: TADListMapCallbackUnbound<TKey, TValue>); overload;
  end;

  ///  <summary><c>Common Type-Insensitive Read-Only Interface for all List Collections.</c></summary>.
  IADListReader<T> = interface(IADInterface)
    // Getters
    ///  <returns><c>The Item at the given Index.</c></returns>
    function GetItem(const AIndex: Integer): T;
    ///  <returns><c>Iterator Interfaced Reference for this List.</c></returns>
    function GetIterator: IADIterableList<T>;

    // Properties
    ///  <returns><c>The Item at the given Index.</c></returns>
    property Items[const AIndex: Integer]: T read GetItem; default;
    ///  <returns><c>Iterator Interfaced Reference for this List.</c></returns>
    property Iterator: IADIterableList<T> read GetIterator;
  end;

  ///  <summary><c>Common Type-Insensitive Read/Write Interface for all List Collections.</c></summary>.
  IADList<T> = interface(IADListReader<T>)
    // Getters
    ///  <returns><c>Read-Only Interfaced Reference to this List.</c></returns>
    function GetReader: IADListReader<T>;

    // Setters
    ///  <summary><c>Assigns the given Item to the given Index.</c></summary>
    procedure SetItem(const AIndex: Integer; const AItem: T);

    // Management Methods
    ///  <summary><c>Adds the given Item into the Collection.</c></summary>
    ///  <returns><c>The Index of the Item in the Collection.</c></returns>
    function Add(const AItem: T): Integer; overload;
    ///  <summary><c>Adds Items from the given List into this List.</c></summary>
    procedure Add(const AItems: IADListReader<T>); overload;
    ///  <summary><c>Adds multiple Items into the Collection.</c></summary>
    procedure AddItems(const AItems: Array of T);
    ///  <summary><c>Deletes the Item at the given Index.</c></summary>
    procedure Delete(const AIndex: Integer);
    ///  <summary><c>Deletes the Items from the Start Index to Start Index + Count.</c></summary>
    procedure DeleteRange(const AFirst, ACount: Integer);
    ///  <summary><c>Insert the given Item at the specified Index.</c></summary>
    ///  <remarks><c>Will Expand the List if necessary.</c></remarks>
    procedure Insert(const AItem: T; const AIndex: Integer);
    ///  <summary><c>Insert the given Items starting at the specified Index.</c></summary>
    ///  <remarks><c>Will Expand the List if necessary.</c></remarks>
    procedure InsertItems(const AItems: Array of T; const AIndex: Integer);

    // Properties
    ///  <summary><c>Assigns the given Item to the given Index.</c></summary>
    ///  <returns><c>The Item at the given Index.</c></returns>
    property Items[const AIndex: Integer]: T read GetItem write SetItem; default;
    ///  <returns><c>Read-Only Interfaced Reference to this List.</c></returns>
    property Reader: IADListReader<T> read GetReader;
  end;

  ///  <summary><c>Common Type-Insensitive Read-Only Interface for all Map Collections.</c></summary>.
  IADMapReader<TKey, TValue> = interface(IADInterface)
    // Getters
    ///  <returns><c>The Item corresponding to the given Key.</c></returns>
    function GetItem(const AKey: TKey): TValue;
    ///  <returns><c>Iterator Interfaced Reference for this Map.</c></returns>
    function GetIterator: IADIterableMap<TKey, TValue>;
    ///  <returns><c>The Key-Value Pair at the given Index.</c></returns>
    function GetPair(const AIndex: Integer): IADKeyValuePair<TKey, TValue>;

    // Management Methods
    ///  <summary><c>Performs a Lookup to determine whether the given Item is in the Map.</c></summary>
    ///  <returns>
    ///    <para>True<c> if the Item is in the List.</c></para>
    ///    <para>False<c> if the Item is NOT in the Map.</c></para>
    ///  </returns>
    function Contains(const AKey: TKey): Boolean;
    ///  <summary><c>Performs Lookups to determine whether the given Items are ALL in the Map.</c></summary>
    ///  <returns>
    ///    <para>True<c> if ALL Items are in the Map.</c></para>
    ///    <para>False<c> if NOT ALL Items are in the Map.</c></para>
    ///  </returns>
    function ContainsAll(const AKeys: Array of TKey): Boolean;
    ///  <summary><c>Performs Lookups to determine whether ANY of the given Items are in the Map.</c></summary>
    ///  <returns>
    ///    <para>True<c> if ANY of the Items are in the Map.</c></para>
    ///    <para>False<c> if NONE of the Items are in the Map.</c></para>
    ///  </returns>
    function ContainsAny(const AKeys: Array of TKey): Boolean;
    ///  <summary><c>Performs Lookups to determine whether ANY of the given Items are in the Map.</c></summary>
    ///  <returns>
    ///    <para>True<c> if NONE of the Items are in the Map.</c></para>
    ///    <para>False<c> if ANY of the Items are in the Map.</c></para>
    function ContainsNone(const AKeys: Array of TKey): Boolean;
    ///  <summary><c>Compares each Item in this Map against those in the Candidate Map to determine Equality.</c></summary>
    ///  <returns>
    ///    <para>True<c> ONLY if the Candidate Map contains ALL Items from this Map, and NO additional Items.</c></para>
    ///    <para>False<c> if not all Items are present or if any ADDITIONAL Items are present.</c></para>
    ///  </returns>
    ///  <remarks>
    ///    <para><c>This ONLY compares Items, and does not include ANY other considerations.</c></para>
    ///  </remarks>
    function EqualItems(const AList: IADMapReader<TKey, TValue>): Boolean;
    ///  <summary><c>Retreives the Index of the given Item within the Map.</c></summary>
    ///  <returns>
    ///    <para>-1<c> if the given Item is not in the Map.</c></para>
    ///    <para>0 or Greater<c> if the given Item IS in the Map.</c></para>
    ///  </returns>
    function IndexOf(const AKey: TKey): Integer;

    // Properties
    ///  <returns><c>The Item corresponding to the given Key.</c></returns>
    property Items[const AKey: TKey]: TValue read GetItem; default;
    ///  <returns><c>Iterator Interfaced Reference for this Map.</c></returns>
    property Iterator: IADIterableMap<TKey, TValue> read GetIterator;
    ///  <returns><c>The Key-Value Pair at the given Index.</c></returns>
    property Pairs[const AIndex: Integer]: IADKeyValuePair<TKey, TValue> read GetPair;
  end;

  ///  <summary><c>Common Type-Insensitive Read/Write Interface for all Map Collections.</c></summary>.
  IADMap<TKey, TValue> = interface(IADMapReader<TKey, TValue>)
    // Getters
    ///  <returns><c>Read-Only Interfaced Reference to this Map.</c></returns>
    function GetReader: IADMapReader<TKey, TValue>;

    // Setters
    ///  <summary><c>Assigns the given Value to the given Key (replacing any existing Value.)</c></summary>
    procedure SetItem(const AKey: TKey; const AValue: TValue);

    // Management Methods
    ///  <summary><c>Adds the given Key-Value Pair into the Map.</c></summary>
    ///  <returns>
    ///    <para><c>The Index of the Item in the Map.</c></para>
    ///  </returns>
    function Add(const AItem: IADKeyValuePair<TKey, TValue>): Integer; overload;
    ///  <summary><c>Adds the given Key-Value Pair into the Map.</c></summary>
    ///  <returns>
    ///    <para><c>The Index of the Item in the Map.</c></para>
    ///  </returns>
    function Add(const AKey: TKey; const AValue: TValue): Integer; overload;
    ///  <summary><c>Adds multiple Items into the Map.</c></summary>
    procedure AddItems(const AItems: Array of IADKeyValuePair<TKey, TValue>); overload;
    ///  <summary><c>Adds Items from the given Map into this Map.</c></summary>
    procedure AddItems(const AMap: IADMapReader<TKey, TValue>); overload;
    ///  <summary><c>Compacts the size of the underlying Array to the minimum required Capacity.</c></summary>
    ///  <remarks>
    ///    <para><c>Note that any subsequent addition to the Map will need to expand the Capacity and could lead to reallocation.</c></para>
    ///  </remarks>
    procedure Compact;
    ///  <summary><c>Deletes the Item at the given Index.</c></summary>
    procedure Delete(const AIndex: Integer); overload;
    ///  <summary><c>Deletes the Items from the Start Index to Start Index + Count.</c></summary>
    procedure DeleteRange(const AFromIndex, ACount: Integer); overload;
    ///  <summary><c>Deletes the given Item from the Map.</c></summary>
    ///  <remarks><c>Performs a Lookup to divine the given Item's Index.</c></remarks>
    procedure Remove(const AKey: TKey);
    ///  <summary><c>Deletes the given Items from the Map.</c></summary>
    ///  <remarks><c>Performs a Lookup for each Item to divine their respective Indexes.</c></remarks>
    procedure RemoveItems(const AKeys: Array of TKey);

    // Properties
    ///  <summary><c>Assigns the given Value to the given Key (replacing any existing Value.)</c></summary>
    ///  <returns><c>The Item corresponding to the given Key.</c></returns>
    property Items[const AKey: TKey]: TValue read GetItem write SetItem; default;
    ///  <returns><c>Read-Only Interfaced Reference to this Map.</c></returns>
    property Reader: IADMapReader<TKey, TValue> read GetReader;
  end;

  ///  <summary><c>A Generic Fixed-Capacity Revolving List</c></summary>
  ///  <remarks>
  ///    <para><c>Accessible in Read-Only Mode.</c></para>
  ///  </remarks>
  IADCircularListReader<T> = interface(IADInterface)
    // Getters
    ///  <returns>
    ///    <para>-1<c> if the Newest Item has subsequently been Deleted (or Invalidated).</c></para>
    ///    <para>0 or Greater<c> if the Newest Item is still Valid.</c></para>
    ///  </returns>
    function GetNewestIndex: Integer;
    ///  <returns><c>The Newest Item.</c></returns>
    function GetNewest: T;
    ///  <returns>
    ///    <para>-1<c> if the Oldest Item has subsequently been Deleted (or Invalidated).</c></para>
    ///    <para>0 or Greater<c> if the Oldest Item is still Valid.</c></para>
    ///  </returns>
    function GetOldestIndex: Integer;
    ///  <returns><c>The Oldest Item.</c></returns>
    function GetOldest: T;

    // Properties
    ///  <returns>
    ///    <para>-1<c> if the Newest Item has subsequently been Deleted (or Invalidated).</c></para>
    ///    <para>0 or Greater<c> if the Newest Item is still Valid.</c></para>
    ///  </returns>
    property NewestIndex: Integer read GetNewestIndex;
    ///  <returns><c>The Newest Item.</c></returns>
    property Newest: T read GetNewest;
    ///  <returns>
    ///    <para>ssSorted<c> if the Collection is Sorted.</c></para>
    ///    <para>ssUnsorted<c> if the Collection is NOT Sorted.</c></para>
    ///    <para>ssUnknown<c> if the Sorted State of the Collection is Unknown.</c></para>
    ///  </returns>
    property OldestIndex: Integer read GetOldestIndex;
    ///  <returns><c>The Oldest Item.</c></returns>
    property Oldest: T read GetOldest;
  end;

  ///  <summary><c>A Generic Fixed-Capacity Revolving List</c></summary>
  ///  <remarks>
  ///    <para><c>Accessible in Read/Write Mode.</c></para>
  ///  </remarks>
  IADCircularList<T> = interface(IADCircularListReader<T>)
    // Getters
    ///  <returns><c>Read-Only Interfaced Reference to this Circular List.</c></returns>
    function GetReader: IADCircularListReader<T>;

    // Properties
    ///  <returns><c>Read-Only Interfaced Reference to this Circular List.</c></returns>
    property Reader: IADCircularListReader<T> read GetReader;
  end;

implementation

end.
