{
  AD.A.P.T. Library
  Copyright (C) 2014-2016, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Generics.Defaults.Intf;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes,
  {$ELSE}
    Classes,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Common, ADAPT.Common.Intf;

  {$I ADAPT_RTTI.inc}

type
  // Exceptions
  EADGenericsException = class(EADException);
    EADGenericsRangeException = class(EADGenericsException);
    EADGenericsParameterInvalidException = class(EADGenericsException);

  ///  <summary><c>A Collection that can Own Objects.</c></summary>
  IADObjectOwner = interface(IADInterface)
  ['{5756A232-26B6-4395-9F1D-CCCC071E5701}']
  // Getters
  function GetOwnership: TADOwnership;
  // Setters
  procedure SetOwnership(const AOwnership: TADOwnership);
  // Properties
  property Ownership: TADOwnership read GetOwnership write SetOwnership;
  end;

implementation

end.
