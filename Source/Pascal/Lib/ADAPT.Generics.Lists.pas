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
  IADObjectList<T: class> = interface;
  IADCircularList<T> = interface;
  IADCircularObjectList<T: class> = interface;
  { Class Forward Declarations }
  TADListExpander = class;
  TADListExpanderDefault = class;
  TADListExpanderGeometric = class;
  TADListExpanderGeometricTS = class;
  TADListCompactor = class;
  TADListCompactorDefault = class;
  TADList<T> = class;
  TADObjectList<T: class> = class;
  TADCircularList<T> = class;
  TADCircularObjectList<T: class> = class;
  TADListTS<T> = class;
  TADObjectListTS<T: class> = class;
  TADCircularListTS<T> = class;
  TADCircularObjectListTS<T: class> = class;

  EADGenericsExpanderNilException = class(EADGenericsParameterInvalidException);
  EADGenericsCompactorNilException = class(EADGenericsParameterInvalidException);
  EADGenericsCapacityLessThanCount = class(EADGenericsParameterInvalidException);

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
    procedure InsertItems(const AItems: Array of T; const AIndex: Integer);
    // Properties
    property Capacity: Integer read GetCapacity write SetCapacity;
    property Compactor: IADListCompactor read GetCompactor;
    property Count: Integer read GetCount;
    property Expander: IADListExpander read GetExpander;
    property InitialCapacity: Integer read GetInitialCapacity;
    property Items[const AIndex: Integer]: T read GetItem write SetItem; default;
  end;

  IADObjectList<T: class> = interface(IADList<T>)
  ['{9B5D42E7-0B73-4E6B-BDAD-AA3AB63E03C3}']
    // Getters
    function GetOwnership: TADOwnership;
    // Setters
    procedure SetOwnership(const AOwnership: TADOwnership);
    // Properties
    property Ownership: TADOwnership read GetOwnership write SetOwnership;
  end;

  IADCircularList<T> = interface(IADInterface)
  ['{AB8E1DFA-D287-4224-BB5B-66364B175956}']
    //TODO -oDaniel -cIADCircularList<T>: Complete interface
  end;

  IADCircularObjectList<T: class> = interface(IADCircularList<T>)
  ['{AA702AC4-A7E4-4A17-9CA5-239199030AFE}']
    //TODO -oDaniel -cIADCircularObjectList<T>: Complete interface
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
    FCount: Integer;
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
    ///  <summary><c>Adds the Item to the first available Index of the Array WITHOUT checking capacity.</c></summary>
    procedure AddActual(const AItem: T);
    ///  <summary><c>Override to constructor an alternative Array type</c></summary>
    procedure CreateArray(const AInitialCapacity: Integer = 0); virtual;
    ///  <summary><c>Compacts the Array according to the given Compactor Algorithm.</c></summary>
    procedure CheckCompact(const AAmount: Integer);
    ///  <summary><c>Expands the Array according to the given Expander Algorithm.</c></summary>
    procedure CheckExpand(const AAmount: Integer);
  public
    ///  <summary><c>Creates an instance of your List using the Default Expander and Compactor Types.</c></summary>
    constructor Create(const AInitialCapacity: Integer = 0); reintroduce; overload;
    ///  <summary><c>Creates an instance of your List using a Custom Expander, and the default Compactor Type.</c></summary>
    constructor Create(const AExpanderType: TADListExpanderType; const AInitialCapacity: Integer = 0); reintroduce; overload;
    ///  <summary><c>Creates an instance of your List using the Default Expander, and a Custom Conpactor Type.</c></summary>
    constructor Create(const ACompactorType: TADListCompactorType; const AInitialCapacity: Integer = 0); reintroduce; overload;
    ///  <summary><c>Creates an instance of your List using a Custom Expander and Compactor Type.</c></summary>
    constructor Create(const AExpanderType: TADListExpanderType; const ACompactorType: TADListCompactorType; const AInitialCapacity: Integer = 0); reintroduce; overload;
    ///  <summary><c>Creates an instance of your List using a Custom Expander Instance, and the default Compactor Type.</c></summary>
    constructor Create(const AExpander: IADListExpander; const AInitialCapacity: Integer = 0); reintroduce; overload;
    ///  <summary><c>Creates an instance of your List using the default Expander Type, and a Custom Compactor Instance.</c></summary>
    constructor Create(const ACompactor: IADListCompactor; const AInitialCapacity: Integer = 0); reintroduce; overload;
    ///  <summary><c>Creates an instance of your List using a Custom Expander and Compactor Instance.</c></summary>
    constructor Create(const AExpander: IADListExpander; const ACompactor: IADListCompactor; const AInitialCapacity: Integer = 0); reintroduce; overload; virtual;
    destructor Destroy; override;
    // Management Methods
    procedure Add(const AItem: T); overload; virtual;
    procedure Add(const AList: IADList<T>); overload; virtual;
    procedure AddItems(const AItems: Array of T); virtual;
    procedure Clear; virtual;
    procedure Delete(const AIndex: Integer); virtual;
    procedure DeleteRange(const AFirst, ACount: Integer); virtual;
    procedure Insert(const AItem: T; const AIndex: Integer); virtual;
    procedure InsertItems(const AItems: Array of T; const AIndex: Integer); virtual;
    // Properties
    property Capacity: Integer read GetCapacity write SetCapacity;
    property Compactor: IADListCompactor read GetCompactor;
    property Count: Integer read GetCount;
    property Expander: IADListExpander read GetExpander;
    property InitialCapacity: Integer read GetInitialCapacity;
    property Items[const AIndex: Integer]: T read GetItem write SetItem; default;
  end;

  TADObjectList<T: class> = class(TADList<T>, IADObjectList<T>)
  private type
    TADObjectArrayT = class(TADObjectArray<T>);
  protected
    // Getters
    function GetOwnership: TADOwnership; virtual;
    // Setters
    procedure SetOwnership(const AOwnership: TADOwnership); virtual;
    // Management Methods
    ///  <summary><c>We need a TADObjectArray instead.</c></summary>
    procedure CreateArray(const AInitialCapacity: Integer = 0); override;
  public
    ///  <summary><c>Creates an instance of your List using the Default Expander and Compactor Types.</c></summary>
    constructor Create(const AInitialCapacity: Integer = 0; const AOwnership: TADOwnership = oOwnsObjects); reintroduce; overload;
    ///  <summary><c>Creates an instance of your List using a Custom Expander, and the default Compactor Type.</c></summary>
    constructor Create(const AExpanderType: TADListExpanderType; const AInitialCapacity: Integer = 0; const AOwnership: TADOwnership = oOwnsObjects); reintroduce; overload;
    ///  <summary><c>Creates an instance of your List using the Default Expander, and a Custom Conpactor Type.</c></summary>
    constructor Create(const ACompactorType: TADListCompactorType; const AInitialCapacity: Integer = 0; const AOwnership: TADOwnership = oOwnsObjects); reintroduce; overload;
    ///  <summary><c>Creates an instance of your List using a Custom Expander and Compactor Type.</c></summary>
    constructor Create(const AExpanderType: TADListExpanderType; const ACompactorType: TADListCompactorType; const AInitialCapacity: Integer = 0; const AOwnership: TADOwnership = oOwnsObjects); reintroduce; overload;
    ///  <summary><c>Creates an instance of your List using a Custom Expander Instance, and the default Compactor Type.</c></summary>
    constructor Create(const AExpander: IADListExpander; const AInitialCapacity: Integer = 0; const AOwnership: TADOwnership = oOwnsObjects); reintroduce; overload;
    ///  <summary><c>Creates an instance of your List using the default Expander Type, and a Custom Compactor Instance.</c></summary>
    constructor Create(const ACompactor: IADListCompactor; const AInitialCapacity: Integer = 0; const AOwnership: TADOwnership = oOwnsObjects); reintroduce; overload;
    ///  <summary><c>Creates an instance of your List using a Custom Expander and Compactor Instance.</c></summary>
    constructor Create(const AExpander: IADListExpander; const ACompactor: IADListCompactor; const AInitialCapacity: Integer = 0; const AOwnership: TADOwnership = oOwnsObjects); reintroduce; overload; virtual;

    // Properties
    property Ownership: TADOwnership read GetOwnership write SetOwnership;
  end;

  TADCircularList<T> = class(TADObject, IADCircularList<T>)
  public
    constructor Create; override;
    destructor Destroy; override;
  end;

  TADCircularObjectList<T: class> = class(TADCircularList<T>, IADCircularObjectList<T>)
  public
    constructor Create; override;
    destructor Destroy; override;
  end;

  TADListTS<T> = class(TADList<T>, IADReadWriteLock)
  private
    FLock: TADReadWriteLock;
    function GetLock: IADReadWriteLock;
  public
    ///  <summary><c>Creates an instance of your List using a Custom Expander and Compactor Instance.</c></summary>
    constructor Create(const AExpander: IADListExpander; const ACompactor: IADListCompactor; const AInitialCapacity: Integer = 0); overload; override;
    destructor Destroy; override;

    property Lock: IADReadWriteLock read GetLock implements IADReadWriteLock;
  end;

  TADObjectListTS<T: class> = class(TADObjectList<T>, IADReadWriteLock)
  private
    FLock: TADReadWriteLock;
    function GetLock: IADReadWriteLock;
  public
    ///  <summary><c>Creates an instance of your List using a Custom Expander and Compactor Instance.</c></summary>
    constructor Create(const AExpander: IADListExpander; const ACompactor: IADListCompactor; const AInitialCapacity: Integer = 0; const AOwnership: TADOwnership = oOwnsObjects); overload; override;
    destructor Destroy; override;

    property Lock: IADReadWriteLock read GetLock implements IADReadWriteLock;
  end;

  TADCircularListTS<T> = class(TADCircularList<T>, IADReadWriteLock)
  private
    FLock: TADReadWriteLock;
    function GetLock: IADReadWriteLock;
  public
    constructor Create; override;
    destructor Destroy; override;

    property Lock: IADReadWriteLock read GetLock implements IADReadWriteLock;
  end;

  TADCircularObjectListTS<T: class> = class(TADCircularObjectList<T>, IADReadWriteLock)
  private
    FLock: TADReadWriteLock;
    function GetLock: IADReadWriteLock;
  public
    constructor Create; override;
    destructor Destroy; override;

    property Lock: IADReadWriteLock read GetLock implements IADReadWriteLock;
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
  CheckExpand(1);
  AddActual(AItem);
  Inc(FCount);
