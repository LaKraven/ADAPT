unit ADAPT.Temp.UnitTests.Generics;

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

  end;

  [TestFixture]
  TADUTCollectionsMap = class(TObject)

  end;

  [TestFixture]
  TADUTCollectionsCircularList = class(TObject)

  end;

implementation

uses
  ADAPT, ADAPT.Collections;

type
  // Specialized Interfaces
  IADStringArray = IADArray<String>;
  IADStringArrayReader = IADArrayReader<String>;
  // Specialized Classes
  TADStringArray = TADArray<String>;

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

{ TADUTCollectionsArray }

procedure TADUTCollectionsArray.BasicIntegrity;
var
  LArray: IADArray<String>;
  I: Integer;
begin
  LArray := TADArray<String>.Create(10);
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
  LArray: IADArray<String>;
  I: Integer;
begin
  LArray := TADArray<String>.Create(10);
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
  LArray: IADArray<String>;
  I: Integer;
begin
  LArray := TADArray<String>.Create(10);
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
  LArray: IADArray<String>;
  I: Integer;
begin
  LArray := TADArray<String>.Create(10);
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
  LArray: IADArray<String>;
  I: Integer;
begin
  LArray := TADArray<String>.Create(10);
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
  LArray: IADArray<String>;
  I: Integer;
begin
  LArray := TADArray<String>.Create(10);
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
  LArray: IADArray<String>;
  I: Integer;
begin
  LArray := TADArray<String>.Create(10);
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
  LArray: IADArray<String>;
  I: Integer;
begin
  LArray := TADArray<String>.Create(10);
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
  LArray: IADArray<String>;
  I: Integer;
begin
  LArray := TADArray<String>.Create(10);
  // Add our Basic Test Items
  for I := Low(BASIC_ITEMS) to High(BASIC_ITEMS) do
    LArray.Items[I] := BASIC_ITEMS[I];
  // Modify Item 5
  LArray.Items[5] := 'Googar';
  // Test Capacity has been increased to 15
  Assert.IsTrue(LArray[5] = 'Googar', Format('Item 5 should be "Googar", got "%s"', [LArray[5]]));
end;

end.
