unit ADAPT.UnitTests.Generics.Lists;

interface

{$I ADAPT.inc}

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes, System.SysUtils,
  {$ELSE}
    Classes, SysUtils,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  DUnitX.TestFramework,
  ADAPT.Intf, ADAPT.Collections.Intf;

type
  [TestFixture]
  TADUTCollectionsArray = class(TObject)
  public
    [Test]
    procedure BasicIntegrity;
    [Test]
    procedure ReaderIntegrity;
    [Test]
    procedure SetCapacity;
    [Test]
    procedure SetItem;
    [Test]
    procedure Clear;
    [Test]
    procedure DeleteOne;
    [Test]
    procedure DeleteRange;
    [Test]
    procedure InsertMiddle;
    [Test]
    procedure InsertFirst;
    [Test]
    procedure InsertLast;
  end;

  [TestFixture]
  TADUTCollectionsExpander = class(TObject)

  end;

  [TestFixture]
  TADUTCollectionsExpanderGeometric = class(TObject)

  end;

  [TestFixture]
  TADUTCollectionsCompactor = class(TObject)

  end;

  [TestFixture]
  TADUTCollectionsList = class(TObject)
    [Test]
    procedure BasicIntegrity;
    [Test]
    procedure ReaderIntegrity;
    [Test]
    procedure SetItem;
    [Test]
    procedure Clear;
    [Test]
    procedure DeleteOne;
    [Test]
    procedure DeleteRange;
    [Test]
    procedure InsertMiddle;
    [Test]
    procedure InsertFirst;
    [Test]
    procedure InsertLast;
    [Test]
    procedure Sort;
    [Test]
    procedure SortRange;
  end;

  [TestFixture]
  TADUTCollectionsSortedList = class(TObject)
    [Test]
    procedure BasicIntegrity;
    [Test]
    procedure ReaderIntegrity;
    [Test]
    procedure Contains;
    [Test]
    procedure IndexOf;
    [Test]
    procedure Remove;
  end;

  [TestFixture]
  TADUTCollectionsCircularList = class(TObject)
    [Test]
    procedure BasicIntegrity;
    [Test]
    procedure ReaderIntegrity;
    [Test]
    procedure CircularIntegrity;
  end;

  [TestFixture]
  TADUTCollectionsMap = class(TObject)
  public
    [Test]
    procedure BasicIntegrity;
  end;

  [TestFixture]
  TADUTCollectionsTree = class(TObject)
  public
    [Test]
    procedure BasicIntegrity;
  end;

implementation

uses
  ADAPT, ADAPT.Collections, ADAPT.Comparers;

type
  // Specialized Interfaces
  IADStringArray = IADArray<String>;
  IADStringArrayReader = IADArrayReader<String>;
  IADStringList = IADList<String>;
  IADStringListReader = IADListReader<String>;
  IADStringCircularList = IADCircularList<String>;
  IADStringCircularListReader = IADCircularListReader<String>;
  IADStringSortedList = IADSortedList<String>;
  IADStringStringMap = IADMap<String, String>;
  IADStringTreeNodeReader = IADTreeNodeReader<String>;
  IADStringTreeNode = IADTreeNode<String>;
  // Specialized Classes
  TADStringArray = TADArray<String>;
  TADStringList = TADList<String>;
  TADStringSortedList = TADSortedList<String>;
  TADStringCircularList = TADCircularList<String>;
  TADStringStringMap = TADMap<String, String>;
  TADStringTreeNode = TADTreeNode<String>;

  TMapTestItem = record
    Key: String;
    Value: String;
  end;

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

  BASIC_ITEMS_SORTED: Array[0..9] of String = (
                                                'Andy',
                                                'Bob',
                                                'Ellen',
                                                'Hugh',
                                                'Jack',
                                                'Marie',
                                                'Ninette',
                                                'Rick',
                                                'Sarah',
                                                'Terry'
                                              );

  BASIC_ITEMS_HALF_SORTED: Array[0..9] of String = (
                                                     'Andy',
                                                     'Bob',
                                                     'Rick',
                                                     'Sarah',
                                                     'Terry',
                                                     'Ellen',
                                                     'Hugh',
                                                     'Jack',
                                                     'Marie',
                                                     'Ninette'
                                                   );

  MAP_ITEMS: Array[0..9] of TMapTestItem = (
                                             (Key: 'Foo'; Value: 'Bar'),
                                             (Key: 'Donald'; Value: 'Duck'),
                                             (Key: 'Mickey'; Value: 'Mouse'),
                                             (Key: 'Winnie'; Value: 'Pooh'),
                                             (Key: 'Goof'; Value: 'Troop'),
                                             (Key: 'Tale'; Value: 'Spin'),
                                             (Key: 'Captain'; Value: 'Kangaroo'),
                                             (Key: 'Major'; Value: 'Tom'),
                                             (Key: 'Gummie'; Value: 'Bears'),
                                             (Key: 'Whacky'; Value: 'Races')
                                           );

  MAP_ITEMS_SORTED: Array[0..9] of TMapTestItem = (
                                                    (Key: 'Captain'; Value: 'Kangaroo'),
                                                    (Key: 'Donald'; Value: 'Duck'),
                                                    (Key: 'Foo'; Value: 'Bar'),
                                                    (Key: 'Goof'; Value: 'Troop'),
                                                    (Key: 'Gummie'; Value: 'Bears'),
                                                    (Key: 'Major'; Value: 'Tom'),
                                                    (Key: 'Mickey'; Value: 'Mouse'),
                                                    (Key: 'Tale'; Value: 'Spin'),
                                                    (Key: 'Whacky'; Value: 'Races'),
                                                    (Key: 'Winnie'; Value: 'Pooh')
                                                  );

