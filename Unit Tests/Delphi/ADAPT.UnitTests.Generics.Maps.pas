unit ADAPT.UnitTests.Generics.Maps;

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
  TAdaptUnitTestGenericsSortedList_String = class(TObject)
  public
    [Test]
    procedure Add;
    [Test]
    procedure AddItems_FromArray;
    [Test]
    procedure AddItems_FromSortedList;
    [Test]
    procedure Compact;
    [Test]
    procedure Contains;
    [Test]
    procedure ContainsAll;
    [Test]
    procedure ContainsAny;
    [Test]
    procedure ContainsNone;
    [Test]
    procedure Delete;
    [Test]
    procedure IndexOf_PreOrdered;
    [Test]
    procedure IndexOf_Unordered;
  end;

  [TestFixture]
  TAdaptUnitTestGenericsSortedList_Integer = class(TObject)
  public
    [Test]
    procedure Add;
    [Test]
    procedure AddItems_FromArray;
    [Test]
    procedure AddItems_FromSortedList;
    [Test]
    procedure Compact;
    [Test]
    procedure Contains;
    [Test]
    procedure ContainsAll;
    [Test]
    procedure ContainsAny;
    [Test]
    procedure ContainsNone;
    [Test]
    procedure Delete;
    [Test]
    procedure IndexOf_PreOrdered;
    [Test]
    procedure IndexOf_Unordered;
  end;

implementation

uses
  ADAPT.Generics.Maps.Intf, ADAPT.Generics.Maps,
  ADAPT.Generics.Comparers,
  ADAPT.UnitTests.Generics.Common;

type
  IIntegerSortedList = IADSortedList<Integer>;
  IStringSortedList = IADSortedList<String>;
  TIntegerSortedList = TADSortedList<Integer>;
  TStringSortedList = class(TADSortedList<String>);

{ TAdaptUnitTestGenericsSortedList }

procedure TAdaptUnitTestGenericsSortedList_String.Add;
var
  LList: IStringSortedList;
  LIndex: Integer;
begin
  LList := TStringSortedList.Create(ADStringComparer, 1);
  LIndex := LList.Add('Foo');
  Assert.IsTrue(LIndex = 0, Format('Item SHOULD have been Added at Index 0, instead was added at Index %d.', [LIndex]));
  Assert.IsTrue(LList.Count = 1, Format('List SHOULD contain 1 Item, instead contains %d.', [LList.Count]));
  Assert.IsTrue(LList[0] = 'Foo', Format('List Item 0 should be "Foo", is instead "%s".', [LList[0]]));
end;

procedure TAdaptUnitTestGenericsSortedList_String.AddItems_FromArray;
var
  LList: IStringSortedList;
begin
  LList := TStringSortedList.Create(ADStringComparer, 10);
  LList.AddItems(BASIC_ITEMS);

  Assert.IsTrue(LList.Count = Length(BASIC_ITEMS), Format('List SHOULD contain %d Item, instead contains %d.', [Length(BASIC_ITEMS), LList.Count]));
  Assert.IsTrue(LList[0] = 'Andy', Format('List Item 0 should be "Andy", is instead "%s".', [LList[0]]));
end;

procedure TAdaptUnitTestGenericsSortedList_String.AddItems_FromSortedList;
var
  LListOrigin, LListDestination: IStringSortedList;
begin
  LListOrigin := TStringSortedList.Create(ADStringComparer, 10);
  LListOrigin.AddItems(BASIC_ITEMS);

  LListDestination := TStringSortedList.Create(ADStringComparer, LListOrigin.Count);
  LListDestination.AddItems(LListOrigin);

  Assert.IsTrue(LListDestination.Count = Length(BASIC_ITEMS), Format('List SHOULD contain %d Item, instead contains %d.', [Length(BASIC_ITEMS), LListDestination.Count]));
  Assert.IsTrue(LListDestination[0] = 'Andy', Format('List Item 0 should be "Andy", is instead "%s".', [LListDestination[0]]));
end;

procedure TAdaptUnitTestGenericsSortedList_String.Compact;
var
  LList: IStringSortedList;
