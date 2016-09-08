unit ADAPT.Demo.PrecisionThreads.TestThread;

{$I ADAPT.inc}

interface

uses
  System.Classes, System.SysUtils,
  ADAPT.Common.Intf, ADAPT.Common,
  ADAPT.Threads,
  ADAPT.Generics.Collections.Intf;

type
  TTestPerformanceData = record
    DesiredTickRate: ADFloat;
    ExtraTime: ADFloat;
    TickRateLimit: ADFloat;
    TickRate: ADFloat;
    TickRateAverage: ADFloat;
    TickRateAverageOver: Cardinal;
  end;

  ITestPerformanceSummary = interface(IADInterface)
  ['{E3C3E313-9B0D-4442-880D-E4561587957B}']
    // Getters
    function GetDesiredTickRateMax: ADFloat;
    function GetDesiredTickRateMin: ADFloat;
    function GetExtraTimeMax: ADFloat;
    function GetExtraTimeMin: ADFLoat;
    function GetTickRateLimitMax: ADFloat;
    function GetTickRateLimitMin: ADFloat;
    function GetTickRateMax: ADFloat;
    function GetTickRateMin: ADFloat;
    function GetTickRateAverageMax: ADFloat;
    function GetTickRateAverageMin: ADFloat;
    function GetTickRateAverageOverMax: Cardinal;
    function GetTickRateAverageOverMin: Cardinal;

    // Setters
    procedure SetDesiredTickRateMax(const ADesiredTickRateMax: ADFloat);
    procedure SetDesiredTickRateMin(const ADesiredTickRateMin: ADFloat);
    procedure SetExtraTimeMax(const AExtraTimeMax: ADFloat);
    procedure SetExtraTimeMin(const AExtraTimeMin: ADFloat);
    procedure SetTickRateLimitMax(const ATickRateLimitMax: ADFloat);
    procedure SetTickRateLimitMin(const ATickRateLimitMin: ADFloat);
    procedure SetTickRateMax(const ATickRateMax: ADFloat);
    procedure SetTickRateMin(const ATickRateMin: ADFloat);
    procedure SetTickRateAverageMax(const ATickRateAverageMax: ADFloat);
    procedure SetTickRateAverageMin(const ATickRateAverageMin: ADFloat);
    procedure SetTickRateAverageOverMax(const ATickRateAverageOverMax: Cardinal);
    procedure SetTickRateAverageOverMin(const ATickRateAverageOverMin: Cardinal);

    // Properties
    property DesiredTickRateMax: ADFloat read GetDesiredTickRateMax write SetDesiredTickRateMax;
    property DesiredTickRateMin: ADFloat read GetDesiredTickRateMin write SetDesiredTickRateMin;
    property ExtraTimeMax: ADFloat read GetExtraTimeMax write SetExtraTimeMax;
    property ExtraTimeMin: ADFloat read GetExtraTimeMin write SetExtraTimeMin;
    property TickRateLimitMax: ADFloat read GetTickRateLimitMax write SetTickRateLimitMax;
    property TickRateLimitMin: ADFloat read GetTickRateLimitMin write SetTickRateLimitMin;
    property TickRateMax: ADFloat read GetTickRateMax write SetTickRateMax;
    property TickRateMin: ADFloat read GetTickRateMin write SetTickRateMin;
    property TickRateAverageMax: ADFloat read GetTickRateAverageMax write SetTickRateAverageMax;
    property TickRateAverageMin: ADFloat read GetTickRateAverageMin write SetTickRateAverageMin;
    property TickRateAverageOverMax: Cardinal read GetTickRateAverageOverMax write SetTickRateAverageOverMax;
    property TickRateAverageOverMin: Cardinal read GetTickRateAverageOverMin write SetTickRateAverageOverMin;
  end;

  TTestPerformanceSummary = class(TADObject, ITestPerformanceSummary)
  private
    FDesiredTickRateMax,
    FDesiredTickRateMin: ADFloat;
    FExtraTimeMax,
    FExtraTimeMin: ADFloat;
    FTickRateLimitMax,
    FTickRateLimitMin: ADFloat;
    FTickRateMax,
    FTickRateMin: ADFloat;
    FTickRateAverageMax,
    FTickRateAverageMin: ADFloat;
    FTickRateAverageOverMax,
    FTickRateAverageOVerMin: Cardinal;

    // Getters
    { ITestPerformanceSummary }
    function GetDesiredTickRateMax: ADFloat;
    function GetDesiredTickRateMin: ADFloat;
    function GetExtraTimeMax: ADFloat;
    function GetExtraTimeMin: ADFLoat;
    function GetTickRateLimitMax: ADFloat;
    function GetTickRateLimitMin: ADFloat;
    function GetTickRateMax: ADFloat;
    function GetTickRateMin: ADFloat;
    function GetTickRateAverageMax: ADFloat;
    function GetTickRateAverageMin: ADFloat;
    function GetTickRateAverageOverMax: Cardinal;
    function GetTickRateAverageOverMin: Cardinal;

    // Setters
    { ITestPerformanceSummary }
    procedure SetDesiredTickRateMax(const ADesiredTickRateMax: ADFloat);
    procedure SetDesiredTickRateMin(const ADesiredTickRateMin: ADFloat);
    procedure SetExtraTimeMax(const AExtraTimeMax: ADFloat);
    procedure SetExtraTimeMin(const AExtraTimeMin: ADFloat);
    procedure SetTickRateLimitMax(const ATickRateLimitMax: ADFloat);
    procedure SetTickRateLimitMin(const ATickRateLimitMin: ADFloat);
    procedure SetTickRateMax(const ATickRateMax: ADFloat);
    procedure SetTickRateMin(const ATickRateMin: ADFloat);
    procedure SetTickRateAverageMax(const ATickRateAverageMax: ADFloat);
    procedure SetTickRateAverageMin(const ATickRateAverageMin: ADFloat);
    procedure SetTickRateAverageOverMax(const ATickRateAverageOverMax: Cardinal);
    procedure SetTickRateAverageOverMin(const ATickRateAverageOverMin: Cardinal);
  public
    constructor Create(const AFirstValues: TTestPerformanceData); reintroduce;

    // Properties
    { ITestPerformanceSummary }
    property DesiredTickRateMax: ADFloat read GetDesiredTickRateMax write SetDesiredTickRateMax;
    property DesiredTickRateMin: ADFloat read GetDesiredTickRateMin write SetDesiredTickRateMin;
    property ExtraTimeMax: ADFloat read GetExtraTimeMax write SetExtraTimeMax;
    property ExtraTimeMin: ADFloat read GetExtraTimeMin write SetExtraTimeMin;
    property TickRateLimitMax: ADFloat read GetTickRateLimitMax write SetTickRateLimitMax;
    property TickRateLimitMin: ADFloat read GetTickRateLimitMin write SetTickRateLimitMin;
    property TickRateMax: ADFloat read GetTickRateMax write SetTickRateMax;
    property TickRateMin: ADFloat read GetTickRateMin write SetTickRateMin;
    property TickRateAverageMax: ADFloat read GetTickRateAverageMax write SetTickRateAverageMax;
    property TickRateAverageMin: ADFloat read GetTickRateAverageMin write SetTickRateAverageMin;
    property TickRateAverageOverMax: Cardinal read GetTickRateAverageOverMax write SetTickRateAverageOverMax;
    property TickRateAverageOverMin: Cardinal read GetTickRateAverageOverMin write SetTickRateAverageOverMin;
  end;

  ITestPerformanceDataCircularList = IADCircularList<TTestPerformanceData>;

  TTestTickCallback = procedure(const APerformanceLog: ITestPerformanceDataCircularList; const APerformanceSummary: ITestPerformanceSummary) of object; // Our Callback Type.

  {
    This Test Thread simply builds a historical dataset of Thread Performance Data.
    A Notify Event is called (if Assigned, of course) to output/consume this historical Performance Data.

    This Test Thread is designed to supplement a "Unit Test", since Unit Tests don't work in the context of a multi-threaded system.
  }
  TTestThread = class(TADPrecisionThread)
  private
    FPerformanceData: ITestPerformanceDataCircularList;
    FTickCallback: TTestTickCallback;
    // Getters
    function GetHistoryLimit: Integer;
    function GetTickCallback: TTestTickCallback;
    // Setters
    procedure SetHistoryLimit(const AHistoryLimit: Integer);
    procedure SetTickCallback(const ACallback: TTestTickCallback);
    // Internal Methods
    procedure LogPerformanceData;
    procedure InvokeCallbackIfAssigned;
  protected
    { TADPrecisionThread }
    function GetDefaultTickRateLimit: ADFloat; override;
    function GetDefaultTickRateDesired: ADFloat; override;
    procedure Tick(const ADelta, AStartTime: ADFloat); override;
  public
    constructor Create(const ACreateSuspended: Boolean); override;
    // Properties
    property HistoryLimit: Integer read GetHistoryLimit write SetHistoryLimit;
    property TickCallback: TTestTickCallback read GetTickCallback write SetTickCallback;
  end;