{ TADUTCollectionsArray }

procedure TADUTCollectionsArray.BasicIntegrity;
var
  LArray: IADStringArray;
  I: Integer;
begin
  LArray := TADStringArray.Create(10);
  // Test Capacity has been Initialized
  Assert.IsTrue(LArray.Capacity = 10, Format('Capacity Expected 10, got %d', [LArray.Capacity]));
  // Add our Basic Test Items
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
    LArray.Items[I] := BASIC_ITEMS[I];
  // Make sure they match!
  for I := 0 to LArray.Capacity - 1 do
    Assert.IsTrue(LArray.Items[I] = BASIC_ITEMS[I], Format('Item at Index %d does not match. Expected "%s" but got "%s"', [I, BASIC_ITEMS[I], LArray.Items[I]]));
end;

procedure TADUTCollectionsArray.Clear;
var
  LArray: IADStringArray;
  I: Integer;
begin
  LArray := TADStringArray.Create(10);
  // Add our Basic Test Items
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
    LArray.Items[I] := BASIC_ITEMS[I];
  // Increase Capacity
  LArray.Capacity := 15;
  // Clear the Array
  LArray.Clear;
  // Capacity should return to 10
  Assert.IsTrue(LArray.Capacity = 10, Format('Capacity Expected 10, got %d', [LArray.Capacity]));
  // There should be no items in the Array, so attempting to reference any should result in an Access Violation Exception.
  Assert.WillRaiseAny(procedure begin LArray[0]; end, 'Item 0 request should have raised an Exception, it did not! List must not be empty!');
end;

procedure TADUTCollectionsArray.DeleteOne;
var
  LArray: IADStringArray;
  I: Integer;
begin
  LArray := TADStringArray.Create(10);
  // Test Capacity has been Initialized
  Assert.IsTrue(LArray.Capacity = 10, Format('Capacity Expected 10, got %d', [LArray.Capacity]));
  // Add our Basic Test Items
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
    LArray.Items[I] := BASIC_ITEMS[I];
  // Remove Item 5
  LArray.Delete(5);
  // Item 5 should now equal Item 6 in the BASIC_ITEMS Array.
  Assert.IsTrue(LArray[5] = BASIC_ITEMS[6], Format('Array Item 5 should be "%s" but instead got "%s".', [BASIC_ITEMS[6], LArray[5]]));
end;

procedure TADUTCollectionsArray.DeleteRange;
var
  LArray: IADStringArray;
  I: Integer;
