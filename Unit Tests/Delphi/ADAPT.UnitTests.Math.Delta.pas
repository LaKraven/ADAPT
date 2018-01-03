unit ADAPT.UnitTests.Math.Delta;

interface

{$I ADAPT.inc}

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes, System.SysUtils,
  {$ELSE}
    Classes, SysUtils,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  DUnitX.TestFramework,
  ADAPT.Intf, ADAPT.Math.Delta.Intf;

type
  [TestFixture]
  TADUTMathDelta = class(TObject)
  public
    [Test]
    procedure BasicIntegrity;
    [Test]
    procedure Extrapolation;
    [Test]
    procedure Interpolation;
  end;

implementation

uses
  ADAPT,
  ADAPT.Comparers,
  ADAPT.Math.Delta;

type
  // Interfaces
  IADFloatDelta = IADDeltaValue<ADFloat>;

{ TADUTMathDelta }

procedure TADUTMathDelta.BasicIntegrity;
var
  LDelta: IADFloatDelta;
  LCurrentTime: ADFloat;
begin
  // Get the current time as of Test Start.
  LCurrentTime := ADReferenceTime;
  // Create an empty Delta Value
  LDelta := ADDeltaFloat;

  // Set the Value for test start to 1.00
  LDelta[LCurrentTime] := 1.00;

  // Set the Value for Start Time + 1 second to 2.00
  LDelta[LCurrentTime + 1] := 2.00;

  // Verify the current exact values
  Assert.IsTrue(LDelta[LCurrentTime] = 1.00, Format('Value at %n should be 1.00 but instead got %n', [LCurrentTime, LDelta[LCurrentTime]]));
  Assert.IsTrue(LDelta[LCurrentTime + 1] = 2.00, Format('Value at %n should be 2.00 but instead got %n', [LCurrentTime + 1, LDelta[LCurrentTime + 1]]));
end;

procedure TADUTMathDelta.Extrapolation;
var
  LDelta: IADFloatDelta;
  LCurrentTime: ADFloat;
begin
  // Get the current time as of Test Start.
  LCurrentTime := ADReferenceTime;
  // Create an empty Delta Value
  LDelta := ADDeltaFloat;

  // Set the Value for test start to 1.00
  LDelta[LCurrentTime] := 1.00;

  // Set the Value for Start Time + 1 second to 2.00
  LDelta[LCurrentTime + 1] := 2.00;

  // Verify the current exact values
  Assert.IsTrue(LDelta[LCurrentTime] = 1.00, Format('Value at %n should be 1.00 but instead got %n', [LCurrentTime, LDelta[LCurrentTime]]));
  Assert.IsTrue(LDelta[LCurrentTime + 1] = 2.00, Format('Value at %n should be 2.00 but instead got %n', [LCurrentTime + 1, LDelta[LCurrentTime + 1]]));

  // Verify the value at LCurrentTime + 2
  Assert.IsTrue(LDelta[LCurrentTime + 2] = 3.00, Format('Value at %n should be 3.00 but instead got %n', [LCurrentTime + 2, LDelta[LCurrentTime + 2]]));

  // Verify the value at LCurrentTime + 2.5
  Assert.IsTrue(LDelta[LCurrentTime + 2.5] = 3.50, Format('Value at %n should be 3.50 but instead got %n', [LCurrentTime + 2.5, LDelta[LCurrentTime + 2.5]]));

  // Verify the value at LCurrentTime + 3
  Assert.IsTrue(LDelta[LCurrentTime + 3] = 4.00, Format('Value at %n should be 4.00 but instead got %n', [LCurrentTime + 3, LDelta[LCurrentTime + 3]]));

  // Verify the value at LCurrentTime -1
  Assert.IsTrue(LDelta[LCurrentTime - 1] = 0.00, Format('Value at %n should be 0.00 but instead got %n', [LCurrentTime - 1, LDelta[LCurrentTime - 1]]));

  // Verify the value at LCurrentTime -2
  Assert.IsTrue(LDelta[LCurrentTime - 2] = -1.00, Format('Value at %n should be -1.00 but instead got %n', [LCurrentTime - 2, LDelta[LCurrentTime - 2]]));

  // Verify the value at LCurrentTime -2.5
  Assert.IsTrue(LDelta[LCurrentTime - 2.5] = -1.50, Format('Value at %n should be -1.50 but instead got %n', [LCurrentTime - 2.5, LDelta[LCurrentTime - 2.5]]));

  // Verify the value at LCurrentTime -3
  Assert.IsTrue(LDelta[LCurrentTime - 3] = -2.00, Format('Value at %n should be -2.00 but instead got %n', [LCurrentTime - 3, LDelta[LCurrentTime - 3]]));
