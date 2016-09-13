{
  AD.A.P.T. Library
  Copyright (C) 2014-2016, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Common;

{$I ADAPT.inc}

{$IFDEF FPC}
  {$IFNDEF ADAPT_SUPPRESS_VERSION_WARNING}
    {.$IF FPC_VERSION < 3}
      {.$ERROR 'FreePascal (FPC) 3.0 or above is required for the ADAPT.'}
      {.$DEFINE ADAPT_WARNING_VERSION}
    {.$IFEND FPC_VERSION}
  {$ENDIF ADAPT_SUPPRESS_VERSION_WARNING}
{$ELSE}
  {$IFNDEF ADAPT_SUPPRESS_VERSION_WARNING}
    {$IFNDEF DELPHIXE2_UP}
      {$MESSAGE WARN 'Delphi 2010 and XE are not regularly tested with the ADAPT. Please report any issues on https://github.com/LaKraven/ADAPT'}
      {$DEFINE ADAPT_WARNING_VERSION}
    {$ENDIF DELPHIXE2_UP}
  {$ENDIF ADAPT_SUPPRESS_VERSION_WARNING}
{$ENDIF FPC}

{$IFDEF ADAPT_WARNING_VERSION}
  {$MESSAGE HINT 'Define "ADAPT_SUPPRESS_VERSION_WARNING" in your project options to get rid of these messages'}
  {$UNDEF ADAPT_WARNING_VERSION}
{$ENDIF ADAPT_WARNING_VERSION}

{$IFNDEF ADAPT_SUPPRESS_DEPRECATION_WARNING}
  // Nothing deprecated to warn about at this moment
  {$IFDEF ADAPT_WARNING_DEPRECATION}
    {$MESSAGE HINT 'Define "ADAPT_SUPPRESS_DEPRECATION_WARNING" in your project options to get rid of these messages'}
  {$ENDIF ADAPT_WARNING_DEPRECATION}
{$ENDIF ADAPT_SUPPRESS_DEPRECATION_WARNING}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes, System.SysUtils,
  {$ELSE}
    Classes, SysUtils,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Common.Intf;

  {$I ADAPT_RTTI.inc}

type
  { Class Forward Declarations }
  TADObject = class;
  TADPersistent = class;
  TADAggregatedObject = class;

  ///  <summary><c>ADAPT Base Excpetion Type.</c></summary>
  EADException = class abstract(Exception);
    EADGenericsIterateException = class(EADException);
      EADGenericsIterateDirectionUnknownException = class(EADGenericsIterateException);
    EADGenericsRangeException = class(EADException);
    EADGenericsParameterInvalidException = class(EADException);
      EADGenericsCapacityLessThanCount = class(EADGenericsParameterInvalidException);
      EADGenericsCompactorNilException = class(EADGenericsParameterInvalidException);
      EADGenericsExpanderNilException = class(EADGenericsParameterInvalidException);


  ///  <summary><c>ADAPT Base Object Type.</c></summary>
  ///  <remarks><c>All Classes in ADAPT are Interfaced unless otherwise stated.</c></remarks>
  TADObject = class abstract(TInterfacedObject, IADInterface)
  private
    function GetInstanceGUID: TGUID;
  protected
    FInstanceGUID: TGUID;
  public
    constructor Create; virtual;
    property InstanceGUID: TGUID read GetInstanceGUID;
  end;

  ///  <summary><c>ADAPT Base Persistent Type.</c></summary>
  ///  <remarks>
  ///    <para><c>All Classes in ADAPT are Interfaced unless otherwise stated.</c></para>
  ///    <para><c>There is no Reference Counting on Persistent Types.</c></para>
  ///  </remarks>
  TADPersistent = class abstract(TInterfacedPersistent, IADInterface)
  private
    function GetInstanceGUID: TGUID;
  protected
    FInstanceGUID: TGUID;
  public
    constructor Create; virtual;
    property InstanceGUID: TGUID read GetInstanceGUID;
  end;

  ///  <summary><c>ADAPT Base Aggregated Object Type.</c></summary>
  ///  <remarks><c>All Classes in ADAPT are Interfaced unless otherwise stated.</c></remarks>
  TADAggregatedObject = class abstract(TAggregatedObject, IADInterface)
  private
    function GetInstanceGUID: TGUID;
  protected
    FInstanceGUID: TGUID;
  public
    constructor Create(const Controller: IInterface); reintroduce; virtual;
    property InstanceGUID: TGUID read GetInstanceGUID;
  end;

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
    // Setters
    procedure SetValue(const AValue: TValue);
  public
    constructor Create(const AKey: TKey; const AValue: TValue); reintroduce;
    // Properties
    property Key: TKey read GetKey;
    property Value: TValue read GetValue write SetValue;
  end;

const
  {$IFDEF ADAPT_FLOAT_SINGLE}
    ///  <summary><c>Zero value for ADFloat values.</c></summary>
    ADFLOAT_ZERO = 0.00;
  {$ELSE}
    {$IFDEF ADAPT_FLOAT_EXTENDED}
      ///  <summary><c>Zero value for ADFloat values.</c></summary>
      ADFLOAT_ZERO = 0.00;
    {$ELSE}
      ///  <summary><c>Zero value for ADFloat values.</c></summary>
      ADFLOAT_ZERO = 0.00;
    {$ENDIF ADAPT_FLOAT_DOUBLE}
  {$ENDIF ADAPT_FLOAT_SINGLE}

implementation

{ TADObject }

constructor TADObject.Create;
begin
  CreateGUID(FInstanceGUID);
end;

function TADObject.GetInstanceGUID: TGUID;
begin
  Result := FInstanceGUID;
end;

{ TADPersistent }

constructor TADPersistent.Create;
begin
  inherited Create;
  CreateGUID(FInstanceGUID);
end;

function TADPersistent.GetInstanceGUID: TGUID;
begin
  Result := FInstanceGUID;
end;

{ TADAggregatedObject }

constructor TADAggregatedObject.Create(const Controller: IInterface);
begin
  inherited Create(Controller);
  CreateGUID(FInstanceGUID);
end;

function TADAggregatedObject.GetInstanceGUID: TGUID;
begin
  Result := FInstanceGUID;
end;

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

procedure TADKeyValuePair<TKey, TValue>.SetValue(const AValue: TValue);
begin
  FValue := AValue;
end;

end.
