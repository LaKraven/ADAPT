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
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FThread: TTestThread;
    procedure PerformanceCallback(const APerformanceLog: ITestPerformanceDataCircularList);
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

procedure TDemoForm.PerformanceCallback(const APerformanceLog: ITestPerformanceDataCircularList);
begin

end;

procedure TDemoForm.FormCreate(Sender: TObject);
begin
  FThread := TTestThread.Create;
  FThread.TickCallback := PerformanceCallback;
end;

{$R *.fmx}

end.
