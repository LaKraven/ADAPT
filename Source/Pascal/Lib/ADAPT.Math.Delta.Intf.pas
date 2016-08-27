{
  AD.A.P.T. Library
  Copyright (C) 2014-2016, Simon J Stuart, All Rights Reserved

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
  ADAPT.Common, ADAPT.Common.Intf,
  ADAPT.Math.Common.Intf;

  {$I ADAPT_RTTI.inc}

type
  ///  <summary><c>Stores n Values to enable calculations based on historical Values.</c></summary>
  ///  <remarks>
  ///    <para><c></c></para>
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
    property ValueAt[const ADelta: ADFloat]: T read GetValueAt write SetValueAt;
    ///  <summary><c>Defines a Known Value for the CURRENT Delta (Reference Time).</c></summary>
    ///  <returns><c>The Value for the CURRENT Delta (Reference Time).</c></returns>
    property ValueNow: T read GetValueNow write SetValueNow;
  end;

implementation

end.
