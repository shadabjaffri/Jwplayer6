package com.longtailvideo.jwplayer.plugins.sharing 
{
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.text.*;
    
    public class SharingButton extends flash.display.Sprite
    {
        public function SharingButton(arg1:flash.display.DisplayObject, arg2:String, arg3:Function)
        {
            super();
            buttonMode = true;
            mouseChildren = false;
            addEventListener(flash.events.MouseEvent.CLICK, arg3);
            addEventListener(flash.events.MouseEvent.MOUSE_OUT, this._outHandler);
            addEventListener(flash.events.MouseEvent.MOUSE_OVER, this._overHandler);
            this._thumb = new flash.display.Sprite();
            this._thumb.filters = new Array(new flash.filters.DropShadowFilter(0, 45, 0, 1, 4, 4));
            var loc1:*;
            arg1.y = loc1 = 1;
            arg1.x = loc1;
            this._thumb.addChild(arg1);
            addChild(this._thumb);
            return;
        }

        internal function _outHandler(arg1:flash.events.MouseEvent):void
        {
            this._thumb.graphics.clear();
            this._thumb.filters = new Array(new flash.filters.DropShadowFilter(0, 45, 0, 1, 4, 4));
            return;
        }

        internal function _overHandler(arg1:flash.events.MouseEvent):void
        {
            this._thumb.graphics.clear();
            this._thumb.filters = new Array(new flash.filters.DropShadowFilter(0, 45, 16777215, 1, 4, 4));
            return;
        }

        internal var _thumb:flash.display.Sprite;

        internal var _post:flash.text.TextField;

        internal var _name:flash.text.TextField;
    }
}
