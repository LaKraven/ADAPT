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
  ADAPT.Generics.Sorters.Intf,
  ADAPT.Generics.Maps.Intf;

  {$I ADAPT_RTTI.inc}

type
  ///  <summary><c>Generic Map Type.</c></summary>
  ///  <remarks>
  ///    <para><c></c></para>
  ///  </remarks>
  TADMap<TKey, TValue> = class(TADObject, IADMap<TKey, TValue>, IADComparable<TKey>, IADIterablePair<TKey, TValue>, IADMapSortable<TKey, TValue>, IADCompactable, IADExpandable)
  private
    FCompactor: IADCollectionCompactor;
    FComparer: IADComparer<TKey>;
    FExpander: IADCollectionExpander;
    FInitialCapacity: Integer;
    FSorter: IADMapSorter<TKey, TValue>;
  protected
    FArray: IADArray<IADKeyValuePair<TKey, TValue>>;
    FCount: Integer;
    // Getters
    { IADCompactable }
    function GetCompactor: IADCollectionCompactor; virtual;
    { IADComparable<T> }
    function GetComparer: IADComparer<TKey>; virtual;
    { IADExpandable }
    function GetExpander: IADCollectionExpander; virtual;
    { IADMapSortable<TKey, TValue> }
    function GetSorter: IADMapSorter<TKey, TValue>; virtual;
    { IADMap<TKey, TValue> }
    function GetCapacity: Integer; virtual;
    function GetCount: Integer; virtual;
    function GetInitialCapacity: Integer;
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
    { IADMapSortable<TKey, TValue> }
    procedure SetSorter(const ASorter: IADMapSorter<TKey, TValue>); virtual;
    { IADMap<TKey, TValue> }
    procedure SetCapacity(const ACapacity: Integer); virtual;

    // Management Methods
    ///  <summary><c>Adds the Item to the correct Index of the Array WITHOUT checking capacity.</c></summary>
    ///  <returns>
    ///    <para>-1<c> if the Item CANNOT be added.</c></para>
    ///    <para>0 OR GREATER<c> if the Item has be added, where the Value represents the Index of the Item.</c></para>
    ///  </returns>
    function AddActual(const AItem: IADKeyValuePair<TKey, TValue>): Integer;
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
    function GetSortedPosition(const AKey: TKey): Integer; virtual;
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
    function Add(const AItem: IADKeyValuePair<TKey, TValue>): Integer; overload; virtual;
    function Add(const AKey: TKey; const AValue: TValue): Integer; overload; virtual;
    procedure AddItems(const AItems: Array of IADKeyValuePair<TKey, TValue>); overload; virtual;
    procedure AddItems(const AMap: IADMap<TKey, TValue>); overload; virtual;
    procedure Clear; virtual;
    procedure Compact; virtual;
    function Contains(const AKey: TKey): Boolean; virtual;
    function ContainsAll(const AKeys: Array of TKey): Boolean; virtual;
    function ContainsAny(const AKeys: Array of TKey): Boolean; virtual;
    function ContainsNone(const AKeys: Array of TKey): Boolean; virtual;
    procedure Delete(const AIndex: Integer); overload; virtual;
    procedure DeleteRange(const AFromIndex, ACount: Integer); overload; virtual;
    function EqualItems(const AList: IADMapReader<TKey, TValue>): Boolean; virtual;
    function IndexOf(const AKey: TKey): Integer; virtual;
    procedure Remove(const AKey: TKey); virtual;
    procedure RemoveItems(const AKeys: Array of TKey); virtual;

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
    { IADMap<TKey, TValue> }
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
  ADAPT.Generics.Arrays,
  ADAPT.Generics.Sorters;

{ TADMap<TKey, TValue> }

function TADMap<TKey, TValue>.Add(const AItem: IADKeyValuePair<TKey, TValue>): Integer;
begin
  CheckExpand(1);
  Result := AddActual(AItem);
