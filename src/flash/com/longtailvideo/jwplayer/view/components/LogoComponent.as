package com.longtailvideo.jwplayer.view.components
{
   import com.longtailvideo.jwplayer.view.interfaces.IPlayerComponent;
   import flash.display.Loader;
   import com.longtailvideo.jwplayer.utils.Animations;
   import flash.events.MouseEvent;
   import com.longtailvideo.jwplayer.utils.RootReference;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.display.DisplayObject;
   import com.longtailvideo.jwplayer.utils.Logger;
   import flash.events.ErrorEvent;
   import flash.net.navigateToURL;
   import com.longtailvideo.jwplayer.utils.Strings;
   import com.longtailvideo.jwplayer.player.PlayerState;
   import com.longtailvideo.jwplayer.player.IPlayer;
   import com.longtailvideo.jwplayer.player.PlayerVersion;
   
   public class LogoComponent extends CoreComponent implements IPlayerComponent
   {
      
      public function LogoComponent(param1:IPlayer, param2:Function = null) {
         this.defaults = 
            {
               "prefix":"http://www.themeflock.com/wp-content/themes/themeflock/assets/",
               "file":"theme-flock-logo.png",
               "link":"http://themeflock.com",
               "linktarget":"_blank",
               "margin":8,
               "hide":false,
               "position":"top-right"
            };
         super(param1,"logo");
         this.animations = new Animations(this);
         _player = param1;
         var _loc3_:String = this._getLinkFlag(this._getEdition());
         this.defaults.link = "http://www.themeflock.com";
         this.setupDefaults();
         this.setupMouseEvents();
         this.loadFile();
         alpha = 0;
         this._loadCallback = param2;
         if(this.getConfigParam("hide").toString().toLowerCase() == "false")
         {
            this.show();
         }
      }
      
      protected var defaults:Object;
      
      protected var timeout:Number = 2;
      
      protected var loader:Loader;
      
      protected var animations:Animations;
      
      protected var _alreadyShown:Boolean = false;
      
      protected var _showing:Boolean = false;
      
      protected var _width:Number;
      
      protected var _height:Number;
      
      protected var _loadCallback:Function;
      
      private function _getLinkFlag(param1:String) : String {
         switch(param1.toLowerCase())
         {
            case "pro":
               return "p";
            case "premium":
               return "r";
            case "ads":
               return "a";
            case "open":
               return "o";
            default:
               return "f";
         }
      }
      
      private function _getEdition() : String {
         var edition:String = "";
         try
         {
            edition = _player["edition"];
         }
         catch(error:Error)
         {
            edition = "open";
         }
         return edition;
      }
      
      protected function setupDefaults() : void {
      }
      
      protected function setupMouseEvents() : void {
         this.mouseChildren = false;
         this.buttonMode = true;
         addEventListener(MouseEvent.CLICK,this.clickHandler);
         this.mouseEnabled = false;
      }
      
      protected function loadFile() : void {
         var _loc1_:RegExp = new RegExp("(\\d+)\\.(\\d+)\\.");
         var _loc2_:Array = _loc1_.exec(_player.version);
         var _loc3_:String = this.getConfigParam("prefix");
         if((this.getConfigParam("file")) && (_loc3_))
         {
            try
            {
               if(RootReference.root.loaderInfo.url.indexOf("https://") == 0)
               {
                  _loc3_ = _loc3_.replace("http://","http://");
               }
            }
            catch(e:Error)
            {
            }
            this.defaults["file"] = _loc3_ + this.getConfigParam("file");
         }
         if((this.getConfigParam("file")) && (_loc3_))
         {
            if(_player.config.logo_file)
            {
               this.defaults["file"] = _player.config.logo_file;
            }
            if(_player.config.logo_file_position)
            {
               this.defaults["position"] = _player.config.logo_file_position;
            }
            if(_player.config.logo_timeout)
            {
               this.defaults["timeout"] = _player.config.logo_timeout;
            }
            if(_player.config.logo_hide)
            {
               this.defaults["hide"] = _player.config.logo_hide;
            }
            if(_player.config.logo_margin)
            {
               this.defaults["margin"] = _player.config.logo_margin;
            }
            if(_player.config.logo_link)
            {
               this.defaults["link"] = _player.config.logo_link;
            }
            if(_player.config.logo_target)
            {
               this.defaults["linktarget"] = _player.config.logo_target;
            }
            if((this.getConfigParam("file")) && RootReference.root.loaderInfo.url.indexOf("http") == 0)
            {
               this.loader = new Loader();
               this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.loaderHandler);
               this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.errorHandler);
               this.loader.load(new URLRequest(this.getConfigParam("file")));
            }
            return;
         }
         if(_player.config.logo_file)
         {
            this.defaults["file"] = _player.config.logo_file;
         }
         if(_player.config.logo_file_position)
         {
            this.defaults["position"] = _player.config.logo_file_position;
         }
         if(_player.config.logo_timeout)
         {
            this.defaults["timeout"] = _player.config.logo_timeout;
         }
         if(_player.config.logo_hide)
         {
            this.defaults["hide"] = _player.config.logo_hide;
         }
         if(_player.config.logo_margin)
         {
            this.defaults["margin"] = _player.config.logo_margin;
         }
         if(_player.config.logo_link)
         {
            this.defaults["link"] = _player.config.logo_link;
         }
         if(_player.config.logo_target)
         {
            this.defaults["linktarget"] = _player.config.logo_target;
         }
         if((this.getConfigParam("file")) && RootReference.root.loaderInfo.url.indexOf("http") == 0)
         {
            this.loader = new Loader();
            this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.loaderHandler);
            this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.errorHandler);
            this.loader.load(new URLRequest(this.getConfigParam("file")));
         }
      }
      
      protected function loaderHandler(param1:Event) : void {
         if(this.loader is DisplayObject)
         {
            addChild(this.loader);
            if(this._loadCallback != null)
            {
               this._loadCallback();
            }
            this.resize(this._width,this._height);
         }
         else
         {
            Logger.log("Logo was not a display object");
         }
      }
      
      protected function errorHandler(param1:ErrorEvent) : void {
         Logger.log("Failed to load logo: " + param1.text);
      }
      
      protected function clickHandler(param1:MouseEvent) : void {
         var _loc2_:String = this.getConfigParam("link");
         if((this._showing) && (_loc2_))
         {
            _player.pause();
            _player.fullscreen(false);
            navigateToURL(new URLRequest(Strings.cleanLink(_loc2_)),this.getConfigParam("linktarget"));
         }
         else if(_player.state == PlayerState.IDLE || _player.state == PlayerState.PAUSED)
         {
            _player.play();
         }
         else
         {
            _player.pause();
         }
         
      }
      
      override public function show() : void {
         visible = true;
         this._showing = true;
         this.animations.fade(1,0.25);
         mouseEnabled = true;
      }
      
      override public function hide(param1:Boolean = false) : void {
         if(this.getConfigParam("hide").toString() == "true" || (param1))
         {
            mouseEnabled = false;
            this._showing = false;
            this.animations.fade(0,0.5);
         }
      }
      
      override public function resize(param1:Number, param2:Number) : void {
         this._width = param1;
         this._height = param2;
         var _loc3_:DisplayObject = this.logo;
         if(_loc3_)
         {
            if(this.position.indexOf("right") >= 0)
            {
               _loc3_.x = this._width - _loc3_.width - this.margin;
            }
            else
            {
               _loc3_.x = this.margin;
            }
            if(this.position.indexOf("bottom") >= 0)
            {
               _loc3_.y = this._height - _loc3_.height - this.margin;
            }
            else
            {
               _loc3_.y = this.margin;
            }
            if(this.position.indexOf("top-left") >= 0 || this.position.indexOf("right-left") >= 0)
            {
               _loc3_.x = 10;
               _loc3_.y = this.margin;
            }
         }
      }
      
      public function get position() : String {
         return String(this.getConfigParam("position")).toLowerCase();
      }
      
      public function get margin() : Number {
         return Number(this.getConfigParam("margin"));
      }
      
      protected function get logo() : DisplayObject {
         return this.loader;
      }
      
      override protected function getConfigParam(param1:String) : * {
         return this.defaults[param1];
      }
   }
}
