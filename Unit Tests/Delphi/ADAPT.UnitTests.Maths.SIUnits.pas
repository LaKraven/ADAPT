unit ADAPT.UnitTests.Maths.SIUnits;

interface

{$I ADAPT.inc}

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes, System.SysUtils,
  {$ELSE}
    Classes, SysUtils,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  DUnitX.TestFramework,
  ADAPT.Common.Intf,
  ADAPT.Math.SIUnits;

type
  [TestFixture]
  TAdaptUnitTestMathSIUnits = class(TObject)
  public
    [Test]
    procedure OneMegaToOneGigaExplicit;
    [Test]
    [TestCase('10 to 1 Deca', '10,simOne,1,simDeca')]
    [TestCase('100 to 1 Hecta', '100,simOne,1,simHecto')]
    [TestCase('20 to 2 Deca', '20,simOne,2,simDeca')]
    [TestCase('1 Deca to 1 Deca', '1,simDeca,1,simDeca')]
    [TestCase('1000 to 1 Kilo', '1000,simOne,1,simKilo')]
    [Testcase('1000 Mega to 1 Giga', '1000,simMega,1,simGiga')]
    procedure MagnitudeBest(const AInputValue: ADFloat; const AMagnitude: TADSIMagnitude; const AExpectedOutputValue: ADFloat; const AExpectedOutputMagnitude: TADSIMagnitude);
  end;

implementation

{ TAdaptUnitTestMathSIUnits }

procedure TAdaptUnitTestMathSIUnits.OneMegaToOneGigaExplicit;
var
  LOutputValue: ADFloat;
begin
  LOutputValue := SIMagnitudeConvert(1000, simMega, simGiga);
  Assert.IsTrue(LOutputValue = 1, Format('1000MB SHOULD be 1GB, but got %n', [LOutputValue]));
end;

procedure TAdaptUnitTestMathSIUnits.MagnitudeBest(const AInputValue: ADFloat; const AMagnitude: TADSIMagnitude; const AExpectedOutputValue: ADFloat; const AExpectedOutputMagnitude: TADSIMagnitude);
var
  LOutputValue: ADFloat;
  LOutputMagnitude: TADSIMagnitude;
begin
  SIMagnitudeToBest(AInputValue, AMagnitude, LOutputValue, LOutputMagnitude);
  Assert.IsTrue((LOutputValue = AExpectedOutputValue) and (LOutputMagnitude = AExpectedOutputMagnitude), Format('Expected Value "%n" (got "%n") and Magnitude "%s" (got "%s")', [AExpectedOutputValue, LOutputValue, AD_UNIT_MAGNITUDE_NAMES_SI[AExpectedOutputMagnitude, unLong], AD_UNIT_MAGNITUDE_NAMES_SI[LOutputMagnitude, unLong]]));
end;

initialization
  TDUnitX.RegisterTestFixture(TAdaptUnitTestMathSIUnits);

end.
