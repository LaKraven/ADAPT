unit ADAPT.UnitTests.Generics.Collections;

interface
uses
  DUnitX.TestFramework;

type

  [TestFixture]
  TAdaptUnitTestGenerics = class(TObject) 
  public

  end;

implementation

initialization
  TDUnitX.RegisterTestFixture(TAdaptUnitTestGenerics);
end.
