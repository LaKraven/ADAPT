unit ADAPT.UnitTests.Generics.Arrays;

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
    [Test]
    procedure TestDummyObjectIntegrity;
  end;

implementation

uses
  ADAPT.Intf,
  ADAPT,
  ADAPT.Collections, ADAPT.Collections.Intf, ADAPT.Collections.Threadsafe,
  ADAPT.UnitTests.Generics.Common;

type
  IStringArray = IADArray<String>;
  TStringArray = class(TADArray<String>);
  IDummyArray = IADArray<TDummyObject>;
  TDummyArray = class(TADObjectArray<TDummyObject>);

{ TAdaptUnitTestGenericsArray }

procedure TAdaptUnitTestGenericsArray.TestIntegrity;
var
  I: Integer;
  LArray: IStringArray;
begin
  LArray := TStringArray.Create(10);
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
    LArray.Items[I] := BASIC_ITEMS[I];
  for I := 0 to LArray.Capacity - 1 do
    Assert.IsTrue(LArray.Items[I] = BASIC_ITEMS[I], Format('Item at Index %d does not match. Expected "%s" but got "%s"', [I, BASIC_ITEMS[I], LArray.Items[I]]));
end;

procedure TAdaptUnitTestGenericsArray.TestItemInRange(const AIndex: Integer; const AExpectInRange: Boolean);
var
  I: Integer;
  LArray: IStringArray;
begin
  LArray := TStringArray.Create(10);
  for I := Low(LETTERS) to High(LETTERS) do
    LArray.Items[I] := LETTERS[I];

  if not (AExpectInRange) then
    Assert.WillRaise(procedure
                     begin
                       LArray.Items[AIndex]
                     end,
                     EADGenericsRangeException,
                     Format('Item %d SHOULD be out of range!', [AIndex]))
  else
    Assert.IsTrue(LArray.Items[AIndex] = LETTERS[AIndex], Format('Item %d did not match. Expected "%s" but got "%s"', [AIndex, LETTERS[AIndex], LArray.Items[AIndex]]))
end;

procedure TAdaptUnitTestGenericsArray.TestDummyObjectIntegrity;
var
  I: Integer;
  LArray: IDummyArray;
begin
  LArray := TDummyArray.Create(oOwnsObjects, 10);
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
    LArray.Items[I] := TDummyObject.Create(BASIC_ITEMS[I]);
  for I := 0 to LArray.Capacity - 1 do
    Assert.IsTrue(LArray.Items[I].Foo = BASIC_ITEMS[I], Format('Item at Index %d does not match. Expected "%s" but got "%s"', [I, LArray.Items[I].Foo, BASIC_ITEMS[I]]));
end;

initialization
  TDUnitX.RegisterTestFixture(TAdaptUnitTestGenericsArray);

end.
