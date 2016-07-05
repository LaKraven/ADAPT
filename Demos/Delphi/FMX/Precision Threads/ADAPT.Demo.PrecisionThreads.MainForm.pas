unit ADAPT.Demo.PrecisionThreads.MainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  ADAPT.Threads.Intf, FMX.Objects, FMX.Layouts,
  ADAPT.Demo.PrecisionThreads.TestThread;

type
  TDemoForm = class(TForm)
    Layout1: TLayout;
    PerformanceChart: TImage;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PerformanceChartClick(Sender: TObject);
  private
    FThread: TTestThread;
  public
    { Public declarations }
  end;

var
  DemoForm: TDemoForm;

implementation

procedure TDemoForm.FormDestroy(Sender: TObject);
begin
  FThread.Free;
end;

procedure TDemoForm.FormCreate(Sender: TObject);
begin
  FThread := TTestThread.Create;
end;

procedure TDemoForm.PerformanceChartClick(Sender: TObject);
begin

end;

{$R *.fmx}

end.
