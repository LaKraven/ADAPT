{
  AD.A.P.T. Library
  Copyright (C) 2014-2016, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT

  Formerlly known as "LaKraven Studios Standard Library" or "LKSL".
  "ADAPT" supercedes the former LKSL codebase as of 2016.

  License:
    - You may use this library as you see fit, including use within commercial applications.
    - You may modify this library to suit your needs, without the requirement of distributing
      modified versions.
    - You may redistribute this library (in part or whole) individually, or as part of any
      other works.
    - You must NOT charge a fee for the distribution of this library (compiled or in its
      source form). It MUST be distributed freely.
    - This license and the surrounding comment block MUST remain in place on all copies and
      modified versions of this source code.
    - Modified versions of this source MUST be clearly marked, including the name of the
      person(s) and/or organization(s) responsible for the changes, and a SEPARATE "changelog"
      detailing all additions/deletions/modifications made.

  Disclaimer:
    - Your use of this source constitutes your understanding and acceptance of this
      disclaimer.
    - Simon J Stuart, nor any other contributor, may be held liable for your use of this source
      code. This includes any losses and/or damages resulting from your use of this source
      code, be they physical, financial, or psychological.
    - There is no warranty or guarantee (implicit or otherwise) provided with this source
      code. It is provided on an "AS-IS" basis.

  Donations:
    - While not mandatory, contributions are always appreciated. They help keep the coffee
      flowing during the long hours invested in this and all other Open Source projects we
      produce.
    - Donations can be made via PayPal to PayPal [at] LaKraven (dot) Com
                                          ^  Garbled to prevent spam!  ^
}
unit ADAPT.Generics.Lists.Threadsafe;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes, System.SysUtils,
  {$ELSE}
    Classes, SysUtils,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Common, ADAPT.Common.Intf, ADAPT.Common.Threadsafe,
  ADAPT.Generics.Defaults.Intf,
  ADAPT.Generics.Allocators.Intf, ADAPT.Generics.Allocators,
  ADAPT.Generics.Arrays.Intf,
  ADAPT.Generics.Lists, ADAPT.Generics.Lists.Intf;

  {$I ADAPT_RTTI.inc}

