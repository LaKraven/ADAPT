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
unit ADAPT.Performance.Threadsafe;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes, System.SysUtils,
  {$ELSE}
    Classes, SysUtils,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Common, ADAPT.Common.Intf, ADAPT.Common.Threadsafe,
  ADAPT.Performance;

  {$I ADAPT_RTTI.inc}

type
  TADPerformanceCounterTS = class;

  ///  <summary><c>Threadsafe Performance Counter Type.</c></summary>
  ///  <remarks>
  ///    <para><c>Keeps track of Performance both Instant and Average, in units of Things Per Second.</c></para>
  ///    <para><c>Note that this does NOT operate like a "Stopwatch", it merely takes the given Time Difference (Delta) Values to calculate smooth averages.</c></para>
  ///    <para><c>Contains a Threadsafe Lock.</c></para>
  ///  </remarks>
  TADPerformanceCounterTS = class(TADPerformanceCounter, IADReadWriteLock)
  protected
    FLock: TADReadWriteLock;
    function GetLock: IADReadWriteLock;
    { Getters }
    function GetAverageOver: Cardinal; override;
    function GetAverageRate: ADFloat; override;
    function GetInstantRate: ADFloat; override;

    { Setters }
    procedure SetAverageOver(const AAverageOver: Cardinal = 10); override;
  public
    constructor Create(const AAverageOver: Cardinal); override;
    destructor Destroy; override;

    procedure RecordSample(const AValue: ADFloat); override;
    procedure Reset; override;

    ///  <summary><c>The number of Samples over which to calculate the Average</c></summary>
    property AverageOver: Cardinal read GetAverageOver write SetAverageOver;
    ///  <summary><c>The Average Rate (based on the number of Samples over which to calculate it)</c></summary>
    property AverageRate: ADFloat read GetAverageRate;
    ///  <summary><c>The Instant Rate (based only on the last given Sample)</c></summary>
    property InstantRate: ADFloat read GetInstantRate;
    ///  <summary><c>Multi-Read, Exclusive-Write Threadsafe Lock.</c></summary>
    property Lock: IADReadWriteLock read GetLock implements IADReadWriteLock;
  end;

implementation

{ TADPerformanceCounterTS }

constructor TADPerformanceCounterTS.Create(const AAverageOver: Cardinal);
begin
  FLock := TADReadWriteLock.Create(Self);
  inherited;
end;

destructor TADPerformanceCounterTS.Destroy;
begin
  FLock.{$IFDEF SUPPORTS_DISPOSEOF}DisposeOf{$ELSE}Free{$ENDIF SUPPORTS_DISPOSEOF};
  inherited;
end;

function TADPerformanceCounterTS.GetAverageOver: Cardinal;
begin
  FLock.AcquireRead;
  try
    Result := inherited;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADPerformanceCounterTS.GetAverageRate: ADFloat;
begin
  FLock.AcquireRead;
  try
    Result := inherited;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADPerformanceCounterTS.GetInstantRate: ADFloat;
begin
  FLock.AcquireRead;
  try
    Result := inherited;
  finally
    FLock.ReleaseRead;
  end;
end;

function TADPerformanceCounterTS.GetLock: IADReadWriteLock;
begin
  Result := FLock;
end;

procedure TADPerformanceCounterTS.RecordSample(const AValue: ADFloat);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

procedure TADPerformanceCounterTS.Reset;
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

procedure TADPerformanceCounterTS.SetAverageOver(const AAverageOver: Cardinal);
begin
  FLock.AcquireWrite;
  try
    inherited;
  finally
    FLock.ReleaseWrite;
  end;
end;

end.