begin
  LList := TStringSortedList.Create(ADStringComparer, 1000);
  Assert.IsFalse(LList.IsCompact, 'List should NOT be Compact yet!');
  LList.AddItems(BASIC_ITEMS);
  Assert.IsFalse(LList.IsCompact, 'List should NOT be Compact yet!');
  LList.Compact;
  Assert.IsTrue(LList.Count = Length(BASIC_ITEMS), Format('List SHOULD contain %d Item, instead contains %d.', [Length(BASIC_ITEMS), LList.Count]));
  Assert.IsTrue(LList.IsCompact, 'List SHOULD be Compact, but is not!');
end;

procedure TAdaptUnitTestGenericsSortedList_String.Contains;
var
  LList: IStringSortedList;
begin
  LList := TStringSortedList.Create(ADStringComparer, 10);
  LList.AddItems(BASIC_ITEMS);

  Assert.IsTrue(LList.Contains(BASIC_ITEMS[0]), Format('List does not contain Item "%s".', [BASIC_ITEMS[0]]));
end;

procedure TAdaptUnitTestGenericsSortedList_String.ContainsAll;
var
  LList: IStringSortedList;
begin
  LList := TStringSortedList.Create(ADStringComparer, 10);
  LList.AddItems(BASIC_ITEMS);

  Assert.IsTrue(LList.ContainsAll(BASIC_ITEMS), 'List does not contain ALL source Items.');
end;

procedure TAdaptUnitTestGenericsSortedList_String.ContainsAny;
var
  LList: IStringSortedList;
begin
  LList := TStringSortedList.Create(ADStringComparer, 10);
  LList.AddItems(BASIC_ITEMS);

  Assert.IsTrue(LList.ContainsAny(['A', 'B', 'C', 'D', 'Bob']), 'List DOES NOT contain ANY source Items.');
  Assert.IsFalse(LList.ContainsAny(['A', 'B', 'C', 'D', 'E']), 'List SHOULD NOT contain ANY source Items, but does.');
end;

procedure TAdaptUnitTestGenericsSortedList_String.ContainsNone;
var
  LList: IStringSortedList;
begin
  LList := TStringSortedList.Create(ADStringComparer, 10);
  LList.AddItems(BASIC_ITEMS);
  Assert.IsTrue(LList.ContainsNone(['A', 'B', 'C', 'D', 'E', 'F']), 'List SHOULD NOT contain ANY source Items, but does.');
  Assert.IsFalse(LList.ContainsNone(['A', 'B', 'C', 'D', 'Bob']), 'List contains at least one source Item, but claims not to.');
end;

procedure TAdaptUnitTestGenericsSortedList_String.Delete;
var
  LList: IStringSortedList;
begin
  LList := TStringSortedList.Create(ADStringComparer, 10);
  LList.AddItems(NAMES_IN_ORDER);

  Assert.IsTrue(SizeOf(String) = 4, Format('Size of String is %d', [SizeOf(String)]));

  LList.Delete(3);

  // Verify Count
  Assert.IsTrue(LList.Count = Length(NAMES_IN_ORDER) - 1, Format('List SHOULD contain %d Items, instead contains %d.', [Length(NAMES_IN_ORDER) - 1, LList.Count]));
  // Verify "Hugh" no longer in List.
  Assert.IsFalse(LList.Contains('Hugh'), 'List should NOT contain Item "Hugh", but does!');
  // Verify Integrity of remaining Items...
  Assert.IsTrue(LList[0] = 'Andy', Format('List Item 0 should be "Andy", is instead "%s".', [LList[0]]));
  Assert.IsTrue(LList[1] = 'Bob', Format('List Item 1 should be "Bob", is instead "%s".', [LList[1]]));
  Assert.IsTrue(LList[2] = 'Ellen', Format('List Item 2 should be "Ellen", is instead "%s".', [LList[2]]));
  Assert.IsTrue(LList[3] = 'Jack', Format('List Item 3 should be "Jack", is instead "%s".', [LList[3]]));
  Assert.IsTrue(LList[4] = 'Marie', Format('List Item 4 should be "Marie", is instead "%s".', [LList[4]]));
  Assert.IsTrue(LList[5] = 'Ninette', Format('List Item 5 should be "Ninette", is instead "%s".', [LList[5]]));
  Assert.IsTrue(LList[6] = 'Rick', Format('List Item 6 should be "Rick", is instead "%s".', [LList[6]]));
  Assert.IsTrue(LList[7] = 'Sarah', Format('List Item 7 should be "Sarah", is instead "%s".', [LList[7]]));
  Assert.IsTrue(LList[8] = 'Terry', Format('List Item 8 should be "Terry", is instead "%s".', [LList[8]]));
