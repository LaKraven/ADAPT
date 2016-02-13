unit ADAPT.UnitTests.Generics.Collections;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry;

type

  TAdaptUnitTestGenericsArray= class(TTestCase)
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestHookUp;
  end;

implementation

procedure TAdaptUnitTestGenericsArray.TestHookUp;
begin
  Fail('Write your own test');
end;

procedure TAdaptUnitTestGenericsArray.SetUp;
begin

end;

procedure TAdaptUnitTestGenericsArray.TearDown;
begin

end;

initialization

  RegisterTest(TAdaptUnitTestGenericsArray);
end.

