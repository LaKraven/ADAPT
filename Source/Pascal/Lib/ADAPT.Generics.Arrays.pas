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
  ADAPT.Common, ADAPT.Common.Intf,
  ADAPT.Generics.Defaults.Intf,
  ADAPT.Generics.Arrays.Intf;

  {$I ADAPT_RTTI.inc}

type
  {$IFDEF FPC}
    TArray<T> = Array of T; // FreePascal doesn't have this defined (yet)
  {$ENDIF FPC}

  {$IFNDEF FPC}
    { Class Forward Declarations }
    TADArray<T> = class;
    TADObjectArray<T: Class> = class;
  {$ENDIF FPC}

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
  TADObjectArray<T: Class> = class(TADArray<T>, IADObjectOwner)
  private
    FOwnership: TADOwnership;
  protected
    // Getters
    function GetOwnership: TADOwnership; virtual;
    // Setters
    procedure SetOwnership(const AOwnership: TADOwnership); virtual;
  public
    constructor Create(const AOwnership: TADOwnership = oOwnsObjects; const ACapacity: Integer = 0); reintroduce; virtual;
    destructor Destroy; override;
    ///  <summary><c>Empties the Array and sets it back to the original Capacity you specified in the Constructor.</c></summary>
    procedure Clear; override;
    // Properties
    property Ownership: TADOwnership read GetOwnership write SetOwnership;
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
  if Ownership = oOwnsObjects then
    for I := Low(FArray) to High(FArray) do
      if ((Assigned(FArray[I]))) and (FArray[I] <> nil) then // TODO -oDaniel -cGeneric Object Array: I really need to test to make sure this won't evaluate as "True" even if a previously-assigned Object at the given Index (I) has been Disposed.
        FArray[I].{$IFDEF SUPPORTS_DISPOSEOF}DisposeOf{$ELSE}Free{$ENDIF SUPPORTS_DISPOSEOF};
  inherited;
end;

constructor TADObjectArray<T>.Create(const AOwnership: TADOwnership = oOwnsObjects; const ACapacity: Integer = 0);
begin
  inherited Create(ACapacity);
  FOwnership := AOwnership;
end;

destructor TADObjectArray<T>.Destroy;
begin
  Clear;
  inherited;
end;

function TADObjectArray<T>.GetOwnership: TADOwnership;
begin
  Result := FOwnership;
end;

procedure TADObjectArray<T>.SetOwnership(const AOwnership: TADOwnership);
begin
  FOwnership := AOwnership;
end;

end.