begin
  LArray := TADStringArray.Create(10);
  // Test Capacity has been Initialized
  Assert.IsTrue(LArray.Capacity = 10, Format('Capacity Expected 10, got %d', [LArray.Capacity]));
  // Add our Basic Test Items
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
    LArray.Items[I] := BASIC_ITEMS[I];
  // Remove Items 5 through 7
  LArray.Delete(5, 2);
  // Item 5 should now equal Item 7 in the BASIC_ITEMS Array.
  Assert.IsTrue(LArray[5] = BASIC_ITEMS[7], Format('Array Item 5 should be "%s" but instead got "%s".', [BASIC_ITEMS[7], LArray[5]]));
end;

procedure TADUTCollectionsArray.InsertFirst;
var
  LArray: IADStringArray;
  I: Integer;
begin
  LArray := TADStringArray.Create(10);
  // Add our Basic Test Items
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
    LArray.Items[I] := BASIC_ITEMS[I];
  // Increase capacity to hold one more item
  LArray.Capacity := 11;
  // Insert a new Item at Index 0
  LArray.Insert('Googar', 0);
  // Index 0 should be "Googar"
    Assert.IsTrue(LArray[0] = 'Googar', Format('Index 0 should be "Googar" but instead got "%s"', [LArray[0]]));
  // Index 1 through 10 should equal BASIC_ITEMS 0 through 9
  for I := 1 to 10 do
    Assert.IsTrue(LArray.Items[I] = BASIC_ITEMS[I-1], Format('Item at Index %d does not match. Expected "%s" but got "%s"', [I, BASIC_ITEMS[I-1], LArray.Items[I]]));
end;

procedure TADUTCollectionsArray.InsertLast;
var
  LArray: IADStringArray;
  I: Integer;
begin
  LArray := TADStringArray.Create(10);
  // Add our Basic Test Items
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
    LArray.Items[I] := BASIC_ITEMS[I];
  // Increase capacity to hold one more item
  LArray.Capacity := 11;
  // Insert a new Item at Index 10
  LArray.Insert('Googar', 10);
  // Index 10 should be "Googar"
    Assert.IsTrue(LArray[10] = 'Googar', Format('Index 10 should be "Googar" but instead got "%s"', [LArray[10]]));
  // Index 0 through 9 should equal BASIC_ITEMS 0 through 9
  for I := 0 to 9 do
    Assert.IsTrue(LArray.Items[I] = BASIC_ITEMS[I], Format('Item at Index %d does not match. Expected "%s" but got "%s"', [I, BASIC_ITEMS[I], LArray.Items[I]]));
end;

procedure TADUTCollectionsArray.InsertMiddle;
var
  LArray: IADStringArray;
  I: Integer;
begin
  LArray := TADStringArray.Create(10);
  // Add our Basic Test Items
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
    LArray.Items[I] := BASIC_ITEMS[I];
  // Increase capacity to hold one more item
  LArray.Capacity := 11;
  // Insert a new Item at Index 5
  LArray.Insert('Googar', 5);
  // Index 0 through 4 should match...
  for I := 0 to 4 do
    Assert.IsTrue(LArray.Items[I] = BASIC_ITEMS[I], Format('Item at Index %d does not match. Expected "%s" but got "%s"', [I, BASIC_ITEMS[I], LArray.Items[I]]));
  // Index 5 should be "Googar"
    Assert.IsTrue(LArray[5] = 'Googar', Format('Index 5 should be "Googar" but instead got "%s"', [LArray[5]]));
  // Index 6 through 10 should equal BASIC_ITEMS 5 through 9
  for I := 6 to 10 do
    Assert.IsTrue(LArray.Items[I] = BASIC_ITEMS[I-1], Format('Item at Index %d does not match. Expected "%s" but got "%s"', [I, BASIC_ITEMS[I-1], LArray.Items[I]]));
end;

procedure TADUTCollectionsArray.ReaderIntegrity;
var
  LArray: IADStringArray;
  LArrayReader: IADStringArrayReader;
  I: Integer;
begin
  LArray := TADStringArray.Create(10);
  // Add our Basic Test Items
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
    LArray.Items[I] := BASIC_ITEMS[I];
  // Obtain the Read-Only Interface Reference
  LArrayReader := LArray.Reader;
  // Make sure the items match
  for I := 0 to LArrayReader.Capacity - 1 do
    Assert.IsTrue(LArrayReader.Items[I] = BASIC_ITEMS[I], Format('Item at Index %d does not match. Expected "%s" but got "%s"', [I, BASIC_ITEMS[I], LArrayReader.Items[I]]));
