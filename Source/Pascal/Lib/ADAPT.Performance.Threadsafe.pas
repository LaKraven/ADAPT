{
  AD.A.P.T. Library
  Copyright (C) 2014-2016, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
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
  FLock := ADReadWriteLock(Self);
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
