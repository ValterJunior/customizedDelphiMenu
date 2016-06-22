unit uLoadMenu;

interface

uses WinApi.Windows, Vcl.Forms, Vcl.ExtCtrls, Vcl.ImgList, Math, Classes, ClassNewPanel, Vcl.StdCtrls, Generics.Collections,
     Vcl.Graphics, Vcl.Controls, SysUtils, uNewScrollBox, System.JSON;

type

  TAlignMenu = (amLeft, amCenter, amRight);
  TTypeIcon  = (tiNone,tiImage, tiFontAwesome);

  TProcessMenuClick    = procedure( name, text : String ) of object;
  TLoadMenuItem        = class;
  TLoadMenuItemList    = TObjectDictionary<String,TLoadMenuItem>;
  TLoadMenuOrderedList = TList<String>;

  TGroupMenuItem = class
  private
    fHeaderObject     : TControl;
    fContainerObject  : TControl;
    fIconOpenedObject : TControl;
    fIconClosedObject : TControl;
    fIndicatorObject  : TControl;
    fMenuItem         : TLoadMenuItem;
    procedure changeDropDownIcon( opened : Boolean );
  public
    constructor Create( menuItem : TLoadMenuItem; header : TControl; container : TControl = nil; iconOpened : TControl = nil; iconClosed : TControl = nil; indicator : TControl = nil );
    function getHeaderObject     : TControl;
    function getContainerObject  : TControl;
    function getIconOpenedObject : TControl;
    function getIconClosedObject : TControl;
    function getIndicatorObject  : TControl;
    function isOpened : Boolean;
    function hasContainer : Boolean;
    procedure open;
    procedure close;
    procedure enableIndicator;
    procedure disableIndicator;
  end;

  TLoadMenuItem = class
  protected
    fName              : String;
    fParent            : TLoadMenuItem;
    fText              : String;
    fItems             : TLoadMenuItemList;
    fItemsOrdered      : TLoadMenuOrderedList;
    fImageIndex        : Integer;
    fFontAwesomeCode   : WideChar;
    fTypeIcon          : TTypeIcon;
    fOnClick           : TProcessMenuClick;
    fLastHeaderDrawPos : Integer;
    fLastChildDrawPos  : Integer;
    fGroupMenuItem     : TGroupMenuItem;
    fEnabled           : Boolean;
    procedure setParent( parent : TLoadMenuItem );
    procedure setEnabled( enabled : Boolean );
  public
    constructor Create( name, text : String; onClick : TProcessMenuClick = nil ); overload;
    constructor Create( name, text : String; imageIndex : Integer; onClick : TProcessMenuClick = nil ); overload;
    constructor Create( name, text : String; fontAwesomeCode : WideChar; onClick : TProcessMenuClick = nil ); overload;
    destructor Destroy; override;
    function getText            : String;
    function getItems           : TLoadMenuItemList;
    function getItemsOrdered    : TLoadMenuOrderedList;
    function getImageIndex      : Integer;
    function getFontAwesomeCode : WideChar;
    function getTypeIcon        : TTypeIcon;
    function getGroupMenuItem   : TGroupMenuItem;
    function addItem( name, text : String; onClick : TProcessMenuClick = nil ) : TLoadMenuItem; overload;
    function addItem( name, text : String; imageIndex : Integer; onClick : TProcessMenuClick = nil ) : TLoadMenuItem; overload;
    function addItem( name, text : String; fontAwesomeCode : WideChar; onClick : TProcessMenuClick = nil ) : TLoadMenuItem; overload;
    function hasChildren : Boolean;
    function getParent : TLoadMenuItem;
    function getLastHeaderDrawPos : Integer;
    function getLastChildDrawPos : Integer;
    function getName : String;
    function getLevel : Integer;
    function hasParent : Boolean;
    function hasGroupMenuItem : Boolean;
    procedure setGroupMenuItem( header : TControl; container : TControl = nil; iconOpened : TControl = nil; iconClosed : TControl = nil; indicator : TControl = nil );
    procedure setLastHeaderDrawPos( drawPos : Integer );
    procedure setLastChildDrawPos( drawPos : Integer );
    property OnClick : TProcessMenuClick read fOnClick;
    property Enabled : Boolean read fEnabled write setEnabled;
  end;

  TLoadMenu = class
  private
    fContHeader          : Integer;
    fContChild           : Integer;
    fContItems            : Integer;
    fContTopHeader       : Integer;
    fLastContainerOpened : String;
    fAlignMenu           : TAlignMenu;
    fDropDownIconType    : TTypeIcon;
    WIDTH_DEFAULT        : Integer;
    ALIGN_DEFAULT        : TAlignMenu;
    procedure enableMenuCompacted( menu : TLoadMenuItem; enable: Boolean);
    procedure relocateMenu;
    procedure closeOtherItems(currentlyOpened: TLoadMenuItem);
    const TEXT_MARGIN = 10;
    const ICON_FONT_MARGIN = 10;
    const INDICATOR_WIDTH = 5;
    const COMPACT_WIDTH = 40;
    CONST BOTTOM_MARGIN = 40;
    const KEY_CONTAINER = '_container';
    const KEY_INDICATOR = '_indicator';
    const KEY_HEADER    = '_menuheader';
    const KEY_DROPCLOSE = '_dropclose';
    const KEY_DROPOPEN  = '_dropopen';
    const FATOR_LEVEL   = 8;
    function formatJsonParam( item : TLoadMenuItem ) : String;
    function getJsonParamToString( content : String; var name : String; var text : String ) : Boolean;
    function getMenuItemByName( name : String ) : TLoadMenuItem; overload;
    function getMenuItemByName( listItems : TLoadMenuItemList; name : String ) : TLoadMenuItem; overload;
    function newIndicator( parent : TWinControl; menu : TLoadMenuItem = nil ) : TNewPanel;
    function newImageIcon( parent : TWinControl; imageIndex : Integer; menu : TLoadMenuItem = nil ) : TImage;
    function newFontIcon( parent : TWinControl; code : WideChar; menu : TLoadMenuItem = nil ) : TLabel;
    function createNewHeader( menu : TLoadMenuItem; parent : TNewPanel = nil ) : TNewPanel;
    procedure createNewChild( container : TNewPanel; item : TLoadMenuItem );
    procedure setFontAwesomeConfig( iconFont : TLabel; code : WideChar );
    procedure OnClickMenu( Sender : TObject );
    procedure OnClickChild( Sender : TObject );
    procedure OnMouseEnterMenu( Sender : TObject );
    procedure OnMouseExitMenu( Sender : TObject );
    procedure OnMouseEnterChild( Sender : TObject );
    procedure OnMouseExitChild( Sender : TObject );
    procedure OnMouseExitScrollChild( Sender : TObject );
    procedure freeItemsMenu;
  protected
    fMenuItems : TLoadMenuItemList;
    fMenuOrdered : TLoadMenuOrderedList;
    fComponentParent : TNewScrollBox;
    fPanelBase : TNewPanel;
    fHeaderHeight : Integer;
    fChildHeight : Integer;
    fHeaderGradientColorStart      : TColor;
    fHeaderGradientColorEnd        : TColor;
    fHeaderFontColor               : TColor;
    fHeaderHoverGradientColorStart : TColor;
    fHeaderHoverGradientColorEnd   : TColor;
    fChildGradientColorStart       : TColor;
    fChildGradientColorEnd         : TColor;
    fChildFontColor                : TColor;
    fChildHoverColorStart          : TColor;
    fChildHoverColorEnd            : TColor;
    fIndicatorColorStart           : TColor;
    fIndicatorColorEnd             : Tcolor;
    fCursor                        : TCursor;
    fShowIndicator                 : Boolean;
    fImageList                     : TImageList;
    fClosedIconImageIndex          : Integer;
    fOpenedIconImageIndex          : Integer;
    fClosedIconFontCode            : WideChar;
    fOpenedIconFontCode            : WideChar;
    fCompacted                     : Boolean;
    fFontAwesomeName               : String;
    fFontAwesomeSize               : Integer;
    fFontAwesomeHeight             : Integer;
    fFontAwesomeColor              : TColor;
    fEnabled                       : Boolean;
    procedure alignLabelPosition( level : Integer; oLabel : TLabel; icon : TImage = nil; iconFont : TLabel = nil );
    procedure setCompact( compact : Boolean );
    procedure setEnabled( enabled : Boolean );
  public
    constructor Create( componentBase : TNewScrollBox; colorBaseStart, colorBaseEnd : TColor ); overload;
    constructor Create( componentBase : TNewScrollBox; colorBase : TColor ); overload;
    destructor Destroy; override;
    function addMenu( name, text : String; onClick : TProcessMenuClick = nil ) : TLoadMenuItem; overload;
    function addMenu( name, text : String; imageIndex : Integer; onClick : TProcessMenuClick = nil ) : TLoadMenuItem; overload;
    function addMenu( name, text : String; fontAwesomeCode : WideChar; onClick : TProcessMenuClick = nil ) : TLoadMenuItem; overload;
    procedure load;
    procedure clear;
    procedure closeAll;
    procedure showIndicator( show : Boolean );
    procedure setHeaderHeight( height : Integer );
    procedure setHeaderBackgroundColor( startColor, endColor : TColor ); overload;
    procedure setHeaderBackgroundColor( color : TColor ); overload;
    procedure setHeaderFontColor( color : TColor );
    procedure setHeaderHoverColor( color : TColor ); overload;
    procedure setHeaderHoverColor( colorStart, colorEnd : TColor ); overload;
    procedure setChildHeight( height : Integer );
    procedure setChildBackgroundColor( startColor, endColor : TColor ); overload;
    procedure setChildBackgroundColor( color : TColor ); overload;
    procedure setChildHoverColor( startColor, endColor : TColor ); overload;
    procedure setChildHoverColor( color : TColor ); overload;
    procedure setChildFontColor( color : TColor );
    procedure setIndicatorColor( startColor, endColor : TColor ); overload;
    procedure setIndicatorColor( color : TColor ); overload;
    procedure setCursor( cursor : TCursor );
    procedure setAlign( align : TAlignMenu );
    procedure setImageList( imgList : TImageList );
    procedure setDropDownIndexes( upIndex, downIndex : Integer );
    procedure setDropDownFonts( upFont, downFont : WideChar );
    procedure setFontAwesomeName( name : String );
    procedure setFontAwesomeSize( size : Integer );
    procedure setFontAwesomeHeight( height : Integer );
    procedure setFontAwesomeColor( color : TColor );
    procedure compactMenu;
    procedure expandMenu;
    property Enabled : Boolean read fEnabled write setEnabled;
  end;

