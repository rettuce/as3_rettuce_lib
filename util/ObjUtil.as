/**
 * 
 *  Dump ユーティリティクラス
 *  Object -> String
 * 	trace(ObjUtil.toString(obj));
 *  参考 : http://adalberyo.blog116.fc2.com/blog-entry-96.html
 * 
 */
package com.rettuce.util
{
	import flash.utils.getQualifiedClassName;
	public class ObjUtil
	{
		public function ObjUtil(){
			throw new ArgumentError( "Error #2012: ObjectUtil クラスを直接インスタンス化することはできません。" );
		}
		/**
		 * Object -> String変換
		 */
		public static function toString( target:Object ):String {
			
			var str:String = "{\n ";
			
			for ( var value:String in target ) {
				str += "\"" + value + "\"" + ":";
				switch ( getQualifiedClassName( target[value] ) ) {
					case "Array"  : {
						str += "[";
						for (var n:* = 0; n < target[value].length; n++) {
							str += arguments.callee( target[value][n] ) + ",";
						}
						str = str.substring( 0, str.lastIndexOf(",")) + "]";
						break;
					}
					case "Boolean" : { str += target[value]; break; }
					case "int"  : { str += target[value].toString(); break; }
					case "Number"  : { str += target[value].toString(); break; }
					case "Date"   : { str += target[value].toString(); break; }
					case "uint"   : { str += target[value].toString(); break; }
					case "String"  : { str += "\"" + target[value] + "\""; break; }
					case "Object"  : { str += ObjUtil.toString( target[value] ).replace(/\n/g, "\n "); break; }
					default     :
				}
				str += ",\n ";
			}
			
			// 末尾の改行を削除する
			str = str.substring( 0, str.lastIndexOf(","));
			str += "\n}";
			return str;
		}
	}
}
