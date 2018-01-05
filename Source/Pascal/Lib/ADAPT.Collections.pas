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
  ADAPT.Comparers.Intf,
  ADAPT.Collections.Intf, ADAPT.Collections.Abstract;

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

  ///  <summary><c>Generic Map Collection.</c></summary>
  ///  <remarks>
  ///    <para><c>Use IADMapReader for Read-Only access.</c></para>
  ///    <para><c>Use IADMap for Read/Write access.</c></para>
  ///    <para><c>Use IADIterableMap for Iterators.</c></para>
  ///    <para><c>Call .Iterator against IADMapReader to return the IADIterableMap interface reference.</c></para>
  ///    <para><c>Use IADCompactable to Get/Set the Compactor.</c></para>
  ///    <para><c>Use IADExpandable to Get/Set the Expander.</c></para>
  ///  </remarks>
  TADMap<TKey, TValue> = class(TADMapExpandableBase<TKey, TValue>)
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

  ///  <summary><c>Generic Circular Map Collection.</c></summary>
  ///  <remarks>
  ///    <para><c>Designed to have a fixed Capacity, it automatically removes older Items to make way for new ones.</c></para>
  ///    <para><c>Use IADMapReader for Read-Only access.</c></para>
  ///    <para><c>Use IADMap for Read/Write access.</c></para>
  ///    <para><c>Use IADIterableMap for Iterators.</c></para>
  ///    <para><c>Call .Iterator against IADMapReader to return the IADIterableMap interface reference.</c></para>
  ///  </remarks>
  TADCircularMap<TKey, TValue> = class(TADMapBase<TKey, TValue>)
  protected
    // Overrides
    { TADMapBase<TKey, TValue> Override }
    procedure CreateSorter; override;
    function AddActual(const AItem: IADKeyValuePair<TKey, TValue>): Integer; override;
  public
    ///  <summary><c>Creates an instance of your Circular Map with the given Capacity (Default = 10).</c></summary>
    constructor Create(const AComparer: IADComparer<TKey>; const AInitialCapacity: Integer = 10); reintroduce; overload;
  end;

  ///  <summary><c>Generic Tree Collection.</c></summary>
  ///  <remarks>
  ///    <para><c>Use IADTreeNodeReader for Read-Only access.</c></para>
  ///    <para><c>Use IADTreeNode for Read/Write access.</c></para>
  ///    <para><c>Use IADCompactable to define a Compactor for the Child List.</c></para>
  ///    <para><c>Use IADExpandable to define an Expander for the Child List.</c></para>
  ///    <para><c>Iterators are defined in both IADTreeNodeReader and IADTreeNode Interfaces.</c></para>
  ///    <para><c>Call IADTreeNode.Reader to return an IADTreeNodeReader referenced Interface.</c></para>
  ///  </remarks>
  TADTreeNode<T> = class(TADObject, IADTreeNodeReader<T>, IADTreeNode<T>, IADCompactable, IADExpandable)
  private
    FChildren: IADList<IADTreeNode<T>>;
    FParent: Pointer;
    FValue: T;
  protected
    // Geters
    { IADTreeNodeReader<T> }
    function GetChildCount: Integer;
    function GetChildCountRecursive: Integer;
    function GetChildReader(const AIndex: Integer): IADTreeNodeReader<T>;
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
    function GetChild(const AIndex: Integer): IADTreeNode<T>;
    function GetParent: IADTreeNode<T>;
    function GetReader: IADTreeNodeReader<T>;
    function GetRoot: IADTreeNode<T>;
    { IADCompactable }
    function GetCompactor: IADCompactor;
    { IADExpandable }
    function GetExpander: IADExpander;

    // Setters
    { IADTreeNode<T> }
    procedure SetParent(const AParent: IADTreeNode<T>); virtual;
    procedure SetValue(const AValue: T); virtual;
    { IADCompactable }
    procedure SetCompactor(const ACompactor: IADCompactor);
    { IADExpandable }
    procedure SetExpander(const AExpander: IADExpander);
  public
    constructor Create(const AParent: IADTreeNode<T>; const AValue: T); reintroduce; overload;
    constructor Create(const AParent: IADTreeNode<T>); reintroduce; overload;
    constructor Create(const AValue: T); reintroduce; overload;

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
    { IADTreeNode<T> }
    procedure AddChild(const AChild: IADTreeNode<T>; const AIndex: Integer = -1);
    procedure MoveTo(const ANewParent: IADTreeNode<T>; const AIndex: Integer = -1); overload;
    procedure MoveTo(const AIndex: Integer); overload;
    procedure RemoveChild(const AChild: IADTreeNodeReader<T>);
    { IADCompactable }
    procedure Compact;

    // Properties
    { IADTreeNodeReader<T> }
    property ChildCount: Integer read GetChildCount;
    property ChildCountRecursive: Integer read GetChildCountRecursive;
    property ChildReader[const AIndex: Integer]: IADTreeNodeReader<T> read GetChildReader;
    property Depth: Integer read GetDepth;
    property IndexAsChild: Integer read GetIndexAsChild;
    property IndexOf[const AChild: IADTreeNodeReader<T>]: Integer read GetIndexOf;
    property IsBranch: Boolean read GetIsBranch;
    property IsLeaf: Boolean read GetIsLeaf;
    property IsRoot: Boolean read GetIsRoot;
    property ParentReader: IADTreeNodeReader<T> read GetParentReader;
    property RootReader: IADTreeNodeReader<T> read GetRootReader;
    { IADTreeNode<T> }
    property Child[const AIndex: Integer]: IADTreeNode<T> read GetChild; default;
    property Parent: IADTreeNode<T> read GetParent;
    property Root: IADTreeNode<T> read GetRoot;
    property Value: T read GetValue write SetValue;
  end;

  TADStackQueue<T> = class(TADObject, IADStackQueueReader<T>, IADStackQueue<T>, IADIterableList<T>)
  private
    FPriorityCount: Integer;
    FQueues: IADArray<IADList<T>>; // Bucket of Queues (one per Priority)
    FStacks: IADArray<IADList<T>>; // Bucket of Stacks (one per Priority)
    function CheckPriority(const APriority: Integer; const AReturnArrayIndex: Boolean = False): Integer;
  protected
    // Getters
    { IADStackQueueReader<T> }
    function GetCount: Integer; overload;
    function GetCount(const APriority: Integer): Integer; overload;
    function GetIterator: IADIterableList<T>; virtual;
    function GetQueueCount: Integer; overload; virtual;
    function GetQueueCount(const APriority: Integer): Integer; overload; virtual;
    function GetStackCount: Integer; overload; virtual;
    function GetStackCount(const APriority: Integer): Integer; overload; virtual;
    { IADStackQueue<T> }
    function GetReader: IADStackQueueReader<T>;
  public
    ///  <summary><c>Creates a Stack/Queue instance containing the given number of Priority Stacks and Queues (respectively).</c></summary>
    ///  <remarks>
    ///    <para>NOTE: <c>Once instanciated, you cannot change the number of Priority Stacks and Queues.</c></para>
    ///  </remarks>
    constructor Create(const APriorityCount: Integer = 5); reintroduce;
    // Management Methods
    procedure Queue(const AItem: T); overload; virtual;
    procedure Queue(const AItem: T; const APriority: Integer); overload; virtual;
    procedure Queue(const AItems: IADListReader<T>); overload; virtual;
    procedure Queue(const AItems: IADListReader<T>; const APriority: Integer); overload; virtual;
    procedure Queue(const AItems: Array of T); overload; virtual;
    procedure Queue(const AItems: Array of T; const APriority: Integer); overload; virtual;
    procedure Stack(const AItem: T); overload; virtual;
    procedure Stack(const AItem: T; const APriority: Integer); overload; virtual;
    procedure Stack(const AItems: IADListReader<T>); overload; virtual;
    procedure Stack(const AItems: IADListReader<T>; const APriority: Integer); overload; virtual;
    procedure Stack(const AItems: Array of T); overload; virtual;
    procedure Stack(const AItems: Array of T; const APriority: Integer); overload; virtual;

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

    // Properties
    { IADStackQueueReader<T> }
    property CountTotal: Integer read GetCount;
    property Count[const APriority: Integer]: Integer read GetCount;
    property Iterator: IADIterableList<T> read GetIterator;
    property QueueTotalCount: Integer read GetQueueCount;
    property QueueCount[const APriority: Integer]: Integer read GetQueueCount;
    property StackTotalCount: Integer read GetStackCount;
    property StackCount[const APriority: Integer]: Integer read GetStackCount;
    { IADStackQueue<T> }
    property Reader: IADStackQueueReader<T> read GetReader;
  end;

  { List Sorters }
  ///  <summary><c>Sorter for Lists using the Quick Sort implementation.</c></summary>
  TADListSorterQuick<T> = class(TADListSorter<T>)
  public
    procedure Sort(const AArray: IADArray<T>; const AComparer: IADComparer<T>; AFrom, ATo: Integer); overload; override;
    procedure Sort(AArray: Array of T; const AComparer: IADComparer<T>; AFrom, ATo: Integer); overload; override;
  end;

  { Map Sorters }
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
  if (FCount = 0) then
    Exit;
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

