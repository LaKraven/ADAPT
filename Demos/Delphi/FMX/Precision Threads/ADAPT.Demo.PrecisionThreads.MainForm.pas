unit ADAPT.Demo.PrecisionThreads.MainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  ADAPT.Threads.Intf;

type
  TDemoForm = class(TForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DemoForm: TDemoForm;

implementation

uses
  ADAPT.Demo.PrecisionThreads.TestThread;

{$R *.fmx}

end.
