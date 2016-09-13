unit ADAPT.Demo.PrecisionThreads.MainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  ADAPT.Threads.Intf, FMX.Objects, FMX.Layouts,
  ADAPT.Demo.PrecisionThreads.TestThread,
  ADAPT.Common, FMX.Edit, FMX.EditBox, FMX.SpinBox, FMX.Controls.Presentation,
  FMX.StdCtrls;

type
  TDemoForm = class(TForm)
    Layout1: TLayout;
    PaintBox1: TPaintBox;
    Label1: TLabel;
    sbTickRateLimit: TSpinBox;
    Label2: TLabel;
    sbDesiredTickRate: TSpinBox;
    Label3: TLabel;
    sbHIstoryLimit: TSpinBox;
    Label4: TLabel;
    sbWorkSimMax: TSpinBox;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject; Canvas: TCanvas);
    procedure sbHIstoryLimitChange(Sender: TObject);
    procedure sbWorkSimMaxChange(Sender: TObject);
  private
    FPerformanceLog: ITestPerformanceDataCircularList;
    FPerformanceSummary: ITestPerformanceSummary;
    FThread: TTestThread;
    procedure PerformanceCallback(const APerformanceLog: ITestPerformanceDataCircularList; const APerformanceSummary: ITestPerformanceSummary);
    procedure RedrawGraph;
  public
    { Public declarations }
  end;

var
  DemoForm: TDemoForm;

implementation

uses
  System.Math,
  ADAPT.Collections;

procedure TDemoForm.FormDestroy(Sender: TObject);
begin
  FThread.Free;
end;

procedure TDemoForm.PerformanceCallback(const APerformanceLog: ITestPerformanceDataCircularList; const APerformanceSummary: ITestPerformanceSummary);
begin
  FThread.TickRateDesired := sbDesiredTickRate.Value;
  FThread.TickRateLimit := sbTickRateLimit.Value;
  FPerformanceLog := APerformanceLog;
  FPerformanceSummary := APerformanceSummary;
  Invalidate;
end;

procedure TDemoForm.RedrawGraph;
const
  MARGIN_LEFT: Single = 10;
  MARGIN_RIGHT: Single = 10;
  MARGIN_TOP: Single = 10;
  MARGIN_BOTTOM: Single = 10;
  MARGIN_DIVIDER: Single = 10;

  COLOR_BACKGROUND: TAlphaColor = TAlphaColors.Cornflowerblue;
  COLOR_BACKGROUND_KEY: TAlphaColor = TAlphaColors.Black;
  COLOR_BACKGROUND_GRAPH: TAlphaColor = TAlphaColors.Black;
  COLOR_SERIES_DESIREDTICKRATE: TAlphaColor = TAlphaColors.Orange;
  COLOR_SERIES_EXTRATIME: TAlphaColor = TAlphaColors.Limegreen;
  COLOR_SERIES_TICKRATELIMIT: TAlphaColor = TAlphaColors.Maroon;
  COLOR_SERIES_TICKRATE: TAlphaColor = TAlphaColors.Red;
  COLOR_SERIES_TICKRATEAVERAGE: TAlphaColor = TAlphaColors.Pink;
  COLOR_SERIES_TICKRATEAVERAGEOVER: TAlphaColor = TAlphaColors.Purple;
  COLOR_GRAPH_LINES: TAlphaColor = TAlphaColors.Darkgreen;
  RADIUS_BLOB: Single = 4;
var
  LRectOuter,
  LRectInner,
  LRectGraph: TRectF;
  LSeriesMarginX: Single;
  I: Integer;
  LRateLowest, LRateHighest, LRateRange,
  LLastPercent, LThisPercent: ADFloat;
