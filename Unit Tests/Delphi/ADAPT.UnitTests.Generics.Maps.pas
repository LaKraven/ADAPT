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

implementation

uses
  ADAPT.Collections.Intf, ADAPT.Collections,
  ADAPT.Comparers,
  ADAPT.UnitTests.Generics.Common;

end.
