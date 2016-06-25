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
unit ADAPT.Streams;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes, System.SysUtils,
  {$ELSE}
    Classes, SysUtils,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Common, ADAPT.Common.Intf,
  ADAPT.Generics.Lists.Intf,
  ADAPT.Streams.Intf;

  {$I ADAPT_RTTI.inc}

type
  { Forward Declarations }
  TADStreamCaret = class;
  TADStream = class;
  TADHandleStreamCaret = class;
  TADHandleStream = class;
  TADFileStreamCaret = class;
  TADFileStream = class;
  TADMemoryStreamCaret = class;
  TADMemoryStream = class;

  { Class Reference Types }
  TADStreamCaretClass = class of TADStreamCaret;

  { Collection Types }
  IADStreamCaretList = IADList<IADStreamCaret>; //TODO -oDaniel -cStreams, Optimization: Replace IADList with IADLookupList for better performance!

  ///  <summary><c>Abstract Base Class for all Stream Caret Types.</c></summary>
  ///  <remarks>
  ///    <para><c>This type is NOT Threadsafe.</c></para>
  ///  </remarks>
  TADStreamCaret = class abstract(TADObject, IADStreamCaret)
  private
    FPosition: Int64;
    ///  <summary><c>Weak Rerefence to the owning Stream object.</c></summary>
    ///  <remarks><c>Use </c>GetStream<c> to cast the Reference back to </c>IADStream<c>.</c></remarks>
    FStream: Pointer;
    FValid: Boolean;
  protected
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
    ///  <summary><c>Deletes the given number of Bytes from the current Position in the Stream, then compacts the Stream by that number of Bytes (shifting any subsequent Bytes to the left)</c></summary>
    ///  <returns><c>Returns the number of Bytes deleted.</c></returns>
    ///  <remarks>
    ///    <para><c>Automatically shifts the Position of subsequent Carets by the offset of Bytes deleted.</c></para>
    ///  </remarks>
    function Delete(const ALength: Int64): Int64; virtual;
    ///  <summary><c>Inserts the given Buffer into the current Position within the Stream (shifting any subsequent Bytes to the right)</c></summary>
    ///  <returns><c>Returns the number of Bytes actually written.</c></returns>
    ///  <remarks>
    ///    <para><c>Automatically shifts the Position of subsequent Carets by the offset of Bytes inserted.</c></para>
    ///  </remarks>
    function Insert(const ABuffer; const ALength: Int64): Int64; virtual;
    ///  <summary><c>Reads the specified number of Bytes from the Array into the specified Address</c></summary>
    ///  <returns><c>Returns the number of Bytes actually read.</c></returns>
    function Read(var ABuffer; const ALength: Int64): Int64; virtual;
    ///  <summary><c>Writes the given Buffer into the current Position within the Stream (overwriting any existing data, and expanding the Size of the Stream if required)</c></summary>
    ///  <returns><c>Returns the number of Bytes actually written.</c></returns>
    ///  <remarks>
    ///    <para><c>DOES NOT shift the position of any subsequent Carets!</c></para>
    ///  </remarks>
    function Write(const ABuffer; const ALength: Int64): Int64; virtual;
    ///  <returns><c>Returns the new </c>Position<c> in the Stream.</c></returns>
    function Seek(const AOffset: Int64; const AOrigin: TSeekOrigin): Int64; virtual;
    ///  <summary><c>Invalidates the Caret.</c></summary>
    ///  <remarks><c>This is usually called by the owning Stream when a Caret has been Invalidated by an operation from another Caret.</c></remarks>
    procedure Invalidate; virtual;

    ///  <summary><c>Has an operation on the Stream rendered this Caret invalid?</c></summary>
    property IsInvalid: Boolean read GetIsInvalid;
    ///  <summary><c>If </c>True<c>, this Caret is still Valid.</c></summary>
    property IsValid: Boolean read GetIsValid;
    ///  <summary><c>The Position of this Caret within the Stream.</c></summary>
    property Position: Int64 read GetPosition write SetPosition;
    ///  <summary><c>Reference to the Caret's owning Stream</c></summary>
    property Stream: IADStream read GetStream;
    ///  <summary><c>Reference to the Caret's owning Stream's Management Methods.</c><summary>
    property StreamManagement: IADStreamManagement read GetStreamManagement;
  end;

  ///  <summary><c>Abstract Base Class for all Stream Types.</c></summary>
  ///  <remarks>
  ///    <para><c>This type is NOT Threadsafe.</c></para>
  ///  </remarks>
  TADStream = class abstract(TADObject, IADStream, IADStreamManagement)
  private
    FCaretList: IADStreamCaretList;
  protected
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
    function GetCaretType: TADStreamCaretClass; virtual; abstract;
  public
    constructor Create; override;
    destructor Destroy; override;

    { IADStream }
    ///  <summary><c>Populate the Stream from a File.</c></summary>
    procedure LoadFromFile(const AFileName: String); virtual; abstract;
    ///  <summary><c>Populate the Stream from the contents of another Stream.</c></summary>
    procedure LoadFromStream(const AStream: IADStream); overload; virtual; abstract;
    ///  <summary><c>Populate the Stream from the contents of another Stream.</c></summary>
    procedure LoadFromStream(const AStream: TStream); overload; virtual; abstract;

    ///  <returns><c>A new Stream Caret.</c></returns>
    function NewCaret: IADStreamCaret; overload;
    ///  <returns><c>A new Stream Caret.</c></returns>
    function NewCaret(const APosition: Int64): IADStreamCaret; overload;

    ///  <summary><c>Save contents of the Stream to a File.</c></summary>
    procedure SaveToFile(const AFileName: String); virtual; abstract;
    ///  <summary><c>Save contents of the Stream to another Stream.</c></summary>
    procedure SaveToStream(const AStream: IADStream); overload; virtual; abstract;
    ///  <summary><c>Save contents of the Stream to another Stream.</c></summary>
    procedure SaveToStream(const AStream: TStream); overload; virtual; abstract;

    // Properties
    ///  <summary><c>Size of the Stream.</c></summary>
    property Size: Int64 read GetSize write SetSize;
  end;

  ///  <summary><c>Caret specifically set up for Handle Streams.</c></summary>
  ///  <remarks>
  ///    <para><c>This type is NOT Threadsafe.</c></para>
  ///  </remarks>
  TADHandleStreamCaret = class(TADStreamCaret)
  protected
    FHandle: THandle;
    { IADStreamCaret }
    function GetPosition: Int64; override;
    procedure SetPosition(const APosition: Int64); override;
  public
    { IADStreamCaret }
    function Delete(const ALength: Int64): Int64; override;
    function Insert(const ABuffer; const ALength: Int64): Int64; override;
    function Read(var ABuffer; const ALength: Int64): Int64; override;
    function Write(const ABuffer; const ALength: Int64): Int64; override;
    function Seek(const AOffset: Int64; const AOrigin: TSeekOrigin): Int64; override;
  end;

  ///  <summary><c>Specialized Stream Type for Handle Streams.</c></summary>
  ///  <remarks>
  ///    <para><c>This type is NOT Threadsafe.</c></para>
  ///  </remarks>
  TADHandleStream = class(TADStream)

  end;

  ///  <summary><c>Caret specifically set up for File Streams.</c></summary>
  ///  <remarks>
  ///    <para><c>This type is NOT Threadsafe.</c></para>
  ///  </remarks>
  TADFileStreamCaret = class(TADStreamCaret)

  end;

  ///  <summary><c>Specialized Stream Type for File Streams.</c></summary>
  ///  <remarks>
  ///    <para><c>This type is NOT Threadsafe.</c></para>
  ///  </remarks>
  TADFileStream = class(TADStream)

  end;

  ///  <summary><c>Caret specifically set up for Memory Streams.</c></summary>
  ///  <remarks>
  ///    <para><c>This type is NOT Threadsafe.</c></para>
  ///  </remarks>
  TADMemoryStreamCaret = class(TADStreamCaret)

  end;

  ///  <summary><c>Specialized Stream Type for Memory Streams.</c></summary>
  ///  <remarks>
  ///    <para><c>This type is NOT Threadsafe.</c></para>
  ///  </remarks>
  TADMemoryStream = class(TADStream)

  end;