{ TADCircularMap<TKey, TValue> }

function TADCircularMap<TKey, TValue>.AddActual(const AItem: IADKeyValuePair<TKey, TValue>): Integer;
begin
  Result := GetSortedPosition(AItem.Key);
  if Result = FCount then
  begin
    FArray[FCount] := AItem;
    if (FCount < FArray.Capacity) then
      Inc(FCount);
  end else
  begin
    if FCount = FArray.Capacity then // If the Array is full, we need to bump off 0
    begin
      FArray.Delete(0);
      if Result > 0 then
        Dec(Result); // Since we've removed Item 0 (lowest-order item) we need to decrement the position by 1
    end
    else
      Inc(FCount);
    FArray.Insert(AItem, Result);
  end;
end;

constructor TADCircularMap<TKey, TValue>.Create(const AComparer: IADComparer<TKey>; const AInitialCapacity: Integer);
begin
  inherited Create(AInitialCapacity);
  FComparer := AComparer;
end;

procedure TADCircularMap<TKey, TValue>.CreateSorter;
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
end;

constructor TADTreeNode<T>.Create(const AParent: IADTreeNode<T>; const AValue: T);
begin
  inherited Create;
  FParent := nil;
  if AParent <> nil then
    SetParent(AParent);
  FChildren := TADList<IADTreeNode<T>>.Create(10);
  FValue := AValue;
