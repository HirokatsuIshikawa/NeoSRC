package converter.parse
{
    
    /**
     * ...
     * @author ishikawa
     */
    public class SystemParse
    {
        
        public static function parseSystenData(str:String):Object
        {
            var i:int = 0;
			var j:int = 0;
			var list:Array = null;
            // 変換データ
            var data:Object = new Object();
            data.myUnit = 0;
            data.saveNum = 4;
            // ※gは繰り返しフラグ
            // 改行
            str = str.replace(/\r\n/g, "\n");
            // タブ
            str = str.replace(/\t/g, "");
            // 半角
            str = str.replace(/ /g, "");
            var ary:Array = str.split("\n");
            
            for (i = 0; i < ary.length; i++)
            {
                var line:String = ary[i];
                var param:Array = line.split(":");
                switch (param[0].toLowerCase())
                {
                case "マイユニット": 
                case "myunit": 
                    data.myUnit = 1;
                    break;
                case "スタートファイル": 
                case "starteve": 
                    data.startEve = param[1];
                    break;
                case "セーブ名": 
                case "savename": 
                    data.saveName = param[1];
                    break;
                case "セーブ数": 
                case "savenum": 
                    data.saveNum = Number(param[1]);
                    break;
                case "参戦作品": 
                case "loaddatalist": 
                    list = param[1].split(",");
                    
                    data.loadDataList = new Array();
                    
                    for (j = 0; j < list.length; j++)
                    {
                        data.loadDataList.push(list[j]);
                    }
                    break;
				case "ユニット画像":
				case "unitimgdata":
                    list = param[1].split(",");
                    data.unitImg = new Array();
                    for (j = 0; j < list.length; j++)
                    {
                        data.unitImg.push(list[j]);
                    }
					break;
				case "会話キャラデータ":
				case "talkcharadata":
                    list = param[1].split(",");
                    data.talkcharadata = new Array();
                    for (j = 0; j < list.length; j++)
                    {
                        data.talkcharadata.push(list[j]);
                    }
					break;
				case "会話タイプ":
				case "会話スタイル":
				case "talktype":
				case "talkstyle":
					if (param[1] === "立ち絵" || param[1] === "stand")
					{
						data.talk_type = "stand";
					}
					else if (param[1] === "アイコン" || param[1] === "icon")
					{
						data.talk_type = "icon";
					}
					
					break;
                }
            }
            
            return data;
        }
    
    }

}