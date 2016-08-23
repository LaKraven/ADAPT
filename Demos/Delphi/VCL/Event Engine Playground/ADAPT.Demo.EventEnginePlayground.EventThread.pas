{
  AD.A.P.T. Library
  Copyright (C) 2014-2016, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Demo.EventEnginePlayground.EventThread;

{$I ADAPT.inc}

interface

uses
  System.Classes,
  ADAPT.EventEngine.Intf;

{
  This function returns an Interfaced Reference to our "Test Event Thread".
  We wouldn't always need to have access to this, but for the sake of demonstration, I'm showing how
  it can be done as there are plenty of contexts wherein you might want to.
}
function TestEventThread: IADEventThread;

implementation

uses
  ADAPT.EventEngine,
  ADAPT.Demo.EventEnginePlayground.Events;

var
  GTestEventThread: TADEventThread; // This Variable will hold our internal Instance. NOTE IT IS INTERNAL ONLY!

type
  {
    This is the Class Definition for our "Test Event Thread".
    It constructs and contains the "Test Event Listener", and provides the Callback to be invoked each time
    a "Test Event" instance is transacted through the Event Engine.
    It performs a "transformation" on the given String Message, then emits a "Test Response Event" containing
    the result.
  }
  TTestEventThread = class(TADEventThread)
  private
    FListener: IADEventListener;
  end;

{
  Necessary "macro" to return an Interfaced Reference to our Internal Event Thread Instance.
}
function TestEventThread: IADEventThread;
begin
  Result := GTestEventThread;
end;

{
  Since the "Test Event Thread" needs to run for the lifetime of our application,
  we managage its lifetime using the "Initialization" and "Finalization".
}
initialization
  GTestEventThread := TTestEventThread.Create;
finalization
  GTestEventThread.Free;

end.
