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
  ///  <summary><c>Generic Lookup List Type</c></summary>
  ///  <remarks>
  ///    <para><c>This type is NOT Threadsafe.</c></para>
  ///  </remarks>
  TADLookupList<T> = class(TADObject, IADLookupList<T>, IADComparable<T>, IADCompactable, IADExpandable)
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
    { IADLookupList<T> }
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
    ///  <summary><c>Creates an instance of your Lookup List using the Default Expander and Compactor Types.</c></summary>
    constructor Create(const AComparer: IADComparer<T>; const AInitialCapacity: Integer = 0); reintroduce; overload;
    ///  <summary><c>Creates an instance of your Lookup List using a Custom Expander Instance, and the default Compactor Type.</c></summary>
    constructor Create(const AExpander: IADCollectionExpander; const AComparer: IADComparer<T>; const AInitialCapacity: Integer = 0); reintroduce; overload;
    ///  <summary><c>Creates an instance of your Lookup List using the default Expander Type, and a Custom Compactor Instance.</c></summary>
    constructor Create(const ACompactor: IADCollectionCompactor; const AComparer: IADComparer<T>; const AInitialCapacity: Integer = 0); reintroduce; overload;
    ///  <summary><c>Creates an instance of your Lookup List using a Custom Expander and Compactor Instance.</c></summary>
    constructor Create(const AExpander: IADCollectionExpander; const ACompactor: IADCollectionCompactor; const AComparer: IADComparer<T>; const AInitialCapacity: Integer = 0); reintroduce; overload; virtual;
    destructor Destroy; override;
    // Management Methods
    { IADLookupList<T> }
    function Add(const AItem: T): Integer; virtual;
    procedure AddItems(const AItems: Array of T); overload; virtual;
    procedure AddItems(const AList: IADLookupList<T>); overload; virtual;
    procedure Clear; virtual;
    procedure Compact; virtual;
    function Contains(const AItem: T): Boolean; virtual;
    function ContainsAll(const AItems: Array of T): Boolean; virtual;
    function ContainsAny(const AItems: Array of T): Boolean; virtual;
    function ContainsNone(const AItems: Array of T): Boolean; virtual;
    procedure Delete(const AIndex: Integer); overload; virtual;
    procedure DeleteRange(const AFromIndex, ACount: Integer); overload; virtual;
    function EqualItems(const AList: IADLookupList<T>): Boolean; virtual;
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
      procedure IterateForward(const ACallback: TADListItemCallbackAnon<T>); overload; virtual;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure IterateForward(const ACallback: TADListItemCallbackOfObject<T>); overload; virtual;
    procedure IterateForward(const ACallback: TADListItemCallbackUnbound<T>); overload; virtual;
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure IterateBackward(const ACallback: TADListItemCallbackAnon<T>); overload; virtual;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure IterateBackward(const ACallback: TADListItemCallbackOfObject<T>); overload; virtual;
    procedure IterateBackward(const ACallback: TADListItemCallbackUnbound<T>); overload; virtual;

    // Properties
    { IADCompactable }
    property Compactor: IADCollectionCompactor read GetCompactor write SetCompactor;
    { IADComparable<T> }
    property Comparer: IADComparer<T> read GetComparer write SetComparer;
    { IADExpandable }
    property Expander: IADCollectionExpander read GetExpander write SetExpander;
    { IADLookupList<T> }
    property Count: Integer read GetCount;
    property IsCompact: Boolean read GetIsCompact;
    property IsEmpty: Boolean read GetIsEmpty;
    property Item[const AIndex: Integer]: T read GetItem;
  end;

  ///  <summary><c>Generic Object Lookup List Type</c></summary>
  ///  <remarks>
  ///    <para><c>Can take Ownership of its Items.</c></para>
  ///    <para><c>This type is NOT Threadsafe.</c></para>
  ///  </remarks>
  TADObjectLookupList<T: class> = class(TADLookupList<T>, IADObjectOwner)
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

implementation

uses
  ADAPT.Generics.Common,
  ADAPT.Generics.Allocators,
  ADAPT.Generics.Arrays;

{ TADLookupList<T> }

function TADLookupList<T>.Add(const AItem: T): Integer;
begin
  CheckExpand(1);
  Result := AddActual(AItem);
end;

procedure TADLookupList<T>.AddItems(const AItems: array of T);
var
  I: Integer;
begin
  CheckExpand(Length(AItems));
  for I := Low(AItems) to High(AItems) do
    AddActual(AItems[I]);
end;

