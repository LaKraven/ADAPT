{
  AD.A.P.T. Library
  Copyright (C) 2014-2016, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Generics.Arrays.Threadsafe;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes, System.SysUtils,
  {$ELSE}
    Classes, SysUtils,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Common, ADAPT.Common.Intf, ADAPT.Common.Threadsafe,
  ADAPT.Generics.Common.Intf,
  ADAPT.Generics.Arrays;

  {$I ADAPT_RTTI.inc}

type
  {$IFNDEF FPC}
    { Class Forward Declarations }
    TADArrayTS<T> = class;
    TADObjectArrayTS<T: Class> = class;
  {$ENDIF FPC}

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
    procedure Clear; override;
    procedure Delete(const AIndex: Integer); override;
    procedure Finalize(const AIndex, ACount: Integer); override;
    procedure Insert(const AItem: T; const AIndex: Integer); override;
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
  TADObjectArrayTS<T: Class> = class(TADObjectArray<T>, IADObjectOwner, IADReadWriteLock)
  private
    FLock: TADReadWriteLock;
    function GetLock: IADReadWriteLock;
  protected
    FArray: TArray<T>;
    FCapacityInitial: Integer;
    // Getters
    function GetCapacity: Integer; override;
    function GetItem(const AIndex: Integer): T; override;
    // Setters
    procedure SetCapacity(const ACapacity: Integer); override;
    procedure SetItem(const AIndex: Integer; const AItem: T); override;
  public
    constructor Create(const AOwnership: TADOwnership = oOwnsObjects; const ACapacity: Integer = 0); reintroduce; virtual;
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

implementation

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

procedure TADArrayTS<T>.Delete(const AIndex: Integer);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
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

procedure TADArrayTS<T>.Insert(const AItem: T; const AIndex: Integer);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
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
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

constructor TADObjectArrayTS<T>.Create(const AOwnership: TADOwnership = oOwnsObjects; const ACapacity: Integer = 0);
begin
  FLock := TADReadWriteLock.Create(Self);
  inherited;
end;

procedure TADObjectArrayTS<T>.Delete(const AIndex: Integer);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

destructor TADObjectArrayTS<T>.Destroy;
begin
  inherited;
  FLock.{$IFDEF SUPPORTS_DISPOSEOF}DisposeOf{$ELSE}Free{$ENDIF SUPPORTS_DISPOSEOF};
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

procedure TADObjectArrayTS<T>.Insert(const AItem: T; const AIndex: Integer);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
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
