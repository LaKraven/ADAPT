{
  A.D.A.P.T. Library
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
unit ADAPT.Common.Types.Base;

{$I ADAPT.inc}

{$IFDEF FPC}
  {$IFNDEF ADAPT_SUPPRESS_VERSION_WARNING}
    {.$IF FPC_VERSION < 3}
      {.$ERROR 'FreePascal (FPC) 3.0 or above is required for the ADAPT.'}
      {.$DEFINE ADAPT_WARNING_VERSION}
    {.$IFEND FPC_VERSION}
  {$ENDIF ADAPT_SUPPRESS_VERSION_WARNING}
{$ELSE}
  {$IFNDEF ADAPT_SUPPRESS_VERSION_WARNING}
    {$IFNDEF DELPHIXE2_UP}
      {$MESSAGE WARN 'Delphi 2010 and XE are not regularly tested with the ADAPT. Please report any issues on https://github.com/LaKraven/ADAPT'}
      {$DEFINE ADAPT_WARNING_VERSION}
    {$ENDIF DELPHIXE2_UP}
  {$ENDIF ADAPT_SUPPRESS_VERSION_WARNING}
{$ENDIF FPC}

{$IFDEF ADAPT_WARNING_VERSION}
  {$MESSAGE HINT 'Define "ADAPT_SUPPRESS_VERSION_WARNING" in your project options to get rid of these messages'}
  {$UNDEF ADAPT_WARNING_VERSION}
{$ENDIF ADAPT_WARNING_VERSION}

{$IFNDEF ADAPT_SUPPRESS_DEPRECATION_WARNING}
  // Nothing deprecated to warn about at this moment
  {$IFDEF ADAPT_WARNING_DEPRECATION}
    {$MESSAGE HINT 'Define "ADAPT_SUPPRESS_DEPRECATION_WARNING" in your project options to get rid of these messages'}
  {$ENDIF ADAPT_WARNING_DEPRECATION}
{$ENDIF ADAPT_SUPPRESS_DEPRECATION_WARNING}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes, System.SysUtils, System.SyncObjs;
  {$ELSE}
    Classes, SysUtils, SyncObjs;
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}

  {$I ADAPT_RTTI.inc}

type
  {$IFDEF ADAPT_FLOAT_SINGLE}
    ///  <summary><c>Single-Precision Floating Point Type.</c></summary>
    ADFloat = Single;
  {$ELSE}
    {$IFDEF ADAPT_FLOAT_EXTENDED}
      ///  <summary><c>Extended-Precision Floating Point Type.</c></summary>
      ADFloat = Extended;
    {$ELSE}
      ///  <summary><c>Double-Precision Floating Point Type.</c></summary>
      ADFloat = Double; // This is our default
    {$ENDIF ADAPT_FLOAT_DOUBLE}
  {$ENDIF ADAPT_FLOAT_SINGLE}

implementation

end.