implementation

uses
  ADAPT.Generics.Collections;

type
  TTestPerformanceDataCircularList = class(TADCircularList<TTestPerformanceData>);

{ TTestPerformanceSummary }

constructor TTestPerformanceSummary.Create(const AFirstValues: TTestPerformanceData);
begin
  inherited Create;
  FDesiredTickRateMax := AFirstValues.DesiredTickRate;
  FDesiredTickRateMin := AFirstValues.DesiredTickRate;
  FExtraTimeMax := AFirstValues.ExtraTime;
  FExtraTimeMin := AFirstValues.ExtraTime;
  FTickRateLimitMax := AFirstValues.TickRateLimit;
  FTickRateLimitMin := AFirstValues.TickRateLimit;
  FTickRateMax := AFirstValues.TickRate;
  FTickRateMin := AFirstValues.TickRate;
  FTickRateAverageMax := AFirstValues.TickRateAverage;
  FTickRateAverageMin := AFirstValues.TickRateAverage;
  FTickRateAverageOverMax := AFirstValues.TickRateAverageOver;
  FTickRateAverageOVerMin := AFirstValues.TickRateAverageOver;
end;

function TTestPerformanceSummary.GetDesiredTickRateMax: ADFloat;
begin
  Result := FDesiredTickRateMax;