implementation

{ TLoadMenu }

function TLoadMenu.addMenu( name, text : String; onClick : TProcessMenuClick = nil ) : TLoadMenuItem;
begin

  if fMenuItems.ContainsKey( name ) then
    raise Exception.Create('O item de nome "' + name + '" já foi adicionado' )
  else
    begin

      result := TLoadMenuItem.Create( name, text, onClick );

      fMenuItems.Add( name, result );
      fMenuOrdered.Add( name );

    end;

end;

function TLoadMenu.addMenu( name, text : String; imageIndex : Integer; onClick : TProcessMenuClick = nil ) : TLoadMenuItem;
begin

  if fMenuItems.ContainsKey( name ) then
    raise Exception.Create('O item de nome "' + name + '" já foi adicionado' )
  else
    begin

      result := TLoadMenuItem.Create( name, text, imageIndex, onClick );

      fMenuItems.add( name, result );
      fMenuOrdered.Add( name );

    end;

end;

function TLoadMenu.addMenu( name, text : String; fontAwesomeCode : WideChar; onClick : TProcessMenuClick = nil ) : TLoadMenuItem;
begin

  if fMenuItems.ContainsKey( name ) then
    raise Exception.Create('O item de nome "' + name + '" já foi adicionado' )
  else
    begin

      result := TLoadMenuItem.Create( name, text, fontAwesomeCode, onClick );

      fMenuItems.Add( name, result );
      fMenuOrdered.Add( name );

    end;

end;

procedure TLoadMenu.alignLabelPosition(level : Integer; oLabel: TLabel; icon : TImage = nil; iconFont : TLabel = nil);
var
  pictureWidth, indicatorWidth   : Integer;
  hasIcon, hasIconFont, hasLabel : Boolean;
begin

  pictureWidth   := 0;
  indicatorWidth := 0;
  hasIcon        := (icon <> nil);
  hasIconFont    := (iconFont <> nil);
  hasLabel       := (oLabel <> nil);

  if fShowIndicator then
    indicatorWidth := INDICATOR_WIDTH;

  if hasIcon then
    pictureWidth := icon.Picture.Width
  else if hasIconFont then
    pictureWidth := iconFont.Width;

  case fAlignMenu of

    amLeft  :
      begin

        if hasIcon then
          icon.Left := indicatorWidth + TEXT_MARGIN + (level * FATOR_LEVEL)
        else if hasIconFont then
          iconFont.Left := indicatorWidth + TEXT_MARGIN + (level * FATOR_LEVEL);;

        if hasLabel then
          begin
            oLabel.Alignment := taLeftJustify;
            oLabel.Left      := indicatorWidth + TEXT_MARGIN + pictureWidth + TEXT_MARGIN + (level * FATOR_LEVEL);
          end;

      end;

    amCenter:
      begin

        if hasIcon then
          begin

            if hasLabel then
              icon.Left := trunc( (icon.Parent.Width - indicatorWidth) / 2 ) - trunc( (pictureWidth + TEXT_MARGIN + oLabel.Width) / 2)
            else
              icon.Left := trunc( (icon.Parent.Width - indicatorWidth) / 2 ) - trunc( pictureWidth / 2);

          end
        else if hasIconFont then
          begin

            if hasLabel then
              iconFont.Left := trunc( (iconFont.Parent.Width - indicatorWidth) / 2 ) - trunc( (pictureWidth + TEXT_MARGIN + oLabel.Width) / 2)
            else
              iconFont.Left := trunc( (iconFont.Parent.Width - indicatorWidth) / 2 ) - trunc( pictureWidth / 2);

          end;

        if hasLabel then
          begin
            oLabel.Alignment := taLeftJustify;
            oLabel.Left      := ( trunc( (oLabel.Parent.Width - indicatorWidth) / 2 ) - trunc( (pictureWidth + TEXT_MARGIN + oLabel.Width) / 2) ) + pictureWidth + TEXT_MARGIN;
          end;

      end;

    amRight :
      begin

        if hasIcon then
          icon.Left := icon.Parent.Width - pictureWidth - TEXT_MARGIN - (level * FATOR_LEVEL)
        else if hasIconFont then
          iconFont.Left := iconFont.Parent.Width - pictureWidth - TEXT_MARGIN -  (level * FATOR_LEVEL);

        if hasLabel then
          begin
            oLabel.Alignment := taRightJustify;
            oLabel.Left      := oLabel.Parent.Width - oLabel.Width - pictureWidth - TEXT_MARGIN - TEXT_MARGIN -  (level * FATOR_LEVEL);
          end;

      end;

  end;