function TADLookupList<T>.AddActual(const AItem: T): Integer;
begin
  // TODO -oDaniel -cTADLookupList<T>: Need to add check to ensure Item not already in List. This MIGHT need to be optional!
  Result := GetSortedPosition(AItem);
  if Result = FCount then
    FArray[FCount] := AItem
  else
    FArray.Insert(AItem, Result);

  Inc(FCount);
end;

procedure TADLookupList<T>.AddItems(const AList: IADLookupList<T>);
var
  I: Integer;
begin
  CheckExpand(AList.Count);
  for I := 0 to AList.Count - 1 do
    AddActual(AList[I]);
end;

procedure TADLookupList<T>.CheckCompact(const AAmount: Integer);
var
  LShrinkBy: Integer;
begin
  LShrinkBy := FCompactor.CheckCompact(FArray.Capacity, FCount, AAmount);
  if LShrinkBy > 0 then
    FArray.Capacity := FArray.Capacity - LShrinkBy;
end;

procedure TADLookupList<T>.CheckExpand(const AAmount: Integer);
var
  LNewCapacity: Integer;
begin
  LNewCapacity := FExpander.CheckExpand(FArray.Capacity, FCount, AAmount);
  if LNewCapacity > 0 then
    FArray.Capacity := FArray.Capacity + LNewCapacity;
end;

procedure TADLookupList<T>.Clear;
begin
//  FArray.Finalize(0, FCount);
  FArray.Clear;
  FCount := 0;
  FArray.Capacity := FInitialCapacity;
end;

procedure TADLookupList<T>.Compact;
begin
  FArray.Capacity := FCount;
end;

function TADLookupList<T>.Contains(const AItem: T): Boolean;
var
  LIndex: Integer;
begin
  LIndex := IndexOf(AItem);
  Result := (LIndex > -1);
end;

function TADLookupList<T>.ContainsAll(const AItems: array of T): Boolean;
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

function TADLookupList<T>.ContainsAny(const AItems: array of T): Boolean;
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

function TADLookupList<T>.ContainsNone(const AItems: array of T): Boolean;
begin
  Result := (not ContainsAny(AItems));
end;

constructor TADLookupList<T>.Create(const AComparer: IADComparer<T>; const AInitialCapacity: Integer);
begin
  Create(ADCollectionExpanderDefault, ADCollectionCompactorDefault, AComparer, AInitialCapacity);
end;

constructor TADLookupList<T>.Create(const AExpander: IADCollectionExpander; const AComparer: IADComparer<T>; const AInitialCapacity: Integer);
begin
  Create(AExpander, ADCollectionCompactorDefault, AComparer, AInitialCapacity);
end;

constructor TADLookupList<T>.Create(const ACompactor: IADCollectionCompactor; const AComparer: IADComparer<T>; const AInitialCapacity: Integer);
begin
  Create(ADCollectionExpanderDefault, ACompactor, AComparer, AInitialCapacity);
end;

constructor TADLookupList<T>.Create(const AExpander: IADCollectionExpander; const ACompactor: IADCollectionCompactor; const AComparer: IADComparer<T>; const AInitialCapacity: Integer);
begin
  inherited Create;
  FCount := 0;
  FExpander := AExpander;
  FCompactor := ACompactor;
  FComparer := AComparer;
  FInitialCapacity := AInitialCapacity;
  CreateArray(AInitialCapacity);
end;

procedure TADLookupList<T>.CreateArray(const AInitialCapacity: Integer);
begin
  FArray := TADArray<T>.Create(AInitialCapacity);
end;

procedure TADLookupList<T>.Delete(const AIndex: Integer);
begin
  FArray.Delete(AIndex);
  Dec(FCount);
end;

procedure TADLookupList<T>.DeleteRange(const AFromIndex, ACount: Integer);
var
  I: Integer;
begin
  for I := AFromIndex + ACount - 1 downto AFromIndex do
    Delete(I);
end;

destructor TADLookupList<T>.Destroy;
begin

  inherited;
end;

function TADLookupList<T>.EqualItems(const AList: IADLookupList<T>): Boolean;
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

function TADLookupList<T>.GetCompactor: IADCollectionCompactor;
begin
  Result := FCompactor;
end;

function TADLookupList<T>.GetComparer: IADComparer<T>;
begin
  Result := FComparer;
end;

function TADLookupList<T>.GetCount: Integer;
begin
  Result := FCount;
end;

function TADLookupList<T>.GetExpander: IADCollectionExpander;
begin
  Result := FExpander;
end;

function TADLookupList<T>.GetIsCompact: Boolean;
begin
  Result := FArray.Capacity = FCount;
