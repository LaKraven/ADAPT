unit ADAPT.UnitTests.Generics.Lists;

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
  TAdaptUnitTestGenericsList = class(TObject)
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
  ADAPT.Common,
  ADAPT.Generics.Defaults.Intf,
  ADAPT.Generics.Lists, ADAPT.Generics.Lists.Intf,
  ADAPT.UnitTests.Generics.Common;

type
  IStringList = IADList<String>;
  TStringList = class(TADList<String>);
//  TStringListTS = class(TADListTS<String>);
  IDummyList = IADList<TDummyObject>;
  TDummyList = class(TADObjectList<TDummyObject>);
//  TDummyListTS = class(TADObjectListTS<TDummyObject>);

{ TAdaptUnitTestGenericsList }

procedure TAdaptUnitTestGenericsList.TestDummyObjectIntegrity;
var
  I: Integer;
  LList: IDummyList;
begin
  LList := TDummyList.Create;
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
    LList.Add(TDummyObject.Create(BASIC_ITEMS[I]));
  for I := 0 to LList.Count - 1 do
    Assert.IsTrue(LList.Items[I].Foo = BASIC_ITEMS[I], Format('Item at Index %d does not match. Expected "%s" but got "%s"', [I, LList.Items[I].Foo, BASIC_ITEMS[I]]));
end;

procedure TAdaptUnitTestGenericsList.TestIntegrity;
var
  I: Integer;
  LList: IStringList;
begin
  LList := TStringList.Create(0);
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
    LList.Add(BASIC_ITEMS[I]);

  for I := 0 to LList.Count - 1 do
    Assert.IsTrue(LList.Items[I] = BASIC_ITEMS[I], Format('Item at Index %d does not match. Expected "%s" but got "%s"', [I, LList.Items[I], BASIC_ITEMS[I]]));
end;

procedure TAdaptUnitTestGenericsList.TestItemInRange(const AIndex: Integer; const AExpectInRange: Boolean);
var
  I: Integer;
  LList: IStringList;
begin
  LList := TStringList.Create(0);
  for I := Low(LETTERS) to High(LETTERS) do
    LList.Add(LETTERS[I]);

  if not (AExpectInRange) then
    Assert.WillRaise(procedure
                     begin
                       LList.Items[AIndex]
                     end,
                     EADGenericsRangeException,
                     Format('Item %d SHOULD be out of range!', [AIndex]))
  else
    Assert.IsTrue(LList.Items[AIndex] = LETTERS[AIndex], Format('Item %d did not match. Expected "%s" but got "%s"', [AIndex, LETTERS[AIndex], LList.Items[AIndex]]))
end;

initialization
  TDUnitX.RegisterTestFixture(TAdaptUnitTestGenericsList);
end.