end;

procedure TLoadMenu.clear;
begin
  freeItemsMenu;
end;

procedure TLoadMenu.compactMenu;
begin
  setCompact( true );
end;

constructor TLoadMenu.Create(componentBase: TNewScrollBox; colorBase: TColor);
begin
  Create( componentBase, colorBase, colorBase );
end;

constructor TLoadMenu.Create( componentBase : TNewScrollBox; colorBaseStart, colorBaseEnd : TColor );
begin

  fComponentParent := componentBase;
  WIDTH_DEFAULT    := componentBase.Width;

  fPanelBase                    := TNewPanel.Create(fComponentParent);
  fPanelBase.Parent             := fComponentParent;
  fPanelBase.ColorGradientStart := colorBaseStart;
  fPanelBase.ColorGradientEnd   := colorBaseEnd;
  fPanelBase.Width              := componentBase.Width;
  fPanelBase.Height             := componentBase.Height;

  fMenuItems   := TLoadMenuItemList.Create( [doOwnsValues] );
  fMenuOrdered := TLoadMenuOrderedList.Create;

  fContHeader := 0;
  fContChild  := 0;
  fContItems   := 0;

  fHeaderGradientColorStart      := fPanelBase.ColorGradientStart;
  fHeaderGradientColorEnd        := fPanelBase.ColorGradientEnd;
  fHeaderHoverGradientColorStart := fPanelBase.ColorGradientStart;
  fHeaderHoverGradientColorEnd   := fPanelBase.ColorGradientEnd;
  fHeaderFontColor               := fPanelBase.Font.Color;
  fIndicatorColorStart           := fPanelBase.ColorGradientStart;
  fIndicatorColorEnd             := fPanelBase.ColorGradientEnd;
  fHeaderHeight                  := 30; // Default

  fChildGradientColorStart  := fPanelBase.ColorGradientStart;
  fChildGradientColorEnd    := fPanelBase.ColorGradientEnd;
  fChildHoverColorStart     := fPanelBase.ColorGradientStart;
  fChildHoverColorEnd       := fPanelBase.ColorGradientEnd;
  fChildFontColor           := fPanelBase.Font.Color;
  fChildHeight              := 30; // Default

  fFontAwesomeName   := 'Fontawesome';
  fFontAwesomeSize   := 12; // Default
  fFontAwesomeHeight := 15; // Default
  fFontAwesomeColor  := fHeaderFontColor;

  fCursor               := crHandPoint;
  fLastContainerOpened  := '';
  fAlignMenu            := amLeft;
  ALIGN_DEFAULT         := amLeft;
  fImageList            := nil;
  fClosedIconImageIndex := -1;
  fOpenedIconImageIndex := -1;
  fCompacted            := false;

end;

procedure TLoadMenu.createNewChild(container: TNewPanel; item : TLoadMenuItem );
var
  child     : TNewPanel;
  textLabel : TLabel;
  text : String;
  icon : TImage;
  iconFont : TLabel;
  imageIndex : Integer;
  fontAwesomeCode : WideChar;
  topChild : Integer;

begin

  text            := item.getText;
  imageIndex      := item.getImageIndex;
  fontAwesomeCode := item.getFontAwesomeCode;

  inc( fContChild );

  if fCompacted then
    begin

      if item.hasParent then
        topChild := item.getParent.getLastHeaderDrawPos
      else
        topChild := fContTopHeader;

    end
  else
    topChild := item.getParent.getLastChildDrawPos;

  // Container do item
  child          := TNewPanel.Create(container);
  child.Parent   := container;
  child.ShowHint := false;
  child.Top      := topChild;
  child.Height   := fChildHeight;

  if fCompacted then
    child.Width := WIDTH_DEFAULT
  else
    child.Width := container.Width;

  child.Name               := '_item' + intToStr( fContChild );
  child.Caption            := '';
  child.ColorGradientStart := fChildGradientColorStart;
  child.ColorGradientEnd   := fChildGradientColorEnd;
  child.Font.Color         := fChildFontColor;
  child.Cursor             := fCursor;
  child.OnMouseEnter       := OnMouseEnterChild;
  child.OnMouseLeave       := OnMouseExitChild;
  child.Hint               := formatJsonParam( item );
  child.OnClick            := onClickChild;

  // Alignment text child
  child.Alignment := taLeftJustify;

  if fCompacted then
    begin
      // Quando em modo compactado, uso apenas 1 contador pois header e child estão no mesmo container
      if item.hasParent then
        item.getParent.setLastHeaderDrawPos( topChild + child.Height )
      else
        inc( fContTopHeader, child.Height );
    end
  else
    item.getParent.setLastChildDrawPos( item.getParent.getLastChildDrawPos + child.Height );

  icon     := nil;
  iconFont := nil;

  // Desenhando imagem padrão do menu
  case item.getTypeIcon of
    tiImage      : icon     := newImageIcon( child, imageIndex );
    tiFontAwesome: iconFont := newFontIcon( child, fontAwesomeCode );
  end;
  
  // Label para o item
  textLabel := TLabel.Create(child);
  textLabel.Parent       := child;
  textLabel.AutoSize     := true;
  textLabel.Top          := trunc( child.Height / 2 ) - trunc(textLabel.Height/2);
  textLabel.Caption      := text;
  textLabel.Font.Color   := fChildFontColor;
  textLabel.Transparent  := true;
  textLabel.Cursor       := fCursor;
  textLabel.OnMouseEnter := OnMouseEnterChild;
  textLabel.OnMouseLeave := OnMouseExitChild;
  textLabel.Hint         := formatJsonParam( item );
  textLabel.OnClick      := onClickChild;

  item.setGroupMenuItem( child );

  alignLabelPosition(item.getLevel, textLabel, icon, iconFont);

end;

function TLoadMenu.createNewHeader( menu : TLoadMenuItem; parent : TNewPanel = nil ): TNewPanel;
var
  header : TNewPanel;
  indicator : TNewPanel;
  scrollBox : TNewScrollBox;
  textLabel : TLabel;
  name, containerName, headerName : String;
  icon, closedIconImage, openedIconImage : TImage;
  closedIconFont, openedIconFont : TLabel;
  iconFont : TLabel;
  startOpened : Boolean;
  imageIndex, countItems, topHeader : Integer;
  fontAwesomeCode : WideChar;
  parentContainer : TNewPanel;
  iconDropDownOpened, iconDropDownClosed : TControl;
