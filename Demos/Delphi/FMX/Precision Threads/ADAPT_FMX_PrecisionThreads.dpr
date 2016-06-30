program ADAPT_FMX_PrecisionThreads;

uses
  System.StartUpCopy,
  FMX.Forms,
  ADAPT.Demo.PrecisionThreads.MainForm in 'ADAPT.Demo.PrecisionThreads.MainForm.pas' {DemoForm},
  ADAPT.Demo.PrecisionThreads.TestThread in 'ADAPT.Demo.PrecisionThreads.TestThread.pas';

{$R *.res}

begin
  {$IFDEF DEBUG}ReportMemoryLeaksOnShutdown := True;{$ENDIF DEBUG}
  Application.Initialize;
  Application.CreateForm(TDemoForm, DemoForm);
  Application.Run;
end.
