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
unit ADAPT.Generics.Lists;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes, System.SysUtils,
  {$ELSE}
    Classes, SysUtils,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Common,
  ADAPT.Generics.Defaults, ADAPT.Generics.Arrays;

  {$I ADAPT_RTTI.inc}

type
  ///  <summary><c>An Allocation Algorithm for Lists.</c></summary>
  ///  <remarks><c>Dictates how to grow an Array based on its current Capacity and the number of Items we're looking to Add/Insert.</c></remarks>
  TADListExpander = class abstract(TADObject)
  public
    ///  <summary><c>Override this to implement the actual Allocation Algorithm</c></summary>
    ///  <remarks><c>Must return the amount by which the Array has been Expanded.</c></remarks>
    function CheckExpand(const ACapacity, ACurrentCount, AAdditionalRequired: Integer): Integer; virtual; abstract;
  end;

  ///  <summary><c>The Default Allocation Algorithm for Lists.</c></summary>
  ///  <remarks><c>By default, the Array will grow by 1 each time it becomes full</c></remarks>
  TADListExpanderDefault = class(TADListExpander)
  public
    function CheckExpand(const ACapacity, ACurrentCount, AAdditionalRequired: Integer): Integer; override;
  end;

  ///  <summary><c>A Geometric Allocation Algorithm for Lists.</c></summary>
  ///  <remarks>
  ///    <para><c>When the number of Vacant Slots falls below the Threshold, the number of Vacant Slots increases by the value of the current Capacity multiplied by the Mulitplier.</c></para>
  ///    <para><c>This Expander Type is NOT Threadsafe.</c></para>
  ///  </remarks>
  TADListExpanderGeometric = class(TADListExpander)
  private
    FMultiplier: Single;
    FThreshold: Integer;
  protected
    // Getters
    function GetCapacityMultiplier: Single; virtual;
    function GetCapacityThreshold: Integer; virtual;
    // Setters
    procedure SetCapacityMultiplier(const AMultiplier: Single); virtual;
    procedure SetCapacityThreshold(const AThreshold: Integer); virtual;
  public
    function CheckExpand(const ACapacity, ACurrentCount, AAdditionalRequired: Integer): Integer; override;
  public
    // Properties
    property CapacityMultiplier: Single read GetCapacityMultiplier write SetCapacityMultiplier;
    property CapacityThreshold: Integer read GetCapacityThreshold write SetCapacityThreshold;
  end;

  ///  <summary><c>A Geometric Allocation Algorithm for Lists.</c></summary>
  ///  <remarks>
  ///    <para><c>When the number of Vacant Slots falls below the Threshold, the number of Vacant Slots increases by the value of the current Capacity multiplied by the Mulitplier.</c></para>
  ///    <para><c>This Expander Type is Threadsafe.</c></para>
  ///  </remarks>
  TADListExpanderGeometricTS = class(TADListExpanderGeometric, IADReadWriteLock)
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

  ///  <summary><c>A Deallocation Algorithm for Lists.</c></summary>
  ///  <remarks><c>Dictates how to shrink an Array based on its current Capacity and the number of Items we're looking to Delete.</c></remarks>
  TADListCompactor = class abstract(TADObject)
  public
    function CheckCompact(const ACapacity, ACurrentCount, AVacating: Integer): Integer; virtual; abstract;
  end;

  ///  <summary><c>The Default Deallocation Algorithm for Lists.</c></summary>
  ///  <remarks><c>By default, the Array will shrink by 1 each time an Item is removed.</c></remarks>
  TADListCompactorDefault = class(TADListCompactor)
  public
    function CheckCompact(const ACapacity, ACurrentCount, AVacating: Integer): Integer; override;
  end;

  { Interface Forward Declarations }
  IADList<T; TExpander: TADListExpander, constructor; TCompactor: TADListCompactor, constructor> = interface;
  { Class Forward Declarations }
  TADList<T; TExpander: TADListExpander, constructor; TCompactor: TADListCompactor, constructor> = class;
//  TADListTS<T; TExpander: TADListExpander, constructor; TCompactor: TADListCompactor, constructor> = class;

  ///  <summary><c>Generic List Type with Dynamic Expander and Compactor</c></summary>
  IADList<T; TExpander: TADListExpander, constructor; TCompactor: TADListCompactor, constructor> = interface
  ['{891BA246-B06C-4B8D-84BD-57878BBB6991}']
    function GetCompactor: TCompactor;
    function GetExpander: TExpander;
    function GetInitialCapacity: Integer;

    property Compactor: TCompactor read GetCompactor;
    property Expander: TExpander read GetExpander;
    property InitialCapacity: Integer read GetInitialCapacity;
  end;

  ///  <summary><c>Generic List Type with Dynamic Expander and Compactor</c></summary>
  ///  <remarks>
  ///    <para><c>This type is NOT Threadsafe.</c></para>
  ///  </remarks>
  TADList<T; TExpander: TADListExpander, constructor; TCompactor: TADListCompactor, constructor> = class(TADObject, IADList<T, TExpander, TCompactor>)
  private
    FCompactor: TCompactor;
    FExpander: TExpander;
  protected
    FArray: TADArray<T>;
    FInitialCapacity: Integer;
    // Getters
    function GetCompactor: TCompactor;
    function GetExpander: TExpander;
    function GetInitialCapacity: Integer; virtual;
  public
    constructor Create(const AInitialCapacity: Integer = 0); reintroduce; virtual;
    destructor Destroy; override;

    property Compactor: TCompactor read GetCompactor;
    property Expander: TExpander read GetExpander;
    property InitialCapacity: Integer read GetInitialCapacity;
  end;

  ///  <summary><c>Generic List Type with Dynamic Expander and Compactor</c></summary>
  ///  <remarks>
  ///    <para><c>This type is Threadsafe.</c></para>
  ///  </remarks>
