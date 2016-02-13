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
unit ADAPT.Generics.Arrays;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes, System.SysUtils,
  {$ELSE}
    Classes, SysUtils,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Common,
  ADAPT.Generics.Defaults;

  {$I ADAPT_RTTI.inc}

type
  {$IFDEF FPC}
    TArray<T> = Array of T; // FreePascal doesn't have this defined (yet)
  {$ENDIF FPC}

  { Interface Forward Declarations }
  IADArray<T> = interface;
  IADObjectArray<T: Class> = interface;
  { Class Forward Declarations }
  TADArray<T> = class;
  TADObjectArray<T: Class> = class;
  TADArrayTS<T> = class;
  TADObjectArrayTS<T: Class> = class;

  ///  <summary><c>A Simple Generic Array with basic Management Methods.</c></summary>
  IADArray<T> = interface(IADInterface)
  ['{8BCFF286-B08C-4A20-8162-F5E926E6A940}']
    // Getters
    function GetCapacity: Integer;
    function GetItem(const AIndex: Integer): T;
    // Setters
    procedure SetCapacity(const ACapacity: Integer);
    procedure SetItem(const AIndex: Integer; const AItem: T);
    // Management Methods
    ///  <summary><c>Empties the Array and sets it back to the original Capacity you specified in the Constructor.</c></summary>
    procedure Clear;
    ///  <summary><c>Low-level Finalization of Items in the Array between the given </c>AIndex<c> and </c>AIndex + ACount<c>.</c></summary>
    procedure Finalize(const AIndex, ACount: Integer);
    ///  <summary><c>Shifts the Items between </c>AFromIndex<c> and </c>AFromIndex + ACount<c> to the range </c>AToIndex<c> and </c>AToIndex + ACount<c> in a single (efficient) operation.</c></summary>
    procedure Move(const AFromIndex, AToIndex, ACount: Integer);
    // Properties
    property Capacity: Integer read GetCapacity write SetCapacity;
    property Items[const AIndex: Integer]: T read GetItem write SetItem; default;
  end;

  ///  <summary><c>A Simple Generic Object Array with basic Management Methods and Item Ownership.</c></summary>
  ///  <remarks>
  ///    <para><c>Will automatically Free any Object contained within the Array on Destruction if </c>OwnsItems<c> is set to </c>True<c>.</c></para>
  ///  </remarks>
  IADObjectArray<T: Class> = interface(IADArray<T>)
  ['{82243ACD-FE8F-4EE4-9231-75D3A6B2D5FE}']
    // Getters
    function GetOwnsItems: Boolean;
    // Setters
    procedure SetOwnsItems(const AOwnsItems: Boolean);
    // Properties
    property OwnsItems: Boolean read GetOwnsItems write SetOwnsItems;
  end;

  ///  <summary><c>A Simple Generic Array with basic Management Methods.</c></summary>
  ///  <remarks>
  ///    <para><c>Use IADArray if you want to take advantage of Reference Counting.</c></para>
  ///    <para><c>This is NOT Threadsafe</c></para>
  ///  </remarks>
  TADArray<T> = class(TADObject, IADArray<T>)
  protected
    FArray: TArray<T>;
    FCapacityInitial: Integer;
    // Getters
    function GetCapacity: Integer; virtual;
    function GetItem(const AIndex: Integer): T; virtual;
    // Setters
    procedure SetCapacity(const ACapacity: Integer); virtual;
    procedure SetItem(const AIndex: Integer; const AItem: T); virtual;
  public
    constructor Create(const ACapacity: Integer = 0); reintroduce; virtual;
    // Management Methods
    ///  <summary><c>Empties the Array and sets it back to the original Capacity you specified in the Constructor.</c></summary>
    procedure Clear; virtual;
    ///  <summary><c>Low-level Finalization of Items in the Array between the given </c>AIndex<c> and </c>AIndex + ACount<c>.</c></summary>
    procedure Finalize(const AIndex, ACount: Integer); virtual;
    ///  <summary><c>Shifts the Items between </c>AFromIndex<c> and </c>AFromIndex + ACount<c> to the range </c>AToIndex<c> and </c>AToIndex + ACount<c> in a single (efficient) operation.</c></summary>
    procedure Move(const AFromIndex, AToIndex, ACount: Integer); virtual;
    // Properties
    property Capacity: Integer read GetCapacity write SetCapacity;
    property Items[const AIndex: Integer]: T read GetItem write SetItem; default;
  end;

  ///  <summary><c>A Simple Generic Object Array with basic Management Methods and Item Ownership.</c></summary>
  ///  <remarks>
  ///    <para><c>Will automatically Free any Object contained within the Array on Destruction if </c>OwnsItems<c> is set to </c>True<c>.</c></para>
  ///    <para><c>Use IADObjectArray if you want to take advantage of Reference Counting.</c></para>
  ///    <para><c>This is NOT Threadsafe</c></para>
  ///  </remarks>
  TADObjectArray<T: Class> = class(TADArray<T>, IADObjectArray<T>)
  private
    FOwnsItems: Boolean;
  protected
    // Getters
    function GetOwnsItems: Boolean; virtual;
    // Setters
    procedure SetOwnsItems(const AOwnsItems: Boolean); virtual;
  public
    constructor Create(const AOwnsItems: Boolean = True; const ACapacity: Integer = 0); reintroduce; virtual;
    destructor Destroy; override;
    ///  <summary><c>Empties the Array and sets it back to the original Capacity you specified in the Constructor.</c></summary>
    procedure Clear; override;
    // Properties
    property OwnsItems: Boolean read GetOwnsItems write SetOwnsItems;
  end;

  ///  <summary><c>A Simple Generic Array with basic Management Methods.</c></summary>
  ///  <remarks>
  ///    <para><c>Use IADArray if you want to take advantage of Reference Counting.</c></para>
  ///    <para><c>This is Threadsafe</c></para>
  ///  </remarks>
  TADArrayTS<T> = class(TADArray<T>, IADReadWriteLock)
  protected
    FArray: TArray<T>;
    FCapacityInitial: Integer;
    FLock: TADReadWriteLock;
    // Getters
    function GetCapacity: Integer; override;
    function GetItem(const AIndex: Integer): T; override;
    function GetLock: IADReadWriteLock;
    // Setters
    procedure SetCapacity(const ACapacity: Integer); override;
    procedure SetItem(const AIndex: Integer; const AItem: T); override;
  public
    constructor Create(const ACapacity: Integer = 0); override;
    destructor Destroy; override;
    // Management Methods
    ///  <summary><c>Empties the Array and sets it back to the original Capacity you specified in the Constructor.</c></summary>
    procedure Clear; override;
    ///  <summary><c>Low-level Finalization of Items in the Array between the given </c>AIndex<c> and </c>AIndex + ACount<c>.</c></summary>
    procedure Finalize(const AIndex, ACount: Integer); override;
    ///  <summary><c>Shifts the Items between </c>AFromIndex<c> and </c>AFromIndex + ACount<c> to the range </c>AToIndex<c> and </c>AToIndex + ACount<c> in a single (efficient) operation.</c></summary>
    procedure Move(const AFromIndex, AToIndex, ACount: Integer); override;
    // Properties
    property Lock: IADReadWriteLock read GetLock implements IADReadWriteLock;
  end;

  ///  <summary><c>A Simple Generic Object Array with basic Management Methods and Item Ownership.</c></summary>
  ///  <remarks>
  ///    <para><c>Will automatically Free any Object contained within the Array on Destruction if </c>OwnsItems<c> is set to </c>True<c>.</c></para>
  ///    <para><c>Use IADObjectArray if you want to take advantage of Reference Counting.</c></para>
  ///    <para><c>This is Threadsafe</c></para>
  ///  </remarks>
  TADObjectArrayTS<T: Class> = class(TADObjectArray<T>, IADReadWriteLock)
  protected
    FArray: TArray<T>;
    FCapacityInitial: Integer;
    FLock: TADReadWriteLock;
    // Getters
    function GetCapacity: Integer; override;
    function GetItem(const AIndex: Integer): T; override;
    function GetLock: IADReadWriteLock;
    // Setters
    procedure SetCapacity(const ACapacity: Integer); override;
    procedure SetItem(const AIndex: Integer; const AItem: T); override;
  public
    constructor Create(const AOwnsItems: Boolean = True; const ACapacity: Integer = 0); reintroduce; virtual;
    destructor Destroy; override;
    // Management Methods
    ///  <summary><c>Empties the Array and sets it back to the original Capacity you specified in the Constructor.</c></summary>
    procedure Clear; override;
    ///  <summary><c>Low-level Finalization of Items in the Array between the given </c>AIndex<c> and </c>AIndex + ACount<c>.</c></summary>
    procedure Finalize(const AIndex, ACount: Integer); override;
    ///  <summary><c>Shifts the Items between </c>AFromIndex<c> and </c>AFromIndex + ACount<c> to the range </c>AToIndex<c> and </c>AToIndex + ACount<c> in a single (efficient) operation.</c></summary>
    procedure Move(const AFromIndex, AToIndex, ACount: Integer); override;
    // Properties
    property Lock: IADReadWriteLock read GetLock implements IADReadWriteLock;
  end;

