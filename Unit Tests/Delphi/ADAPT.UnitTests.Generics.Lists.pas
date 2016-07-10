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
    procedure BasicIntegrity;
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

  [TestFixture]
  TAdaptUnitTestGenericsCircularList = class(TObject)
  public
    [Test]
    procedure BasicIntegrity;
    [Test]
    procedure BasicIteratorIntegrityNewestToOldest;
    [Test]
    procedure BasicIteratorIntegrityOldestToNewest;
    [Test]
    procedure CircularIntegrity;
    [Test]
    procedure CircularIteratorIntegrityNewestToOldest;
    [Test]
    procedure CircularIteratorIntegrityOldestToNewest;
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
  IDummyList = IADList<TDummyObject>;
  TDummyList = class(TADObjectList<TDummyObject>);
  ICircularStringList = IADCircularList<String>;
  TCircularStringList = TADCircularList<String>;

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
    Assert.IsTrue(LList.Items[I].Foo = BASIC_ITEMS[I], Format('Item at Index %d does not match. Expected "%s" but got "%s"', [I, BASIC_ITEMS[I], LList.Items[I].Foo]));
end;

procedure TAdaptUnitTestGenericsList.BasicIntegrity;
var
  I: Integer;
  LList: IStringList;
begin
  LList := TStringList.Create(0);
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
    LList.Add(BASIC_ITEMS[I]);

  for I := 0 to LList.Count - 1 do
    Assert.IsTrue(LList.Items[I] = BASIC_ITEMS[I], Format('Item at Index %d does not match. Expected "%s" but got "%s"', [I, BASIC_ITEMS[I], LList.Items[I]]));
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

{ TAdaptUnitTestGenericsCircularList }

procedure TAdaptUnitTestGenericsCircularList.BasicIntegrity;
var
  I: Integer;
  LList: ICircularStringList;
begin
  LList := TCircularStringList.Create(Length(BASIC_ITEMS));
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
    LList.Add(BASIC_ITEMS[I]);

  for I := 0 to LList.Count - 1 do
    Assert.IsTrue(LList.Items[I] = BASIC_ITEMS[I], Format('Item at Index %d does not match. Expected "%s" but got "%s"', [I, BASIC_ITEMS[I], LList.Items[I]]));
end;

procedure TAdaptUnitTestGenericsCircularList.BasicIteratorIntegrityNewestToOldest;
var
  I: Integer;
  LList: ICircularStringList;
begin
  LList := TCircularStringList.Create(Length(BASIC_ITEMS));
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
    LList.Add(BASIC_ITEMS[I]);

  I := High(BASIC_ITEMS);

  LList.IterateNewestToOldest(procedure(const AItem: String)
                              begin
                                Assert.IsTrue(AItem = BASIC_ITEMS[I], Format('Item at Index %d does not match. Expected "%s" but got "%s"', [I, BASIC_ITEMS[I], AItem]));
                                Dec(I);
                              end);

  Assert.IsTrue(I = -1, Format('Iterator should have Index of -1 but instead shows Index of %d', [I]));
end;

procedure TAdaptUnitTestGenericsCircularList.BasicIteratorIntegrityOldestToNewest;
var
  I: Integer;
  LList: ICircularStringList;
begin
  LList := TCircularStringList.Create(Length(BASIC_ITEMS));
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
    LList.Add(BASIC_ITEMS[I]);

  I := 0;

  LList.IterateOldestToNewest(procedure(const AItem: String)
                              begin
                                Assert.IsTrue(AItem = BASIC_ITEMS[I], Format('Item at Index %d does not match. Expected "%s" but got "%s"', [I, BASIC_ITEMS[I], AItem]));
                                Inc(I);
                              end);

  Assert.IsTrue(I = Length(BASIC_ITEMS), Format('Iterator should have Index of %d but instead shows Index of %d', [Length(BASIC_ITEMS), I]));
end;

procedure TAdaptUnitTestGenericsCircularList.CircularIntegrity;
begin

end;

procedure TAdaptUnitTestGenericsCircularList.CircularIteratorIntegrityNewestToOldest;
const
  MAX_CAPACITY: Integer = Length(BASIC_ITEMS) div 2;
var
  I: Integer;
  LList: ICircularStringList;
begin
  LList := TCircularStringList.Create(MAX_CAPACITY);
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
    LList.Add(BASIC_ITEMS[I]);

  I := MAX_CAPACITY;

  LList.IterateNewestToOldest(procedure(const AItem: String)
                              begin
                                Assert.IsTrue(AItem = BASIC_ITEMS[I + MAX_CAPACITY - 1], Format('Item at Index %d does not match. Expected "%s" but got "%s"', [I, BASIC_ITEMS[I + MAX_CAPACITY - 1], AItem]));
                                Dec(I);
                              end);

  Assert.IsTrue(I = 0, Format('Iterator should have Index of 0 but instead shows Index of %d', [I]));
end;

procedure TAdaptUnitTestGenericsCircularList.CircularIteratorIntegrityOldestToNewest;
const
  MAX_CAPACITY: Integer = Length(BASIC_ITEMS) div 2;
var
  I: Integer;
  LList: ICircularStringList;
begin
  LList := TCircularStringList.Create(MAX_CAPACITY);
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
    LList.Add(BASIC_ITEMS[I]);

  I := 0;

  LList.IterateOldestToNewest(procedure(const AItem: String)
                              begin
                                Assert.IsTrue(AItem = BASIC_ITEMS[I + MAX_CAPACITY], Format('Item at Index %d does not match. Expected "%s" but got "%s"', [I, BASIC_ITEMS[I + MAX_CAPACITY], AItem]));
                                Inc(I);
                              end);

  Assert.IsTrue(I = MAX_CAPACITY, Format('Iterator should have Index of %d but instead shows Index of %d', [MAX_CAPACITY, I]));
end;

initialization
  TDUnitX.RegisterTestFixture(TAdaptUnitTestGenericsList);
  TDUnitX.RegisterTestFixture(TAdaptUnitTestGenericsCircularList);
end.
