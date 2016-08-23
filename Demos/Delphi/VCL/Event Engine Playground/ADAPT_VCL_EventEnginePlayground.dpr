program ADAPT_VCL_EventEnginePlayground;

uses
  Vcl.Forms,
  ADAPT.Demo.EventEnginePlayground.MainForm in 'ADAPT.Demo.EventEnginePlayground.MainForm.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