end;

constructor TADTreeNode<T>.Create(const AParent: IADTreeNode<T>);
begin
  Create(AParent, Default(T));
end;

procedure TADTreeNode<T>.Compact;
begin
  (FChildren as IADCompactable).Compact;
end;

constructor TADTreeNode<T>.Create(const AValue: T);
begin
  Create(nil, AValue);
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

function TADTreeNode<T>.GetChildReader(const AIndex: Integer): IADTreeNodeReader<T>;
begin
  Result := FChildren[AIndex];
end;

function TADTreeNode<T>.GetCompactor: IADCompactor;
begin

end;

function TADTreeNode<T>.GetChild(const AIndex: Integer): IADTreeNode<T>;
begin
  Result := FChildren[AIndex];
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

function TADTreeNode<T>.GetExpander: IADExpander;
begin

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
  if (not ADInterfaceComparer.AEqualToB(AChild.ParentReader, Self)) then
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
    Result := IADTreeNode<T>(FParent);
end;

function TADTreeNode<T>.GetParentReader: IADTreeNodeReader<T>;
begin
  if FParent = nil then
    Result := nil
  else
    Result := IADTreeNodeReader<T>(FParent);
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
    if AIndex <> IndexAsChild then // If the Index of this Child is NOT the same as we're attempting to Move it to...
    begin
      Parent.RemoveChild(Self); // Remove the Child
      Parent.AddChild(Self, AIndex); // Add it again at the given Index
    end;
  end else // If it's a NEW Parent
  begin
    if Parent <> nil then
      Parent.RemoveChild(Self);

    ANewParent.AddChild(Self, AIndex);
  end;

  FParent := Pointer(ANewParent);
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

procedure TADTreeNode<T>.RemoveChild(const AChild: IADTreeNodeReader<T>);
var
  LIndex: Integer;
begin
  LIndex := IndexOf[AChild];
  if LIndex > -1 then
    FChildren.Delete(LIndex);
end;

procedure TADTreeNode<T>.SetCompactor(const ACompactor: IADCompactor);
begin
  (FChildren as IADCompactable).Compactor := ACompactor;
end;

procedure TADTreeNode<T>.SetExpander(const AExpander: IADExpander);
begin
  (FChildren as IADExpandable).Expander := AExpander;
end;

procedure TADTreeNode<T>.SetParent(const AParent: IADTreeNode<T>);
var
  LParent: IADTreeNode<T>;
begin
  LParent := GetParent;
  if LParent <> nil then
    LParent.RemoveChild(Self);

  FParent := Pointer(AParent);
  AParent.AddChild(Self);
end;

procedure TADTreeNode<T>.SetValue(const AValue: T);
begin
  FValue := AValue;
end;

{ TADStackQueue<T> }

