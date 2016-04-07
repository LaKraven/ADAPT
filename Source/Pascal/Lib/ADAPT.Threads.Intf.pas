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
unit ADAPT.Threads.Intf;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes,
  {$ELSE}
    Classes,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Common, ADAPT.Common.Intf;

  {$I ADAPT_RTTI.inc}

type
  { Enums }
  TADThreadState = (tsRunning, tsPaused);

  ///  <summary><c>Common Interface for ADAPT Thread Types.</c></summary>
  IADThread = interface(IADInterface)
  ['{021D276B-6619-4489-ABD1-56787D0FBF2D}']
    function GetLock: IADReadWriteLock;

    property Lock: IADReadWriteLock read GetLock;
  end;

  ///  <summary><c>Common Interface for ADAPT Precision Thread Types.</c></summary>
  IADThreadPrecision = interface(IADThread)
  ['{3668FFD2-45E4-4EA7-948F-75A698C90480}']
    ///  <summary><c>Forces the "Next Tick Time" to be bumped to RIGHT NOW. This will trigger the next Tick immediately regardless of any Rate Limit setting.</c></summary>
    procedure Bump;
    ///  <summary><c>Places the Thread in an Inactive state, waiting for the signal to </c><see DisplayName="Wake" cref="ADAPT.Threads|ILKThreadPrecision.Wake"/><c> the Thread.</c></summary>
    procedure Rest;
    ///  <summary><c>Wakes the Thread if it is an Inactive state (see </c><see DisplayName="Rest" cref="ADAPT.Threads|ILKThreadPrecision.Rest"/><c> for details)</c></summary>
    procedure Wake;

    { Property Getters }
    function GetNextTickTime: ADFloat;
    function GetThreadState: TADThreadState;
    function GetTickRate: ADFloat;
    function GetTickRateAverage: ADFloat;
    function GetTickRateAverageOver: Cardinal;
    function GetTickRateDesired: ADFloat;
    function GetTickRateLimit: ADFloat;
    function GetThrottleInterval: Cardinal;
    { Property Setters }
    procedure SetThreadState(const AThreadState: TADThreadState);
    procedure SetTickRateAverageOver(const AAverageOver: Cardinal);
    procedure SetTickRateDesired(const ADesiredRate: ADFloat);
    procedure SetTickRateLimit(const ATickRateLimit: ADFloat);
    procedure SetThrottleInterval(const AThrottleInterval: Cardinal);

    ///  <summary><c>The Absolute Reference Time at which the next Tick will occur.</c></summary>
    property NextTickTime: ADFloat read GetNextTickTime;
    ///  <summary><c>The current State of the Thread (running or paused).</c></summary>
    property ThreadState: TADThreadState read GetThreadState write SetThreadState;
    ///  <summary><c>The Absolute Rate (in Ticks Per Second [T/s]) at which the Thread is executing its Tick method.</c></summary>
    property TickRate: ADFloat read GetTickRate;
    ///  <summary><c>The Running Average Rate (in Ticks Per Second [T/s]) at which the Thread is executing its Tick method.</c></summary>
    property TickRateAverage: ADFloat read GetTickRateAverage;
    ///  <summary><c>The Time (in Seconds) over which to calculate the Running Average.</c></summary>
    property TickRateAverageOver: Cardinal read GetTickRateAverageOver write SetTickRateAverageOver;
    ///  <summary><c>The number of Ticks Per Second [T/s] you would LIKE the Thread to operate at.</c></summary>
    ///  <remarks><c>This value is used to calculate how much "Extra Time" (if any) is available on the current Tick.</c></remarks>
    property TickRateDesired: ADFloat read GetTickRateDesired write SetTickRateDesired;
    ///  <summary><c>The Absolute Tick Rate (in Ticks Per Second [T/s]) at which you wish the Thread to operate.</c></summary>
    ///  <remarks><c>There is no guarantee that the rate you specify here will be achievable. Slow hardware or an overloaded running environment may mean the thread operates below the specified rate.</c></remarks>
    property TickRateLimit: ADFloat read GetTickRateLimit write SetTickRateLimit;
    ///  <summary><c>The minimum amount of time that must be available between Ticks in order to Rest the Thread.</c></summary>
    ///  <remarks>
    ///    <para><c>Value is in </c>MILLISECONDS<c> (1 = 0.001 seconds)</c></para>
    ///    <para><c>Minimum value = </c>1</para>
    ///  </remarks>
    property ThrottleInterval: Cardinal read GetThrottleInterval write SetThrottleInterval;
  end;

implementation

end.
