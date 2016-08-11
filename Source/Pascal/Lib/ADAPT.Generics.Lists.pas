{
  AD.A.P.T. Library
  Copyright (C) 2014-2016, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Generics.Lists;

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
  ADAPT.Generics.Sorters.Intf,
  ADAPT.Generics.Arrays.Intf,
  ADAPT.Generics.Lists.Intf;

  {$I ADAPT_RTTI.inc}

type
  ///  <summary><c>Generic List Type</c></summary>
  ///  <remarks>
  ///    <para><c>This type is NOT Threadsafe.</c></para>
  ///  </remarks>
  TADList<T> = class(TADObject, IADList<T>, IADIterable<T>, IADListSortable<T>, IADExpandable, IADCompactable)
  private
    FCompactor: IADCollectionCompactor;
    FExpander: IADCollectionExpander;
    FInitialCapacity: Integer;
    FSorter: IADListSorter<T>;
  protected
    FArray: IADArray<T>;
    FCount: Integer;

    // Getters
    { IADCompactable }
    function GetCompactor: IADCollectionCompactor; virtual;
    { IADExpandable }
    function GetExpander: IADCollectionExpander; virtual;
    { IADListSortable<T> }
    function GetSorter: IADListSorter<T>; virtual;
    { IADList<T> }
    function GetCapacity: Integer; virtual;
    function GetCount: Integer; virtual;
    function GetInitialCapacity: Integer; virtual;
    function GetItem(const AIndex: Integer): T; virtual;

    // Setters
    { IADCompactable }
    procedure SetCompactor(const ACompactor: IADCollectionCompactor); virtual;
    { IADExpandable }
    procedure SetExpander(const AExpander: IADCollectionExpander); virtual;
    { IADListSortable<T> }
    procedure SetSorter(const ASorter: IADListSorter<T>); virtual;
    { IADList<T> }
    procedure SetCapacity(const ACapacity: Integer); virtual;
    procedure SetItem(const AIndex: Integer; const AItem: T); virtual;

    // Management Methods
    ///  <summary><c>Adds the Item to the first available Index of the Array WITHOUT checking capacity.</c></summary>
    procedure AddActual(const AItem: T);
    ///  <summary><c>Override to construct an alternative Array type</c></summary>
    procedure CreateArray(const AInitialCapacity: Integer = 0); virtual;
    ///  <summary><c>Compacts the Array according to the given Compactor Algorithm.</c></summary>
    procedure CheckCompact(const AAmount: Integer); virtual;
    ///  <summary><c>Expands the Array according to the given Expander Algorithm.</c></summary>
    procedure CheckExpand(const AAmount: Integer); virtual;
  public
    ///  <summary><c>Creates an instance of your List using the Default Expander and Compactor Types.</c></summary>
    constructor Create(const AInitialCapacity: Integer = 0); reintroduce; overload;
    ///  <summary><c>Creates an instance of your List using a Custom Expander Instance, and the default Compactor Type.</c></summary>
    constructor Create(const AExpander: IADCollectionExpander; const AInitialCapacity: Integer = 0); reintroduce; overload;
    ///  <summary><c>Creates an instance of your List using the default Expander Type, and a Custom Compactor Instance.</c></summary>
    constructor Create(const ACompactor: IADCollectionCompactor; const AInitialCapacity: Integer = 0); reintroduce; overload;
    ///  <summary><c>Creates an instance of your List using a Custom Expander and Compactor Instance.</c></summary>
    constructor Create(const AExpander: IADCollectionExpander; const ACompactor: IADCollectionCompactor; const AInitialCapacity: Integer = 0); reintroduce; overload; virtual;
    destructor Destroy; override;
    // Management Methods
    procedure Add(const AItem: T); overload; virtual;
    procedure Add(const AList: IADList<T>); overload; virtual;
    procedure AddItems(const AItems: Array of T); virtual;
    procedure Clear; virtual;
    procedure Delete(const AIndex: Integer); virtual;
    procedure DeleteRange(const AFirst, ACount: Integer); virtual;
    procedure Insert(const AItem: T; const AIndex: Integer); virtual;
    procedure InsertItems(const AItems: Array of T; const AIndex: Integer); virtual;
    procedure Sort(const AComparer: IADComparer<T>); virtual;
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
    property Compactor: IADCollectionCompactor read GetCompactor;
    { IADExpandable }
    property Expander: IADCollectionExpander read GetExpander;
    { IADList<T> }
    property Capacity: Integer read GetCapacity write SetCapacity;
    property Count: Integer read GetCount;
    property InitialCapacity: Integer read GetInitialCapacity;
    property Items[const AIndex: Integer]: T read GetItem write SetItem; default;
  end;

  ///  <summary><c>Generic Object List Type</c></summary>
  ///  <remarks>
  ///    <para><c>Can take Ownership of its Items.</c></para>
  ///    <para><c>This type is NOT Threadsafe.</c></para>
  ///  </remarks>
  TADObjectList<T: class> = class(TADList<T>, IADObjectOwner)
  protected
    // Getters
    function GetOwnership: TADOwnership; virtual;
    // Setters
    procedure SetOwnership(const AOwnership: TADOwnership); virtual;
    // Management Methods
    ///  <summary><c>We need a TADObjectArray instead.</c></summary>
    procedure CreateArray(const AInitialCapacity: Integer = 0); override;
  public
    ///  <summary><c>Creates an instance of your List using the Default Expander and Compactor Types.</c></summary>
    constructor Create(const AInitialCapacity: Integer = 0; const AOwnership: TADOwnership = oOwnsObjects); reintroduce; overload;
    ///  <summary><c>Creates an instance of your List using a Custom Expander Instance, and the default Compactor Type.</c></summary>
    constructor Create(const AExpander: IADCollectionExpander; const AInitialCapacity: Integer = 0; const AOwnership: TADOwnership = oOwnsObjects); reintroduce; overload;
    ///  <summary><c>Creates an instance of your List using the default Expander Type, and a Custom Compactor Instance.</c></summary>
    constructor Create(const ACompactor: IADCollectionCompactor; const AInitialCapacity: Integer = 0; const AOwnership: TADOwnership = oOwnsObjects); reintroduce; overload;
    ///  <summary><c>Creates an instance of your List using a Custom Expander and Compactor Instance.</c></summary>
    constructor Create(const AExpander: IADCollectionExpander; const ACompactor: IADCollectionCompactor; const AInitialCapacity: Integer = 0; const AOwnership: TADOwnership = oOwnsObjects); reintroduce; overload; virtual;

    // Properties
    property Ownership: TADOwnership read GetOwnership write SetOwnership;
  end;

  ///  <summary><c>A Generic Fixed-Capacity Revolving List</c></summary>
  ///  <remarks>
  ///    <para><c>When the current Index is equal to the Capacity, the Index resets to 0, and items are subsequently Replaced by new ones.</c></para>
  ///    <para><c>This type is NOT Threadsafe.</c></para>
  ///  </remarks>
  TADCircularList<T> = class(TADObject, IADCircularList<T>, IADIterable<T>)
  private
    FCount: Integer;
    FIndex: Integer;
    FItems: IADArray<T>;
    // Getters
    function GetCapacity: Integer;
  protected
    // Getters
    function GetCount: Integer; virtual;
    function GetItem(const AIndex: Integer): T; virtual;
    function GetNewest: T; virtual;
    function GetNewestIndex: Integer; virtual;
    function GetOldest: T; virtual;
    function GetOldestIndex: Integer; virtual;
    // Setters
    procedure SetItem(const AIndex: Integer; const AItem: T); virtual;
    // Management Methods
    function AddActual(const AItem: T): Integer;
    procedure CreateItemArray(const ACapacity: Integer); virtual;
  public
    constructor Create(const ACapacity: Integer); reintroduce; virtual;
    destructor Destroy; override;
    // Management Methods
    function Add(const AItem: T): Integer; virtual;
    procedure AddItems(const AItems: Array of T); virtual;
    procedure Clear; virtual;
    procedure Delete(const AIndex: Integer); virtual;
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
    property Capacity: Integer read GetCapacity;
    property Count: Integer read GetCount;
    property Items[const AIndex: Integer]:  T read GetItem write SetItem;
    property Newest: T read GetNewest;
    property NewestIndex: Integer read GetNewestIndex;
    property Oldest: T read GetOldest;
    property OldestIndex: Integer read GetOldestIndex;
  end;

  ///  <summary><c>A Generic Fixed-Capacity Revolving Object List</c></summary>
  ///  <remarks>
  ///    <para><c>When the current Index is equal to the Capacity, the Index resets to 0, and items are subsequently Replaced by new ones.</c></para>
  ///    <para><c>Can take Ownership of its Items.</c></para>
  ///    <para><c>This type is NOT Threadsafe.</c></para>
  ///  </remarks>
  TADCircularObjectList<T: class> = class(TADCircularList<T>, IADObjectOwner)
  private
    FDefaultOwnership: TADOwnership;
  protected
    // Getters
    function GetOwnership: TADOwnership; virtual;
    // Setters
    procedure SetOwnership(const AOwnership: TADOwnership); virtual;
  protected
    procedure CreateItemArray(const ACapacity: Integer); override;
  public
    constructor Create(const AOwnership: TADOwnership; const ACapacity: Integer); reintroduce; virtual;
    destructor Destroy; override;
  end;

implementation

uses
  ADAPT.Generics.Common,
  ADAPT.Generics.Allocators,
  ADAPT.Generics.Sorters,
  ADAPT.Generics.Arrays;

{ TADList<T> }

constructor TADList<T>.Create(const AInitialCapacity: Integer = 0);
begin
  Create(ADCollectionExpanderDefault, ADCollectionCompactorDefault, AInitialCapacity);
end;

constructor TADList<T>.Create(const AExpander: IADCollectionExpander; const AInitialCapacity: Integer = 0);
begin
  Create(AExpander, ADCollectionCompactorDefault, AInitialCapacity);
end;

constructor TADList<T>.Create(const ACompactor: IADCollectionCompactor; const AInitialCapacity: Integer = 0);
begin
  Create(ADCollectionExpanderDefault, ACompactor, AInitialCapacity);
end;

constructor TADList<T>.Create(const AExpander: IADCollectionExpander; const ACompactor: IADCollectionCompactor; const AInitialCapacity: Integer = 0);
begin
  inherited Create;
  FCount := 0;
  FCompactor := ACompactor;
  FExpander := AExpander;
  FInitialCapacity := AInitialCapacity;
  CreateArray(AInitialCapacity);
  FSorter := TADListSorterQuick<T>.Create;
end;

destructor TADList<T>.Destroy;
begin
  FExpander := nil;
  FCompactor := nil;
  inherited;
end;

procedure TADList<T>.Add(const AItem: T);
begin
  CheckExpand(1);
  AddActual(AItem);
end;

procedure TADList<T>.Add(const AList: IADList<T>);
var
  I: Integer;
begin
  CheckExpand(AList.Count);
  for I := 0 to AList.Count - 1 do
    AddActual(AList[I]);
end;

procedure TADList<T>.AddActual(const AItem: T);
begin
  FArray[FCount] := AItem;
  Inc(FCount);
end;

procedure TADList<T>.AddItems(const AItems: Array of T);
var
  I: Integer;
begin
  CheckExpand(Length(AItems));
  for I := Low(AItems) to High(AItems) do
    AddActual(AItems[I]);
end;

procedure TADList<T>.CheckCompact(const AAmount: Integer);
var
  LShrinkBy: Integer;
begin
  LShrinkBy := FCompactor.CheckCompact(FArray.Capacity, FCount, AAmount);
  if LShrinkBy > 0 then
    FArray.Capacity := FArray.Capacity - LShrinkBy;
end;

procedure TADList<T>.CheckExpand(const AAmount: Integer);
var
  LNewCapacity: Integer;
begin
  LNewCapacity := FExpander.CheckExpand(FArray.Capacity, FCount, AAmount);
  if LNewCapacity > 0 then
    FArray.Capacity := FArray.Capacity + LNewCapacity;
end;

procedure TADList<T>.Clear;
begin
  FArray.Finalize(0, FCount);
  FCount := 0;
  FArray.Capacity := FInitialCapacity;
end;

procedure TADList<T>.CreateArray(const AInitialCapacity: Integer = 0);
begin
  FArray := TADArray<T>.Create(AInitialCapacity);
end;

procedure TADList<T>.Delete(const AIndex: Integer);
begin
  FArray.Finalize(AIndex, 1);
  if AIndex < FCount - 1 then
    FArray.Move(AIndex + 1, AIndex, FCount - AIndex); // Shift all subsequent items left by 1
  Dec(FCount);
  CheckCompact(1);
end;

procedure TADList<T>.DeleteRange(const AFirst, ACount: Integer);
begin
  FArray.Finalize(AFirst, ACount);
  if AFirst + FCount < FCount - 1 then
    FArray.Move(AFirst + FCount + 1, AFirst, ACount); // Shift all subsequent items left
  Dec(FCount, ACount);
  CheckCompact(ACount);
end;

function TADList<T>.GetCapacity: Integer;
begin
  Result := FArray.Capacity;
end;

function TADList<T>.GetCompactor: IADCollectionCompactor;
begin
  Result := FCompactor;
end;

function TADList<T>.GetCount: Integer;
begin
  Result := FCount;
end;

function TADList<T>.GetExpander: IADCollectionExpander;
begin
  Result := FExpander;
end;

function TADList<T>.GetInitialCapacity: Integer;
begin
  Result := FInitialCapacity;
end;

function TADList<T>.GetItem(const AIndex: Integer): T;
begin
  Result := FArray[AIndex];
end;

function TADList<T>.GetSorter: IADListSorter<T>;
begin
  Result := FSorter;
end;

procedure TADList<T>.Insert(const AItem: T; const AIndex: Integer);
begin
  //TODO -oDaniel -cTADList<T>: Implement Insert method
end;

procedure TADList<T>.InsertItems(const AItems: Array of T; const AIndex: Integer);
begin
  //TODO -oDaniel -cTADList<T>: Implement InsertItems method
end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADList<T>.Iterate(const ACallback: TADListItemCallbackAnon<T>; const ADirection: TADIterateDirection = idRight);
  begin
    case ADirection of
      idLeft: IterateBackward(ACallback);
      idRight: IterateForward(ACallback);
      else
        raise EADGenericsIterateDirectionUnknownException.Create('Unhandled Iterate Direction given.');
    end;
  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADList<T>.Iterate(const ACallback: TADListItemCallbackOfObject<T>; const ADirection: TADIterateDirection);
begin
  case ADirection of
    idLeft: IterateBackward(ACallback);
    idRight: IterateForward(ACallback);
    else
      raise EADGenericsIterateDirectionUnknownException.Create('Unhandled Iterate Direction given.');
  end;
end;

procedure TADList<T>.Iterate(const ACallback: TADListItemCallbackUnbound<T>; const ADirection: TADIterateDirection);
begin
  case ADirection of
    idLeft: IterateBackward(ACallback);
    idRight: IterateForward(ACallback);
    else
      raise EADGenericsIterateDirectionUnknownException.Create('Unhandled Iterate Direction given.');
  end;
end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADList<T>.IterateBackward(const ACallback: TADListItemCallbackAnon<T>);
  var
    I: Integer;
  begin
    for I := FCount - 1 downto 0 do
      ACallback(FArray[I]);
  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADList<T>.IterateBackward(const ACallback: TADListItemCallbackOfObject<T>);
var
  I: Integer;
begin
  for I := FCount - 1 downto 0 do
    ACallback(FArray[I]);
end;

procedure TADList<T>.IterateBackward(const ACallback: TADListItemCallbackUnbound<T>);
var
  I: Integer;
begin
  for I := FCount - 1 downto 0 do
    ACallback(FArray[I]);
end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADList<T>.IterateForward(const ACallback: TADListItemCallbackAnon<T>);
  var
    I: Integer;
  begin
    for I := 0 to FCount - 1 do
      ACallback(FArray[I]);
  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADList<T>.IterateForward(const ACallback: TADListItemCallbackOfObject<T>);
var
  I: Integer;
begin
  for I := 0 to FCount - 1 do
    ACallback(FArray[I]);
end;

procedure TADList<T>.IterateForward(const ACallback: TADListItemCallbackUnbound<T>);
var
  I: Integer;
begin
  for I := 0 to FCount - 1 do
    ACallback(FArray[I]);
end;

procedure TADList<T>.SetCapacity(const ACapacity: Integer);
begin
  if ACapacity < FCount then
    raise EADGenericsCapacityLessThanCount.CreateFmt('Given Capacity of %d insufficient for a List containing %d Items.', [ACapacity, FCount])
  else
    FArray.Capacity := ACapacity;
end;

procedure TADList<T>.SetCompactor(const ACompactor: IADCollectionCompactor);
begin
  if ACompactor = nil then
    raise EADGenericsCompactorNilException.Create('Cannot assign a Nil Compactor.')
  else
    FCompactor := ACompactor;
end;

procedure TADList<T>.SetExpander(const AExpander: IADCollectionExpander);
begin
  if AExpander = nil then
    raise EADGenericsExpanderNilException.Create('Cannot assign a Nil Expander.')
  else
    FExpander := AExpander;
end;

procedure TADList<T>.SetItem(const AIndex: Integer; const AItem: T);
begin
  FArray[AIndex] := AItem;
end;

procedure TADList<T>.SetSorter(const ASorter: IADListSorter<T>);
begin
  FSorter := ASorter;
end;

procedure TADList<T>.Sort(const AComparer: IADComparer<T>);
begin
  FSorter.Sort(FArray, AComparer, 0, FCount - 1);
end;

{ TADObjectList<T> }

constructor TADObjectList<T>.Create(const AInitialCapacity: Integer; const AOwnership: TADOwnership);
begin
  Create(ADCollectionExpanderDefault, ADCollectionCompactorDefault, AInitialCapacity, AOwnership);
end;

constructor TADObjectList<T>.Create(const ACompactor: IADCollectionCompactor; const AInitialCapacity: Integer; const AOwnership: TADOwnership);
begin
  Create(ADCollectionExpanderDefault, ACompactor, AInitialCapacity, AOwnership);
end;

constructor TADObjectList<T>.Create(const AExpander: IADCollectionExpander; const AInitialCapacity: Integer; const AOwnership: TADOwnership);
begin
  Create(AExpander, ADCollectionCompactorDefault, AInitialCapacity, AOwnership);
end;

constructor TADObjectList<T>.Create(const AExpander: IADCollectionExpander; const ACompactor: IADCollectionCompactor; const AInitialCapacity: Integer; const AOwnership: TADOwnership);
begin
  inherited Create(AExpander, ACompactor, AInitialCapacity);
  TADObjectArray<T>(FArray).Ownership := AOwnership;
end;

procedure TADObjectList<T>.CreateArray(const AInitialCapacity: Integer = 0);
begin
  FArray := TADObjectArray<T>.Create(oOwnsObjects, AInitialCapacity);
end;

function TADObjectList<T>.GetOwnership: TADOwnership;
begin
  Result := TADObjectArray<T>(FArray).Ownership;
end;

procedure TADObjectList<T>.SetOwnership(const AOwnership: TADOwnership);
begin
  TADObjectArray<T>(FArray).Ownership := AOwnership;
end;

{ TADCircularList<T> }

function TADCircularList<T>.Add(const AItem: T): Integer;
begin
  Result := AddActual(AItem);
end;

function TADCircularList<T>.AddActual(const AItem: T): Integer;
begin
  Result := FIndex;
  if FIndex <= FCount then
    FItems.Finalize(FIndex, 1);
  FItems[FIndex] := AItem;
  Inc(FIndex);
  if FIndex > FItems.Capacity - 1 then
    FIndex := 0;
  if FCount <= FItems.Capacity - 1 then
    Inc(FCount);
end;

procedure TADCircularList<T>.AddItems(const AItems: array of T);
var
  I: Integer;
begin
  for I := Low(AItems) to High(AItems) do
    AddActual(AItems[I]);
end;

procedure TADCircularList<T>.Clear;
begin
  FItems.Clear;
  FCount := 0;
  FIndex := 0;
end;

constructor TADCircularList<T>.Create(const ACapacity: Integer);
begin
  inherited Create;
  CreateItemArray(ACapacity);
  FCount := 0;
  FIndex := 0;
end;

procedure TADCircularList<T>.CreateItemArray(const ACapacity: Integer);
begin
  FItems := TADArray<T>.Create(ACapacity);
end;

procedure TADCircularList<T>.Delete(const AIndex: Integer);
begin
  FItems.Finalize(AIndex, 1); // Finalize the item at the specified Index
  if AIndex < FItems.Capacity then
    FItems.Move(AIndex + 1, AIndex, FCount - AIndex); // Shift all subsequent items left by 1
  Dec(FCount); // Decrement the Count
  if AIndex <= FIndex then
    Dec(FIndex); // Shift the Index back by 1
end;

destructor TADCircularList<T>.Destroy;
begin
  inherited;
end;

function TADCircularList<T>.GetCapacity: Integer;
begin
  Result := FItems.Capacity;
end;

function TADCircularList<T>.GetCount: Integer;
begin
  Result := FCount;
end;

function TADCircularList<T>.GetItem(const AIndex: Integer): T;
begin
  Result := FItems[AIndex]; // Index Validation is now performed by TADArray<T>.GetItem
end;

function TADCircularList<T>.GetNewest: T;
var
  LIndex: Integer;
begin
  LIndex := GetNewestIndex;
  if LIndex > -1 then
    Result := FItems[LIndex];
end;

function TADCircularList<T>.GetNewestIndex: Integer;
begin
  if FCount > 0 then
  begin
    Result := FIndex - 1;
    if Result = -1 then
      Result := FItems.Capacity - 1;
  end else
    Result := -1;
end;

function TADCircularList<T>.GetOldest: T;
var
  LIndex: Integer;
begin
  LIndex := GetOldestIndex;
  if LIndex > -1 then
    Result := FItems[LIndex];
end;

function TADCircularList<T>.GetOldestIndex: Integer;
begin
  if FCount > 0 then
  begin
    Result := FIndex;
    if Result > FCount - 1 then
      Result := 0;
  end else
    Result := -1;
end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADCircularList<T>.Iterate(const ACallback: TADListItemCallbackAnon<T>; const ADirection: TADIterateDirection = idRight);
  begin
    case ADirection of
      idLeft: IterateBackward(ACallback);
      idRight: IterateForward(ACallback);
      else
        raise EADGenericsIterateDirectionUnknownException.Create('Unhandled Iterate Direction given.');
    end;
  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADCircularList<T>.Iterate(const ACallback: TADListItemCallbackOfObject<T>; const ADirection: TADIterateDirection);
begin
  case ADirection of
    idLeft: IterateBackward(ACallback);
    idRight: IterateForward(ACallback);
    else
      raise EADGenericsIterateDirectionUnknownException.Create('Unhandled Iterate Direction given.');
  end;
end;

procedure TADCircularList<T>.Iterate(const ACallback: TADListItemCallbackUnbound<T>; const ADirection: TADIterateDirection);
begin
  case ADirection of
    idLeft: IterateBackward(ACallback);
    idRight: IterateForward(ACallback);
    else
      raise EADGenericsIterateDirectionUnknownException.Create('Unhandled Iterate Direction given.');
  end;
end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADCircularList<T>.IterateBackward(const ACallback: TADListItemCallbackAnon<T>);
  var
    I: Integer;
  begin
    if FIndex > 0 then
      for I := FIndex downto 0 do // Iterate from the current Index (latest item) back to 0
        ACallback(FItems[I]);
    if FCount > FIndex then // If there are other (older) Items at the right-hand side of the Array...
      for I := FCount - 1 downto FIndex + Ord(FIndex > 0) do // Iterate from the Right to one Item Right of the Newest (this would be the Oldest)
        ACallback(FItems[I]);
  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADCircularList<T>.IterateBackward(const ACallback: TADListItemCallbackOfObject<T>);
var
  I: Integer;
begin
  if FIndex > 0 then
    for I := FIndex downto 0 do // Iterate from the current Index (latest item) back to 0
      ACallback(FItems[I]);
  if FCount > FIndex then // If there are other (older) Items at the right-hand side of the Array...
    for I := FCount - 1 downto FIndex + Ord(FIndex > 0) do // Iterate from the Right to one Item Right of the Newest (this would be the Oldest)
      ACallback(FItems[I]);
end;

procedure TADCircularList<T>.IterateBackward(const ACallback: TADListItemCallbackUnbound<T>);
var
  I: Integer;
begin
  if FIndex > 0 then
    for I := FIndex downto 0 do // Iterate from the current Index (latest item) back to 0
      ACallback(FItems[I]);
  if FCount > FIndex then // If there are other (older) Items at the right-hand side of the Array...
    for I := FCount - 1 downto FIndex + Ord(FIndex > 0) do // Iterate from the Right to one Item Right of the Newest (this would be the Oldest)
      ACallback(FItems[I]);
end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADCircularList<T>.IterateForward(const ACallback: TADListItemCallbackAnon<T>);
  var
    I: Integer;
  begin
    if FIndex = FCount - 1 then    // if the Index = Count - 1 (as in, top item)
    begin
      for I := 0 to FCount - 1 do  // Iterate from 0 to Count - 1
        ACallback(FItems[I]);
    end else                       // if the Index <> Count - 1 (as in, NOT top item)
    begin
      for I := FIndex to FCount - 1 do // Iterate from Index to Count - 1
        ACallback(FItems[I]);
      for I := 0 to FIndex - 1 do      // Iterate from 0 to Index
        ACallback(FItems[I]);
    end;
  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADCircularList<T>.IterateForward(const ACallback: TADListItemCallbackOfObject<T>);
var
  I: Integer;
begin
  if FIndex = FCount - 1 then    // if the Index = Count - 1 (as in, top item)
  begin
    for I := 0 to FCount - 1 do  // Iterate from 0 to Count - 1
      ACallback(FItems[I]);
  end else                       // if the Index <> Count - 1 (as in, NOT top item)
  begin
    for I := FIndex to FCount - 1 do // Iterate from Index to Count - 1
      ACallback(FItems[I]);
    for I := 0 to FIndex - 1 do      // Iterate from 0 to Index
      ACallback(FItems[I]);
  end;
end;

procedure TADCircularList<T>.IterateForward(const ACallback: TADListItemCallbackUnbound<T>);
var
  I: Integer;
begin
  if FIndex = FCount - 1 then    // if the Index = Count - 1 (as in, top item)
  begin
    for I := 0 to FCount - 1 do  // Iterate from 0 to Count - 1
      ACallback(FItems[I]);
  end else                       // if the Index <> Count - 1 (as in, NOT top item)
  begin
    for I := FIndex to FCount - 1 do // Iterate from Index to Count - 1
      ACallback(FItems[I]);
    for I := 0 to FIndex - 1 do      // Iterate from 0 to Index
      ACallback(FItems[I]);
  end;
end;

procedure TADCircularList<T>.SetItem(const AIndex: Integer; const AItem: T);
begin
  FItems[AIndex] := AItem;// Index Validation is now performed by TADArray<T>.GetItem
end;

{ TADCircularObjectList<T> }

constructor TADCircularObjectList<T>.Create(const AOwnership: TADOwnership; const ACapacity: Integer);
begin
  FDefaultOwnership := AOwnership;
  inherited Create(ACapacity);
end;

procedure TADCircularObjectList<T>.CreateItemArray(const ACapacity: Integer);
begin
  FItems := TADObjectArray<T>.Create(FDefaultOwnership, ACapacity);
end;

destructor TADCircularObjectList<T>.Destroy;
begin

  inherited;
end;

function TADCircularObjectList<T>.GetOwnership: TADOwnership;
begin
  Result := TADObjectArray<T>(FItems).Ownership;
end;

procedure TADCircularObjectList<T>.SetOwnership(const AOwnership: TADOwnership);
begin
  TADObjectArray<T>(FItems).Ownership := AOwnership;
end;

end.