end;

procedure TADList<T>.Add(const AList: IADList<T>);
var
  I: Integer;
begin
  CheckExpand(AList.Count);
  for I := 0 to AList.Count - 1 do
    AddActual(AList[I]);
  Inc(FCount, AList.Count);
end;

procedure TADList<T>.AddActual(const AItem: T);
begin
  FArray[FCount] := AItem;
end;

procedure TADList<T>.AddItems(const AItems: Array of T);
var
  I: Integer;
begin
  CheckExpand(Length(AItems));
  for I := Low(AItems) to High(AItems) do
    AddActual(AItems[I]);
  Inc(FCount, Length(AItems));
end;

procedure TADList<T>.CheckCompact(const AAmount: Integer);
var
  LShrinkBy: Integer;
begin
  LShrinkBy := FCompactor.CheckCompact(FArray.Capacity, FCount, AAmount);
  if LShrinkBy > 0 then
    FArray.Capacity := FArray.Capacity - LShrinkBy;
end;

procedure TADList<T>.CheckExpand(const AAmount: Integer);
var
  LNewCapacity: Integer;
begin
  LNewCapacity := FExpander.CheckExpand(FArray.Capacity, FCount, AAmount);
  if LNewCapacity > 0 then
    FArray.Capacity := FArray.Capacity + LNewCapacity;