end;

procedure TAdaptUnitTestGenericsSortedList_String.IndexOf_PreOrdered;
var
  LSortedList: IStringSortedList;
begin
  LSortedList := TStringSortedList.Create(ADStringComparer, 10);
  LSortedList.AddItems(NAMES_IN_ORDER);
  Assert.IsTrue(LSortedList.IndexOf('Andy') = 0, Format('Index 0 should be "Andy", got instead "%s"', [LSortedList[0]]));
  Assert.IsTrue(LSortedList.IndexOf('Bob') = 1, Format('Index 1 should be "Bob", got instead "%s"', [LSortedList[1]]));
  Assert.IsTrue(LSortedList.IndexOf('Ellen') = 2, Format('Index 2 should be "Ellen", got instead "%s"', [LSortedList[2]]));
  Assert.IsTrue(LSortedList.IndexOf('Hugh') = 3, Format('Index 3 should be "Hugh", got instead "%s"', [LSortedList[3]]));
  Assert.IsTrue(LSortedList.IndexOf('Jack') = 4, Format('Index 4 should be "Jack", got instead "%s"', [LSortedList[4]]));
  Assert.IsTrue(LSortedList.IndexOf('Marie') = 5, Format('Index 5 should be "Marie", got instead "%s"', [LSortedList[5]]));
  Assert.IsTrue(LSortedList.IndexOf('Ninette') = 6, Format('Index 6 should be "Ninette", got instead "%s"', [LSortedList[6]]));
  Assert.IsTrue(LSortedList.IndexOf('Rick') = 7, Format('Index 7 should be "Rick", got instead "%s"', [LSortedList[7]]));
  Assert.IsTrue(LSortedList.IndexOf('Sarah') = 8, Format('Index 8 should be "Sarah", got instead "%s"', [LSortedList[8]]));
  Assert.IsTrue(LSortedList.IndexOf('Terry') = 9, Format('Index 9 should be "Terry", got instead "%s"', [LSortedList[9]]));
end;

procedure TAdaptUnitTestGenericsSortedList_String.IndexOf_Unordered;
const
  NAMES_OUT_OF_ORDER: Array[0..9] of String = ('Hugh', 'Andy', 'Ellen', 'Jack', 'Marie', 'Bob', 'Ninette', 'Rick', 'Terry', 'Sarah');
var
  LSortedList: IStringSortedList;
begin
  LSortedList := TStringSortedList.Create(ADStringComparer, 10);
  LSortedList.AddItems(NAMES_OUT_OF_ORDER);
  Assert.IsTrue(LSortedList.IndexOf('Andy') = 0, Format('Index of "Andy" should be 0, got instead "%d"', [LSortedList.IndexOf('Andy')]));
  Assert.IsTrue(LSortedList.IndexOf('Bob') = 1, Format('Index of "Bob" should be 1, got instead "%d"', [LSortedList.IndexOf('Bob')]));
  Assert.IsTrue(LSortedList.IndexOf('Ellen') = 2, Format('Index of "Ellen" should be 2, got instead "%d"', [LSortedList.IndexOf('Ellen')]));
  Assert.IsTrue(LSortedList.IndexOf('Hugh') = 3, Format('Index of "Hugh" should be 3, got instead "%d"', [LSortedList.IndexOf('Hugh')]));
  Assert.IsTrue(LSortedList.IndexOf('Jack') = 4, Format('Index of "Jack" should be 4, got instead "%d"', [LSortedList.IndexOf('Jack')]));
  Assert.IsTrue(LSortedList.IndexOf('Marie') = 5, Format('Index of "Marie" should be 5, got instead "%d"', [LSortedList.IndexOf('Marie')]));
  Assert.IsTrue(LSortedList.IndexOf('Ninette') = 6, Format('Index of "Ninette" should be 6, got instead "%d"', [LSortedList.IndexOf('Ninette')]));
  Assert.IsTrue(LSortedList.IndexOf('Rick') = 7, Format('Index of "Rick" should be 7, got instead "%d"', [LSortedList.IndexOf('Rick')]));
  Assert.IsTrue(LSortedList.IndexOf('Sarah') = 8, Format('Index of "Sarah" should be 8, got instead "%d"', [LSortedList.IndexOf('Sarah')]));
  Assert.IsTrue(LSortedList.IndexOf('Terry') = 9, Format('Index of "Terry" should be 9, got instead "%d"', [LSortedList.IndexOf('Terry')]));
