{
  AD.A.P.T. Library
  Copyright (C) 2014-2016, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.EventEngine.Intf;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes,
  {$ELSE}
    Classes,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Common, ADAPT.Common.Intf,
  ADAPT.Generics.Common.Intf,
  ADAPT.Generics.Comparers.Intf,
  ADAPT.Generics.Sorters.Intf,
  ADAPT.Generics.Lists.Intf;

  {$I ADAPT_RTTI.inc}

type
  { Enums }
  TADEventDispatchMethod = (dmQueue, dmStack);
  TADEventDispatchTarget = (dtThreads);
  TADEventOrigin = (eoInternal, eoReplay, eoRemote, eoUnknown);
  TADEventState = (esNotDispatched, esScheduled, esDispatched, esProcessing, esProcessed, esCancelled);

  { Sets }
  TADEventDispatchTargets = set of TADEventDispatchTarget;

  IADEvent = interface(IADInterface)
    // Getters
    ///  <returns><c>The Time at which the Event was Created.</c></returns>
    function GetCreatedTime: ADFloat;
    ///  <returns><c>The Time (in Seconds) after which the Event should be Dispatched.</c></returns>
    ///  <remarks>
    ///    <para><c>Value represents an Offset (in Seconds) from DispatchTime</c></para>
    ///    <para><c>0 = Instant Dispatch (no Scheduling)</c></para>
    ///    <para><c>Default = </c>0</para>
    ///  </remarks>
    function GetDispatchAfter: ADFloat;
    ///  <returns><c>The Physical Reference Time at which the Event should be Dispatched by the Scheduler.</c></returns>
    function GetDispatchAt: ADFloat;
    ///  <returns><c>The Method by which the Event was Dispatched.</c></returns>
    ///  <remarks><c>We either Queue an Event, or Stack it!</c></remarks>
    function GetDispatchMethod: TADEventDispatchMethod;
    ///  <returns><c>The Targets to which this Event is allowed to be Dispatched.</c></returns>
    ///  <remarks>
    ///    <para><c>Default = ADAPT_EVENTENGINE_DEFAULT_TARGETS (meaning that there are no restrictions)</c></para>
    ///    <para><c>By default, we want to allow the Event to be processed by ALL available PreProcessors</c></para>
    ///  </remarks>
    function GetDispatchTargets: TADEventDispatchTargets;
    ///  <returns><c>The Reference Time at which the Event was Dispatched.</c></returns>
    function GetDispatchTime: ADFloat;
    ///  <returns><c>The Duration of Time after which the Event will Expire once Dispatched.</c></returns>
    ///  <remarks><c>Default will be 0.00 (Never Expires)</c></remarks>
    function GetExpiresAfter: ADFloat;
    ///  <returns><c>Where this Event came from.</c></returns>
    function GetEventOrigin: TADEventOrigin;
    ///  <returns><c>The Reference Time at which the Event was First Processed.</c></returns>
    function GetProcessedTime: ADFloat;
    ///  <returns><c>Current State of this Event.</c></returns>
    function GetState: TADEventState;
    // Setters

    // Properties
    ///  <summary><c>The Time at which the Event was Created.</c></summary>
    property CreatedTime: ADFloat read GetCreatedTime;
    ///  <returns><c>The Time (in Seconds) after which the Event should be Dispatched.</c></returns>
    ///  <remarks>
    ///    <para><c>Value represents an Offset (in Seconds) from DispatchTime</c></para>
    ///    <para><c>0 = Instant Dispatch (no Scheduling)</c></para>
    ///    <para><c>Default = </c>0</para>
    ///  </remarks>
    property DispatchAfter: ADFloat read GetDispatchAfter;
    ///  <returns><c>The Physical Reference Time at which the Event should be Dispatched by the Scheduler.</c></returns>
    property DispatchAt: ADFloat read GetDispatchAt;
    ///  <returns><c>The Method by which the Event was Dispatched.</c></returns>
    ///  <remarks><c>We either Queue an Event, or Stack it!</c></remarks>
    property DispatchMethod: TADEventDispatchMethod read GetDispatchMethod;
    ///  <returns><c>The Targets to which this Event is allowed to be Dispatched.</c></returns>
    ///  <remarks>
    ///    <para><c>Default = ADAPT_EVENTENGINE_DEFAULT_TARGETS (meaning that there are no restrictions)</c></para>
    ///    <para><c>By default, we want to allow the Event to be processed by ALL available PreProcessors</c></para>
    ///  </remarks>
    property DispatchTargets: TADEventDispatchTargets read GetDispatchTargets;
    ///  <returns><c>The Reference Time at which the Event was Dispatched.</c></returns>
    property DispatchTime: ADFloat read GetDispatchTime;
    ///  <returns><c>The Duration of Time after which the Event will Expire once Dispatched.</c></returns>
    ///  <remarks><c>Default will be 0.00 (Never Expires)</c></remarks>
    property ExpiresAfter: ADFloat read GetExpiresAfter;
    ///  <returns><c>Where this Event came from.</c></returns>
    property EventOrigin: TADEventOrigin read GetEventOrigin;
    ///  <returns><c>The Reference Time at which the Event was First Processed.</c></returns>
    property ProcessedTime: ADFloat read GetProcessedTime;
    ///  <returns><c>Current State of this Event.</c></returns>
    property State: TADEventState read GetState;
  end;

implementation

end.
