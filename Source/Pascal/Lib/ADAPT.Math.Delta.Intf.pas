{
  AD.A.P.T. Library
  Copyright (C) 2014-2018, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Math.Delta.Intf;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes,
  {$ELSE}
    Classes,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT, ADAPT.Intf,
  ADAPT.Collections.Intf,
  ADAPT.Math.Common.Intf;

  {$I ADAPT_RTTI.inc}

type
  ///  <summary><c>Provides an algorithmic solution for calculating values beyond the range of fixed data points.</c></summary>
  IADExtrapolator<TKey, TValue> = interface(IADInterface)
    ///  <summary><c>Takes a Map of existing data points, calculates a rate of change, then returns the calculated value for the given Key Data Point.</c></summary>
    ///  <returns><c>The Calculated Value for the given Key Data Point.</c></returns>
    function Extrapolate(const AMap: IADMap<TKey, TValue>; const ADataPoint: TKey): TValue;
  end;

  ///  <summary><c>Provides an algorithmic solution for calculating values between fixed data points.</c></summary>
  IADInterpolator<TKey, TValue> = interface(IADInterface)
    ///  <summary><c>Takes a Map of existing data points, calculates a rate of change, then returns the calculated value for the given Key Data Point.</c></summary>
    ///  <returns><c>The Calculated Value for the given Key Data Point.</c></returns>
    function Interpolate(const AMap: IADMap<TKey, TValue>; const ADataPoint: TKey): TValue;
  end;

  ///  <summary><c>Stores n Values to enable calculations based on historical Values.</c></summary>
  ///  <remarks>
  ///    <para><c>Uses an IADInterpolator to calculate values between given data points.</c></para>
  ///    <para><c>Uses an IADExtrapolator to calculate values beyond given data points.</c></para>
  ///  </remarks>
  IADDeltaValue<T> = interface(IADInterface)
    // Getters
    ///  <returns><c>The Value at the given Delta (Reference Time).</c></returns>
    function GetValueAt(const ADelta: ADFloat): T;
    ///  <returns><c>The Value for the CURRENT Delta (Reference Time).</c></returns>
    function GetValueNow: T;

    // Setters
    ///  <summary><c>Defines a Known Value for a specific Delta (Reference Time).</c></summary>
    procedure SetValueAt(const ADelta: ADFloat; const AValue: T);
    ///  <summary><c>Defines a Known Value for the CURRENT Delta (Reference Time).</c></summary>
    procedure SetValueNow(const AValue: T);

    // Properties
    ///  <summary><c>Defines a Known Value for a specific Delta (Reference Time).</c></summary>
    ///  <returns><c>The Value at the given Delta (Reference Time).</c></returns>
    property ValueAt[const ADelta: ADFloat]: T read GetValueAt write SetValueAt; default;
    ///  <summary><c>Defines a Known Value for the CURRENT Delta (Reference Time).</c></summary>
    ///  <returns><c>The Value for the CURRENT Delta (Reference Time).</c></returns>
    property ValueNow: T read GetValueNow write SetValueNow;
  end;

implementation

end.
