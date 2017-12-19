{
  AD.A.P.T. Library
  Copyright (C) 2014-2018, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Demo.EventEnginePlayground.Events;

{$I ADAPT.inc}

interface

uses
  System.Classes,
  ADAPT.EventEngine.Intf, ADAPT.EventEngine;

type
  {
    This "Test Event" simply takes a String Message as its "Payload"
    This String Message could be consumed in an infinite variety of ways by individual Listeners.

    NOTE: We provide a Reintroduced "Constructor" to initialize the Value because this must only be set ONCE...
          and must ALWAYS be set BEFORE we dispatch the Event to the Queue/Stack (or Scheduler).
          After dispatch, we must NEVER change this Value! That is ABSOLUTELY CRITICAL!
  }
  TTestEvent = class(TADEvent)
  private
    FMessage: String;
  public
    constructor Create(const AMessage: String); reintroduce;

    property Message: String read FMessage;
  end;

  {
    Just as with the "Test Event", this Response Event takes a String as its "Payload".
    The idea is that any Event Thread listening for "Test Event" will perform an operation on its Payload,
    then return the resulting "Response" by emitting a "TTestResponseEvent" instance.
  }
  TTestResponseEvent = class(TADEvent)
  private
    FResponse: String;
  public
    constructor Create(const AResponse: String); reintroduce;

    property Response: String read FResponse;
  end;

implementation

{ TTestEvent }

constructor TTestEvent.Create(const AMessage: String);
begin
  inherited Create;
  FMessage := AMessage;
end;

{ TTestResponseEvent }

constructor TTestResponseEvent.Create(const AResponse: String);
begin
  inherited Create;
  FResponse := AResponse;
end;

end.
