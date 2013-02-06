package com.bradsbytes.tmx
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	/**
	 * Represents one of the tilesets within the .tmx file.
	 * <p>
	 * 	The TMXTileset class supports most of the same operations an Array.
	 * </p>
	 * @author Brad Harms
	 */
	public class TMXTileset extends Proxy
	{
		protected var _name : String;
		protected var _firstgid : uint;
		protected var _source : String;
		protected var _bitmapData : BitmapData;
		protected var _tmx : TMX = null;
		protected var _tiles : Vector.<TMXTile>;
		protected var _tileWidth : uint;
		protected var _tileHeight : uint;
		
		/**
		 * Constructor.
		 */
		public function TMXTileset(name_ : String, firstgid_ : uint, tileWidth_ : uint, tileHeight_ : uint, source_ : String, bitmapData_ : BitmapData) 
		{
			_name = name_;
			_firstgid = firstgid_;
			_tileWidth = tileWidth_;
			_tileHeight = tileHeight_;
			_source = source_;
			_bitmapData = bitmapData_;
			_tiles = new Vector.<TMXTile>;
			
			var rows : uint = bitmapData.height / tileHeight;
			var cols : uint = bitmapData.width / tileWidth;
			var tid : uint = 0;
			for (var row : uint = 0; row < rows; row++) {
				for (var col : uint = 0; col < cols; col++) {
					var rect : Rectangle = new Rectangle(col * tileWidth, row * tileHeight, tileWidth, tileHeight); 
					var tile : TMXTile = createTile(tid, bitmapData, rect);
					push(tile);
					tile.setTileset(this);
					tid++;
				}
			}
		}
		
		/**
		 * Create a new tile to push into the tileset.
		 * 
		 * <p>
		 * 	This is used by the constructor to generate all tiles. Override it to change the way tiles are created.
		 * </p>
		 * <p>
		 * 	Note that the bitmap and rectangle given do not necessarily have to be used.
		 * </p>
		 * 
		 * @param index The index of this tile within the parent tileset.
		 * @param srcBitmap The source bitmap from which the tile will take its own bitmap data.
		 * @param rect The rectangular area of the source bitmap to use.
		 * 
		 */
		protected function createTile(index : uint, srcBitmap : BitmapData, rect : Rectangle) : TMXTile {
			var bmp : BitmapData = new BitmapData(tileWidth, tileHeight, true, 0x00000000);
			bmp.copyPixels(srcBitmap, rect, new Point(0, 0));
			var tile : TMXTile = new TMXTile(index, bmp);
			return tile;
		}
		
		/**
		 * Name of the tileset.
		 */
		public function get name() : String {
			return _name;
		}
		
		/**
		 * The first (lowest) "global tile identifier" of any tile in the tileset.
		 */
		public function get firstgid() : uint {
			return _firstgid;
		}
		
		/**
		 * The last (highest) gid of any tile in the tileset. Equal to firstgid + length - 1.
		 */
		public function get lastgid() : uint {
			return firstgid + length - 1;
		}
		
		/**
		 * The source file path of the bitmap data.
		 */
		
		public function get source() : String {
			return _source;
		}
		
		/**
		 * The image that contains all the tile bitmap data that is shared by all tiles in the tileset.
		 */
		public function get bitmapData() : BitmapData {
			return _bitmapData;
		}
		
		/**
		 * A link back to the containing map.
		 */
		public function get tmx() : TMX {
			return _tmx;
		}
		
		internal function setTmx(tmx_:TMX) : void {
			_tmx = tmx_;
		}
		
		/**
		 * Width of tiles within the tileset in pixels. This may differ from the tile width of the map.
		 */
		public function get tileWidth() : uint {
			return _tileWidth;
		}
		
		/**
		 * Height of tiles within the tileset in pixels. This may differ from the tile height of the map.
		 */
		public function get tileHeight() : uint {
			return _tileHeight;
		}
		
		/**
		 * Get the tile with the given local ID.
		 */
		public function getTile(tid:uint) : TMXTile {
			return _tiles[tid];
		} 
		
		/**
		 * Returns the TMXTile with the given "global tile identifier," or "GID," which is used to
		 * represent the tile within tile layers. If 0 is given or if no tile can be found with the
		 * given id within this tileset, null is returned.
		 * @param	gid
		 * @return
		 */
		public function getByGid(gid:uint) : TMXTile {
			if (gid < firstgid || gid > lastgid)
				return null;
			else 
				return this[gid - firstgid];
		}
		
		// TODO: getByProperties([pname, ...]) --> [tile, ...]
		// (Return a list of all tiles with the given property names)
		
		// TODO: getByPropertyValues({pname:pvalue, ...}) --> [tile, ...]
		// (Return a list of all tiles with properties that have the given values)
		
		/**
		 * Pushes a new tile to the end of the tileset.
		 * <p>
		 * 	Should only be used during construction as the number of
		 *  tiles in a tileset is fixed after initialization, and no tiles
		 *  can be added or removed. 
		 * </p>
		 */
		protected function push(tile:TMXTile) : void {
			_tiles.push(tile);
		}
		
		/**
		 * Total number of tiles in the tileset.
		 */
		public function get length():uint {
			return _tiles.length;
		}
		
		override flash_proxy function getProperty(n : *) : * {
			if (!(n is int))
			return _tiles[n as int];
		}
		
		override flash_proxy function nextNameIndex(index:int):int {
			if (index > _tiles.length)
				return 0;
			return index + 1;
		}
		
		override flash_proxy function nextName(index:int):String {
			return String(index - 1);
		}
		
		override flash_proxy function nextValue(index:int):* {
			return _tiles[index - 1];
		}
	}

}