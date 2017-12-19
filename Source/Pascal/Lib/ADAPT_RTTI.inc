{
  AD.A.P.T. Library
  Copyright (C) 2014-2018, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}

{
  This unit allows you to enable and disable RTTI for ADAPT's units
  By default, RTTI is ENABLED.

  You can disable RTTI by defining ADAPT_NO_RTTI in your Project Options

  NOTE: THIS UNIT CURRENTLY ONLY APPLIES TO DELPHI!
}
{$IFNDEF FPC}
  {$IFDEF ADAPT_NO_RTTI}
    {$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}
  {$ENDIF ADAPT_NO_RTTI}
{$ENDIF FPC}