end;

procedure TADUTCollectionsArray.SetCapacity;
var
  LArray: IADStringArray;
  I: Integer;
begin
  LArray := TADStringArray.Create(10);
  // Test Capacity has been Initialized
  Assert.IsTrue(LArray.Capacity = 10, Format('Capacity Expected 10, got %d', [LArray.Capacity]));
  // Add our Basic Test Items
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
    LArray.Items[I] := BASIC_ITEMS[I];
  // Modify our Capacity
  LArray.Capacity := 15;
  // Test Capacity has been increased to 15
  Assert.IsTrue(LArray.Capacity = 15, Format('Capacity Expected 15, got %d', [LArray.Capacity]));
end;

procedure TADUTCollectionsArray.SetItem;
var
  LArray: IADStringArray;
  I: Integer;
begin
  LArray := TADStringArray.Create(10);
  // Add our Basic Test Items
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
    LArray.Items[I] := BASIC_ITEMS[I];
  // Modify Item 5
  LArray.Items[5] := 'Googar';
  // Test Capacity has been increased to 15
  Assert.IsTrue(LArray[5] = 'Googar', Format('Item 5 should be "Googar", got "%s"', [LArray[5]]));
end;

{ TADUTCollectionsList }

procedure TADUTCollectionsList.BasicIntegrity;
var
  LList: IADStringList;
  I: Integer;
begin
  LList := TADStringList.Create(10);
  // Add our Basic Test Items
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
    LList.Add(BASIC_ITEMS[I]);
  // Make sure they match!
  for I := 0 to Length(BASIC_ITEMS) - 1 do
    Assert.IsTrue(LList[I] = BASIC_ITEMS[I], Format('Item at Index %d does not match. Expected "%s" but got "%s"', [I, BASIC_ITEMS[I], LList[I]]));
end;

procedure TADUTCollectionsList.Clear;
var
  LList: IADStringList;
  I: Integer;
begin
  LList := TADStringList.Create(10);
  // Add our Basic Test Items
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
  begin
    LList.Add(BASIC_ITEMS[I]);
    Assert.IsTrue(LList.Count = I + 1, Format('Count should be %d, instead got %d', [I + 1, LList.Count]));
  end;
  // Clear the List
  LList.Clear;
  // The Count should now be 0
  Assert.IsTrue(LList.Count = 0, Format('Count should be 0, instead got %d', [LList.Count]));
  // There should be no items in the Array, so attempting to reference any should result in an Access Violation Exception.
  Assert.WillRaiseAny(procedure begin LList[0]; end, 'Item 0 request should have raised an Exception, it did not! List must not be empty!');
end;

procedure TADUTCollectionsList.DeleteOne;
var
  LList: IADStringList;
  I: Integer;
begin
  LList := TADStringList.Create(10);
  // Add our Basic Test Items
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
    LList.Add(BASIC_ITEMS[I]);
  // Remove Item 5
  LList.Delete(5);
  // Item 5 should now equal Item 6 in the BASIC_ITEMS List.
  Assert.IsTrue(LList[5] = BASIC_ITEMS[6], Format('List Item 5 should be "%s" but instead got "%s".', [BASIC_ITEMS[6], LList[5]]));
end;

procedure TADUTCollectionsList.DeleteRange;
var
  LList: IADStringList;
  I: Integer;
begin
  LList := TADStringList.Create(10);
  // Add our Basic Test Items
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
    LList.Add(BASIC_ITEMS[I]);
  // Remove Items 5 through 7
  LList.DeleteRange(5, 2);
  // Item 5 should now equal Item 7 in the BASIC_ITEMS List.
  Assert.IsTrue(LList[5] = BASIC_ITEMS[7], Format('List Item 5 should be "%s" but instead got "%s".', [BASIC_ITEMS[7], LList[5]]));
end;

procedure TADUTCollectionsList.InsertFirst;
var
  LList: IADStringList;
  I: Integer;
