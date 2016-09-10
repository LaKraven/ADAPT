{
  AD.A.P.T. Library
  Copyright (C) 2014-2016, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Performance;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes, System.SysUtils,
  {$ELSE}
    Classes, SysUtils,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Common, ADAPT.Common.Intf,
  ADAPT.Generics.Common.Intf,
  ADAPT.Generics.Collections.Intf,
  ADAPT.Performance.Intf;

  {$I ADAPT_RTTI.inc}

type
  { Class Forward Declarations }
  TADPerformanceCounter = class;

  ///  <summary><c>Non-Threadsafe Performance Counter Type.</c></summary>
  ///  <remarks>
  ///    <para><c>Keeps track of Performance both Instant and Average, in units of Things Per Second.</c></para>
  ///    <para><c>Note that this does NOT operate like a "Stopwatch", it merely takes the given Time Difference (Delta) Values to calculate smooth averages.</c></para>
  ///    <para><c>CAUTION - THIS CLASS IS NOT THREADSAFE.</c></para>
  ///  </remarks>
  TADPerformanceCounter = class(TADObject, IADPerformanceCounter)
  protected
    FAverageOver: Cardinal;
    FAverageRate: ADFloat;
    FInstantRate: ADFloat;

    ///  <summary><c>A humble Dynamic Array, fixed to the specified "Average Over" value, containing each Sample used to determine the Average Rate.</c></summary>
    FSamples: IADCircularList<ADFloat>;

    { Getters }
    function GetAverageOver: Cardinal; virtual;
    function GetAverageRate: ADFloat; virtual;
    function GetInstantRate: ADFloat; virtual;

    { Setters }
    procedure SetAverageOver(const AAverageOver: Cardinal = 10); virtual;
  public
    constructor Create(const AAverageOver: Cardinal); reintroduce; virtual;

    procedure AfterConstruction; override;

    procedure RecordSample(const AValue: ADFloat); virtual;
    procedure Reset; virtual;

    ///  <summary><c>The number of Samples over which to calculate the Average</c></summary>
    property AverageOver: Cardinal read GetAverageOver write SetAverageOver;
    ///  <summary><c>The Average Rate (based on the number of Samples over which to calculate it)</c></summary>
    property AverageRate: ADFloat read GetAverageRate;
    ///  <summary><c>The Instant Rate (based only on the last given Sample)</c></summary>
    property InstantRate: ADFloat read GetInstantRate;
  end;

  ///  <summary><c>Non-Threadsafe Performance Limiter Type.</c></summary>
  ///  <remarks>
  ///    <para><c>Enforces a given Performance Limit, handling all of the Delta Extrapolation Mathematics.</c></para>
  ///    <para><c>CAUTION - THIS CLASS IS NOT THREADSAFE.</c></para>
  ///  </remarks>
  TADPerformanceLimiter = class(TADAggregatedObject, IADPerformanceLimiter)
  private
    FNextDelta: ADFloat;
    FRateDesired: ADFloat;
    FRateLimit: ADFloat;
    FThrottleInterval: Cardinal;
  protected
    { IADPerformanceLimiter Getters }
    function GetNextDelta: ADFloat; virtual;
    function GetRateDesired: ADFloat; virtual;
    function GetRateLimit: ADFloat; virtual;
    function GetThrottleInterval: Cardinal; virtual;
    { IADPerformanceLimiter Setters }
    procedure SetRateDesired(const ARateDesired: ADFloat); virtual;
    procedure SetRateLimit(const ARateLimit: ADFloat); virtual;
    procedure SetThrottleInterval(const AThrottleInterval: Cardinal); virtual;
  public

    { IADPerformanceLimiter Properties }
    property NextDelta: ADFloat read GetNextDelta;
    property RateDesired: ADFloat read GetRateDesired write SetRateDesired;
    property RateLimit: ADFloat read GetRateLimit write SetRateLimit;
    property ThrottleInterval: Cardinal read GetThrottleInterval write SetThrottleInterval;
  end;

implementation

uses
  ADAPT.Math.Averagers,
  ADAPT.Generics.Collections;

{ TADPerformanceCounter }

procedure TADPerformanceCounter.AfterConstruction;
begin
  inherited;
  Reset;
end;

constructor TADPerformanceCounter.Create(const AAverageOver: Cardinal);
begin
  inherited Create;
  FAverageOver := AAverageOver;
  FSamples := TADCircularList<ADFloat>.Create(AAverageOver);
end;

function TADPerformanceCounter.GetAverageOver: Cardinal;
begin
  Result := FAverageOver;
end;

function TADPerformanceCounter.GetAverageRate: ADFloat;
begin
  Result := FAverageRate;
end;

function TADPerformanceCounter.GetInstantRate: ADFloat;
begin
  Result := FInstantRate;
end;

procedure TADPerformanceCounter.RecordSample(const AValue: ADFloat);
begin
  FInstantRate := AValue; // Calculate Instant Rate
  FSamples.Add(AValue);

  FAverageRate := ADAveragerFloatMean.CalculateAverage(FSamples);
end;

procedure TADPerformanceCounter.Reset;
begin
  FSamples.Clear;
  FInstantRate := 0;
  FAverageRate := 0;
end;

procedure TADPerformanceCounter.SetAverageOver(const AAverageOver: Cardinal);
begin
  FAverageOver := AAverageOver;
  FSamples.Capacity := AAverageOver;
end;

{ TADPerformanceLimiter }

function TADPerformanceLimiter.GetNextDelta: ADFloat;
begin
  Result := FNextDelta;
end;

function TADPerformanceLimiter.GetRateDesired: ADFloat;
begin
  Result := FRateDesired;
end;

function TADPerformanceLimiter.GetRateLimit: ADFloat;
begin
  Result := FRateLimit;
end;

function TADPerformanceLimiter.GetThrottleInterval: Cardinal;
begin
  Result := FThrottleInterval;
end;

procedure TADPerformanceLimiter.SetRateDesired(const ARateDesired: ADFloat);
begin
  FRateDesired := ARateDesired;
end;

procedure TADPerformanceLimiter.SetRateLimit(const ARateLimit: ADFloat);
begin
  FRateLimit := ARateLimit;
end;

procedure TADPerformanceLimiter.SetThrottleInterval(const AThrottleInterval: Cardinal);
begin
  FThrottleInterval := AThrottleInterval;
end;

end.
