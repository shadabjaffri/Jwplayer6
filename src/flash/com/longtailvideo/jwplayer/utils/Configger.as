package com.longtailvideo.jwplayer.utils
{
   import flash.events.EventDispatcher;
   import flash.net.SharedObject;
   import flash.net.URLLoader;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.Event;
   import flash.net.URLRequest;
   import flash.events.ErrorEvent;
   import flash.external.ExternalInterface;
   import flash.system.Security;
   
   public class Configger extends EventDispatcher
   {
      
      public function Configger() {
         this._config = {};
         super();
      }
      
      public static function saveCookie(param1:String, param2:*) : void {
         var _loc3_:SharedObject = null;
         try
         {
            _loc3_ = SharedObject.getLocal("com.longtailvideo.jwplayer","/");
            _loc3_.data[param1] = param2;
            _loc3_.flush();
         }
         catch(err:Error)
         {
         }
      }
      
      private var _config:Object;
      
      public function get config() : Object {
         return this._config;
      }
      
     public function loadConfig() : void {
         this.loadCookies();
         var _loc1_:* = "/video/vid=";
         if(this.xmlConfig)
         {
            this.loadXML(_loc1_ + this.xmlConfig);
         }
         else
         {
            this.loadExternal();
         }
      }
      
      public function get xmlConfig() : String {
         return RootReference.root.loaderInfo.parameters["config"];
      }
      
      public function loadXML(param1:String) : void {
         var _loc2_:URLLoader = new URLLoader();
         _loc2_.addEventListener(IOErrorEvent.IO_ERROR,this.xmlFail);
         _loc2_.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.xmlFail);
         _loc2_.addEventListener(Event.COMPLETE,this.loadComplete);
         _loc2_.load(new URLRequest(param1));
      }
      
      private function loadComplete(param1:Event) : void {
         var _loc2_:XML = XML((param1.target as URLLoader).data);
         if((_loc2_ && _loc2_.name()) && (_loc2_.name().toString().toLowerCase() == "config") && _loc2_.children().length() > 0)
         {
            this.parseXML(_loc2_);
         }
         else
         {
            Logger.log("Config XML was empty");
         }
         this.loadFlashvars(RootReference.root.loaderInfo.parameters);
      }
      
      private function xmlFail(param1:ErrorEvent) : void {
         dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,param1.text));
      }
      
      private function parseXML(param1:XML) : void {
         var _loc2_:XML = null;
         for each(_loc2_ in param1.children())
         {
            if(_loc2_.name() == "pluginconfig")
            {
               this.parsePluginConfig(_loc2_);
            }
            else
            {
               this.setConfigParam(_loc2_.name().toString(),_loc2_.toString());
            }
         }
      }
      
      private function parsePluginConfig(param1:XML) : void {
         var _loc2_:XML = null;
         var _loc3_:XML = null;
         for each(_loc2_ in param1.plugin)
         {
            for each(_loc3_ in _loc2_.children())
            {
               this.setConfigParam(_loc2_.@name + "." + _loc3_.name(),_loc3_.toString());
            }
         }
      }
      
      public function loadFlashvars(param1:Object) : void {
         var param:String = null;
         var params:Object = param1;
         try
         {
            for(param in params)
            {
               this.setConfigParam(param,params[param]);
            }
            dispatchEvent(new Event(Event.COMPLETE));
         }
         catch(e:Error)
         {
            dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,e.message));
         }
      }
      
      private function loadExternal() : void {
         var _loc1_:Object = null;
         var _loc2_:String = null;
         if(ExternalInterface.available)
         {
            try
            {
               _loc1_ = ExternalInterface.call("jwplayer.embed.flash.getVars",ExternalInterface.objectID);
               if(_loc1_ !== null)
               {
                  for(_loc2_ in _loc1_)
                  {
                     this.setConfigParam(_loc2_,_loc1_[_loc2_]);
                  }
                  dispatchEvent(new Event(Event.COMPLETE));
                  return;
               }
            }
            catch(e:Error)
            {
            }
         }
         if(ExternalInterface.available)
         {
            if(ExternalInterface.available)
            {
               if(Security.sandboxType == Security.LOCAL_WITH_FILE)
               {
                  dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"Error loading player: Offline playback not supported"));
               }
               else
               {
                  dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"Error loading player: Could not load player configuration"));
               }
               return;
            }
            if(Security.sandboxType == Security.LOCAL_WITH_FILE)
            {
               dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"Error loading player: Offline playback not supported"));
            }
            else
            {
               dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"Error loading player: Could not load player configuration"));
            }
            return;
         }
         if(ExternalInterface.available)
         {
            if(Security.sandboxType == Security.LOCAL_WITH_FILE)
            {
               dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"Error loading player: Offline playback not supported"));
            }
            else
            {
               dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"Error loading player: Could not load player configuration"));
            }
            return;
         }
         if(Security.sandboxType == Security.LOCAL_WITH_FILE)
         {
            dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"Error loading player: Offline playback not supported"));
         }
         else
         {
            dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"Error loading player: Could not load player configuration"));
         }
      }
      
      private function loadCookies() : void {
         var _loc1_:SharedObject = null;
         try
         {
            _loc1_ = SharedObject.getLocal("com.longtailvideo.jwplayer","/");
            this.writeCookieData(_loc1_.data);
         }
         catch(err:Error)
         {
         }
      }
      
      private function writeCookieData(param1:Object) : void {
         var _loc2_:String = null;
         for(_loc2_ in param1)
         {
            this.setConfigParam(_loc2_.toLowerCase(),param1[_loc2_]);
         }
      }
      
      private function setConfigParam(param1:String, param2:*) : void {
         var _loc3_:RegExp = null;
         var _loc4_:Vector.<RegExp> = new <RegExp>[new RegExp("fullscreen","i"),new RegExp("controlbar\\.","i"),new RegExp("playlist\\.","i")];
         for each(_loc3_ in _loc4_)
         {
            if(_loc3_.test(param1))
            {
               return;
            }
         }
         if(param2 is String)
         {
            param2 = Strings.serialize(Strings.trim(param2));
         }
         this._config[param1.toLowerCase()] = param2;
      }
   }
}
