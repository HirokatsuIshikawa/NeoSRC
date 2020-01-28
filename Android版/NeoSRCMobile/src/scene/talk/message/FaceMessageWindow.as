package scene.talk.message
{
	import common.CommonSystem;
	import system.custom.customSprite.CImage;
	import system.custom.customSprite.ImageBoard;
	import database.user.FaceData;
	import starling.display.Quad;
	import scene.main.MainController;
	import scene.talk.message.MessageWindow;
	
	/**
	 * ...
	 * @author
	 */
	public class FaceMessageWindow extends MessageWindow
	{
		
		/**表示顔画像*/
		private var _faceImg:ImageBoard = null;
		
		public function FaceMessageWindow()
		{
			super();
			
			_nameTxt.x = 160;
			_nameTxt.y = 0;
			_textArea.x = 160;
			_textArea.y = 28;
			_faceImg = new ImageBoard();
			addChild(_faceImg);
		}
		
		public function setImage(name:String, command:Array):void
		{
			var i:int = 0;
			var j:int = 0;
			var k:int = 0;
			_charaName = name;
			_faceImg.imgClear();
			//var selectData:MasterCharaData = CharaDataUtil.getMasterCharaDataName(name);
			var imgData:FaceData = MainController.$.model.getCharaImgDataFromName(name);
			var mask:Quad = null;
			
			switch (imgData.defaultType)
			{
			case "stand": 
				mask = new Quad(160, imgData.addPoint.y);
				mask.x = 0;
				mask.y = 160 - imgData.addPoint.y;
				_faceImg.mask = mask;
				break;
			case "icon": 
				break;
			}
			
			//画像セット
			_faceImg.setAdd(imgData.addPoint.x, imgData.addPoint.y);
			
			var showList:Vector.<String> = new Vector.<String>;
			
			for (i = 0; i < imgData.basicList.length; i++)
			{
				showList[i] = imgData.basicList[i];
			}
			
			for (j = 2; j < command.length; j++)
			{
				var str:String = command[j];
				if (str.indexOf(":") >= 0)
				{
					continue;
				}
				
				for (k = 0; k < imgData.imgList.length; k++)
				{
					if (str === imgData.imgList[k].name)
					{
						showList[imgData.imgList[k].layer] = imgData.imgList[k].name;
					}
				}
			}
			
			for (i = 0; i < showList.length; i++)
			{
				//var faceImg:CImage = new CImage(TextureManager.loadTexture(imgData.imgUrl, imgData.getFileName(showList[i]), TextureManager.TYPE_CHARA));
				var faceImg:CImage = new CImage(MainController.$.imgAsset.getTexture(imgData.getFileName(imgData.getFileName(showList[i]))));
				_faceImg.addImage(faceImg, imgData.defaultType);
			}
			
			//_faceImg = MainController.$.model.getCharaBaseImg(name, MainModel.IMG_BOARD_FACE);
			_nameTxt.text = name;
		}
		
		override public function dispose():void
		{
			//_textArea.textViewPort.textField.filters = null;
			super.dispose();
		}
	}
}