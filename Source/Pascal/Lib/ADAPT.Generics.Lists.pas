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
  { Interface Forward Declarations }
  IADListExpander = interface;
  IADListExpanderGeometric = interface;
  IADListCompactor = interface;
  IADList<T> = interface;
  { Class Forward Declarations }
  TADListExpander = class;
  TADListExpanderDefault = class;
  TADListExpanderGeometric = class;
  TADListExpanderGeometricTS = class;
  TADListCompactor = class;
  TADList<T> = class;

  ///  <summary><c>An Allocation Algorithm for Lists.</c></summary>
  ///  <remarks><c>Dictates how to grow an Array based on its current Capacity and the number of Items we're looking to Add/Insert.</c></remarks>
  IADListExpander = interface(IADInterface)
  ['{B4742A80-74A7-408E-92BA-F854515B6D24}']
    function CheckExpand(const ACapacity, ACurrentcount, AAdditionalRequired: Integer): Integer;
  end;

  ///  <summary><c>A Geometric Allocation Algorithm for Lists.</c></summary>
  ///  <remarks>
  ///    <para><c>When the number of Vacant Slots falls below the Threshold, the number of Vacant Slots increases by the value of the current Capacity multiplied by the Mulitplier.</c></para>
  ///  </remarks>
  IADListExpanderGeometric = interface(IADListExpander)
  ['{CAF4B15C-9BE5-4A66-B31F-804AB752A102}']
    // Getters
    function GetCapacityMultiplier: Single;
    function GetCapacityThreshold: Integer;
    // Setters
    procedure SetCapacityMultiplier(const AMultiplier: Single);
    procedure SetCapacityThreshold(const AThreshold: Integer);
    // Properties
    property CapacityMultiplier: Single read GetCapacityMultiplier write SetCapacityMultiplier;
    property CapacityThreshold: Integer read GetCapacityThreshold write SetCapacityThreshold;
  end;

  ///  <summary><c>A Deallocation Algorithm for Lists.</c></summary>
  ///  <remarks><c>Dictates how to shrink an Array based on its current Capacity and the number of Items we're looking to Delete.</c></remarks>
  IADListCompactor = interface(IADInterface)
  ['{B7D577D4-8425-4C5D-9DDB-5864C3676199}']
    function CheckCompact(const ACapacity, ACurrentCount, AVacating: Integer): Integer;
  end;

  ///  <summary><c>Generic List Type</c></summary>
  IADList<T> = interface
  ['{89F7688F-8C90-4165-9CC9-73B07826381A}']
    // Getters
    function GetCapacity: Integer;
    function GetCompactor: IADListCompactor;
    function GetCount: Integer;
    function GetExpander: IADListExpander;
    function GetInitialCapacity: Integer;
    function GetItem(const AIndex: Integer): T;
    // Setters
    procedure SetCapacity(const ACapacity: Integer);
    procedure SetCompactor(const ACompactor: IADListCompactor);
    procedure SetExpander(const AExpander: IADListExpander);
    procedure SetItem(const AIndex: Integer; const AItem: T);
    // Management Methods
    procedure Add(const AItem: T); overload;
    procedure Add(const AList: IADList<T>); overload;
    procedure AddItems(const AItems: Array of T);
    procedure Clear;
    procedure Delete(const AIndex: Integer);
    procedure DeleteRange(const AFirst, ACount: Integer);
    procedure Insert(const AItem: T; const AIndex: Integer);
    procedure InsertItems(const AItems: TArray<T>; const AIndex: Integer);
    // Properties
    property Capacity: Integer read GetCapacity write SetCapacity;
    property Compactor: IADListCompactor read GetCompactor;
    property Count: Integer read GetCount;
    property Expander: IADListExpander read GetExpander;
    property InitialCapacity: Integer read GetInitialCapacity;
    property Items[const AIndex: Integer]: T read GetItem write SetItem; default;
  end;

  ///  <summary><c>An Allocation Algorithm for Lists.</c></summary>
  ///  <remarks><c>Dictates how to grow an Array based on its current Capacity and the number of Items we're looking to Add/Insert.</c></remarks>
  TADListExpander = class abstract(TADObject, IADListExpander)
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
  TADListExpanderGeometric = class(TADListExpander, IADListExpanderGeometric)
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
  TADListCompactor = class abstract(TADObject, IADListCompactor)
  public
    function CheckCompact(const ACapacity, ACurrentCount, AVacating: Integer): Integer; virtual; abstract;
  end;

  ///  <summary><c>The Default Deallocation Algorithm for Lists.</c></summary>
  ///  <remarks><c>By default, the Array will shrink by 1 each time an Item is removed.</c></remarks>
  TADListCompactorDefault = class(TADListCompactor)
  public
    function CheckCompact(const ACapacity, ACurrentCount, AVacating: Integer): Integer; override;
  end;

  TADListExpanderType = class of TADListExpander;
  TADListCompactorType = class of TADListCompactor;

  ///  <summary><c>Generic List Type</c></summary>
  ///  <remarks>
  ///    <para><c>This type is NOT Threadsafe.</c></para>
  ///  </remarks>
  TADList<T> = class(TADObject, IADList<T>)
  private
    FCompactor: IADListCompactor;
    FExpander: IADListExpander;
    FInitialCapacity: Integer;
  protected
    FArray: TADArray<T>;
    // Getters
    function GetCapacity: Integer;
    function GetCompactor: IADListCompactor;
    function GetCount: Integer;
    function GetExpander: IADListExpander;
    function GetInitialCapacity: Integer;
    function GetItem(const AIndex: Integer): T;
    // Setters
    procedure SetCapacity(const ACapacity: Integer);
    procedure SetCompactor(const ACompactor: IADListCompactor);
    procedure SetExpander(const AExpander: IADListExpander);
    procedure SetItem(const AIndex: Integer; const AItem: T);
  public
    ///  <summary><c>Creates an instance of your List using the Default Expander and Compactor Types.</c></summary>
    constructor Create(const AInitialCapacity: Integer = 0); reintroduce; overload; virtual;
    ///  <summary><c>Creates an instance of your List using a Custom Expander, and the default Compactor Type.</c></summary>
    constructor Create(const AExpanderType: TADListExpanderType; const AInitialCapacity: Integer = 0); reintroduce; overload; virtual;
    ///  <summary><c>Creates an instance of your List using the Default Expander, and a Custom Conpactor Type.</c></summary>
    constructor Create(const ACompactorType: TADListCompactorType; const AInitialCapacity: Integer = 0); reintroduce; overload; virtual;
    ///  <summary><c>Creates an instance of your List using a Custom Expander and Compactor Type.</c></summary>
    constructor Create(const AExpanderType: TADListExpanderType; const ACompactorType: TADListCompactorType; const AInitialCapacity: Integer = 0); reintroduce; overload; virtual;
    ///  <summary><c>Creates an instance of your List using a Custom Expander Instance, and the default Compactor Type.</c></summary>
    constructor Create(const AExpander: IADListExpander; const AInitialCapacity: Integer = 0); reintroduce; overload; virtual;
    ///  <summary><c>Creates an instance of your List using the default Expander Type, and a Custom Compactor Instance.</c></summary>
    constructor Create(const ACompactor: IADListCompactor; const AInitialCapacity: Integer = 0); reintroduce; overload; virtual;
    ///  <summary><c>Creates an instance of your List using a Custom Expander and Compactor Instance.</c></summary>
    constructor Create(const AExpander: IADListExpander; const ACompactor: IADListCompactor; const AInitialCapacity: Integer = 0); reintroduce; overload; virtual;
    destructor Destroy; override;
    // Management Methods
    procedure Add(const AItem: T); overload;
    procedure Add(const AList: IADList<T>); overload;
    procedure AddItems(const AItems: Array of T);
    procedure Clear;
    procedure Delete(const AIndex: Integer);
    procedure DeleteRange(const AFirst, ACount: Integer);
    procedure Insert(const AItem: T; const AIndex: Integer);
    procedure InsertItems(const AItems: TArray<T>; const AIndex: Integer);
    // Properties
    property Capacity: Integer read GetCapacity write SetCapacity;
    property Compactor: IADListCompactor read GetCompactor;
    property Count: Integer read GetCount;
    property Expander: IADListExpander read GetExpander;
    property InitialCapacity: Integer read GetInitialCapacity;
    property Items[const AIndex: Integer]: T read GetItem write SetItem; default;
  end;

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

