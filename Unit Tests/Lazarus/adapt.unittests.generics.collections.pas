unit ADAPT.UnitTests.Generics.Collections;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry,
  ADAPT.Common,
  ADAPT.Generics.Defaults, ADAPT.Generics.Arrays, ADAPT.Generics.Lists;

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