end;

function TTestPerformanceSummary.GetDesiredTickRateMin: ADFloat;
begin
  Result := FDesiredTickRateMin;
end;

function TTestPerformanceSummary.GetExtraTimeMax: ADFloat;
begin
  Result := FExtraTimeMax;
end;

function TTestPerformanceSummary.GetExtraTimeMin: ADFLoat;
begin
  Result := FExtraTimeMin;
end;

function TTestPerformanceSummary.GetTickRateAverageMax: ADFloat;
begin
  Result := FTickRateAverageMax;
end;

function TTestPerformanceSummary.GetTickRateAverageMin: ADFloat;
begin
  Result := FTickRateAverageMin;
end;

function TTestPerformanceSummary.GetTickRateAverageOverMax: Cardinal;
begin
  Result := FTickRateAverageOverMax;
end;

function TTestPerformanceSummary.GetTickRateAverageOverMin: Cardinal;
begin
  Result := FTickRateAverageOverMin;
end;

function TTestPerformanceSummary.GetTickRateLimitMax: ADFloat;
begin
  Result := FTickRateLimitMax;
end;

function TTestPerformanceSummary.GetTickRateLimitMin: ADFloat;
begin
  Result := FTickRateLimitMin;
end;

function TTestPerformanceSummary.GetTickRateMax: ADFloat;
begin
  Result := FTickRateMax;
