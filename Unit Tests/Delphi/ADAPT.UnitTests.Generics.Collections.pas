unit ADAPT.UnitTests.Generics.Collections;

interface

{$I ADAPT.inc}

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes, System.SysUtils,
  {$ELSE}
    Classes, SysUtils,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Generics.Defaults, ADAPT.Generics.Arrays, ADAPT.Generics.Lists,
  DUnitX.TestFramework;

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
  IDummyArray = IADObjectArray<TDummyObject>;
  TDummyArray = class(TADObjectArray<TDummyObject>);
  TDummyArrayTS = class(TADObjectArrayTS<TDummyObject>);
  IStringList = IADList<String>;
  TStringList = class(TADList<String>);
//  TStringListTS = class(TADListTS<String>);
//  IDummyList = IADObjectList<TDummyObject>);
//  TDummyList = class(TADObjectList<TDummyObject>);
//  TDummyListTS = class(TADObjectListTS<TDummyObject>);

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
  end;

implementation

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
const
  ITEMS: Array[0..9] of String = ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J');
var
  I: Integer;
  LArray: IStringArray;
begin
  LArray := TStringArray.Create(10);
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

procedure TAdaptUnitTestGenericsArray.TestItemInRangeThreadsafe(const AIndex: Integer; const AExpectInRange: Boolean);
const
  ITEMS: Array[0..9] of String = ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J');
var
  I: Integer;
  LArray: IStringArray;
begin
  LArray := TStringArrayTS.Create(10);
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
    Assert.IsTrue(LArray.Items[AIndex] = ITEMS[AIndex], Format('Item %d did not match. Expected "%s" but got "%s"', [AIndex, ITEMS[AIndex], LArray.Items[AIndex]]));
end;

procedure TAdaptUnitTestGenericsArray.TestDummyObjectIntegrity;
var
  I: Integer;
  LArray: IDummyArray;
begin
  LArray := TDummyArray.Create(True, 10);
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
  LArray := TDummyArrayTS.Create(True, 10);
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
    LArray.Items[I] := TDummyObject.Create(BASIC_ITEMS[I]);
  for I := 0 to LArray.Capacity - 1 do
    Assert.IsTrue(LArray.Items[I].Foo = BASIC_ITEMS[I], Format('Item at Index %d does not match. Expected "%s" but got "%s"', [I, LArray.Items[I].Foo, BASIC_ITEMS[I]]));
end;

{ TAdaptUnitTestGenericsList }

procedure TAdaptUnitTestGenericsList.TestIntegrity;
var
  I: Integer;
  LList: IStringList;
begin
  LList := TStringList.Create(10);
//  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
//    LList.Items[I] := BASIC_ITEMS[I];
end;

initialization
  TDUnitX.RegisterTestFixture(TAdaptUnitTestGenericsArray);
  TDUnitX.RegisterTestFixture(TAdaptUnitTestGenericsList);
end.