begin

  name            := menu.getText;
  imageIndex      := menu.getImageIndex;
  fontAwesomeCode := menu.getFontAwesomeCode;
  countItems      := menu.getItems.Count;

  if menu.hasParent then
    topHeader := menu.getParent.getLastHeaderDrawPos
  else
    topHeader := fContTopHeader;

  inc( fContHeader );
  containerName := KEY_CONTAINER + intToStr( fContHeader );
  headerName    := KEY_HEADER + intToStr( fContHeader );
  startOpened   := (not fLastContainerOpened.Trim.IsEmpty) and containerName.Trim.Equals(fLastContainerOpened);

  if parent <> nil then
    parentContainer := parent
  else
    parentContainer := fPanelBase;

  // Panel Header
  header := TNewPanel.Create( parentContainer );
  header.Parent             := parentContainer;
  header.ColorGradientStart := fHeaderGradientColorStart;
  header.ColorGradientEnd   := fHeaderGradientColorEnd;
  header.Top                := topHeader;
  header.Height             := fHeaderHeight;
  header.Width              := parentContainer.Width;
  header.Name               := headerName;
  header.Caption            := '';
  header.ShowHint           := false;
  header.Hint               := formatJsonParam( menu );
  header.Cursor             := fCursor;

  header.OnClick      := OnClickMenu;
  header.OnMouseEnter := OnMouseEnterMenu;
  header.OnMouseLeave := OnMouseExitMenu;

  if menu.hasParent then
    menu.getParent.setLastHeaderDrawPos( topHeader + header.Height )
  else
    inc( fContTopHeader, header.Height );

  indicator          := nil;
  iconDropDownOpened := nil;
  iconDropDownClosed := nil;
  icon               := nil;
  iconFont           := nil;
  textLabel          := nil;

  // Indicator
  if fShowIndicator then
    indicator := newIndicator( header );

  // Desenhando imagem padrão do menu
  case menu.getTypeIcon of
    tiImage      : icon     := newImageIcon( header, imageIndex, menu );
    tiFontAwesome: iconFont := newFontIcon( header, fontAwesomeCode, menu );
  end;

  if (not fCompacted) or menu.hasParent then
      case fDropDownIconType of
        tiImage:
          begin

            // Desenhando dropdown icones
            if (fClosedIconImageIndex >= 0) and (fOpenedIconImageIndex >= 0) then
              begin

                // Ícone drop closed
                closedIconImage := TImage.Create( header );
                closedIconImage.Parent := header;
                closedIconImage.Name   := KEY_DROPCLOSE + intToStr( fContHeader );
                closedIconImage.Hint   := formatJsonParam( menu );

                fImageList.GetIcon( fClosedIconImageIndex, closedIconImage.Picture.Icon );

                closedIconImage.AutoSize := true;
                closedIconImage.Top      := trunc(header.Height / 2) - trunc(closedIconImage.Picture.Height / 2);
                closedIconImage.Left     := header.Width - closedIconImage.Picture.Width - TEXT_MARGIN;

                closedIconImage.OnClick := OnClickMenu;
                closedIconImage.OnMouseEnter := OnMouseEnterMenu;

                closedIconImage.Visible := not startOpened;

                iconDropDownClosed := closedIconImage;

                // Ícone drop opened
                openedIconImage := TImage.Create( header );
                openedIconImage.Parent := header;
                openedIconImage.Name   := KEY_DROPOPEN + intToStr( fContHeader );
                openedIconImage.Hint   := formatJsonParam( menu );

                fImageList.GetIcon( fOpenedIconImageIndex, openedIconImage.Picture.Icon );

                openedIconImage.AutoSize := true;
                openedIconImage.Top  := trunc(header.Height / 2) - trunc(openedIconImage.Picture.Height / 2);
                openedIconImage.Left := header.Width - openedIconImage.Picture.Width - TEXT_MARGIN;

                openedIconImage.Visible := startOpened;

                openedIconImage.OnClick := OnClickMenu;
                openedIconImage.OnMouseEnter := OnMouseEnterMenu;

                iconDropDownOpened := openedIconImage;

              end;

          end;

        tiFontAwesome:
          begin

            if not String(fClosedIconFontCode).IsEmpty and not String(fOpenedIconFontCode).IsEmpty then
              begin

                // Ícone drop closed
                closedIconFont        := TLabel.Create( header );
                closedIconFont.Parent := header;
                closedIconFont.Name   := KEY_DROPCLOSE + intToStr( fContHeader );
                closedIconFont.Hint   := formatJsonParam( menu );

                setFontAwesomeConfig( closedIconFont, fClosedIconFontCode );

                closedIconFont.AutoSize := true;
                closedIconFont.Top      := trunc(header.Height / 2) - trunc(closedIconFont.Height / 2);
                closedIconFont.Left     := header.Width - TEXT_MARGIN - ICON_FONT_MARGIN;

                closedIconFont.OnClick      := OnClickMenu;
                closedIconFont.OnMouseEnter := OnMouseEnterMenu;

                closedIconFont.Visible := not startOpened;

                iconDropDownClosed := closedIconFont;

                // Ícone drop opened
                openedIconFont := TLabel.Create( header );
                openedIconFont.Parent := header;
                openedIconFont.Name   := KEY_DROPOPEN + intToStr( fContHeader );
                openedIconFont.Hint   := formatJsonParam( menu );

                setFontAwesomeConfig( openedIconFont, fOpenedIconFontCode );

                openedIconFont.AutoSize := true;
                openedIconFont.Top      := trunc(header.Height / 2) - trunc(openedIconFont.Height / 2);
                openedIconFont.Left     := header.Width - TEXT_MARGIN - ICON_FONT_MARGIN;

                openedIconFont.Visible := startOpened;

                openedIconFont.OnClick := OnClickMenu;
                openedIconFont.OnMouseEnter := OnMouseEnterMenu;

                iconDropDownOpened := openedIconFont;

              end;

          end;

      end;

  if (not fCompacted) or menu.hasParent then
    begin

      // Label para o cabeçalho
      textLabel := TLabel.Create(header);
      textLabel.Parent       := header;
      textLabel.Top          := trunc( header.Height / 2 ) - trunc(textLabel.Height/2);
      textLabel.Caption      := name;
      textLabel.Font.Color   := fHeaderFontColor;
      textLabel.Transparent  := true;
      textLabel.Cursor       := fCursor;
      textLabel.Hint         := formatJsonParam( menu );
      textLabel.OnClick      := OnClickMenu;
      textLabel.OnMouseEnter := OnMouseEnterMenu;
      textLabel.OnMouseLeave := OnMouseExitMenu;

    end;

  if (not fCompacted) then
    begin

      // Container pra colocar os items do menu
      result := TNewPanel.Create( parentContainer );
      result.Parent             := parentContainer;
      result.ColorGradientStart := parentContainer.ColorGradientStart;
      result.ColorGradientEnd   := parentContainer.ColorGradientEnd;
      result.Color              := parentContainer.Color;
      result.Top                := topHeader;
      result.Height             := (fChildHeight*countItems);
      result.Width              := header.Width;
      result.Name               := containerName;
      result.Caption            := '';
      result.Visible            := startOpened;
      result.Cursor             := fCursor;

      // Guardando objeto visual do header e container
      menu.setGroupMenuItem( header, result, iconDropDownOpened, iconDropDownClosed, indicator );

    end
  else
    begin

      // Container pra colocar os items do menu
      // Quando compactado, os itens são projetados ao lado do menu
      // e Terá scrollbox como parent

      scrollBox := TNewScrollBox.Create( fComponentParent.Parent );
      scrollBox.Parent  := fComponentParent.Parent;
      scrollBox.HorzScrollBar.Visible := false;
      scrollBox.AutoScroll := false;
      scrollBox.Top     := topHeader;
      scrollBox.Visible := startOpened;
      scrollBox.Name    := containerName;
      scrollBox.Width   := WIDTH_DEFAULT;
      scrollBox.Height  := fChildHeight*countItems;
      scrollBox.Tag     := fChildHeight*countItems;
      scrollBox.OnMouseLeaveNC := OnMouseExitScrollChild;

      if fComponentParent.Align = alLeft then
        scrollBox.Left := fComponentParent.Width
      else if fComponentParent.Align = alRight then
        scrollBox.Left := fComponentParent.Left - scrollBox.Width;

      result := TNewPanel.Create( scrollBox );
      result.Parent             := scrollBox;
      result.ColorGradientStart := parentContainer.ColorGradientStart;
      result.ColorGradientEnd   := parentContainer.ColorGradientEnd;
      result.Color              := parentContainer.Color;
      result.Height             := (fChildHeight*countItems);
      result.Width              := WIDTH_DEFAULT;

      result.Name    := containerName + '_child';
      result.Caption := '';
      result.Cursor  := fCursor;

      // Guardando objeto visual do header e container
      menu.setGroupMenuItem( header, scrollbox, nil, nil, indicator );

    end;

  alignLabelPosition(menu.getLevel, textLabel, icon, iconFont);