type
  ///  <summary><c>Generic List Type</c></summary>
  ///  <remarks>
  ///    <para><c>This is Threadsafe</c></para>
  ///  </remarks>
  TADListTS<T> = class(TADList<T>, IADReadWriteLock)
  private
    FLock: TADReadWriteLock;
    function GetLock: IADReadWriteLock;
  public
    ///  <summary><c>Creates an instance of your List using a Custom Expander and Compactor Instance.</c></summary>
    constructor Create(const AExpander: IADCollectionExpander; const ACompactor: IADCollectionCompactor; const AInitialCapacity: Integer = 0); overload; override;
    destructor Destroy; override;

    property Lock: IADReadWriteLock read GetLock implements IADReadWriteLock;
  end;

  ///  <summary><c>Generic Object List Type</c></summary>
  ///  <remarks>
  ///    <para><c>Can take Ownership of its Items.</c></para>
  ///    <para><c>This is Threadsafe</c></para>
  ///  </remarks>
  TADObjectListTS<T: class> = class(TADObjectList<T>, IADObjectOwner, IADReadWriteLock)
  private
    FLock: TADReadWriteLock;
    function GetLock: IADReadWriteLock;
  public
    ///  <summary><c>Creates an instance of your List using a Custom Expander and Compactor Instance.</c></summary>
    constructor Create(const AExpander: IADCollectionExpander; const ACompactor: IADCollectionCompactor; const AInitialCapacity: Integer = 0; const AOwnership: TADOwnership = oOwnsObjects); overload; override;
    destructor Destroy; override;

    property Lock: IADReadWriteLock read GetLock implements IADReadWriteLock;
  end;

  ///  <summary><c>A Generic Fixed-Capacity Revolving List</c></summary>
  ///  <remarks>
  ///    <para><c>When the current Index is equal to the Capacity, the Index resets to 0, and items are subsequently Replaced by new ones.</c></para>
  ///    <para><c>This is Threadsafe</c></para>
  ///  </remarks>
  TADCircularListTS<T> = class(TADCircularList<T>, IADReadWriteLock)
  private
    FLock: TADReadWriteLock;
    function GetLock: IADReadWriteLock;
  protected
    // Getters
    function GetCount: Integer; override;
    function GetItem(const AIndex: Integer): T; override;
    // Setters
    procedure SetItem(const AIndex: Integer; const AItem: T); override;
  public
    constructor Create(const ACapacity: Integer); override;
    destructor Destroy; override;

    // Management Methods
    function Add(const AItem: T): Integer; override;
    procedure AddItems(const AItems: Array of T); override;
    procedure Clear; override;
    procedure Delete(const AIndex: Integer); override;

    // Iterators
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure IterateNewestToOldest(const ACallback: TADListItemCallbackAnon<T>); overload; override;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure IterateNewestToOldest(const ACallback: TADListItemCallbackOfObject<T>); overload; override;
    procedure IterateNewestToOldest(const ACallback: TADListItemCallbackUnbound<T>); overload; override;
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure IterateOldestToNewest(const ACallback: TADListItemCallbackAnon<T>); overload; override;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure IterateOldestToNewest(const ACallback: TADListItemCallbackOfObject<T>); overload; override;
    procedure IterateOldestToNewest(const ACallback: TADListItemCallbackUnbound<T>); overload; override;

    property Lock: IADReadWriteLock read GetLock implements IADReadWriteLock;
  end;

  ///  <summary><c>A Generic Fixed-Capacity Revolving Object List</c></summary>
  ///  <remarks>
  ///    <para><c>When the current Index is equal to the Capacity, the Index resets to 0, and items are subsequently Replaced by new ones.</c></para>
  ///    <para><c>Can take Ownership of its Items.</c></para>
  ///    <para><c>This is Threadsafe</c></para>
  ///  </remarks>
  TADCircularObjectListTS<T: class> = class(TADCircularObjectList<T>, IADObjectOwner, IADReadWriteLock)
  private
    FLock: TADReadWriteLock;
    function GetLock: IADReadWriteLock;
  protected
    // Getters
    function GetCount: Integer; override;
    function GetItem(const AIndex: Integer): T; override;
    // Setters
    procedure SetItem(const AIndex: Integer; const AItem: T); override;
  public
    constructor Create(const AOwnership: TADOwnership; const ACapacity: Integer); override;
    destructor Destroy; override;

    // Management Methods
    function Add(const AItem: T): Integer; override;
    procedure AddItems(const AItems: Array of T); override;
    procedure Clear; override;
    procedure Delete(const AIndex: Integer); override;

    property Lock: IADReadWriteLock read GetLock implements IADReadWriteLock;
  end;

implementation

{ TADListTS<T> }

constructor TADListTS<T>.Create(const AExpander: IADCollectionExpander; const ACompactor: IADCollectionCompactor; const AInitialCapacity: Integer);
begin
  inherited;
  FLock := TADReadWriteLock.Create(Self);
end;

destructor TADListTS<T>.Destroy;
begin
  FLock.Free;
  inherited;
end;

function TADListTS<T>.GetLock: IADReadWriteLock;
begin
  Result := FLock;
end;

{ TADObjectListTS<T> }

constructor TADObjectListTS<T>.Create(const AExpander: IADCollectionExpander; const ACompactor: IADCollectionCompactor; const AInitialCapacity: Integer; const AOwnership: TADOwnership);
begin
  inherited;
  FLock := TADReadWriteLock.Create(Self);
end;

destructor TADObjectListTS<T>.Destroy;
begin
  FLock.Free;
  inherited;
end;

function TADObjectListTS<T>.GetLock: IADReadWriteLock;
begin
  Result := FLock;
