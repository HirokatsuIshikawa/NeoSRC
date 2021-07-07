package viewitem.parts.phone
{
	import common.CommonDef;
	import common.CommonSystem;
	import system.custom.customSprite.CButton;
	import system.custom.customSprite.CImage;
	import system.custom.customSprite.CImgButton;
	import system.custom.customSprite.CSprite;
	import feathers.controls.TextArea;
	import flash.desktop.NativeApplication;
	import flash.events.PermissionEvent;
	import flash.filesystem.File;
	import flash.permissions.PermissionStatus;
	import starling.events.Event;
	import starling.textures.Texture;
	import system.file.DataLoad;
	import viewitem.parts.list.ListSelecter;
	import viewitem.parts.pc.StartWindowPC;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class StartWindowPhone extends CSprite
	{
		private var _backImg:CImage = null;
		private var _compFunc:Function = null;
		private var _scenalioListData:Object = null;
		
		private var _scenalioList:ListSelecter = null;
		
		public function StartWindowPhone(func:Function)
		{
			CommonSystem.initPhoneInfo();
			var dir:File = File.userDirectory;
			var file:File = dir.resolvePath(CommonSystem.FOLDER_NAME + "//Scenario");
			//var file:File = dir.resolvePath("C:\\Users\\syoug\\Desktop\\Git_NeoSRC\\シナリオ");
			
			file.addEventListener(PermissionEvent.PERMISSION_STATUS, checkPermissions);
			
			try
			{
				file.requestPermission();
			}
			catch (e:Error)
			{
				// another request is in progress
				trace("REQUEST ERROR!!! : " + e.toString());
			}
			
			function checkPermissions(e:PermissionEvent):void
			{
				trace("Status is : " + e.status.toString());
				
				// does not reach to this point if user declined permission request
				if (e.status == PermissionStatus.GRANTED || e.status == PermissionStatus.ONLY_WHEN_IN_USE)
				{
					// フォルダを作成する
					if (file == null)
					{
						file.createDirectory();
					}
					loadFileList(func, file);
				}
			}
		}
		
		public function loadFileList(func:Function, homefile:File):void
		{
			
			_backImg = new CImage(CommonDef.BACK_TEX);
			
			_backImg.width = CommonDef.WINDOW_W;
			_backImg.height = CommonDef.WINDOW_H - 96;
			addChild(_backImg);
			_compFunc = func;
			            
            if(homefile.exists)
            {
                
                //CommonSystem.FILE_HEAD = "file://";
                CommonSystem.FILE_HEAD = "";
                //_scenalioListData = DataLoad.loadPhoneList([".srcsys", ".srctxt"]);
                _scenalioListData = DataLoad.loadPhoneList([".srcsys", ".srctxt"], homefile);
                _scenalioList = new ListSelecter(false);
                var ary:Array = new Array();
                var str:String;
                var findFlg:Boolean = false;
                    
                if (_scenalioListData.name.length > 0)
                {
                    for (var i:int = 0; i < _scenalioListData.count; i++)
                    {
                        if (_scenalioListData.name[i].indexOf(".srcsys") >= 0)
                        {
                            ary.push(_scenalioListData.name[i].replace(".srcsys", ""));
                        }
                        else if (_scenalioListData.name[i].indexOf(".srctxt") >= 0)
                        {
                            ary.push(_scenalioListData.name[i].replace(".srctxt", ""));
                        }
                    }
                    _scenalioList.setList(ary, loadStart);
                    _scenalioList.scale = 3;
                    addChild(_scenalioList);
                    findFlg = true;
                }
            }
			
            //ファイルが無い場合
            if(!findFlg)
			{
                homefile.createDirectory();
				var alertText:TextArea = new TextArea();
				alertText.text = "シナリオがありません\n" + CommonSystem.FOLDER_NAME + "のScenarioフォルダ内に、\nシナリオフォルダを入れてください。\n（ルートフォルダに、" + CommonSystem.FOLDER_NAME +"フォルダと、Scenarioフォルダを作成しました。）";
				alertText.width = 400;
				alertText.height = 300;
				alertText.x = (CommonDef.WINDOW_W - alertText.width) / 2
				alertText.y = ((CommonDef.WINDOW_H - 96) - alertText.height) / 2
				addChild(alertText);
				
				var endBtn:CButton = new CButton();
				endBtn.styleName = "systemBtn";
				endBtn.label = "終了";
				endBtn.width = 128;
				endBtn.height = 24;
				endBtn.x = alertText.x + alertText.width - endBtn.width - 32;
				endBtn.y = alertText.y + alertText.height - endBtn.height - 32;
				endBtn.addEventListener(Event.TRIGGERED, exitFunc);
				addChild(endBtn);
			}
		}
		
		private function loadStart(num:int):void
		{
			DataLoad.LoadPhoneData(_scenalioListData.path[num], compLoad);
		}
		
		private function exitFunc(event:Event):void
		{
			NativeApplication.nativeApplication.exit();    //アプリの終了
		}
		
		/** 読み込み完了 */
		private function compLoad(data:Object):void
		{
			_compFunc(data);
			dispose();
		}
		
		override public function dispose():void
		{
			this.parent.removeChild(this);
			
			removeChild(_scenalioList);
			for (var i:int = 0; i < _scenalioListData.name.length; i++)
			{
				_scenalioListData[i] = null;
			}
			
			_scenalioListData = null;
			
			//_btn.dispose();
			super.dispose();
		}
	
	}

}