end;

destructor TLoadMenu.Destroy;
begin

  try

    freeAndNil( fMenuItems );
    freeAndNil( fPanelBase );
    freeAndNil( fMenuOrdered );

  finally
    inherited;
  end;

end;

procedure TLoadMenu.expandMenu;
begin
  setCompact( false );
end;

function TLoadMenu.formatJsonParam( item : TLoadMenuItem ): String;
var
  json : TJSONObject;
  name, text : String;
begin

  name := item.getName;
  text := item.getText;

  json := TJSONObject.Create;

  try

    json.AddPair( 'name', name );
    json.AddPair( 'text', text );

    result := json.ToString;

  finally
    freeAndNil( json );
  end;

end;


procedure TLoadMenu.freeItemsMenu;
var
  control : TNewPanel;

  function temContainer( var container : TNewPanel ) : Boolean;
  var
    i: Integer;
  begin

    container := nil;

    for i := 0 to fComponentParent.Parent.ControlCount - 1 do
      if trim(fComponentParent.Parent.Controls[i].Name).ToLower.Contains(KEY_CONTAINER) then
        begin
          container := TNewPanel(fComponentParent.Parent.Controls[i]);
          break;
        end;

    result := (container <> nil);

  end;

begin

  if fPanelBase <> nil then
    while fPanelBase.ControlCount > 0 do
      fPanelBase.Controls[fPanelBase.ControlCount-1].Free;

  if fCompacted and (fComponentParent <> nil) then
    begin

      control := nil;

      while temContainer(control) do
        control.Free;

    end;

end;

function TLoadMenu.getJsonParamToString(content : String; var name,  text: String): Boolean;
var
  json : TJSONValue;

begin

  json   := TJSONObject.ParseJSONValue( content );
  result := json <> nil;

  if result then
    begin

      name := json.GetValue<String>('name');
      text := json.GetValue<String>('text');

    end;

end;

function TLoadMenu.getMenuItemByName(name: String): TLoadMenuItem;
begin
  result := getMenuItemByName( fMenuItems, name );
end;

function TLoadMenu.getMenuItemByName(listItems : TLoadMenuItemList; name: String): TLoadMenuItem;
var
  item: TPair<String, TLoadMenuItem>;
begin

  result := nil;

  if listItems.ContainsKey( name ) then
    result := listItems[ name ]
  else
    for item in listItems do
      begin

        result := getMenuItemByName( item.Value.getItems, name );

        if result <> nil then
          break;

      end;

end;


procedure TLoadMenu.load;

  procedure drawItem( item : TLoadMenuItem; parentContainer : TNewPanel = nil );
  var
    container : TNewPanel;
    key : String;
  begin

    container := createNewHeader( item, parentContainer );

    // Zerando qtd de posições de filhos guardadas no pai
    item.setLastHeaderDrawPos(0);
    item.setLastChildDrawPos(0);

    if container <> nil then
      begin

        for key in item.getItemsOrdered do
          begin

            if item.getItems[key].hasChildren then
              drawItem( item.getItems[key], container )
            else
              createNewChild( container, item.getItems[key] );

          end;

      end;

  end;

var
  key : String;

begin

  freeItemsMenu;

  if fCompacted then
    begin
      fComponentParent.Width := COMPACT_WIDTH;
      fAlignMenu := amCenter;
    end
  else
    begin
      fComponentParent.Width := WIDTH_DEFAULT;
      fAlignMenu := ALIGN_DEFAULT;
    end;

  fPanelBase.Width  := fComponentParent.Width;
  fPanelBase.Height := fComponentParent.Height;

  fContHeader    := 0;
  fContChild     := 0;
  fContItems     := 0;
  fContTopHeader := 0;

  // Desenhando menu
  for key in fMenuOrdered do
    drawItem( fMenuItems[key] );

end;

function TLoadMenu.newFontIcon(parent: TWinControl; code : WideChar; menu : TLoadMenuItem = nil ): TLabel;
begin

  inc( fContItems );

  result := TLabel.Create( parent );
  result.Parent := parent;
  result.Name   := '_icon' + intToStr( fContItems );

  if menu <> nil then
    result.Hint := formatJsonParam( menu );

  result.AutoSize   := true;
  result.Top        := trunc(parent.Height / 2) - trunc(result.Height / 2);

  setFontAwesomeConfig( result, code );

  result.OnClick      := OnClickMenu;
  result.OnMouseEnter := OnMouseEnterMenu;

end;

function TLoadMenu.newImageIcon(parent: TWinControl; imageIndex : Integer; menu : TLoadMenuItem = nil ): TImage;
begin

  inc( fContItems );

  result := TImage.Create( parent );
  result.Parent  := parent;
  result.Name    := '_icon' + intToStr( fContItems );

  if menu <> nil then
    result.Hint := formatJsonParam( menu );

  fImageList.GetIcon(imageIndex, result.Picture.icon);
  result.AutoSize := true;
  result.Top      := trunc(parent.Height / 2) - trunc(result.Picture.Height / 2);

  result.OnClick      := OnClickMenu;
  result.OnMouseEnter := OnMouseEnterMenu;

end;

function TLoadMenu.newIndicator(parent: TWinControl; menu : TLoadMenuItem = nil): TNewPanel;
begin

  inc( fContItems );

  result := TnewPanel.Create(parent);
  result.Parent  := parent;
  result.Left    := 0;
  result.Top     := 0;
  result.Name    := KEY_INDICATOR + intToStr( fContItems );

  if menu <> nil then
    result.Hint := formatJsonParam( menu );

  result.Caption := '';
  result.ColorGradientStart := fIndicatorColorStart;
  result.ColorGradientEnd   := fIndicatorColorEnd;
  result.Height  := parent.Height;
  result.Width   := INDICATOR_WIDTH;
  result.Visible := false;

  result.OnClick      := OnClickMenu;
  result.OnMouseEnter := OnMouseEnterMenu;
  result.OnMouseLeave := OnMouseExitMenu;

end;

procedure TLoadMenu.OnClickChild(Sender: TObject);
var
  content, name, text : String;
  menu : TLoadMenuItem;

begin

  content := TWinControl(Sender).Hint;

  if not content.IsEmpty then
    begin

      if getJsonParamToString( content, name, text ) then
        begin

          // Executing the click!
          if (not name.IsEmpty) then
            begin

              menu := getMenuItemByName( name );

              if fCompacted then
                closeAll;

              if (menu <> nil) then
                menu.OnClick( name, text );

            end;

        end;

    end;

end;

procedure TLoadMenu.closeAll;
var
  pair : TPair<String, TLoadMenuItem>;
begin

  for pair in fMenuItems do
    if pair.Value.hasGroupMenuItem then
      pair.Value.getGroupMenuItem.close;