end;

procedure TADList<T>.Clear;
begin
  FArray.Finalize(0, FCount);
  FCount := 0;
  FArray.Capacity := FInitialCapacity;
end;

constructor TADList<T>.Create(const AExpander: IADListExpander; const ACompactor: IADListCompactor; const AInitialCapacity: Integer = 0);
begin
  inherited Create;
  FCount := 0;
  FCompactor := ACompactor;
  FExpander := AExpander;
  FInitialCapacity := AInitialCapacity;
  CreateArray(AInitialCapacity);
end;

procedure TADList<T>.CreateArray(const AInitialCapacity: Integer = 0);
begin
  FArray := TADArray<T>.Create(AInitialCapacity);
end;

procedure TADList<T>.Delete(const AIndex: Integer);
begin
  FArray.Finalize(AIndex, 1);
  if AIndex < FCount - 1 then
    FArray.Move(AIndex + 1, AIndex, FCount - AIndex); // Shift all subsequent items left by 1
  Dec(FCount);
  CheckCompact(1);
end;

procedure TADList<T>.DeleteRange(const AFirst, ACount: Integer);
begin
  FArray.Finalize(AFirst, ACount);
  if AFirst + FCount < FCount - 1 then
    FArray.Move(AFirst + FCount + 1, AFirst, ACount); // Shift all subsequent items left
  Dec(FCount, ACount);
  CheckCompact(ACount);
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
  Result := FArray.Capacity;
end;

function TADList<T>.GetCompactor: IADListCompactor;
begin
  Result := FCompactor;
end;

function TADList<T>.GetCount: Integer;
begin
  Result := FCount;
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
  Result := FArray[AIndex];
end;

procedure TADList<T>.Insert(const AItem: T; const AIndex: Integer);
begin
  //TODO -oDaniel -cTADList<T>: Implement Insert method
end;

procedure TADList<T>.InsertItems(const AItems: Array of T; const AIndex: Integer);
begin
  //TODO -oDaniel -cTADList<T>: Implement InsertItems method
end;

procedure TADList<T>.SetCapacity(const ACapacity: Integer);
begin
  if ACapacity < FCount then
    raise EADGenericsCapacityLessThanCount.CreateFmt('Given Capacity of %d insufficient for a List containing %d Items.', [ACapacity, FCount])
  else
    FArray.Capacity := ACapacity;
