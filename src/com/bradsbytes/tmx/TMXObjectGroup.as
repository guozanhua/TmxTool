package com.bradsbytes.tmx
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import spark.primitives.Rect;

	use namespace flash_proxy;
	
	/**
	 * Represents an object layer, or object "group," within the TMX.
	 * 
	 * <p>
	 * 	Object groups can be used in the for each .. in statement.
	 * </p>
	 * 
	 * 
	 * @example Shows how a TMXObjectGroup may be used with the for each .. in statement
	 * // We'll assume tmx is a properly-defined TMX object
	 * // and we'll also assume that layer 0 is a TMXObjectGroup
	 * 	var group : TMXObjectGroup = tmx.getLayer(0) as TMXObjectGroup;
	 * 	for each (var obj : TMXObject in group) {
	 * 		trace(obj.name); // Print the names of the objects in this group
	 * 	}
	 * 
	 * @author Brad Harms
	 */
	public class TMXObjectGroup extends AbstractTMXLayer
	{	
		protected var _objects : Vector.<TMXObject>;
		protected var _color : uint = 0x00000000;
		
		public function TMXObjectGroup(name_ : String, width_ : uint, height_ : uint) 
		{
			super(name_, width_, height_);
			_objects = new Vector.<TMXObject>;
		}
		
		/**
		 * Return the object at the given index.
		 * If the index is out of range, null is returned.
		 */
		public function getByIndex(index : int) : TMXObject {
			if (index < 0 || index > length)
				return null;
			return _objects[index];
		}
		
		/**
		 * Return the first object with the given name. If there is no object
		 * with the given name, null is returned.
		 */
		public function getByName(oname : String) : TMXObject {
			for each (var obj : TMXObject in this) {
				if (obj.name == oname)
					return obj;
			}
			return null;
		}
		
		/**
		 * The total number of objects in this group.
		 */
		public function get length() : uint {
			return _objects.length;
		}
		
		/**
		 * Add a TMXObject to the group.
		 * <p>The TMXObject must not already be a member of a TMXGroup.</p>
		 */
		public function push(obj : TMXObject) : void {
			if (obj.group === null) {
				_objects.push(obj);
				obj.setGroup(this);
			}
			else
				throw new ArgumentError("object is already a member of a group.");
		}
		
		/**
		 * The color of objects in this objectgroup. This is used by objects that do not have a tile associated with them. 
		 */
		public function get color() : uint {
			return _color;
		}
		
		/**
		 * @private
		 */
		public function set color(c:uint) : void {
			_color = c;
		}
		
		/**
		 * Draw all objects on the layer that lie within the given source rectangle.
		 * 
		 * <p>The whole object will be drawn, even if the object is not completely inside the rectangle.</p>
		 * 
		 * @param dest The bitmap data onto which the objects will be drawn.
		 * @param destPoint The position within the destination bitmap onto which the objects will be drawn.
		 * @param sourceRect The region of space (measured in pixels) from which to draw objects.
		 * @param shapeOpacity The opacity of shapes drawn by objects that do not have tiles associated with them.
		 *                     (This is multiplied by the opacity of the object group itself.) 
		 */
		public function draw(dest:BitmapData, destPoint:Point, sourceRect:Rectangle, shapeOpacity:Number = 0.0) : void {
			// TODO: Make things draw!
		}
		
		override flash_proxy function getProperty(n:*) : * {
			return _objects[n];
		}

		override flash_proxy function nextNameIndex(index:int):int {
			if (index >= _objects.length)
				return 0;
			return index + 1;
		}
		
		override flash_proxy function nextName(index:int):String {
			return String(index - 1);
		}
		
		override flash_proxy function nextValue(index:int):* {
			return _objects[index - 1];
		}
	}

}