{
  AD.A.P.T. Library
  Copyright (C) 2014-2016, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
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
  ADAPT.Generics.Collections.Intf;

  {$I ADAPT_RTTI.inc}

type
  { Callback Types }
  {$IFDEF SUPPORTS_REFERENCETOMETHOD}
    TADTreeNodeValueCallbackAnon<V> = reference to procedure(const Value: V);
  {$ENDIF SUPPORTS_REFERENCETOMETHOD}
  TADTreeNodeValueCallbackOfObject<V> = procedure(const Value: V) of object;
  TADTreeNodeValueCallbackUnbound<V> = procedure(const Value: V);

  IADTreeNode<T> = interface(IADInterface)
    // Geters
    function GetChildCount: Integer;
    function GetDepth: Integer;
    function GetIsDestroying: Boolean;
    function GetRootNode: IADTreeNode<T>;
    function GetParent: IADTreeNode<T>;
    function GetChildren: IADList<IADTreeNode<T>>;
    function GetIndexAsChild: Integer;
    function GetIsBranch: Boolean;
    function GetIsRoot: Boolean;
    function GetIsLeaf: Boolean;
    function GetValue: T;
    // Setters
    procedure SetValue(const AValue: T);

    procedure AncestorChanged;
    procedure AddChild(const AIndex: Integer; const AChild: IADTreeNode<T>);
    procedure RemoveChild(const AChild: IADTreeNode<T>);

    // Management Methods
    procedure MoveTo(const ANewParent: IADTreeNode<T>; const AIndex: Integer = -1); overload;
    procedure MoveTo(const AIndex: Integer); overload;

    function IndexOf(const AChild: IADTreeNode<T>): Integer;

    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      ///  <summary><c>Steps recursively through the Tree from the current node, down, and executes the given Callback.</c></summary>
      procedure PreOrderWalk(const AAction: TADTreeNodeValueCallbackAnon<IADTreeNode<T>>); overload;
      ///  <summary><c>Steps recursively through the Tree from the current node, down, and executes the given Callback.</c></summary>
      procedure PreOrderWalk(const AAction: TADTreeNodeValueCallbackAnon<T>); overload;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    ///  <summary><c>Steps recursively through the Tree from the current node, down, and executes the given Callback.</c></summary>
    procedure PreOrderWalk(const AAction: TADTreeNodeValueCallbackOfObject<IADTreeNode<T>>); overload;
    ///  <summary><c>Steps recursively through the Tree from the current node, down, and executes the given Callback.</c></summary>
    procedure PreOrderWalk(const AAction: TADTreeNodeValueCallbackOfObject<T>); overload;
    ///  <summary><c>Steps recursively through the Tree from the current node, down, and executes the given Callback.</c></summary>
    procedure PreOrderWalk(const AAction: TADTreeNodeValueCallbackUnbound<IADTreeNode<T>>); overload;
    ///  <summary><c>Steps recursively through the Tree from the current node, down, and executes the given Callback.</c></summary>
    procedure PreOrderWalk(const AAction: TADTreeNodeValueCallbackUnbound<T>); overload;

    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      ///  <summary><c>Steps recursively through the Tree from the current node, up, and executes the given Callback.</c></summary>
      procedure PostOrderWalk(const AAction: TADTreeNodeValueCallbackAnon<IADTreeNode<T>>); overload;
      ///  <summary><c>Steps recursively through the Tree from the current node, up, and executes the given Callback.</c></summary>
      procedure PostOrderWalk(const AAction: TADTreeNodeValueCallbackAnon<T>); overload;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    ///  <summary><c>Steps recursively through the Tree from the current node, up, and executes the given Callback.</c></summary>
    procedure PostOrderWalk(const AAction: TADTreeNodeValueCallbackOfObject<IADTreeNode<T>>); overload;
    ///  <summary><c>Steps recursively through the Tree from the current node, up, and executes the given Callback.</c></summary>
    procedure PostOrderWalk(const AAction: TADTreeNodeValueCallbackOfObject<T>); overload;
    ///  <summary><c>Steps recursively through the Tree from the current node, up, and executes the given Callback.</c></summary>
    procedure PostOrderWalk(const AAction: TADTreeNodeValueCallbackUnbound<IADTreeNode<T>>); overload;
    ///  <summary><c>Steps recursively through the Tree from the current node, up, and executes the given Callback.</c></summary>
    procedure PostOrderWalk(const AAction: TADTreeNodeValueCallbackUnbound<T>); overload;

    ///  <summary><c>The Depth of the given Node relative to the Root.</c></summary>
    property Depth: Integer read GetDepth;

    property IsDestroying: Boolean read GetIsDestroying;

    ///  <summary><c>Reference to the Parent of the given Node.</c></summary>
    ///  <remarks><c>This reference would be Nil for the Root Node.</c></summary>
    property Parent: IADTreeNode<T> read GetParent;
    ///  <summary><c>Reference to the Root Node.</c></summary>
    ///  <remarks><c>This reference would be Self for the Root Node.</c></summary>
    property RootNode: IADTreeNode<T> read GetRootNode;
    ///  <summary><c>The number of Child Nodes directly beneath the given Node.</c></summary>
    property ChildCount: Integer read GetChildCount;
    ///  <summary><c>Returns the List of Children.</c></summary>
    property Children: IADList<IADTreeNode<T>> read GetChildren;
    ///  <summary><c>Returns the Index of the given Node relative to its Parent Node.</c></summary>
    ///  <remarks><c>Returns -1 if there is no Parent Node.</c></remarks>
    property IndexAsChild: Integer read GetIndexAsChild;

    ///  <summary><c>Is the given Node a Branch.</c></summary>
    property IsBranch: Boolean read GetIsBranch;
    ///  <summary><c>Is the given Node the Root.</c></summary>
    property IsRoot: Boolean read GetIsRoot;
    ///  <summary><c>Is the given Node a Leaf.</c></summary>
    property IsLeaf: Boolean read GetIsLeaf;

    ///  <summary><c>The Value specialized to the given Generic Type.</c></summary>
    property Value: T read GetValue write SetValue;
  end;

implementation

end.
