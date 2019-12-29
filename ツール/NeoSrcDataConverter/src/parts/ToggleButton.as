package parts
{
    import flash.display.FrameLabel;
    import flash.display.SimpleButton;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    import mx.core.FlexTextField;
    
    /**
     * ...
     * @author ishikawa
     */
    public class ToggleButton extends Sprite
    {
        
        private var _onButton:SimpleButton = null;
        private var _offButton:SimpleButton = null;
        
        private var _onCallBack:Function = null;
        private var _offCallBack:Function = null;
        
        public function ToggleButton(onLabel:String, offLabel:String, onCallBack:Function, offCallBack:Function)
        {
            var format:TextFormat = new TextFormat(null, 12, 0x0, null, null, null, null, null, TextFormatAlign.CENTER);
            
            var labelOn:FlexTextField = new FlexTextField();
            labelOn.text = onLabel;
            labelOn.background = true;
            labelOn.backgroundColor = 0xFF6666;
            labelOn.width = 40;
            labelOn.height = 20;
            labelOn.setTextFormat(format)
            
            var labelOff:FlexTextField = new FlexTextField();
            labelOff.text = offLabel;
            labelOff.background = true;
            labelOff.backgroundColor = 0x6666FF;
            labelOff.width = 40;
            labelOff.height = 20;
            labelOff.setTextFormat(format)
            
            _onButton = new SimpleButton(labelOn,labelOn,labelOn,labelOn);
            _offButton = new SimpleButton(labelOff,labelOff,labelOff,labelOff);
            
            _onCallBack = onCallBack;
            _offCallBack = offCallBack;
            
            _onButton.addEventListener(MouseEvent.CLICK, onAction);
            _offButton.addEventListener(MouseEvent.CLICK, offAction);
            
            addChild(_onButton);
            addChild(_offButton);
            
            _onButton.visible = true;
            _offButton.visible = false;
        }
        
        private function onAction(e:MouseEvent):void
        {
            _onButton.visible = false;
            _offButton.visible = true;
            _onCallBack();
        }
        
        private function offAction(e:MouseEvent):void
        {
            _offButton.visible = false;
            _onButton.visible = true;
            _offCallBack();
        }
    
    }

}