package com.bradsbytes.tmx
{
	import flash.display.BitmapData;
	
	import mx.utils.ObjectProxy;

	/**
	 * Represents one of the tiles within a tile set.
	 * <p>
	 * Again, these should not be created directly. This is the job of the TMXLoader.
	 * </p>
	 * <p>
	 * A tile contains the bitmap data from the appropriate portion of the tileset's image.
	 * </p>
	 * <p>
	 * A tile has a link back to its parent tileset via the <code>tileset</code> property.
	 * </p>
	 * @author Brad Harms
	 */
	public class TMXTile extends AbstractTMXObject
	{
		
		private var _index : uint;
		private var _tileset : TMXTileset = null;
		private var _bitmapData : BitmapData;
		
		/**
		 * Constructor.
		 */
		public function TMXTile(index_ : uint, bitmapData_ : BitmapData) 
		{
			super();
			_index = index_;
			_bitmapData = bitmapData_;
		}
		
		
		/**
		 * The index number of this tile within the tile set.
		 */
		public function get index():uint {
			return _index;
		}
		
		/**
		 * The "global identifier," which is used to identify the tile across all tilesets and layers.
		 * This number will always be at least 1, and may be larger than the number of tiles within the tile set.
		 */
		public function get gid():uint {
			return tileset.firstgid + index;
		}
		
		/**
		 * A link back to the containing tileset.
		 */
		public function get tileset() : TMXTileset {
			return _tileset;
		}
		
		/**
		 * Used by the creating TMXTileset to properly associate the tile with the tileset.
		 */
		internal function setTileset(tileset_ : TMXTileset) : void {
			_tileset = tileset_;
		}
		
		/**
		 * Bitmap data copied from the parent tileset's.
		 */
		public function get bitmapData() : BitmapData {
			return _bitmapData;
		}
	}

}