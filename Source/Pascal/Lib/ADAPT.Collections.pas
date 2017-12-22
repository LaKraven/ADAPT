{
  AD.A.P.T. Library
  Copyright (C) 2014-2018, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Collections;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes,
  {$ELSE}
    Classes,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT, ADAPT.Intf,
  ADAPT.Collections.Intf;

  {$I ADAPT_RTTI.inc}

type
  ///  <summary><c>A Simple Generic Array with basic Management Methods.</c></summary>
  ///  <remarks>
  ///    <para><c>Use IADArray or IADArrayReader if you want to take advantage of Reference Counting.</c></para>
  ///    <para><c>This is NOT Threadsafe</c></para>
  ///  </remarks>
  TADArray<T> = class(TADObject, IADArrayReader<T>, IADArray<T>)
  private
    FArray: TArray<IADValueHolder<T>>;
    FCapacityInitial: Integer;
    // Getters
    { IADArrayReader<T> }
    function GetCapacity: Integer;
    function GetItem(const AIndex: Integer): T;
    { IADArray<T> }
    function GetReader: IADArrayReader<T>;

    // Setters
    { IADArray<T> }
    procedure SetCapacity(const ACapacity: Integer);
    procedure SetItem(const AIndex: Integer; const AItem: T);
  public
    constructor Create(const ACapacity: Integer = 0); reintroduce; virtual;
    destructor Destroy; override;
    // Management Methods
    { IADArray<T> }
    procedure Clear;
    procedure Delete(const AIndex: Integer); overload;
    procedure Delete(const AFirstIndex, ACount: Integer); overload;
    procedure Finalize(const AIndex, ACount: Integer);
    procedure Insert(const AItem: T; const AIndex: Integer);
    procedure Move(const AFromIndex, AToIndex, ACount: Integer);

    // Properties
    { IADArrayReader<T> }
    property Capacity: Integer read GetCapacity;
    property Items[const AIndex: Integer]: T read GetItem; default;
    { IADArray<T> }
    property Items[const AIndex: Integer]: T read GetItem write SetItem; default;
    property Reader: IADArrayReader<T> read GetReader;
  end;

  ///  <summary><c>An Allocation Algorithm for Lists.</c></summary>
  ///  <remarks><c>Dictates how to grow an Array based on its current Capacity and the number of Items we're looking to Add/Insert.</c></remarks>
  TADExpander = class abstract(TADObject, IADExpander)
  public
    { IADExpander }
    ///  <summary><c>Override this to implement the actual Allocation Algorithm</c></summary>
    ///  <remarks><c>Must return the amount by which the Array has been Expanded.</c></remarks>
    function CheckExpand(const ACapacity, ACurrentCount, AAdditionalRequired: Integer): Integer; virtual; abstract;
  end;

  ///  <summary><c>A Geometric Allocation Algorithm for Lists.</c></summary>
  ///  <remarks>
  ///    <para><c>When the number of Vacant Slots falls below the Threshold, the number of Vacant Slots increases by the value of the current Capacity multiplied by the Mulitplier.</c></para>
  ///    <para><c>This Expander Type is NOT Threadsafe.</c></para>
  ///  </remarks>
  TADExpanderGeometric = class(TADExpander, IADExpanderGeometric)
  private
    FMultiplier: Single;
    FThreshold: Integer;
  protected
    // Getters
    { IADExpanderGeometric }
    function GetCapacityMultiplier: Single; virtual;
    function GetCapacityThreshold: Integer; virtual;
    // Setters
    { IADExpanderGeometric }
    procedure SetCapacityMultiplier(const AMultiplier: Single); virtual;
    procedure SetCapacityThreshold(const AThreshold: Integer); virtual;
  public
    { IADExpanderGeometric }
    function CheckExpand(const ACapacity, ACurrentCount, AAdditionalRequired: Integer): Integer; override;
  public
    // Properties
    { IADExpanderGeometric }
    property CapacityMultiplier: Single read GetCapacityMultiplier write SetCapacityMultiplier;
    property CapacityThreshold: Integer read GetCapacityThreshold write SetCapacityThreshold;
  end;

  ///  <summary><c>A Deallocation Algorithm for Lists.</c></summary>
  ///  <remarks><c>Dictates how to shrink an Array based on its current Capacity and the number of Items we're looking to Delete.</c></remarks>
  TADCompactor = class abstract(TADObject, IADCompactor)
  public
    { IADCompactor }
    function CheckCompact(const ACapacity, ACurrentCount, AVacating: Integer): Integer; virtual; abstract;
  end;

  ///  <summary><c>Abstract Base Class for all Collection Classes.</c></summary>
  ///  <remarks>
  ///    <para><c>Use IADCollectionReader or IADCollection if you want to take advantage of Reference Counting.</c></para>
  ///    <para><c>This is NOT Threadsafe</c></para>
  ///  </remarks>
  TADCollection = class abstract(TADObject, IADCollectionReader, IADCollection)
  protected
    FCount: Integer;
    FInitialCapacity: Integer;
    FSortedState: TADSortedState;

    // Getters
    { IADCollectionReader }
    function GetCapacity: Integer; virtual; abstract;
    function GetCount: Integer; virtual;
    function GetInitialCapacity: Integer;
    function GetIsCompact: Boolean; virtual; abstract;
    function GetIsEmpty: Boolean; virtual;
    function GetSortedState: TADSortedState; virtual;
    { IADCollection }
    function GetReader: IADCollectionReader;

    // Setters
    { IADCollectionReader }
    { IADCollection }
    procedure SetCapacity(const ACapacity: Integer); virtual; abstract;

    // Overridables
    procedure CreateArray(const AInitialCapacity: Integer); virtual; abstract;

    constructor Create(const AInitialCapacity: Integer); reintroduce; virtual;
  public
    // Management Methods
    { IADCollectionReader }
    { IADCollection }
    procedure Clear; virtual; abstract;

    // Properties
    { IADCollectionReader }
    property Capacity: Integer read GetCapacity write SetCapacity;
    property Count: Integer read GetCount;
    property InitialCapacity: Integer read GetInitialCapacity;
    property IsCompact: Boolean read GetIsCompact;
    property IsEmpty: Boolean read GetIsEmpty;
    property SortedState: TADSortedState read GetSortedState;
    { IADCollection }
    property Reader: IADCollectionReader read GetReader;
  end;

  ///  <summary><c>Abstract Base Type for all Generic List Collection Types.</c></summary>
  ///  <remarks>
  ///    <para><c>Use IADListReader for Read-Only access.</c></para>
  ///    <para><c>Use IADList for Read/Write access.</c></para>
  ///    <para><c>Use IADIterableList for Iterators.</c></para>
  ///    <para><c>Call .Iterator against IADListReader to return the IADIterableList interface reference.</c></para>
  ///  </remarks>
  TADListBase<T> = class abstract(TADCollection, IADListReader<T>, IADList<T>, IADIterableList<T>)
  private
    // Getters
    { IADListReader<T> }
    function GetIterator: IADIterableList<T>;
    { IADList<T> }
    function GetReader: IADListReader<T>;
    { IADIterableList<T> }
  protected
    FArray: IADArray<T>;
    FSorter: IADListSorter<T>;
    // Getters
    { TADCollection Overrides }
    function GetCapacity: Integer; override;
    function GetIsCompact: Boolean; override;
    { IADListReader<T> }
    function GetItem(const AIndex: Integer): T; virtual;

    // Setters
    { TADCollection Overrides }
    procedure SetCapacity(const ACapacity: Integer); override;
    { IADListReader<T> }
    { IADList<T> }
    procedure SetItem(const AIndex: Integer; const AItem: T); virtual; abstract; // Each List Type performs a specific process, so we Override this for each List Type
    { IADIterableList<T> }

    // Overrides
    { TADCollection Overrides }
    procedure CreateArray(const AInitialCapacity: Integer = 0); override;

    // Overrideables
    function AddActual(const AItem: T): Integer; virtual; abstract; // Each List Type performs a specific process, so we Override this for each List Type
    procedure DeleteActual(const AIndex: Integer); virtual; abstract; // Each List Type performs a specific process, so we Override this for each List Type
    procedure InsertActual(const AItem: T; const AIndex: Integer); virtual; abstract; // Each List Type performs a specific process, so we Override this for each List Type

    constructor Create(const AInitialCapacity: Integer); override;
  public
    // Management Methods
    { TADCollection Overrides }
    procedure Clear; override;
    { IADListReader<T> }
    { IADList<T> }
    function Add(const AItem: T): Integer; overload; virtual;
    procedure Add(const AItems: IADListReader<T>); overload; virtual;
    procedure AddItems(const AItems: Array of T); virtual;
    procedure Delete(const AIndex: Integer); virtual;
    procedure DeleteRange(const AFirst, ACount: Integer); virtual;
    procedure Insert(const AItem: T; const AIndex: Integer);
    procedure InsertItems(const AItems: Array of T; const AIndex: Integer);
    procedure Sort(const AComparer: IADComparer<T>); overload; virtual;
    procedure Sort(const ASorter: IADListSorter<T>; const AComparer: IADComparer<T>); overload; virtual;
    procedure SortRange(const AComparer: IADComparer<T>; const AFromIndex: Integer; const AToIndex: Integer); overload; virtual;
    procedure SortRange(const ASorter: IADListSorter<T>; const AComparer: IADComparer<T>; const AFromIndex: Integer; const AToIndex: Integer); overload; virtual;

    { IADIterableList<T> }
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

    // Properties
    { IADListReader<T> }
    property Items[const AIndex: Integer]: T read GetItem; default;
    property Iterator: IADIterableList<T> read GetIterator;
    { IADList<T> }
    property Items[const AIndex: Integer]: T read GetItem write SetItem; default;
    property Reader: IADListReader<T> read GetReader;
  end;

  ///  <summary><c>Abstract Base Type for all Expandable/Compactable Generic List Collection Types.</c></summary>
  ///  <remarks>
  ///    <para><c>Use IADListReader for Read-Only access.</c></para>
  ///    <para><c>Use IADList for Read/Write access.</c></para>
  ///    <para><c>Use IADIterableList for Iterators.</c></para>
  ///    <para><c>Call .Iterator against IADListReader to return the IADIterableList interface reference.</c></para>
  ///    <para><c>Use IADCompactable to Get/Set Compactor.</c></para>
  ///    <para><c>Use IADExpandable to Get/Set Expander.</c></para>
  ///  </remarks>
  TADListExpandableBase<T> = class abstract(TADListBase<T>, IADCompactable, IADExpandable)
  protected
    FCompactor: IADCompactor;
    FExpander: IADExpander;
    // Getters
    { IADCompactable }
    function GetCompactor: IADCompactor; virtual;
    { IADExpandable }
    function GetExpander: IADExpander; virtual;

    // Setters
    { IADCompactable }
    procedure SetCompactor(const ACompactor: IADCompactor); virtual;
    { IADExpandable }
    procedure SetExpander(const AExpander: IADExpander); virtual;

    { Overridables }
    ///  <summary><c>Compacts the Array according to the given Compactor Algorithm.</c></summary>
    procedure CheckCompact(const AAmount: Integer); virtual;
    ///  <summary><c>Expands the Array according to the given Expander Algorithm.</c></summary>
    procedure CheckExpand(const AAmount: Integer); virtual;
  public
    // Management Methods
    { IADCompactable }
    procedure Compact;
    { IADExpandable }

    // Properties
    { IADCompactable }
    property Compactor: IADCompactor read GetCompactor write SetCompactor;
    { IADExpandable }
    property Expander: IADExpander read GetExpander write SetExpander;
  end;

  ///  <summary><c>Generic List Collection.</c></summary>
  ///  <remarks>
  ///    <para><c>Use IADListReader for Read-Only access.</c></para>
  ///    <para><c>Use IADList for Read/Write access.</c></para>
  ///    <para><c>Use IADIterableList for Iterators.</c></para>
  ///    <para><c>Call .Iterator against IADListReader to return the IADIterableList interface reference.</c></para>
  ///    <para><c>Cast to IADCompactable to define a Compactor Type.</c></para>
  ///    <para><c>Cast to IADExpandable to define an Expander Type.</c></para>
  ///  </remarks>
  TADList<T> = class(TADListExpandableBase<T>)
  protected
    // Overrides
    { TADListBase Overrides }
    function AddActual(const AItem: T): Integer; override;
    procedure DeleteActual(const AIndex: Integer); override;
    procedure InsertActual(const AItem: T; const AIndex: Integer); override;
    procedure SetItem(const AIndex: Integer; const AItem: T); override;
  public
    ///  <summary><c>Creates an instance of your Collection using the Default Expander and Compactor Types.</c></summary>
    constructor Create(const AInitialCapacity: Integer = 0); reintroduce; overload;
    ///  <summary><c>Creates an instance of your Collection using a Custom Expander Instance, and the default Compactor Type.</c></summary>
    constructor Create(const AExpander: IADExpander; const AInitialCapacity: Integer = 0); reintroduce; overload;
    ///  <summary><c>Creates an instance of your Collection using the default Expander Type, and a Custom Compactor Instance.</c></summary>
    constructor Create(const ACompactor: IADCompactor; const AInitialCapacity: Integer = 0); reintroduce; overload;
    ///  <summary><c>Creates an instance of your Collection using a Custom Expander and Compactor Instance.</c></summary>
    constructor Create(const AExpander: IADExpander; const ACompactor: IADCompactor; const AInitialCapacity: Integer = 0); reintroduce; overload; virtual;
  end;

  ///  <summary><c>Generic Sorted List Collection.</c></summary>
  ///  <remarks>
  ///    <para><c>Use IADListReader for Read-Only access.</c></para>
  ///    <para><c>Use IADList for Read/Write access.</c></para>
  ///    <para><c>Use IADIterableList for Iterators.</c></para>
  ///    <para><c>Call .Iterator against IADListReader to return the IADIterableList interface reference.</c></para>
  ///    <para><c>Cast to IADCompactable to define a Compactor Type.</c></para>
  ///    <para><c>Cast to IADExpandable to define an Expander Type.</c></para>
  ///  </remarks>
  TADSortedList<T> = class(TADListExpandableBase<T>, IADSortedListReader<T>, IADSortedList<T>, IADComparable<T>)
  private
    FComparer: IADComparer<T>;
  protected
    // Getters
    { IADComparable<T> }
    function GetComparer: IADComparer<T>; virtual;
    { IADSortedList<T> }
    function GetReader: IADSortedListReader<T>;

    // Setters
    { IADComparable<T> }
    procedure SetComparer(const AComparer: IADComparer<T>); virtual;

    // Overrides
    { TADCollection Overrides }
    function GetSortedState: TADSortedState; override;
    { TADListBase  Overrides }
    ///  <summary><c>Adds the Item to the correct Index of the Array WITHOUT checking capacity.</c></summary>
    ///  <returns>
    ///    <para>-1<c> if the Item CANNOT be added.</c></para>
    ///    <para>0 OR GREATER<c> if the Item has be added, where the Value represents the Index of the Item.</c></para>
    ///  </returns>
    function AddActual(const AItem: T): Integer; override;
    procedure DeleteActual(const AIndex: Integer); override;
    procedure InsertActual(const AItem: T; const AIndex: Integer); override; // This effectively passes the call along to AddAcutal as we cannot Insert with explicit Indexes on a Sorted List.
    procedure SetItem(const AIndex: Integer; const AItem: T); override; // This effectively deletes the item at AIndex, then calls AddActual to add AItem at its Sorted Index. We cannot explicitly set Items on a Sorted List.

    // Overridables
    ///  <summary><c>Determines the Index at which an Item would need to be Inserted for the List to remain in-order.</c></summary>
    ///  <remarks>
    ///    <para><c>This is basically a Binary Sort implementation.<c></para>
    ///  </remarks>
    function GetSortedPosition(const AItem: T): Integer; virtual;
  public
    ///  <summary><c>Creates an instance of your Collection using the Default Expander and Compactor Types.</c></summary>
    constructor Create(const AComparer: IADComparer<T>; const AInitialCapacity: Integer = 0); reintroduce; overload;
    ///  <summary><c>Creates an instance of your Collection using a Custom Expander Instance, and the default Compactor Type.</c></summary>
    constructor Create(const AComparer: IADComparer<T>; const AExpander: IADExpander; const AInitialCapacity: Integer = 0); reintroduce; overload;
    ///  <summary><c>Creates an instance of your Collection using the default Expander Type, and a Custom Compactor Instance.</c></summary>
    constructor Create(const AComparer: IADComparer<T>; const ACompactor: IADCompactor; const AInitialCapacity: Integer = 0); reintroduce; overload;
    ///  <summary><c>Creates an instance of your Collection using a Custom Expander and Compactor Instance.</c></summary>
    constructor Create(const AComparer: IADComparer<T>; const AExpander: IADExpander; const ACompactor: IADCompactor; const AInitialCapacity: Integer = 0); reintroduce; overload; virtual;
    // Management Methods
    { IADSortedListReader<T> }
    function Contains(const AItem: T): Boolean;
    function ContainsAll(const AItems: Array of T): Boolean;
    function ContainsAny(const AItems: Array of T): Boolean;
    function ContainsNone(const AItems: Array of T): Boolean;
    function EqualItems(const AList: IADList<T>): Boolean;
    function IndexOf(const AItem: T): Integer;
    { IADSortedList<T> }
    procedure Remove(const AItem: T);
    procedure RemoveItems(const AItems: Array of T);
  end;

  ///  <summary><c>A Generic Fixed-Capacity Revolving List</c></summary>
  ///  <remarks>
  ///    <para><c>When the current Index is equal to the Capacity, the Index resets to 0, and Items are subsequently Replaced by new ones.</c></para>
  ///    <para><c>Use IADListReader for Read-Only List access.</c></para>
  ///    <para><c>Use IADList for Read/Write List access.</c></para>
  ///    <para><c>Use IADIterableList for Iterators.</c></para>
  ///    <para><c>Call .Iterator against IADListReader to return the IADIterableList interface reference.</c></para>
  ///    <para><c>Use IADCircularListReader for Read-Only Circular List access.</c></para>
  ///    <para><c>Use IADCircularList for Read/Write Circular List access.</c></para>  ///
  ///    <para><c>This type is NOT Threadsafe.</c></para>
  ///  </remarks>
  TADCircularList<T> = class(TADListBase<T>, IADCircularListReader<T>, IADCircularList<T>)
  private
    // Getters
  protected
    // Getters
    { IADCircularListReader<T> }
    function GetNewestIndex: Integer; virtual;
    function GetNewest: T; virtual;
    function GetOldestIndex: Integer; virtual;
    function GetOldest: T; virtual;
    { IADCircularList<T> }
    function GetReader: IADCircularListReader<T>;

    // Setters
    { TADListBase<T> Overrides }
    procedure SetItem(const AIndex: Integer; const AItem: T); override;
    { IADCircularListReader<T> }
    { IADCircularList<T> }

    // Overrides
    { TADListBase<T> }
    function AddActual(const AItem: T): Integer; override;
    procedure DeleteActual(const AIndex: Integer); override;
    procedure InsertActual(const AItem: T; const AIndex: Integer); override;
  public
    // Properties
    { IADCircularListReader<T> }
    property NewestIndex: Integer read GetNewestIndex;
    property Newest: T read GetNewest;
    property OldestIndex: Integer read GetOldestIndex;
    property Oldest: T read GetOldest;
    { IADCircularList<T> }
    property Reader: IADCircularListReader<T> read GetReader;
  end;

  ///  <summary><c>Abstract Base Type for all Generic Map Collection Types.</c></summary>
  ///  <remarks>
  ///    <para><c>Use IADMapReader for Read-Only access.</c></para>
  ///    <para><c>Use IADMap for Read/Write access.</c></para>
  ///    <para><c>Use IADIterableMap for Iterators.</c></para>
  ///    <para><c>Call .Iterator against IADMapReader to return the IADIterableMap interface reference.</c></para>
  ///  </remarks>
  TADMapBase<TKey, TValue> = class abstract(TADCollection, IADMapReader<TKey, TValue>, IADMap<TKey, TValue>, IADIterableMap<TKey, TValue>, IADCompactable, IADExpandable, IADComparable<TKey>)
  private
    FCompactor: IADCompactor;
    FComparer: IADComparer<TKey>;
    FExpander: IADExpander;
    FSorter: IADMapSorter<TKey, TValue>;
  protected
    FArray: IADArray<IADKeyValuePair<TKey, TValue>>;
    // Getters
    { IADMapReader<TKey, TValue> }
    function GetItem(const AKey: TKey): TValue;
    function GetIterator: IADIterableMap<TKey, TValue>;
    function GetPair(const AIndex: Integer): IADKeyValuePair<TKey, TValue>;
    function GetSorter: IADMapSorter<TKey, TValue>; virtual;
    { IADMap<TKey, TValue> }
    function GetReader: IADMapReader<TKey, TValue>;
    { IADIterableMap<TKey, TValue> }
    { IADCompactable }
    function GetCompactor: IADCompactor; virtual;
    { IADExpandable }
    function GetExpander: IADExpander; virtual;
    { IADComparable<T> }
    function GetComparer: IADComparer<TKey>; virtual;
    { IADComparable<T> }
    procedure SetComparer(const AComparer: IADComparer<TKey>); virtual;

    // Setters
    { IADMapReader<TKey, TValue> }
    { IADMap<TKey, TValue> }
    procedure SetItem(const AKey: TKey; const AValue: TValue);
    procedure SetSorter(const ASorter: IADMapSorter<TKey, TValue>); virtual;
    { IADIterableMap<TKey, TValue> }
    { IADCompactable }
    procedure SetCompactor(const ACompactor: IADCompactor); virtual;
    { IADExpandable }
    procedure SetExpander(const AExpander: IADExpander); virtual;

    // Overrides
    { TADCollection Overrides }
    function GetCapacity: Integer; override;
    function GetIsCompact: Boolean; override;
    procedure CreateArray(const AInitialCapacity: Integer = 0); override;
    procedure SetCapacity(const ACapacity: Integer); override;

    // Management Methods
    ///  <summary><c>Adds the Item to the correct Index of the Array WITHOUT checking capacity.</c></summary>
    ///  <returns>
    ///    <para>-1<c> if the Item CANNOT be added.</c></para>
    ///    <para>0 OR GREATER<c> if the Item has be added, where the Value represents the Index of the Item.</c></para>
    ///  </returns>
    function AddActual(const AItem: IADKeyValuePair<TKey, TValue>): Integer; virtual;
    ///  <summary><c>Compacts the Array according to the given Compactor Algorithm.</c></summary>
    procedure CheckCompact(const AAmount: Integer); virtual;
    ///  <summary><c>Expands the Array according to the given Expander Algorithm.</c></summary>
    procedure CheckExpand(const AAmount: Integer); virtual;
    ///  <summary><c>Determines the Index at which an Item would need to be Inserted for the List to remain in-order.</c></summary>
    ///  <remarks>
    ///    <para><c>This is basically a Binary Sort implementation.<c></para>
    ///  </remarks>
    function GetSortedPosition(const AKey: TKey): Integer; virtual;
    ///  <summary><c>Defines the default Sorter Type to use for managing the Map.</c></summary>
    procedure CreateSorter; virtual; abstract;

    constructor Create(const AInitialCapacity: Integer); override;
  public
    // Management Methods
    { IADMapReader<TKey, TValue> }
    function Contains(const AKey: TKey): Boolean;
    function ContainsAll(const AKeys: Array of TKey): Boolean;
    function ContainsAny(const AKeys: Array of TKey): Boolean;
    function ContainsNone(const AKeys: Array of TKey): Boolean;
    function EqualItems(const AMap: IADMapReader<TKey, TValue>): Boolean;
    function IndexOf(const AKey: TKey): Integer;
    { IADMap<TKey, TValue> }
    function Add(const AItem: IADKeyValuePair<TKey, TValue>): Integer; overload;
    function Add(const AKey: TKey; const AValue: TValue): Integer; overload;
    procedure AddItems(const AItems: Array of IADKeyValuePair<TKey, TValue>); overload;
    procedure AddItems(const AMap: IADMapReader<TKey, TValue>); overload;
    procedure Compact;
    procedure Delete(const AIndex: Integer); overload;
    procedure DeleteRange(const AFromIndex, ACount: Integer); overload;
    procedure Remove(const AKey: TKey);
    procedure RemoveItems(const AKeys: Array of TKey);
    { TADCollection Overrides }
    procedure Clear; override;

    { IADIterableMap<TKey, TValue> }
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

    // Properties
    { IADMapReader<TKey, TValue> }
    property Items[const AKey: TKey]: TValue read GetItem; default;
    property Iterator: IADIterableMap<TKey, TValue> read GetIterator;
    property Pairs[const AIndex: Integer]: IADKeyValuePair<TKey, TValue> read GetPair;
    { IADMap<TKey, TValue> }
    property Items[const AKey: TKey]: TValue read GetItem write SetItem; default;
    property Reader: IADMapReader<TKey, TValue> read GetReader;
    { IADIterableMap<TKey, TValue> }
    { IADCompactable }
    property Compactor: IADCompactor read GetCompactor write SetCompactor;
    { IADExpandable }
    property Expander: IADExpander read GetExpander write SetExpander;
    { IADComparable<T> }
    property Comparer: IADComparer<TKey> read GetComparer write SetComparer;
  end;

  ///  <summary><c>Generic Map Collection.</c></summary>
  ///  <remarks>
  ///    <para><c>Use IADMapReader for Read-Only access.</c></para>
  ///    <para><c>Use IADMap for Read/Write access.</c></para>
  ///    <para><c>Use IADIterableMap for Iterators.</c></para>
  ///    <para><c>Call .Iterator against IADMapReader to return the IADIterableMap interface reference.</c></para>
  ///  </remarks>
  TADMap<TKey, TValue> = class(TADMapBase<TKey, TValue>)
  protected
    // Overrides
    { TADMapBase<TKey, TValue> Override }
    procedure CreateSorter; override;
  public
    ///  <summary><c>Creates an instance of your Sorted List using the Default Expander and Compactor Types.</c></summary>
    constructor Create(const AComparer: IADComparer<TKey>; const AInitialCapacity: Integer = 0); reintroduce; overload;
    ///  <summary><c>Creates an instance of your Sorted List using a Custom Expander Instance, and the default Compactor Type.</c></summary>
    constructor Create(const AExpander: IADExpander; const AComparer: IADComparer<TKey>; const AInitialCapacity: Integer = 0); reintroduce; overload;
    ///  <summary><c>Creates an instance of your Sorted List using the default Expander Type, and a Custom Compactor Instance.</c></summary>
    constructor Create(const ACompactor: IADCompactor; const AComparer: IADComparer<TKey>; const AInitialCapacity: Integer = 0); reintroduce; overload;
    ///  <summary><c>Creates an instance of your Sorted List using a Custom Expander and Compactor Instance.</c></summary>
    constructor Create(const AExpander: IADExpander; const ACompactor: IADCompactor; const AComparer: IADComparer<TKey>; const AInitialCapacity: Integer = 0); reintroduce; overload; virtual;
  end;

  ///  <summary><c>Generic Tree Collection.</c></summary>
  ///  <remarks>
  ///    <para><c>Use IADTreeNodeReader for Read-Only access.</c></para>
  ///    <para><c>Use IADTreeNode for Read/Write access.</c></para>
  ///    <para><c>Iterators are defined in both IADTreeNodeReader and IADTreeNode Interfaces.</c></para>
  ///    <para><c>Call IADTreeNode.Reader to return an IADTreeNodeReader referenced Interface.</c></para>
  ///  </remarks>
  TADTreeNode<T> = class(TADCollection, IADTreeNodeReader<T>, IADTreeNode<T>)
  private
    FChildren: IADList<IADTreeNode<T>>;
    FChildrenReaders: IADList<IADTreeNodeReader<T>>;
    FParent: Pointer;
    FValue: T;
  protected
    // Geters
    { IADTreeNodeReader<T> }
    function GetChildCount: Integer;
    function GetChildCountRecursive: Integer;
    function GetChildrenReaders: IADListReader<IADTreeNodeReader<T>>;
    function GetDepth: Integer;
    function GetIndexAsChild: Integer;
    function GetIndexOf(const AChild: IADTreeNodeReader<T>): Integer;
    function GetIsBranch: Boolean;
    function GetIsLeaf: Boolean;
    function GetIsRoot: Boolean;
    function GetParentReader: IADTreeNodeReader<T>;
    function GetRootReader: IADTreeNodeReader<T>;
    function GetValue: T;
    { IADTreeNode<T> }
    function GetChildren: IADList<IADTreeNode<T>>;
    function GetParent: IADTreeNode<T>;
    function GetReader: IADTreeNodeReader<T>;
    function GetRoot: IADTreeNode<T>;

    // Setters
    { IADTreeNode<T> }
    procedure SetParent(const AParent: IADTreeNode<T>); virtual;
    procedure SetValue(const AValue: T); virtual;
  public
    // Iterators
    { IADTreeNodeReader<T> }
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure PreOrderWalk(const AAction: TADTreeNodeValueCallbackAnon<IADTreeNodeReader<T>>); overload;
      procedure PreOrderWalk(const AAction: TADTreeNodeValueCallbackAnon<T>); overload;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure PreOrderWalk(const AAction: TADTreeNodeValueCallbackOfObject<IADTreeNodeReader<T>>); overload;
    procedure PreOrderWalk(const AAction: TADTreeNodeValueCallbackOfObject<T>); overload;
    procedure PreOrderWalk(const AAction: TADTreeNodeValueCallbackUnbound<IADTreeNodeReader<T>>); overload;
    procedure PreOrderWalk(const AAction: TADTreeNodeValueCallbackUnbound<T>); overload;
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure PostOrderWalk(const AAction: TADTreeNodeValueCallbackAnon<IADTreeNodeReader<T>>); overload;
      procedure PostOrderWalk(const AAction: TADTreeNodeValueCallbackAnon<T>); overload;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure PostOrderWalk(const AAction: TADTreeNodeValueCallbackOfObject<IADTreeNodeReader<T>>); overload;
    procedure PostOrderWalk(const AAction: TADTreeNodeValueCallbackOfObject<T>); overload;
    procedure PostOrderWalk(const AAction: TADTreeNodeValueCallbackUnbound<IADTreeNodeReader<T>>); overload;
    procedure PostOrderWalk(const AAction: TADTreeNodeValueCallbackUnbound<T>); overload;
    { IADTreeNode<T> }
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure PreOrderWalk(const AAction: TADTreeNodeValueCallbackAnon<IADTreeNode<T>>); overload;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure PreOrderWalk(const AAction: TADTreeNodeValueCallbackOfObject<IADTreeNode<T>>); overload;
    procedure PreOrderWalk(const AAction: TADTreeNodeValueCallbackUnbound<IADTreeNode<T>>); overload;
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure PostOrderWalk(const AAction: TADTreeNodeValueCallbackAnon<IADTreeNode<T>>); overload;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure PostOrderWalk(const AAction: TADTreeNodeValueCallbackOfObject<IADTreeNode<T>>); overload;
    procedure PostOrderWalk(const AAction: TADTreeNodeValueCallbackUnbound<IADTreeNode<T>>); overload;

    // Management Methods
    procedure AddChild(const AChild: IADTreeNode<T>; const AIndex: Integer = -1);
    procedure MoveTo(const ANewParent: IADTreeNode<T>; const AIndex: Integer = -1); overload;
    procedure MoveTo(const AIndex: Integer); overload;
    procedure RemoveChild(const AChild: IADTreeNode<T>);

    // Properties
    { IADTreeNodeReader<T> }
    property ChildCount: Integer read GetChildCount;
    property ChildCountRecursive: Integer read GetChildCountRecursive;
    property ChildrenReaders: IADListReader<IADTreeNodeReader<T>> read GetChildrenReaders;
    property Depth: Integer read GetDepth;
    property IndexAsChild: Integer read GetIndexAsChild;
    property IndexOf[const AChild: IADTreeNodeReader<T>]: Integer read GetIndexOf;
    property IsBranch: Boolean read GetIsBranch;
    property IsLeaf: Boolean read GetIsLeaf;
    property IsRoot: Boolean read GetIsRoot;
    property ParentReader: IADTreeNodeReader<T> read GetParentReader;
    property RootReader: IADTreeNodeReader<T> read GetRootReader;
    { IADTreeNode<T> }
    property Children: IADList<IADTreeNode<T>> read GetChildren;
    property Parent: IADTreeNode<T> read GetParent;
    property Root: IADTreeNode<T> read GetRoot;
    property Value: T read GetValue write SetValue;
  end;

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

// Allocators
function ADCollectionExpanderDefault: IADExpander;
function ADCollectionExpanderGeometric: IADExpanderGeometric;
function ADCollectionCompactorDefault: IADCompactor;

implementation

uses
  ADAPT.Comparers;

type
  ///  <summary><c>The Default Allocation Algorithm for Lists.</c></summary>
  ///  <remarks><c>By default, the Array will grow by 1 each time it becomes full</c></remarks>
  TADExpanderDefault = class(TADExpander)
  public
    function CheckExpand(const ACapacity, ACurrentCount, AAdditionalRequired: Integer): Integer; override;
  end;

  ///  <summary><c>The Default Deallocation Algorithm for Lists.</c></summary>
  ///  <remarks><c>By default, the Array will shrink by 1 each time an Item is removed.</c></remarks>
  TADCompactorDefault = class(TADCompactor)
  public
    function CheckCompact(const ACapacity, ACurrentCount, AVacating: Integer): Integer; override;
  end;

var
  GCollectionExpanderDefault: IADExpander;
  GCollectionCompactorDefault: IADCompactor;

function ADCollectionExpanderDefault: IADExpander;
begin
  Result := GCollectionExpanderDefault;
end;

function ADCollectionExpanderGeometric: IADExpanderGeometric;
begin
  Result := TADExpanderGeometric.Create;
end;

function ADCollectionCompactorDefault: IADCompactor;
begin
  Result := GCollectionCompactorDefault;
end;

{ TADExpanderDefault }

function TADExpanderDefault.CheckExpand(const ACapacity, ACurrentCount, AAdditionalRequired: Integer): Integer;
begin
  if ACurrentCount + AAdditionalRequired > ACapacity then
    Result := (ACapacity - ACurrentCount) + AAdditionalRequired
  else
    Result := 0;
end;

{ TADCompactorDefault }

function TADCompactorDefault.CheckCompact(const ACapacity, ACurrentCount, AVacating: Integer): Integer;
begin
  Result := AVacating;
end;

{ TADArray<T> }

procedure TADArray<T>.Clear;
begin
  SetLength(FArray, FCapacityInitial);
  if FCapacityInitial > 0 then
    Finalize(0, FCapacityInitial);
end;

procedure TADArray<T>.Delete(const AIndex: Integer);
var
  I: Integer;
begin
  FArray[AIndex] := nil;
//  System.FillChar(FArray[AIndex], SizeOf(IADValueHolder<T>), 0);
  if AIndex < Length(FArray) - 1 then
  begin
//    System.Move(FArray[AIndex + 1],
//                FArray[AIndex],
//                ((Length(FArray) - 1) - AIndex) * SizeOf(IADValueHolder<T>));
    for I := AIndex to Length(FArray) - 2 do
      FArray[I] := FArray[I + 1];
  end;
  //TODO -oSJS -cGeneric Collections: Figure out why block Finalize/Move/Reallocation isn't working properly.
end;

constructor TADArray<T>.Create(const ACapacity: Integer);
begin
  inherited Create;
  FCapacityInitial := ACapacity;
  SetLength(FArray, ACapacity);
end;

procedure TADArray<T>.Delete(const AFirstIndex, ACount: Integer);
var
  I: Integer;
begin
  for I := AFirstIndex + (ACount - 1) downto AFirstIndex do
    Delete(I);
end;

destructor TADArray<T>.Destroy;
begin

  inherited;
end;

procedure TADArray<T>.Finalize(const AIndex, ACount: Integer);
begin
  System.Finalize(FArray[AIndex], ACount);
  System.FillChar(FArray[AIndex], ACount * SizeOf(T), 0);
end;

function TADArray<T>.GetCapacity: Integer;
begin
  Result := Length(FArray);
end;

function TADArray<T>.GetItem(const AIndex: Integer): T;
begin
  if (AIndex < Low(FArray)) or (AIndex > High(FArray)) then
    raise EADGenericsRangeException.CreateFmt('Index [%d] Out Of Range', [AIndex]);
  Result := FArray[AIndex].Value;
end;

function TADArray<T>.GetReader: IADArrayReader<T>;
begin
  Result := IADArrayReader<T>(Self);
end;

procedure TADArray<T>.Insert(const AItem: T; const AIndex: Integer);
begin
  Move(AIndex, AIndex + 1, (Capacity - AIndex) - 1);
  Finalize(AIndex, 1);
  FArray[AIndex] := TADValueHolder<T>.Create(AItem);
end;

procedure TADArray<T>.Move(const AFromIndex, AToIndex, ACount: Integer);
var
  LItem: T;
  I: Integer;
begin
  if AFromIndex < AToIndex then
  begin
    for I := AFromIndex + ACount downto AFromIndex + 1 do
      FArray[I] := FArray[I - (AToIndex - AFromIndex)];
  end else
    System.Move(FArray[AFromIndex], FArray[AToIndex], ACount * SizeOf(T));
end;

procedure TADArray<T>.SetCapacity(const ACapacity: Integer);
begin
  SetLength(FArray, ACapacity);
end;

procedure TADArray<T>.SetItem(const AIndex: Integer; const AItem: T);
begin
  FArray[AIndex] := TADValueHolder<T>.Create(AItem);
end;

{ TADExpanderGeometric }

function TADExpanderGeometric.CheckExpand(const ACapacity, ACurrentCount, AAdditionalRequired: Integer): Integer;
begin
  if (AAdditionalRequired < FThreshold) then
  begin
    if (Round(ACapacity * FMultiplier)) > (FMultiplier + FThreshold) then
      Result :=  Round(ACapacity * FMultiplier)
    else
      Result := ACapacity + AAdditionalRequired + FThreshold; // Expand to ensure everything fits
  end else
    Result := 0;
end;

function TADExpanderGeometric.GetCapacityMultiplier: Single;
begin
  Result := FMultiplier;
end;

function TADExpanderGeometric.GetCapacityThreshold: Integer;
begin
  Result := FThreshold;
end;

procedure TADExpanderGeometric.SetCapacityMultiplier(const AMultiplier: Single);
begin
  FMultiplier := AMultiplier;
end;

procedure TADExpanderGeometric.SetCapacityThreshold(const AThreshold: Integer);
begin
  FThreshold := AThreshold;
end;

{ TADCollection }

constructor TADCollection.Create(const AInitialCapacity: Integer);
begin
  inherited Create;
  FSortedState := ssUnknown;
  FCount := 0;
  FInitialCapacity := AInitialCapacity;
  CreateArray(AInitialCapacity);
end;

function TADCollection.GetCount: Integer;
begin
  Result := FCount;
end;

function TADCollection.GetInitialCapacity: Integer;
begin
  Result := FInitialCapacity;
end;

function TADCollection.GetIsEmpty: Boolean;
begin
  Result := (FCount = 0);
end;

function TADCollection.GetReader: IADCollectionReader;
begin
  Result := IADCollectionReader(Self);
end;

function TADCollection.GetSortedState: TADSortedState;
begin
  Result := FSortedState;
end;

{ TADListBase<T> }

function TADListBase<T>.Add(const AItem: T): Integer;
begin
  Result := AddActual(AItem);
end;

procedure TADListBase<T>.Add(const AItems: IADListReader<T>);
var
  I: Integer;
begin
  for I := 0 to AItems.Count - 1 do
    AddActual(AItems[I]);
end;

procedure TADListBase<T>.AddItems(const AItems: array of T);
var
  I: Integer;
begin
  for I := Low(AItems) to High(AItems) do
    AddActual(AItems[I]);
end;

procedure TADListBase<T>.Clear;
begin
  FArray.Clear;
  FCount := 0;
end;

constructor TADListBase<T>.Create(const AInitialCapacity: Integer);
begin
  inherited;
  FSorter := TADListSorterQuick<T>.Create; // Use the Quick Sorter by default.
end;

procedure TADListBase<T>.CreateArray(const AInitialCapacity: Integer);
begin
  FArray := TADArray<T>.Create(AInitialCapacity);
end;

procedure TADListBase<T>.Delete(const AIndex: Integer);
begin
  DeleteActual(AIndex);
end;

procedure TADListBase<T>.DeleteRange(const AFirst, ACount: Integer);
var
  I: Integer;
begin
  for I := AFirst + (ACount - 1) downto AFirst do
    DeleteActual(I);
end;

function TADListBase<T>.GetCapacity: Integer;
begin
  Result := FArray.Capacity;
end;

function TADListBase<T>.GetIsCompact: Boolean;
begin
  Result := (FArray.Capacity = FCount);
end;

function TADListBase<T>.GetItem(const AIndex: Integer): T;
begin
  Result := FArray[AIndex];
end;

function TADListBase<T>.GetIterator: IADIterableList<T>;
begin
  Result := IADIterableList<T>(Self);
end;

function TADListBase<T>.GetReader: IADListReader<T>;
begin
  Result := IADListReader<T>(Self);
end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADListBase<T>.Iterate(const ACallback: TADListItemCallbackAnon<T>; const ADirection: TADIterateDirection = idRight);
  begin
    case ADirection of
      idLeft: IterateBackward(ACallback);
      idRight: IterateForward(ACallback);
      else
        raise EADGenericsIterateDirectionUnknownException.Create('Unhandled Iterate Direction given.');
    end;
  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADListBase<T>.Iterate(const ACallback: TADListItemCallbackOfObject<T>; const ADirection: TADIterateDirection);
begin
    case ADirection of
      idLeft: IterateBackward(ACallback);
      idRight: IterateForward(ACallback);
      else
        raise EADGenericsIterateDirectionUnknownException.Create('Unhandled Iterate Direction given.');
    end;
end;

procedure TADListBase<T>.Insert(const AItem: T; const AIndex: Integer);
begin
  InsertActual(AItem, AIndex);
end;

procedure TADListBase<T>.InsertItems(const AItems: array of T; const AIndex: Integer);
var
  I: Integer;
begin
  for I := High(AItems) downto Low(AItems) do
    Insert(AItems[I], AIndex);
end;

procedure TADListBase<T>.Iterate(const ACallback: TADListItemCallbackUnbound<T>; const ADirection: TADIterateDirection);
begin
    case ADirection of
      idLeft: IterateBackward(ACallback);
      idRight: IterateForward(ACallback);
      else
        raise EADGenericsIterateDirectionUnknownException.Create('Unhandled Iterate Direction given.');
    end;
end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADListBase<T>.IterateBackward(const ACallback: TADListItemCallbackAnon<T>);
  var
    I: Integer;
  begin
    for I := FCount - 1 downto 0 do
      ACallback(FArray[I]);
  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADListBase<T>.IterateBackward(const ACallback: TADListItemCallbackOfObject<T>);
  var
    I: Integer;
  begin
    for I := FCount - 1 downto 0 do
      ACallback(FArray[I]);
end;

procedure TADListBase<T>.IterateBackward(const ACallback: TADListItemCallbackUnbound<T>);
  var
    I: Integer;
  begin
    for I := FCount - 1 downto 0 do
      ACallback(FArray[I]);
end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
procedure TADListBase<T>.IterateForward(const ACallback: TADListItemCallbackAnon<T>);
  var
    I: Integer;
  begin
    for I := 0 to FCount - 1 do
      ACallback(FArray[I]);
end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADListBase<T>.IterateForward(const ACallback: TADListItemCallbackOfObject<T>);
  var
    I: Integer;
  begin
    for I := 0 to FCount - 1 do
      ACallback(FArray[I]);
end;

procedure TADListBase<T>.IterateForward(const ACallback: TADListItemCallbackUnbound<T>);
  var
    I: Integer;
  begin
    for I := 0 to FCount - 1 do
      ACallback(FArray[I]);
end;

procedure TADListBase<T>.SetCapacity(const ACapacity: Integer);
begin
  if ACapacity < FCount then
    raise EADGenericsCapacityLessThanCount.CreateFmt('Given Capacity of %d insufficient for a Collection containing %d Items.', [ACapacity, FCount])
  else
    FArray.Capacity := ACapacity;
end;

procedure TADListBase<T>.Sort(const ASorter: IADListSorter<T>; const AComparer: IADComparer<T>);
begin
  SortRange(ASorter, AComparer, 0, FCount - 1);
end;

procedure TADListBase<T>.SortRange(const AComparer: IADComparer<T>; const AFromIndex, AToIndex: Integer);
begin
  SortRange(FSorter, AComparer, AFromIndex, AToIndex);
end;

procedure TADListBase<T>.Sort(const AComparer: IADComparer<T>);
begin
  SortRange(FSorter, AComparer, 0, FCount - 1);
end;

procedure TADListBase<T>.SortRange(const ASorter: IADListSorter<T>; const AComparer: IADComparer<T>; const AFromIndex, AToIndex: Integer);
begin
  ASorter.Sort(FArray, AComparer, AFromIndex, AToIndex);
end;

{ TADListExpandableBase<T> }

procedure TADListExpandableBase<T>.CheckCompact(const AAmount: Integer);
var
  LShrinkBy: Integer;
begin
  LShrinkBy := Compactor.CheckCompact(FArray.Capacity, FCount, AAmount);
  if LShrinkBy > 0 then
    FArray.Capacity := FArray.Capacity - LShrinkBy;
end;

procedure TADListExpandableBase<T>.CheckExpand(const AAmount: Integer);
var
  LNewCapacity: Integer;
begin
  LNewCapacity := Expander.CheckExpand(FArray.Capacity, FCount, AAmount);
  if LNewCapacity > 0 then
    FArray.Capacity := FArray.Capacity + LNewCapacity;
end;

procedure TADListExpandableBase<T>.Compact;
begin
  FArray.Capacity := FCount;
end;

function TADListExpandableBase<T>.GetCompactor: IADCompactor;
begin
  Result := FCompactor;
end;

function TADListExpandableBase<T>.GetExpander: IADExpander;
begin
  Result := FExpander;
end;

procedure TADListExpandableBase<T>.SetCompactor(const ACompactor: IADCompactor);
begin
  FCompactor := ACompactor;
end;

procedure TADListExpandableBase<T>.SetExpander(const AExpander: IADExpander);
begin
  FExpander := AExpander;
end;

{ TADList<T> }

function TADList<T>.AddActual(const AItem: T): Integer;
begin
  CheckExpand(1);
  FArray[FCount] := AItem;
  Result := FCount;
  Inc(FCount);
  FSortedState := ssUnsorted;
end;

constructor TADList<T>.Create(const AExpander: IADExpander; const AInitialCapacity: Integer);
begin
  Create(AExpander, ADCollectionCompactorDefault, AInitialCapacity);
end;

constructor TADList<T>.Create(const AInitialCapacity: Integer);
begin
  Create(ADCollectionExpanderDefault, ADCollectionCompactorDefault, AInitialCapacity);
end;

constructor TADList<T>.Create(const AExpander: IADExpander; const ACompactor: IADCompactor; const AInitialCapacity: Integer);
begin
  inherited Create(AInitialCapacity);
  FExpander := AExpander;
  FCompactor := ACompactor;
end;

constructor TADList<T>.Create(const ACompactor: IADCompactor; const AInitialCapacity: Integer);
begin
  Create(ADCollectionExpanderDefault, ACompactor, AInitialCapacity);
end;

procedure TADList<T>.DeleteActual(const AIndex: Integer);
begin
  FArray.Delete(AIndex);
  Dec(FCount);
  CheckCompact(1);
end;

procedure TADList<T>.InsertActual(const AItem: T; const AIndex: Integer);
begin
  CheckExpand(1);
  FArray.Insert(AItem, AIndex);
  Inc(FCount);
  FSortedState := ssUnsorted;
end;

procedure TADList<T>.SetItem(const AIndex: Integer; const AItem: T);
begin
  FArray[AIndex] := AItem;
end;

{ TADSortedList<T> }

function TADSortedList<T>.AddActual(const AItem: T): Integer;
begin
  CheckExpand(1);
  Result := GetSortedPosition(AItem);
  if Result = FCount then
    FArray[FCount] := AItem
  else
    FArray.Insert(AItem, Result);

  Inc(FCount);
end;

function TADSortedList<T>.Contains(const AItem: T): Boolean;
begin
  Result := (IndexOf(AItem) > -1);
end;

function TADSortedList<T>.ContainsAll(const AItems: array of T): Boolean;
var
  I: Integer;
begin
  Result := True; // Optimistic
  for I := Low(AItems) to High(AItems) do
    if (not Contains(AItems[I])) then
    begin
      Result := False;
      Break;
    end;
end;

function TADSortedList<T>.ContainsAny(const AItems: array of T): Boolean;
var
  I: Integer;
begin
  Result := False; // Pessimistic
  for I := Low(AItems) to High(AItems) do
    if Contains(AItems[I]) then
    begin
      Result := True;
      Break;
    end;
end;

function TADSortedList<T>.ContainsNone(const AItems: array of T): Boolean;
begin
  Result := (not ContainsAny(AItems));
end;

constructor TADSortedList<T>.Create(const AComparer: IADComparer<T>; const AExpander: IADExpander; const AInitialCapacity: Integer);
begin
  Create(AComparer, AExpander, ADCollectionCompactorDefault, AInitialCapacity);
end;

constructor TADSortedList<T>.Create(const AComparer: IADComparer<T>; const AInitialCapacity: Integer);
begin
  Create(AComparer, ADCollectionExpanderDefault, ADCollectionCompactorDefault, AInitialCapacity);
end;

constructor TADSortedList<T>.Create(const AComparer: IADComparer<T>; const AExpander: IADExpander; const ACompactor: IADCompactor; const AInitialCapacity: Integer);
begin
  inherited Create(AInitialCapacity);
  FComparer := AComparer;
  FExpander := AExpander;
  FCompactor := ACompactor;
end;

constructor TADSortedList<T>.Create(const AComparer: IADComparer<T>; const ACompactor: IADCompactor; const AInitialCapacity: Integer);
begin
  Create(AComparer, ADCollectionExpanderDefault, ACompactor, AInitialCapacity);
end;

procedure TADSortedList<T>.DeleteActual(const AIndex: Integer);
begin
  FArray.Delete(AIndex);
  Dec(FCount);
  CheckCompact(1);
end;

function TADSortedList<T>.EqualItems(const AList: IADList<T>): Boolean;
var
  I: Integer;
begin
  Result := AList.Count = FCount;
  if Result then
    for I := 0 to AList.Count - 1 do
      if (not FComparer.AEqualToB(AList[I], FArray[I])) then
      begin
        Result := False;
        Break;
      end;
end;

function TADSortedList<T>.GetComparer: IADComparer<T>;
begin
  Result := FComparer;
end;

function TADSortedList<T>.GetReader: IADSortedListReader<T>;
begin
  Result := Self as IADSortedListReader<T>;
end;

function TADSortedList<T>.GetSortedPosition(const AItem: T): Integer;
var
  LIndex, LLow, LHigh: Integer;
begin
  Result := 0;
  LLow := 0;
  LHigh := FCount - 1;
  if LHigh = -1 then
    Exit;
  if LLow < LHigh then
  begin
    while (LHigh - LLow > 1) do
    begin
      LIndex := (LHigh + LLow) div 2;
      if FComparer.ALessThanOrEqualToB(AItem, FArray[LIndex]) then
        LHigh := LIndex
      else
        LLow := LIndex;
    end;
  end;
  if FComparer.ALessThanB(FArray[LHigh], AItem) then
    Result := LHigh + 1
  else if FComparer.ALessThanB(FArray[LLow], AItem) then
    Result := LLow + 1
  else
    Result := LLow;
end;

function TADSortedList<T>.GetSortedState: TADSortedState;
begin
  Result := TADSortedState.ssSorted;
end;

procedure TADSortedList<T>.Remove(const AItem: T);
var
  LIndex: Integer;
begin
  LIndex := IndexOf(AItem);
  if LIndex > -1 then
    Delete(LIndex);
end;

procedure TADSortedList<T>.RemoveItems(const AItems: array of T);
var
  I: Integer;
begin
  for I := Low(AItems) to High(AItems) do
    Remove(AItems[I]);
end;

procedure TADSortedList<T>.SetComparer(const AComparer: IADComparer<T>);
begin
  FComparer := AComparer;
end;

procedure TADSortedList<T>.SetItem(const AIndex: Integer; const AItem: T);
begin
  DeleteActual(AIndex);
  AddActual(AItem);
end;

function TADSortedList<T>.IndexOf(const AItem: T): Integer;
var
  LLow, LHigh, LMid: Integer;
begin
  Result := -1; // Pessimistic
  LLow := 0;
  LHigh := FCount - 1;
  repeat
    LMid := (LLow + LHigh) div 2;
    if FComparer.AEqualToB(FArray[LMid], AItem) then
    begin
      Result := LMid;
      Break;
    end
    else if FComparer.ALessThanB(AItem, FArray[LMid]) then
      LHigh := LMid - 1
    else
      LLow := LMid + 1;
  until LHigh < LLow;
end;

procedure TADSortedList<T>.InsertActual(const AItem: T; const AIndex: Integer);
begin
  AddActual(AItem);
end;

{ TADCircularList<T> }

function TADCircularList<T>.AddActual(const AItem: T): Integer;
begin
  if FCount < FArray.Capacity then
    Inc(FCount)
  else
    FArray.Delete(0);

  Result := FCount - 1;

  FArray[Result] := AItem; // Assign the Item to the Array at the Index.
end;

procedure TADCircularList<T>.DeleteActual(const AIndex: Integer);
begin
  FArray.Delete(AIndex);
end;

function TADCircularList<T>.GetNewest: T;
begin
  if FCount > 0 then
    Result := FArray[FCount - 1];
end;

function TADCircularList<T>.GetNewestIndex: Integer;
begin
  Result := FCount - 1;
end;

function TADCircularList<T>.GetOldest: T;
begin
  if FCount > 0 then
    Result := FArray[0];
end;

function TADCircularList<T>.GetOldestIndex: Integer;
begin
  if FCount = 0 then
    Result := -1
  else
    Result := 0;
end;

function TADCircularList<T>.GetReader: IADCircularListReader<T>;
begin
  Result := IADCircularListReader<T>(Self);
end;

procedure TADCircularList<T>.InsertActual(const AItem: T; const AIndex: Integer);
begin
  if FCount < FArray.Capacity then
  begin
    FArray.Insert(AItem, AIndex);
    Inc(FCount);
  end else
  begin
    FArray.Delete(0);
    FArray.Insert(AItem, AIndex);
  end;
end;

procedure TADCircularList<T>.SetItem(const AIndex: Integer; const AItem: T);
begin
  FArray[AIndex] := AItem;
end;

{ TADMapBase<TKey, TValue> }

function TADMapBase<TKey, TValue>.Add(const AKey: TKey; const AValue: TValue): Integer;
var
  LPair: IADKeyValuePair<TKey, TValue>;
begin
  LPair := TADKeyValuePair<TKey, TValue>.Create(AKey, AValue);
  Result := Add(LPair);
end;

function TADMapBase<TKey, TValue>.AddActual(const AItem: IADKeyValuePair<TKey, TValue>): Integer;
begin
  Result := GetSortedPosition(AItem.Key);
  if Result = FCount then
    FArray[FCount] := AItem
  else
    FArray.Insert(AItem, Result);

  Inc(FCount);
end;

function TADMapBase<TKey, TValue>.Add(const AItem: IADKeyValuePair<TKey, TValue>): Integer;
begin
  CheckExpand(1);
  Result := AddActual(AItem);
end;

procedure TADMapBase<TKey, TValue>.AddItems(const AItems: array of IADKeyValuePair<TKey, TValue>);
var
  I: Integer;
begin
  CheckExpand(Length(AItems));
  for I := Low(AItems) to High(AItems) do
    AddActual(AItems[I]);
end;

procedure TADMapBase<TKey, TValue>.AddItems(const AMap: IADMapReader<TKey, TValue>);
var
  I: Integer;
begin
  CheckExpand(AMap.Count);
  for I := 0 to AMap.Count - 1 do
    AddActual(AMap.Pairs[I]);
end;

procedure TADMapBase<TKey, TValue>.CheckCompact(const AAmount: Integer);
var
  LShrinkBy: Integer;
begin
  LShrinkBy := FCompactor.CheckCompact(FArray.Capacity, FCount, AAmount);
  if LShrinkBy > 0 then
    FArray.Capacity := FArray.Capacity - LShrinkBy;
end;

procedure TADMapBase<TKey, TValue>.CheckExpand(const AAmount: Integer);
var
  LNewCapacity: Integer;
begin
  LNewCapacity := FExpander.CheckExpand(FArray.Capacity, FCount, AAmount);
  if LNewCapacity > 0 then
    FArray.Capacity := FArray.Capacity + LNewCapacity;
end;

procedure TADMapBase<TKey, TValue>.Clear;
begin
  FArray.Clear;
  FArray.Capacity := FInitialCapacity;
  FCount := 0;
end;

procedure TADMapBase<TKey, TValue>.Compact;
begin
  FArray.Capacity := FCount;
end;

function TADMapBase<TKey, TValue>.Contains(const AKey: TKey): Boolean;
begin
  Result := (IndexOf(AKey) > -1);
end;

function TADMapBase<TKey, TValue>.ContainsAll(const AKeys: array of TKey): Boolean;
var
  I: Integer;
begin
  Result := True; // Optimistic
  for I := Low(AKeys) to High(AKeys) do
    if (not Contains(AKeys[I])) then
    begin
      Result := False;
      Break;
    end;
end;

function TADMapBase<TKey, TValue>.ContainsAny(const AKeys: array of TKey): Boolean;
var
  I: Integer;
begin
  Result := False; // Pessimistic
  for I := Low(AKeys) to High(AKeys) do
    if Contains(AKeys[I]) then
    begin
      Result := True;
      Break;
    end;
end;

function TADMapBase<TKey, TValue>.ContainsNone(const AKeys: array of TKey): Boolean;
begin
  Result := (not ContainsAny(AKeys));
end;

constructor TADMapBase<TKey, TValue>.Create(const AInitialCapacity: Integer);
begin
  inherited;
  CreateSorter;
end;

procedure TADMapBase<TKey, TValue>.CreateArray(const AInitialCapacity: Integer);
begin
  FArray := TADArray<IADKeyValuePair<TKey, TValue>>.Create(AInitialCapacity);
end;

procedure TADMapBase<TKey, TValue>.Delete(const AIndex: Integer);
begin
  FArray.Delete(AIndex);
  Dec(FCount);
end;

procedure TADMapBase<TKey, TValue>.DeleteRange(const AFromIndex, ACount: Integer);
var
  I: Integer;
begin
  for I := AFromIndex + ACount - 1 downto AFromIndex do
    Delete(I);
end;

function TADMapBase<TKey, TValue>.EqualItems(const AMap: IADMapReader<TKey, TValue>): Boolean;
var
  I: Integer;
begin
  Result := AMap.Count = FCount;
  if Result then
    for I := 0 to AMap.Count - 1 do
      if (not FComparer.AEqualToB(AMap.Pairs[I].Key, FArray[I].Key)) then
      begin
        Result := False;
        Break;
      end;
end;

function TADMapBase<TKey, TValue>.GetCapacity: Integer;
begin
  Result := FArray.Capacity;
end;

function TADMapBase<TKey, TValue>.GetCompactor: IADCompactor;
begin
  Result := FCompactor;
end;

function TADMapBase<TKey, TValue>.GetComparer: IADComparer<TKey>;
begin
  Result := FComparer;
end;

function TADMapBase<TKey, TValue>.GetExpander: IADExpander;
begin
  Result := FExpander;
end;

function TADMapBase<TKey, TValue>.GetIsCompact: Boolean;
begin
  Result := (FArray.Capacity = FCount);
end;

function TADMapBase<TKey, TValue>.GetItem(const AKey: TKey): TValue;
var
  LIndex: Integer;
begin
  LIndex := IndexOf(AKey);
  if LIndex > -1 then
    Result := FArray[LIndex].Value;
end;

function TADMapBase<TKey, TValue>.GetIterator: IADIterableMap<TKey, TValue>;
begin
  Result := IADIterableMap<TKey, TValue>(Self);
end;

function TADMapBase<TKey, TValue>.GetPair(const AIndex: Integer): IADKeyValuePair<TKey, TValue>;
begin
  Result := FArray[AIndex];
end;

function TADMapBase<TKey, TValue>.GetReader: IADMapReader<TKey, TValue>;
begin
  Result := IADMapReader<TKey, TValue>(Self);
end;

function TADMapBase<TKey, TValue>.GetSortedPosition(const AKey: TKey): Integer;
var
  LIndex, LLow, LHigh: Integer;
begin
  Result := 0;
  LLow := 0;
  LHigh := FCount - 1;
  if LHigh = -1 then
    Exit;
  if LLow < LHigh then
  begin
    while (LHigh - LLow > 1) do
    begin
      LIndex := (LHigh + LLow) div 2;
      if FComparer.ALessThanOrEqualToB(AKey, FArray[LIndex].Key) then
        LHigh := LIndex
      else
        LLow := LIndex;
    end;
  end;
  if FComparer.ALessThanB(FArray[LHigh].Key, AKey) then
    Result := LHigh + 1
  else if FComparer.ALessThanB(FArray[LLow].Key, AKey) then
    Result := LLow + 1
  else
    Result := LLow;
end;

function TADMapBase<TKey, TValue>.GetSorter: IADMapSorter<TKey, TValue>;
begin
  Result := FSorter;
end;

function TADMapBase<TKey, TValue>.IndexOf(const AKey: TKey): Integer;
var
  LLow, LHigh, LMid: Integer;
begin
  Result := -1; // Pessimistic
  LLow := 0;
  LHigh := FCount - 1;
  repeat
    LMid := (LLow + LHigh) div 2;
    if FComparer.AEqualToB(FArray[LMid].Key, AKey) then
    begin
      Result := LMid;
      Break;
    end
    else if FComparer.ALessThanB(AKey, FArray[LMid].Key) then
      LHigh := LMid - 1
    else
      LLow := LMid + 1;
  until LHigh < LLow;
end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADMapBase<TKey, TValue>.Iterate(const ACallback: TADListMapCallbackAnon<TKey, TValue>; const ADirection: TADIterateDirection = idRight);
  begin
    case ADirection of
      idLeft: IterateBackward(ACallback);
      idRight: IterateForward(ACallback);
      else
        raise EADGenericsIterateDirectionUnknownException.Create('Unhandled Iterate Direction given.');
    end;
  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADMapBase<TKey, TValue>.Iterate(const ACallback: TADListMapCallbackUnbound<TKey, TValue>; const ADirection: TADIterateDirection);
begin
  case ADirection of
    idLeft: IterateBackward(ACallback);
    idRight: IterateForward(ACallback);
    else
      raise EADGenericsIterateDirectionUnknownException.Create('Unhandled Iterate Direction given.');
  end;
end;

procedure TADMapBase<TKey, TValue>.Iterate(const ACallback: TADListMapCallbackOfObject<TKey, TValue>; const ADirection: TADIterateDirection);
begin
  case ADirection of
    idLeft: IterateBackward(ACallback);
    idRight: IterateForward(ACallback);
    else
      raise EADGenericsIterateDirectionUnknownException.Create('Unhandled Iterate Direction given.');
  end;
end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADMapBase<TKey, TValue>.IterateBackward(const ACallback: TADListMapCallbackAnon<TKey, TValue>);
  var
    I: Integer;
  begin
    for I := FCount - 1 downto 0 do
      ACallback(FArray[I].Key, FArray[I].Value);
  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADMapBase<TKey, TValue>.IterateBackward(const ACallback: TADListMapCallbackUnbound<TKey, TValue>);
var
  I: Integer;
begin
  for I := FCount - 1 downto 0 do
    ACallback(FArray[I].Key, FArray[I].Value);
end;

procedure TADMapBase<TKey, TValue>.IterateBackward(const ACallback: TADListMapCallbackOfObject<TKey, TValue>);
var
  I: Integer;
begin
  for I := FCount - 1 downto 0 do
    ACallback(FArray[I].Key, FArray[I].Value);
end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADMapBase<TKey, TValue>.IterateForward(const ACallback: TADListMapCallbackAnon<TKey, TValue>);
  var
    I: Integer;
  begin
    for I := 0 to FCount - 1 do
      ACallback(FArray[I].Key, FArray[I].Value);
  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADMapBase<TKey, TValue>.IterateForward(const ACallback: TADListMapCallbackUnbound<TKey, TValue>);
var
  I: Integer;
begin
  for I := 0 to FCount - 1 do
    ACallback(FArray[I].Key, FArray[I].Value);
end;

procedure TADMapBase<TKey, TValue>.IterateForward(const ACallback: TADListMapCallbackOfObject<TKey, TValue>);
var
  I: Integer;
begin
  for I := 0 to FCount - 1 do
    ACallback(FArray[I].Key, FArray[I].Value);
end;

procedure TADMapBase<TKey, TValue>.Remove(const AKey: TKey);
var
  LIndex: Integer;
begin
  LIndex := IndexOf(AKey);
  if LIndex > -1 then
    Delete(LIndex);
end;

procedure TADMapBase<TKey, TValue>.RemoveItems(const AKeys: array of TKey);
var
  I: Integer;
begin
  for I := Low(AKeys) to High(AKeys) do
    Remove(AKeys[I]);
end;

procedure TADMapBase<TKey, TValue>.SetCapacity(const ACapacity: Integer);
begin
  FArray.Capacity := ACapacity;
end;

procedure TADMapBase<TKey, TValue>.SetCompactor(const ACompactor: IADCompactor);
begin
  FCompactor := ACompactor;
end;

procedure TADMapBase<TKey, TValue>.SetComparer(const AComparer: IADComparer<TKey>);
begin
  FComparer := AComparer;
end;

procedure TADMapBase<TKey, TValue>.SetExpander(const AExpander: IADExpander);
begin
  FExpander := AExpander;
end;

procedure TADMapBase<TKey, TValue>.SetItem(const AKey: TKey; const AValue: TValue);
var
  LIndex: Integer;
begin
  LIndex := IndexOf(AKey);
  if LIndex > -1 then
    FArray[LIndex].Value := AValue;
end;

procedure TADMapBase<TKey, TValue>.SetSorter(const ASorter: IADMapSorter<TKey, TValue>);
begin
  FSorter := ASorter;
end;

{ TADMap<TKey, TValue> }

constructor TADMap<TKey, TValue>.Create(const AComparer: IADComparer<TKey>; const AInitialCapacity: Integer);
begin
  Create(ADCollectionExpanderDefault, ADCollectionCompactorDefault, AComparer, AInitialCapacity);
end;

constructor TADMap<TKey, TValue>.Create(const AExpander: IADExpander; const AComparer: IADComparer<TKey>; const AInitialCapacity: Integer);
begin
  Create(AExpander, ADCollectionCompactorDefault, AComparer, AInitialCapacity);
end;

constructor TADMap<TKey, TValue>.Create(const ACompactor: IADCompactor; const AComparer: IADComparer<TKey>; const AInitialCapacity: Integer);
begin
  Create(ADCollectionExpanderDefault, ACompactor, AComparer, AInitialCapacity);
end;

constructor TADMap<TKey, TValue>.Create(const AExpander: IADExpander; const ACompactor: IADCompactor; const AComparer: IADComparer<TKey>; const AInitialCapacity: Integer);
begin
  inherited Create(AInitialCapacity);
  FExpander := AExpander;
  FCompactor := ACompactor;
  FComparer := AComparer;
end;

procedure TADMap<TKey, TValue>.CreateSorter;
begin
  FSorter := TADMapSorterQuick<TKey, TValue>.Create;
end;

{ TADTreeNode<T> }

procedure TADTreeNode<T>.AddChild(const AChild: IADTreeNode<T>; const AIndex: Integer);
begin
  if AIndex < 0 then
    FChildren.Add(AChild)
  else
    FChildren.Insert(AChild, AIndex);

  AChild.Parent := Self;
end;

function TADTreeNode<T>.GetChildCount: Integer;
begin
  Result := FChildren.Count;
end;

function TADTreeNode<T>.GetChildCountRecursive: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to FChildren.Count - 1 do
  begin
    Inc(Result);
    Result := Result + FChildren[I].ChildCountRecursive;
  end;
end;

function TADTreeNode<T>.GetChildren: IADList<IADTreeNode<T>>;
begin
  Result := FChildren;
end;

function TADTreeNode<T>.GetChildrenReaders: IADListReader<IADTreeNodeReader<T>>;
begin
  Result := FChildrenReaders;
end;

function TADTreeNode<T>.GetDepth: Integer;
var
  Ancestor: IADTreeNodeReader<T>;
begin
  Ancestor := ParentReader;
  Result := 0;

  while Ancestor <> nil do
  begin
    Inc(Result);
    Ancestor := Ancestor.ParentReader;
  end;
end;

function TADTreeNode<T>.GetIndexAsChild: Integer;
begin
  if Parent = nil then
    Result := -1
  else
    Result := Parent.IndexOf[Self];
end;

function TADTreeNode<T>.GetIndexOf(const AChild: IADTreeNodeReader<T>): Integer;
begin
  if (not ADInterfaceComparer.AEqualToB(AChild, Self)) then
    Result := -1
  else
    Result := AChild.IndexAsChild;
end;

function TADTreeNode<T>.GetIsBranch: Boolean;
begin
  Result := (not GetIsRoot) and (not GetIsLeaf);
end;

function TADTreeNode<T>.GetIsLeaf: Boolean;
begin
  Result := FChildren.Count = 0;
end;

function TADTreeNode<T>.GetIsRoot: Boolean;
begin
  Result := FParent = nil;
end;

function TADTreeNode<T>.GetParent: IADTreeNode<T>;
begin
  if FParent = nil then
    Result := nil
  else
    Result := IADTreeNode<T>(FParent^);
end;

function TADTreeNode<T>.GetParentReader: IADTreeNodeReader<T>;
begin
  if FParent = nil then
    Result := nil
  else
    Result := IADTreeNodeReader<T>(FParent^);
end;

function TADTreeNode<T>.GetReader: IADTreeNodeReader<T>;
begin
  Result := Self;
end;

function TADTreeNode<T>.GetRoot: IADTreeNode<T>;
begin
  if IsRoot then
    Result := Self
  else
    Result := Parent.Root;
end;

function TADTreeNode<T>.GetRootReader: IADTreeNodeReader<T>;
begin
  if IsRoot then
    Result := Self
  else
    Result := Parent.RootReader;
end;

function TADTreeNode<T>.GetValue: T;
begin
  Result := FValue;
end;

procedure TADTreeNode<T>.MoveTo(const ANewParent: IADTreeNode<T>; const AIndex: Integer);
begin
  if (Parent = nil) and (ANewParent = nil) then
    Exit;

  if Parent = ANewParent then // If it's the existing Parent...
  begin
    if AIndex <> IndexAsChild then
    begin
      Parent.RemoveChild(Self);
      if AIndex < 0 then
        Parent.Children.Add(Self)
      else
        Parent.Children.Insert(Self, AIndex);
    end;
  end else // If it's a NEW Parent
  begin
    if Parent <> nil then
      Parent.RemoveChild(Self);

    FParent := @ANewParent;

    Parent.AddChild(Self, AIndex);

    //DoAncestorChanged;
  end;
end;

procedure TADTreeNode<T>.MoveTo(const AIndex: Integer);
begin
  MoveTo(Parent, AIndex);
end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADTreeNode<T>.PostOrderWalk(const AAction: TADTreeNodeValueCallbackAnon<IADTreeNodeReader<T>>);
  begin

  end;

  procedure TADTreeNode<T>.PostOrderWalk(const AAction: TADTreeNodeValueCallbackAnon<T>);
  begin

  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADTreeNode<T>.PostOrderWalk(const AAction: TADTreeNodeValueCallbackUnbound<IADTreeNodeReader<T>>);
begin

end;

procedure TADTreeNode<T>.PostOrderWalk(const AAction: TADTreeNodeValueCallbackOfObject<T>);
begin

end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADTreeNode<T>.PostOrderWalk(const AAction: TADTreeNodeValueCallbackAnon<IADTreeNode<T>>);
  begin

  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADTreeNode<T>.PostOrderWalk(const AAction: TADTreeNodeValueCallbackOfObject<IADTreeNodeReader<T>>);
begin

end;

procedure TADTreeNode<T>.PostOrderWalk(const AAction: TADTreeNodeValueCallbackUnbound<IADTreeNode<T>>);
begin

end;

procedure TADTreeNode<T>.PostOrderWalk(const AAction: TADTreeNodeValueCallbackOfObject<IADTreeNode<T>>);
begin

end;

procedure TADTreeNode<T>.PostOrderWalk(const AAction: TADTreeNodeValueCallbackUnbound<T>);
begin

end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADTreeNode<T>.PreOrderWalk(const AAction: TADTreeNodeValueCallbackAnon<IADTreeNodeReader<T>>);
  begin

  end;

  procedure TADTreeNode<T>.PreOrderWalk(const AAction: TADTreeNodeValueCallbackAnon<T>);
  begin

  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADTreeNode<T>.PreOrderWalk(const AAction: TADTreeNodeValueCallbackOfObject<IADTreeNodeReader<T>>);
begin

end;

procedure TADTreeNode<T>.PreOrderWalk(const AAction: TADTreeNodeValueCallbackUnbound<T>);
begin

end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADTreeNode<T>.PreOrderWalk(const AAction: TADTreeNodeValueCallbackAnon<IADTreeNode<T>>);
  begin

  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADTreeNode<T>.PreOrderWalk(const AAction: TADTreeNodeValueCallbackOfObject<IADTreeNode<T>>);
begin

end;

procedure TADTreeNode<T>.PreOrderWalk(const AAction: TADTreeNodeValueCallbackUnbound<IADTreeNode<T>>);
begin

end;

procedure TADTreeNode<T>.PreOrderWalk(const AAction: TADTreeNodeValueCallbackOfObject<T>);
begin

end;

procedure TADTreeNode<T>.PreOrderWalk(const AAction: TADTreeNodeValueCallbackUnbound<IADTreeNodeReader<T>>);
begin

end;

procedure TADTreeNode<T>.RemoveChild(const AChild: IADTreeNode<T>);
var
  LIndex: Integer;
begin
  LIndex := IndexOf[AChild];
  if LIndex > -1 then
  begin
    FChildren.Delete(LIndex);
    FChildrenReaders.Delete(LIndex);
  end;
end;

procedure TADTreeNode<T>.SetParent(const AParent: IADTreeNode<T>);
begin
  MoveTo(AParent);
end;

procedure TADTreeNode<T>.SetValue(const AValue: T);
begin
  FValue := AValue;
end;

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

initialization
  GCollectionExpanderDefault := TADExpanderDefault.Create;
  GCollectionCompactorDefault := TADCompactorDefault.Create;

end.