end;

procedure TADUTMathDelta.Interpolation;
var
  LDelta: IADFloatDelta;
  LCurrentTime: ADFloat;
begin
  // Get the current time as of Test Start.
  LCurrentTime := ADReferenceTime;
  // Create an empty Delta Value
  LDelta := ADDeltaFloat;

  // Set the Value for test start to 1.00
  LDelta[LCurrentTime] := 1.00;

  // Set the Value for Start Time + 1 second to 2.00
  LDelta[LCurrentTime + 1] := 2.00;

  // Verify the value at LCurrentTime + 0.5;
  Assert.IsTrue(LDelta[LCurrentTime + 0.5] = 1.50, Format('Value at %n should be 1.50 but instead got %n', [LCurrentTime + 0.5, LDelta[LCurrentTime + 0.5]]));

  // Verify the value at LCurrentTime + 0.75;
  Assert.IsTrue(LDelta[LCurrentTime + 0.75] = 1.75, Format('Value at %n should be 1.75 but instead got %n', [LCurrentTime + 0.75, LDelta[LCurrentTime + 0.75]]));

  // Now let's add a new reference value.
  LDelta[LCurrentTime + 2] := 3.00;

  // Verify the value at LCurrentTime + 0.5;
  Assert.IsTrue(LDelta[LCurrentTime + 0.5] = 1.50, Format('Value at %n should be 1.50 but instead got %n', [LCurrentTime + 0.5, LDelta[LCurrentTime + 0.5]]));

  // Verify the value at LCurrentTime + 0.75;
  Assert.IsTrue(LDelta[LCurrentTime + 0.75] = 1.75, Format('Value at %n should be 1.75 but instead got %n', [LCurrentTime + 0.75, LDelta[LCurrentTime + 0.75]]));

  // Verify the value at LCurrentTime + 1.50;
  Assert.IsTrue(LDelta[LCurrentTime + 1.50] = 2.5, Format('Value at %n should be 2.5 but instead got %n', [LCurrentTime + 1.5, LDelta[LCurrentTime + 1.5]]));

  LDelta[LCurrentTime + 3] := 4.00;
  LDelta[LCurrentTime + 4] := 5.00;
  LDelta[LCurrentTime + 5] := 6.00;

  // Verify the value at LCurrentTime + 4.5;
  Assert.IsTrue(LDelta[LCurrentTime + 4.5] = 5.5, Format('Value at %n should be 5.5 but instead got %n', [LCurrentTime + 4.5, LDelta[LCurrentTime + 4.5]]));

  // Re-Verify the value at LCurrentTime + 0.5;
  Assert.IsTrue(LDelta[LCurrentTime + 0.5] = 1.50, Format('Value at %n should be 1.50 but instead got %n', [LCurrentTime + 0.5, LDelta[LCurrentTime + 0.5]]));

  // Verify the value at LCurrentTime - 1;
  Assert.IsTrue(LDelta[LCurrentTime - 1.00] = 0.00, Format('Value at %n should be 0.00 but instead got %n', [LCurrentTime - 1.00, LDelta[LCurrentTime - 1.00]]));
end;

end.