end;

function TADMap<TKey, TValue>.Add(const AKey: TKey; const AValue: TValue): Integer;
var
  LPair: IADKeyValuePair<TKey, TValue>;
begin
  LPair := TADKeyValuePair<TKey, TValue>.Create(AKey, AValue);
  Result := Add(LPair);
end;

function TADMap<TKey, TValue>.AddActual(const AItem: IADKeyValuePair<TKey, TValue>): Integer;
begin
  // TODO -oDaniel -cTADMapList<TKey, TValue>: Need to add check to ensure Item not already in List. This MIGHT need to be optional!
  Result := GetSortedPosition(AItem.Key);
  if Result = FCount then
    FArray[FCount] := AItem
  else
    FArray.Insert(AItem, Result);

  Inc(FCount);
end;

procedure TADMap<TKey, TValue>.AddItems(const AItems: Array of IADKeyValuePair<TKey, TValue>);
var
  I: Integer;
begin
  CheckExpand(Length(AItems));
  for I := Low(AItems) to High(AItems) do
    AddActual(AItems[I]);
end;

procedure TADMap<TKey, TValue>.AddItems(const AMap: IADMap<TKey, TValue>);
var
  I: Integer;
begin
  CheckExpand(AMap.Count);
  for I := 0 to AMap.Count - 1 do
    AddActual(AMap.Pair[I]);
end;

procedure TADMap<TKey, TValue>.CheckCompact(const AAmount: Integer);
var
  LShrinkBy: Integer;
begin
  LShrinkBy := FCompactor.CheckCompact(FArray.Capacity, FCount, AAmount);
  if LShrinkBy > 0 then
    FArray.Capacity := FArray.Capacity - LShrinkBy;
end;

procedure TADMap<TKey, TValue>.CheckExpand(const AAmount: Integer);
var
  LNewCapacity: Integer;
begin
  LNewCapacity := FExpander.CheckExpand(FArray.Capacity, FCount, AAmount);
  if LNewCapacity > 0 then
    FArray.Capacity := FArray.Capacity + LNewCapacity;
end;

procedure TADMap<TKey, TValue>.Clear;
begin
//  FArray.Finalize(0, FCount);
  FArray.Clear;
  FCount := 0;
  FArray.Capacity := FInitialCapacity;
end;

procedure TADMap<TKey, TValue>.Compact;
begin
  FArray.Capacity := FCount;
end;

function TADMap<TKey, TValue>.Contains(const AKey: TKey): Boolean;
var
  LIndex: Integer;
begin
  LIndex := IndexOf(AKey);
  Result := (LIndex > -1);
end;

function TADMap<TKey, TValue>.ContainsAll(const AKeys: array of TKey): Boolean;
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

function TADMap<TKey, TValue>.ContainsAny(const AKeys: array of TKey): Boolean;
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

function TADMap<TKey, TValue>.ContainsNone(const AKeys: array of TKey): Boolean;
begin
  Result := (not ContainsAny(AKeys));
end;

constructor TADMap<TKey, TValue>.Create(const AComparer: IADComparer<TKey>; const AInitialCapacity: Integer);
begin
  Create(ADCollectionExpanderDefault, ADCollectionCompactorDefault, AComparer, AInitialCapacity);
end;

constructor TADMap<TKey, TValue>.Create(const AExpander: IADCollectionExpander; const AComparer: IADComparer<TKey>; const AInitialCapacity: Integer);
begin
  Create(AExpander, ADCollectionCompactorDefault, AComparer, AInitialCapacity);
end;

constructor TADMap<TKey, TValue>.Create(const ACompactor: IADCollectionCompactor; const AComparer: IADComparer<TKey>; const AInitialCapacity: Integer);
begin
  Create(ADCollectionExpanderDefault, ACompactor, AComparer, AInitialCapacity);
end;

