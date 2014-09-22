package com.longtailvideo.jwplayer.plugins.related 
{
    import com.longtailvideo.jwplayer.events.*;
    import com.longtailvideo.jwplayer.parsers.*;
    import com.longtailvideo.jwplayer.player.*;
    import com.longtailvideo.jwplayer.plugins.*;
    import com.longtailvideo.jwplayer.utils.*;
    import com.longtailvideo.jwplayer.view.interfaces.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;
    import flash.utils.*;
    
    public class Related extends flash.display.Sprite implements com.longtailvideo.jwplayer.plugins.IPlugin6
    {
        public function Related()
        {
            super();
            return;
        }

        internal function _completeHandler(arg1:com.longtailvideo.jwplayer.events.MediaEvent):void
        {
            if (this._config.oncomplete !== false) 
            {
                flash.utils.setTimeout(this._completeWrapper, 150);
            }
            return;
        }

        internal function _completeWrapper():void
        {
            if (this._state == "IDLE") 
            {
                this.show();
            }
            return;
        }

      

        internal function _errorHandler(arg1:flash.events.ErrorEvent):void
        {
            com.longtailvideo.jwplayer.utils.Logger.log(arg1.text, this.id);
            this._heading.htmlText = "No related videos found";
            this._resizeGrid(this._dimensions[2], this._dimensions[3]);
            return;
        }

        internal function _setHeading(arg1:String):void
        {
            if (this._config.heading === undefined) 
            {
                this._heading.htmlText = arg1;
            }
            else 
            {
                this._heading.htmlText = this._config.heading;
            }
            return;
        }

        public function hide():void
        {
            this._back.alpha = 1;
            new com.longtailvideo.jwplayer.utils.Animations(this._container).fade(0, 0.2);
            this._player.setControls(true);
            return;
        }

        public function hideDisplay():void
        {
            this._back.alpha = 1;
            new com.longtailvideo.jwplayer.utils.Animations(this._container).fade(0, 0.2);
            this._player.setControls(true);
            return;
        }

        public function get id():String
        {
            return "related";
        }

        public function initPlugin(arg1:com.longtailvideo.jwplayer.player.IPlayer, arg2:com.longtailvideo.jwplayer.plugins.PluginConfig):void
        {
            this._player = arg1;
            this._config = arg2;
            this._player.addEventListener(com.longtailvideo.jwplayer.events.MediaEvent.JWPLAYER_MEDIA_COMPLETE, this._completeHandler);
            this._player.addEventListener(com.longtailvideo.jwplayer.events.PlaylistEvent.JWPLAYER_PLAYLIST_ITEM, this._itemHandler);
            this._player.addEventListener(com.longtailvideo.jwplayer.events.PlayerStateEvent.JWPLAYER_PLAYER_STATE, this._stateHandler);
            this._loader = new flash.net.URLLoader();
            this._loader.addEventListener(flash.events.Event.COMPLETE, this._loaderHandler);
            this._loader.addEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, this._errorHandler);
            this._loader.addEventListener(flash.events.IOErrorEvent.IO_ERROR, this._errorHandler);
            this._parser = new com.longtailvideo.jwplayer.parsers.RSSParser();
            this.tabChildren = false;
            this._container = new flash.display.MovieClip();
            this._container.alpha = 0;
            this._container.visible = false;
            addChild(this._container);
            this._back = new flash.display.Sprite();
            this._back.buttonMode = true;
            this._back.addChild(new this.BackSheet());
            this._back.addEventListener(flash.events.MouseEvent.CLICK, this._backHandler);
            this._container.addChild(this._back);
            this._close = new flash.display.Sprite();
            this._close.buttonMode = true;
            this._close.addChild(new this.CloseButton());
            this._close.addEventListener(flash.events.MouseEvent.CLICK, this._backHandler);
            this._container.addChild(this._close);
            this._heading = new flash.text.TextField();
            this._heading.height = 30;
            this._heading.defaultTextFormat = new flash.text.TextFormat("Arial", 15, 16777215);
            this._heading.autoSize = "center";
            this._heading.multiline = false;
            this._heading.selectable = false;
            this._setHeading("Related Videos");
            this._container.addChild(this._heading);
            this._grid = new flash.display.Sprite();
            this._container.addChild(this._grid);
            return;
        }

        public function _itemHandler(arg1:com.longtailvideo.jwplayer.events.PlaylistEvent):void
        {
            this._file = undefined;
            this._related = new Array();
            this._isLoaded = false;
            while (this._grid.numChildren > 0) 
            {
                this._grid.removeChildAt(0);
            }
            this.hideDisplay();
            var loc1:*=this._player.playlist.currentItem;
            if (this._config["file"]) 
            {
                if (this._config["file"].indexOf("MEDIAID") > 0 && loc1["mediaid"]) 
                {
                    this._file = this._config["file"].replace("MEDIAID", loc1["mediaid"]);
                }
                else if (this._config["file"].indexOf("MEDIAID") == -1) 
                {
                    this._file = this._config["file"];
                }
            }
            return;
        }

        internal function _load():void
        {
            this._isLoaded = true;
            if (this._file) 
            {
                this._heading.htmlText = "";
                this._loader.load(new flash.net.URLRequest(this._file));
            }
            else 
            {
                this._errorHandler(new flash.events.ErrorEvent(flash.events.ErrorEvent.ERROR, false, false, "No related videos found"));
            }
            return;
        }

        internal function _loaderHandler(arg1:flash.events.Event):void
        {
            var evt:flash.events.Event;
            var i:Number;
            var xml:XML;
            var rss:Array;

            var loc1:*;
            xml = null;
            rss = null;
            evt = arg1;
            try 
            {
                xml = XML(evt.target.data);
                rss = this._parser.parse(xml);
            }
            catch (error:Error)
            {
                _errorHandler(new flash.events.ErrorEvent(flash.events.ErrorEvent.ERROR, false, false, "This feed is not valid XML and/or RSS."));
                return;
            }
            i = 0;
            while (i < rss.length) 
            {
                if (rss[i].image && rss[i].title && (this._config.onclick == "play" && rss[i].file || !(this._config.onclick == "play") && rss[i].link)) 
                {
                    this._related.push(rss[i]);
                }
                ++i;
            }
            this._repaint();
            return;
        }

        internal function _repaint():void
        {
            var loc1:*=NaN;
            var loc2:*=NaN;
            var loc3:*=NaN;
            var loc4:*=null;
            while (this._grid.numChildren > 0) 
            {
                this._grid.removeChildAt(0);
            }
            if (this._related.length) 
            {
                loc1 = 0;
                loc2 = 0;
                loc3 = 0;
                while (loc3 < this._related.length) 
                {
                    (loc4 = new com.longtailvideo.jwplayer.plugins.related.RelatedThumb(this._dimensions[0], this._dimensions[1], this._related[loc3], this._clickHandler)).x = (this._dimensions[0] + 10) * loc1;
                    loc4.y = (this._dimensions[1] + 10) * loc2;
                    this._grid.addChild(loc4);
                    if ((this._dimensions[0] + 10) * (loc1 + 2) > this._dimensions[2]) 
                    {
                        if ((this._dimensions[1] + 10) * (loc2 + 2) > this._dimensions[3] - 80) 
                        {
                            break;
                        }
                        else 
                        {
                            ++loc2;
                            loc1 = 0;
                        }
                    }
                    else 
                    {
                        ++loc1;
                    }
                    ++loc3;
                }
                this._setHeading("Related Videos");
                this._resizeGrid(this._dimensions[2], this._dimensions[3]);
            }
            else 
            {
                this._errorHandler(new flash.events.ErrorEvent(flash.events.ErrorEvent.ERROR, false, false, "RSS feed has 0 entries that contain title,link and image."));
            }
            return;
        }

        internal function _resizeGrid(arg1:Number, arg2:Number):void
        {
            this._grid.x = Math.round(arg1 / 2 - this._grid.width / 2);
            this._grid.y = Math.round(arg2 / 2 - this._grid.height / 2) + 15;
            this._heading.y = this._grid.y - 30;
            this._heading.x = Math.round(arg1 / 2 - this._heading.width / 2);
            return;
        }

        public function resize(arg1:Number, arg2:Number):void
        {
            var loc1:*=null;
            var loc2:*=NaN;
            this._back.width = arg1;
            this._back.height = arg2;
            this._close.x = arg1 - 32;
            this._close.y = 20;
            this._dimensions = [140, 90, arg1, arg2];
            if (this._config.dimensions) 
            {
                loc1 = this._config.dimensions.split("x");
                loc2 = 0;
                while (loc2 < 2) 
                {
                    this._dimensions[loc2] = Number(loc1[loc2]);
                    ++loc2;
                }
            }
            this._repaint();
            return;
        }

        public function show():void
        {
            new com.longtailvideo.jwplayer.utils.Animations(this._container).fade(1, 0.2);
            if (this._state == "PLAYING") 
            {
                this._player.pause();
            }
            this._player.setControls(false);
            if (!this._isLoaded) 
            {
                this._load();
            }
            return;
        }

        internal function _stateHandler(arg1:com.longtailvideo.jwplayer.events.PlayerStateEvent):void
        {
            this._state = arg1.newstate;
            if (this._state == "PLAYING") 
            {
                this.hide();
            }
            return;
        }

        public function get target():String
        {
            return "6.0";
        }

        internal function _backHandler(arg1:flash.events.MouseEvent):void
        {
            this.hide();
            return;
        }

        internal function _clickHandler(arg1:Object):void
        {
            if (this._config.onclick != "play") 
            {
                flash.net.navigateToURL(new flash.net.URLRequest(arg1.link), "_top");
            }
            else 
            {
                this._player.load(arg1);
                if (arg1.provider == "youtube") 
                {
                    this._player.load(arg1);
                }
                this._player.play();
            }
            return;
        }



        internal const BackSheet:Class=com.longtailvideo.jwplayer.plugins.related.Related_BackSheet;

        internal const CloseButton:Class=com.longtailvideo.jwplayer.plugins.related.Related_CloseButton;

        internal var _back:flash.display.Sprite;


        internal var _config:Object;

        internal var _container:flash.display.MovieClip;

        internal var _dimensions:Array;

        internal var _file:String;

        internal var _grid:flash.display.Sprite;

        internal var _heading:flash.text.TextField;

        internal var _loader:flash.net.URLLoader;

        internal var _parser:com.longtailvideo.jwplayer.parsers.RSSParser;

        internal var _player:com.longtailvideo.jwplayer.player.IPlayer;

        internal var _close:flash.display.Sprite;

        internal var _state:String;

        internal var _isLoaded:Boolean;

        internal var _related:Array;
    }
}