implementation

{ TADArray<T> }

procedure TADArray<T>.Clear;
begin
  SetLength(FArray, FCapacityInitial);
  if FCapacityInitial > 0 then
    Finalize(0, FCapacityInitial);
end;

constructor TADArray<T>.Create(const ACapacity: Integer);
begin
  inherited Create;
  FCapacityInitial := ACapacity;
  SetLength(FArray, ACapacity);
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
    Result := FArray[AIndex];
end;

procedure TADArray<T>.Move(const AFromIndex, AToIndex, ACount: Integer);
begin
  System.Move(FArray[AFromIndex], FArray[AToIndex], ACount * SizeOf(T));
end;

procedure TADArray<T>.SetCapacity(const ACapacity: Integer);
begin
  SetLength(FArray, ACapacity);
end;

procedure TADArray<T>.SetItem(const AIndex: Integer; const AItem: T);
begin
  FArray[AIndex] := AItem;
end;

{ TADObjectArray<T> }

procedure TADObjectArray<T>.Clear;
var
  I: Integer;
begin
  if OwnsItems then
    for I := Low(FArray) to High(FArray) do
      if ((Assigned(FArray[I]))) and (FArray[I] <> nil) then // TODO -oDaniel -cGeneric Object Array: I really need to test to make sure this won't evaluate as "True" even if a previously-assigned Object at the given Index (I) has been Disposed.
        FArray[I].{$IFDEF SUPPORTS_DISPOSEOF}DisposeOf{$ELSE}Free{$ENDIF SUPPORTS_DISPOSEOF};
  inherited;
