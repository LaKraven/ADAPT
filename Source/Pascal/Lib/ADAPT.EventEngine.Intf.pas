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
  ADAPT.Common, ADAPT.Common.Intf, ADAPT.Common.Threadsafe,
  ADAPT.Generics.Common.Intf,
  ADAPT.Generics.Collections.Intf,
  ADAPT.Generics.Maps.Intf;

  {$I ADAPT_RTTI.inc}

type
  { Forward Declarations }
  IADEvent = interface;
  TADEventBase = class;
  IADEventListener = interface;
  IADEventThread = interface;

  { Class References }
  TADEventBaseClass = class of TADEventBase;

  { Enums }
  TADEventDispatchMethod = (dmQueue, dmStack);
  TADEventDispatchTarget = (dtThreads);
  TADEventOrigin = (eoInternal, eoReplay, eoRemote, eoUnknown);
  TADEventState = (esNotDispatched, esScheduled, esDispatched, esProcessing, esProcessed, esCancelled);
  TADEventListenerRegistrationMode = (elrmAutomatic, elrmManual);

  { Sets }
  TADEventDispatchTargets = set of TADEventDispatchTarget;

  { Exceptions }
  EADEventEngineException = class(EADException);
    EADEventEngineEventException = class(EADEventEngineException);
    EADEventEngineEventListenerException = class(EADEventEngineException);
      EADEventEngineEventListenerCallbackUnassigned = class(EADEventEngineEventListenerException);
    EADEventEngineEventThreadException = class(EADEventEngineException);

  { Generic Collections }
  IADEventHolder = IADObjectHolder<TADEventBase>;
  IADEventList = IADList<IADEventHolder>;
  IADEventListenerMap = IADMap<TADEventBaseClass, IADEventListener>;

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
    ///  <returns><c>The Interfaced Holder for this Event.</c></returns>
    ///  <remarks>
    ///    <para><c>Hold a Reference to this if you want to keep hold of the Event after it has been processed.</c></para>
    ///    <para><c>If you don't hold a Reference to this, the Event will be destroyed immediately after it has been processed.</c></para>
    ///  </remarks>
    function GetHolder: IADEventHolder;
    ///  <returns><c>The Reference Time at which the Event was First Processed.</c></returns>
    function GetProcessedTime: ADFloat;
    ///  <returns><c>Current State of this Event.</c></returns>
    function GetState: TADEventState;

    // Setters

    // Management Methods
    ///  <summary><c>Dispatches the Event through the Event Engine Queue.</c></summary>
    procedure Queue; overload;
    ///  <summary><c>Dispatches the Event through the Event Engine Queue.</c></summary>
    ///  <remarks><c>Defines an instance-specific Expiry Time.</c></remarks>
    procedure Queue(const AExpiresAfter: ADFloat); overload;
    ///  <summary><c>Schedules the Event for Dispatch through the Event Engine Queue.</c></summary>
    procedure QueueSchedule(const AScheduleFor: ADFloat);
    ///  <summary><c>Dispatches the Event through the Event Engine Stack.</c></summary>
    procedure Stack; overload;
    ///  <summary><c>Dispatches the Event through the Event Engine Stack.</c></summary>
    ///  <remarks><c>Defines an instance-specific Expiry Time.</c></remarks>
    procedure Stack(const AExpiresAfter: ADFloat); overload;
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
    ///  <returns><c>The Interfaced Holder for this Event.</c></returns>
    ///  <remarks>
    ///    <para><c>Hold a Reference to this if you want to keep hold of the Event after it has been processed.</c></para>
    ///    <para><c>If you don't hold a Reference to this, the Event will be destroyed immediately after it has been processed.</c></para>
    ///  </remarks>
    property Holder: IADEventHolder read GetHolder;
    ///  <returns><c>The Reference Time at which the Event was First Processed.</c></returns>
    property ProcessedTime: ADFloat read GetProcessedTime;
    ///  <returns><c>Current State of this Event.</c></returns>
    property State: TADEventState read GetState;
  end;

  ///  <summary><c>The Absolute Abstract Base Class for all Event Types.</c></summary>
  ///  <remarks><c>Inherit from </c>TADEvent<c> instead of this class!!</c></remarks>
  TADEventBase = class abstract(TADObjectTS, IADEvent)
  protected
    // Getters
    { IADEvent }
    function GetCreatedTime: ADFloat; virtual; abstract;
    function GetDelta: ADFloat; virtual; abstract;
    function GetDispatchAfter: ADFloat; virtual; abstract;
    function GetDispatchAt: ADFloat; virtual; abstract;
    function GetDispatchMethod: TADEventDispatchMethod; virtual; abstract;
    function GetDispatchTargets: TADEventDispatchTargets; virtual; abstract;
    function GetDispatchTime: ADFloat; virtual; abstract;
    function GetExpiresAfter: ADFloat; virtual; abstract;
    function GetEventOrigin: TADEventOrigin; virtual; abstract;
    function GetHolder: IADEventHolder; virtual; abstract;
    function GetProcessedTime: ADFloat; virtual; abstract;
    function GetState: TADEventState; virtual; abstract;
  public
    // Management Methods
    { IADEvent }
    procedure Queue; overload; virtual; abstract;
    procedure Queue(const AExpiresAfter: ADFloat); overload; virtual; abstract;
    procedure QueueSchedule(const AScheduleFor: ADFloat); virtual; abstract;
    procedure Stack; overload; virtual; abstract;
    procedure Stack(const AExpiresAfter: ADFloat); overload; virtual; abstract;
    procedure StackSchedule(const AScheduleFor: ADFloat); virtual; abstract;

    // Properties
    { IADEvent }
    property CreatedTime: ADFloat read GetCreatedTime;
    property Delta: ADFloat read GetDelta;
    property DispatchAfter: ADFloat read GetDispatchAfter;
    property DispatchAt: ADFloat read GetDispatchAt;
    property DispatchMethod: TADEventDispatchMethod read GetDispatchMethod;
    property DispatchTargets: TADEventDispatchTargets read GetDispatchTargets;
    property DispatchTime: ADFloat read GetDispatchTime;
    property ExpiresAfter: ADFloat read GetExpiresAfter;
    property EventOrigin: TADEventOrigin read GetEventOrigin;
    property Holder: IADEventHolder read GetHolder;
    property ProcessedTime: ADFloat read GetProcessedTime;
    property State: TADEventState read GetState;
  end;

  { Callbacks }
  TADEventCallback<T: TADEventBase> = procedure(const AEvent: T) of object;

  ///  <summary><c>Event Listeners are invoked when their relevent Event Type is processed through the Event Engine.</c></summary>
  IADEventListener = interface(IADInterface)
  ['{08B3A941-6D79-4165-80CE-1E45B5E35A9A}']
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
    ///  <summary><c>Executes an Event<c></summary>
    procedure ExecuteEvent(const AEvent: TADEventBase);
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

  ///  <summary><c>Any Type containing an Event Queue and Stack.</c></summary>
  IADEventContainer = interface(IADInterface)
  ['{6189CACA-B75D-4A5D-881A-61BE88C9ABC5}']
    // Getters
    ///  <returns><c>The combined number of Events currently contained within the Queue and Stack.</c></returns>
    function GetEventCount: Integer;
    ///  <returns><c>The number of Events currently contained within the Queue.</c></returns>
    function GetEventQueueCount: Integer;
    ///  <returns><c>The number of Events currently contained within the Stack.</c></returns>
    function GetEventStackCount: Integer;
    ///  <returns><c>The overall Limit to the number of Events the Queue and Stack (combined) can contain at any one time.</c></returns>
    function GetMaxEventCount: Integer;

    // Setters
    ///  <summary><c>Defines the Limit to the number of Events the Queue and Stack (combined) can contain at any one time.</c></summary>
    procedure SetMaxEventCount(const AMaxEventCount: Integer);

    // Management Methods
    ///  <summary><c>Places the given Event into this Container's Event Queue.</c></summary>
    procedure QueueEvent(const AEvent: TADEventBase);
    ///  <summary><c>Places the given Event into this Container's Event Stack.</c></summary>
    procedure StackEvent(const AEVent: TADEventBase);

    // Properties
    ///  <returns><c>The combined number of Events currently contained within the Queue and Stack.</c></returns>
    property EventCount: Integer read GetEventCount;
    ///  <returns><c>The number of Events currently contained within the Queue.</c></returns>
    property EventQueueCount: Integer read GetEventQueueCount;
    ///  <returns><c>The number of Events currently contained within the Stack.</c></returns>
    property EventStackCount: Integer read GetEventStackCount;
    ///  <summary><c>Defines the Limit to the number of Events the Queue and Stack (combined) can contain at any one time.</c></summary>
    ///  <returns><c>The overall Limit to the number of Events the Queue and Stack (combined) can contain at any one time.</c></returns>
    property MaxEventCount: Integer read GetMaxEventCount write SetMaxEventCount;
  end;

  ///  <summary><c>Event Threads are specialized "Precision Threads" designed to process Asynchronous Events.</c></summary>
  IADEventThread = interface(IADInterface)
  ['{0374AD53-2EB7-45BB-8402-1FD34D40512B}']
    // Getters
    ///  <returns>
    ///    <para>True<c> if the Event Thread Pauses when there are no pending Events in the Queue or Stack</c></para>
    ///    <para>False<c> if the Event Thread continues to Tick regardless of whether or not there are pending Events.</c></para>
    ///  </returns>
    function GetPauseOnNoEvent: Boolean;

    // Setters
    ///  <summary><c>Define whether or not the Event Thread Pauses when there are no pending Events in the Queue or Stack.</c></summary>
    procedure SetPauseOnNoEvent(const APauseOnNoEvent: Boolean);

    // Management Methods
    ///  <summary><c>Registers an Event Listener with this Event Thread.</c></summary>
    procedure RegisterEventListener(const AEventListener: IADEventListener);
    ///  <summary><c>Unregisters and Event Listener from this Event Thread.</c></summary>
    procedure UnregisterEventListener(const AEventListener: IADEventListener);

    // Properties
    ///  <summary><c>Define whether or not the Event Thread Pauses when there are no pending Events in the Queue or Stack.</c></summary>
    ///  <returns>
    ///    <para>True<c> if the Event Thread Pauses when there are no pending Events in the Queue or Stack</c></para>
    ///    <para>False<c> if the Event Thread continues to Tick regardless of whether or not there are pending Events.</c></para>
    ///  </returns>
    property PauseOnNoEvent: Boolean read GetPauseOnNoEvent write SetPauseOnNoEvent;
  end;

  ///  <summary><c>Public Interface for the Event Engine.</c></summary>
  IADEventEngine = interface(IADInterface)
  ['{6E6D99BF-BAD7-4E43-8CA6-3CF25F262329}']
    // Getters
    ///  <returns><c>The Global Maximum number of Events the Engine can handle at any one time.</c></returns>
    function GetGlobalMaxEvents: Integer;

    // Setters
    ///  <summary><c>Defines the Global Maximum number of Events the Engine can handle at any one time.</c></returns>
    procedure SetGlobalMaxEvents(const AGlobalMaxEvents: Integer);

    // Management Methods
    ///  <summary><c>Dispatches the given Event across the entire Event Engine via the Queues.</c></summary>
    procedure QueueEvent(const AEvent: IADEvent);
    ///  <summary><c>Dispatches the given Event across the entire Event Engine via the Stacks.</c></summary>
    procedure StackEvent(const AEvent: IADEvent);

    // Properties
    ///  <summary><c>Defines the Global Maximum number of Events the Engine can handle at any one time.</c></returns>
    ///  <returns><c>The Global Maximum number of Events the Engine can handle at any one time.</c></returns>
    property GlobalMaxEvents: Integer read GetGlobalMaxEvents write SetGlobalMaxEvents;
  end;

implementation

end.
