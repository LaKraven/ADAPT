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
  public
    constructor Create(const AInitialCapacity: Integer); reintroduce; virtual;
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
  TADList<T> = class(TADListExpandableBase<T>, IADCompactable, IADExpandable)
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
  ///    <para><c>Use IADSortableList to define a Sorter and perform Lookups.</c></para>
  ///  </remarks>
  TADSortedList<T> = class(TADListExpandableBase<T>, IADSortableList<T>, IADComparable<T>)
  private
    FSorter: IADListSorter<T>;
    FComparer: IADComparer<T>;
  protected
    // Getters
    { IADSortableList<T> }
    function GetSorter: IADListSorter<T>; virtual;
    { IADComparable<T> }
    function GetComparer: IADComparer<T>; virtual;

    // Setters
    { IADSortableList<T> }
    procedure SetSorter(const ASorter: IADListSorter<T>); virtual;
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
    { IADSortableList<T> }
    function Contains(const AItem: T): Boolean;
    function ContainsAll(const AItems: Array of T): Boolean;
    function ContainsAny(const AItems: Array of T): Boolean;
    function ContainsNone(const AItems: Array of T): Boolean;
    function EqualItems(const AList: IADList<T>): Boolean;
    function IndexOf(const AItem: T): Integer;
    procedure Remove(const AItem: T);
    procedure RemoveItems(const AItems: Array of T);
    procedure Sort(const AComparer: IADComparer<T>); virtual;

    // Properties
    { IADSortableList<T> }
    property Sorter: IADListSorter<T> read GetSorter write SetSorter;
  end;

  ///  <summary><c>Abstract Base Type for all Generic Map Collection Types.</c></summary>
  ///  <remarks>
  ///    <para><c>Use IADMapReader for Read-Only access.</c></para>
  ///    <para><c>Use IADMap for Read/Write access.</c></para>
  ///    <para><c>Use IADIterableMap for Iterators.</c></para>
  ///    <para><c>Call .Iterator against IADMapReader to return the IADIterableMap interface reference.</c></para>
  ///  </remarks>
  TADMapBase<TKey, TValue> = class abstract(TADCollection, IADMapReader<TKey, TValue>, IADMap<TKey, TValue>, IADIterableMap<TKey, TValue>)
  private
    // Getters
    { IADMapReader<TKey, TValue> }
    function GetItem(const AKey: TKey): TValue;
    function GetIterator: IADIterableMap<TKey, TValue>;
    function GetPair(const AIndex: Integer): IADKeyValuePair<TKey, TValue>;
    { IADMap<TKey, TValue> }
    function GetReader: IADMapReader<TKey, TValue>;
    { IADIterableMap<TKey, TValue> }

    // Setters
    { IADMapReader<TKey, TValue> }
    { IADMap<TKey, TValue> }
    procedure SetItem(const AKey: TKey; const AValue: TValue);
    { IADIterableMap<TKey, TValue> }
  public
    // Management Methods
    { IADMapReader<TKey, TValue> }
    function Contains(const AKey: TKey): Boolean;
    function ContainsAll(const AKeys: Array of TKey): Boolean;
    function ContainsAny(const AKeys: Array of TKey): Boolean;
    function ContainsNone(const AKeys: Array of TKey): Boolean;
    function EqualItems(const AList: IADMapReader<TKey, TValue>): Boolean;
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
  end;

  ///  <summary><c>Generic Map Collection.</c></summary>
  ///  <remarks>
  ///    <para><c>Use IADMapReader for Read-Only access.</c></para>
  ///    <para><c>Use IADMap for Read/Write access.</c></para>
  ///    <para><c>Use IADIterableMap for Iterators.</c></para>
  ///    <para><c>Call .Iterator against IADMapReader to return the IADIterableMap interface reference.</c></para>
  ///  </remarks>
  TADMap<TKey, TValue> = class(TADMapBase<TKey, TValue>)

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
var
  LIndex: Integer;
begin
  LIndex := IndexOf(AItem);
  Result := (LIndex > -1);
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

function TADSortedList<T>.GetSorter: IADListSorter<T>;
begin
  Result := FSorter;
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
  Sort(AComparer); // We need to re-sort the list because we've changed the Sorter
end;

procedure TADSortedList<T>.SetItem(const AIndex: Integer; const AItem: T);
begin
  DeleteActual(AIndex);
  AddActual(AItem);
end;

