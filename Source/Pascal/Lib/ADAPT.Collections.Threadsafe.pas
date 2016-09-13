{
  AD.A.P.T. Library
  Copyright (C) 2014-2016, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Collections.Threadsafe;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes, System.SysUtils,
  {$ELSE}
    Classes, SysUtils,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT, ADAPT.Intf, ADAPT.Threadsafe,
  ADAPT.Collections.Intf, ADAPT.Collections;

  {$I ADAPT_RTTI.inc}

type
  ///  <summary><c>A Simple Generic Array with basic Management Methods.</c></summary>
  ///  <remarks>
  ///    <para><c>Use IADArray if you want to take advantage of Reference Counting.</c></para>
  ///    <para><c>This is Threadsafe</c></para>
  ///  </remarks>
  TADArrayTS<T> = class(TADArray<T>, IADReadWriteLock)
  private
    FLock: TADReadWriteLock;
    function GetLock: IADReadWriteLock;
  protected
    // Getters
    function GetCapacity: Integer; override;
    function GetItem(const AIndex: Integer): T; override;
    // Setters
    procedure SetCapacity(const ACapacity: Integer); override;
    procedure SetItem(const AIndex: Integer; const AItem: T); override;
  public
    constructor Create(const ACapacity: Integer = 0); override;
    destructor Destroy; override;

    // Management Methods
    procedure Clear; override;
    procedure Delete(const AIndex: Integer); override;
    procedure Finalize(const AIndex, ACount: Integer); override;
    procedure Insert(const AItem: T; const AIndex: Integer); override;
    procedure Move(const AFromIndex, AToIndex, ACount: Integer); override;

    // Properties
    property Lock: IADReadWriteLock read GetLock implements IADReadWriteLock;
  end;

  ///  <summary><c>A Geometric Allocation Algorithm for Lists.</c></summary>
  ///  <remarks>
  ///    <para><c>When the number of Vacant Slots falls below the Threshold, the number of Vacant Slots increases by the value of the current Capacity multiplied by the Mulitplier.</c></para>
  ///    <para><c>This Expander Type is Threadsafe.</c></para>
  ///  </remarks>
  TADExpanderGeometricTS = class(TADExpanderGeometric, IADReadWriteLock)
  private
    FLock: TADReadWriteLock;
    function GetLock: IADReadWriteLock;
  protected
    // Getters
    function GetCapacityMultiplier: Single; override;
    function GetCapacityThreshold: Integer; override;
    // Setters
    procedure SetCapacityMultiplier(const AMultiplier: Single); override;
    procedure SetCapacityThreshold(const AThreshold: Integer); override;
  public
    constructor Create; override;
    destructor Destroy; override;

    property Lock: IADReadWriteLock read GetLock implements IADReadWriteLock;
  end;

  ///  <summary><c>Generic List Type</c></summary>
  ///  <remarks>
  ///    <para><c>This type is NOT Threadsafe.</c></para>
  ///  </remarks>
  TADListTS<T> = class(TADList<T>, IADReadWriteLock)
  private
    FLock: TADReadWriteLock;
    function GetLock: IADReadWriteLock;
  protected
    // Getters
    { TADCollection }
    function GetCapacity: Integer; override;
    function GetCount: Integer; override;
    function GetIsCompact: Boolean; override;
    function GetIsEmpty: Boolean; override;
    function GetSortedState: TADSortedState; override;
    { TADCollectionList<T> }
    function GetSorter: IADListSorter<T>; override;
    function GetItem(const AIndex: Integer): T; override;
    { TADCollectionListAllocatable<T> }
    function GetCompactor: IADCompactor; override;
    function GetExpander: IADExpander; override;

    // Setters
    { TADCollection }
    procedure SetCapacity(const ACapacity: Integer); override;
    { TADCollectionList<T> }
    procedure SetSorter(const ASorter: IADListSorter<T>); override;
    { TADCollectionListAllocatable<T> }
    procedure SetCompactor(const ACompactor: IADCompactor); override;
    procedure SetExpander(const AExpander: IADExpander); override;
    { TADList<T> }
    procedure SetItem(const AIndex: Integer; const AItem: T); override;
  public
    constructor Create(const AExpander: IADExpander; const ACompactor: IADCompactor; const AInitialCapacity: Integer = 0); override;
    destructor Destroy; override;

    // Management Methods
    { TADCollection }
    procedure Clear; override;
    { TADCollectionList<T> }
    function Add(const AItem: T): Integer; overload; override;
    procedure Add(const AItems: IADCollectionList<T>); overload; override;
    procedure AddItems(const AItems: Array of T); override;
    procedure Delete(const AIndex: Integer); override;
    procedure DeleteRange(const AFirst, ACount: Integer); override;
    { TADCollectionListAllocatable<T> }
    procedure Compact; override;
    { TADList }
    procedure Insert(const AItem: T; const AIndex: Integer); override;
    procedure InsertItems(const AItems: Array of T; const AIndex: Integer); override;
    procedure Sort(const AComparer: IADComparer<T>); override;

    // Iterators
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure IterateBackward(const ACallback: TADListItemCallbackAnon<T>); overload; override;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure IterateBackward(const ACallback: TADListItemCallbackOfObject<T>); overload; override;
    procedure IterateBackward(const ACallback: TADListItemCallbackUnbound<T>); overload; override;
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure IterateForward(const ACallback: TADListItemCallbackAnon<T>); overload; override;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure IterateForward(const ACallback: TADListItemCallbackOfObject<T>); overload; override;
    procedure IterateForward(const ACallback: TADListItemCallbackUnbound<T>); overload; override;

    // Properties
    property Lock: IADReadWriteLock read GetLock implements IADReadWriteLock;
  end;

implementation

{ TADArrayTS<T> }

procedure TADArrayTS<T>.Clear;
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseRead;
  end;
end;

constructor TADArrayTS<T>.Create(const ACapacity: Integer);
begin
  inherited;
  FLock := ADReadWriteLock(Self);
end;

procedure TADArrayTS<T>.Delete(const AIndex: Integer);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseRead;
  end;
end;

destructor TADArrayTS<T>.Destroy;
begin
  FLock.{$IFDEF SUPPORTS_DISPOSEOF}DisposeOf{$ELSE}Free{$ENDIF SUPPORTS_DISPOSEOF};
  inherited;
end;

procedure TADArrayTS<T>.Finalize(const AIndex, ACount: Integer);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADArrayTS<T>.GetCapacity: Integer;
begin
  FLock.AcquireRead;
  try
    Result := inherited;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADArrayTS<T>.GetItem(const AIndex: Integer): T;
begin
  FLock.AcquireRead;
  try
    Result := inherited;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADArrayTS<T>.GetLock: IADReadWriteLock;
begin
  Result := FLock;
end;

procedure TADArrayTS<T>.Insert(const AItem: T; const AIndex: Integer);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseRead;
  end;
end;

procedure TADArrayTS<T>.Move(const AFromIndex, AToIndex, ACount: Integer);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseRead;
  end;
end;

procedure TADArrayTS<T>.SetCapacity(const ACapacity: Integer);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseRead;
  end;
end;

procedure TADArrayTS<T>.SetItem(const AIndex: Integer; const AItem: T);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseRead;
  end;
end;

{ TADExpanderGeometricTS }

constructor TADExpanderGeometricTS.Create;
begin
  inherited;
  FLock := ADReadWriteLock(Self);
end;

destructor TADExpanderGeometricTS.Destroy;
begin
  FLock.{$IFDEF SUPPORTS_DISPOSEOF}DisposeOf{$ELSE}Free{$ENDIF SUPPORTS_DISPOSEOF};
  inherited;
end;

function TADExpanderGeometricTS.GetCapacityMultiplier: Single;
begin
  FLock.AcquireRead;
  try
    Result := inherited;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADExpanderGeometricTS.GetCapacityThreshold: Integer;
begin
  FLock.AcquireRead;
  try
    Result := inherited;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADExpanderGeometricTS.GetLock: IADReadWriteLock;
begin
  Result := FLock;
end;

procedure TADExpanderGeometricTS.SetCapacityMultiplier(const AMultiplier: Single);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

procedure TADExpanderGeometricTS.SetCapacityThreshold(const AThreshold: Integer);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

{ TADListTS<T> }

procedure TADListTS<T>.Add(const AItems: IADCollectionList<T>);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

function TADListTS<T>.Add(const AItem: T): Integer;
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

procedure TADListTS<T>.AddItems(const AItems: array of T);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

procedure TADListTS<T>.Clear;
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

procedure TADListTS<T>.Compact;
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

constructor TADListTS<T>.Create(const AExpander: IADExpander; const ACompactor: IADCompactor; const AInitialCapacity: Integer);
begin
  inherited;
  FLock := ADReadWriteLock(Self);
end;

destructor TADListTS<T>.Destroy;
begin
  FLock.{$IFDEF SUPPORTS_DISPOSEOF}DisposeOf{$ELSE}Free{$ENDIF SUPPORTS_DISPOSEOF};
  inherited;
end;

procedure TADListTS<T>.Delete(const AIndex: Integer);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

procedure TADListTS<T>.DeleteRange(const AFirst, ACount: Integer);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

function TADListTS<T>.GetCapacity: Integer;
begin
  FLock.AcquireRead;
  try
    Result := inherited;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADListTS<T>.GetCompactor: IADCompactor;
begin
  FLock.AcquireRead;
  try
    Result := inherited;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADListTS<T>.GetCount: Integer;
begin
  FLock.AcquireRead;
  try
    Result := inherited;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADListTS<T>.GetExpander: IADExpander;
begin
  FLock.AcquireRead;
  try
    Result := inherited;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADListTS<T>.GetIsCompact: Boolean;
begin
  FLock.AcquireRead;
  try
    Result := inherited;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADListTS<T>.GetIsEmpty: Boolean;
begin
  FLock.AcquireRead;
  try
    Result := inherited;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADListTS<T>.GetItem(const AIndex: Integer): T;
begin
  FLock.AcquireRead;
  try
    Result := inherited;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADListTS<T>.GetLock: IADReadWriteLock;
begin
  Result := FLock;
end;

function TADListTS<T>.GetSortedState: TADSortedState;
begin
  FLock.AcquireRead;
  try
    Result := inherited;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADListTS<T>.GetSorter: IADListSorter<T>;
begin
  FLock.AcquireRead;
  try
    Result := inherited;
  finally
    FLock.ReleaseRead;
  end;
end;

procedure TADListTS<T>.Insert(const AItem: T; const AIndex: Integer);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

procedure TADListTS<T>.InsertItems(const AItems: array of T; const AIndex: Integer);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADListTS<T>.IterateBackward(const ACallback: TADListItemCallbackAnon<T>);
  begin
    FLock.AcquireWrite;
    try
      inherited;
    finally
      FLock.ReleaseWrite;
    end;
  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADListTS<T>.IterateBackward(const ACallback: TADListItemCallbackOfObject<T>);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

procedure TADListTS<T>.IterateBackward(const ACallback: TADListItemCallbackUnbound<T>);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADListTS<T>.IterateForward(const ACallback: TADListItemCallbackAnon<T>);
  begin
    FLock.AcquireWrite;
    try
      inherited;
    finally
      FLock.ReleaseWrite;
    end;
  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADListTS<T>.IterateForward(const ACallback: TADListItemCallbackOfObject<T>);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

procedure TADListTS<T>.IterateForward(const ACallback: TADListItemCallbackUnbound<T>);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

procedure TADListTS<T>.SetCapacity(const ACapacity: Integer);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

procedure TADListTS<T>.SetCompactor(const ACompactor: IADCompactor);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

procedure TADListTS<T>.SetExpander(const AExpander: IADExpander);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

procedure TADListTS<T>.SetItem(const AIndex: Integer; const AItem: T);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

procedure TADListTS<T>.SetSorter(const ASorter: IADListSorter<T>);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

procedure TADListTS<T>.Sort(const AComparer: IADComparer<T>);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

end.
