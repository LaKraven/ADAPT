{
  AD.A.P.T. Library
  Copyright (C) 2014-2018, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Math.Common.Intf;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes,
  {$ELSE}
    Classes,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT, ADAPT.Intf;

  {$I ADAPT_RTTI.inc}

type
  { Exceptions }
  EADMathException = class(EADException);
    EADMathAveragerException = class(EADMathException);
      EADMathAveragerListNotSorted = class(EADMathAveragerException);

  ///  <summary><c>An Extrapolator calculates Values beyond the range of Known (Reference) Values.</c></summary>
  IADExtrapolator<T> = interface(IADInterface)

  end;

  ///  <summary><c>An Object containing an Extrapolator.</c></summary>
  IADExtrapolatable<T> = interface(IADInterface)
  ['{0198D26B-6654-4E17-A4B0-2EFF1EF7025B}']
    // Getters
    ///  <returns><c>The Extrapolator used by this Object.</c></returns>
    function GetExtrapolator: IADExtrapolator<T>;

    // Setters
    ///  <summary><c>Defines the Extrapolator to be used by this Object.</c></returns>
    procedure SetExtrapolator(const AExtrapolator: IADExtrapolator<T>);

    // Properties
    ///  <summary><c>Defines the Extrapolator to be used by this Object.</c></returns>
    ///  <returns><c>The Extrapolator used by this Object.</c></returns>
    property Extrapolator: IADExtrapolator<T> read GetExtrapolator write SetExtrapolator;
  end;

  ///  <summary><c>An Interpolator calculates Values between Known (Reference) Values.</c></summary>
  IADInterpolator<T> = interface(IADInterface)

  end;

  ///  <summary><c>An Object containing an Interpolator.</c></summary>
  IADInterpolatable<T> = interface(IADInterface)
  ['{A66A8CEF-3030-4BF4-8187-6AFC2AD1E941}']
    // Getters
    ///  <returns>The Interpolator used by this Object.</c></returns>
    function GetInterpolator: IADInterpolator<T>;

    // Setters
    ///  <summary><c>Defines the Interpolator to be used by this Object.</c></summary>
    procedure SetInterpolator(const AInterpolator: IADInterpolator<T>);

    // Properties
    ///  <summary><c>Defines the Interpolator to be used by this Object.</c></summary>
    ///  <returns>The Interpolator used by this Object.</c></returns>
    property Interpolator: IADInterpolator<T> read GetInterpolator write SetInterpolator;
  end;

implementation

end.
