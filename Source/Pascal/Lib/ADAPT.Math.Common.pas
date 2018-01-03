{
  AD.A.P.T. Library
  Copyright (C) 2014-2018, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Math.Common;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes,
  {$ELSE}
    Classes,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT, ADAPT.Intf,
  ADAPT.Math.Common.Intf;

  {$I ADAPT_RTTI.inc}

type
  TADExtrapolator<TKey, TValue> = class abstract(TADObject, IADExtrapolator<TKey, TValue>)

  end;

  TADInterpolator<TKey, TValue> = class abstract(TADObject, IADInterpolator<TKey, TValue>)

  end;

implementation

end.
