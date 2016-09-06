unit ADAPT.UnitTests.Maths.Averagers;

interface

{$I ADAPT.inc}

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes, System.SysUtils,
  {$ELSE}
    Classes, SysUtils,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  DUnitX.TestFramework,
  ADAPT.Common,
  ADAPT.Generics.Collections.Intf,
  ADAPT.Math.Averagers.Intf;

type
  [TestFixture]
  TAdaptUnitTestMathAveragerFloatMean = class(TObject)
  public
    [Test]
    procedure TestAverageFromSortedList;
  end;

  [TestFixture]
  TAdaptUnitTestMathAveragerFloatMedian = class(TObject)
  public
    [Test]
    procedure TestAverageFromSortedList;
  end;

  [TestFixture]
  TAdaptUnitTestMathAveragerFloatRange = class(TObject)
  public
    [Test]
    procedure TestAverageFromSortedList;
  end;

  [TestFixture]
  TAdaptUnitTestMathAveragerIntegerMean = class(TObject)
  public
    [Test]
    procedure TestAverageFromSortedList;
  end;

  [TestFixture]
  TAdaptUnitTestMathAveragerIntegerMedian = class(TObject)
  public
    [Test]
    procedure TestAverageFromSortedList;
  end;

  [TestFixture]
  TAdaptUnitTestMathAveragerIntegerRange = class(TObject)
  public
    [Test]
    procedure TestAverageFromSortedList;
  end;

implementation

uses
  ADAPT.Generics.Collections,
  ADAPT.Generics.Comparers,
  ADAPT.Math.Common,
  ADAPT.Math.Averagers;

{ TAdaptUnitTestMathAveragerFloatMean }

procedure TAdaptUnitTestMathAveragerFloatMean.TestAverageFromSortedList;
var
  LSeries: IADSortedList<ADFloat>;
  LAverage: ADFloat;
begin
  LSeries := TADSortedList<ADFloat>.Create(ADFloatComparer);
  LSeries.AddItems([1.00, 2.00, 3.00, 4.00, 5.00, 6.00, 7.00, 8.00, 9.00, 10.00]);

  LAverage := ADAveragerFloatMean.CalculateAverage(LSeries);

  Assert.IsTrue(LAverage = 5.5, Format('Expected Average of 5.5, got %n.', [LAverage]));
end;

{ TAdaptUnitTestMathAveragerFloatMedian }

procedure TAdaptUnitTestMathAveragerFloatMedian.TestAverageFromSortedList;
var
  LSeries: IADSortedList<ADFloat>;
  LAverage: ADFloat;
begin
  LSeries := TADSortedList<ADFloat>.Create(ADFloatComparer);
  LSeries.AddItems([1.00, 2.00, 3.00, 4.00, 5.00, 6.00, 7.00, 8.00, 9.00, 10.00]);

  LAverage := ADAveragerFloatMedian.CalculateAverage(LSeries);

  Assert.IsTrue(LAverage = 5.00, Format('Expected Average of 5.00, got %n.', [LAverage]));
end;

{ TAdaptUnitTestMathAveragerFloatRange }

procedure TAdaptUnitTestMathAveragerFloatRange.TestAverageFromSortedList;
var
  LSeries: IADSortedList<ADFloat>;
  LAverage: ADFloat;
begin
  LSeries := TADSortedList<ADFloat>.Create(ADFloatComparer);
  LSeries.AddItems([1.00, 2.00, 3.00, 4.00, 5.00, 6.00, 7.00, 8.00, 9.00, 10.00]);

  LAverage := ADAveragerFloatRange.CalculateAverage(LSeries);

  Assert.IsTrue(LAverage = 9.00, Format('Expected Average of 9.00, got %n.', [LAverage]));
end;

{ TAdaptUnitTestMathAveragerIntegerMean }

procedure TAdaptUnitTestMathAveragerIntegerMean.TestAverageFromSortedList;
var
  LSeries: IADSortedList<Integer>;
  LAverage: Integer;
begin
  LSeries := TADSortedList<Integer>.Create(ADIntegerComparer);
  LSeries.AddItems([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);

  LAverage := ADAveragerIntegerMean.CalculateAverage(LSeries);

  Assert.IsTrue(LAverage = 5, Format('Expected Average of 5, got %d.', [LAverage]));
end;

{ TAdaptUnitTestMathAveragerIntegerMedian }

procedure TAdaptUnitTestMathAveragerIntegerMedian.TestAverageFromSortedList;
var
  LSeries: IADSortedList<Integer>;
  LAverage: Integer;
begin
  LSeries := TADSortedList<Integer>.Create(ADIntegerComparer);
  LSeries.AddItems([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);

  LAverage := ADAveragerIntegerMedian.CalculateAverage(LSeries);

  Assert.IsTrue(LAverage = 5, Format('Expected Average of 5, got %d.', [LAverage]));
end;

{ TAdaptUnitTestMathAveragerIntegerRange }

procedure TAdaptUnitTestMathAveragerIntegerRange.TestAverageFromSortedList;
var
  LSeries: IADSortedList<Integer>;
  LAverage: Integer;
begin
  LSeries := TADSortedList<Integer>.Create(ADIntegerComparer);
  LSeries.AddItems([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);

  LAverage := ADAveragerIntegerRange.CalculateAverage(LSeries);

  Assert.IsTrue(LAverage = 9, Format('Expected Average of 9, got %d.', [LAverage]));
end;

end.