begin
  LList := TADStringList.Create(10);
  // Add our Basic Test Items
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
    LList.Add(BASIC_ITEMS[I]);
  // Insert a new Item at Index 0
  LList.Insert('Googar', 0);
  // Index 0 should be "Googar"
    Assert.IsTrue(LList[0] = 'Googar', Format('Index 0 should be "Googar" but instead got "%s"', [LList[0]]));
  // Index 1 through 10 should equal BASIC_ITEMS 0 through 9
  for I := 1 to 10 do
    Assert.IsTrue(LList[I] = BASIC_ITEMS[I-1], Format('Item at Index %d does not match. Expected "%s" but got "%s"', [I, BASIC_ITEMS[I-1], LList[I]]));
end;

procedure TADUTCollectionsList.InsertLast;
var
  LList: IADStringList;
  I: Integer;
begin
  LList := TADStringList.Create(10);
  // Add our Basic Test Items
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
    LList.Add(BASIC_ITEMS[I]);
  // Insert a new Item at Index 10
  LList.Insert('Googar', 10);
  // Index 10 should be "Googar"
    Assert.IsTrue(LList[10] = 'Googar', Format('Index 10 should be "Googar" but instead got "%s"', [LList[10]]));
  // Index 0 through 9 should equal BASIC_ITEMS 0 through 9
  for I := 0 to 9 do
    Assert.IsTrue(LList[I] = BASIC_ITEMS[I], Format('Item at Index %d does not match. Expected "%s" but got "%s"', [I, BASIC_ITEMS[I], LList[I]]));
end;

procedure TADUTCollectionsList.InsertMiddle;
var
  LList: IADStringList;
  I: Integer;
begin
  LList := TADStringList.Create(10);
  // Add our Basic Test Items
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
    LList.Add(BASIC_ITEMS[I]);
  // Insert a new Item at Index 5
  LList.Insert('Googar', 5);
  // Index 0 through 4 should match...
  for I := 0 to 4 do
    Assert.IsTrue(LList[I] = BASIC_ITEMS[I], Format('Item at Index %d does not match. Expected "%s" but got "%s"', [I, BASIC_ITEMS[I], LList[I]]));
  // Index 5 should be "Googar"
    Assert.IsTrue(LList[5] = 'Googar', Format('Index 5 should be "Googar" but instead got "%s"', [LList[5]]));
  // Index 6 through 10 should equal BASIC_ITEMS 5 through 9
  for I := 6 to 10 do
    Assert.IsTrue(LList[I] = BASIC_ITEMS[I-1], Format('Item at Index %d does not match. Expected "%s" but got "%s"', [I, BASIC_ITEMS[I-1], LList[I]]));
end;

procedure TADUTCollectionsList.ReaderIntegrity;
var
  LList: IADStringList;
  LListReader: IADStringListReader;
  I: Integer;
begin
  LList := TADStringList.Create(10);
  // Add our Basic Test Items
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
    LList.Add(BASIC_ITEMS[I]);
  // Obtain the Reader Interface
  LListReader := LList.Reader;
  // Make sure they match!
  for I := 0 to Length(BASIC_ITEMS) - 1 do
    Assert.IsTrue(LListReader[I] = BASIC_ITEMS[I], Format('Item at Index %d does not match. Expected "%s" but got "%s"', [I, BASIC_ITEMS[I], LListReader[I]]));
end;

procedure TADUTCollectionsList.SetItem;
var
  LList: IADStringList;
  I: Integer;
begin
  LList := TADStringList.Create(10);
  // Add our Basic Test Items
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
    LList.Add(BASIC_ITEMS[I]);
  // Modify Item 5
  LList.Items[5] := 'Googar';
  // Test Capacity has been increased to 15
  Assert.IsTrue(LList[5] = 'Googar', Format('Item 5 should be "Googar", got "%s"', [LList[5]]));
end;

procedure TADUTCollectionsList.Sort;
var
  LList: IADStringList;
  I: Integer;
begin
  LList := TADStringList.Create(10);
  // Add our Basic Test Items
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
    LList.Add(BASIC_ITEMS[I]);

  // Sort the List
  LList.Sort(ADStringComparer);

  // Make sure they match!
  for I := 0 to Length(BASIC_ITEMS) - 1 do
    Assert.IsTrue(LList[I] = BASIC_ITEMS_SORTED[I], Format('Item at Index %d does not match. Expected "%s" but got "%s"', [I, BASIC_ITEMS_SORTED[I], LList[I]]));
end;

procedure TADUTCollectionsList.SortRange;
var
  LList: IADStringList;
  I: Integer;
