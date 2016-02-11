{
  AD.A.P.T. Library
  Copyright (C) 2014-2016, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT

  Formerlly known as "LaKraven Studios Standard Library" or "LKSL".
  "ADAPT" supercedes the former LKSL codebase as of 2016.

  License:
    - You may use this library as you see fit, including use within commercial applications.
    - You may modify this library to suit your needs, without the requirement of distributing
      modified versions.
    - You may redistribute this library (in part or whole) individually, or as part of any
      other works.
    - You must NOT charge a fee for the distribution of this library (compiled or in its
      source form). It MUST be distributed freely.
    - This license and the surrounding comment block MUST remain in place on all copies and
      modified versions of this source code.
    - Modified versions of this source MUST be clearly marked, including the name of the
      person(s) and/or organization(s) responsible for the changes, and a SEPARATE "changelog"
      detailing all additions/deletions/modifications made.

  Disclaimer:
    - Your use of this source constitutes your understanding and acceptance of this
      disclaimer.
    - Simon J Stuart, nor any other contributor, may be held liable for your use of this source
      code. This includes any losses and/or damages resulting from your use of this source
      code, be they physical, financial, or psychological.
    - There is no warranty or guarantee (implicit or otherwise) provided with this source
      code. It is provided on an "AS-IS" basis.

  Donations:
    - While not mandatory, contributions are always appreciated. They help keep the coffee
      flowing during the long hours invested in this and all other Open Source projects we
      produce.
    - Donations can be made via PayPal to PayPal [at] LaKraven (dot) Com
                                          ^  Garbled to prevent spam!  ^
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
