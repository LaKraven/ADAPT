{
  AD.A.P.T. Library
  Copyright (C) 2014-2016, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Performance.Intf;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes, System.SysUtils,
  {$ELSE}
    Classes, SysUtils,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT, ADAPT.Intf;

  {$I ADAPT_RTTI.inc}

type
  ///  <summary><c>Common Interface for all Performance Counter Types.</c></summary>
  ///  <remarks>
  ///    <para><c>Keeps track of Performance both Instant and Average, in units of Things Per Second.</c></para>
  ///    <para><c>Note that this does NOT operate like a "Stopwatch", it merely takes the given Time Difference (Delta) Values to calculate smooth averages.</c></para>
  ///  </remarks>
  IADPerformanceCounter = interface(IADInterface)
  ['{6095EB28-79FC-4AC8-8CED-C11BA9A2CF48}']
    { Getters }
    function GetAverageOver: Cardinal;
    function GetAverageRate: ADFloat;
    function GetInstantRate: ADFloat;

    { Setters }
    procedure SetAverageOver(const AAverageOver: Cardinal = 10);

    { Public Methods }
    procedure RecordSample(const AValue: ADFloat);
    procedure Reset;

    ///  <summary><c>The number of Samples over which to calculate the Average</c></summary>
    property AverageOver: Cardinal read GetAverageOver write SetAverageOver;
    ///  <summary><c>The Average Rate (based on the number of Samples over which to calculate it)</c></summary>
    property AverageRate: ADFloat read GetAverageRate;
    ///  <summary><c>The Instant Rate (based only on the last given Sample)</c></summary>
    property InstantRate: ADFloat read GetInstantRate;
  end;

  ///  <summary><c>Common Interface for all Performance Limiter Types.</c></summary>
  ///  <remarks>
  ///    <para><c>Limiters serve to enforce precise-as-possible Time Differential Based (Delta-Based) calculations.</c></para>
  ///  </remarks>
  IADPerformanceLimiter = interface(IADInterface)
  ['{279704C6-BBAF-415F-897D-77953D049E8E}']
    { Getters }
    function GetNextDelta: ADFloat;
    function GetRateDesired: ADFloat;
    function GetRateLimit: ADFloat;
    function GetThrottleInterval: Cardinal;
    { Setters }
    procedure SetRateDesired(const ARateDesired: ADFloat);
    procedure SetRateLimit(const ARateLimit: ADFloat);
    procedure SetThrottleInterval(const AThrottleInterval: Cardinal);
    { Public Methods }

    { Properties }
    property NextDelta: ADFloat read GetNextDelta;
    property RateDesired: ADFloat read GetRateDesired write SetRateDesired;
    property RateLimit: ADFloat read GetRateLimit write SetRateLimit;
    property ThrottleInterval: Cardinal read GetThrottleInterval write SetThrottleInterval;
  end;

implementation

end.
