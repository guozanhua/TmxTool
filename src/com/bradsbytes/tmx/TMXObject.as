package com.bradsbytes.tmx
{
	import flash.display.BitmapData;
	import flash.geom.Point;
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
		
		/**
		 * Draw the object onto a BitmapData.
		 * 
		 * <p>Objects are drawn differently depending on several factors. If the object has a tile associated
		 * with it, it is drawn using that tile. The tile will be drawn at the given location, but will be offset upwards
		 * by a distance equal to the difference between the tile's height and the tile-height of the TMX. This is
		 * done to be consistent with the .tmx file spec, which says that oversized tiles are drawn from the bottom-left
		 * corner, rather than the top-left.</p>
		 * 
		 * <p>If there is no tile associated with an object but it has a width and height, the tile will draw itself using
		 * a simple colored rectangle. The color of the rectangle is taken from the color's parent group, and the opacity
		 * will be the shapeOpacity that was given to the draw method.</p>
		 * 
		 * <p>Finally, if the object has no tile and no size, it will be drawn as a circle centered around the given point
		 * with a diameter equal to the average of the tile-width and tile-height of the TMX. As with the rectangle,
		 * the color comes from the parent object group and the opacity is that which is given.</p>   
		 * 
		 * @param dest The bitmap data onto which the object will be drawn.
		 * @param destPoint The position within the bitmap at which the object will be drawn.
		 */
		public function draw(dest:BitmapData, destPoint:Point, shapeOpacity : Number = 0.0) : void {
			if (tile !== null) {
				// TODO: Make things draw!
			}
		}
	}

}