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
unit ADAPT.Threads.Types.Base;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes, System.SysUtils, System.SyncObjs,
  {$ELSE}
    Classes, SysUtils, SyncObjs,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Common.Types.Base, ADAPT.Common.Types.Threadsafe;

type
  { Interface Forward Declarations }
  IADThread = interface;
  { Class Forward Declarations }
  TADThread = class;

  { Enums }
  TLKThreadState = (tsRunning, tsPaused);

  ///  <summary><c>Common Interface for ADAPT Thread Types.</c></summary>
  IADThread = interface
  ['{021D276B-6619-4489-ABD1-56787D0FBF2D}']

  end;

  ///  <summary><c>Abstract Base Type for all Threads in the ADAPT codebase.</c></summary>
  ///  <remarks>
  ///    <para><c>ALL Threads in the codebase have a defactor Threadsafe Lock.</c></para>
  ///  </remarks>
  TADThread = class abstract(TThread, IADInterface, IADThread, IADReadWriteLock)
  private
    FOwnerInterface: IInterface;
    { IInterface }
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    { IADInterface }
    function GetInstanceGUID: TGUID;
    { IADReadWriteLock }
    function GetLock: IADReadWriteLock;
  protected
    FInstanceGUID: TGUID;
    FLock: TADReadWriteLock;
  public
    constructor Create; reintroduce; virtual;
    destructor Destroy; override;
    procedure AfterConstruction; override;

    { IADInterface }
    property InstanceGUID: TGUID read GetInstanceGUID;
    { IADReadWriteLock }
    property Lock: IADReadWriteLock read GetLock implements IADReadWriteLock;
  end;

implementation

{ TADThread }

constructor TADThread.Create;
begin
  inherited;
  CreateGUID(FInstanceGUID);
  FLock := TADReadWriteLock.Create(IADThread(Self));
end;

destructor TADThread.Destroy;
begin
  FLock.Free;
  inherited;
end;

function TADThread.GetInstanceGUID: TGUID;
begin
  Result := FInstanceGUID;
end;

function TADThread.GetLock: IADReadWriteLock;
begin
  Result := FLock;
end;

function TADThread.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
if GetInterface(IID, Obj) then Result := 0 else Result := E_NOINTERFACE;
end;

function TADThread._AddRef: Integer;
begin
  if FOwnerInterface <> nil then
    Result := FOwnerInterface._AddRef else
    Result := -1;
end;

function TADThread._Release: Integer;
begin
  if FOwnerInterface <> nil then
    Result := FOwnerInterface._Release else
    Result := -1;
end;

procedure TADThread.AfterConstruction;
begin
  inherited;
  GetInterface(IInterface, FOwnerInterface);
end;

end.
