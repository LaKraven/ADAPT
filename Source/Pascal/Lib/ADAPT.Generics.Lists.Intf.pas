{
  AD.A.P.T. Library
  Copyright (C) 2014-2016, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Generics.Lists.Intf;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes,
  {$ELSE}
    Classes,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Common.Intf,
  ADAPT.Generics.Allocators.Intf;

  {$I ADAPT_RTTI.inc}

type
  {$IFDEF SUPPORTS_REFERENCETOMETHOD}
    TADListItemCallbackAnon<T> = reference to procedure(const Item: T);
  {$ENDIF SUPPORTS_REFERENCETOMETHOD}
  TADListItemCallbackOfObject<T> = procedure(const Item: T) of object;
  TADListItemCallbackUnbound<T> = procedure(const Item: T);

  ///  <summary><c>Generic List Type</c></summary>
  IADList<T> = interface
    // Getters
    function GetCapacity: Integer;
    function GetCompactor: IADCollectionCompactor;
    function GetCount: Integer;
    function GetExpander: IADCollectionExpander;
    function GetInitialCapacity: Integer;
    function GetItem(const AIndex: Integer): T;
    // Setters
    procedure SetCapacity(const ACapacity: Integer);
    procedure SetCompactor(const ACompactor: IADCollectionCompactor);
    procedure SetExpander(const AExpander: IADCollectionExpander);
    procedure SetItem(const AIndex: Integer; const AItem: T);
    // Management Methods
    procedure Add(const AItem: T); overload;
    procedure Add(const AList: IADList<T>); overload;
    procedure AddItems(const AItems: Array of T);
    procedure Clear;
    procedure Delete(const AIndex: Integer);
    procedure DeleteRange(const AFirst, ACount: Integer);
    procedure Insert(const AItem: T; const AIndex: Integer);
    procedure InsertItems(const AItems: Array of T; const AIndex: Integer);
    // Iterators
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure IterateForward(const ACallback: TADListItemCallbackAnon<T>); overload;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure IterateForward(const ACallback: TADListItemCallbackOfObject<T>); overload;
    procedure IterateForward(const ACallback: TADListItemCallbackUnbound<T>); overload;
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure IterateBackward(const ACallback: TADListItemCallbackAnon<T>); overload;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure IterateBackward(const ACallback: TADListItemCallbackOfObject<T>); overload;
    procedure IterateBackward(const ACallback: TADListItemCallbackUnbound<T>); overload;
    // Properties
    property Capacity: Integer read GetCapacity write SetCapacity;
    property Compactor: IADCollectionCompactor read GetCompactor;
    property Count: Integer read GetCount;
    property Expander: IADCollectionExpander read GetExpander;
    property InitialCapacity: Integer read GetInitialCapacity;
    property Items[const AIndex: Integer]: T read GetItem write SetItem; default;
  end;

  ///  <summary><c>A Generic Fixed-Capacity Revolving List</c></summary>
  ///  <remarks>
  ///    <para><c>When the current Index is equal to the Capacity, the Index resets to 0, and items are subsequently Replaced by new ones.</c></para>
  ///  </remarks>
  IADCircularList<T> = interface(IADInterface)
    // Getters
    function GetCapacity: Integer;
    function GetCount: Integer;
    function GetItem(const AIndex: Integer): T;
    // Setters
    procedure SetItem(const AIndex: Integer; const AItem: T);
    // Management Methods
    function Add(const AItem: T): Integer;
    procedure AddItems(const AItems: Array of T);
    procedure Clear;
    procedure Delete(const AIndex: Integer);
    // Iterators
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure IterateNewestToOldest(const ACallback: TADListItemCallbackAnon<T>); overload;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure IterateNewestToOldest(const ACallback: TADListItemCallbackOfObject<T>); overload;
    procedure IterateNewestToOldest(const ACallback: TADListItemCallbackUnbound<T>); overload;
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure IterateOldestToNewest(const ACallback: TADListItemCallbackAnon<T>); overload;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure IterateOldestToNewest(const ACallback: TADListItemCallbackOfObject<T>); overload;
    procedure IterateOldestToNewest(const ACallback: TADListItemCallbackUnbound<T>); overload;
    // Properties
    property Capacity: Integer read GetCapacity;
    property Count: Integer read GetCount;
    property Items[const AIndex: Integer]:  T read GetItem write SetItem;
  end;

implementation

end.