//  TADListTS<T; TExpander: TADListExpander, constructor; TCompactor: TADListCompactor, constructor> = class(TADObject, IADList<T, TExpander, TCompactor>, IADReadWriteLock)
//
//  end;

implementation

{ TADListExpanderDefault }

function TADListExpanderDefault.CheckExpand(const ACapacity, ACurrentCount, AAdditionalRequired: Integer): Integer;
begin
  if ACurrentCount + AAdditionalRequired > ACapacity then
    Result := (ACapacity - ACurrentCount) + AAdditionalRequired
  else
    Result := 0;
end;

{ TADListExpanderGeometric }

function TADListExpanderGeometric.CheckExpand(const ACapacity, ACurrentCount, AAdditionalRequired: Integer): Integer;
begin
  // TODO -oDaniel -cTADListExpanderGeometric: Implement Geometric Expansion Algorithm
  if ACurrentCount + AAdditionalRequired > ACapacity then
    Result := (ACapacity - ACurrentCount) + AAdditionalRequired
  else
    Result := 0;
end;

function TADListExpanderGeometric.GetCapacityMultiplier: Single;
begin
  Result := FMultiplier;
end;

function TADListExpanderGeometric.GetCapacityThreshold: Integer;
begin
  Result := FThreshold;
end;

procedure TADListExpanderGeometric.SetCapacityMultiplier(const AMultiplier: Single);
begin
  FMultiplier := AMultiplier;
end;

procedure TADListExpanderGeometric.SetCapacityThreshold(const AThreshold: Integer);
begin
  FThreshold := AThreshold;
end;

{ TADListExpanderGeometricTS }

constructor TADListExpanderGeometricTS.Create;
begin
  inherited;
  FLock := TADReadWriteLock.Create(Self);
end;

destructor TADListExpanderGeometricTS.Destroy;
begin
  FLock.Free;
  inherited;
end;

function TADListExpanderGeometricTS.GetCapacityMultiplier: Single;
begin
  FLock.AcquireRead;
  try
    Result := inherited;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADListExpanderGeometricTS.GetCapacityThreshold: Integer;
begin
  FLock.AcquireRead;
  try
    Result := inherited;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADListExpanderGeometricTS.GetLock: IADReadWriteLock;
begin
  Result := FLock;
end;

procedure TADListExpanderGeometricTS.SetCapacityMultiplier(const AMultiplier: Single);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

procedure TADListExpanderGeometricTS.SetCapacityThreshold(const AThreshold: Integer);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

{ TADListCompactorDefault }

function TADListCompactorDefault.CheckCompact(const ACapacity, ACurrentCount, AVacating: Integer): Integer;
begin
  Result := AVacating;
end;

{ TADList<T, TExpander, TCompactor> }

constructor TADList<T, TExpander, TCompactor>.Create(const AInitialCapacity: Integer);
begin
  inherited Create;
  FCompactor := TCompactor.Create;
  FExpander := TExpander.Create;
  FInitialCapacity := AInitialCapacity;
  FArray := TADArray<T>.Create(AInitialCapacity);
end;

destructor TADList<T, TExpander, TCompactor>.Destroy;
begin
  FExpander.{$IFDEF SUPPORTS_DISPOSEOF}DisposeOf{$ELSE}Free{$ENDIF SUPPORTS_DISPOSEOF};
  FCompactor.{$IFDEF SUPPORTS_DISPOSEOF}DisposeOf{$ELSE}Free{$ENDIF SUPPORTS_DISPOSEOF};
  FArray.{$IFDEF SUPPORTS_DISPOSEOF}DisposeOf{$ELSE}Free{$ENDIF SUPPORTS_DISPOSEOF};
  inherited;
end;

function TADList<T, TExpander, TCompactor>.GetCompactor: TCompactor;
begin
  Result := FCompactor;
end;

function TADList<T, TExpander, TCompactor>.GetExpander: TExpander;
begin
  Result := FExpander;
end;

function TADList<T, TExpander, TCompactor>.GetInitialCapacity: Integer;
begin
  Result := FInitialCapacity;
end;

end.