end;

function TADLookupList<T>.GetIsEmpty: Boolean;
begin
  Result := (FCount = 0);
end;

function TADLookupList<T>.GetItem(const AIndex: Integer): T;
begin
  Result := FArray[AIndex];
end;

function TADLookupList<T>.GetSortedPosition(const AItem: T): Integer;
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

function TADLookupList<T>.IndexOf(const AItem: T): Integer;
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
  procedure TADLookupList<T>.Iterate(const ACallback: TADListItemCallbackAnon<T>; const ADirection: TADIterateDirection = idRight);
  begin
    case ADirection of
      idLeft: IterateBackward(ACallback);
      idRight: IterateForward(ACallback);
      else
        raise EADGenericsIterateDirectionUnknownException.Create('Unhandled Iterate Direction given.');
    end;
  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADLookupList<T>.Iterate(const ACallback: TADListItemCallbackOfObject<T>; const ADirection: TADIterateDirection);
begin
  case ADirection of
    idLeft: IterateBackward(ACallback);
    idRight: IterateForward(ACallback);
    else
      raise EADGenericsIterateDirectionUnknownException.Create('Unhandled Iterate Direction given.');
  end;
end;

procedure TADLookupList<T>.Iterate(const ACallback: TADListItemCallbackUnbound<T>; const ADirection: TADIterateDirection);
begin
  case ADirection of
    idLeft: IterateBackward(ACallback);
    idRight: IterateForward(ACallback);
    else
      raise EADGenericsIterateDirectionUnknownException.Create('Unhandled Iterate Direction given.');
  end;
end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADLookupList<T>.IterateBackward(const ACallback: TADListItemCallbackAnon<T>);
  var
    I: Integer;
  begin
    for I := FCount - 1 downto 0 do
      ACallback(FArray[I]);
  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADLookupList<T>.IterateBackward(const ACallback: TADListItemCallbackOfObject<T>);
var
  I: Integer;
begin
  for I := FCount - 1 downto 0 do
    ACallback(FArray[I]);
end;

procedure TADLookupList<T>.IterateBackward(const ACallback: TADListItemCallbackUnbound<T>);
var
  I: Integer;
begin
  for I := FCount - 1 downto 0 do
    ACallback(FArray[I]);
end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADLookupList<T>.IterateForward(const ACallback: TADListItemCallbackAnon<T>);
  var
    I: Integer;
  begin
    for I := 0 to FCount - 1 do
      ACallback(FArray[I]);
  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADLookupList<T>.IterateForward(const ACallback: TADListItemCallbackOfObject<T>);
var
  I: Integer;
begin
  for I := 0 to FCount - 1 do
    ACallback(FArray[I]);
end;

procedure TADLookupList<T>.IterateForward(const ACallback: TADListItemCallbackUnbound<T>);
var
  I: Integer;
begin
  for I := 0 to FCount - 1 do
    ACallback(FArray[I]);
end;

procedure TADLookupList<T>.QuickSort(ALow, AHigh: Integer);
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

procedure TADLookupList<T>.Remove(const AItem: T);
var
  LIndex: Integer;
begin
  LIndex := IndexOf(AItem);
  if LIndex > -1 then
    Delete(LIndex);
end;

procedure TADLookupList<T>.RemoveItems(const AItems: array of T);
var
  I: Integer;
begin
  for I := Low(AItems) to High(AItems) do
    Remove(AItems[I]);
end;

procedure TADLookupList<T>.SetCompactor(const ACompactor: IADCollectionCompactor);
begin
  FCompactor := ACompactor;
  //TODO -oDaniel -cTADLookupList<T>: Perform a "Smart Compact" here
end;

procedure TADLookupList<T>.SetComparer(const AComparer: IADComparer<T>);
begin
  FComparer := AComparer;
  QuickSort(0, FCount - 1)
end;

procedure TADLookupList<T>.SetExpander(const AExpander: IADCollectionExpander);
begin
  FExpander := AExpander;
end;

{ TADObjectLookupList<T> }

procedure TADObjectLookupList<T>.CreateArray(const AInitialCapacity: Integer);
begin
  FArray := TADObjectArray<T>.Create(oOwnsObjects, AInitialCapacity);
end;

function TADObjectLookupList<T>.GetOwnership: TADOwnership;
begin
  Result := TADObjectArray<T>(FArray).Ownership;
end;

procedure TADObjectLookupList<T>.SetOwnership(const AOwnership: TADOwnership);
begin
  TADObjectArray<T>(FArray).Ownership := AOwnership;
end;

end.
