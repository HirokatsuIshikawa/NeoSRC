package parts.popwindow
{
    import dataloader.MapLoader;
    import feathers.controls.Button;
    import feathers.controls.NumericStepper;
    import feathers.controls.TextArea;
    import feathers.controls.TextInput;
    import feathers.controls.text.StageTextTextEditor;
    import feathers.core.ITextEditor;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.filesystem.File;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.textures.Texture;
    import system.CommonSystem;
    import system.UserImage;
    import system.UserImage;
    import system.file.DataLoad;
    import main.MainController;
    import main.MainViewer;
    
    /**
     * ...
     * @author
     */
    public class StartWindow extends Sprite
    {
        public static var invokePath:String = null;
        
        private var _loadBtn:Button = null;
        private var _createBtn:Button = null;
        
        /**背景*/
        private var _backImg:Image = null;
        /**縦サイズ*/
        private var _widthLabel:TextArea = null;
        private var _widthStep:NumericStepper = null;
        /**横サイズ*/
        private var _heightLabel:TextArea = null;
        private var _heightStep:NumericStepper = null;
        /**ファイル名*/
        private var _textInput:TextInput = null;
        /**シナリオパス名*/
        private var _pathName:TextArea = null;
        private var _pathButton:Button = null;
        
        public function StartWindow()
        {
            super();
            
            //直接起動時
            if (invokePath != null)
            {
                var sysPath:String = CommonSystem.getSystemPath(invokePath);
                
                compPathSet(sysPath);
                MainController.$.view.mapLoader.loadInvokePath(invokePath);
            }
            else
            {
                _backImg = new Image(Texture.fromBitmapData(new BitmapData(240, 160, true, 0x99FF3333)));
                addChild(_backImg);
                
                //入力欄
                _textInput = new TextInput();
                _textInput.text = "新しいマップ";
                _textInput.textEditorFactory = function():ITextEditor
                {
                    var stageTextTextEditor:StageTextTextEditor = new StageTextTextEditor();
                    stageTextTextEditor.multiline = false;
                    return stageTextTextEditor;
                }
                _textInput.backgroundSkin = new Image(Texture.fromBitmap(new Bitmap(new BitmapData(80, 24, true, 0xFF7733FF))));
                _textInput.x = 8;
                _textInput.y = 16;
                _textInput.width = 220;
                addChild(_textInput);
                
                //横ラベル
                _widthLabel = new TextArea();
                _widthLabel.text = "横";
                _widthLabel.x = 16;
                _widthLabel.y = 48;
                addChild(_widthLabel);
                //横
                _widthStep = new NumericStepper();
                _widthStep.x = 48;
                _widthStep.y = 48;
                _widthStep.maximum = 60;
                _widthStep.minimum = 15;
                _widthStep.value = 30;
                _widthStep.step = 1;
                addChild(_widthStep);
                //縦ラベル
                _heightLabel = new TextArea();
                _heightLabel.text = "縦";
                _heightLabel.x = 128;
                _heightLabel.y = 48;
                addChild(_heightLabel);
                
                //縦
                _heightStep = new NumericStepper();
                _heightStep.x = 160;
                _heightStep.y = 48;
                _heightStep.maximum = 60;
                _heightStep.minimum = 15;
                _heightStep.value = 20;
                _heightStep.step = 1;
                addChild(_heightStep);
                
                //読み込みボタン
                _loadBtn = new Button();
                _loadBtn.x = 4;
                _loadBtn.y = 92;
                _loadBtn.width = 64;
                _loadBtn.height = 24;
                
                _loadBtn.label = "新規";
                _loadBtn.addEventListener(Event.TRIGGERED, function():void
                {
                    _loadBtn.touchable = false;
                    _createBtn.touchable = false;
                    _pathButton.touchable = false;
                    MainController.$.view.mapLoader.mapName = _textInput.text;
                    MainController.$.view.canvas.setTipArea(_widthStep.value, _heightStep.value);
                    UserImage.$.loadAssetStart(MainController.$.view.endStartWindow);
                    //MainController.$.view.endStartWindow();
                });
                addChild(_loadBtn);
                //新規作成ボタン
                _createBtn = new Button();
                _createBtn.x = 72;
                _createBtn.y = 92;
                _createBtn.width = 64;
                _createBtn.height = 24;
                _createBtn.label = "読込";
                _createBtn.addEventListener(Event.TRIGGERED, function():void
                {
                    if (_textInput.text.length > 0)
                    {
                        //UserImage.$.loadAssetStart(MainController.$.view.mapLoader.loadMapData);
                        MainController.$.view.mapLoader.loadMapData();
                    }
                });
                addChild(_createBtn);
                
                _pathButton = new Button();
                _pathButton.x = 72;
                _pathButton.y = 128;
                _pathButton.width = 64;
                _pathButton.height = 24;
                _pathButton.label = "シナリオ";
                _pathButton.addEventListener(Event.TRIGGERED, setPath);
                
                addChild(_pathButton);
                
                _pathName = new TextArea();
                _pathName.x = 0;
                _pathName.y = 160;
                _pathName.width = 240;
                _pathName.height = 240;
                _pathName.text = MainViewer.SCENARIO_PATH;
                addChild(_pathName);
            }
        }
        
        private function setPath(e:Event):void
        {
            MapLoader.LoadFolderPath(compPathSet);
        }
        
        private function compPathSet(path:String):void
        {
            CommonSystem.setScenarioPath(path);
            if (_pathName != null)
            {
                _pathName.text = MainViewer.SCENARIO_PATH;
            }
        }
        
        private function compLoad(data:Object):void
        {
            CommonSystem.SCENARIO_PATH = data.path;
            MainController.$.view.mapLoader.mapName = _textInput.text;
            MainController.$.view.canvas.setTipArea(_widthStep.value, _heightStep.value);
            MainController.$.view.endStartWindow();
        }
    
    }

}