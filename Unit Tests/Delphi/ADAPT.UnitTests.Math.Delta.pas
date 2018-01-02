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
  LDelta := TADDeltaFloat.Create;

  // Set the Value for test start to 1.00
  LDelta.ValueAt[LCurrentTime] := 1.00;

  // Set the Value for Start Time + 1 second to 2.00
  LDelta.ValueAt[LCurrentTime + 1] := 2.00;

  // Verify the current exact values
  Assert.IsTrue(LDelta.ValueAt[LCurrentTime] = 1.00, Format('Value at %n should be 1.00 but instead got %n', [LCurrentTime, LDelta.ValueAt[LCurrentTime]]));
  Assert.IsTrue(LDelta.ValueAt[LCurrentTime + 1] = 2.00, Format('Value at %n should be 2.00 but instead got %n', [LCurrentTime + 1, LDelta.ValueAt[LCurrentTime + 1]]));
end;

procedure TADUTMathDelta.Extrapolation;
var
  LDelta: IADFloatDelta;
  LCurrentTime: ADFloat;
begin
  // Get the current time as of Test Start.
  LCurrentTime := ADReferenceTime;
  // Create an empty Delta Value
  LDelta := TADDeltaFloat.Create;

  // Set the Value for test start to 1.00
  LDelta.ValueAt[LCurrentTime] := 1.00;

  // Set the Value for Start Time + 1 second to 2.00
  LDelta.ValueAt[LCurrentTime + 1] := 2.00;

  // Verify the current exact values
  Assert.IsTrue(LDelta.ValueAt[LCurrentTime] = 1.00, Format('Value at %n should be 1.00 but instead got %n', [LCurrentTime, LDelta.ValueAt[LCurrentTime]]));
  Assert.IsTrue(LDelta.ValueAt[LCurrentTime + 1] = 2.00, Format('Value at %n should be 2.00 but instead got %n', [LCurrentTime + 1, LDelta.ValueAt[LCurrentTime + 1]]));

  // Verify the value at LCurrentTime + 2
  Assert.IsTrue(LDelta.ValueAt[LCurrentTime + 2] = 3.00, Format('Value at %n should be 3.00 but instead got %n', [LCurrentTime + 2, LDelta.ValueAt[LCurrentTime + 2]]));

  // Verify the value at LCurrentTime + 2.5
  Assert.IsTrue(LDelta.ValueAt[LCurrentTime + 2.5] = 3.50, Format('Value at %n should be 3.50 but instead got %n', [LCurrentTime + 2.5, LDelta.ValueAt[LCurrentTime + 2.5]]));

  // Verify the value at LCurrentTime + 3
  Assert.IsTrue(LDelta.ValueAt[LCurrentTime + 3] = 4.00, Format('Value at %n should be 4.00 but instead got %n', [LCurrentTime + 3, LDelta.ValueAt[LCurrentTime + 3]]));

  // Verify the value at LCurrentTime -1
  Assert.IsTrue(LDelta.ValueAt[LCurrentTime - 1] = 0.00, Format('Value at %n should be 0.00 but instead got %n', [LCurrentTime - 1, LDelta.ValueAt[LCurrentTime - 1]]));

  // Verify the value at LCurrentTime -2
  Assert.IsTrue(LDelta.ValueAt[LCurrentTime - 2] = -1.00, Format('Value at %n should be -1.00 but instead got %n', [LCurrentTime - 2, LDelta.ValueAt[LCurrentTime - 2]]));

  // Verify the value at LCurrentTime -2.5
  Assert.IsTrue(LDelta.ValueAt[LCurrentTime - 2.5] = -1.50, Format('Value at %n should be -1.50 but instead got %n', [LCurrentTime - 2.5, LDelta.ValueAt[LCurrentTime - 2.5]]));

  // Verify the value at LCurrentTime -3
  Assert.IsTrue(LDelta.ValueAt[LCurrentTime - 3] = -2.00, Format('Value at %n should be -2.00 but instead got %n', [LCurrentTime - 3, LDelta.ValueAt[LCurrentTime - 3]]));
end;

procedure TADUTMathDelta.Interpolation;
var
  LDelta: IADFloatDelta;
  LCurrentTime: ADFloat;
begin
  // Get the current time as of Test Start.
  LCurrentTime := ADReferenceTime;
  // Create an empty Delta Value
  LDelta := TADDeltaFloat.Create;

  // Set the Value for test start to 1.00
  LDelta.ValueAt[LCurrentTime] := 1.00;

  // Set the Value for Start Time + 1 second to 2.00
  LDelta.ValueAt[LCurrentTime + 1] := 2.00;

  // Verify the value at LCurrentTime + 0.5;
  Assert.IsTrue(LDelta.ValueAt[LCurrentTime + 0.5] = 1.50, Format('Value at %n should be 1.50 but instead got %n', [LCurrentTime + 0.5, LDelta.ValueAt[LCurrentTime + 0.5]]));
end;

end.