end;

{ TAdaptUnitTestGenericsSortedList_Integer }

procedure TAdaptUnitTestGenericsSortedList_Integer.Add;
var
  LList: IIntegerSortedList;
  LIndex: Integer;
begin
  LList := TIntegerSortedList.Create(ADIntegerComparer, 1);
  LIndex := LList.Add(1337);
  Assert.IsTrue(LIndex = 0, Format('Item SHOULD have been Added at Index 0, instead was added at Index %d.', [LIndex]));
  Assert.IsTrue(LList.Count = 1, Format('List SHOULD contain 1 Item, instead contains %d.', [LList.Count]));
  Assert.IsTrue(LList[0] = 1337, Format('List Item 0 should be "1337", is instead "%d".', [LList[0]]));
end;

procedure TAdaptUnitTestGenericsSortedList_Integer.AddItems_FromArray;
var
  LList: IIntegerSortedList;
begin
  LList := TIntegerSortedList.Create(ADIntegerComparer, 10);
  LList.AddItems(BASIC_INTEGER_ITEMS);

  Assert.IsTrue(LList.Count = Length(BASIC_INTEGER_ITEMS), Format('List SHOULD contain %d Item, instead contains %d.', [Length(BASIC_INTEGER_ITEMS), LList.Count]));
  Assert.IsTrue(LList[0] = 1, Format('List Item 0 should be "1", is instead "%d".', [LList[0]]));
end;

procedure TAdaptUnitTestGenericsSortedList_Integer.AddItems_FromSortedList;
var
  LListOrigin, LListDestination: IIntegerSortedList;
begin
  LListOrigin := TIntegerSortedList.Create(ADIntegerComparer, 10);
  LListOrigin.AddItems(BASIC_INTEGER_ITEMS);

  LListDestination := TIntegerSortedList.Create(ADIntegerComparer, LListOrigin.Count);
  LListDestination.AddItems(LListOrigin);

  Assert.IsTrue(LListDestination.Count = Length(BASIC_INTEGER_ITEMS), Format('List SHOULD contain %d Item, instead contains %d.', [Length(BASIC_INTEGER_ITEMS), LListDestination.Count]));
  Assert.IsTrue(LListDestination[0] = 1, Format('List Item 0 should be "1", is instead "%d.', [LListDestination[0]]));
end;

procedure TAdaptUnitTestGenericsSortedList_Integer.Compact;
var
  LList: IIntegerSortedList;
begin
  LList := TIntegerSortedList.Create(ADIntegerComparer, 1000);
  Assert.IsFalse(LList.IsCompact, 'List should NOT be Compact yet!');
  LList.AddItems(BASIC_INTEGER_ITEMS);
  Assert.IsFalse(LList.IsCompact, 'List should NOT be Compact yet!');
  LList.Compact;
  Assert.IsTrue(LList.Count = Length(BASIC_INTEGER_ITEMS), Format('List SHOULD contain %d Item, instead contains %d.', [Length(BASIC_INTEGER_ITEMS), LList.Count]));
  Assert.IsTrue(LList.IsCompact, 'List SHOULD be Compact, but is not!');
end;