implementation

uses
  ADAPT.Generics.Lists;

  {$I ADAPT_RTTI.inc}

type
  TADStreamCaretList = class(TADList<IADStreamCaret>);

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
  FCaretList := TADStreamCaretList.Create;
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
  Result := GetCaretType.Create(Self);
  FCaretList.Add(Result);
end;

function TADStream.NewCaret(const APosition: Int64): IADStreamCaret;
begin
  Result := GetCaretType.Create(Self, APosition);
  FCaretList.Add(Result);
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
  //TODO -oDaniel -cStreams: Can't implement this until "Lookup Lists" are available! BUGGER!
//  LIndex := FCaretList.IndexOf(ACaret);
  if LIndex > -1 then
    FCaretList.Delete(LIndex);
end;

{ TADHandleStreamCaret }

function TADHandleStreamCaret.Delete(const ALength: Int64): Int64;
var
  LStartPosition, LSize: Int64;
  LValue: TBytes;
begin
  inherited;
  LStartPosition := Position;
  LSize := GetStream.Size;
  if GetStream.Size > Position + ALength then
  begin
    SetLength(LValue, LSize - ALength);
    Position := Position + ALength;
    Read(LValue[0], LSize - ALength);
    Position := LStartPosition;
    Write(LValue[0], ALength);
  end;
  GetStream.Size := LSize - ALength;
  // Invalidate the Carets representing the Bytes we've deleted
  GetStreamManagement.InvalidateCarets(LStartPosition, ALength);
  // Shift subsequent Carets to the left
  GetStreamManagement.ShiftCaretsLeft(LStartPosition + ALength, LSize - (LStartPosition + ALength));
  if LStartPosition < GetStream.Size then // If this Caret is still in range...
    Position := LStartPosition // ...set this Caret's position back to where it began
  else // otherwise, if this Caret is NOT in range...
    Invalidate; // ...invalidate this Caret
  Result := ALength;