constructor TADMap<TKey, TValue>.Create(const AExpander: IADCollectionExpander; const ACompactor: IADCollectionCompactor; const AComparer: IADComparer<TKey>; const AInitialCapacity: Integer);
begin
  inherited Create;
  FCount := 0;
  FExpander := AExpander;
  FCompactor := ACompactor;
  FComparer := AComparer;
  FSorter := TADMapSorterQuick<TKey, TValue>.Create;
  FInitialCapacity := AInitialCapacity;
  CreateArray(AInitialCapacity);
end;

destructor TADMap<TKey, TValue>.Destroy;
begin

  inherited;
end;

procedure TADMap<TKey, TValue>.CreateArray(const AInitialCapacity: Integer);
begin
  FArray := TADArray<IADKeyValuePair<TKey, TValue>>.Create(AInitialCapacity);
end;

procedure TADMap<TKey, TValue>.Delete(const AIndex: Integer);
begin
  FArray.Delete(AIndex);
  Dec(FCount);
end;

procedure TADMap<TKey, TValue>.DeleteRange(const AFromIndex, ACount: Integer);
var
  I: Integer;
begin
  for I := AFromIndex + ACount - 1 downto AFromIndex do
    Delete(I);
end;

function TADMap<TKey, TValue>.EqualItems(const AList: IADMapReader<TKey, TValue>): Boolean;
var
  I: Integer;
begin
  Result := AList.Count = FCount;
  if Result then
    for I := 0 to AList.Count - 1 do
      if (not FComparer.AEqualToB(AList.Pair[I].Key, FArray[I].Key)) then
      begin
        Result := False;
        Break;
      end;
end;

function TADMap<TKey, TValue>.GetCapacity: Integer;
begin
  Result := FArray.Capacity;
end;

function TADMap<TKey, TValue>.GetCompactor: IADCollectionCompactor;
begin
  Result := FCompactor;
end;

function TADMap<TKey, TValue>.GetComparer: IADComparer<TKey>;
begin
  Result := FComparer;
end;

function TADMap<TKey, TValue>.GetCount: Integer;
begin
  Result := FCount;
end;

function TADMap<TKey, TValue>.GetExpander: IADCollectionExpander;
begin
  Result := FExpander;
end;

function TADMap<TKey, TValue>.GetInitialCapacity: Integer;
begin
  Result := FInitialCapacity;
end;

function TADMap<TKey, TValue>.GetIsCompact: Boolean;
begin
  Result := FArray.Capacity = FCount;
end;

function TADMap<TKey, TValue>.GetIsEmpty: Boolean;
begin
  Result := (FCount = 0);
end;

function TADMap<TKey, TValue>.GetItem(const AKey: TKey): TValue;
var
  LIndex: Integer;
begin
  LIndex := IndexOf(AKey);
  if LIndex > -1 then
    Result := FArray[LIndex].Value;
end;

function TADMap<TKey, TValue>.GetPair(const AIndex: Integer): IADKeyValuePair<TKey, TValue>;
begin
  Result := FArray[AIndex];
end;

function TADMap<TKey, TValue>.GetSortedPosition(const AKey: TKey): Integer;
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

function TADMap<TKey, TValue>.GetSorter: IADMapSorter<TKey, TValue>;
begin
  Result := FSorter;
end;

function TADMap<TKey, TValue>.IndexOf(const AKey: TKey): Integer;
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
  procedure TADMap<TKey, TValue>.Iterate(const ACallback: TADListPairCallbackAnon<TKey, TValue>; const ADirection: TADIterateDirection = idRight);
  begin
    case ADirection of
      idLeft: IterateBackward(ACallback);
      idRight: IterateForward(ACallback);
      else
        raise EADGenericsIterateDirectionUnknownException.Create('Unhandled Iterate Direction given.');
    end;
  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADMap<TKey, TValue>.Iterate(const ACallback: TADListPairCallbackOfObject<TKey, TValue>; const ADirection: TADIterateDirection);
