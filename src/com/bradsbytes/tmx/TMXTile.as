package com.bradsbytes.tmx
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;

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
		// Used when drawing the tile
		static private var _mat : Matrix = new Matrix;
		
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
		
		/**
		 * Draw the tile at the given location.
		 * 
		 * <p>According to the .tmx spec, oversized tiles are drawn from
		 * the BOTTOM-LEFT (not top-left) corner of their layer's cells.
		 * (This allows extra-tall tiles to appear to rise up into the air,
		 * as with buildings or plants.)
		 * This means that a different offset calculation is used for the X
		 * axis than for the Y axis. </p>
		 * 
		 * <p>Example:</p>
		 * <pre><code>
		 *   Normal-sized    Oversized
		 *
		 *   +---+---+---+   +---+---+---+   
		 *   |   |   |   |   |   |.....  |
		 *   +---+---+---+   +---+.....--+  <-- Goes up and to the right, not down
		 *   |   |...|   |   |   |.....  |
		 *   +---+---+---+   +---+---+---+
		 *   |   |   |   |   |   |   |   |
		 *   +---+---+---+   +---+---+---+   
		 *
		 * </code></pre>
		 * 
		 * @param dest Bitmap data onto which the tile will be drawn.
		 * @param destPoint Position within the tile at which to draw the tile.
		 */
		public function draw(dest:BitmapData, destPoint:Point) : void {
			if (tileset !== null && tileset.tmx !== null) {
				if (bitmapData !== null) {
					_mat.identity();
					_mat.translate(
						destPoint.x ,
						destPoint.y + tileset.tmx.tileHeight - bitmapData.height
					)
					dest.draw(bitmapData, _mat);
				}
			}
			else
				// XXX: Should be a more appropriate error type. Maybe create a new one?
				throw new ReferenceError("The tile is not a member of a tileset, or tileset is not a member of a TMX.");
		}
	}

}