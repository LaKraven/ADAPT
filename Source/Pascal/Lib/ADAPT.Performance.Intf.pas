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
unit ADAPT.Performance.Intf;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes, System.SysUtils,
  {$ELSE}
    Classes, SysUtils,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Common, ADAPT.Common.Intf;

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

implementation

end.
