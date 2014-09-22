package com.longtailvideo.jwplayer.plugins.sharing 
{
    import com.longtailvideo.jwplayer.events.*;
    import com.longtailvideo.jwplayer.player.*;
    import com.longtailvideo.jwplayer.plugins.*;
    import com.longtailvideo.jwplayer.utils.*;
    import com.longtailvideo.jwplayer.view.interfaces.*;
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.net.*;
    import flash.text.*;
    
    public class Sharing extends flash.display.Sprite implements com.longtailvideo.jwplayer.plugins.IPlugin6
    {
        public function Sharing()
        {
            super();
            return;
        }

        public function _itemHandler(arg1:com.longtailvideo.jwplayer.events.PlaylistEvent):void
        {
            this._backHandler(null);
            var loc1:*=this._player.playlist.currentItem;
            this._code = "";
            if (this._config.code) 
            {
                if (this._config.code.indexOf("MEDIAID") > 0 && loc1["mediaid"]) 
                {
                    this._code = this._config.code.replace("MEDIAID", loc1["mediaid"]);
                }
                else if (this._config.code.indexOf("MEDIAID") == -1) 
                {
                    this._code = this._config.code;
                }
            }
            if (this._code.substr(0, 3) == "%3C") 
            {
                this._code = decodeURIComponent(this._code);
            }
            this._link = this._getPageURL();
            if (this._config.link) 
            {
                if (this._config.link.indexOf("MEDIAID") > 0 && loc1["mediaid"]) 
                {
                    this._link = this._config.link.replace("MEDIAID", loc1["mediaid"]);
                }
                else if (this._config.link.indexOf("MEDIAID") == -1) 
                {
                    this._link = this._config.link;
                }
            }
            if (this._container) 
            {
                this._codeRow.setText(this._code);
                this._linkRow.setText(this._link);
                if (this._code != "") 
                {
                    this._codeRow.visible = true;
                    this._codeRow.y = 32;
                    this._linkRow.y = 74;
                    this._emailButton.y = loc2 = 116;
                    this._twitterButton.y = loc2 = loc2;
                    this._facebookButton.y = loc2;
                }
                else 
                {
                    this._codeRow.visible = false;
                    this._linkRow.y = 32;
                    var loc2:*;
                    this._emailButton.y = loc2 = 74;
                    this._twitterButton.y = loc2 = loc2;
                    this._facebookButton.y = loc2;
                }
                this.resize(this._back.width, this._back.height);
            }
            if (!loc1["ova.hidden"]) 
            {
            };
            return;
        }

        internal function _renderDialog():void
        {
            this.tabChildren = false;
            this._container = new flash.display.MovieClip();
            this._container.visible = false;
            this._container.alpha = 0;
            addChild(this._container);
            this._back = new flash.display.Sprite();
            this._back.buttonMode = true;
            this._back.addChild(new this.DialogBack());
            this._back.addEventListener(flash.events.MouseEvent.CLICK, this._backHandler);
            this._container.addChild(this._back);
            this._close = new flash.display.Sprite();
            this._close.buttonMode = true;
            this._close.addChild(new this.CloseButton());
            this._close.addEventListener(flash.events.MouseEvent.CLICK, this._backHandler);
            this._container.addChild(this._close);
            this._form = new flash.display.Sprite();
            this._container.addChild(this._form);
            this._headingText = new flash.text.TextField();
            this._headingText.width = 240;
            this._headingText.height = 24;
            this._headingText.defaultTextFormat = new flash.text.TextFormat("Arial", 15, 16777215);
            if (this._config.heading is String) 
            {
                this._headingText.text = this._config.heading;
            }
            else 
            {
                this._headingText.text = "Share Video";
            }
            this._headingText.x = 80;
            this._form.addChild(this._headingText);
            this._codeRow = new com.longtailvideo.jwplayer.plugins.sharing.SharingRow("Embed code");
            this._form.addChild(this._codeRow);
            this._linkRow = new com.longtailvideo.jwplayer.plugins.sharing.SharingRow("Video link");
            this._form.addChild(this._linkRow);
            this._facebookButton = new com.longtailvideo.jwplayer.plugins.sharing.SharingButton(new this.FacebookIcon(), "Facebook", this._facebookHandler);
            this._facebookButton.x = 80;
            this._form.addChild(this._facebookButton);
            this._twitterButton = new com.longtailvideo.jwplayer.plugins.sharing.SharingButton(new this.TwitterIcon(), "Twitter", this._twitterHandler);
            this._twitterButton.x = 120;
            this._form.addChild(this._twitterButton);
            this._emailButton = new com.longtailvideo.jwplayer.plugins.sharing.SharingButton(new this.EmailIcon(), "Email", this._emailHandler);
            this._emailButton.x = 160;
            this._form.addChild(this._emailButton);
            return;
        }

        public function resize(arg1:Number, arg2:Number):void
        {
            if (this._container) 
            {
                this._back.width = arg1;
                this._back.height = arg2;
                this._close.x = arg1 - 30;
                this._close.y = 18;
                this._codeRow.resize(arg1);
                this._linkRow.resize(arg1);
                this._form.x = Math.round(arg1 / 2 - this._codeRow.width / 2);
                this._form.y = Math.round(arg2 / 2 - this._form.height / 2);
            }
            return;
        }

        internal function _twitterHandler(arg1:flash.events.MouseEvent):void
        {
            flash.net.navigateToURL(new flash.net.URLRequest(this.TWITTER_URL + encodeURIComponent(this._link)));
            return;
        }

        internal function _emailHandler(arg1:flash.events.MouseEvent):void
        {
            var loc1:*=new flash.net.URLRequest("mailto:" + "?body= " + encodeURIComponent(this._link));
            flash.net.navigateToURL(loc1, "_blank");
            loc1.method = flash.net.URLRequestMethod.POST;
            return;
        }

        public function get target():String
        {
            return "6.0";
        }

        internal function _backHandler(arg1:flash.events.MouseEvent):void
        {
            new com.longtailvideo.jwplayer.utils.Animations(this._container).fade(0, 0.2);
            this._player.setControls(true);
            return;
        }

        internal function _dialogHandler(arg1:flash.events.MouseEvent):void
        {
            this._player.pause();
            new com.longtailvideo.jwplayer.utils.Animations(this._container).fade(1, 0.2);
            this._player.setControls(false);
            return;
        }

        internal function _facebookHandler(arg1:flash.events.MouseEvent):void
        {
            flash.net.navigateToURL(new flash.net.URLRequest(this.FACEBOOK_URL + encodeURIComponent(this._link)));
            return;
        }

        internal function _getPageURL():String
        {
            var loc1:*="";
            if (flash.external.ExternalInterface.available) 
            {
                try 
                {
                    loc1 = flash.external.ExternalInterface.call("function(){if(window.top==window)return window.location.toString();else return document.referrer;}");
                }
                catch (err:Error)
                {
                };
            }
            return loc1;
        }

        public function get id():String
        {
            return "sharing";
        }

        public function initPlugin(arg1:com.longtailvideo.jwplayer.player.IPlayer, arg2:com.longtailvideo.jwplayer.plugins.PluginConfig):void
        {
            this._player = arg1;
            this._config = arg2;
            this._player.addEventListener(com.longtailvideo.jwplayer.events.PlaylistEvent.JWPLAYER_PLAYLIST_ITEM, this._itemHandler);
            this._button = this._player.controls.dock.addButton(new this.DialogIcon(), this._config.heading ? this._config.heading : "Share Video", this._dialogHandler);
            this._renderDialog();
            return;
        }

        internal const CloseButton:Class=com.longtailvideo.jwplayer.plugins.sharing.Sharing_CloseButton;

        internal const DialogIcon:Class=com.longtailvideo.jwplayer.plugins.sharing.Sharing_DialogIcon;

        internal const DialogBack:Class=com.longtailvideo.jwplayer.plugins.sharing.Sharing_DialogBack;

        internal const FacebookIcon:Class=com.longtailvideo.jwplayer.plugins.sharing.Sharing_FacebookIcon;

        internal const TwitterIcon:Class=com.longtailvideo.jwplayer.plugins.sharing.Sharing_TwitterIcon;

        internal const EmailIcon:Class=com.longtailvideo.jwplayer.plugins.sharing.Sharing_EmailIcon;

        public const FACEBOOK_URL:String="http://www.facebook.com/sharer/sharer.php?u=";

        public const TWITTER_URL:String="http://twitter.com/intent/tweet?url=";

        internal var _back:flash.display.Sprite;

        internal var _close:flash.display.Sprite;

        internal var _code:String;

        internal var _codeRow:com.longtailvideo.jwplayer.plugins.sharing.SharingRow;

        internal var _config:Object;

        internal var _container:flash.display.MovieClip;

        internal var _button:com.longtailvideo.jwplayer.view.interfaces.IDockButton;

        internal var _facebookButton:com.longtailvideo.jwplayer.plugins.sharing.SharingButton;

        internal var _form:flash.display.Sprite;

        internal var _linkRow:com.longtailvideo.jwplayer.plugins.sharing.SharingRow;

        internal var _player:com.longtailvideo.jwplayer.player.IPlayer;

        internal var _twitterButton:com.longtailvideo.jwplayer.plugins.sharing.SharingButton;

        internal var _emailButton:com.longtailvideo.jwplayer.plugins.sharing.SharingButton;

        internal var _link:String;

        internal var _headingText:flash.text.TextField;
    }
}
