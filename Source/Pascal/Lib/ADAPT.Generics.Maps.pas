{
  AD.A.P.T. Library
  Copyright (C) 2014-2016, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Generics.Maps;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes, System.SysUtils,
  {$ELSE}
    Classes, SysUtils,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Common, ADAPT.Common.Intf,
  ADAPT.Generics.Common.Intf,
  ADAPT.Generics.Allocators.Intf,
  ADAPT.Generics.Comparers.Intf,
  ADAPT.Generics.Arrays.Intf,
  ADAPT.Generics.Maps.Intf;

  {$I ADAPT_RTTI.inc}

type
  ///  <summary><c>Generic Sorted List Type.</c></summary>
  ///  <remarks>
  ///    <para><c>This type is NOT Threadsafe.</c></para>
  ///  </remarks>
  TADSortedList<T> = class(TADObject, IADSortedList<T>, IADComparable<T>, IADIterable<T>, IADCompactable, IADExpandable)
  private
    FCompactor: IADCollectionCompactor;
    FComparer: IADComparer<T>;
    FExpander: IADCollectionExpander;
    FInitialCapacity: Integer;
  protected
    FArray: IADArray<T>;
    FCount: Integer;

    // Getters
    { IADCompactable }
    function GetCompactor: IADCollectionCompactor; virtual;
    { IADComparable<T> }
    function GetComparer: IADComparer<T>; virtual;
    { IADExpandable }
    function GetExpander: IADCollectionExpander; virtual;
    { IADSortedList<T> }
    function GetCount: Integer; virtual;
    function GetIsCompact: Boolean; virtual;
    function GetIsEmpty: Boolean; virtual;
    function GetItem(const AIndex: Integer): T; virtual;

    // Setters
    { IADCompactable }
    procedure SetCompactor(const ACompactor: IADCollectionCompactor); virtual;
    { IADComparable<T> }
    procedure SetComparer(const AComparer: IADComparer<T>); virtual;
    { IADExpandable }
    procedure SetExpander(const AExpander: IADCollectionExpander); virtual;

    // Management Methods
    ///  <summary><c>Adds the Item to the correct Index of the Array WITHOUT checking capacity.</c></summary>
    ///  <returns>
    ///    <para>-1<c> if the Item CANNOT be added.</c></para>
    ///    <para>0 OR GREATER<c> if the Item has be added, where the Value represents the Index of the Item.</c></para>
    ///  </returns>
    function AddActual(const AItem: T): Integer;
    ///  <summary><c>Compacts the Array according to the given Compactor Algorithm.</c></summary>
    procedure CheckCompact(const AAmount: Integer); virtual;
    ///  <summary><c>Expands the Array according to the given Expander Algorithm.</c></summary>
    procedure CheckExpand(const AAmount: Integer); virtual;
    ///  <summary><c>Override to construct an alternative Array type</c></summary>
    procedure CreateArray(const AInitialCapacity: Integer = 0); virtual;
    ///  <summary><c>Determines the Index at which an Item would need to be Inserted for the List to remain in-order.</c></summary>
    ///  <remarks>
    ///    <para><c>This is basically a Binary Sort implementation.<c></para>
    ///  </remarks>
    function GetSortedPosition(const AItem: T): Integer; virtual;
    ///  <summary>Resorts the entire List.</c></summary>
    procedure QuickSort(ALow, AHigh: Integer); virtual;
  public
    ///  <summary><c>Creates an instance of your Sorted List using the Default Expander and Compactor Types.</c></summary>
    constructor Create(const AComparer: IADComparer<T>; const AInitialCapacity: Integer = 0); reintroduce; overload;
    ///  <summary><c>Creates an instance of your Sorted List using a Custom Expander Instance, and the default Compactor Type.</c></summary>
    constructor Create(const AExpander: IADCollectionExpander; const AComparer: IADComparer<T>; const AInitialCapacity: Integer = 0); reintroduce; overload;
    ///  <summary><c>Creates an instance of your Sorted List using the default Expander Type, and a Custom Compactor Instance.</c></summary>
    constructor Create(const ACompactor: IADCollectionCompactor; const AComparer: IADComparer<T>; const AInitialCapacity: Integer = 0); reintroduce; overload;
    ///  <summary><c>Creates an instance of your Sorted List using a Custom Expander and Compactor Instance.</c></summary>
    constructor Create(const AExpander: IADCollectionExpander; const ACompactor: IADCollectionCompactor; const AComparer: IADComparer<T>; const AInitialCapacity: Integer = 0); reintroduce; overload; virtual;
    destructor Destroy; override;

    // Management Methods
    { IADSortedList<T> }
    function Add(const AItem: T): Integer; virtual;
    procedure AddItems(const AItems: Array of T); overload; virtual;
    procedure AddItems(const AList: IADSortedList<T>); overload; virtual;
    procedure Clear; virtual;
    procedure Compact; virtual;
    function Contains(const AItem: T): Boolean; virtual;
    function ContainsAll(const AItems: Array of T): Boolean; virtual;
    function ContainsAny(const AItems: Array of T): Boolean; virtual;
    function ContainsNone(const AItems: Array of T): Boolean; virtual;
    procedure Delete(const AIndex: Integer); overload; virtual;
    procedure DeleteRange(const AFromIndex, ACount: Integer); overload; virtual;
    function EqualItems(const AList: IADSortedList<T>): Boolean; virtual;
    function IndexOf(const AItem: T): Integer; virtual;
    procedure Remove(const AItem: T); virtual;
    procedure RemoveItems(const AItems: Array of T); virtual;

    // Iterators
    { IADIterable<T> }
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure Iterate(const ACallback: TADListItemCallbackAnon<T>; const ADirection: TADIterateDirection = idRight); overload; inline;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure Iterate(const ACallback: TADListItemCallbackOfObject<T>; const ADirection: TADIterateDirection = idRight); overload; inline;
    procedure Iterate(const ACallback: TADListItemCallbackUnbound<T>; const ADirection: TADIterateDirection = idRight); overload; inline;
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure IterateBackward(const ACallback: TADListItemCallbackAnon<T>); overload; virtual;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure IterateBackward(const ACallback: TADListItemCallbackOfObject<T>); overload; virtual;
    procedure IterateBackward(const ACallback: TADListItemCallbackUnbound<T>); overload; virtual;
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure IterateForward(const ACallback: TADListItemCallbackAnon<T>); overload; virtual;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure IterateForward(const ACallback: TADListItemCallbackOfObject<T>); overload; virtual;
    procedure IterateForward(const ACallback: TADListItemCallbackUnbound<T>); overload; virtual;

    // Properties
    { IADCompactable }
    property Compactor: IADCollectionCompactor read GetCompactor write SetCompactor;
    { IADComparable<T> }
    property Comparer: IADComparer<T> read GetComparer write SetComparer;
    { IADExpandable }
    property Expander: IADCollectionExpander read GetExpander write SetExpander;
    { IADSortedList<T> }
    property Count: Integer read GetCount;
    property IsCompact: Boolean read GetIsCompact;
    property IsEmpty: Boolean read GetIsEmpty;
    property Item[const AIndex: Integer]: T read GetItem;
  end;

  ///  <summary><c>Generic Object Sorted List Type</c></summary>
  ///  <remarks>
  ///    <para><c>Can take Ownership of its Items.</c></para>
  ///    <para><c>This type is NOT Threadsafe.</c></para>
  ///  </remarks>
  TADObjectSortedList<T: class> = class(TADSortedList<T>, IADObjectOwner)
  protected
    // Getters
    function GetOwnership: TADOwnership; virtual;
    // Setters
    procedure SetOwnership(const AOwnership: TADOwnership); virtual;
    // Management Methods
    ///  <summary><c>Override to construct an alternative Array type</c></summary>
    procedure CreateArray(const AInitialCapacity: Integer = 0); override;
  public
    // Properties
    property Ownership: TADOwnership read GetOwnership write SetOwnership;
  end;

  ///  <summary><c>Generic Lookup List Type.</c></summary>
  ///  <remarks>
  ///    <para><c></c></para>
  ///  </remarks>
  TADLookupList<TKey, TValue> = class(TADObject, IADLookupList<TKey, TValue>, IADComparable<TKey>, IADIterablePair<TKey, TValue>, IADCompactable, IADExpandable)
  private
    FCompactor: IADCollectionCompactor;
    FComparer: IADComparer<TKey>;
    FExpander: IADCollectionExpander;
    FInitialCapacity: Integer;
  protected
    FArray: IADArray<IADKeyValuePair<TKey, TValue>>;
    // Getters
    { IADCompactable }
    function GetCompactor: IADCollectionCompactor; virtual;
    { IADComparable<T> }
    function GetComparer: IADComparer<TKey>; virtual;
    { IADExpandable }
    function GetExpander: IADCollectionExpander; virtual;
    { IADLookupList<TKey, TValue> }
    function GetCount: Integer; virtual;
    function GetIsCompact: Boolean; virtual;
    function GetIsEmpty: Boolean; virtual;
    function GetItem(const AKey: TKey): TValue; virtual;
    function GetPair(const AIndex: Integer): IADKeyValuePair<TKey, TValue>; virtual;

    // Setters
    { IADCompactable }
    procedure SetCompactor(const ACompactor: IADCollectionCompactor); virtual;
    { IADComparable<T> }
    procedure SetComparer(const AComparer: IADComparer<TKey>); virtual;
    { IADExpandable }
    procedure SetExpander(const AExpander: IADCollectionExpander); virtual;
    { IADLookupList<TKey, TValue> }
  public
    ///  <summary><c>Creates an instance of your Sorted List using the Default Expander and Compactor Types.</c></summary>
    constructor Create(const AComparer: IADComparer<TKey>; const AInitialCapacity: Integer = 0); reintroduce; overload;
    ///  <summary><c>Creates an instance of your Sorted List using a Custom Expander Instance, and the default Compactor Type.</c></summary>
    constructor Create(const AExpander: IADCollectionExpander; const AComparer: IADComparer<TKey>; const AInitialCapacity: Integer = 0); reintroduce; overload;
    ///  <summary><c>Creates an instance of your Sorted List using the default Expander Type, and a Custom Compactor Instance.</c></summary>
    constructor Create(const ACompactor: IADCollectionCompactor; const AComparer: IADComparer<TKey>; const AInitialCapacity: Integer = 0); reintroduce; overload;
    ///  <summary><c>Creates an instance of your Sorted List using a Custom Expander and Compactor Instance.</c></summary>
    constructor Create(const AExpander: IADCollectionExpander; const ACompactor: IADCollectionCompactor; const AComparer: IADComparer<TKey>; const AInitialCapacity: Integer = 0); reintroduce; overload; virtual;
    destructor Destroy; override;

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

    // Iterators
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure Iterate(const ACallback: TADListPairCallbackAnon<TKey, TValue>; const ADirection: TADIterateDirection = idRight); overload; virtual;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure Iterate(const ACallback: TADListPairCallbackOfObject<TKey, TValue>; const ADirection: TADIterateDirection = idRight); overload; virtual;
    procedure Iterate(const ACallback: TADListPairCallbackUnbound<TKey, TValue>; const ADirection: TADIterateDirection = idRight); overload; virtual;
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure IterateBackward(const ACallback: TADListPairCallbackAnon<TKey, TValue>); overload; virtual;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure IterateBackward(const ACallback: TADListPairCallbackOfObject<TKey, TValue>); overload; virtual;
    procedure IterateBackward(const ACallback: TADListPairCallbackUnbound<TKey, TValue>); overload; virtual;
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure IterateForward(const ACallback: TADListPairCallbackAnon<TKey, TValue>); overload; virtual;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure IterateForward(const ACallback: TADListPairCallbackOfObject<TKey, TValue>); overload; virtual;
    procedure IterateForward(const ACallback: TADListPairCallbackUnbound<TKey, TValue>); overload; virtual;

    // Properties
    { IADCompactable }
    property Compactor: IADCollectionCompactor read GetCompactor write SetCompactor;
    { IADComparable<T> }
    property Comparer: IADComparer<TKey> read GetComparer write SetComparer;
    { IADExpandable }
    property Expander: IADCollectionExpander read GetExpander write SetExpander;
    { IADLookupList<TKey, TValue> }
    property Count: Integer read GetCount;
    property IsCompact: Boolean read GetIsCompact;
    property IsEmpty: Boolean read GetIsEmpty;
    property Item[const AKey: TKey]: TValue read GetItem; default;
    property Pair[const AIndex: Integer]: IADKeyValuePair<TKey, TValue> read GetPair;
  end;

implementation

uses
  ADAPT.Generics.Common,
  ADAPT.Generics.Allocators,
  ADAPT.Generics.Arrays;

{ TADSortedList<T> }

function TADSortedList<T>.Add(const AItem: T): Integer;
begin
  CheckExpand(1);
  Result := AddActual(AItem);
end;

procedure TADSortedList<T>.AddItems(const AItems: array of T);
var
  I: Integer;
begin
  CheckExpand(Length(AItems));
  for I := Low(AItems) to High(AItems) do
    AddActual(AItems[I]);
end;

function TADSortedList<T>.AddActual(const AItem: T): Integer;
begin
  // TODO -oDaniel -cTADSortedList<T>: Need to add check to ensure Item not already in List. This MIGHT need to be optional!
  Result := GetSortedPosition(AItem);
  if Result = FCount then
    FArray[FCount] := AItem
  else
    FArray.Insert(AItem, Result);

  Inc(FCount);
end;

procedure TADSortedList<T>.AddItems(const AList: IADSortedList<T>);
var
  I: Integer;
begin
  CheckExpand(AList.Count);
  for I := 0 to AList.Count - 1 do
    AddActual(AList[I]);
end;

procedure TADSortedList<T>.CheckCompact(const AAmount: Integer);
var
  LShrinkBy: Integer;
begin
  LShrinkBy := FCompactor.CheckCompact(FArray.Capacity, FCount, AAmount);
  if LShrinkBy > 0 then
    FArray.Capacity := FArray.Capacity - LShrinkBy;
end;

procedure TADSortedList<T>.CheckExpand(const AAmount: Integer);
var
  LNewCapacity: Integer;
begin
  LNewCapacity := FExpander.CheckExpand(FArray.Capacity, FCount, AAmount);
  if LNewCapacity > 0 then
    FArray.Capacity := FArray.Capacity + LNewCapacity;
end;

procedure TADSortedList<T>.Clear;
begin
//  FArray.Finalize(0, FCount);
  FArray.Clear;
  FCount := 0;
  FArray.Capacity := FInitialCapacity;
end;

procedure TADSortedList<T>.Compact;
begin
  FArray.Capacity := FCount;
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

constructor TADSortedList<T>.Create(const AComparer: IADComparer<T>; const AInitialCapacity: Integer);
begin
  Create(ADCollectionExpanderDefault, ADCollectionCompactorDefault, AComparer, AInitialCapacity);
end;

constructor TADSortedList<T>.Create(const AExpander: IADCollectionExpander; const AComparer: IADComparer<T>; const AInitialCapacity: Integer);
begin
  Create(AExpander, ADCollectionCompactorDefault, AComparer, AInitialCapacity);
end;

constructor TADSortedList<T>.Create(const ACompactor: IADCollectionCompactor; const AComparer: IADComparer<T>; const AInitialCapacity: Integer);
begin
  Create(ADCollectionExpanderDefault, ACompactor, AComparer, AInitialCapacity);
end;

constructor TADSortedList<T>.Create(const AExpander: IADCollectionExpander; const ACompactor: IADCollectionCompactor; const AComparer: IADComparer<T>; const AInitialCapacity: Integer);
begin
  inherited Create;
  FCount := 0;
  FExpander := AExpander;
  FCompactor := ACompactor;
  FComparer := AComparer;
  FInitialCapacity := AInitialCapacity;
  CreateArray(AInitialCapacity);
end;

procedure TADSortedList<T>.CreateArray(const AInitialCapacity: Integer);
begin
  FArray := TADArray<T>.Create(AInitialCapacity);
end;

procedure TADSortedList<T>.Delete(const AIndex: Integer);
begin
  FArray.Delete(AIndex);
  Dec(FCount);
end;

procedure TADSortedList<T>.DeleteRange(const AFromIndex, ACount: Integer);
var
  I: Integer;
begin
  for I := AFromIndex + ACount - 1 downto AFromIndex do
    Delete(I);
end;

destructor TADSortedList<T>.Destroy;
begin

  inherited;
end;

function TADSortedList<T>.EqualItems(const AList: IADSortedList<T>): Boolean;
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

function TADSortedList<T>.GetCompactor: IADCollectionCompactor;
begin
  Result := FCompactor;
end;

function TADSortedList<T>.GetComparer: IADComparer<T>;
begin
  Result := FComparer;
end;

function TADSortedList<T>.GetCount: Integer;
begin
  Result := FCount;
end;

function TADSortedList<T>.GetExpander: IADCollectionExpander;
begin
  Result := FExpander;
end;

function TADSortedList<T>.GetIsCompact: Boolean;
begin
  Result := FArray.Capacity = FCount;
end;

function TADSortedList<T>.GetIsEmpty: Boolean;
begin
  Result := (FCount = 0);
end;

function TADSortedList<T>.GetItem(const AIndex: Integer): T;
begin
  Result := FArray[AIndex];
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

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADSortedList<T>.Iterate(const ACallback: TADListItemCallbackAnon<T>; const ADirection: TADIterateDirection = idRight);
  begin
    case ADirection of
      idLeft: IterateBackward(ACallback);
      idRight: IterateForward(ACallback);
      else
        raise EADGenericsIterateDirectionUnknownException.Create('Unhandled Iterate Direction given.');
    end;
  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADSortedList<T>.Iterate(const ACallback: TADListItemCallbackOfObject<T>; const ADirection: TADIterateDirection);
begin
  case ADirection of
    idLeft: IterateBackward(ACallback);
    idRight: IterateForward(ACallback);
    else
      raise EADGenericsIterateDirectionUnknownException.Create('Unhandled Iterate Direction given.');
  end;
end;

procedure TADSortedList<T>.Iterate(const ACallback: TADListItemCallbackUnbound<T>; const ADirection: TADIterateDirection);
begin
  case ADirection of
    idLeft: IterateBackward(ACallback);
    idRight: IterateForward(ACallback);
    else
      raise EADGenericsIterateDirectionUnknownException.Create('Unhandled Iterate Direction given.');
  end;
end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADSortedList<T>.IterateBackward(const ACallback: TADListItemCallbackAnon<T>);
  var
    I: Integer;
  begin
    for I := FCount - 1 downto 0 do
      ACallback(FArray[I]);
  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADSortedList<T>.IterateBackward(const ACallback: TADListItemCallbackOfObject<T>);
var
  I: Integer;
begin
  for I := FCount - 1 downto 0 do
    ACallback(FArray[I]);
end;

procedure TADSortedList<T>.IterateBackward(const ACallback: TADListItemCallbackUnbound<T>);
var
  I: Integer;
begin
  for I := FCount - 1 downto 0 do
    ACallback(FArray[I]);
end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADSortedList<T>.IterateForward(const ACallback: TADListItemCallbackAnon<T>);
  var
    I: Integer;
  begin
    for I := 0 to FCount - 1 do
      ACallback(FArray[I]);
  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADSortedList<T>.IterateForward(const ACallback: TADListItemCallbackOfObject<T>);
var
  I: Integer;
begin
  for I := 0 to FCount - 1 do
    ACallback(FArray[I]);
end;

procedure TADSortedList<T>.IterateForward(const ACallback: TADListItemCallbackUnbound<T>);
var
  I: Integer;
begin
  for I := 0 to FCount - 1 do
    ACallback(FArray[I]);
end;

procedure TADSortedList<T>.QuickSort(ALow, AHigh: Integer);
var
  I, J: Integer;
  LPivot, LTemp: T;
begin
  if FCount = 0 then
    Exit;

  repeat
    I := ALow;
    J := AHigh;
    LPivot := FArray[ALow + (AHigh - ALow) shr 1];
    repeat

      while FComparer.ALessThanB(FArray[I], LPivot) do
        Inc(I);
      while FComparer.AGreaterThanB(FArray[J], LPivot) do
        Dec(J);

      if I <= J then
      begin
        if I <> J then
        begin
          LTemp := FArray[I];
          FArray[I] := FArray[J];
          FArray[J] := LTemp;
        end;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if ALow < J then
      QuickSort(ALow, J);
    ALow := I;
until I >= AHigh;
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

procedure TADSortedList<T>.SetCompactor(const ACompactor: IADCollectionCompactor);
begin
  FCompactor := ACompactor;
  //TODO -oDaniel -cTADSortedList<T>: Perform a "Smart Compact" here
end;

procedure TADSortedList<T>.SetComparer(const AComparer: IADComparer<T>);
begin
  FComparer := AComparer;
  QuickSort(0, FCount - 1)
end;

procedure TADSortedList<T>.SetExpander(const AExpander: IADCollectionExpander);
begin
  FExpander := AExpander;
end;

{ TADObjectSortedList<T> }

procedure TADObjectSortedList<T>.CreateArray(const AInitialCapacity: Integer);
begin
  FArray := TADObjectArray<T>.Create(oOwnsObjects, AInitialCapacity);
end;

function TADObjectSortedList<T>.GetOwnership: TADOwnership;
begin
  Result := TADObjectArray<T>(FArray).Ownership;
end;

procedure TADObjectSortedList<T>.SetOwnership(const AOwnership: TADOwnership);
begin
  TADObjectArray<T>(FArray).Ownership := AOwnership;
end;

{ TADLookupList<TKey, TValue> }

function TADLookupList<TKey, TValue>.Add(const AKey: TKey; const AValue: TValue): Integer;
begin

end;

function TADLookupList<TKey, TValue>.Add(const AItem: IADKeyValuePair<TKey, TValue>): Integer;
begin

end;

procedure TADLookupList<TKey, TValue>.AddItems(const AItems: array of IADKeyValuePair<TKey, TValue>);
begin

end;

procedure TADLookupList<TKey, TValue>.AddItems(const AList: IADLookupList<TKey, TValue>);
begin

end;

procedure TADLookupList<TKey, TValue>.Clear;
begin

end;

procedure TADLookupList<TKey, TValue>.Compact;
begin

end;

function TADLookupList<TKey, TValue>.Contains(const AKey: TKey): Boolean;
begin

end;

function TADLookupList<TKey, TValue>.ContainsAll(const AKeys: array of TKey): Boolean;
begin

end;

function TADLookupList<TKey, TValue>.ContainsAny(const AKeys: array of TKey): Boolean;
begin

end;

function TADLookupList<TKey, TValue>.ContainsNone(const AKeys: array of TKey): Boolean;
begin

end;

constructor TADLookupList<TKey, TValue>.Create(const ACompactor: IADCollectionCompactor; const AComparer: IADComparer<TKey>; const AInitialCapacity: Integer);
begin

end;

constructor TADLookupList<TKey, TValue>.Create(const AExpander: IADCollectionExpander; const ACompactor: IADCollectionCompactor; const AComparer: IADComparer<TKey>; const AInitialCapacity: Integer);
begin

end;

constructor TADLookupList<TKey, TValue>.Create(const AExpander: IADCollectionExpander; const AComparer: IADComparer<TKey>; const AInitialCapacity: Integer);
begin

end;

constructor TADLookupList<TKey, TValue>.Create(const AComparer: IADComparer<TKey>; const AInitialCapacity: Integer);
begin

end;

procedure TADLookupList<TKey, TValue>.Delete(const AIndex: Integer);
begin

end;

procedure TADLookupList<TKey, TValue>.DeleteRange(const AFromIndex, ACount: Integer);
begin

end;

destructor TADLookupList<TKey, TValue>.Destroy;
begin

  inherited;
end;

function TADLookupList<TKey, TValue>.EqualItems(const AList: IADLookupList<TKey, TValue>): Boolean;
begin

end;

function TADLookupList<TKey, TValue>.GetCompactor: IADCollectionCompactor;
begin

end;

function TADLookupList<TKey, TValue>.GetComparer: IADComparer<TKey>;
begin

end;

function TADLookupList<TKey, TValue>.GetCount: Integer;
begin

end;

function TADLookupList<TKey, TValue>.GetExpander: IADCollectionExpander;
begin

end;

function TADLookupList<TKey, TValue>.GetIsCompact: Boolean;
begin

end;

function TADLookupList<TKey, TValue>.GetIsEmpty: Boolean;
begin

end;

function TADLookupList<TKey, TValue>.GetItem(const AKey: TKey): TValue;
begin

end;

function TADLookupList<TKey, TValue>.GetPair(const AIndex: Integer): IADKeyValuePair<TKey, TValue>;
begin

end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADLookupList<TKey, TValue>.Iterate(const ACallback: TADListPairCallbackAnon<TKey, TValue>; const ADirection: TADIterateDirection = idRight);
  begin

  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADLookupList<TKey, TValue>.Iterate(const ACallback: TADListPairCallbackOfObject<TKey, TValue>; const ADirection: TADIterateDirection);
begin

end;

function TADLookupList<TKey, TValue>.IndexOf(const AKey: TKey): Integer;
begin

end;

procedure TADLookupList<TKey, TValue>.Iterate(const ACallback: TADListPairCallbackUnbound<TKey, TValue>; const ADirection: TADIterateDirection);
begin

end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADLookupList<TKey, TValue>.IterateBackward(const ACallback: TADListPairCallbackAnon<TKey, TValue>);
  begin

  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADLookupList<TKey, TValue>.IterateBackward(const ACallback: TADListPairCallbackOfObject<TKey, TValue>);
begin

end;

procedure TADLookupList<TKey, TValue>.IterateBackward(const ACallback: TADListPairCallbackUnbound<TKey, TValue>);
begin

end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADLookupList<TKey, TValue>.IterateForward(const ACallback: TADListPairCallbackAnon<TKey, TValue>);
  begin

  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADLookupList<TKey, TValue>.IterateForward(const ACallback: TADListPairCallbackOfObject<TKey, TValue>);
begin

end;

procedure TADLookupList<TKey, TValue>.IterateForward(const ACallback: TADListPairCallbackUnbound<TKey, TValue>);
begin

end;

procedure TADLookupList<TKey, TValue>.Remove(const AKey: TKey);
begin

end;

procedure TADLookupList<TKey, TValue>.RemoveItems(const AKeys: array of TKey);
begin

end;

procedure TADLookupList<TKey, TValue>.SetCompactor(const ACompactor: IADCollectionCompactor);
begin

end;

procedure TADLookupList<TKey, TValue>.SetComparer(const AComparer: IADComparer<TKey>);
begin

end;

procedure TADLookupList<TKey, TValue>.SetExpander(const AExpander: IADCollectionExpander);
begin

end;

end.
