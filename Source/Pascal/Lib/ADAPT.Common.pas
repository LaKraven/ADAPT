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

  { Enums }
  ///  <summary><c>Defines the Ownership role of a container.</c></summary>
  TADOwnership = (oOwnsObjects, oNotOwnsObjects);

  {$IFDEF ADAPT_FLOAT_SINGLE}
    ///  <summary><c>Single-Precision Floating Point Type.</c></summary>
    ADFloat = Single;
  {$ELSE}
    {$IFDEF ADAPT_FLOAT_EXTENDED}
      ///  <summary><c>Extended-Precision Floating Point Type.</c></summary>
      ADFloat = Extended;
    {$ELSE}
      ///  <summary><c>Double-Precision Floating Point Type.</c></summary>
      ADFloat = Double; // This is our default
    {$ENDIF ADAPT_FLOAT_DOUBLE}
  {$ENDIF ADAPT_FLOAT_SINGLE}

  ///  <summary><c>ADAPT Base Excpetion Type.</c></summary>
  EADException = class abstract(Exception);

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

end.