function TADStackQueue<T>.CheckPriority(const APriority: Integer; const AReturnArrayIndex: Boolean = False): Integer;
begin
  if APriority < 1 then
    Result := 1
  else if APriority > FPriorityCount then
    Result := FPriorityCount
  else
    Result := APriority;

  if (AReturnArrayIndex) then
    Dec(Result); // This accounts for the 0-based Array Offset.
end;

constructor TADStackQueue<T>.Create(const APriorityCount: Integer);
var
  I: Integer;
begin
  inherited Create;
  FPriorityCount := APriorityCount;
  FQueues := TADArray<IADList<T>>.Create(APriorityCount);
  FStacks := TADArray<IADList<T>>.Create(APriorityCount);
  for I := 0 to APriorityCount - 1 do
  begin
    FQueues[I] := TADList<T>.Create(ADCollectionExpanderGeometric);
    FStacks[I] := TADList<T>.Create(ADCollectionExpanderGeometric);
  end;
end;

function TADStackQueue<T>.GetCount: Integer;
begin
  Result := GetQueueCount + GetStackCount;
end;

function TADStackQueue<T>.GetCount(const APriority: Integer): Integer;
begin
  Result := GetQueueCount(APriority) + GetStackCount(APriority);
end;

function TADStackQueue<T>.GetIterator: IADIterableList<T>;
begin
  Result := Self;
end;

function TADStackQueue<T>.GetQueueCount: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to FQueues.Capacity - 1 do
    Result := Result := FQueues[I].Count;
end;

function TADStackQueue<T>.GetQueueCount(const APriority: Integer): Integer;
var
  LPriority: Integer;
begin
  LPriority := CheckPriority(APriority, True);
  Result := FQueues[LPriority].Count;
end;

function TADStackQueue<T>.GetReader: IADStackQueueReader<T>;
begin
  Result := Self;
end;

function TADStackQueue<T>.GetStackCount(const APriority: Integer): Integer;
var
  LPriority: Integer;
begin
  LPriority := CheckPriority(APriority, True);
  Result := FStacks[LPriority].Count;
end;

function TADStackQueue<T>.GetStackCount: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to FStacks.Capacity - 1 do
    Result := Result := FStacks[I].Count;
end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADStackQueue<T>.Iterate(const ACallback: TADListItemCallbackAnon<T>; const ADirection: TADIterateDirection);
  begin

  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADStackQueue<T>.Iterate(const ACallback: TADListItemCallbackUnbound<T>; const ADirection: TADIterateDirection);
begin

end;

procedure TADStackQueue<T>.Iterate(const ACallback: TADListItemCallbackOfObject<T>; const ADirection: TADIterateDirection);
begin

end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADStackQueue<T>.IterateBackward(const ACallback: TADListItemCallbackAnon<T>);
  begin

  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADStackQueue<T>.IterateBackward(const ACallback: TADListItemCallbackUnbound<T>);
begin

end;

procedure TADStackQueue<T>.IterateBackward(const ACallback: TADListItemCallbackOfObject<T>);
begin

end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADStackQueue<T>.IterateForward(const ACallback: TADListItemCallbackAnon<T>);
  begin

  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADStackQueue<T>.IterateForward(const ACallback: TADListItemCallbackOfObject<T>);
begin

end;

procedure TADStackQueue<T>.IterateForward(const ACallback: TADListItemCallbackUnbound<T>);
begin

end;

procedure TADStackQueue<T>.Queue(const AItems: IADListReader<T>);
begin

end;

procedure TADStackQueue<T>.Queue(const AItems: IADListReader<T>; const APriority: Integer);
begin

end;

procedure TADStackQueue<T>.Queue(const AItem: T);
begin

end;

procedure TADStackQueue<T>.Queue(const AItem: T; const APriority: Integer);
begin

end;

procedure TADStackQueue<T>.Queue(const AItems: array of T; const APriority: Integer);
begin

end;

procedure TADStackQueue<T>.Queue(const AItems: array of T);
begin

end;

procedure TADStackQueue<T>.Stack(const AItems: IADListReader<T>; const APriority: Integer);
begin

end;

procedure TADStackQueue<T>.Stack(const AItems: array of T);
begin

end;

procedure TADStackQueue<T>.Stack(const AItems: array of T; const APriority: Integer);
begin

end;

procedure TADStackQueue<T>.Stack(const AItem: T; const APriority: Integer);
begin

end;

procedure TADStackQueue<T>.Stack(const AItem: T);
begin

end;

procedure TADStackQueue<T>.Stack(const AItems: IADListReader<T>);
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
