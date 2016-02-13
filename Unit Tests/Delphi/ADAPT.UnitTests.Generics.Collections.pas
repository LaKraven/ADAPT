unit ADAPT.UnitTests.Generics.Collections;

interface

{$I ADAPT.inc}

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes, System.SysUtils,
  {$ELSE}
    Classes, SysUtils,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Generics.Defaults, ADAPT.Generics.Arrays,
  DUnitX.TestFramework;

type

  [TestFixture]
  TAdaptUnitTestGenericsArray = class(TObject)
  public
    [Test]
    procedure TestIntegrity;
    [Test]
    [TestCase('In Range at 1', '1,True')]
    [TestCase('Out Of Range at 11', '11,False')]
    [TestCase('In Range at 2', '2,True')]
    [TestCase('Out Of Range at 1337', '1337,False')]
    [TestCase('In Range at 9', '9,True')]
    [TestCase('Out Of Range at 10', '10,False')]
    procedure TestItemInRange(const AIndex: Integer; const AExpectInRange: Boolean);
  end;

implementation

{ TAdaptUnitTestGenericsArray }

procedure TAdaptUnitTestGenericsArray.TestIntegrity;
const
  ITEMS: Array[0..9] of String = (
                                  'Bob',
                                  'Terry',
                                  'Andy',
                                  'Rick',
                                  'Sarah',
                                  'Ellen',
                                  'Hugh',
                                  'Jack',
                                  'Marie',
                                  'Ninette'
                                 );
var
  I: Integer;
  LArray: IADArray<String>;
begin
  LArray := TADArray<String>.Create(10);
  for I := Low(ITEMS) to High(ITEMS) do
    LArray.Items[I] := ITEMS[I];
  for I := 0 to LArray.Capacity - 1 do
    Assert.IsTrue(LArray.Items[I] = ITEMS[I], Format('Item at Index %d does not match. Expected "%s" but got "%s"', [I, LArray.Items[I], ITEMS[I]]));
end;

procedure TAdaptUnitTestGenericsArray.TestItemInRange(const AIndex: Integer; const AExpectInRange: Boolean);
const
  ITEMS: Array[0..9] of String = ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J');
var
  I: Integer;
  LArray: IADArray<String>;
begin
  LArray := TADArray<String>.Create(10);
  for I := Low(ITEMS) to High(ITEMS) do
    LArray.Items[I] := ITEMS[I];

  if not (AExpectInRange) then
    Assert.WillRaise(procedure
                     begin
                       LArray.Items[AIndex]
                     end,
                     EADGenericsRangeException,
                     Format('Item %d SHOULD be out of range!', [AIndex]))
  else
    Assert.IsTrue(LArray.Items[AIndex] = ITEMS[AIndex], Format('Item %d did not match. Expected "%s" but got "%s"', [AIndex, ITEMS[AIndex], LArray.Items[AIndex]]))
end;

initialization
  TDUnitX.RegisterTestFixture(TAdaptUnitTestGenericsArray);
end.