begin
  LList := TADStringList.Create(10);
  // Add our Basic Test Items
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
    LList.Add(BASIC_ITEMS[I]);

  // Sort the List from Index 0 to Index 4 (half the list)
  LList.SortRange(ADStringComparer, 0, 4);

  // Make sure they match!
  for I := 0 to LList.Count - 1 do
    Assert.IsTrue(LList[I] = BASIC_ITEMS_HALF_SORTED[I], Format('Item at Index %d does not match. Expected "%s" but got "%s"', [I, BASIC_ITEMS_HALF_SORTED[I], LList[I]]));
end;

{ TADUTCollectionsSortedList }

procedure TADUTCollectionsSortedList.BasicIntegrity;
var
  LList: IADStringList;
  I: Integer;
begin
  LList := TADStringSortedList.Create(ADStringComparer, 10);
  // Add our Basic Test Items
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
    LList.Add(BASIC_ITEMS[I]);
  // Make sure they match their PRE-SORTED COUNTERPARTS!
  for I := 0 to LList.Count - 1 do
  begin
    Log(TLogLevel.Information, Format('Sorted List Index %d = "%s"', [I, LList[I]]));
    Assert.IsTrue(LList[I] = BASIC_ITEMS_SORTED[I], Format('Item at Index %d does not match. Expected "%s" but got "%s"', [I, BASIC_ITEMS_SORTED[I], LList[I]]));
  end;
end;

procedure TADUTCollectionsSortedList.Contains;
var
  LSortedList: IADStringSortedList;
  I: Integer;
begin
  LSortedList := TADStringSortedList.Create(ADStringComparer, 10);
  // Add our Basic Test Items
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
    LSortedList.Add(BASIC_ITEMS[I]);
  // Should NOT contain "Googar"
  Assert.IsFalse(LSortedList.Contains('Googar'), 'List should NOT contain "Googar" but does.');
  // Should contain "Bob"
  Assert.IsTrue(LSortedList.Contains('Bob'), 'List SHOULD contain "Bob" but does not.');
end;

procedure TADUTCollectionsSortedList.IndexOf;
var
  LSortedList: IADStringSortedList;
  I: Integer;
begin
  LSortedList := TADStringSortedList.Create(ADStringComparer, 10);
  // Add our Basic Test Items
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
    LSortedList.Add(BASIC_ITEMS[I]);
  // Should NOT contain "Googar"
  Assert.IsTrue(LSortedList.IndexOf('Googar') = -1, 'List should NOT contain "Googar" but does.');
  // Should contain "Bob"
  Assert.IsTrue(LSortedList.IndexOf('Bob') = 1, 'List SHOULD contain "Bob" but does not.');
end;

procedure TADUTCollectionsSortedList.ReaderIntegrity;
var
  LList: IADStringList;
  LReader: IADStringListReader;
  I: Integer;
begin
  LList := TADStringSortedList.Create(ADStringComparer, 10);
  // Add our Basic Test Items
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
    LList.Add(BASIC_ITEMS[I]);
  // Grab our Reader Interface
  LReader := LList.Reader;
  // Make sure they match their PRE-SORTED COUNTERPARTS!
  for I := 0 to LReader.Count - 1 do
  begin
    Log(TLogLevel.Information, Format('Sorted List Index %d = "%s"', [I, LReader[I]]));
    Assert.IsTrue(LReader[I] = BASIC_ITEMS_SORTED[I], Format('Item at Index %d does not match. Expected "%s" but got "%s"', [I, BASIC_ITEMS_SORTED[I], LReader[I]]));
  end;
end;

procedure TADUTCollectionsSortedList.Remove;
var
  LList: IADStringSortedList;
  I: Integer;
begin
  LList := TADStringSortedList.Create(ADStringComparer, 10);
  // Add our Basic Test Items
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
    LList.Add(BASIC_ITEMS[I]);

  // Remove "Bob"
  LList.Remove('Bob'); // We know "Bob" sits at Index 1

  // Ensure Item 0 matches
  Assert.IsTrue(LList[0] = BASIC_ITEMS_SORTED[0], 'Item 0 should match but does not.');
  // Make sure the rest match their PRE-SORTED COUNTERPARTS!
  for I := 1 to Length(BASIC_ITEMS_SORTED) - 2 do
    Assert.IsTrue(LList[I] = BASIC_ITEMS_SORTED[I+1], Format('Item at Index %d does not match. Expected "%s" but got "%s"', [I, BASIC_ITEMS_SORTED[I+1], LList[I]]));