begin
  // Calculate Rects
  LRectOuter := PaintBox1.ClipRect;
  LRectInner := RectF(
                       LRectOuter.Left + MARGIN_LEFT,
                       LRectOuter.Top + MARGIN_TOP,
                       LRectOuter.Right - MARGIN_RIGHT,
                       LRectOuter.Bottom - MARGIN_BOTTOM
                     );
  LRectGraph := LRectInner;

  // Calculate Margins
  LSeriesMarginX := LRectGraph.Width / (FPerformanceLog.Capacity - 1);

  // Calculate Tick Rate Constraints
  LRateLowest := MinValue([
                            FPerformanceSummary.DesiredTickRateMin,
                            FPerformanceSummary.TickRateLimitMin,
                            FPerformanceSummary.TickRateMin,
                            FPerformanceSummary.TickRateAverageMin
                          ]);

  LRateHighest := MaxValue([
                             FPerformanceSummary.DesiredTickRateMax,
                             FPerformanceSummary.TickRateLimitMax,
                             FPerformanceSummary.TickRateMax,
                             FPerformanceSummary.TickRateAverageMax
                           ]);
  LRateRange := LRateHighest - LRateLowest;

  PaintBox1.Canvas.BeginScene;
  try
    // Fill Outer Rect
    PaintBox1.Canvas.ClearRect(LRectOuter, COLOR_BACKGROUND);

    // Fill Graph Rect
    PaintBox1.Canvas.ClearRect(LRectGraph, COLOR_BACKGROUND_GRAPH);

    // Draw Series
    if FPerformanceLog <> nil then
    begin
      // Draw Graph Lines
      PaintBox1.Canvas.Stroke.Thickness := 0.5;
      for I := 1 to FPerformanceLog.Capacity - 1 do
      begin
        if (I <> 0) and (I <> FPerformanceLog.Capacity) then
        begin
          PaintBox1.Canvas.Stroke.Color := COLOR_GRAPH_LINES;
          PaintBox1.Canvas.DrawLine(
                                     PointF(
                                             (I * LSeriesMarginX) + LRectGraph.Left,
                                             LRectGraph.Top
                                           ),
                                     PointF(
                                             (I * LSeriesMarginX) + LRectGraph.Left,
                                             LRectGraph.Bottom
                                           ),
                                     0.5
                                   );
        end;
      end;

      // Draw Performance Data
      for I := 0 to FPerformanceLog.Count - 1 do
      begin
        PaintBox1.Canvas.Stroke.Thickness := 1;

        // Tick Rate Limit
        PaintBox1.Canvas.Stroke.Color := COLOR_SERIES_TICKRATELIMIT;
        PaintBox1.Canvas.Fill.Color := COLOR_SERIES_TICKRATELIMIT;
        { Blob }
        LThisPercent := (FPerformanceLog[I].TickRateLimit / LRateHighest) * 100;
        PaintBox1.Canvas.FillEllipse(
                                      RectF(
                                             (((I) * LSeriesMarginX) + LRectGraph.Left) - RADIUS_BLOB,
                                             (LRectGraph.Bottom - ((LRectGraph.Height / 100) * LThisPercent)) - RADIUS_BLOB,
                                             (((I) * LSeriesMarginX) + LRectGraph.Left) + RADIUS_BLOB,
                                             (LRectGraph.Bottom - ((LRectGraph.Height / 100) * LThisPercent)) + RADIUS_BLOB
                                           ),
                                      1
                                    );
        { Link Lines }
        if I > 0 then
        begin
          LLastPercent := (FPerformanceLog[I - 1].TickRateLimit / LRateHighest) * 100;
          PaintBox1.Canvas.DrawLine(
                                     PointF(
                                             ((I - 1) * LSeriesMarginX) + LRectGraph.Left,
                                             (LRectGraph.Bottom - ((LRectGraph.Height / 100) * LLastPercent))
                                           ),
                                     PointF(
                                             ((I) * LSeriesMarginX) + LRectGraph.Left,
                                             (LRectGraph.Bottom - ((LRectGraph.Height / 100) * LThisPercent))
                                           ),
                                     1
                                   );
        end;

        // Tick Rate Limit
        PaintBox1.Canvas.Stroke.Color := COLOR_SERIES_DESIREDTICKRATE;
        PaintBox1.Canvas.Fill.Color := COLOR_SERIES_DESIREDTICKRATE;
        { Blob }
        LThisPercent := (FPerformanceLog[I].DesiredTickRate / LRateHighest) * 100;
        PaintBox1.Canvas.FillEllipse(
                                      RectF(
                                             (((I) * LSeriesMarginX) + LRectGraph.Left) - RADIUS_BLOB,
                                             (LRectGraph.Bottom - ((LRectGraph.Height / 100) * LThisPercent)) - RADIUS_BLOB,
                                             (((I) * LSeriesMarginX) + LRectGraph.Left) + RADIUS_BLOB,
                                             (LRectGraph.Bottom - ((LRectGraph.Height / 100) * LThisPercent)) + RADIUS_BLOB
                                           ),
                                      1
                                    );
        { Link Lines }
        if I > 0 then
        begin
          LLastPercent := (FPerformanceLog[I - 1].DesiredTickRate / LRateHighest) * 100;
          PaintBox1.Canvas.DrawLine(
                                     PointF(
                                             ((I - 1) * LSeriesMarginX) + LRectGraph.Left,
                                             (LRectGraph.Bottom - ((LRectGraph.Height / 100) * LLastPercent))
                                           ),
                                     PointF(
                                             ((I) * LSeriesMarginX) + LRectGraph.Left,
                                             (LRectGraph.Bottom - ((LRectGraph.Height / 100) * LThisPercent))
                                           ),
                                     1
                                   );
        end;

        // Tick Rate Average
        PaintBox1.Canvas.Stroke.Color := COLOR_SERIES_TICKRATEAVERAGE;
        PaintBox1.Canvas.Fill.Color := COLOR_SERIES_TICKRATEAVERAGE;
        { Blob }
        LThisPercent := (FPerformanceLog[I].TickRateAverage / LRateHighest) * 100;
        PaintBox1.Canvas.FillEllipse(
                                      RectF(
                                             (((I) * LSeriesMarginX) + LRectGraph.Left) - RADIUS_BLOB,
                                             (LRectGraph.Bottom - ((LRectGraph.Height / 100) * LThisPercent)) - RADIUS_BLOB,
                                             (((I) * LSeriesMarginX) + LRectGraph.Left) + RADIUS_BLOB,
                                             (LRectGraph.Bottom - ((LRectGraph.Height / 100) * LThisPercent)) + RADIUS_BLOB
                                           ),
                                      1
                                    );
        { Link Lines }
        if I > 0 then
        begin
          LLastPercent := (FPerformanceLog[I - 1].TickRateAverage / LRateHighest) * 100;
          PaintBox1.Canvas.DrawLine(
                                     PointF(
                                             ((I - 1) * LSeriesMarginX) + LRectGraph.Left,
                                             (LRectGraph.Bottom - ((LRectGraph.Height / 100) * LLastPercent))
                                           ),
                                     PointF(
                                             ((I) * LSeriesMarginX) + LRectGraph.Left,
                                             (LRectGraph.Bottom - ((LRectGraph.Height / 100) * LThisPercent))
                                           ),
                                     1
                                   );
        end;

        // Tick Rate
        PaintBox1.Canvas.Stroke.Color := COLOR_SERIES_TICKRATE;
        PaintBox1.Canvas.Fill.Color := COLOR_SERIES_TICKRATE;
        { Blob }
        LThisPercent := (FPerformanceLog[I].TickRate / LRateHighest) * 100;
        PaintBox1.Canvas.FillEllipse(
                                      RectF(
                                             (((I) * LSeriesMarginX) + LRectGraph.Left) - RADIUS_BLOB,
                                             (LRectGraph.Bottom - ((LRectGraph.Height / 100) * LThisPercent)) - RADIUS_BLOB,
                                             (((I) * LSeriesMarginX) + LRectGraph.Left) + RADIUS_BLOB,
                                             (LRectGraph.Bottom - ((LRectGraph.Height / 100) * LThisPercent)) + RADIUS_BLOB
                                           ),
                                      1
                                    );
        { Link Lines }
        if I > 0 then
        begin
          LLastPercent := (FPerformanceLog[I - 1].TickRate / LRateHighest) * 100;
          PaintBox1.Canvas.DrawLine(
                                     PointF(
                                             ((I - 1) * LSeriesMarginX) + LRectGraph.Left,
                                             (LRectGraph.Bottom - ((LRectGraph.Height / 100) * LLastPercent))
                                           ),
                                     PointF(
                                             ((I) * LSeriesMarginX) + LRectGraph.Left,
                                             (LRectGraph.Bottom - ((LRectGraph.Height / 100) * LThisPercent))
                                           ),
                                     1
                                   );
        end;
      end;
    end;

  finally
    PaintBox1.Canvas.EndScene;
  end;
end;

procedure TDemoForm.FormCreate(Sender: TObject);
begin
  FThread := TTestThread.Create;
  FThread.TickCallback := PerformanceCallback;
end;

procedure TDemoForm.PaintBox1Paint(Sender: TObject; Canvas: TCanvas);
begin
  RedrawGraph;
end;

procedure TDemoForm.sbHIstoryLimitChange(Sender: TObject);
begin
  FThread.HistoryLimit := Round(sbHIstoryLimit.Value);
end;

procedure TDemoForm.sbWorkSimMaxChange(Sender: TObject);
begin
  FThread.WorkSimMax := Round(sbWorkSimMax.Value);
end;

{$R *.fmx}

end.
