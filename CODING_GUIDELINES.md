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

### Managing Dependencies / Loading Order

* You MUST use the pattern suggested [here](https://docs.neos.io/cms/manual/dependency-management). Otherwise you will run into loading order issues.
* In the composer.json of your distribution package you MUST require all dependencies of your root composer.json that you want to override in one or the other way.
  Otherwise you will run into loading order issues.
  ```
   "require": {
        "neos/neos": "*",
        "jonnitto/prettyembedvideo": "*",
        "jonnitto/prettyembedyoutube": "*",
    }
  ```

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

Constraints SHOULD be configured to NOT allow any `childNodes` for `Neos.Neos:Document` and `Neos.Neos:ContentCollection` as a default. This makes it easier to correctly configure constraints for the editor. For this you SHOULD create an override for `Neos.Neos:Document` and `Neos.Neos:ContentCollection`.

TODO DISCUSS: Override vs. Abstract NodeType

```yaml
# Override.Document.yaml
'Neos.Neos:Document':
  constraints:
    nodeTypes:
      '*': ~
      'Neos.Neos:Document': ~
```

```yaml
# Override.ContentCollection.yaml
'Neos.Neos:ContentCollection':
  constraints:
    nodeTypes:
      'Neos.Neos:Document': false
      # This might break when using abstract NodeTypes -> see https://github.com/neos/neos-development-collection/issues/3212
      '*': ~
```

TODO: explanation on why we use null instead of false

* For constraining content collections we RECOMMEND creating reusable constraint configuration like so:

```yaml
# Constraint.Base.yaml
'MyVendor.AwesomeNeosProject:Constraints.Base':
  abstract: true
  constraints:
    nodeTypes:
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

* The Root.Fusion in a project MUST not contain anything but includes.
* All fusion files MUST be placed in `Resources/Private/Fusion` otherwise changes will not be picked up, although they 
  might have been included in the `Root.fusion`
* The minimal folder structure for fusion files MUST look like this
  * `/Integration`
    * `/Document`
    * `/Content`
  * `/Presentation`
    * `/Components`

* Integrational Fusion prototypes (also called integrational components) are used to query and preprocess data of nodes. The processed
  data is then passed on to presentational Fusion prototypes (also called presentational components).

#### Integration

* We RECOMMEND using an "abstract" Fusion prototypes to be reused for rendering different neos pages.
  ```neosfusion
  prototype(MyVendor.AwesomeNeosProject:Document.AbstractPage) < prototype(Neos.Neos:Page) {
    // ...
  }
  ```
* Each non abstract `Neos.Neos:Document` NodeType MUST have a corresponding Fusion prototype in `/Integration/Document`
  * The Fusion prototype SHOULD extend `MyVendor.AwesomeNeosProject:Document.AbstractPage`
  * The filename MUST start with `Document.`. This way we can easily find the Fusion prototype 
    for the corresponding NodeType and vice versa
    * `Document.Homepage.yaml`
    * `Document.Homepage.fusion`
    * `MyVendor.AwesomeNeosProject:Document.Homepage`
* Each non abstract `Neos.Neos:Content` NodeType with MUST have a corresponding Fusion prototype in `/Integration/Content`
  * The Fusion prototype SHOULD extend `Neos.Neos:ContentComponent`
  * The filename MUST start with `Content.`. This way we can easily find the Fusion prototype 
    for the corresponding NodeType and vice versa
    * `Content.Text.yaml`
    * `Content.Text.fusion`
    * `MyVendor.AwesomeNeosProject:Content.Text`
* ONLY fusion files ARE ALLOWED be placed inside `/Integration`. E.g. css and html are only relevant for presentational
  components that can be found in a different part of the folder structure.
* Your MUST NEVER extend from `Neos.Neos:ContentComponent` except for integrational components
* You MUST NEVER extend from `Neos.Neos:Document` except for integrational components

#### Presentation

##### Components

* You SHOULD structure the rendering of you markup in reusable components
* We recommend extending from `Neos.Fusion:Component`.
* Inside `Presentation/Components` each component should be place in a separate folder
  * all files needed to render this component should also be place here
  * `/Button` 
    * `Button.fusion`
    * `Button.scss`
    * `Button.ts`
* You MUST declare all props at the beginning of your component, by providing a default value
  ```neosfusion
  prototype(MyVendor.AwesomeNeosProject:Component.Button) < prototype(Neos.Fusion:Component) {
      text = ''
      href = ''
      renderer = afx`<a href={props.href}>{props.text}</a>`
  }
  ```
* You MUST type all of your props using `@propTypes`
  ```neosfusion
  prototype(MyVendor.AwesomeNeosProject:Component.Button) < prototype(Neos.Fusion:Component) {
      text = ''
      href = ''
        
      @propTypes {
          @strict = true
          text = ${PropTypes.string}
          href = ${PropTypes.string}
      }
  
      renderer = afx`<a href={props.href}>{props.text}</a>`
  }
  ```
* You SHOULD use `@stric = true` to have more control over what is passed into your components.
* You SHOULD not repurpose props as internal are computed "variables" as will not be able to use @strict = true
  without also typing your computed variable
  ```neosfusion
  prototype(MyVendor.AwesomeNeosProject:Component.Button) < prototype(Neos.Fusion:Component) {
      text = ''
      href = ''
  
      @propTypes {
          @strict = true
          text = ${PropTypes.string}
          href = ${PropTypes.string}
          // BAD
          _computedText = ${PropTypes.string}
      }
  
      _computedText = ${'[' + props.text + ']'}
  
      renderer = afx`<a href={props.href}>{props._computedText}</a>`
  }
  ```
* You SHOULD start with the following structure for each new components, as this makes it easier to
  implement internal and computed "variables" also reducing the need to implement patterns like 
  `this.someVar ...` or `@contex.someVar ...`
  ```neosfusion
  prototype(MyVendor.AwesomeNeosProject:Component.Button) < prototype(Neos.Fusion:Component) {
      text = ''
      href = ''
       
      @propTypes {
          @strict = true
          text = ${PropTypes.string}
          href = ${PropTypes.string}
      }
  
      renderer = Neos.Fusion:Component {
         @apply.props = props
         _computedText = ${PropTypes.string}
  
         renderer = afx`<a href={props.href}>{props._computedText}</a>`
      }
  }
  ```
* You SHOULD prefix variables inside the render with an `_` -> `_computedText` so we can differentiate them
  from actual props. `props.text` vs. `props._computedText`
* You SHOULD not load data from a node inside a presentational component. This makes it harder to reuse and test components.

##### Layouts and Others

##### AFX vs. Fluid

#### Connecting Integration with Presentation

* We RECOMMEND to process nodes before passing them to a presentational component

### Editor Happiness


