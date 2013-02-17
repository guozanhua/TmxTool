package com.bradsbytes.tmx
{
	
	import flash.events.Event;
	
	import mx.events.PropertyChangeEvent;
	import mx.utils.ObjectProxy;

	/**
	 * Represents a whole TMX file.
	 * 
	 * <p>This is not created directly. Instead, a .tmx file is loaded using TMXLoader class.</p>
	 * 
	 * @author Brad Harms
	 * @see TMXLoader
	 */
	public class TMX 
	{
		protected var _width : uint;
		protected var _height : uint;
		protected var _tileWidth : uint;
		protected var _tileHeight : uint;
		protected var _layers : TMXLayersView;
		protected var _tilesets : TMXTilesetsView;
		protected var _properties : ObjectProxy;
		
		/**
		 * Constructs a new, empty TMX with a given size in tiles and with a given tile size.
		 */
		public function TMX(width_ : uint, height_ : uint, tileWidth_ : uint, tileHeight_ : uint) 
		{
			_width = width_;
			_height = height_;
			_tileWidth = tileWidth_;
			_tileHeight = tileHeight_;
			_tilesets = new TMXTilesetsView;
			_tilesets.setTmx(this);
			_layers = new TMXLayersView;
			_layers.setTmx(this);
			_properties = new ObjectProxy;
			_properties.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, handlePropertyChanged);
		}
		
		/**
		 *	Width of the map in tiles.
		 */
		public function get width() : uint {
			return _width;
		}
		
		/**
		 * Height of the map in tiles.
		 */
		public function get height() : uint {
			return _height;
		}
		
		/**
		 * Width of a tile on the global grid. Use this for positioning tiles in all layers, regardless of the size of the layer's tiles.
		 */
		public function get tileWidth() : uint {
			return _tileWidth;
		}
		
		/**
		 * Height of a tile on the global grid. Use this for positioning tiles in all layers, regardless of the layer's tiles.
		 */
		public function get tileHeight() : uint {
			return _tileWidth;
		}
		
		/**
		 * Provides access to the TMX's tilesets using an Array-like ordered collection.
		 * <p>Treat this property as you would an Array, except that direct assignment is not possible and pushing new
		 * tilesets onto it is bound by certain restrictions; see TMXTilesetsView for details.</p>
		 * @see TMXTilesetsView
		 */
		public function get tilesets() : TMXTilesetsView {
			return _tilesets;
		}
		
		/**
		 * Provides access to the TMX's layers using an Array-like ordered collection.
		 * <p>Treat this property as you would an Array, except that direct assignment is not possible and pushing new
		 * layers onto it is bound by certain restrictions; see TMXLayersView for details.</p>
		 * @see TMXLayersView
		 */
		public function get layers() : TMXLayersView {
			return _layers;
		}
		
		/**
		 * A proxy to the TMX's properties.
		 * <p>
		 * 	TODO: Changes to this proxy will trigger calls to the protected method handlePropertyChanged().
		 * </p>
		 */
		public function get properties() : ObjectProxy {
			return _properties;
		}
		
		/**
		 * Handles changes to the TMX properties.
		 * <p>
		 * 	This does nothing by default, but subclasses may want to use it.
		 * </p>
		 */
		public function handlePropertyChanged(e:PropertyChangeEvent) : void {
			 //Leave it to the subclasses!
		}
		
		
	}

}