unit ADAPT.UnitTests.Generics.Comparers;

interface

{$I ADAPT.inc}

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes, System.SysUtils,
  {$ELSE}
    Classes, SysUtils,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  DUnitX.TestFramework;

type
  [TestFixture]
  TAdaptUnitTestGenericsComparer = class(TObject)
  public
    [Test]
    [TestCase('A = A', 'A,A,True')]
    [TestCase('A <> B', 'A,B,False')]
    [TestCase('B <> A', 'B,A,False')]
    procedure AEqualToB(const AValueA, AValueB: String; const AExpectedResult: Boolean);
    [Test]
    [TestCase('A > A', 'A,A,False')]
    [TestCase('A > B', 'A,B,False')]
    [TestCase('B > A', 'B,A,True')]
    procedure AGreaterThanB(const AValueA, AValueB: String; const AExpectedResult: Boolean);
    [Test]
    [TestCase('A >= A', 'A,A,True')]
    [TestCase('A >= B', 'A,B,False')]
    [TestCase('B >= A', 'B,A,True')]
    procedure AGreaterThanOrEqualToB(const AValueA, AValueB: String; const AExpectedResult: Boolean);
    [Test]
    [TestCase('A < A', 'A,A,False')]
    [TestCase('A < B', 'A,B,True')]
    [TestCase('B < A', 'B,A,False')]
    procedure ALessThanB(const AValueA, AValueB: String; const AExpectedResult: Boolean);
    [Test]
    [TestCase('A <= A', 'A,A,True')]
    [TestCase('A <= B', 'A,B,True')]
    [TestCase('B <= A', 'B,A,False')]
    procedure ALessThanOrEqualToB(const AValueA, AValueB: String; const AExpectedResult: Boolean);
  end;

implementation

uses
  ADAPT.Generics.Comparers;

{ TAdaptUnitTestGenericsComparer }

procedure TAdaptUnitTestGenericsComparer.AEqualToB(const AValueA, AValueB: String; const AExpectedResult: Boolean);
begin
  if AExpectedResult then
    Assert.IsTrue(ADStringComparer.AEqualToB(AValueA, AValueB), Format('ValueA is "%s", ValueB is "%s"... these SHOULD evaluate as Matching, but do not!', [AValueA, AValueB]))
  else
    Assert.IsFalse(ADStringComparer.AEqualToB(AValueA, AValueB), Format('ValueA is "%s", ValueB is "%s"... these SHOULD evaluate as NOT Matching, but evaluate as Matching!', [AValueA, AValueB]))
end;

procedure TAdaptUnitTestGenericsComparer.AGreaterThanB(const AValueA, AValueB: String; const AExpectedResult: Boolean);
begin
  if AExpectedResult then
    Assert.IsTrue(ADStringComparer.AGreaterThanB(AValueA, AValueB), Format('ValueA is "%s", ValueB is "%s"... ValueA SHOULD be GREATER THAN ValueB, but is not!', [AValueA, AValueB]))
  else
    Assert.IsFalse(ADStringComparer.AGreaterThanB(AValueA, AValueB), Format('ValueA is "%s", ValueB is "%s"... ValueB SHOULD be GREATER THAN ValueA, but is not!', [AValueA, AValueB]))
end;

procedure TAdaptUnitTestGenericsComparer.AGreaterThanOrEqualToB(const AValueA, AValueB: String; const AExpectedResult: Boolean);
begin
  if AExpectedResult then
    Assert.IsTrue(ADStringComparer.AGreaterThanOrEqualToB(AValueA, AValueB), Format('ValueA is "%s", ValueB is "%s"... ValueA SHOULD be GREATER THAN OR EQUAL TO ValueB, but is not!', [AValueA, AValueB]))
  else
    Assert.IsFalse(ADStringComparer.AGreaterThanOrEqualToB(AValueA, AValueB), Format('ValueA is "%s", ValueB is "%s"... ValueA should NOT be GREATER THAN OR EQUAL TO ValueB, but is not!', [AValueA, AValueB]))
end;

procedure TAdaptUnitTestGenericsComparer.ALessThanB(const AValueA, AValueB: String; const AExpectedResult: Boolean);
begin
  if AExpectedResult then
    Assert.IsTrue(ADStringComparer.ALessThanB(AValueA, AValueB), Format('ValueA is "%s", ValueB is "%s"... ValueA SHOULD be LESS THAN ValueB, but is not!', [AValueA, AValueB]))
  else
    Assert.IsFalse(ADStringComparer.ALessThanB(AValueA, AValueB), Format('ValueA is "%s", ValueB is "%s"... ValueB SHOULD be LESS THAN ValueA, but is not!', [AValueA, AValueB]))
end;

procedure TAdaptUnitTestGenericsComparer.ALessThanOrEqualToB(const AValueA, AValueB: String; const AExpectedResult: Boolean);
begin
  if AExpectedResult then
    Assert.IsTrue(ADStringComparer.ALessThanOrEqualToB(AValueA, AValueB), Format('ValueA is "%s", ValueB is "%s"... ValueA SHOULD be LESS THAN OR EQUAL TO ValueB, but is not!', [AValueA, AValueB]))
  else
    Assert.IsFalse(ADStringComparer.ALessThanOrEqualToB(AValueA, AValueB), Format('ValueA is "%s", ValueB is "%s"... ValueA should NOT be LESS THAN OR EQUAL TO ValueB, but is not!', [AValueA, AValueB]))
end;

initialization
  TDUnitX.RegisterTestFixture(TAdaptUnitTestGenericsComparer);

end.
