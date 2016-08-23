{
  AD.A.P.T. Library
  Copyright (C) 2014-2016, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Generics.Common.Threadsafe;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes,
  {$ELSE}
    Classes,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Common, ADAPT.Common.Intf, ADAPT.Common.Threadsafe,
  ADAPT.Generics.Common.Intf, ADAPT.Generics.Common;

  {$I ADAPT_RTTI.inc}

type
  TADObjectHolderTS<T: class> = class(TADObjectHolder<T>, IADReadWriteLock)
  private
    FLock: TADReadWriteLock;
    function GetLock: IADReadWriteLock;
  protected
    // Getters
    { IADObjectOwner }
    function GetOwnership: TADOwnership; override;
    { IADObjectHolder<T> }
    function GetObject: T; override;

    // Setters
    { IADObjectOwner }
    procedure SetOwnership(const AOwnership: TADOwnership); override;
    { IADObjectHolder<T> }
    procedure SetObject(const AObject: T); override;
  public
    constructor Create(const AObject: T; const AOwnership: TADOwnership = oOwnsObjects); override;
    destructor Destroy; override;

    property Lock: IADReadWriteLock read GetLock implements IADReadWriteLock;
  end;

implementation

{ TADObjectHolderTS<T> }

constructor TADObjectHolderTS<T>.Create(const AObject: T; const AOwnership: TADOwnership);
begin
  inherited;
  FLock := TADReadWriteLock.Create(Self);
end;

destructor TADObjectHolderTS<T>.Destroy;
begin
  FLock.{$IFDEF SUPPORTS_DISPOSEOF}DisposeOf{$ELSE}Free{$ENDIF SUPPORTS_DISPOSEOF};
  inherited;
end;

function TADObjectHolderTS<T>.GetLock: IADReadWriteLock;
begin
  Result := FLock;
end;

function TADObjectHolderTS<T>.GetObject: T;
begin
  FLock.AcquireRead;
  try
    Result := inherited;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADObjectHolderTS<T>.GetOwnership: TADOwnership;
begin
  FLock.AcquireRead;
  try
    Result := inherited;
  finally
    FLock.ReleaseRead;
  end;
end;

procedure TADObjectHolderTS<T>.SetObject(const AObject: T);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

procedure TADObjectHolderTS<T>.SetOwnership(const AOwnership: TADOwnership);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

end.
