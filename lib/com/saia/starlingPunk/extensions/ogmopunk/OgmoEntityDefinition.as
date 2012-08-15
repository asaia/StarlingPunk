package com.saia.starlingPunk.extensions.ogmopunk 
{
	import com.saia.starlingPunk.SPEntity;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author Erin M Gunn
	 */
	public class OgmoEntityDefinition 
	{
		public var name:String;
		public var className:String;
		
		public var limit:int;
		public var resizableX:Boolean;
		public var resizableY:Boolean;
		public var rotatable:Boolean;
		public var rotateIncrements:int;
		public var values:Vector.<OgmoValue>;
		
		public var size:Point;
		public var origin:Point;
		public var imageDef:ImageDefinition;
		
		public function loadData(dta:XML):SPEntity
		{
			var clsRef:Class = (getDefinitionByName(className) as Class);
			var e:SPEntity = new clsRef;
			e.x = dta.@x;
			e.y = dta.@y;
			//e.type = name;
			//e.setHitbox(size.x, size.y, origin.x, origin.y);
			var value:OgmoValue;
			for (var i:int = 0; i < values.length; i++)
			{
				value = values[i];
				if (value.type == uint) value.mValue = uint(dta.attribute(value.name).toString().replace("#", "0x"));
				else if (value.type == Boolean) value.mValue = dta.attribute(value.name).toString() == "True";
				else if (value.type == Number) value.mValue = Number(dta.attribute(value.name));
				else value.mValue = dta.attribute(value.name).toString() as value.type;
				if (e.hasOwnProperty(value.name))
				{
					if ((typeof e[value.name] == typeof Function || e[value.name] is Function) && value.type == String && clsRef.hasOwnProperty(value.value))
					{
						e[value.name] = clsRef[value.value as String];
					}
					else e[value.name] = value.value as value.type;
				}
			}
			if (resizableX) e.width = dta.@width;
			if (resizableY) e.height = dta.@height;
			
			var nodes:Vector.<Point> = new Vector.<Point>;
			for each(var node:XML in dta.children())
			{
				if (node.localName() == "node")
				{
					nodes.push(new Point(node.@x, node.@y));
				}
			}
			if (nodes.length > 0)
			{
				e["nodes"] = nodes;
			}
			
			return e;
		}
	}

}