end;

procedure TLoadMenu.closeOtherItems( currentlyOpened : TLoadMenuItem );
var
  parentItems : TLoadMenuItemList;
  pair : TPair<String, TLoadMenuItem>;
begin

  if currentlyOpened.hasParent then
    parentItems := currentlyOpened.getParent.getItems
  else
    parentItems := fMenuItems;

  for pair in parentItems do
    if (pair.Value <> currentlyOpened) and pair.Value.hasGroupMenuItem then
      pair.Value.getGroupMenuItem.close;

end;


procedure TLoadMenu.OnClickMenu(Sender: TObject);
var
  content, name, text : String;
  menu : TLoadMenuItem;

begin

  if fCompacted then
    exit;

  content := TWinControl( Sender ).Hint;

  if not content.IsEmpty then
    begin

      if getJsonParamToString( content, name, text ) then
        begin

          menu := getMenuItemByName( name );

          // Recuperando o objeto do menu
          if menu <> nil then
            begin

              // Pegando objeto que controla os status visualmente do objeto
              if menu.hasGroupMenuItem then
                begin

                  if menu.getGroupMenuItem.isOpened then
                    menu.getGroupMenuItem.close
                  else
                    begin

                      closeOtherItems( menu );

                      menu.getGroupMenuItem.open;

                    end;

                end;

              relocateMenu;

            end;

        end;

    end;

end;

procedure TLoadMenu.relocateMenu;

  function redrawItem( item : TLoadMenuItem; top : Integer ) : Integer;
  var
    topChild : Integer;
    key : String;

  begin

    result := top;

    if item.hasGroupMenuItem then
      begin

        item.getGroupMenuItem.getHeaderObject.Top := result;
        inc( result, fHeaderHeight );

        if item.getGroupMenuItem.isOpened then
          begin

            if item.hasChildren and item.getGroupMenuItem.hasContainer then
              begin

                topChild := 0;

                for key in item.getItemsOrdered do
                  topChild := redrawItem( item.getItems[key], topChild );

                item.getGroupMenuItem.getContainerObject.Height := topChild;
                item.getGroupMenuItem.getContainerObject.Top    := result;

                inc( result, topChild );

              end;

          end;

      end;

  end;

var
  key : String;
  top : Integer;

begin

  top := 0;

  for key in fMenuOrdered do
    top := redrawItem( fMenuItems[key], top );

  fPanelBase.Height := max( top, fComponentParent.Height );

  // Quando o scroll vertical está ativo, pego a espessura do mesmo e aumento a área do menu, para não cortar informação
  if fComponentParent.VertScrollBar.IsScrollBarVisible then
    fPanelBase.Width := WIDTH_DEFAULT + GetSystemMetrics(SM_CYVSCROLL)
  else
    fPanelBase.Width := WIDTH_DEFAULT;

  fComponentParent.Width := fPanelBase.Width;

end;

procedure TLoadMenu.OnMouseEnterChild(Sender: TObject);
var
  content, name, text : String;
  menu : TLoadMenuItem;
begin

  content := TWinControl( Sender ).Hint;

  if getJsonParamToString( content, name, text ) then
    begin

      menu := getMenuItemByName( name );

      if (menu <> nil) and menu.hasGroupMenuItem then
        begin

          TNewPanel( menu.getGroupMenuItem.getHeaderObject ).ColorGradientStart := fChildHoverColorStart;
          TNewPanel( menu.getGroupMenuItem.getHeaderObject ).ColorGradientEnd   := fChildHoverColorEnd;

        end;

    end;

end;

procedure TLoadMenu.OnMouseEnterMenu(Sender: TObject);
var
  content, name, text : String;
  menu : TLoadMenuItem;
  groupMenu : TGroupMenuItem;
begin

  content := TWinControl( Sender ).Hint;

  if getJsonParamToString( content, name, text ) then
    begin

      menu := getMenuItemByName( name );

      if (menu <> nil) and menu.hasGroupMenuItem then
        begin

          groupMenu := menu.getGroupMenuItem;

          TNewPanel( groupMenu.getHeaderObject ).ColorGradientStart := fHeaderHoverGradientColorStart;
          TNewPanel( groupMenu.getHeaderObject ).ColorGradientEnd   := fHeaderHoverGradientColorEnd;

          if fShowIndicator then
            groupMenu.enableIndicator;

          if fCompacted then
            enableMenuCompacted( menu, true );

        end;

    end;

end;

procedure TLoadMenu.OnMouseExitChild(Sender: TObject);
var
  content, name, text : String;
  menu, parentMenu : TLoadMenuItem;
  groupMenu : TGroupMenuItem;
  pt : TPoint;
  rec : TRect;
//  parent : TWinControl;
begin

  content := TWinControl( Sender ).Hint;

  if getJsonParamToString( content, name, text ) then
    begin

      menu := getMenuItemByName( name );

      if (menu <> nil) and menu.hasGroupMenuItem then
        begin

          groupMenu := menu.getGroupMenuItem;

          TNewPanel( groupMenu.getHeaderObject ).ColorGradientStart := fChildGradientColorStart;
          TNewPanel( groupMenu.getHeaderObject ).ColorGradientEnd   := fChildGradientColorStart;

          if fCompacted then
            begin

              if menu.hasParent then
                begin

                  parentMenu := menu.getParent;

                  if parentMenu.hasGroupMenuItem and parentMenu.getGroupMenuItem.hasContainer then
                    begin

                      pt  := parentMenu.getGroupMenuItem.getContainerObject.ScreenToClient( Mouse.CursorPos );
                      rec := parentMenu.getGroupMenuItem.getContainerObject.ClientRect;

                      if (not PtInRect( rec, pt ) ) then
                        parentMenu.getGroupMenuItem.close;

                    end;

                end;

            end;

        end;

    end;

end;

procedure TLoadMenu.OnMouseExitMenu(Sender: TObject);
var
  content, name, text : String;
  menu : TLoadMenuItem;
  pt : TPoint;
begin

  content := TWinControl( Sender ).Hint;

  if getJsonParamToString( content, name, text ) then
    begin

      menu := getMenuItemByName( name );

      if (menu <> nil) and menu.hasGroupMenuItem then
        begin

          TNewPanel( menu.getGroupMenuItem.getHeaderObject ).ColorGradientStart := fHeaderGradientColorStart;
          TNewPanel( menu.getGroupMenuItem.getHeaderObject ).ColorGradientEnd   := fHeaderGradientColorEnd;

          if fShowIndicator then
            menu.getGroupMenuItem.disableIndicator;

          if fCompacted then
            begin

              pt := Mouse.CursorPos;
              pt := TWinControl( menu.getGroupMenuItem.getHeaderObject ).ScreenToClient(pt);

              if pt.Y >= TWinControl( menu.getGroupMenuItem.getHeaderObject ).Width then
                enableMenuCompacted( menu, false );

            end;

        end;

    end;

end;

procedure TLoadMenu.OnMouseExitScrollChild(Sender: TObject);
var
  rec : TRect;
  pt : TPoint;
begin

  pt  := TNewScrollBox(Sender).ScreenToClient( Mouse.CursorPos );
  rec := TNewScrollBox(Sender).ClientRect;

  if TNewScrollBox(Sender).VertScrollBar.IsScrollBarVisible then
    rec.Width := rec.Width + GetSystemMetrics(SM_CYVSCROLL);

  if (not PtInRect( rec, pt ) ) then
    TNewScrollBox(Sender).Visible := false;

