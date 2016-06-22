# Customized Delphi Menu

## Synopsis
TLoadMenu is a **Delphi** class to create a customized menu on Delphi desktop applications, based on sidebar bootstrap menus that are popular on internet.

Example: [SmartAdmin theme](http://192.241.236.31/themes/preview/smartadmin/1.8.x/ajax/index.html#ajax/dashboard.html)

By using this class you will be able to create and edit tables using **DataSet classes pattern** through intuitive methods.

## Requirements

* [Delphi XE2+](https://www.embarcadero.com/products/delphi)

## Installation

Just add all these file in your project.

## API Reference

```delphi
// Creating a new CookieTable object
var menu : TLoadMenu;

menu := TLoadMenu.Create( oContainer, clRed );
```
### Public Methods

#### addItem(name,type)

Method to add items to the menu

##### Examples

```delphi
// Adding new fields
menu.addItem( 'id', ctFieldTypes.NUMBER );
```

## License (MIT)

Copyright (c) Valter Junior ("Author")

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
