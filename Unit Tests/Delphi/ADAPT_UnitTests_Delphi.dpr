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
  ADAPT in '..\..\Source\Pascal\Lib\ADAPT.pas',
  ADAPT.Threads in '..\..\Source\Pascal\Lib\ADAPT.Threads.pas',
  ADAPT.Performance in '..\..\Source\Pascal\Lib\ADAPT.Performance.pas',
  ADAPT.Hashers in '..\..\Source\Pascal\Lib\ADAPT.Hashers.pas',
  ADAPT.Math.SIUnits in '..\..\Source\Pascal\Lib\ADAPT.Math.SIUnits.pas',
  ADAPT.UnitTests.Maths.SIUnits in 'ADAPT.UnitTests.Maths.SIUnits.pas',
  ADAPT.Streamables in '..\..\Source\Pascal\Lib\ADAPT.Streamables.pas',
  ADAPT.Streams in '..\..\Source\Pascal\Lib\ADAPT.Streams.pas',
  ADAPT.Intf in '..\..\Source\Pascal\Lib\ADAPT.Intf.pas',
  ADAPT.Threads.Intf in '..\..\Source\Pascal\Lib\ADAPT.Threads.Intf.pas',
  ADAPT.Performance.Intf in '..\..\Source\Pascal\Lib\ADAPT.Performance.Intf.pas',
  ADAPT.Hashers.Intf in '..\..\Source\Pascal\Lib\ADAPT.Hashers.Intf.pas',
  ADAPT.UnitTests.Generics.Common in 'ADAPT.UnitTests.Generics.Common.pas',
  ADAPT.Streams.Intf in '..\..\Source\Pascal\Lib\ADAPT.Streams.Intf.pas',
  ADAPT.Threadsafe in '..\..\Source\Pascal\Lib\ADAPT.Threadsafe.pas',
  ADAPT.Collections.Threadsafe in '..\..\Source\Pascal\Lib\ADAPT.Collections.Threadsafe.pas',
  ADAPT.Performance.Threadsafe in '..\..\Source\Pascal\Lib\ADAPT.Performance.Threadsafe.pas',
  ADAPT.Streams.Threadsafe in '..\..\Source\Pascal\Lib\ADAPT.Streams.Threadsafe.pas',
  ADAPT.Comparers in '..\..\Source\Pascal\Lib\ADAPT.Comparers.pas',
  ADAPT.UnitTests.Generics.Comparers in 'ADAPT.UnitTests.Generics.Comparers.pas',
  ADAPT.Math.Common.Intf in '..\..\Source\Pascal\Lib\ADAPT.Math.Common.Intf.pas',
  ADAPT.Math.Common in '..\..\Source\Pascal\Lib\ADAPT.Math.Common.pas',
  ADAPT.Math.Delta.Intf in '..\..\Source\Pascal\Lib\ADAPT.Math.Delta.Intf.pas',
  ADAPT.Math.Delta in '..\..\Source\Pascal\Lib\ADAPT.Math.Delta.pas',
  ADAPT.UnitTests.Maths.Averagers in 'ADAPT.UnitTests.Maths.Averagers.pas',
  ADAPT.Math.Averagers.Intf in '..\..\Source\Pascal\Lib\ADAPT.Math.Averagers.Intf.pas',
  ADAPT.Math.Averagers in '..\..\Source\Pascal\Lib\ADAPT.Math.Averagers.pas',
  ADAPT.Collections.Intf in '..\..\Source\Pascal\Lib\ADAPT.Collections.Intf.pas',
  ADAPT.Collections in '..\..\Source\Pascal\Lib\ADAPT.Collections.pas',
  ADAPT.UnitTests.Streams in 'ADAPT.UnitTests.Streams.pas',
  ADAPT.UnitTests.Math.Delta in 'ADAPT.UnitTests.Math.Delta.pas',
  ADAPT.Comparers.Intf in '..\..\Source\Pascal\Lib\ADAPT.Comparers.Intf.pas',
  ADAPT.Math.Delta.Abstract in '..\..\Source\Pascal\Lib\ADAPT.Math.Delta.Abstract.pas',
  ADAPT.Streams.Abstract in '..\..\Source\Pascal\Lib\ADAPT.Streams.Abstract.pas';

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
    ReportMemoryLeaksOnShutdown := True;
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