procedure TAdaptUnitTestGenericsSortedList_Integer.Contains;
var
  LList: IIntegerSortedList;
begin
  LList := TIntegerSortedList.Create(ADIntegerComparer, 10);
  LList.AddItems(BASIC_INTEGER_ITEMS);

  Assert.IsTrue(LList.Contains(BASIC_INTEGER_ITEMS[0]), Format('List does not contain Item "%d".', [BASIC_INTEGER_ITEMS[0]]));
end;

procedure TAdaptUnitTestGenericsSortedList_Integer.ContainsAll;
var
  LList: IIntegerSortedList;
begin
  LList := TIntegerSortedList.Create(ADIntegerComparer, 10);
  LList.AddItems(BASIC_INTEGER_ITEMS);

  Assert.IsTrue(LList.ContainsAll(BASIC_INTEGER_ITEMS), 'List does not contain ALL source Items.');
end;

procedure TAdaptUnitTestGenericsSortedList_Integer.ContainsAny;
var
  LList: IIntegerSortedList;
begin
  LList := TIntegerSortedList.Create(ADIntegerComparer, 10);
  LList.AddItems(BASIC_INTEGER_ITEMS);

  Assert.IsTrue(LList.ContainsAny([98, 86, 411, 1, 17]), 'List DOES NOT contain ANY source Items.');
  Assert.IsFalse(LList.ContainsAny([66, 77, 88, 99, 101]), 'List SHOULD NOT contain ANY source Items, but does.');
end;

procedure TAdaptUnitTestGenericsSortedList_Integer.ContainsNone;
var
  LList: IIntegerSortedList;
begin
  LList := TIntegerSortedList.Create(ADIntegerComparer, 10);
  LList.AddItems(BASIC_INTEGER_ITEMS);
  Assert.IsTrue(LList.ContainsNone([66, 77, 88, 99, 101]), 'List SHOULD NOT contain ANY source Items, but does.');
  Assert.IsFalse(LList.ContainsNone([98, 86, 411, 1, 17]), 'List contains at least one source Item, but claims not to.');
end;

procedure TAdaptUnitTestGenericsSortedList_Integer.Delete;
var
  LList: IIntegerSortedList;
begin
  LList := TIntegerSortedList.Create(ADIntegerComparer, 10);
  LList.AddItems(NUMBERS_IN_ORDER);

  LList.Delete(3);

  // Verify Count
  Assert.IsTrue(LList.Count = Length(NUMBERS_IN_ORDER) - 1, Format('List SHOULD contain %d Items, instead contains %d.', [Length(NUMBERS_IN_ORDER) - 1, LList.Count]));
  // Verify "Hugh" no longer in List.
  Assert.IsFalse(LList.Contains(20), 'List should NOT contain Item 20, but does!');
  // Verify Integrity of remaining Items...

{
1, 2, 10, 21, 30, 55, 666, 1337, 9001
}
  Assert.IsTrue(LList[0] = 1, Format('List Item 0 should be "1", is instead "%d".', [LList[0]]));
  Assert.IsTrue(LList[1] = 2, Format('List Item 1 should be "2", is instead "%d".', [LList[1]]));
  Assert.IsTrue(LList[2] = 10, Format('List Item 2 should be "10", is instead "%d".', [LList[2]]));
  Assert.IsTrue(LList[3] = 21, Format('List Item 3 should be "21", is instead "%d".', [LList[3]]));
  Assert.IsTrue(LList[4] = 30, Format('List Item 4 should be "30", is instead "%d".', [LList[4]]));
  Assert.IsTrue(LList[5] = 55, Format('List Item 5 should be "55", is instead "%d".', [LList[5]]));
  Assert.IsTrue(LList[6] = 666, Format('List Item 6 should be "666", is instead "%d".', [LList[6]]));
  Assert.IsTrue(LList[7] = 1337, Format('List Item 7 should be "1337", is instead "%d".', [LList[7]]));
  Assert.IsTrue(LList[8] = 9001, Format('List Item 8 should be "9001", is instead "%d".', [LList[8]]));
end;

procedure TAdaptUnitTestGenericsSortedList_Integer.IndexOf_PreOrdered;
var
  LSortedList: IIntegerSortedList;
