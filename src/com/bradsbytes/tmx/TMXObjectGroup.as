package com.bradsbytes.tmx
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

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

		override flash_proxy function nextNameIndex(index:int):int {
			if (index > _objects.length)
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