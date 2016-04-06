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
unit ADAPT.Math.SIUnits;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes, System.Math,
  {$ELSE}
    Classes, Math,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Common;

  {$I ADAPT_RTTI.inc}

type
  { Enum Types }
  TADSIUnitNotation = (unShort, unLong);
  TADSIMagnitude = (simYocto, simZepto, simAtto, simFemto, simPico, simNano, simMicro, simMilli, simCenti, simDeci,
                     simOne,
                     simDeca, simHecto, simKilo, simMega, simGiga, simTera, simPeta, simExa, simZetta, simYotta);
  TADSIBaseUnitType = (sbtLength, sbtMass, sbtTime, sbtCurrent, sbtTemperature, sbtSubstance, sbtLuminousIntensity);
  TADSIBaseUnits = (sbuMetre, sbuKilogram, sbuSecond, sbuAmpere, sbuKelvin, sbuMole, sbuCandela);

  { Array Types }
  TADSIUnitNotations = Array[TADSIUnitNotation] of String;

  ///  <summary><c>Describes the "properties" of a Unit from the International System of Units.</c></summary>
  TADSIUnit = record
    Name: String;
    Symbol: String;
    BaseMagnitude: TADSIMagnitude;
    Notations: TADSIUnitNotations;
  end;

const
  AD_UNIT_METRE: TADSIUnit =   (
                                  Name: 'metre';
                                  Symbol: 'm';
                                  BaseMagnitude: simOne;
                                  Notations: ('m', 'metre');
                               );

  AD_UNIT_GRAM: TADSIUnit =    (
                                  Name: 'gram';
                                  Symbol: 'g';
                                  BaseMagnitude: simKilo;
                                  Notations: ('g', 'gram');
                               );

  AD_UNIT_SECOND: TADSIUnit =  (
                                  Name: 'second';
                                  Symbol: 's';
                                  BaseMagnitude: simOne;
                                  Notations: ('s', 'second');
                               );

  AD_UNIT_AMPERE: TADSIUnit =  (
                                  Name: 'ampere';
                                  Symbol: 'A';
                                  BaseMagnitude: simOne;
                                  Notations: ('A', 'ampere');
                               );

  AD_UNIT_KELVIN: TADSIUnit =  (
                                  Name: 'kelvin';
                                  Symbol: 'K';
                                  BaseMagnitude: simOne;
                                  Notations: ('K', 'kelvin');
                               );

  AD_UNIT_MOLE: TADSIUnit =    (
                                  Name: 'mole';
                                  Symbol: 'mol';
                                  BaseMagnitude: simOne;
                                  Notations: ('mol', 'mole');
                               );

  AD_UNIT_CANDELA: TADSIUnit = (
                                  Name: 'candela';
                                  Symbol: 'cd';
                                  BaseMagnitude: simOne;
                                  Notations: ('cd', 'candela');
                               );

  AD_UNIT_MAGNITUDE_NAMES_SI: Array[TADSIMagnitude, TADSIUnitNotation] of String = (
                                                                                     ('y', 'Yocto'), ('z', 'Zepto'), ('a', 'Atto'), ('f', 'Femto'), ('p', 'Pico'), ('n', 'Nano'), ('µ', 'Micro'), ('m', 'Milli'), ('c', 'Centi'), ('d', 'Deci'),
                                                                                     ('', ''),
                                                                                     ('da', 'Deca'), ('h', 'Hecto'), ('k', 'Kilo'), ('M', 'Mega'), ('G', 'Giga'), ('T', 'Tera'), ('P', 'Peta'), ('E', 'Exa'), ('Z', 'Zetta'), ('Y', 'Yotta')
                                                                                   );

  {$REGION 'Magnitude Conversion Table'}
    AD_UNIT_MAGNITUDE_CONVERSIONTABLE_SI: Array[TADSIMagnitude, TADSIMagnitude] of ADFloat = (
                                                                               //  Yocto   Zepto   Atto    Femto   Pico    Nano    Micro   Milli   Centi   Deci    One     Deca    Hecto   Kilo    Mega    Giga    Tera    Peta    Exa     Zetta   Yotta
                                                                         {Yocto}  (1,      1e-3,   1e-6,   1e-9,   1e-12,  1e-15,  1e-18,  1e-21,  1e-22,  1e-23,  1e-24,  1e-25,  1e-26,  1e-27,  1e-30,  1e-33,  1e-36,  1e-39,  1e-42,  1e-45,  1e-48),
                                                                         {Zepto}  (1e3,    1,      1e-3,   1e-6,   1e-9,   1e-12,  1e-15,  1e-18,  1e-19,  1e-20,  1e-21,  1e-22,  1e-23,  1e-24,  1e-27,  1e-30,  1e-33,  1e-36,  1e-39,  1e-42,  1e-45),
                                                                          {Atto}  (1e6,    1e3,    1,      1e-3,   1e-6,   1e-9,   1e-12,  1e-15,  1e-16,  1e-17,  1e-18,  1e-19,  1e-20,  1e-21,  1e-24,  1e-27,  1e-30,  1e-33,  1e-36,  1e-39,  1e-42),
                                                                         {Femto}  (1e9,    1e6,    1e3,    1,      1e-3,   1e-6,   1e-9,   1e-12,  1e-13,  1e-14,  1e-15,  1e-16,  1e-17,  1e-18,  1e-21,  1e-24,  1e-27,  1e-30,  1e-33,  1e-36,  1e-39),
                                                                          {Pico}  (1e12,   1e9,    1e6,    1e3,    1,      1e-3,   1e-6,   1e-9,   1e-10,  1e-11,  1e-12,  1e-13,  1e-14,  1e-15,  1e-18,  1e-21,  1e-24,  1e-27,  1e-30,  1e-33,  1e-36),
                                                                          {Nano}  (1e15,   1e12,   1e9,    1e6,    1e3,    1,      1e-3,   1e-6,   1e-7,   1e-8,   1e-9,   1e-10,  1e-11,  1e-12,  1e-15,  1e-18,  1e-21,  1e-24,  1e-27,  1e-30,  1e-33),
                                                                         {Micro}  (1e18,   1e15,   1e12,   1e9,    1e6,    1e3,    1,      1e-3,   1e-4,   1e-5,   1e-6,   1e-7,   1e-8,   1e-9,   1e-12,  1e-15,  1e-18,  1e-21,  1e-24,  1e-27,  1e-30),
                                                                         {Milli}  (1e21,   1e18,   1e15,   1e12,   1e9,    1e6,    1e1,    1,      1e-1,   1e-2,   1e-3,   1e-4,   1e-5,   1e-6,   1e-9,   1e-12,  1e-15,  1e-18,  1e-21,  1e-24,  1e-27),
                                                                         {Centi}  (1e22,   1e19,   1e16,   1e13,   1e10,   1e7,    1e4,    1e1,    1,      1e-1,   1e-2,   1e-3,   1e-4,   1e-5,   1e-8,   1e-11,  1e-14,  1e-17,  1e-20,  1e-23,  1e-26),
                                                                          {Deci}  (1e23,   1e20,   1e17,   1e14,   1e11,   1e8,    1e5,    1e2,    1e1,    1,      1e-1,   1e-2,   1e-3,   1e-4,   1e-7,   1e-10,  1e-13,  1e-16,  1e-19,  1e-22,  1e-25),
                                                                           {One}  (1e24,   1e21,   1e18,   1e15,   1e12,   1e9,    1e6,    1e3,    1e2,    1e1,    1,      1e-1,   1e-2,   1e-3,   1e-6,   1e-9,   1e-12,  1e-15,  1e-18,  1e-21,  1e-24),
                                                                          {Deca}  (1e25,   1e22,   1e19,   1e16,   1e13,   1e10,   1e7,    1e4,    1e3,    1e2,    1e1,    1,      1e-1,   1e-2,   1e-5,   1e-8,   1e-11,  1e-14,  1e-17,  1e-20,  1e-23),
                                                                         {Hecto}  (1e26,   1e23,   1e20,   1e17,   1e14,   1e11,   1e8,    1e5,    1e4,    1e3,    1e2,    1e1,    1,      1e-1,   1e-4,   1e-7,   1e-10,  1e-13,  1e-16,  1e-19,  1e-22),
                                                                          {Kilo}  (1e27,   1e24,   1e21,   1e18,   1e15,   1e12,   1e9,    1e6,    1e5,    1e4,    1e3,    1e2,    1e1,    1,      1e-3,   1e-6,   1e-9,   1e-12,  1e-15,  1e-18,  1e-21),
                                                                          {Mega}  (1e30,   1e27,   1e24,   1e21,   1e18,   1e15,   1e12,   1e9,    1e8,    1e7,    1e6,    1e5,    1e4,    1e3,    1,      1e-3,   1e-6,   1e-9,   1e-12,  1e-15,  1e-18),
                                                                          {Giga}  (1e33,   1e30,   1e27,   1e24,   1e21,   1e18,   1e15,   1e12,   1e11,   1e10,   1e9,    1e8,    1e7,    1e6,    1e3,    1,      1e-3,   1e-6,   1e-9,   1e-12,  1e-15),
                                                                          {Tera}  (1e36,   1e33,   1e30,   1e27,   1e24,   1e21,   1e18,   1e15,   1e14,   1e13,   1e12,   1e11,   1e10,   1e9,    1e6,    1e3,    1,      1e-3,   1e-6,   1e-9,   1e-12),
                                                                          {Peta}  (1e39,   1e36,   1e33,   1e30,   1e27,   1e24,   1e21,   1e18,   1e17,   1e16,   1e15,   1e14,   1e13,   1e12,   1e9,    1e6,    1e3,    1,      1e-3,   1e-6,   1e-9),
                                                                           {Exa}  (1e42,   1e39,   1e36,   1e33,   1e30,   1e27,   1e24,   1e21,   1e20,   1e19,   1e18,   1e17,   1e16,   1e15,   1e12,   1e9,    1e6,    1e3,    1,      1e-3,   1e-6),
                                                                         {Zetta}  (1e45,   1e42,   1e39,   1e36,   1e33,   1e30,   1e27,   1e24,   1e23,   1e22,   1e21,   1e20,   1e19,   1e18,   1e15,   1e12,   1e9,    1e6,    1e3,    1,      1e-3),
                                                                         {Yotta}  (1e48,   1e45,   1e42,   1e39,   1e36,   1e33,   1e30,   1e27,   1e26,   1e25,   1e24,   1e23,   1e22,   1e21,   1e18,   1e15,   1e12,   1e9,    1e6,    1e3,    1)
                                                                               );
  {$ENDREGION}