begin
  case ADirection of
    idLeft: IterateBackward(ACallback);
    idRight: IterateForward(ACallback);
    else
      raise EADGenericsIterateDirectionUnknownException.Create('Unhandled Iterate Direction given.');
  end;
end;

procedure TADMap<TKey, TValue>.Iterate(const ACallback: TADListPairCallbackUnbound<TKey, TValue>; const ADirection: TADIterateDirection);
begin
  case ADirection of
    idLeft: IterateBackward(ACallback);
    idRight: IterateForward(ACallback);
    else
      raise EADGenericsIterateDirectionUnknownException.Create('Unhandled Iterate Direction given.');
  end;
end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADMap<TKey, TValue>.IterateBackward(const ACallback: TADListPairCallbackAnon<TKey, TValue>);
  var
    I: Integer;
  begin
    for I := FCount - 1 downto 0 do
      ACallback(FArray[I].Key, FArray[I].Value);
  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADMap<TKey, TValue>.IterateBackward(const ACallback: TADListPairCallbackOfObject<TKey, TValue>);
var
  I: Integer;
begin
  for I := FCount - 1 downto 0 do
    ACallback(FArray[I].Key, FArray[I].Value);
end;

procedure TADMap<TKey, TValue>.IterateBackward(const ACallback: TADListPairCallbackUnbound<TKey, TValue>);
var
  I: Integer;
begin
  for I := FCount - 1 downto 0 do
    ACallback(FArray[I].Key, FArray[I].Value);
end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADMap<TKey, TValue>.IterateForward(const ACallback: TADListPairCallbackAnon<TKey, TValue>);
  var
    I: Integer;
  begin
    for I := 0 to FCount - 1 do
      ACallback(FArray[I].Key, FArray[I].Value);
  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADMap<TKey, TValue>.IterateForward(const ACallback: TADListPairCallbackOfObject<TKey, TValue>);
var
  I: Integer;
begin
  for I := 0 to FCount - 1 do
    ACallback(FArray[I].Key, FArray[I].Value);
end;

procedure TADMap<TKey, TValue>.IterateForward(const ACallback: TADListPairCallbackUnbound<TKey, TValue>);
var
  I: Integer;
begin
  for I := 0 to FCount - 1 do
    ACallback(FArray[I].Key, FArray[I].Value);
end;

procedure TADMap<TKey, TValue>.Remove(const AKey: TKey);
var
  LIndex: Integer;
begin
  LIndex := IndexOf(AKey);
  if LIndex > -1 then
    Delete(LIndex);
end;

procedure TADMap<TKey, TValue>.RemoveItems(const AKeys: Array of TKey);
var
  I: Integer;
begin
  for I := Low(AKeys) to High(AKeys) do
    Remove(AKeys[I]);
end;

procedure TADMap<TKey, TValue>.SetCapacity(const ACapacity: Integer);
begin
  if ACapacity < FCount then
    raise EADGenericsCapacityLessThanCount.CreateFmt('Given Capacity of %d insufficient for a List containing %d Items.', [ACapacity, FCount])
  else
    FArray.Capacity := ACapacity;
end;

procedure TADMap<TKey, TValue>.SetCompactor(const ACompactor: IADCollectionCompactor);
begin
  FCompactor := ACompactor;
  CheckCompact(0);
end;

procedure TADMap<TKey, TValue>.SetComparer(const AComparer: IADComparer<TKey>);
begin
  FComparer := AComparer;
  FSorter.Sort(FArray, AComparer, 0, FCount - 1);
end;

procedure TADMap<TKey, TValue>.SetExpander(const AExpander: IADCollectionExpander);
begin
  FExpander := AExpander;
end;

procedure TADMap<TKey, TValue>.SetSorter(const ASorter: IADMapSorter<TKey, TValue>);
begin
  FSorter := ASorter;
end;

end.
