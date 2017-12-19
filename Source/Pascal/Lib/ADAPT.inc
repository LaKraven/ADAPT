{
  AD.A.P.T. Library
  Copyright (C) 2014-2018, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
{$I ADAPT_VERSIONS.inc}

{$IFDEF FPC}
  {$IFNDEF ADAPT_FPC_MODE}
    {$DEFINE ADAPT_DELPHI_MODE}
  {$ENDIF ADAPT_FPC_MODE}
{$ELSE}
  // MINIMUM SUPPORTED VERSION
  {$IFNDEF DELPHI2010_UP}
    {$MESSAGE FATAL 'Your version of Delphi is older than Delphi 2010, and not supported by the LaKraven Studios Standard Library [ADAPT] (www.lakraven.com)'}
  {$ELSE}
    {$DEFINE ADAPT}
  {$ENDIF DELPHI2010}
{$ENDIF FPC}

{$IFDEF SUPPORTS_RECORDHELPERS}
  {$IFNDEF ADAPT_NO_HELPERS}
    {$DEFINE ADAPT_USE_HELPERS} // Define "ADAPT_NO_HELPERS" in your project to disable Helpers
  {$ENDIF ADAPT_NO_HELPERS}
{$ENDIF SUPPORTS_RECORDHELPERS}

{$IFNDEF ADAPT_NO_LISTS}
  {$DEFINE ADAPT_USE_LISTS} // Define "ADAPT_NO_LISTS" in your project to disable Generic Lists
{$ENDIF ADAPT_NO_LISTS}

{$IFDEF SUPPORTS_NAMESPACES}
  {$IFNDEF ADAPT_NO_EXPLICIT_UNIT_NAMES}
    {$IFDEF NAMESPACES_BY_DEFAULT}
      {$DEFINE ADAPT_USE_EXPLICIT_UNIT_NAMES} // Define "ADAPT_NO_EXPLICIT_UNIT_NAMES" to disable explicit unit names on XE2+
    {$ENDIF NAMESPACES_BY_DEFAULT}
  {$ENDIF ADAPT_NO_EXPLICIT_UNIT_NAMES}
{$ENDIF SUPPORTS_NAMESPACES}

// Enforce Default Float Type Precision
{$IFNDEF ADAPT_FLOAT_SINGLE}
  {$IFNDEF ADAPT_FLOAT_EXTENDED}
    {$DEFINE ADAPT_FLOAT_DOUBLE} // Default to DOUBLE precision
  {$ENDIF ADAPT_FLOAT_EXTENDED}
{$ENDIF ADAPT_FLOAT_SINGLE}

// Delphi/FPC Mode Setting

{$IFDEF FPC}
  {$IFDEF ADAPT_MODE_FPC}
    {$mode objfpc}{$H+}
  {$ELSE}
    {$mode delphi}
  {$ENDIF ADAPT_MODE_FPC}
{$ENDIF FPC}

{$DEFINE ADAPT_LOCK_ALLEXCLUSIVE} // THIS IS TEMPORARY WHILE THE LOCK TYPE ISN'T COMPLETE!