begin
  LSortedList := TIntegerSortedList.Create(ADIntegerComparer, 10);
  LSortedList.AddItems(NUMBERS_IN_ORDER);
  Assert.IsTrue(LSortedList.IndexOf(1) = 0, Format('Index 0 should be "1", got instead "%d"', [LSortedList[0]]));
  Assert.IsTrue(LSortedList.IndexOf(2) = 1, Format('Index 1 should be "2", got instead "%d"', [LSortedList[1]]));
  Assert.IsTrue(LSortedList.IndexOf(10) = 2, Format('Index 2 should be "10", got instead "%d"', [LSortedList[2]]));
  Assert.IsTrue(LSortedList.IndexOf(20) = 3, Format('Index 3 should be "20", got instead "%d"', [LSortedList[3]]));
  Assert.IsTrue(LSortedList.IndexOf(21) = 4, Format('Index 4 should be "21", got instead "%d"', [LSortedList[4]]));
  Assert.IsTrue(LSortedList.IndexOf(30) = 5, Format('Index 5 should be "30", got instead "%d"', [LSortedList[5]]));
  Assert.IsTrue(LSortedList.IndexOf(55) = 6, Format('Index 6 should be "55", got instead "%d"', [LSortedList[6]]));
  Assert.IsTrue(LSortedList.IndexOf(666) = 7, Format('Index 7 should be "666", got instead "%d"', [LSortedList[7]]));
  Assert.IsTrue(LSortedList.IndexOf(1337) = 8, Format('Index 8 should be "1337", got instead "%d"', [LSortedList[8]]));
  Assert.IsTrue(LSortedList.IndexOf(9001) = 9, Format('Index 9 should be "9001", got instead "%d"', [LSortedList[9]]));
end;

procedure TAdaptUnitTestGenericsSortedList_Integer.IndexOf_Unordered;
const
  NUMBERS_OUT_OF_ORDER: Array[0..9] of Integer = (1337, 9001, 10, 1, 20, 2, 21, 30, 55, 666);
var
  LSortedList: IIntegerSortedList;
begin
  LSortedList := TIntegerSortedList.Create(ADIntegerComparer, 10);
  LSortedList.AddItems(NUMBERS_OUT_OF_ORDER);
  Assert.IsTrue(LSortedList.IndexOf(1) = 0, Format('Index 0 should be "1", got instead "%d"', [LSortedList[0]]));
  Assert.IsTrue(LSortedList.IndexOf(2) = 1, Format('Index 1 should be "2", got instead "%d"', [LSortedList[1]]));
  Assert.IsTrue(LSortedList.IndexOf(10) = 2, Format('Index 2 should be "10", got instead "%d"', [LSortedList[2]]));
  Assert.IsTrue(LSortedList.IndexOf(20) = 3, Format('Index 3 should be "20", got instead "%d"', [LSortedList[3]]));
  Assert.IsTrue(LSortedList.IndexOf(21) = 4, Format('Index 4 should be "21", got instead "%d"', [LSortedList[4]]));
  Assert.IsTrue(LSortedList.IndexOf(30) = 5, Format('Index 5 should be "30", got instead "%d"', [LSortedList[5]]));
  Assert.IsTrue(LSortedList.IndexOf(55) = 6, Format('Index 6 should be "55", got instead "%d"', [LSortedList[6]]));
  Assert.IsTrue(LSortedList.IndexOf(666) = 7, Format('Index 7 should be "666", got instead "%d"', [LSortedList[7]]));
  Assert.IsTrue(LSortedList.IndexOf(1337) = 8, Format('Index 8 should be "1337", got instead "%d"', [LSortedList[8]]));
  Assert.IsTrue(LSortedList.IndexOf(9001) = 9, Format('Index 9 should be "9001", got instead "%d"', [LSortedList[9]]));
end;

initialization
  TDUnitX.RegisterTestFixture(TAdaptUnitTestGenericsSortedList_String);
  TDUnitX.RegisterTestFixture(TAdaptUnitTestGenericsSortedList_Integer);
end.
