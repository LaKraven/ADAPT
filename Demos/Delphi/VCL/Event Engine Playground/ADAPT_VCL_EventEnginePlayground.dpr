program ADAPT_VCL_EventEnginePlayground;

uses
  Vcl.Forms,
  ADAPT.Demo.EventEnginePlayground.MainForm in 'ADAPT.Demo.EventEnginePlayground.MainForm.pas' {MainForm},
  ADAPT.Demo.EventEnginePlayground.Events in 'ADAPT.Demo.EventEnginePlayground.Events.pas',
  ADAPT.Demo.EventEnginePlayground.EventThread in 'ADAPT.Demo.EventEnginePlayground.EventThread.pas';

{$R *.res}

begin
  {$IFDEF DEBUG}ReportMemoryLeaksOnShutdown := True;{$ENDIF DEBUG}
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