end;

function TTestPerformanceSummary.GetTickRateMin: ADFloat;
begin
  Result := FTickRateMin;
end;

procedure TTestPerformanceSummary.SetDesiredTickRateMax(const ADesiredTickRateMax: ADFloat);
begin
  FDesiredTickRateMax := ADesiredTickRateMax;
end;

procedure TTestPerformanceSummary.SetDesiredTickRateMin(const ADesiredTickRateMin: ADFloat);
begin
  FDesiredTickRateMin := ADesiredTickRateMin;
end;

procedure TTestPerformanceSummary.SetExtraTimeMax(const AExtraTimeMax: ADFloat);
begin
  FExtraTimeMax := AExtraTimeMax;
end;

procedure TTestPerformanceSummary.SetExtraTimeMin(const AExtraTimeMin: ADFloat);
begin
  FExtraTimeMin := AExtraTimeMin;
end;

procedure TTestPerformanceSummary.SetTickRateAverageMax(const ATickRateAverageMax: ADFloat);
begin
  FTickRateAverageMax := ATickRateAverageMax;
end;

procedure TTestPerformanceSummary.SetTickRateAverageMin(const ATickRateAverageMin: ADFloat);
begin
  FTickRateAverageMin := ATickRateAverageMin;
end;

procedure TTestPerformanceSummary.SetTickRateAverageOverMax(const ATickRateAverageOverMax: Cardinal);
begin
  FTickRateAverageOverMax := ATickRateAverageOverMax;
end;

procedure TTestPerformanceSummary.SetTickRateAverageOverMin(const ATickRateAverageOverMin: Cardinal);
begin
  FTickRateAverageOverMin := ATickRateAverageOverMin;
end;

procedure TTestPerformanceSummary.SetTickRateLimitMax(const ATickRateLimitMax: ADFloat);
begin
  FTickRateLimitMax := ATickRateLimitMax;
end;

procedure TTestPerformanceSummary.SetTickRateLimitMin(const ATickRateLimitMin: ADFloat);
begin
  FTickRateLimitMin := ATickRateLimitMin;
end;

procedure TTestPerformanceSummary.SetTickRateMax(const ATickRateMax: ADFloat);
begin
  FTickRateMax := ATickRateMax;
end;

procedure TTestPerformanceSummary.SetTickRateMin(const ATickRateMin: ADFloat);
begin
  FTickRateMin := ATickRateMin;
end;

{ TTestThread }

constructor TTestThread.Create(const ACreateSuspended: Boolean);
begin
  inherited;
  FPerformanceData := TTestPerformanceDataCircularList.Create(50);
end;

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
  Result := 60; // We default the demo to 30 ticks per second.
end;

function TTestThread.GetHistoryLimit: Integer;
begin
  FLock.AcquireRead;
  try
    Result := FPerformanceData.Capacity;
  finally
    FLock.ReleaseRead;
  end;
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
var
  LPerformanceData: ITestPerformanceDataCircularList;
  LPerformanceSummary: ITestPerformanceSummary;
  I: Integer;