{ TADList<T> }

constructor TADList<T>.Create(const AInitialCapacity: Integer = 0);
begin
  Create(TADListExpanderDefault, TADListCompactorDefault, AInitialCapacity);
end;

constructor TADList<T>.Create(const AExpanderType: TADListExpanderType; const AInitialCapacity: Integer = 0);
begin
  Create(AExpanderType, TADListCompactorDefault, AInitialCapacity);
end;

constructor TADList<T>.Create(const ACompactorType: TADListCompactorType; const AInitialCapacity: Integer = 0);
begin
  Create(TADListExpanderDefault, ACompactorType, AInitialCapacity);
end;

constructor TADList<T>.Create(const AExpanderType: TADListExpanderType; const ACompactorType: TADListCompactorType; const AInitialCapacity: Integer = 0);
begin
  Create(AExpanderType.Create, ACompactorType.Create, AInitialCapacity);
end;

constructor TADList<T>.Create(const AExpander: IADListExpander; const AInitialCapacity: Integer = 0);
begin
  Create(AExpander, TADListCompactorDefault.Create, AInitialCapacity);
end;

constructor TADList<T>.Create(const ACompactor: IADListCompactor; const AInitialCapacity: Integer = 0);
begin
  Create(TADListExpanderDefault.Create, ACompactor, AInitialCapacity);
