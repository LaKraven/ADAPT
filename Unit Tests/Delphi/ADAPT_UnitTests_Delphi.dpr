program ADAPT_UnitTests_Delphi;

{$IFNDEF TESTINSIGHT}{$APPTYPE CONSOLE}{$ENDIF}
{$STRONGLINKTYPES ON}
uses
  SysUtils,
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ENDIF }
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  DUnitX.TestFramework,
  ADAPT.UnitTests.Generics.Lists in 'ADAPT.UnitTests.Generics.Lists.pas',
  ADAPT.Common in '..\..\Source\Pascal\Lib\ADAPT.Common.pas',
  ADAPT.Threads in '..\..\Source\Pascal\Lib\ADAPT.Threads.pas',
  ADAPT.Performance in '..\..\Source\Pascal\Lib\ADAPT.Performance.pas',
  ADAPT.Generics.Arrays in '..\..\Source\Pascal\Lib\ADAPT.Generics.Arrays.pas',
  ADAPT.Generics.Defaults in '..\..\Source\Pascal\Lib\ADAPT.Generics.Defaults.pas',
  ADAPT.Generics.Lists in '..\..\Source\Pascal\Lib\ADAPT.Generics.Lists.pas',
  ADAPT.Math.SIUnits in '..\..\Source\Pascal\Lib\ADAPT.Math.SIUnits.pas',
  ADAPT.UnitTests.Maths.SIUnits in 'ADAPT.UnitTests.Maths.SIUnits.pas',
  ADAPT.Streamables in '..\..\Source\Pascal\Lib\ADAPT.Streamables.pas',
  ADAPT.Streams in '..\..\Source\Pascal\Lib\ADAPT.Streams.pas',
  ADAPT.Common.Intf in '..\..\Source\Pascal\Lib\ADAPT.Common.Intf.pas',
  ADAPT.Threads.Intf in '..\..\Source\Pascal\Lib\ADAPT.Threads.Intf.pas',
  ADAPT.Performance.Intf in '..\..\Source\Pascal\Lib\ADAPT.Performance.Intf.pas',
  ADAPT.Generics.Defaults.Intf in '..\..\Source\Pascal\Lib\ADAPT.Generics.Defaults.Intf.pas',
  ADAPT.Generics.Arrays.Intf in '..\..\Source\Pascal\Lib\ADAPT.Generics.Arrays.Intf.pas',
  ADAPT.Generics.Lists.Intf in '..\..\Source\Pascal\Lib\ADAPT.Generics.Lists.Intf.pas',
  ADAPT.Generics.Trees in '..\..\Source\Pascal\Lib\ADAPT.Generics.Trees.pas',
  ADAPT.Generics.Trees.Intf in '..\..\Source\Pascal\Lib\ADAPT.Generics.Trees.Intf.pas',
  ADAPT.UnitTests.Generics.Arrays in 'ADAPT.UnitTests.Generics.Arrays.pas',
  ADAPT.UnitTests.Generics.Common in 'ADAPT.UnitTests.Generics.Common.pas',
  ADAPT.Generics.Maps.Intf in '..\..\Source\Pascal\Lib\ADAPT.Generics.Maps.Intf.pas',
  ADAPT.Generics.Maps in '..\..\Source\Pascal\Lib\ADAPT.Generics.Maps.pas',
  ADAPT.Generics.Allocators.Intf in '..\..\Source\Pascal\Lib\ADAPT.Generics.Allocators.Intf.pas',
  ADAPT.Generics.Allocators in '..\..\Source\Pascal\Lib\ADAPT.Generics.Allocators.pas';

var
  runner : ITestRunner;
  results : IRunResults;
  logger : ITestLogger;
  nunitLogger : ITestLogger;
begin
  ReportMemoryLeaksOnShutdown := True;
{$IFDEF TESTINSIGHT}
  TestInsight.DUnitX.RunRegisteredTests;
  exit;
{$ENDIF}
  try
    //Check command line options, will exit if invalid
    TDUnitX.CheckCommandLine;
    //Create the test runner
    runner := TDUnitX.CreateRunner;
    //Tell the runner to use RTTI to find Fixtures
    runner.UseRTTI := True;
    //tell the runner how we will log things
    //Log to the console window
    logger := TDUnitXConsoleLogger.Create(true);
    runner.AddLogger(logger);
    //Generate an NUnit compatible XML File
    nunitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    runner.AddLogger(nunitLogger);
    runner.FailsOnNoAsserts := False; //When true, Assertions must be made during tests;

    //Run tests
    results := runner.Execute;
    if not results.AllPassed then
      System.ExitCode := EXIT_ERRORS;

    {$IFNDEF CI}
    //We don't want this happening when running under CI.
    if TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause then
    begin
      System.Write('Done.. press <Enter> key to quit.');
      System.Readln;
    end;
    {$ENDIF}
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;
end.
