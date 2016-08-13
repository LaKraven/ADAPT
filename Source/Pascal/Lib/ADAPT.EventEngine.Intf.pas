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
  { Forward Declarations }
  IADEventThread = interface;

  { Enums }
  TADEventDispatchMethod = (dmQueue, dmStack);
  TADEventDispatchTarget = (dtThreads);
  TADEventOrigin = (eoInternal, eoReplay, eoRemote, eoUnknown);
  TADEventState = (esNotDispatched, esScheduled, esDispatched, esProcessing, esProcessed, esCancelled);

  { Sets }
  TADEventDispatchTargets = set of TADEventDispatchTarget;

  ///  <summary><c>Fundamental Interface for all Event Types.</c></summary>
  ///  <remarks>
  ///    <para><c>Remember that Events do NOT provide functionality, only information.</c></para>
  ///  </remarks>
  IADEvent = interface(IADInterface)
  ['{CAFF660F-37F4-49B3-BBCC-15096C4B8E50}']
    // Getters
    ///  <returns><c>The Time at which the Event was Created.</c></returns>
    function GetCreatedTime: ADFloat;
    ///  <returns><c>The Time Differential (Delta) between Dispatch and Now.</c></returns>
    function GetDelta: ADFloat;
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

    // Management Methods
    ///  <summary><c>Dispatches the Event through the Event Engine Queue.</c></summary>
    procedure Queue;
    ///  <summary><c>Schedules the Event for Dispatch through the Event Engine Queue.</c></summary>
    procedure QueueSchedule(const AScheduleFor: ADFloat);
    ///  <summary><c>Dispatches the Event through the Event Engine Stack.</c></summary>
    procedure Stack;
    ///  <summary><c>Schedules the Event for Dispatch through the Event Engine Stack.</c></summary>
    procedure StackSchedule(const AScheduleFor: ADFloat);

    // Properties
    ///  <summary><c>The Time at which the Event was Created.</c></summary>
    property CreatedTime: ADFloat read GetCreatedTime;
    ///  <returns><c>The Time Differential (Delta) between Dispatch and Now.</c></returns>
    property Delta: ADFloat read GetDelta;
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

  ///  <summary><c>Event Listeners are invoked when their relevent Event Type is processed through the Event Engine.</c></summary>
  IADEventListener<T: IADEvent> = interface(IADInterface)
    // Getters
    ///  <returns><c>A reference to the Event Thread owning this Listener.</c></returns>
    ///  <remarks>
    ///    <para><c>Could be </c>nil<c> if the Listener has no owning Event Thread.</c></para>
    ///  </remarks>
    function GetEventThread: IADEventThread;
    ///  <returns><c>The Reference Time of the last processed Event.</c></returns>
    function GetLastProcessed: ADFloat;
    ///  <returns>The Maximum Age (Delta) of an Event before this Listener will no longer process it.</c></returns>
    function GetMaxAge: ADFloat;
    ///  <returns>
    ///    <para>True<c> if this Listener will only process an Event if it is newer than the last Processed Event.</c></para>
    ///    <para>False<c> if this Listener doesn't care whether an Event is newer or older than the last Processed Event.</c></para>
    ///  </returns>
    function GetNewestOnly: Boolean;

    // Setters
    ///  <summary><c>Defines the Maximum Age (Delta) of an Event before this Listener will no longer process it.</c></summary>
    procedure SetMaxAge(const AMaxAge: ADFloat);
    ///  <summary><c>Defines whether or not this Listener will only process an Event if it is newer than the last Processed Event.</c></summary>
    procedure SetNewestOnly(const ANewestOnly: Boolean);

    // Management Methods
    ///  <summary><c>Registers the Event Listner so that it can begin processing Events.</c></summary>
    procedure Register;
    ///  <summary><c>Unregisters the Event Listener. It will no longer respond to Events.</c></summary>
    procedure Unregister;

    // Properties
    ///  <returns><c>A reference to the Event Thread owning this Listener.</c></returns>
    ///  <remarks>
    ///    <para><c>Could be </c>nil<c> if the Listener has no owning Event Thread.</c></para>
    ///  </remarks>
    property EventThread: IADEventThread read GetEventThread;
    ///  <summary><c>Defines the Maximum Age (Delta) of an Event before this Listener will no longer process it.</c></summary>
    ///  <returns>The Maximum Age (Delta) of an Event before this Listener will no longer process it.</c></returns>
    property MaxAge: ADFloat read GetMaxAge write SetMaxAge;
    ///  <summary><c>Defines whether or not this Listener will only process an Event if it is newer than the last Processed Event.</c></summary>
    ///  <returns>
    ///    <para>True<c> if this Listener will only process an Event if it is newer than the last Processed Event.</c></para>
    ///    <para>False<c> if this Listener doesn't care whether an Event is newer or older than the last Processed Event.</c></para>
    ///  </returns>
    property NewestOnly: Boolean read GetNewestOnly write SetNewestOnly;
  end;

  ///  <summary><c>Event Threads are specialized "Precision Threads" designed to process Asynchronous Events.</c></summary>
  IADEventThread = interface(IADInterface)
  ['{0374AD53-2EB7-45BB-8402-1FD34D40512B}']

  end;

implementation

end.