end;

procedure TADList<T>.SetCompactor(const ACompactor: IADListCompactor);
begin
  if ACompactor = nil then
    raise EADGenericsCompactorNilException.Create('Cannot assign a Nil Compactor.')
  else
    FCompactor := ACompactor;
end;

procedure TADList<T>.SetExpander(const AExpander: IADListExpander);
begin
  if AExpander = nil then
    raise EADGenericsExpanderNilException.Create('Cannot assign a Nil Expander.')
  else
    FExpander := AExpander;
end;

procedure TADList<T>.SetItem(const AIndex: Integer; const AItem: T);
begin

end;

{ TADListTS<T> }

constructor TADListTS<T>.Create(const AExpander: IADListExpander; const ACompactor: IADListCompactor; const AInitialCapacity: Integer);
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

end;

{ TADObjectList<T> }

constructor TADObjectList<T>.Create(const AInitialCapacity: Integer; const AOwnership: TADOwnership);
begin
  Create(TADListExpanderDefault, TADListCompactorDefault, AInitialCapacity, AOwnership);
end;

constructor TADObjectList<T>.Create(const ACompactorType: TADListCompactorType; const AInitialCapacity: Integer; const AOwnership: TADOwnership);
begin
  Create(TADListExpanderDefault.Create, ACompactorType.Create, AInitialCapacity, AOwnership);
end;

constructor TADObjectList<T>.Create(const AExpanderType: TADListExpanderType; const AInitialCapacity: Integer; const AOwnership: TADOwnership);
begin
  Create(AExpanderType.Create, TADListCompactorDefault.Create, AInitialCapacity, AOwnership);
end;

constructor TADObjectList<T>.Create(const AExpanderType: TADListExpanderType; const ACompactorType: TADListCompactorType; const AInitialCapacity: Integer; const AOwnership: TADOwnership);
begin
  Create(AExpanderType.Create, ACompactorType.Create, AInitialCapacity, AOwnership);
end;

constructor TADObjectList<T>.Create(const ACompactor: IADListCompactor; const AInitialCapacity: Integer; const AOwnership: TADOwnership);
begin
  Create(TADListExpanderDefault.Create, ACompactor, AInitialCapacity, AOwnership);
end;

constructor TADObjectList<T>.Create(const AExpander: IADListExpander; const AInitialCapacity: Integer; const AOwnership: TADOwnership);
begin
  Create(AExpander, TADListCompactorDefault.Create, AInitialCapacity, AOwnership);
end;

constructor TADObjectList<T>.Create(const AExpander: IADListExpander; const ACompactor: IADListCompactor; const AInitialCapacity: Integer; const AOwnership: TADOwnership);
begin
  inherited Create(AExpander, ACompactor, AInitialCapacity);
  TADObjectArrayT(FArray).Ownership := AOwnership;
end;

procedure TADObjectList<T>.CreateArray(const AInitialCapacity: Integer = 0);
begin
  FArray := TADObjectArrayT.Create(oOwnsObjects, AInitialCapacity);
end;

function TADObjectList<T>.GetOwnership: TADOwnership;
begin
  Result := TADObjectArrayT(FArray).Ownership;
end;

procedure TADObjectList<T>.SetOwnership(const AOwnership: TADOwnership);
begin
  TADObjectArrayT(FArray).Ownership := AOwnership;
end;

{ TADCircularList<T> }

constructor TADCircularList<T>.Create;
begin
  inherited;

end;

destructor TADCircularList<T>.Destroy;
begin

  inherited;
end;

{ TADCircularObjectList<T> }

constructor TADCircularObjectList<T>.Create;
begin
  inherited;

end;

destructor TADCircularObjectList<T>.Destroy;
begin

  inherited;
end;

{ TADObjectListTS<T> }

constructor TADObjectListTS<T>.Create(const AExpander: IADListExpander; const ACompactor: IADListCompactor; const AInitialCapacity: Integer; const AOwnership: TADOwnership);
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

constructor TADCircularListTS<T>.Create;
begin
  inherited;
  FLock := TADReadWriteLock.Create(Self);
end;

destructor TADCircularListTS<T>.Destroy;
begin
  FLock.Free;
  inherited;
end;

function TADCircularListTS<T>.GetLock: IADReadWriteLock;
begin
  Result := FLock;
end;

{ TADCircularObjectListTS<T> }

constructor TADCircularObjectListTS<T>.Create;
begin
  inherited;
  FLock := TADReadWriteLock.Create(Self);
end;

destructor TADCircularObjectListTS<T>.Destroy;
begin
  FLock.Free;
  inherited;
end;

function TADCircularObjectListTS<T>.GetLock: IADReadWriteLock;
begin
  Result := FLock;
end;

end.
