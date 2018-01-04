{
  AD.A.P.T. Library
  Copyright (C) 2014-2018, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Collections.Abstract;

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
  ADAPT.Collections.Intf;

  {$I ADAPT_RTTI.inc}

type
  ///  <summary><c>An Allocation Algorithm for Lists.</c></summary>
  ///  <remarks><c>Dictates how to grow an Array based on its current Capacity and the number of Items we're looking to Add/Insert.</c></remarks>
  TADExpander = class abstract(TADObject, IADExpander)
  public
    { IADExpander }
    ///  <summary><c>Override this to implement the actual Allocation Algorithm</c></summary>
    ///  <remarks><c>Must return the amount by which the Array has been Expanded.</c></remarks>
    function CheckExpand(const ACapacity, ACurrentCount, AAdditionalRequired: Integer): Integer; virtual; abstract;
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

  ///  <summary><c>Abstract Base Type for all Generic Map Collection Types.</c></summary>
  ///  <remarks>
  ///    <para><c>Use IADMapReader for Read-Only access.</c></para>
  ///    <para><c>Use IADMap for Read/Write access.</c></para>
  ///    <para><c>Use IADIterableMap for Iterators.</c></para>
  ///    <para><c>Call .Iterator against IADMapReader to return the IADIterableMap interface reference.</c></para>
  ///  </remarks>
  TADMapBase<TKey, TValue> = class abstract(TADCollection, IADMapReader<TKey, TValue>, IADMap<TKey, TValue>, IADIterableMap<TKey, TValue>, IADComparable<TKey>)
  protected
    FArray: IADArray<IADKeyValuePair<TKey, TValue>>;
    FComparer: IADComparer<TKey>;
    FSorter: IADMapSorter<TKey, TValue>;
    // Getters
    { IADMapReader<TKey, TValue> }
    function GetItem(const AKey: TKey): TValue;
    function GetIterator: IADIterableMap<TKey, TValue>;
    function GetPair(const AIndex: Integer): IADKeyValuePair<TKey, TValue>;
    function GetSorter: IADMapSorter<TKey, TValue>; virtual;
    { IADMap<TKey, TValue> }
    function GetReader: IADMapReader<TKey, TValue>;
    { IADIterableMap<TKey, TValue> }
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
    function Add(const AItem: IADKeyValuePair<TKey, TValue>): Integer; overload; virtual;
    function Add(const AKey: TKey; const AValue: TValue): Integer; overload; virtual;
    procedure AddItems(const AItems: Array of IADKeyValuePair<TKey, TValue>); overload; virtual;
    procedure AddItems(const AMap: IADMapReader<TKey, TValue>); overload; virtual;
    procedure Compact;
    procedure Delete(const AIndex: Integer); overload; virtual;
    procedure DeleteRange(const AFromIndex, ACount: Integer); overload; virtual;
    procedure Remove(const AKey: TKey); virtual;
    procedure RemoveItems(const AKeys: Array of TKey); virtual;
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
    { IADComparable<T> }
    property Comparer: IADComparer<TKey> read GetComparer write SetComparer;
  end;

  ///  <summary><c>Abstract Base Type for all Expandable Generic Map Collection Types.</c></summary>
  ///  <remarks>
  ///    <para><c>Use IADMapReader for Read-Only access.</c></para>
  ///    <para><c>Use IADMap for Read/Write access.</c></para>
  ///    <para><c>Use IADIterableMap for Iterators.</c></para>
  ///    <para><c>Call .Iterator against IADMapReader to return the IADIterableMap interface reference.</c></para>
  ///    <para><c>Use IADCompactable to Get/Set the Compactor.</c></para>
  ///    <para><c>Use IADExpandable to Get/Set the Expander.</c></para>
  ///  </remarks>
  TADMapExpandableBase<TKey, TValue> = class abstract(TADMapBase<TKey, TValue>, IADCompactable, IADExpandable)
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

    // Overridables
    ///  <summary><c>Compacts the Array according to the given Compactor Algorithm.</c></summary>
    procedure CheckCompact(const AAmount: Integer); virtual;
    ///  <summary><c>Expands the Array according to the given Expander Algorithm.</c></summary>
    procedure CheckExpand(const AAmount: Integer); virtual;
  public
    { IADMap<TKey, TValue> }
    function Add(const AItem: IADKeyValuePair<TKey, TValue>): Integer; overload; override;
    function Add(const AKey: TKey; const AValue: TValue): Integer; overload; override;
    procedure AddItems(const AItems: Array of IADKeyValuePair<TKey, TValue>); overload; override;
    procedure AddItems(const AMap: IADMapReader<TKey, TValue>); overload; override;
    procedure Delete(const AIndex: Integer); overload; override;
    procedure DeleteRange(const AFromIndex, ACount: Integer); overload; override;
    procedure Remove(const AKey: TKey); override;
    procedure RemoveItems(const AKeys: Array of TKey); override;

    // Properties
    { IADCompactable }
    property Compactor: IADCompactor read GetCompactor write SetCompactor;
    { IADExpandable }
    property Expander: IADExpander read GetExpander write SetExpander;
  end;

  ///  <summary><c>Abstract Base Class for all List Sorters.</c></summary>
  TADListSorter<T> = class abstract(TADObject, IADListSorter<T>)
  public
    procedure Sort(const AArray: IADArray<T>; const AComparer: IADComparer<T>; AFrom, ATo: Integer); overload; virtual; abstract;
    procedure Sort(AArray: Array of T; const AComparer: IADComparer<T>; AFrom, ATo: Integer); overload; virtual; abstract;
  end;

  ///  <summary><c>Abstract Base Class for all Map Sorters.</c></summary>
  TADMapSorter<TKey, TValue> = class abstract(TADObject, IADMapSorter<TKey, TValue>)
  public
    procedure Sort(const AArray: IADArray<IADKeyValuePair<TKey,TValue>>; const AComparer: IADComparer<TKey>; AFrom, ATo: Integer); overload; virtual; abstract;
    procedure Sort(AArray: Array of IADKeyValuePair<TKey,TValue>; const AComparer: IADComparer<TKey>; AFrom, ATo: Integer); overload; virtual; abstract;
  end;

implementation

uses
  ADAPT.Collections; // This is needed for TADListSorterQuick as the Default Sorter.

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
  Result := AddActual(AItem);
end;

procedure TADMapBase<TKey, TValue>.AddItems(const AItems: array of IADKeyValuePair<TKey, TValue>);
var
  I: Integer;
begin
  for I := Low(AItems) to High(AItems) do
    AddActual(AItems[I]);
end;

procedure TADMapBase<TKey, TValue>.AddItems(const AMap: IADMapReader<TKey, TValue>);
var
  I: Integer;
begin
  for I := 0 to AMap.Count - 1 do
    AddActual(AMap.Pairs[I]);
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

function TADMapBase<TKey, TValue>.GetComparer: IADComparer<TKey>;
begin
  Result := FComparer;
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
  if (FCount = 0) then
    Exit;
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

procedure TADMapBase<TKey, TValue>.SetComparer(const AComparer: IADComparer<TKey>);
begin
  FComparer := AComparer;
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

{ TADMapExpandableBase<TKey, TValue> }

function TADMapExpandableBase<TKey, TValue>.Add(const AItem: IADKeyValuePair<TKey, TValue>): Integer;
begin
  CheckExpand(1);
  inherited;
end;

function TADMapExpandableBase<TKey, TValue>.Add(const AKey: TKey; const AValue: TValue): Integer;
begin
  CheckExpand(1);
  inherited;
end;

procedure TADMapExpandableBase<TKey, TValue>.AddItems(const AItems: array of IADKeyValuePair<TKey, TValue>);
begin
  CheckExpand(Length(AItems));
  inherited;
end;

procedure TADMapExpandableBase<TKey, TValue>.AddItems(const AMap: IADMapReader<TKey, TValue>);
begin
  CheckExpand(AMap.Count);
  inherited;
end;

procedure TADMapExpandableBase<TKey, TValue>.CheckCompact(const AAmount: Integer);
var
  LShrinkBy: Integer;
begin
  LShrinkBy := FCompactor.CheckCompact(FArray.Capacity, FCount, AAmount);
  if LShrinkBy > 0 then
    FArray.Capacity := FArray.Capacity - LShrinkBy;
end;

procedure TADMapExpandableBase<TKey, TValue>.CheckExpand(const AAmount: Integer);
var
  LNewCapacity: Integer;
begin
  LNewCapacity := FExpander.CheckExpand(FArray.Capacity, FCount, AAmount);
  if LNewCapacity > 0 then
    FArray.Capacity := FArray.Capacity + LNewCapacity;
end;

procedure TADMapExpandableBase<TKey, TValue>.Delete(const AIndex: Integer);
begin
  inherited;
  CheckCompact(1);
end;

procedure TADMapExpandableBase<TKey, TValue>.DeleteRange(const AFromIndex, ACount: Integer);
begin
  inherited;
  CheckCompact(ACount);
end;

function TADMapExpandableBase<TKey, TValue>.GetCompactor: IADCompactor;
begin
  Result := FCompactor;
end;

function TADMapExpandableBase<TKey, TValue>.GetExpander: IADExpander;
begin
  Result := FExpander;
end;

procedure TADMapExpandableBase<TKey, TValue>.Remove(const AKey: TKey);
begin
  inherited;
  CheckCompact(1);
end;

procedure TADMapExpandableBase<TKey, TValue>.RemoveItems(const AKeys: array of TKey);
begin
  inherited;
  CheckCompact(Length(AKeys));
end;

procedure TADMapExpandableBase<TKey, TValue>.SetCompactor(const ACompactor: IADCompactor);
begin
  FCompactor := ACompactor;
end;

procedure TADMapExpandableBase<TKey, TValue>.SetExpander(const AExpander: IADExpander);
begin
  FExpander := AExpander;
end;

end.
