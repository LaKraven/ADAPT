{
  AD.A.P.T. Library
  Copyright (C) 2014-2016, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Generics.Defaults;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes, System.SysUtils,
  {$ELSE}
    Classes, SysUtils,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Common, ADAPT.Common.Intf,
  ADAPT.Generics.Defaults.Intf;

  {$I ADAPT_RTTI.inc}

///  <comments>
///    <para><c>For 32bit CPUs uses </c><see DisplayName="ADSuperFastHash32" cref="ADAPT.Generics.Defaults|ADSuperFastHash32"/><c>.</c></para>
///    <para><c>For 64bit CPUs uses </c><see DisplayName="ADSuperFastHash64" cref="ADAPT.Generics.Defaults|ADSuperFastHash64"/><c>.</c></para>
///  </comments>
function ADSuperFastHash(AData: Pointer; ADataLength: Integer): LongWord;
///  <comments>
///    <para><c>For 32bit CPUs</c></para>
///    <para><c>Pascal translation of the SuperFastHash function by Paul Hsieh</c></para>
///    <para><c>More info: http://www.azillionmonkeys.com/qed/hash.html</c></para>
///    <para><c>Translation by: Davy Landman</c></para>
///    <para><c>Translation found at: http://landman-code.blogspot.co.uk/2008/06/superfasthash-from-paul-hsieh.html</c></para>
///    <para><c>Source appears to be made available as "Public Domain" and is used in good faith.</c></para>
///  </comments>
function ADSuperFastHash32(AData: Pointer; ADataLength: Integer): LongWord;
///  <comments>
///    <para><c>For 64bit CPUs</c></para>
///    <para><c>Pascal translation of the SuperFastHash function by Paul Hsieh</c></para>
///    <para><c>More info: http://www.azillionmonkeys.com/qed/hash.html</c></para>
///    <para><c>Translation by: Davy Landman</c></para>
///    <para><c>Translation found at: http://landman-code.blogspot.co.uk/2008/06/superfasthash-from-paul-hsieh.html</c></para>
///    <para><c>Source appears to be made available as "Public Domain" and is used in good faith.</c></para>
///    <para><c>64bit Fixes by: Simon J Stuart</c></para>
///  </comments>
function ADSuperFastHash64(AData: Pointer; ADataLength: Integer): LongWord;

implementation

function ADSuperFastHash32(AData: Pointer; ADataLength: Integer): LongWord;
var
  LTmpPart: LongWord;
  LBytesRemaining: Integer;
begin
  if not Assigned(AData) or (ADataLength <= 0) then
  begin
    Result := 0;
    Exit;
  end;
  Result := ADataLength;
  LBytesRemaining := ADataLength and 3;
  ADataLength := ADataLength shr 2; // div 4, so var name is not correct anymore..
  // main loop
  while ADataLength > 0 do
  begin
    inc(Result, PWord(AData)^);
    LTmpPart := (PWord(Pointer(Cardinal(AData)+2))^ shl 11) xor Result;
    Result := (Result shl 16) xor LTmpPart;
    AData := Pointer(Cardinal(AData) + 4);
    inc(Result, Result shr 11);
    dec(ADataLength);
  end;
  // end case
  if LBytesRemaining = 3 then
  begin
    inc(Result, PWord(AData)^);
    Result := Result xor (Result shl 16);
    Result := Result xor (PByte(Pointer(Cardinal(AData)+2))^ shl 18);
    inc(Result, Result shr 11);
  end
  else if LBytesRemaining = 2 then
  begin
    inc(Result, PWord(AData)^);
    Result := Result xor (Result shl 11);
    inc(Result, Result shr 17);
  end
  else if LBytesRemaining = 1 then
  begin
    inc(Result, PByte(AData)^);
    Result := Result xor (Result shl 10);
    inc(Result, Result shr 1);
  end;

  Result := Result xor (Result shl 3);
  inc(Result, Result shr 5);
  Result := Result xor (Result shl 4);
  inc(Result, Result shr 17);
  Result := Result xor (Result shl 25);
  inc(Result, Result shr 6);
end;

function ADSuperFastHash64(AData: Pointer; ADataLength: Integer): LongWord;
var
  LTmpPart: UInt64;
  LBytesRemaining: Int64;
begin
  if not Assigned(AData) or (ADataLength <= 0) then
  begin
    Result := 0;
    Exit;
  end;
  Result := ADataLength;
  LBytesRemaining := ADataLength and 3;
  ADataLength := ADataLength shr 2; // div 4, so var name is not correct anymore..
  // main loop
  while ADataLength > 0 do
  begin
    inc(Result, PWord(AData)^);
    LTmpPart := (PWord(Pointer(UInt64(AData)+2))^ shl 11) xor Result;
    Result := (Result shl 16) xor LTmpPart;
    AData := Pointer(UInt64(AData) + 4);
    inc(Result, Result shr 11);
    dec(ADataLength);
  end;
  // end case
  if LBytesRemaining = 3 then
  begin
    inc(Result, PWord(AData)^);
    Result := Result xor (Result shl 16);
    Result := Result xor (PByte(Pointer(UInt64(AData)+2))^ shl 18);
    inc(Result, Result shr 11);
  end
  else if LBytesRemaining = 2 then
  begin
    inc(Result, PWord(AData)^);
    Result := Result xor (Result shl 11);
    inc(Result, Result shr 17);
  end
  else if LBytesRemaining = 1 then
  begin
    inc(Result, PByte(AData)^);
    Result := Result xor (Result shl 10);
    inc(Result, Result shr 1);
  end;

  Result := Result xor (Result shl 3);
  inc(Result, Result shr 5);
  Result := Result xor (Result shl 4);
  inc(Result, Result shr 17);
  Result := Result xor (Result shl 25);
  inc(Result, Result shr 6);
end;

function ADSuperFastHash(AData: Pointer; ADataLength: Integer): LongWord;
begin
  {$IFDEF CPUX64}
    Result := ADSuperFastHash64(AData, ADataLength);
  {$ELSE}
    Result := ADSuperFastHash32(AData, ADataLength);
  {$ENDIF CPUX64}
end;

end.
