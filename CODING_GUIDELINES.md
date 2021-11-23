# Neos Coding Guidelines and Best Practises at Sandstorm

**VERSION: DRAFT**

These guidelines are based on the official Neos Best Practises found [here](https://docs.neos.io/cms/manual/best-practices).

This is a more opinionated and more detailed version on what we think is important when doing Neos projects at Sandstorm. These guidelines refer to the current Neos version.

[[_TOC_]]

## What this guide is intended for

* make it easier to share knowlege
* establish a common understanding on how we do Neos projects
* establish a common coding style in Neos projects
* to be guideline for people new to the Neos world
* be a reference point for code reviews
* be a foundation for discussions and further self improvement

## What this guide is NOT intended for

* replace other means of knowlege transfer e.g. by code reviews, as they are very important
* it does not replace reading the documentation

## Wording

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED",  "MAY", and "OPTIONAL" in this document are to be interpreted as described in [RFC 2119](https://www.ietf.org/rfc/rfc2119.txt).

## Guide

### Configuration

* Settings.XYZ.yaml for Packages Outside the Neos namespace
* wann in der Distribution wann im Package -> unsicher

### NodeTypes

#### Structure & Naming

* NodeTypes MUST be placed in `/NodeTypes` folder
* Each NodeType MUST be defined in a dedicated yaml-file and the file-name MUST represent the namespace of the contained NodeType. This helps finding the definition of a NodeType and get an understanding of the existing NodeTypes.
* `/NodeTypes` SHOULD be have the following subfolders with the corresponding filenames
  * `/Document` containing NodeTypes with supertype `Neos.Neos:Document`
  * `/Content` containing NodeTypes with supertype `Neos.Neos:Content`
  * `/ContentCollection` containing NodeTypes with supertype `Neos.Neos:ContentCollection`
  * `/Constraint` containing reusable configuration concerning constraints
  * `/Mixin` containing all other reusable configuration
  * `/Overrides` containing all other reusable configuration
* Filenames in these folders MUST be prefixed with the folder name. This helps identifying them in the IDE later
  easier.
  * `/Document`
    * `Document.Homepage.yaml`
    * `Document.Page.yaml`
  * same for other folders
* NodeType-files that modify NodeTypes from other Packages MUST have “Override” in the filename to show which aspects
  of other packages have been overriden. This is especially important for making updates.
  * `/Override`
    * `Override.Document.yaml` when overriding `Neos.Neos:Document`
    * `Override.Content.yaml` when overriding `Neos.Neos:Content`
* the NodeType name MUST include the folder name to make it easier to find the corresponding file for a given
  NodeType name
    * `/Document`
        * `MyVendor.AwesomeNeosProject:Document.Homepage`
        * `MyVendor.AwesomeNeosProject:Document.Page`
    * same for other folders
* Sub-NodeTypes that are bound to a specific parent NodeType MUST have a name matching the parent. You SHOULD also make
  sure the constraints are configured accordingly.
  * `MyVendor.AwesomeNeosProject:Content.Slider`
  * `MyVendor.AwesomeNeosProject:Content.Slider.Slide`

#### Inheritance & Mixins

* Mixins and Constraints MUST be `abstract: true`
* A NodeType SHOULD only inherit from a single non-abstract superType. All other superTypes SHOULD be Mixins, or Constraints. This helps keeping the inheritance chain understandable.
* We RECOMMEND not inheriting directly from `Neos.Neos:Document` or `Neos.Neos:Content` but from an abstract Nodetype. 
  ```yaml
  'MyVendor.AwesomeNeosProject:Content.AbstractContent':
    abstract: true
    superTypes:
      'Neos.Neos:Content': true
  ```
  ```yaml
  'MyVendor.AwesomeNeosProject:Document.AbstractPage':
    abstract: true
  superTypes:
    'Neos.Neos:Document': true
  constraints:
    nodeTypes:
      '*': ~
  ```
  This makes it easier to e.g. configure default constraints for all documents.

#### Constraints

Constraints SHOULD be configured to NOT allow any `childNodes` for `Neos.Neos:Document` and `Neos.Neos:ContentCollection` as a default. This makes it easier to correctly configure constraints for the editor. For this you SHOULD create on override for `Neos.Neos:Document`.

```yaml
# Override.Document.yaml
'Neos.Neos:Document':
  constraints:
    nodeTypes:
      '*': ~
      'Neos.Neos:Document': ~
```
TODO: double check `'*': ~` is needed as this allows the `'Neos.Neos:Document': ~` to work. There is a difference between `~` and `false`. TODO explain

For constraining content collections you may create reusable constraint configuration like so:

```yaml
# Constraint.Base.yaml
'MyVendor.AwesomeNeosProject:Constraints.Base':
  abstract: true
  constraints:
    nodeTypes:
      '*': ~ # TODO: explain, maybe check if overriding Neos.Neos:ContentCollection works and is more consistent
      'MyVendor.AwesomeNeosProject:Content.Text': true
      'MyVendor.AwesomeNeosProject:Content.Headline': true
      'MyVendor.AwesomeNeosProject:Content.Button': true
```

#### Properties

* Properties SHOULD only be editable by a single editor – either inline or in the inspector. Editing the same property with different editors like inspector and inline easily causes problems when settings are only slightly off.
* Each NodeType property MUST be valid after creating a new node. This can be done by defining the defaultValue or by allowing the property being empty. Especially SelectBoxEditors caused trouble in the past if they neither allowed being empty nor had good defaults.

#### Using other packages

* The Neos.Neos.NodeTypes package SHOULD NOT be used directly. We RECOMMEND to create NodeTypes in the project namespace. You MAY use the Mixins from Neos.Neos.NodeTypes.BaseMixins instead.
* The Neos.HTML node type MUST not be used

### Fusion

### Editor Happiness


