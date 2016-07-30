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
    ///  <summary><c>Override to construct an alternative Array type</c></summary>
    procedure CreateArray(const AInitialCapacity: Integer = 0); virtual;
  public
    // Management Methods
    { IADLookupList<T> }
    function Add(const AItem: T): Integer; virtual;
    procedure AddItems(const AItems: Array of T); virtual;
    procedure Clear; virtual;
    procedure Compact; virtual;
    function Contains(const AItem: T): Boolean; virtual;
    function ContainsAll(const AItems: Array of T): Boolean; virtual;
    procedure Delete(const AIndex: Integer); overload; virtual;
    procedure DeleteRange(const AFromIndex, ACount: Integer); overload; virtual;
    procedure DeleteSelection(const AIndexes: Array of Integer); virtual;
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
  ADAPT.Generics.Arrays;

{ TADLookupList<T> }

function TADLookupList<T>.Add(const AItem: T): Integer;
begin

end;

procedure TADLookupList<T>.AddItems(const AItems: array of T);
begin

end;

procedure TADLookupList<T>.Clear;
begin

end;

procedure TADLookupList<T>.Compact;
begin

end;

function TADLookupList<T>.Contains(const AItem: T): Boolean;
begin

end;

function TADLookupList<T>.ContainsAll(const AItems: array of T): Boolean;
begin

end;

procedure TADLookupList<T>.CreateArray(const AInitialCapacity: Integer);
begin
  FArray := TADArray<T>.Create(AInitialCapacity);
end;

procedure TADLookupList<T>.Delete(const AIndex: Integer);
begin

end;

procedure TADLookupList<T>.DeleteRange(const AFromIndex, ACount: Integer);
begin

end;

procedure TADLookupList<T>.DeleteSelection(const AIndexes: array of Integer);
begin

end;

function TADLookupList<T>.GetCompactor: IADCollectionCompactor;
begin

end;

function TADLookupList<T>.GetComparer: IADComparer<T>;
begin

end;

function TADLookupList<T>.GetCount: Integer;
begin

end;

function TADLookupList<T>.GetExpander: IADCollectionExpander;
begin

end;

function TADLookupList<T>.GetIsEmpty: Boolean;
begin

end;

function TADLookupList<T>.GetItem(const AIndex: Integer): T;
begin

end;

function TADLookupList<T>.IndexOf(const AItem: T): Integer;
begin

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

procedure TADLookupList<T>.Remove(const AItem: T);
begin

end;

procedure TADLookupList<T>.RemoveItems(const AItems: array of T);
begin

end;

procedure TADLookupList<T>.SetCompactor(const ACompactor: IADCollectionCompactor);
begin

end;

procedure TADLookupList<T>.SetComparer(const AComparer: IADComparer<T>);
begin

end;

procedure TADLookupList<T>.SetExpander(const AExpander: IADCollectionExpander);
begin

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
