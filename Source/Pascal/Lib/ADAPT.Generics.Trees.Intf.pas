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
unit ADAPT.Generics.Trees.Intf;


{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes, System.SysUtils,
  {$ELSE}
    Classes, SysUtils,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Common, ADAPT.Common.Intf,
  ADAPT.Generics.Defaults, ADAPT.Generics.Defaults.Intf,
  ADAPT.Generics.Arrays,
  ADAPT.Generics.Lists.Intf;

  {$I ADAPT_RTTI.inc}

type
  { Callback Types }
  {$IFDEF SUPPORTS_REFERENCETOMETHOD}
    TADTreeNodeValueCallbackAnon<V> = reference to procedure(const Value: V);
  {$ENDIF SUPPORTS_REFERENCETOMETHOD}
  TADTreeNodeValueCallbackOfObject<V> = procedure(const Value: V) of object;
  TADTreeNodeValueCallbackUnbound<V> = procedure(const Value: V);

  IADTreeNode<T> = interface(IADInterface)
    function GetChildCount: Integer;
    function GetDepth: Integer;
    function GetRootNode: IADTreeNode<T>;
    function GetParent: IADTreeNode<T>;
    function GetChild(const AIndex: Integer): IADTreeNode<T>;
    function GetIndexAsChild: Integer;
    function GetIsBranch: Boolean;
    function GetIsRoot: Boolean;
    function GetIsLeaf: Boolean;
    function GetValue: T;
    procedure SetValue(const AValue: T);

    procedure MoveTo(const ANewParent: IADTreeNode<T>; const AIndex: Integer = -1); overload;
    procedure MoveTo(const AIndex: Integer); overload;

    function IndexOf(const AChild: IADTreeNode<T>): Integer;

    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure PreOrderWalk(const AAction: TADTreeNodeValueCallbackAnon<IADTreeNode<T>>); overload;
      procedure PreOrderWalk(const AAction: TADTreeNodeValueCallbackAnon<T>); overload;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure PreOrderWalk(const AAction: TADTreeNodeValueCallbackOfObject<IADTreeNode<T>>); overload;
    procedure PreOrderWalk(const AAction: TADTreeNodeValueCallbackOfObject<T>); overload;
    procedure PreOrderWalk(const AAction: TADTreeNodeValueCallbackUnbound<IADTreeNode<T>>); overload;
    procedure PreOrderWalk(const AAction: TADTreeNodeValueCallbackUnbound<T>); overload;

    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure PostOrderWalk(const AAction: TADTreeNodeValueCallbackAnon<IADTreeNode<T>>); overload;
      procedure PostOrderWalk(const AAction: TADTreeNodeValueCallbackAnon<T>); overload;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure PostOrderWalk(const AAction: TADTreeNodeValueCallbackOfObject<IADTreeNode<T>>); overload;
    procedure PostOrderWalk(const AAction: TADTreeNodeValueCallbackOfObject<T>); overload;
    procedure PostOrderWalk(const AAction: TADTreeNodeValueCallbackUnbound<IADTreeNode<T>>); overload;
    procedure PostOrderWalk(const AAction: TADTreeNodeValueCallbackUnbound<T>); overload;

    property Depth: Integer read GetDepth;

    property Parent: IADTreeNode<T> read GetParent;
    property RootNode: IADTreeNode<T> read GetRootNode;
    property ChildCount: Integer read GetChildCount;
    property Children[const AIndex: Integer]: IADTreeNode<T> read GetChild; default;
    property IndexAsChild: Integer read GetIndexAsChild;

    property IsBranch: Boolean read GetIsBranch;
    property IsRoot: Boolean read GetIsRoot;
    property IsLeaf: Boolean read GetIsLeaf;

    property Value: T read GetValue write SetValue;
  end;

implementation

end.
