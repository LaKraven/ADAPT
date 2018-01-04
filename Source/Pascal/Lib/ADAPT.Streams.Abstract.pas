{
  AD.A.P.T. Library
  Copyright (C) 2014-2018, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Streams.Abstract;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes, System.SysUtils, System.RTLConsts,
    {$IFDEF MSWINDOWS}WinApi.Windows,{$ENDIF MSWINDOWS}
    {$IFDEF POSIX}Posix.UniStd,{$ENDIF POSIX}
  {$ELSE}
    Classes, SysUtils, RTLConsts,
    {$IFDEF MSWINDOWS}Windows,{$ENDIF MSWINDOWS}
    {$IFDEF POSIX}Posix,{$ENDIF POSIX}
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT, ADAPT.Intf,
  ADAPT.Collections.Intf,
  ADAPT.Streams.Intf,
  ADAPT.Comparers.Intf;

  {$I ADAPT_RTTI.inc}

type
  ///  <summary><c>Abstract Base Class for all Stream Caret Types.</c></summary>
  ///  <remarks>
  ///    <para><c>This type is NOT Threadsafe.</c></para>
  ///  </remarks>
  TADStreamCaret = class abstract(TADObject, IADStreamCaret)
  protected
    FPosition: Int64;
    ///  <summary><c>Weak Rerefence to the owning Stream object.</c></summary>
    ///  <remarks><c>Use </c>GetStream<c> to cast the Reference back to </c>IADStream<c>.</c></remarks>
    FStream: Pointer;
    FValid: Boolean;

    procedure CheckCaretValid;
    { IADStreamCaret }
    function GetIsInvalid: Boolean; virtual;
    function GetIsValid: Boolean; virtual;
    function GetPosition: Int64; virtual;
    function GetStream: IADStream; virtual;
    function GetStreamManagement: IADStreamManagement; virtual;
    procedure SetPosition(const APosition: Int64); virtual;
  public
    constructor Create(const AStream: IADStream); reintroduce; overload;
    constructor Create(const AStream: IADStream; const APosition: Int64); reintroduce; overload;
    destructor Destroy; override;
    { IADStreamCaret }
    function Delete(const ALength: Int64): Int64; virtual;
    function Insert(const ABuffer; const ALength: Int64): Int64; virtual;
    function Read(var ABuffer; const ALength: Int64): Int64; virtual;
    function Write(const ABuffer; const ALength: Int64): Int64; virtual;
    function Seek(const AOffset: Int64; const AOrigin: TSeekOrigin): Int64; virtual;
    procedure Invalidate; virtual;

    property IsInvalid: Boolean read GetIsInvalid;
    property IsValid: Boolean read GetIsValid;
    property Position: Int64 read GetPosition write SetPosition;
    property Stream: IADStream read GetStream;
    property StreamManagement: IADStreamManagement read GetStreamManagement;
  end;

  ///  <summary><c>Abstract Base Class for all Stream Types.</c></summary>
  ///  <remarks>
  ///    <para><c>This type is NOT Threadsafe.</c></para>
  ///  </remarks>
  TADStream = class abstract(TADObject, IADStream, IADStreamManagement)
  protected
    FCaretList: IADSortedList<IADStreamCaret>;
    { IADStream }
    function GetSize: Int64; virtual; abstract;
    procedure SetSize(const ASize: Int64); virtual; abstract;
    { IADStreamManagement }
    procedure InvalidateCaret(const ACaret: IADStreamCaret; const AFromPosition, ACount: Int64); virtual;
    procedure InvalidateCarets(const AFromPosition, ACount: Int64); virtual;
    procedure ShiftCaretLeft(const ACaret: IADStreamCaret; const AFromPosition, ACount: Int64); virtual;
    procedure ShiftCaretRight(const ACaret: IADStreamCaret; const AFromPosition, ACount: Int64); virtual;
    procedure ShiftCaretsLeft(const AFromPosition, ACount: Int64); virtual;
    procedure ShiftCaretsRight(const AFromPosition, ACount: Int64); virtual;
    procedure UnregisterCaret(const ACaret: IADStreamCaret); virtual;
    { Internal Methods }
    function MakeNewCaret: IADStreamCaret; virtual; abstract;
  public
    constructor Create; override;
    destructor Destroy; override;

    { IADStream }
    procedure LoadFromFile(const AFileName: String); virtual; abstract;
    procedure LoadFromStream(const AStream: IADStream); overload; virtual; abstract;
    procedure LoadFromStream(const AStream: TStream); overload; virtual; abstract;
    function NewCaret: IADStreamCaret; overload;
    function NewCaret(const APosition: Int64): IADStreamCaret; overload;
    function NewCaretReader: IADStreamCaretReader; overload;
    function NewCaretReader(const APosition: Int64): IADStreamCaretReader; overload;
    procedure SaveToFile(const AFileName: String); virtual; abstract;
    procedure SaveToStream(const AStream: IADStream); overload; virtual; abstract;
    procedure SaveToStream(const AStream: TStream); overload; virtual; abstract;

    // Properties
    property Size: Int64 read GetSize write SetSize;
  end;

implementation

uses
  ADAPT.Collections,
  ADAPT.Comparers,
  ADAPT.Streams; // Used for ADStreamCaretComparer

{ TADStreamCaret }

constructor TADStreamCaret.Create(const AStream: IADStream);
begin
  inherited Create;
  FStream := @AStream;
end;

constructor TADStreamCaret.Create(const AStream: IADStream; const APosition: Int64);
begin
  Create(AStream);
  SetPosition(APosition);
end;

procedure TADStreamCaret.CheckCaretValid;
begin
  if IsInvalid then
    raise EADStreamCaretInvalid.CreateFmt('The binary data at position %d as referenced by this Caret has been removed or modified.', [GetPosition]);
end;

function TADStreamCaret.Delete(const ALength: Int64): Int64;
begin
  Result := 0;
  CheckCaretValid;
end;

destructor TADStreamCaret.Destroy;
begin
  GetStreamManagement.UnregisterCaret(Self);
  inherited;
end;

function TADStreamCaret.GetIsInvalid: Boolean;
begin
  Result := (not FValid);
end;

function TADStreamCaret.GetIsValid: Boolean;
begin
  Result := FValid;
end;

function TADStreamCaret.GetPosition: Int64;
begin
  Result := Seek(0, soCurrent);
end;

function TADStreamCaret.GetStream: IADStream;
begin
  Result := IADStream(FStream^);
end;

function TADStreamCaret.GetStreamManagement: IADStreamManagement;
begin
  Result := GetStream as IADStreamManagement;
end;

function TADStreamCaret.Insert(const ABuffer; const ALength: Int64): Int64;
begin
  Result := 0;
  CheckCaretValid;
end;

procedure TADStreamCaret.Invalidate;
begin
  FValid := False;
end;

function TADStreamCaret.Read(var ABuffer; const ALength: Int64): Int64;
begin
  Result := 0;
  CheckCaretValid;
end;

function TADStreamCaret.Seek(const AOffset: Int64; const AOrigin: TSeekOrigin): Int64;
begin
  Result := 0;
  CheckCaretValid;
end;

procedure TADStreamCaret.SetPosition(const APosition: Int64);
begin
  FPosition := Seek(APosition, soBeginning);
end;

function TADStreamCaret.Write(const ABuffer; const ALength: Int64): Int64;
begin
  Result := 0;
  CheckCaretValid;
end;

{ TADStream }

constructor TADStream.Create;
begin
  inherited;
  FCaretList := TADSortedList<IADStreamCaret>.Create(ADStreamCaretComparer);
end;

destructor TADStream.Destroy;
begin
  InvalidateCarets(0, GetSize);
  inherited;
end;

procedure TADStream.InvalidateCaret(const ACaret: IADStreamCaret; const AFromPosition, ACount: Int64);
begin
  if (ACaret.Position >= AFromPosition) and (ACaret.Position < AFromPosition + ACount) then
    ACaret.Invalidate;
end;

procedure TADStream.InvalidateCarets(const AFromPosition, ACount: Int64);
var
  I: Integer;
begin
  for I := 0 to FCaretList.Count - 1 do
    InvalidateCaret(FCaretList[I], AFromPosition, ACount);
end;

function TADStream.NewCaret: IADStreamCaret;
begin
  Result := MakeNewCaret;
  FCaretList.Add(Result);
end;

function TADStream.NewCaret(const APosition: Int64): IADStreamCaret;
begin
  Result := MakeNewCaret;
  Result.Position := APosition;
  FCaretList.Add(Result);
end;

function TADStream.NewCaretReader: IADStreamCaretReader;
begin
  Result := NewCaret;
end;

function TADStream.NewCaretReader(const APosition: Int64): IADStreamCaretReader;
begin
  Result := NewCaret(APosition);
end;

procedure TADStream.ShiftCaretLeft(const ACaret: IADStreamCaret; const AFromPosition, ACount: Int64);
begin
  if (ACaret.Position >= AFromPosition) and (ACaret.Position < AFromPosition + ACount) then
    ACaret.Position := ACaret.Position - ACount;
end;

procedure TADStream.ShiftCaretRight(const ACaret: IADStreamCaret; const AFromPosition, ACount: Int64);
begin
  if (ACaret.Position >= AFromPosition) and (ACaret.Position < AFromPosition + ACount) then
    ACaret.Position := ACaret.Position + ACount;
end;

procedure TADStream.ShiftCaretsLeft(const AFromPosition, ACount: Int64);
var
  I: Integer;
begin
  for I := 0 to FCaretList.Count - 1 do
    ShiftCaretLeft(FCaretList[I], AFromPosition, ACount);
end;

procedure TADStream.ShiftCaretsRight(const AFromPosition, ACount: Int64);
var
  I: Integer;
begin
  for I := 0 to FCaretList.Count - 1 do
    ShiftCaretRight(FCaretList[I], AFromPosition, ACount);
end;

procedure TADStream.UnregisterCaret(const ACaret: IADStreamCaret);
var
  LIndex: Integer;
begin
  LIndex := FCaretList.IndexOf(ACaret);
  if LIndex > -1 then
    FCaretList.Delete(LIndex);
end;

end.