end;

{ TADCircularListTS<T> }

function TADCircularListTS<T>.Add(const AItem: T): Integer;
begin
  FLock.AcquireWrite;
  try
    Result := inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

procedure TADCircularListTS<T>.AddItems(const AItems: array of T);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

procedure TADCircularListTS<T>.Clear;
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

constructor TADCircularListTS<T>.Create(const ACapacity: Integer);
begin
  inherited;
  FLock := TADReadWriteLock.Create(Self);
end;

procedure TADCircularListTS<T>.Delete(const AIndex: Integer);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

destructor TADCircularListTS<T>.Destroy;
begin
  FLock.Free;
  inherited;
end;

function TADCircularListTS<T>.GetCount: Integer;
begin
  FLock.AcquireRead;
  try
    Result := inherited;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADCircularListTS<T>.GetItem(const AIndex: Integer): T;
begin
  FLock.AcquireRead;
  try
    Result := inherited;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADCircularListTS<T>.GetLock: IADReadWriteLock;
begin
  Result := FLock;
end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADCircularListTS<T>.IterateNewestToOldest(const ACallback: TADListItemCallbackAnon<T>);
  begin
    FLock.AcquireRead;
    try
      inherited;
    finally
      FLock.ReleaseRead;
    end;
  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADCircularListTS<T>.IterateNewestToOldest(const ACallback: TADListItemCallbackOfObject<T>);
begin
  FLock.AcquireRead;
  try
    inherited;
  finally
    FLock.ReleaseRead;
  end;
end;

procedure TADCircularListTS<T>.IterateNewestToOldest(const ACallback: TADListItemCallbackUnbound<T>);
begin
  FLock.AcquireRead;
  try
    inherited;
  finally
    FLock.ReleaseRead;
  end;
end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADCircularListTS<T>.IterateOldestToNewest(const ACallback: TADListItemCallbackAnon<T>);
  begin
    FLock.AcquireRead;
    try
      inherited;
    finally
      FLock.ReleaseRead;
    end;
  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADCircularListTS<T>.IterateOldestToNewest(const ACallback: TADListItemCallbackOfObject<T>);
begin
  FLock.AcquireRead;
  try
    inherited;
  finally
    FLock.ReleaseRead;
  end;
end;

procedure TADCircularListTS<T>.IterateOldestToNewest(const ACallback: TADListItemCallbackUnbound<T>);
begin
  FLock.AcquireRead;
  try
    inherited;
  finally
    FLock.ReleaseRead;
  end;
end;

procedure TADCircularListTS<T>.SetItem(const AIndex: Integer; const AItem: T);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

{ TADCircularObjectListTS<T> }

function TADCircularObjectListTS<T>.Add(const AItem: T): Integer;
begin
  FLock.AcquireWrite;
  try
    Result := inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

procedure TADCircularObjectListTS<T>.AddItems(const AItems: array of T);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

procedure TADCircularObjectListTS<T>.Clear;
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

constructor TADCircularObjectListTS<T>.Create(const AOwnership: TADOwnership; const ACapacity: Integer);
begin
  inherited;
  FLock := TADReadWriteLock.Create(Self);
end;

procedure TADCircularObjectListTS<T>.Delete(const AIndex: Integer);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

destructor TADCircularObjectListTS<T>.Destroy;
begin
  FLock.Free;
  inherited;
end;

function TADCircularObjectListTS<T>.GetCount: Integer;
begin
  FLock.AcquireRead;
  try
    Result := inherited;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADCircularObjectListTS<T>.GetItem(const AIndex: Integer): T;
begin
  FLock.AcquireRead;
  try
    Result := inherited;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADCircularObjectListTS<T>.GetLock: IADReadWriteLock;
begin
  Result := FLock;
end;

procedure TADCircularObjectListTS<T>.SetItem(const AIndex: Integer; const AItem: T);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

end.