function SIMagnitudeConvert(const ASourceValue: ADFloat; const AFromMagnitude, AToMagnitude: TADSIMagnitude): ADFloat; inline;
function SIMagnitudeGetNotationText(const AMagnitude: TADSIMagnitude; const ANotation: TADSIUnitNotation): String; inline;
procedure SIMagnitudeToBest(const AInValue: ADFloat; const AInMagnitude: TADSIMagnitude; var AOutValue: ADFloat; var AOutMagnitude: TADSIMagnitude); overload; inline;
procedure SIMagnitudeToBest(var AValue: ADFloat; var AMagnitude: TADSIMagnitude); overload; inline;

implementation

function SIMagnitudeConvert(const ASourceValue: ADFloat; const AFromMagnitude, AToMagnitude: TADSIMagnitude): ADFloat;
begin
  Result := ASourceValue * AD_UNIT_MAGNITUDE_CONVERSIONTABLE_SI[AFromMagnitude, AToMagnitude];
end;

function SIMagnitudeGetNotationText(const AMagnitude: TADSIMagnitude; const ANotation: TADSIUnitNotation): String;
begin
  Result := AD_UNIT_MAGNITUDE_NAMES_SI[AMagnitude, ANotation];
end;

procedure SIMagnitudeToBest(var AValue: ADFloat; var AMagnitude: TADSIMagnitude);
begin
  { TODO -oDaniel -cSI Units : Implement method to determine most appropriate Order of Magnitude to represent given value }
end;

procedure SIMagnitudeToBest(const AInValue: ADFloat; const AInMagnitude: TADSIMagnitude; var AOutValue: ADFloat; var AOutMagnitude: TADSIMagnitude);
begin
  // Presume that no conversion is required.
  AOutValue := AInValue;
  AOutMagnitude := AInMagnitude;
  SIMagnitudeToBest(AOutValue, AOutMagnitude);
end;

end.
