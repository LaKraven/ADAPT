unit ADAPT.UnitTests.Generics.Collections;

interface
uses
  DUnitX.TestFramework;

type

  [TestFixture]
  TAdaptUnitTestGenericsArray = class(TObject)
  public

  end;

implementation

initialization
  TDUnitX.RegisterTestFixture(TAdaptUnitTestGenericsArray);
end.