end;

procedure TADList<T>.Add(const AItem: T);
begin

end;

procedure TADList<T>.Add(const AList: IADList<T>);
begin

end;

procedure TADList<T>.AddItems(const AItems: array of T);
begin

end;

procedure TADList<T>.Clear;
begin

end;

constructor TADList<T>.Create(const AExpander: IADListExpander; const ACompactor: IADListCompactor; const AInitialCapacity: Integer = 0);
begin
  inherited Create;
  FCompactor := ACompactor;
  FExpander := AExpander;
  FInitialCapacity := AInitialCapacity;
  FArray := TADArray<T>.Create(AInitialCapacity);
end;

procedure TADList<T>.Delete(const AIndex: Integer);
begin

end;

procedure TADList<T>.DeleteRange(const AFirst, ACount: Integer);
begin

end;

destructor TADList<T>.Destroy;
begin
  FExpander := nil;
  FCompactor := nil;
  FArray.{$IFDEF SUPPORTS_DISPOSEOF}DisposeOf{$ELSE}Free{$ENDIF SUPPORTS_DISPOSEOF};
  inherited;
end;

function TADList<T>.GetCapacity: Integer;
begin

end;

function TADList<T>.GetCompactor: IADListCompactor;
begin
  Result := FCompactor;
end;

function TADList<T>.GetCount: Integer;
begin

end;

function TADList<T>.GetExpander: IADListExpander;
begin
  Result := FExpander;
end;

function TADList<T>.GetInitialCapacity: Integer;
begin
  Result := FInitialCapacity;
end;

function TADList<T>.GetItem(const AIndex: Integer): T;
begin

end;

procedure TADList<T>.Insert(const AItem: T; const AIndex: Integer);
begin

end;

procedure TADList<T>.InsertItems(const AItems: TArray<T>;
  const AIndex: Integer);
begin

end;

procedure TADList<T>.SetCapacity(const ACapacity: Integer);
begin

end;

procedure TADList<T>.SetCompactor(const ACompactor: IADListCompactor);
begin

end;

procedure TADList<T>.SetExpander(const AExpander: IADListExpander);
begin

end;

procedure TADList<T>.SetItem(const AIndex: Integer; const AItem: T);
begin

end;

end.