end;

procedure TLoadMenu.enableMenuCompacted( menu : TLoadMenuItem; enable : Boolean );
var
  groupMenu : TGroupMenuItem;
  container : TControl;
begin

  if menu.hasGroupMenuItem then
    begin

      groupMenu := menu.getGroupMenuItem;

      if groupMenu.hasContainer then
        begin

          // Recuperando o scrollbox
          container     := groupMenu.getContainerObject;
          container.Top := fComponentParent.Top + groupMenu.getHeaderObject.Top;

          if enable then
            begin

              groupMenu.open;
              closeOtherItems( menu );

              if fCompacted then
                begin

                  container.Top  := groupMenu.getHeaderObject.Parent.Top + groupMenu.getHeaderObject.Top;
                  container.Left := groupMenu.getHeaderObject.Parent.Parent.Left + groupMenu.getHeaderObject.Parent.Parent.Width;

                  TNewScrollBox(container).AutoScroll := (container.Top + container.Height) >= (container.Parent.Height-BOTTOM_MARGIN);

                  if TNewScrollBox(container).AutoScroll then
                    container.Height := min( container.Height - ( (container.Top + container.Height) - (container.Parent.Height-BOTTOM_MARGIN) ), container.Tag );

                  if TNewScrollBox(container).VertScrollBar.IsScrollBarVisible then
                    container.Width := WIDTH_DEFAULT + GetSystemMetrics(SM_CYVSCROLL)
                  else
                    container.Width := WIDTH_DEFAULT;

                end;

            end
          else
            groupMenu.close;

        end;

    end;

end;

procedure TLoadMenu.setAlign(align: TAlignMenu);
begin
  fAlignMenu    := align;
  ALIGN_DEFAULT := fAlignMenu;
end;

procedure TLoadMenu.setChildBackgroundColor(color: TColor);
begin
  fChildGradientColorStart := color;
  fChildGradientColorEnd   := color;
end;

procedure TLoadMenu.setChildBackgroundColor(startColor, endColor: TColor);
begin
  fChildGradientColorStart := startColor;
  fChildGradientColorEnd   := endColor;
end;

procedure TLoadMenu.setChildFontColor(color: TColor);
begin
  fChildFontColor := color;
end;

procedure TLoadMenu.setChildHeight(height: Integer);
begin
  fChildHeight := height;
end;

procedure TLoadMenu.setChildHoverColor(startColor, endColor: TColor);
begin
  fChildHoverColorStart := startColor;
  fChildHoverColorEnd   := endColor;
end;

procedure TLoadMenu.setChildHoverColor(color: TColor);
begin
  setChildHoverColor(color, color);
end;

procedure TLoadMenu.setCompact(compact: Boolean);
begin

  fCompacted := compact;
  fLastContainerOpened := '';
  load;

end;

procedure TLoadMenu.setCursor(cursor: TCursor);
begin
  fCursor := cursor;
end;

procedure TLoadMenu.setDropDownFonts(upFont, downFont: WideChar);
begin
  fClosedIconFontCode := upFont;
  fOpenedIconFontCode := downFont;
  fDropDownIconType   := tiFontAwesome;
end;

procedure TLoadMenu.setDropDownIndexes(upIndex, downIndex: Integer);
begin
  fClosedIconImageIndex := upIndex;
  fOpenedIconImageIndex := downIndex;
  fDropDownIconType     := tiImage;
end;

procedure TLoadMenu.setEnabled(enabled: Boolean);
var
  pair : TPair<String, TLoadMenuItem>;

begin

  fEnabled := enabled;

  for pair in fMenuItems do
    pair.Value.Enabled := enabled;

end;

procedure TLoadMenu.setFontAwesomeColor(color: TColor);
begin
  fFontAwesomeColor := color;
end;

procedure TLoadMenu.setFontAwesomeConfig(iconFont: TLabel; code : WideChar);
begin

  iconFont.Font.Name  := fFontAwesomeName;
  iconFont.Font.Size  := fFontAwesomeSize;
  iconFont.Font.Height:= fFontAwesomeHeight;
  iconFont.Font.Color := fFontAwesomeColor;
  iconFont.Caption    := code;

end;

procedure TLoadMenu.setFontAwesomeHeight(height: Integer);
begin
  fFontAwesomeHeight := height;
end;

procedure TLoadMenu.setFontAwesomeName(name: String);
begin
  fFontAwesomeName := name;
end;

procedure TLoadMenu.setFontAwesomeSize(size: Integer);
begin
  fFontAwesomeSize := size;
end;

procedure TLoadMenu.setHeaderBackgroundColor(color: TColor);
begin
  fHeaderGradientColorStart := color;
  fHeaderGradientColorEnd   := color;
end;

procedure TLoadMenu.setHeaderBackgroundColor(startColor, endColor: TColor);
begin
  fHeaderGradientColorStart := startColor;
  fHeaderGradientColorEnd   := endColor;
end;

procedure TLoadMenu.setHeaderFontColor(color: TColor);
begin
  fHeaderFontColor := color;
end;

procedure TLoadMenu.setHeaderHeight(height: Integer);
begin
  fHeaderHeight := height;
end;

procedure TLoadMenu.setHeaderHoverColor(colorStart, colorEnd: TColor);
begin
  fHeaderHoverGradientColorStart := colorStart;
  fHeaderHoverGradientColorEnd   := colorEnd;
end;

procedure TLoadMenu.setIndicatorColor(startColor, endColor: TColor);
begin
  fIndicatorColorStart := startColor;
  fIndicatorColorEnd   := endColor;
end;

procedure TLoadMenu.setImageList(imgList: TImageList);
begin

  imgList.ColorDepth   := cd32bit;
  imgList.DrawingStyle := dsTransparent;

  fImageList := imgList;

end;

procedure TLoadMenu.setIndicatorColor(color: TColor);
begin
  setIndicatorColor( color, color );
end;

procedure TLoadMenu.showIndicator(show: Boolean);
begin
  fShowIndicator := show;
end;

procedure TLoadMenu.setHeaderHoverColor(color: TColor);
begin
  setHeaderHoverColor(color, color);
end;

{ TLoadMenuItem }

function TLoadMenuItem.addItem( name, text : String; onClick : TProcessMenuClick = nil ) : TLoadMenuItem;
begin

  if fItems.ContainsKey( name ) then
    raise Exception.Create('O item de nome "' + name + '" já foi adicionado' )
  else
    begin

      result := TLoadMenuItem.Create( name, text, onClick );
      result.setParent( self );

      fItems.add( name, result );
      fItemsOrdered.Add( name );

    end;

end;

function TLoadMenuItem.addItem( name, text : String; imageIndex : Integer; onClick : TProcessMenuClick = nil ) : TLoadMenuItem;
begin

  if fItems.ContainsKey( name ) then
    raise Exception.Create('O item de nome "' + name + '" já foi adicionado' )
  else
    begin

      result := TLoadMenuItem.Create( name, text, imageIndex, onClick );
      result.setParent( self );

      fItems.Add( name, result );
      fItemsOrdered.Add( name );

    end;

end;

function TLoadMenuItem.addItem( name, text : String; fontAwesomeCode : WideChar; onClick : TProcessMenuClick = nil ) : TLoadMenuItem;
begin

  if fItems.ContainsKey( name ) then
    raise Exception.Create('O item de nome "' + name + '" já foi adicionado' )
  else
    begin

      result := TLoadMenuItem.Create( name, text, fontAwesomeCode, onClick );
      result.setParent( self );

      fItems.add( name, result );
      fItemsOrdered.add( name );

    end;

