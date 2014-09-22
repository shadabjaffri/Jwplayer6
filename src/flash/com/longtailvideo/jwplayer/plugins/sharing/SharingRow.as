package com.longtailvideo.jwplayer.plugins.sharing 
{
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.system.*;
    import flash.text.*;
    
    public class SharingRow extends flash.display.Sprite
    {
        public function SharingRow(arg1:String)
        {
            super();
            this._label = new flash.text.TextField();
            this._label.defaultTextFormat = new flash.text.TextFormat("Arial", 12, 16777215);
            this._label.text = arg1;
            this._label.x = -5;
            this._label.y = 6;
            this._label.width = 80;
            this._label.autoSize = "right";
            addChild(this._label);
            this._back = new flash.display.Sprite();
            this._back.graphics.beginFill(16777215, 1);
            this._back.graphics.drawRect(1, 1, this._textWidth, 28);
            this._back.filters = new Array(new flash.filters.DropShadowFilter(0, 45, 0, 1, 4, 4));
            this._back.x = 80;
            addChild(this._back);
            this._field = new flash.text.TextField();
            this._field.defaultTextFormat = new flash.text.TextFormat("Arial", 11, 0);
            this._field.x = 84;
            this._field.y = 5;
            this._field.width = this._textWidth - 54;
            this._field.height = 28;
            addChild(this._field);
            this._button = new flash.display.Sprite();
            var loc1:*=new flash.display.Sprite();
            loc1.addChild(new this.ButtonBackground());
            loc1.height = 28;
            loc1.width = 50;
            this._button.addChild(loc1);
            this._button.buttonMode = true;
            this._button.mouseChildren = false;
            this._button.addEventListener(flash.events.MouseEvent.CLICK, this._clickHandler);
            this._button.addEventListener(flash.events.MouseEvent.MOUSE_OUT, this._outHandler);
            this._button.addEventListener(flash.events.MouseEvent.MOUSE_OVER, this._overHandler);
            this._button.height = 28;
            this._button.width = 50;
            this._button.x = 85 + this._field.width;
            this._button.y = 1;
            this._copy = new flash.text.TextField();
            this._copy.x = 8;
            this._copy.y = 4;
            this._copy.width = 40;
            this._copy.height = 20;
            this._copy.defaultTextFormat = new flash.text.TextFormat("Arial", 11, 16777215);
            this._copy.text = "Copy";
            this._button.addChild(this._copy);
            addChild(this._button);
            return;
        }

        internal function _clickHandler(arg1:flash.events.MouseEvent):void
        {
            stage.focus = this._field;
            this._field.setSelection(0, 999999);
            flash.system.System.setClipboard(this._field.text);
            return;
        }

        internal function _outHandler(arg1:flash.events.MouseEvent):void
        {
            this._back.graphics.clear();
            this._back.graphics.beginFill(16777215, 1);
            this._back.graphics.drawRect(1, 1, this._textWidth, 28);
            this._back.filters = new Array(new flash.filters.DropShadowFilter(0, 45, 0, 1, 4, 4));
            return;
        }

        internal function _overHandler(arg1:flash.events.MouseEvent):void
        {
            this._back.graphics.clear();
            this._back.graphics.beginFill(16777215, 1);
            this._back.graphics.drawRect(1, 1, this._textWidth, 28);
            this._back.filters = new Array(new flash.filters.DropShadowFilter(0, 45, 16777215, 1, 4, 4));
            return;
        }

        public function setText(arg1:String):void
        {
            this._field.text = arg1;
            return;
        }

        public function resize(arg1:Number):void
        {
            var loc1:*=arg1 - 180;
            if (loc1 < 200) 
            {
                loc1 = 200;
            }
            else if (loc1 > 400) 
            {
                loc1 = 400;
            }
            this._textWidth = loc1;
            this._back.graphics.clear();
            this._back.graphics.beginFill(16777215, 1);
            this._back.graphics.drawRect(1, 1, this._textWidth, 28);
            this._back.filters = new Array(new flash.filters.DropShadowFilter(0, 45, 0, 1, 4, 4));
            this._field.width = this._textWidth - 54;
            this._button.x = 85 + this._field.width;
            return;
        }

        internal const ButtonBackground:Class=com.longtailvideo.jwplayer.plugins.sharing.SharingRow_ButtonBackground;

        internal var _back:flash.display.Sprite;

        internal var _button:flash.display.Sprite;

        internal var _copy:flash.text.TextField;

        internal var _field:flash.text.TextField;

        internal var _label:flash.text.TextField;

        internal var _textWidth:Number=200;
    }
}