begin
  if FPerformanceData.Count > 0 then
  begin
    FLock.AcquireRead; // We acquire the Lock so that the Callback cannot be changed while we're using it...
    try
      LPerformanceData := TTestPerformanceDataCircularList.Create(FPerformanceData.Capacity);
      LPerformanceSummary := TTestPerformanceSummary.Create(FPerformanceData[0]);
      for I := 0 to FPerformanceData.Count - 1 do
      begin
        LPerformanceData.Add(FPerformanceData[I]);
        if I > 0 then
        begin
          // Desired Tick Rate
          if FPerformanceData[I].DesiredTickRate > LPerformanceSummary.DesiredTickRateMax then
            LPerformanceSummary.DesiredTickRateMax := FPerformanceData[I].DesiredTickRate;
          if FPerformanceData[I].DesiredTickRate < LPerformanceSummary.DesiredTickRateMin then
            LPerformanceSummary.DesiredTickRateMin := FPerformanceData[I].DesiredTickRate;

          // Extra Time
          if FPerformanceData[I].ExtraTime > LPerformanceSummary.ExtraTimeMax then
            LPerformanceSummary.ExtraTimeMax := FPerformanceData[I].ExtraTime;
          if FPerformanceData[I].ExtraTime < LPerformanceSummary.ExtraTimeMin then
            LPerformanceSummary.ExtraTimeMin := FPerformanceData[I].ExtraTime;

          // Tick Rate Limit
          if FPerformanceData[I].TickRateLimit > LPerformanceSummary.TickRateLimitMax then
            LPerformanceSummary.TickRateLimitMax := FPerformanceData[I].TickRateLimit;
          if FPerformanceData[I].TickRateLimit < LPerformanceSummary.TickRateLimitMin then
            LPerformanceSummary.TickRateLimitMin := FPerformanceData[I].TickRateLimit;

          // Tick Rate
          if FPerformanceData[I].TickRate > LPerformanceSummary.TickRateMax then
            LPerformanceSummary.TickRateMax := FPerformanceData[I].TickRate;
          if FPerformanceData[I].TickRate < LPerformanceSummary.TickRateMin then
            LPerformanceSummary.TickRateMin := FPerformanceData[I].TickRate;

          // Tick Rate Average
          if FPerformanceData[I].TickRateAverage > LPerformanceSummary.TickRateAverageMax then
            LPerformanceSummary.TickRateMax := FPerformanceData[I].TickRateAverage;
          if FPerformanceData[I].TickRateAverage < LPerformanceSummary.TickRateAverageMin then
            LPerformanceSummary.TickRateAverageMin := FPerformanceData[I].TickRateAverage;

          // Tick Rate Average Over
          if FPerformanceData[I].TickRateAverageOver > LPerformanceSummary.TickRateAverageOverMax then
            LPerformanceSummary.TickRateAverageOverMax := FPerformanceData[I].TickRateAverageOver;
          if FPerformanceData[I].TickRateAverageOver < LPerformanceSummary.TickRateAverageOverMin then
            LPerformanceSummary.TickRateAverageOverMin := FPerformanceData[I].TickRateAverageOver;
        end;
      end;

      if Assigned(FTickCallback) then // We need to check that the Callback has been Assigned
        Synchronize(procedure // We Synchronize the Callback because our Demo consumes it on the UI Thread.
                    begin
                      FTickCallback(LPerformanceData, LPerformanceSummary); // Invoke the Callback...
                    end);
    finally
      FLock.ReleaseRead; // ...Now we can release the Lock as we're done with the Callback.
    end;
  end;
end;

procedure TTestThread.LogPerformanceData;
var
  LPerformanceData: TTestPerformanceData;
begin
  FLock.AcquireRead; // We acquire the Lock so that the Callback cannot be changed while we're using it...
  try
    LPerformanceData.DesiredTickRate := TickRateDesired;
    LPerformanceData.ExtraTime := CalculateExtraTime;
    LPerformanceData.TickRateLimit := TickRateLimit;
    LPerformanceData.TickRate := TickRate;
    LPerformanceData.TickRateAverage := TickRateAverage;
    LPerformanceData.TickRateAverageOver := TickRateAverageOver;
  finally
    FLock.ReleaseRead; // ...Now we can release the Lock as we're done with the Callback.
  end;
  FPerformanceData.Add(LPerformanceData);
end;

procedure TTestThread.SetHistoryLimit(const AHistoryLimit: Integer);
begin
  FLock.AcquireWrite;
  try
    FPerformanceData.Capacity := AHistoryLimit;
  finally
    FLock.ReleaseWrite;
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
  LogPerformanceData;
  // Notify the Callback to consume the updated Performance Dataset
  InvokeCallbackIfAssigned;
  // Simulate some work
  Sleep(Random(75));
end;

end.
