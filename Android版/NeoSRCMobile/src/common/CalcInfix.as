package common
{
	
	public class CalcInfix
	{
		public var items:Array;
		
		public function Expression():Number
		{
			//--- 中置記法を逆ポーランドに変換
			var stack:Array = [];
			var polish:Array = [];
			var priority:Object = { //
				'func': 6, 'num': 6, //
				'^': 5, //
				'*': 4, '/': 4, '%': 4, //
				'+': 3, '-': 3, //
				'(': 2, //
				'and': 0, '&&': 0, 'or': 0, '||': 0, //
				'==': 1, '>=': 1, '>': 1, '<=': 1, '<': 1 //
			};
			var getPriority:Function = function(s:String):int
			{
				if (priority[s] != undefined)
				{
					return priority[s];
				}
				if (s.match("^\w+$") != null)
				{
					return priority["func"];
				}
				return priority["num"];
			};
			var top:String;
			for each (var tmp:String in items)
			{
				if (tmp == "" || tmp == " ") continue;
				if (tmp == "(")
				{
					stack.push(tmp);
				}
				else if (tmp == ")")
				{
					while (stack.length > 0)
					{
						top = stack[stack.length - 1];
						if (top != "(")
						{
							polish.push(stack.pop());
						}
						else break;
					}
					stack.pop();// skip '('
					
				}
				else
				{
					while (stack.length > 0)
					{
						top = stack[stack.length - 1];
						if (getPriority(tmp) <= getPriority(top))
						{
							polish.push(stack.pop());
						}
						else break;
					}
					stack.push(tmp);
				}
					// DEBUG
					//trace("polish=", polish.join(" "));
					//trace("stack =", stack.join(" "));
					//trace("---");
			}
			while (stack.length > 0)
			{
				polish.push(stack.pop());
			}
			return calcPostfix(polish);
		}
		
		public static function calcPostfix(polish:Array):Number
		{
			var stack:Array = [];
			var v1:Number, v2:Number;
			var s1:String, s2:String;
			var getStack2:Function = function():void
			{
				s2 = stack.pop();
				s1 = stack.pop();
				
				if (s2 === "false")
				{
					v2 = 0;
					s2 = null;
				}
				else if (s2 === "true")
				{
					v2 = 1;
					s2 = null;
				}
				else if (!isNaN(Number(s2)))
				{
					v2 = Number(s2);
					s2 = null;
				}
				
				if (s1 === "false")
				{
					v1 = 0;
					s1 = null;
				}
				else if (s1 === "true")
				{
					v1 = 1;
					s1 = null;
				}
				else if (!isNaN(Number(s1)))
				{
					v1 = Number(s1);
					s1 = null;
				}
			};
			var getStack1:Function = function():void
			{
				s1 = stack.pop();
				v1 = Number(s1);
			};
			for each (var i:String in polish)
			{
				i = i.toLowerCase();
				switch (i)
				{
				// 演算子
				case '+': 
					getStack2();
					stack.push(v1 + v2);
					break;
				case '-': 
					getStack2();
					stack.push(v1 - v2);
					break;
				case '*': 
					getStack2();
					stack.push(v1 * v2);
					break;
				case '/': 
					getStack2();
					stack.push(v1 / v2);
					break;
				case '%': 
					getStack2();
					stack.push(v1 % v2);
					break;
				case '^': 
					getStack2();
					stack.push(Math.pow(v1, v2));
					break;
				case '==': 
					getStack2();
					if (s1 != null && s2 != null)
					{
						stack.push(s1 === s2);
					}
					else
					{
						stack.push(v1 == v2);
					}
					break;
				case '!=': 
					getStack2();
					stack.push(v1 != v2);
					break;
				case '===': 
					getStack2();
					stack.push(s1 === s2);
					break;
				case '>': 
					getStack2();
					stack.push(v1 > v2);
					break;
				case '>=': 
					getStack2();
					stack.push(v1 >= v2);
					break;
				case '<': 
					getStack2();
					stack.push(v1 < v2);
					break;
				case '<=': 
					getStack2();
					stack.push(v1 <= v2);
					break;
				case '&&': 
				case 'and': 
					getStack2();
					stack.push(v1 && v2);
					break;
				case '||': 
				case 'or': 
					getStack2();
					stack.push(v1 || v2);
					break;
				// 関数
				case 'floor': 
					getStack1();
					stack.push(Math.floor(v1));
					break;
				case 'ceil': 
					getStack1();
					stack.push(Math.ceil(v1));
					break;
				case 'random': 
					getStack1();
					stack.push(Math.floor(Math.random() * v1));
					break;
				case 'sin': 
					getStack1();
					stack.push(Math.sin(v1));
					break;
				case 'cos': 
					getStack1();
					stack.push(Math.cos(v1));
					break;
				case 'tan': 
					getStack1();
					stack.push(Math.tan(v1));
					break;
				case 'asin': 
					getStack1();
					stack.push(Math.asin(v1));
					break;
				case 'acon': 
					getStack1();
					stack.push(Math.acos(v1));
					break;
				case 'atan': 
					getStack1();
					stack.push(Math.atan(v1));
					break;
				case 'abs': 
					getStack1();
					stack.push(Math.abs(v1));
					break;
				default: 
					stack.push(i);
					break;
				}
			}
			return Number(stack.pop());
		}
		
		private function checkMinus():void
		{
			var tmp:String;
			// 先頭のマイナスを数値に反映させる
			if (items[0] == "-")
			{
				items[1] = items[1] * -1;
				items.shift();
			}
			// 演算子の直後のマイナスを数値に反映させる
			var enzansi:String = "()+-*/%^";
			var i:int = 0;
			while (i < items.length)
			{
				if (enzansi.indexOf(items[i]) >= 0)
				{
					if (items[i + 1] == "-")
					{
						items[i + 2] = items[i + 2] * -1;
						items.splice(i + 1, 1);
					}
				}
				i++;
			}
		}
		
		/**
		 * 文字列の計算式を計算して返す
		 * @param    e    文字列で計算式を指定する(中置記法)
		 * @rerurn        計算結果
		 */
		public static function eval(e:String):Number
		{
			// 数値と演算子を区切る
			//e = e.replace(/\s*/g, ''); // 空白を除去
			e = e.replace(/((\d+\.\d+|\d+))/g, ' $1 '); // 数値の後にスペース
			e = e.replace(/([a-z\_]+)/g, ' $1 '); // 関数の後にスペース
			e = e.replace(/([\%\(\)\-\^\+\*\/\^])/g, ' $1 ');
			
			while (e.indexOf("  ") >= 0)
			{
				e = xReplace(e, '  ', ' ');
			}
			
			var p:CalcInfix = new CalcInfix();
			p.items = e.split(/\s/);
			p.checkMinus();
			return p.Expression();
		}
		
		public static function xReplace(source_str:String, find_str:String, replace_str:String):String
		{
			var numChar:uint = find_str.length;
			var end:int;
			var result_str:String = "";
			for (var i:uint = 0; -1 < (end = source_str.indexOf(find_str, i)); i = end + numChar)
			{
				result_str += source_str.substring(i, end) + replace_str;
			}
			result_str += source_str.substring(i);
			return result_str;
		}
	
	}

}

