package system.custom.customTheme
{
	import system.custom.customTheme.CustomTheme;
	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.NumericStepper;
	import feathers.controls.PickerList;
	import feathers.controls.Radio;
	import feathers.controls.Slider;
	import feathers.controls.TextArea;
	import feathers.controls.TextInput;
	import feathers.controls.ToggleSwitch;

	import feathers.controls.ToggleButton;
	import feathers.core.ToggleGroup;
	import feathers.data.ListCollection;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;

	/**
	 * ...
	 * @author ishikawa
	 */
	public class ThemeTest extends Sprite
	{

		protected var theme:CustomTheme;

		public function ThemeTest()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(e:Event):void
		{
			//カスタムテーマ設定
			this.theme = new CustomTheme();

			//デフォルトボタン
			var specialButton:Button = new Button();
			specialButton.label = "Default";
			this.addChild(specialButton);

			//テーマ指定ボタン
			var specialButton2:Button = new Button();
			specialButton2.label = "Style";
			specialButton2.styleNameList.add("custom-button");
			specialButton2.y = 200;
			this.addChild(specialButton2);
			//デフォルトスライダー
			var slider0:Slider = new Slider();
			slider0.x = stage.stageWidth * 0.15;
			slider0.y = stage.stageHeight * 0.1;
			slider0.width = 400;
			slider0.height = 4;
			slider0.minimum = 0;
			slider0.maximum = 2;
			slider0.value = 1;
			slider0.page = 0.5;
			slider0.step = 0.05;
			this.addChild(slider0);
			//テーマ指定スライダー
			var slider1:Slider = new Slider();
			slider1.styleNameList.add("volum-slider");
			slider1.x = stage.stageWidth * 0.15;
			slider1.y = stage.stageHeight * 0.2;
			slider1.width = 320;
			slider1.height = 12;
			slider1.minimum = 0;
			slider1.maximum = 100;
			slider1.value = 50;
			slider1.page = 0.5;
			slider1.step = 0.05;
			this.addChild(slider1);

			//ラジオボタン・デフォルト
			var group:ToggleGroup = new ToggleGroup();

			var radio1:Radio = new Radio();
			radio1.label = "One";
			radio1.toggleGroup = group;
			radio1.y = 300;
			this.addChild(radio1);

			var radio2:Radio = new Radio();
			radio2.label = "Two";
			radio2.toggleGroup = group;
			radio2.y = 320;
			this.addChild(radio2);

			var radio3:Radio = new Radio();
			radio3.label = "Three";
			radio3.toggleGroup = group;
			radio3.y = 340;
			this.addChild(radio3);

			var radio4:Radio = new Radio();
			radio4.label = "None";
			radio4.toggleGroup = group;
			radio4.y = 360;
			radio4.isEnabled = false;
			this.addChild(radio4);

			//group.addEventListener( Event.CHANGE, group_changeHandler );

			//チェックボックス
			var check:Check = new Check();
			check.label = "Pick Me!";
			check.isSelected = true;
			check.y = 400;
			//check.addEventListener( Event.CHANGE, check_changeHandler );
			this.addChild(check);

			//チェックボックス
			var check_2:Check = new Check();
			check_2.label = "Pick Me!";
			check_2.isSelected = true;
			check_2.y = 420;
			check_2.isEnabled = false;
			check_2.isSelected = false;
			//check.addEventListener( Event.CHANGE, check_changeHandler );
			this.addChild(check_2);

			//入力エリア
			var input:TextInput = new TextInput();
			input.text = "Hello World";
			input.x = 160;
			input.y = 20;
			input.width = 360;
			input.setSize(360, 24);
			this.addChild(input);

			//テキスト表示エリア
			var textArea:TextArea = new TextArea();
			textArea.text = "Hello\nWorld";
			textArea.x = 160;
			textArea.y = 160;
			textArea.setSize(400, 160);
			this.addChild(textArea);

			//ステッパー
			var stepper:NumericStepper = new NumericStepper();
			stepper.x = 160;
			stepper.y = 340;
			stepper.minimum = 0;
			stepper.maximum = 100;
			stepper.step = 1;
			stepper.value = 50;
			stepper.width = 100;
			stepper.textInputProperties
			this.addChild(stepper);
			/*
			   var toggleS:ToggleSwitch = new ToggleSwitch();
			   toggleS.isSelected = true;
			   toggleS.x = 400;
			   toggleS.y = 280;
			   toggleS.trackLayoutMode = ToggleSwitch.TRACK_LAYOUT_MODE_ON_OFF;
			   toggleS.addEventListener( Event.CHANGE, toggle_changeHandler );
			   this.addChild( toggleS );
			 */

			var toggleB:ToggleButton = new ToggleButton();
			toggleB.isSelected = true;
			toggleB.x = 400;
			toggleB.y = 340;
			this.addChild(toggleB);

			//ドロップダウンリスト
		/*
		   var list:PickerList = new PickerList();
		   list.labelField = "text";
		   list.x = 160;
		   list.y = 340;
		   list.listProperties.@itemRendererProperties.labelField = "text";
		   list.listProperties.@itemRendererProperties.iconSourceField = "thumbnail";
		   this.addChild( list );
		   //リスト一覧
		   var groceryList:ListCollection = new ListCollection(
		   [
		   { text: "Milk", thumbnail: Texture.fromBitmap(new Bitmap(new BitmapData(20,20,true,0xFFFFFFFF))) },
		   { text: "Eggs", thumbnail: Texture.fromBitmap(new Bitmap(new BitmapData(20,20,true ,0xFFFFFF00))) },
		   { text: "Bread", thumbnail: Texture.fromBitmap(new Bitmap(new BitmapData(20,20,true ,0xFFFFFF00))) },
		   { text: "Chicken", thumbnail: Texture.fromBitmap(new Bitmap(new BitmapData(20,20,true ,0xFFFFFF00))) },
		   ]);
		   list.dataProvider = groceryList;
		   list.prompt = "Select an Item";
		   list.selectedIndex = -1;
		 */
		}

		private function slider_onChange(evt:Event):void
		{

			var slider1:Slider = evt.target as Slider;
		/*
		   logo1.scaleX = 2 - slider.value;
		   logo1.scaleY = 2 - slider.value;
		   logo2.scaleX = -slider.value;
		   logo2.scaleY = slider.value;
		 */

		/*
		   var slider0:Slider = new Slider();
		   slider0.x = stage.stageWidth * 0.15;
		   slider0.y = stage.stageHeight * 0.1;
		   slider0.minimum = 0;
		   slider0.maximum = 2;
		   slider0.value = 1;
		   slider0.page = 0.5;
		   slider0.step = 0.05;
		   slider0.direction = Slider.DIRECTION_HORIZONTAL;     //横方向のslider指定
		   slider0.thumbProperties.defaultSkin = new Image( Texture.fromBitmap( new img_slide() ) );
		   slider0.thumbProperties.downSkin = new Image( Texture.fromBitmap( new img_slide2() ) );
		   slider0.minimumTrackProperties.defaultSkin = new Image( Texture.fromBitmap( new Bitmap(new BitmapData(256,12,true, 0xFF00FF00)) ) );
		   slider0.minimumTrackProperties.downSkin = new Image( Texture.fromBitmap( new Bitmap(new BitmapData(256,12,true, 0xFFFF0000)) ) );
		   slider0.addEventListener( Event.CHANGE, slider_onChange );
		   this.addChild( slider0 );
		 */
		}

		//切り替えスイッチイベント
		private function toggle_changeHandler(event:Event):void
		{
			//var toggle:ToggleSwitch = ToggleSwitch( event.currentTarget );
			//trace( "toggle.isSelected changed:", toggle.isSelected );
		}

		//ラジオボタン選択時
		private function group_changeHandler(event:Event):void
		{
			var group:ToggleGroup = ToggleGroup(event.currentTarget);
			trace("group.selectedIndex:", group.selectedIndex);
		}

		//チェックボックス選択時
		private function check_changeHandler(event:Event):void
		{
			var check:Check = Check(event.currentTarget);
		}

	}

}