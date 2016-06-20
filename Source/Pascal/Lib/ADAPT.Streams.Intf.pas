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
unit ADAPT.Streams.Intf;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes, System.SysUtils,
  {$ELSE}
    Classes, SysUtils,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Common, ADAPT.Common.Intf;

  {$I ADAPT_RTTI.INC}

type
  { Forward Delcarations }
  IADStream = interface;

  IADStreamCaret = interface(IADInterface)
  ['{D8E849E5-A5A1-4B4F-9AF6-BBD397216C5B}']
    function GetIsInvalid: Boolean;
    function GetIsValid: Boolean;
    function GetPosition: Int64;
    procedure SetPosition(const APosition: Int64);

    function GetStream: IADStream;

    ///  <summary><c>Deletes the given number of Bytes from the current Position in the Stream, then compacts the Stream by that number of Bytes (shifting any subsequent Bytes to the left)</c></summary>
    ///  <returns><c>Returns the number of Bytes deleted.</c></returns>
    ///  <remarks>
    ///    <para><c>Locks the Stream for duration of operation</c></para>
    ///    <para><c>Automatically shifts the Position of subsequent Carets by the offset of Bytes deleted.</c></para>
    ///  </remarks>
    function Delete(const ALength: Int64): Int64;

    ///  <summary><c>Inserts the given Buffer into the current Position within the Stream (shifting any subsequent Bytes to the right)</c></summary>
    ///  <returns><c>Returns the number of Bytes actually written.</c></returns>
    ///  <remarks>
    ///    <para><c>Locks the Stream for duration of operation</c></para>
    ///    <para><c>Automatically shifts the Position of subsequent Carets by the offset of Bytes inserted.</c></para>
    ///  </remarks>
    function Insert(const ABuffer; const ALength: Int64): Int64;

    ///  <summary><c>Reads the specified number of Bytes from the Array into the specified Address</c></summary>
    ///  <returns><c>Returns the number of Bytes actually read.</c></returns>
    ///  <remarks>
    ///    <para><c>Locks the Stream only when reading each Byte (releases Lock between Bytes)</c></para>
    ///  </remarks>
    function Read(var ABuffer; const ALength: Int64): Int64;

    ///  <summary><c>Writes the given Buffer into the current Position within the Stream (overwriting any existing data, and expanding the Size of the Stream if required)</c></summary>
    ///  <returns><c>Returns the number of Bytes actually written.</c></returns>
    ///  <remarks>
    ///    <para><c>Locks the Stream for duration of operation</c></para>
    ///    <para><c>DOES NOT shift the position of any subsequent Carets!</c></para>
    ///  </remarks>
    function Write(const ABuffer; const ALength: Int64): Int64;

    ///  <returns><c>Returns the new </c>Position<c> in the Stream.</c></returns>
    function Seek(const AOffset: Int64; const AOrigin: TSeekOrigin): Int64;

    ///  <summary><c>Has an operation on the Stream rendered this Caret invalid?</c></summary>
    property IsInvalid: Boolean read GetIsInvalid;
    ///  <summary><c>If </c>True<c>, this Caret is still Valid.</c></summary>
    property IsValid: Boolean read GetIsValid;
    ///  <summary><c>The Position of this Caret within the Stream.</c></summary>
    property Position: Int64 read GetPosition write SetPosition;
    ///  <summary><c>Reference to the Caret's owning Stream</c></summary>
    property Stream: IADStream read GetStream;
  end;

  IADStream = interface(IADInterface)
  ['{07F45B12-1DFC-453A-B95C-E00C9F5F4285}']
    function GetSize: Int64;
    procedure SetSize(const ASize: Int64);

    ///  <summary><c>Waits for all Writes to be completed, then increments the Read Count (locking Write access)</c></summary>
    procedure AcquireReadLock;
    ///  <summary><c>Waits for all Reads to be completed, then increments the Write Count (locking Read access)</c></summary>
    procedure AcquireWriteLock;
    ///  <summary><c>Decrements the Read Count (unlocking Write access if that count hits 0)</c></summary>
    procedure ReleaseReadLock;
    ///  <summary><c>Decrements the Write Count (unlocking Read access if that count hits 0)</c></summary>
    procedure ReleaseWriteLock;

    procedure LoadFromFile(const AFileName: String);
    procedure LoadFromStream(const AStream: IADStream); overload;
    procedure LoadFromStream(const AStream: TStream); overload;

    function NewCaret: IADStreamCaret; overload;
    function NewCaret(const APosition: Int64): IADStreamCaret; overload;

    procedure SaveToFile(const AFileName: String);
    procedure SaveToStream(const AStream: IADStream); overload;
    procedure SaveToStream(const AStream: TStream); overload;

    property Size: Int64 read GetSize write SetSize;
  end;

  IADHandleStreamCaret = interface(IADStreamCaret)
  ['{292415DC-68E3-4317-8EE1-5DF1E36097DB}']

  end;

  IADHandleStream = interface(IADStream)
  ['{88BE52C5-0BAD-4E05-A0B3-9DA2C0330F22}']

  end;

  IADFileStreamCaret = interface(IADHandleStreamCaret)
  ['{D3D56456-E6A6-49CE-985A-3407009EA2C9}']

  end;

  IADFileStream = interface(IADHandleStream)
  ['{62B111EB-938E-4F2D-BA94-30504646F90F}']

  end;

  IADMemoryStreamCaret = interface(IADStreamCaret)
  ['{1FB5A4F9-8FFB-4A79-B364-01D6E428A718}']

  end;

  IADMemoryStream  = interface(IADStream)
  ['{289F1193-AE69-47D6-B66B-0174070963B5}']

  end;

implementation

end.