end;

function TADHandleStreamCaret.GetPosition: Int64;
begin
  Result := FPosition;
end;

function TADHandleStreamCaret.Insert(const ABuffer; const ALength: Int64): Int64;
var
  I, LStartPosition, LNewSize: Int64;
  LByte: Byte;
begin
  Result := inherited;
  LStartPosition := FPosition;
  // Expand the Stream
  LNewSize := GetStream.Size + ALength;
  GetStream.Size := LNewSize;
  // Move subsequent Bytes to the Right
  I := LStartPosition;
  repeat
    Seek(I, soBeginning); // Navigate to the Byte
    Read(LByte, 1); // Read this byte
    Seek(I + ALength + 1, soBeginning); // Navigate to this Byte's new location
    Write(LByte, 1); // Write this byte
    Inc(I); // On to the next
    Inc(Result);
  until I > LNewSize;
  // Insert the Value
  Position := LStartPosition;
  Write(ABuffer, ALength);
  // Shift overlapping Carets to the Right
  GetStreamManagement.ShiftCaretsRight(LStartPosition, ALength);
  Position := LStartPosition + ALength;
end;

function TADHandleStreamCaret.Read(var ABuffer; const ALength: Int64): Int64;
begin
  inherited;
  Seek(FPosition, soBeginning);
  Result := FileRead(FHandle, ABuffer, ALength);
  if Result = -1 then
    Result := 0
  else
    Inc(FPosition, ALength);
end;

function TADHandleStreamCaret.Seek(const AOffset: Int64; const AOrigin: TSeekOrigin): Int64;
begin
  inherited;
  Result := FileSeek(FHandle, AOffset, Ord(AOrigin));
end;

procedure TADHandleStreamCaret.SetPosition(const APosition: Int64);
begin
  FPosition := APosition;
end;

function TADHandleStreamCaret.Write(const ABuffer; const ALength: Int64): Int64;
var
  LStartPosition: Int64;
begin
  inherited;
  LStartPosition := FPosition;
  Seek(FPosition, soBeginning);
  Result := FileWrite(FHandle, ABuffer, ALength);
  if Result = -1 then
    Result := 0
  else begin
    Inc(FPosition, ALength);
    GetStreamManagement.InvalidateCarets(LStartPosition, ALength);
  end;
end;

end.
