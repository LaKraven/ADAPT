unit ADAPT.Demo.PrecisionThreads.TestThread;

{$I ADAPT.inc}

interface

uses
  System.Classes, System.SysUtils,
  ADAPT.Common,
  ADAPT.Threads;

type
  TTestPerformanceData = class(TADObject)

  end;

  TTestTickCallback = procedure() of object; // Our Callback Type.

  {
    This Test Thread simply builds a historical dataset of Thread Performance Data.
    A Notify Event is called (if Assigned, of course) to output/consume this historical Performance Data.

    This Test Thread is designed to supplement a "Unit Test", since Unit Tests don't work in the context of a multi-threaded system.
  }
  TTestThread = class(TADPrecisionThread)
  private
    FTickCallback: TTestTickCallback;
    // Getters
    function GetTickCallback: TTestTickCallback;
    // Setters
    procedure SetTickCallback(const ACallback: TTestTickCallback);
    // Internal Methods
    procedure InvokeCallbackIfAssigned;
  protected
    { TADPrecisionThread }
    function GetDefaultTickRateLimit: ADFloat; override;
    function GetDefaultTickRateDesired: ADFloat; override;
    procedure Tick(const ADelta, AStartTime: ADFloat); override;
  public
    property TickCallback: TTestTickCallback read GetTickCallback write SetTickCallback;
  end;

implementation

{ TTestThread }

function TTestThread.GetDefaultTickRateDesired: ADFloat;
begin
  Result := 30; // Since our demo defaults to 30 ticks per second, we want to indicate our desire for this rate.
  {
     Remember that a "Desired" Tick Rate is NOT the same as a "Tick Rate Limit".
     We might want to have NO Rate Limit, but still desire a MINIMUM rate.
     This information can then be used to calculate any "extra time" available on a Tick, which can be used to perform optional "additional processing".
  }
end;

function TTestThread.GetDefaultTickRateLimit: ADFloat;
begin
  Result := 0; // We default the demo to 30 ticks per second.
end;

function TTestThread.GetTickCallback: TTestTickCallback;
begin
  FLock.AcquireRead; // This needs to be "Threadsafe"
  try
    Result := FTickCallback;
  finally
    FLock.ReleaseRead;
  end;
end;

procedure TTestThread.InvokeCallbackIfAssigned;
begin
  FLock.AcquireRead; // We acquire the Lock so that the Callback cannot be changed while we're using it...
  try
    if Assigned(FTickCallback) then // We need to check that the Callback has been Assigned
      Synchronize(procedure // We Synchronize the Callback because our Demo consumes it on the UI Thread.
                  begin
                    FTickCallback; // Invoke the Callback...
                  end);
  finally
    FLock.ReleaseRead; // ...Now we can release the Lock as we're done with the Callback.
  end;
end;

procedure TTestThread.SetTickCallback(const ACallback: TTestTickCallback);
begin
  FLock.AcquireWrite; // This needs to be "Threadsafe"
  try
    FTickCallback := ACallback;
  finally
    FLock.ReleaseWrite;
  end;
end;

procedure TTestThread.Tick(const ADelta, AStartTime: ADFloat);
begin
  // Update Historical Performance Dataset
  // Notify the Callback to consume the updated Performance Dataset
  InvokeCallbackIfAssigned;
end;

end.
