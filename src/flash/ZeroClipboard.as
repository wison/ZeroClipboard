﻿package {

  import flash.display.Stage;
  import flash.display.Sprite;
  import flash.display.LoaderInfo;
  import flash.display.StageScaleMode;
  import flash.events.*;
  import flash.display.StageAlign;
  import flash.display.StageScaleMode;
  import flash.external.ExternalInterface;
  import flash.system.Security;
  import flash.utils.*;
  import flash.system.System;

  public class ZeroClipboard extends Sprite {

    private var id:String = '';
    private var button:Sprite;
    private var clipText:String = '';

    public function ZeroClipboard() {
      // constructor, setup event listeners and external interfaces
      stage.align = "TL";
      stage.scaleMode = "noScale";
      flash.system.Security.allowDomain("*");

      // import flashvars
      var flashvars:Object = LoaderInfo( this.root.loaderInfo ).parameters;
      id = flashvars.id;
      id = id.split("\\").join("\\\\");
      // invisible button covers entire stage
      button = new Sprite();
      button.buttonMode = true;
      button.useHandCursor = true;
      button.graphics.beginFill(0xCCFF00);
      button.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
      button.alpha = 0.0;
      addChild(button);
      button.addEventListener(MouseEvent.CLICK, function(event:Event): void {
        // user click copies text to clipboard
        // as of flash player 10, this MUST happen from an in-movie flash click event
        System.setClipboard( clipText );
        ExternalInterface.call( 'ZeroClipboard.dispatch', id, 'complete', clipText );
      });

      button.addEventListener(MouseEvent.MOUSE_OVER, function(event:Event): void {
        ExternalInterface.call( 'ZeroClipboard.dispatch', id, 'mouseOver', null );
      } );
      button.addEventListener(MouseEvent.MOUSE_OUT, function(event:Event): void {
        ExternalInterface.call( 'ZeroClipboard.dispatch', id, 'mouseOut', null );
      } );
      button.addEventListener(MouseEvent.MOUSE_DOWN, function(event:Event): void {
        ExternalInterface.call( 'ZeroClipboard.dispatch', id, 'mouseDown', null );
      } );
      button.addEventListener(MouseEvent.MOUSE_UP, function(event:Event): void {
        ExternalInterface.call( 'ZeroClipboard.dispatch', id, 'mouseUp', null );
      } );

      // external functions
      ExternalInterface.addCallback("setHandCursor", setHandCursor);
      ExternalInterface.addCallback("setText", setText);

      // signal to the browser that we are ready
      ExternalInterface.call( 'ZeroClipboard.dispatch', id, 'load', null );
    }

    public function setText(newText:String): void {
      // set the maximum number of files allowed
      clipText = newText;
    }

    public function setHandCursor(enabled:Boolean): void {
      // control whether the hand cursor is shown on rollover (true)
      // or the default arrow cursor (false)
      button.useHandCursor = enabled;
    }
  }
}
