unit ADAPT.UnitTests.Streams;

interface

{$I ADAPT.inc}

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes, System.SysUtils,
  {$ELSE}
    Classes, SysUtils,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  DUnitX.TestFramework,
  ADAPT.Intf,
  ADAPT.Streams.Intf;

type
  [TestFixture]
  TAdaptUnitTestStreamsMemory = class(TObject)
  public
    [Test]
    procedure BasicIntegrity;
  end;

implementation

uses
  ADAPT.Streams;

{ TAdaptUnitTestStreamsMemory }

procedure TAdaptUnitTestStreamsMemory.BasicIntegrity;
begin
  Assert.IsTrue(False, 'Not implemented yet!');
end;

end.
