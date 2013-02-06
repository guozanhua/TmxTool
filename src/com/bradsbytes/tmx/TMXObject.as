package com.bradsbytes.tmx
{
	import flash.geom.Rectangle;
	
	import mx.events.PropertyChangeEvent;
	import mx.utils.ObjectProxy;
	
	/**
	 * Represents one of the objects of an object layer (object group) within the .tmx file.
	 * @author Brad Harms
	 */
	public class TMXObject extends AbstractTMXObject
	{
		private var _name : String;
		private var _type : String;
		private var _rect : Rectangle;
		private var _tile : TMXTile;
		
		private var _group : TMXObjectGroup = null;
		
		/**
		 * Constructor.
		 */
		public function TMXObject(name_ : String, type_ : String, rect_ : Rectangle) 
		{
			super();
			_name = name_;
			_type = type_;
			_rect = rect_;
			_tile = null;
		}
		
		/**
		 * Name of the object. Need not be unique, but should be. Also doesn't need to be present.
		 */
		public function get name() : String {
			return _name;
		}
		
		/**
		 * @private
		 */
		public function set name(name_:String) : void {
			_name = name_;
		}
		
		/**
		 * Type string of the object. This is separate from the name of the name of the object's group, but has a similar meaning.
		 */
		public function get type() : String {
			return _type;
		}
		
		/**
		 * @private
		 */
		public function set type(type_ : String) : void {
			_type = type_;
		}
		
		/**
		 * Boundries of the object in pixels. The width and height may be 0,0, in which case the object is a "point" object and has no size.
		 */
		public function get rect() : Rectangle {
			return _rect;
		}
		
		/**
		 * The tile used to represent this object, if any.
		 * <p>
		 * The tile size need not match the object rect size. If a tile is present
		 * and the rect width or height is 0, the tile's width AND height may be used
		 * instead of the rect's width and height. (TmxTool does not force this, however.)
		 */
		public function get tile() : TMXTile {
			return _tile;
		}
		
		/**
		 * @private
		 */
		public function set tile(tile_ : TMXTile) : void {
			_tile = tile_;
		}
		
		/**
		 * Link back to the containing object group.
		 */
		public function get group() : TMXObjectGroup {
			return _group;
		}
		
		/**
		 * Used by TMXObjectGroup to properly set the object's group.
		 */
		internal function setGroup(group_ : TMXObjectGroup) : void {
			_group = group_;
		}
	}

}