end;

constructor TLoadMenuItem.Create( name, text : String; onClick : TProcessMenuClick = nil );
begin

  fName             := name;
  fText             := text;
  fOnClick          := onClick;
  fTypeIcon         := tiNone;
  fItems            := TLoadMenuItemList.Create([doOwnsValues]);
  fItemsOrdered     := TLoadMenuOrderedList.Create;
  fParent           := nil;
  fGroupMenuItem    := nil;
  fLastChildDrawPos := 0;
  fEnabled          := false;

end;

constructor TLoadMenuItem.Create( name, text : String; imageIndex : Integer; onClick : TProcessMenuClick = nil );
begin

  Create( name, text, onClick );

  fImageIndex := imageIndex;
  fTypeIcon   := tiImage;

end;

constructor TLoadMenuItem.Create( name, text : String; fontAwesomeCode : WideChar; onClick : TprocessMenuClick = nil );
begin

  Create( name, text, onClick );

  fFontAwesomeCode := fontAwesomeCode;
  fTypeIcon        := tiFontAwesome;

end;

destructor TLoadMenuItem.Destroy;
begin

  try

    if fItems <> nil then
      freeAndNil(fItems);

    if fItemsOrdered <> nil then
      freeAndNil( fItemsOrdered );

    if fGroupMenuItem <> nil then
      freeAndNil( fGroupMenuItem );

  finally
    inherited;
  end;


end;

function TLoadMenuItem.getItems: TLoadMenuItemList;
begin
  result := fItems;
end;

function TLoadMenuItem.getItemsOrdered: TLoadMenuOrderedList;
begin
  result := fItemsOrdered;
end;

function TLoadMenuItem.getLastChildDrawPos: Integer;
begin
  result := fLastChildDrawPos;
end;

function TLoadMenuItem.getLastHeaderDrawPos: Integer;
begin
  result := fLastHeaderDrawPos;
end;

function TLoadMenuItem.getLevel: Integer;

  function addLevel( obj : TLoadMenuItem ) : Integer;
    begin

      result := 1;

      if obj.getParent <> nil then
        result := result + addLevel( obj.getParent )

    end;

begin
  result := addLevel( self ) - 1;
end;

function TLoadMenuItem.getName: String;
begin
  result := fName;
end;

function TLoadMenuItem.getParent: TLoadMenuItem;
begin
  result := fParent;
end;

function TLoadMenuItem.getFontAwesomeCode: WideChar;
begin
  result := fFontAwesomeCode;
end;

function TLoadMenuItem.getGroupMenuItem: TGroupMenuItem;
begin
  result := fGroupMenuItem;
end;

function TLoadMenuItem.getImageIndex: Integer;
begin
  result := fImageIndex;
end;

function TLoadMenuItem.getText: String;
begin
  result := fText;
end;

function TLoadMenuItem.getTypeIcon: TTypeIcon;
begin
  result := fTypeIcon;
end;

function TLoadMenuItem.hasChildren: Boolean;
begin
  result := getItems.Count > 0;
end;

function TLoadMenuItem.hasGroupMenuItem: Boolean;
begin
  result := getGroupMenuItem <> nil;
end;

function TLoadMenuItem.hasParent: Boolean;
begin
  result := getParent <> nil;
end;

procedure TLoadMenuItem.setEnabled(enabled: Boolean);
begin

  fEnabled := enabled;

  if fGroupMenuItem.fHeaderObject <> nil then
    fGroupMenuItem.fHeaderObject.Enabled     := fEnabled;

  if fGroupMenuItem.fContainerObject <> nil then
    fGroupMenuItem.fContainerObject.Enabled  := fEnabled;

  if fGroupMenuItem.fIconOpenedObject <> nil then
    fGroupMenuItem.fIconOpenedObject.Enabled := fEnabled;

  if fGroupMenuItem.fIconClosedObject <> nil then
    fGroupMenuItem.fIconClosedObject.Enabled := fEnabled;

  if fGroupMenuItem.fIndicatorObject <> nil then
    fGroupMenuItem.fIndicatorObject.Enabled  := fEnabled;

end;

procedure TLoadMenuItem.setGroupMenuItem( header : TControl; container: TControl = nil; iconOpened : TControl = nil; iconClosed : TControl = nil; indicator : TControl = nil );
begin

  if fGroupMenuItem <> nil then
    freeAndNil( fGroupMenuItem );

  fGroupMenuItem := TGroupMenuItem.Create( self, header, container, iconOpened, iconClosed, indicator );

end;

procedure TLoadMenuItem.setLastChildDrawPos(drawPos : Integer);
begin
  fLastChildDrawPos := drawPos;
end;

procedure TLoadMenuItem.setLastHeaderDrawPos(drawPos: Integer);
begin
  fLastHeaderDrawPos := drawPos;
end;

procedure TLoadMenuItem.setParent(parent: TLoadMenuItem);
begin
  fParent := parent;
end;

{ TGroupMenuItem }

procedure TGroupMenuItem.changeDropDownIcon(opened: Boolean);
begin

  // Mudando icones caso haja
  if (fIconOpenedObject <> nil) then
    fIconOpenedObject.Visible := opened;

  if (fIconClosedObject <> nil) then
    fIconClosedObject.Visible := not opened;

end;

procedure TGroupMenuItem.close;
var
  pair : TPair<String, TLoadMenuItem>;
begin

  // Fechando todos os filhos
  for pair in fMenuItem.getItems do
    if pair.Value.hasGroupMenuItem then
      pair.Value.getGroupMenuItem.close;

  // Fechando container do próprio objeto
  if hasContainer then
    getContainerObject.Visible := false;

  changeDropDownIcon( false );

end;

constructor TGroupMenuItem.Create( menuItem : TLoadMenuItem; header : TControl; container: TControl = nil; iconOpened : TControl = nil; iconClosed : TControl = nil; indicator : TControl = nil );
begin

  fHeaderObject     := header;
  fContainerObject  := container;
  fMenuItem         := menuItem;
  fIconOpenedObject := iconOpened;
  fIconClosedObject := iconClosed;
  fIndicatorObject  := indicator;

end;

procedure TGroupMenuItem.disableIndicator;
begin

  if fIndicatorObject <> nil then
    fIndicatorObject.Visible := false;

end;

procedure TGroupMenuItem.enableIndicator;
begin

  if fIndicatorObject <> nil then
    fIndicatorObject.Visible := true;

end;

function TGroupMenuItem.getContainerObject: TControl;
begin
  result := fContainerObject;
end;

function TGroupMenuItem.getHeaderObject: TControl;
begin
  result := fHeaderObject;
end;

function TGroupMenuItem.getIconClosedObject: TControl;
begin
  result := fIconClosedObject;
end;

function TGroupMenuItem.getIconOpenedObject: TControl;
begin
  result := fIconOpenedObject;
end;

function TGroupMenuItem.getIndicatorObject: TControl;
begin
  result := fIndicatorObject;
end;

function TGroupMenuItem.hasContainer: Boolean;
begin
  result := getContainerObject <> nil;
end;

function TGroupMenuItem.isOpened: Boolean;
begin

  if hasContainer then
    result := fContainerObject.Visible
  else
    result := false;

end;

procedure TGroupMenuItem.open;
begin

  if hasContainer then
    getContainerObject.Visible := true;

  changeDropDownIcon( true );

end;

end.