procedure TADSortedList<T>.SetSorter(const ASorter: IADListSorter<T>);
begin
  FSorter := ASorter; // Since the Sorter only defines the algorithm for sorting and NOT the sort-order, we don't need to re-sort.
end;

procedure TADSortedList<T>.Sort(const AComparer: IADComparer<T>);
begin
  FComparer := AComparer; // If we're going to sort against a different Comparer, we need to keep hold of the Comparer!
  FSorter.Sort(FArray, AComparer, 0, FCount - 1);
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

{ TADMapBase<TKey, TValue> }

function TADMapBase<TKey, TValue>.Add(const AKey: TKey; const AValue: TValue): Integer;
begin

end;

function TADMapBase<TKey, TValue>.Add(const AItem: IADKeyValuePair<TKey, TValue>): Integer;
begin

end;

procedure TADMapBase<TKey, TValue>.AddItems(const AItems: array of IADKeyValuePair<TKey, TValue>);
begin

end;

procedure TADMapBase<TKey, TValue>.AddItems(const AMap: IADMapReader<TKey, TValue>);
begin

end;

procedure TADMapBase<TKey, TValue>.Compact;
begin

end;

function TADMapBase<TKey, TValue>.Contains(const AKey: TKey): Boolean;
begin

end;

function TADMapBase<TKey, TValue>.ContainsAll(const AKeys: array of TKey): Boolean;
begin

end;

function TADMapBase<TKey, TValue>.ContainsAny(const AKeys: array of TKey): Boolean;
begin

end;

function TADMapBase<TKey, TValue>.ContainsNone(const AKeys: array of TKey): Boolean;
begin

end;

procedure TADMapBase<TKey, TValue>.Delete(const AIndex: Integer);
begin

end;

procedure TADMapBase<TKey, TValue>.DeleteRange(const AFromIndex, ACount: Integer);
begin

end;

function TADMapBase<TKey, TValue>.EqualItems(const AList: IADMapReader<TKey, TValue>): Boolean;
begin

end;

function TADMapBase<TKey, TValue>.GetItem(const AKey: TKey): TValue;
begin

end;

function TADMapBase<TKey, TValue>.GetIterator: IADIterableMap<TKey, TValue>;
begin
  Result := IADIterableMap<TKey, TValue>(Self);
end;

function TADMapBase<TKey, TValue>.GetPair(const AIndex: Integer): IADKeyValuePair<TKey, TValue>;
begin

end;

function TADMapBase<TKey, TValue>.GetReader: IADMapReader<TKey, TValue>;
begin
  Result := IADMapReader<TKey, TValue>(Self);
end;

function TADMapBase<TKey, TValue>.IndexOf(const AKey: TKey): Integer;
begin

end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADMapBase<TKey, TValue>.Iterate(const ACallback: TADListMapCallbackAnon<TKey, TValue>; const ADirection: TADIterateDirection = idRight);
  begin

  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADMapBase<TKey, TValue>.Iterate(const ACallback: TADListMapCallbackUnbound<TKey, TValue>; const ADirection: TADIterateDirection);
begin

end;

procedure TADMapBase<TKey, TValue>.Iterate(const ACallback: TADListMapCallbackOfObject<TKey, TValue>; const ADirection: TADIterateDirection);
begin

end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADMapBase<TKey, TValue>.IterateBackward(const ACallback: TADListMapCallbackAnon<TKey, TValue>);
  begin

  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADMapBase<TKey, TValue>.IterateBackward(const ACallback: TADListMapCallbackUnbound<TKey, TValue>);
begin

end;

procedure TADMapBase<TKey, TValue>.IterateBackward(const ACallback: TADListMapCallbackOfObject<TKey, TValue>);
begin

end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADMapBase<TKey, TValue>.IterateForward(const ACallback: TADListMapCallbackAnon<TKey, TValue>);
  begin

  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADMapBase<TKey, TValue>.IterateForward(const ACallback: TADListMapCallbackUnbound<TKey, TValue>);
begin

end;

procedure TADMapBase<TKey, TValue>.IterateForward(const ACallback: TADListMapCallbackOfObject<TKey, TValue>);
begin

end;

procedure TADMapBase<TKey, TValue>.Remove(const AKey: TKey);
begin

end;

procedure TADMapBase<TKey, TValue>.RemoveItems(const AKeys: array of TKey);
begin

end;

procedure TADMapBase<TKey, TValue>.SetItem(const AKey: TKey; const AValue: TValue);
begin

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

end;

procedure TADCircularList<T>.SetItem(const AIndex: Integer; const AItem: T);
begin

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