end;

constructor TADObjectArray<T>.Create(const AOwnsItems: Boolean; const ACapacity: Integer);
begin
  inherited Create(ACapacity);
  FOwnsItems := AOwnsItems;
end;

destructor TADObjectArray<T>.Destroy;
begin
  Clear;
  inherited;
end;

function TADObjectArray<T>.GetOwnsItems: Boolean;
begin
  Result := FOwnsItems;
end;

procedure TADObjectArray<T>.SetOwnsItems(const AOwnsItems: Boolean);
begin
  FOwnsItems := AOwnsItems;
end;

{ TADArrayTS<T> }

procedure TADArrayTS<T>.Clear;
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

constructor TADArrayTS<T>.Create(const ACapacity: Integer);
begin
  inherited;
  FLock := TADReadWriteLock.Create(Self);
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
    FLock.ReleaseWrite;
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

procedure TADArrayTS<T>.Move(const AFromIndex, AToIndex, ACount: Integer);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

procedure TADArrayTS<T>.SetCapacity(const ACapacity: Integer);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

procedure TADArrayTS<T>.SetItem(const AIndex: Integer; const AItem: T);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

{ TADObjectArrayTS<T> }

procedure TADObjectArrayTS<T>.Clear;
var
  I: Integer;
begin
  FLock.AcquireWrite;
  try
    if OwnsItems then
      for I := Low(FArray) to High(FArray) do
        if ((Assigned(FArray[I]))) and (FArray[I] <> nil) then // TODO -oDaniel -cGeneric Object Array: I really need to test to make sure this won't evaluate as "True" even if a previously-assigned Object at the given Index (I) has been Disposed.
          FArray[I].{$IFDEF SUPPORTS_DISPOSEOF}DisposeOf{$ELSE}Free{$ENDIF SUPPORTS_DISPOSEOF};
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

constructor TADObjectArrayTS<T>.Create(const AOwnsItems: Boolean = True; const ACapacity: Integer = 0);
begin
  inherited;
  FLock := TADReadWriteLock.Create(Self);
end;

destructor TADObjectArrayTS<T>.Destroy;
begin
  Clear;
  FLock.{$IFDEF SUPPORTS_DISPOSEOF}DisposeOf{$ELSE}Free{$ENDIF SUPPORTS_DISPOSEOF};
  inherited;
end;

procedure TADObjectArrayTS<T>.Finalize(const AIndex, ACount: Integer);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

function TADObjectArrayTS<T>.GetCapacity: Integer;
begin
  FLock.AcquireRead;
  try
    Result := inherited;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADObjectArrayTS<T>.GetItem(const AIndex: Integer): T;
begin
  FLock.AcquireRead;
  try
    Result := inherited;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADObjectArrayTS<T>.GetLock: IADReadWriteLock;
begin
  Result := FLock;
end;

procedure TADObjectArrayTS<T>.Move(const AFromIndex, AToIndex, ACount: Integer);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

procedure TADObjectArrayTS<T>.SetCapacity(const ACapacity: Integer);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

procedure TADObjectArrayTS<T>.SetItem(const AIndex: Integer; const AItem: T);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

end.
