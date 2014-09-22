package com.longtailvideo.jwplayer.plugins.related 
{
    import com.longtailvideo.jwplayer.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.net.*;
    import flash.text.*;
    
    public class RelatedThumb extends flash.display.Sprite
    {
        public function RelatedThumb(arg1:Number, arg2:Number, arg3:Object, arg4:Function)
        {
            super();
            this._width = arg1;
            this._height = arg2;
            this._item = arg3;
            this._click = arg4;
            this._back = new flash.display.Sprite();
            this._back.graphics.beginFill(0, 1);
            this._back.graphics.drawRect(1, 1, arg1 - 2, arg2 - 2);
            this._back.filters = new Array(new flash.filters.DropShadowFilter(0));
            addChild(this._back);
            this._loader = new flash.display.Loader();
            this._loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, this._loaderHandler);
            this._loader.load(new flash.net.URLRequest(arg3.image));
            addChild(this._loader);
            this._mask = new flash.display.Sprite();
            this._mask.graphics.beginFill(0, 1);
            this._mask.graphics.drawRect(1, 1, arg1 - 2, arg2 - 2);
            addChild(this._mask);
            this._loader.mask = this._mask;
            this._glow = new this.GlowSheet();
            this._glow.x = 1;
            this._glow.y = 1;
            this._glow.width = arg1 - 2;
            this._glow.scaleY = this._glow.scaleX;
            addChild(this._glow);
            this._field = new flash.text.TextField();
            this._field.width = arg1 - 2;
            this._field.x = 1;
            this._field.wordWrap = true;
            this._field.autoSize = "center";
            this._format = new flash.text.TextFormat("Arial", 11, 13421772);
            this._format.align = "center";
            this._format.leftMargin = 5;
            this._format.rightMargin = 5;
            this._field.defaultTextFormat = this._format;
            this._field.selectable = false;
            this._field.text = arg3.title;
            if (this._field.textHeight > arg2 - 12) 
            {
                this._field.autoSize = "none";
                this._field.height = arg2 - 8;
            }
            this._field.y = arg2 - this._field.height - 4;
            this._overlay = new flash.display.Sprite();
            this._overlay.graphics.beginFill(0, 0.8);
            this._overlay.graphics.drawRect(1, this._field.y - 3, arg1 - 2, this._field.height + 6);
            addChild(this._overlay);
            addChild(this._field);
            buttonMode = true;
            mouseChildren = false;
            addEventListener(flash.events.MouseEvent.CLICK, this._clickHandler);
            addEventListener(flash.events.MouseEvent.MOUSE_OUT, this._outHandler);
            addEventListener(flash.events.MouseEvent.MOUSE_OVER, this._overHandler);
            return;
        }

        internal function _clickHandler(arg1:flash.events.MouseEvent):void
        {
            this._click(this._item);
            return;
        }

        internal function _loaderHandler(arg1:flash.events.Event):void
        {
            try 
            {
                flash.display.Bitmap(this._loader.content).smoothing = true;
            }
            catch (e:Error)
            {
            };
            com.longtailvideo.jwplayer.utils.Stretcher.stretch(this._loader, this._width, this._height, com.longtailvideo.jwplayer.utils.Stretcher.FILL);
            return;
        }

        internal function _outHandler(arg1:flash.events.MouseEvent):void
        {
            this._back.graphics.clear();
            this._back.graphics.beginFill(0, 1);
            this._back.graphics.drawRect(1, 1, this._width - 2, this._height - 2);
            this._back.filters = new Array(new flash.filters.DropShadowFilter(0));
            this._format = new flash.text.TextFormat("Arial", 11, 13421772);
            this._format.align = "center";
            this._format.leftMargin = 5;
            this._format.rightMargin = 5;
            this._field.defaultTextFormat = this._format;
            this._field.text = this._field.text;
            return;
        }

        internal function _overHandler(arg1:flash.events.MouseEvent):void
        {
            this._back.graphics.clear();
            this._back.graphics.beginFill(16777215, 1);
            this._back.graphics.drawRect(1, 1, this._width - 2, this._height - 2);
            this._back.filters = new Array(new flash.filters.DropShadowFilter(0, 45, 16777215));
            this._format = new flash.text.TextFormat("Arial", 11, 16777215);
            this._format.align = "center";
            this._format.leftMargin = 5;
            this._format.rightMargin = 5;
            this._field.defaultTextFormat = this._format;
            this._field.text = this._field.text;
            return;
        }

        internal const GlowSheet:Class=com.longtailvideo.jwplayer.plugins.related.RelatedThumb_GlowSheet;

        internal var _back:flash.display.Sprite;

        internal var _click:Function;

        internal var _item:Object;

        internal var _loader:flash.display.Loader;

        internal var _mask:flash.display.Sprite;

        internal var _glow:flash.display.DisplayObject;

        internal var _height:Number;

        internal var _overlay:flash.display.Sprite;

        internal var _field:flash.text.TextField;

        internal var _format:flash.text.TextFormat;

        internal var _width:Number;
    }
}