end;

{ TADUTCollectionsCircularList }

procedure TADUTCollectionsCircularList.BasicIntegrity;
var
  LList: IADStringList;
  I: Integer;
begin
  LList := TADStringCircularList.Create(10);
  // Add our Basic Test Items
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
    LList.Add(BASIC_ITEMS[I]);
  // Make sure they match!
  for I := 0 to Length(BASIC_ITEMS) - 1 do
    Assert.IsTrue(LList[I] = BASIC_ITEMS[I], Format('Item at Index %d does not match. Expected "%s" but got "%s"', [I, BASIC_ITEMS[I], LList[I]]));
end;

procedure TADUTCollectionsCircularList.CircularIntegrity;
var
  LList: IADStringList;
  I: Integer;
begin
  LList := TADStringCircularList.Create(5);
  // Add our Basic Test Items
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
    LList.Add(BASIC_ITEMS[I]);
  // Make sure they match the SECOND HALF of the BASIC_ITEMS Array!
  for I := 0 to LList.Count - 1 do
    Assert.IsTrue(LList[I] = BASIC_ITEMS[I+5], Format('Item at Index %d does not match. Expected "%s" but got "%s"', [I, BASIC_ITEMS[I+5], LList[I]]));
end;

procedure TADUTCollectionsCircularList.ReaderIntegrity;
var
  LList: IADStringList;
  LReader: IADStringCircularListReader;
  I: Integer;
begin
  LList := TADStringCircularList.Create(10);
  // Add our Basic Test Items
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
    LList.Add(BASIC_ITEMS[I]);
  // Get our Reader interface
  LReader := IADStringCircularListReader(LList.Reader);
  // Make sure they match!
  for I := 0 to Length(BASIC_ITEMS) - 1 do
    Assert.IsTrue(LReader[I] = BASIC_ITEMS[I], Format('Item at Index %d does not match. Expected "%s" but got "%s"', [I, BASIC_ITEMS[I], LReader[I]]));
end;

{ TADUTCollectionsMap }

procedure TADUTCollectionsMap.BasicIntegrity;
var
  LMap: IADStringStringMap;
  LItem: IADKeyValuePair<String, String>;
  I: Integer;
begin
  LMap := TADStringStringMap.Create(ADStringComparer);

  // Add the Test Items
  for I := Low(MAP_ITEMS) to High(MAP_ITEMS) do
    LMap.Add(MAP_ITEMS[I].Key, MAP_ITEMS[I].Value);

  // Verify they exist
  for I := 0 to LMap.Count - 1 do
  begin
    LItem := LMap.Pairs[I];
    Assert.IsTrue((LItem.Key = MAP_ITEMS_SORTED[I].Key) and (LItem.Value = MAP_ITEMS_SORTED[I].Value), Format('Pair should be "%s", "%s" but instead got pair "%s", "%s".', [MAP_ITEMS_SORTED[I].Key, MAP_ITEMS_SORTED[I].Value, LItem.Key, LItem.Value]));
  end;
end;

{ TADUTCollectionsTree }

procedure TADUTCollectionsTree.BasicIntegrity;
var
  LNode: IADStringTreeNode;
  LNode2: IADStringTreeNode;
begin
  LNode := TADStringTreeNode.Create('Foo');
  LNode2 := TADStringTreeNode.Create(LNode, 'Bar');

  // Test Values for both Nodes
  Assert.IsTrue(LNode.Value = 'Foo', Format('Node Value should be "Foo" but instead got "%s"', [LNode.Value]));
  Assert.IsTrue(LNode2.Value = 'Bar', Format('Node2 Value should be "Bar" but instead got "%s"', [LNode.Value]));

  LNode2.Parent.Value := 'Haha';
  Assert.IsTrue(LNode.Value = 'Haha', Format('Node Value should be "Haha" but instead got "%s"', [LNode.Value]));

  Assert.IsTrue(LNode2.Parent <> nil, 'Node2 Parent should be Node, but is not!');
end;

end.
