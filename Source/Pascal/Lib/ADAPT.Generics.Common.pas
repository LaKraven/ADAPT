{
  AD.A.P.T. Library
  Copyright (C) 2014-2016, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Generics.Common;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes,
  {$ELSE}
    Classes,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Common, ADAPT.Common.Intf,
  ADAPT.Generics.Common.Intf,
  ADAPT.Generics.Allocators.Intf,
  ADAPT.Generics.Collections.Intf;

  {$I ADAPT_RTTI.inc}

type
  // Exceptions
  EADGenericsException = class(EADException);
      EADGenericsIterateException = class(EADGenericsException);
      EADGenericsIterateDirectionUnknownException = class(EADGenericsIterateException);
    EADGenericsRangeException = class(EADGenericsException);
    EADGenericsParameterInvalidException = class(EADGenericsException);
      EADGenericsCapacityLessThanCount = class(EADGenericsParameterInvalidException);
      EADGenericsCompactorNilException = class(EADGenericsParameterInvalidException);
      EADGenericsExpanderNilException = class(EADGenericsParameterInvalidException);

  TADObjectHolder<T: class> = class(TADObject, IADObjectHolder<T>)
  private
    FOwnership: TADOwnership;
    FObject: T;
  protected
    // Getters
    { IADObjectOwner }
    function GetOwnership: TADOwnership; virtual;
    { IADObjectHolder<T> }
    function GetObject: T; virtual;

    // Setters
    { IADObjectOwner }
    procedure SetOwnership(const AOwnership: TADOwnership); virtual;
  public
    constructor Create(const AObject: T; const AOwnership: TADOwnership = oOwnsObjects); reintroduce; virtual;
    destructor Destroy; override;
    // Properties
    { IADObjectOwner }
    property Ownership: TADOwnership read GetOwnership write SetOwnership;
    { IADObjectHolder<T> }
    property HeldObject: T read GetObject;
  end;

  TADValueHolder<T> = class(TADObject, IADValueHolder<T>)
  private
    FValue: T;
  protected
    function GetValue: T; virtual;
  public
    constructor Create(const AValue: T); reintroduce;

    property Value: T read GetValue;
  end;

  TADKeyValuePair<TKey, TValue> = class(TADObject, IADKeyValuePair<TKey, TValue>)
  protected
    FKey: TKey;
    FValue: TValue;
    // Getters
    function GetKey: TKey;
    function GetValue: TValue;
  public
    constructor Create(const AKey: TKey; const AValue: TValue); reintroduce;
    // Properties
    property Key: TKey read GetKey;
    property Value: TValue read GetValue;
  end;

implementation

uses
  ADAPT.Generics.Allocators;

{ TADObjectHolder<T> }

constructor TADObjectHolder<T>.Create(const AObject: T; const AOwnership: TADOwnership);
begin
  inherited Create;
  FObject := AObject;
  FOwnership := AOwnership;
end;

destructor TADObjectHolder<T>.Destroy;
begin
  if FOwnership = oOwnsObjects then
    FObject.{$IFDEF SUPPORTS_DISPOSEOF}DisposeOf{$ELSE}Free{$ENDIF SUPPORTS_DISPOSEOF};
  inherited;
end;

function TADObjectHolder<T>.GetObject: T;
begin
  Result := FObject;
end;

function TADObjectHolder<T>.GetOwnership: TADOwnership;
begin
  Result := FOwnership;
end;

procedure TADObjectHolder<T>.SetOwnership(const AOwnership: TADOwnership);
begin
  FOwnership := AOwnership;
end;

{ TADValueHolder<T> }

constructor TADValueHolder<T>.Create(const AValue: T);
begin
  inherited Create;
  FValue := AValue;
end;

function TADValueHolder<T>.GetValue: T;
begin
  Result := FValue;
end;

{ TADKeyValuePair<TKey, TValue> }

constructor TADKeyValuePair<TKey, TValue>.Create(const AKey: TKey; const AValue: TValue);
begin
  inherited Create;
  FKey := AKey;
  FValue := AValue;
end;

function TADKeyValuePair<TKey, TValue>.GetKey: TKey;
begin
  Result := FKey;
end;

function TADKeyValuePair<TKey, TValue>.GetValue: TValue;
begin
  Result := FValue;
end;

end.
