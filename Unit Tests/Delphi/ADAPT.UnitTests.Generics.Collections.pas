unit ADAPT.UnitTests.Generics.Collections;

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
    procedure TestIntegrityThreadsafe;
    [Test]
    [TestCase('In Range at 1', '1,True')]
    [TestCase('Out Of Range at 11', '11,False')]
    [TestCase('In Range at 2', '2,True')]
    [TestCase('Out Of Range at 1337', '1337,False')]
    [TestCase('In Range at 9', '9,True')]
    [TestCase('Out Of Range at 10', '10,False')]
    procedure TestItemInRange(const AIndex: Integer; const AExpectInRange: Boolean);
    [Test]
    [TestCase('In Range at 1', '1,True')]
    [TestCase('Out Of Range at 11', '11,False')]
    [TestCase('In Range at 2', '2,True')]
    [TestCase('Out Of Range at 1337', '1337,False')]
    [TestCase('In Range at 9', '9,True')]
    [TestCase('Out Of Range at 10', '10,False')]
    procedure TestItemInRangeThreadsafe(const AIndex: Integer; const AExpectInRange: Boolean);
    [Test]
    procedure TestDummyObjectIntegrity;
    [Test]
    procedure TestDummyObjectIntegrityThreadsafe;
  end;

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
  ADAPT.Generics.Defaults, ADAPT.Generics.Arrays, ADAPT.Generics.Lists;

type
  TDummyObject = class(TObject)
  private
    FFoo: String;
  public
    constructor Create(const AFoo: String);
    property Foo: String read FFoo;
  end;

  IStringArray = IADArray<String>;
  TStringArray = class(TADArray<String>);
  TStringArrayTS = class(TADArrayTS<String>);
  IDummyArray = IADArray<TDummyObject>;
  TDummyArray = class(TADObjectArray<TDummyObject>);
  TDummyArrayTS = class(TADObjectArrayTS<TDummyObject>);
  IStringList = IADList<String>;
  TStringList = class(TADList<String>);
//  TStringListTS = class(TADListTS<String>);
  IDummyList = IADList<TDummyObject>;
  TDummyList = class(TADObjectList<TDummyObject>);
//  TDummyListTS = class(TADObjectListTS<TDummyObject>);

const
  BASIC_ITEMS: Array[0..9] of String = (
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

  LETTERS: Array[0..9] of String = ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J');

{ TDummyObject }

constructor TDummyObject.Create(const AFoo: String);
begin
  inherited Create;
  FFoo := AFoo;
end;

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
    Assert.IsTrue(LArray.Items[I] = BASIC_ITEMS[I], Format('Item at Index %d does not match. Expected "%s" but got "%s"', [I, LArray.Items[I], BASIC_ITEMS[I]]));
end;

procedure TAdaptUnitTestGenericsArray.TestIntegrityThreadsafe;
var
  I: Integer;
  LArray: IStringArray;
begin
  LArray := TStringArrayTS.Create(10);
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
    LArray.Items[I] := BASIC_ITEMS[I];
  for I := 0 to LArray.Capacity - 1 do
    Assert.IsTrue(LArray.Items[I] = BASIC_ITEMS[I], Format('Item at Index %d does not match. Expected "%s" but got "%s"', [I, LArray.Items[I], BASIC_ITEMS[I]]));
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

procedure TAdaptUnitTestGenericsArray.TestItemInRangeThreadsafe(const AIndex: Integer; const AExpectInRange: Boolean);
var
  I: Integer;
  LArray: IStringArray;
begin
  LArray := TStringArrayTS.Create(10);
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
    Assert.IsTrue(LArray.Items[AIndex] = LETTERS[AIndex], Format('Item %d did not match. Expected "%s" but got "%s"', [AIndex, LETTERS[AIndex], LArray.Items[AIndex]]));
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

procedure TAdaptUnitTestGenericsArray.TestDummyObjectIntegrityThreadsafe;
var
  I: Integer;
  LArray: IDummyArray;
begin
  LArray := TDummyArrayTS.Create(oOwnsObjects, 10);
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
    LArray.Items[I] := TDummyObject.Create(BASIC_ITEMS[I]);
  for I := 0 to LArray.Capacity - 1 do
    Assert.IsTrue(LArray.Items[I].Foo = BASIC_ITEMS[I], Format('Item at Index %d does not match. Expected "%s" but got "%s"', [I, LArray.Items[I].Foo, BASIC_ITEMS[I]]));
end;

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
  TDUnitX.RegisterTestFixture(TAdaptUnitTestGenericsArray);
  TDUnitX.RegisterTestFixture(TAdaptUnitTestGenericsList);
end.
