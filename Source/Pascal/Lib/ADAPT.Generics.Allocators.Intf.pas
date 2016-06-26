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
unit ADAPT.Generics.Allocators.Intf;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes,
  {$ELSE}
    Classes,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Common.Intf;

  {$I ADAPT_RTTI.inc}

type
  ///  <summary><c>An Allocation Algorithm for Lists.</c></summary>
  ///  <remarks><c>Dictates how to grow an Array based on its current Capacity and the number of Items we're looking to Add/Insert.</c></remarks>
  IADCollectionExpander = interface(IADInterface)
  ['{B4742A80-74A7-408E-92BA-F854515B6D24}']
    function CheckExpand(const ACapacity, ACurrentcount, AAdditionalRequired: Integer): Integer;
  end;

  ///  <summary><c>A Geometric Allocation Algorithm for Lists.</c></summary>
  ///  <remarks>
  ///    <para><c>When the number of Vacant Slots falls below the Threshold, the number of Vacant Slots increases by the value of the current Capacity multiplied by the Mulitplier.</c></para>
  ///  </remarks>
  IADCollectionExpanderGeometric = interface(IADCollectionExpander)
  ['{CAF4B15C-9BE5-4A66-B31F-804AB752A102}']
    // Getters
    function GetCapacityMultiplier: Single;
    function GetCapacityThreshold: Integer;
    // Setters
    procedure SetCapacityMultiplier(const AMultiplier: Single);
    procedure SetCapacityThreshold(const AThreshold: Integer);
    // Properties
    property CapacityMultiplier: Single read GetCapacityMultiplier write SetCapacityMultiplier;
    property CapacityThreshold: Integer read GetCapacityThreshold write SetCapacityThreshold;
  end;

  ///  <summary><c>A Deallocation Algorithm for Lists.</c></summary>
  ///  <remarks><c>Dictates how to shrink an Array based on its current Capacity and the number of Items we're looking to Delete.</c></remarks>
  IADCollectionCompactor = interface(IADInterface)
  ['{B7D577D4-8425-4C5D-9DDB-5864C3676199}']
    function CheckCompact(const ACapacity, ACurrentCount, AVacating: Integer): Integer;
  end;

  ///  <summary><c>An Object requiring an Expander.</c></summary>
  IADExpandable = interface(IADInterface)
  ['{D14A0D38-48EF-4EAE-A25D-8CAD1F8B1035}']
    // Getters
    function GetExpander: IADCollectionExpander;
    // Setters
    procedure SetExpander(const AExpander: IADCollectionExpander);
    // Properties
    property Expander: IADCollectionExpander read GetExpander write SetExpander;
  end;

  ///  <summary><c>An Object requiring a Compactor.</c></summary>
  IADCompactable = interface(IADInterface)
  ['{F1C40D71-7899-482F-86E2-C052D2735013}']
    // Getters
    function GetCompactor: IADCollectionCompactor;
    // Setters
    procedure SetCompactor(const ACompactor: IADCollectionCompactor);
    // Properties
    property Compactor: IADCollectionCompactor read GetCompactor write SetCompactor;
  end;

implementation

end.
