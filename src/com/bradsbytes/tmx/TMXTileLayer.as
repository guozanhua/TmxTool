package com.bradsbytes.tmx
{
	/**
	 * Represents a tile layer from the .tmx file.
	 * 
	 * <p>Note that even though the TMXTileLayer object has its own width and height,
	 * these are intended to be used only during the short time after the layer is
	 * created but before it is added to the TMX. Once the layer is a member of a TMX,
	 * its size should match that of its parent TMX.</p>
	 * 
	 * <p>It is assumed that the tileWidth and tileHeight from the parent TMXMap will be
	 * used to determine grid cell sizes since different tilesets used by the layer
	 * may have differently-sized tiles. </p>
	 *
	 * @author Brad Harms
	 */
	public class TMXTileLayer extends AbstractTMXLayer
	{	
		protected var _tiles : Vector.<Vector.<TMXTile>>;
		
		/**
		 * Constructor.
		 */
		public function TMXTileLayer(name_ : String, width_ : uint, height_ : uint, filler : TMXTile = null) 
		{
			super(name_, width_, height_);
			_tiles = new Vector.<Vector.<TMXTile>>();
			resize(width_, height_, filler);
		}
		
		/**
		 * Return the TMXTile that corresponds to the given cell location within the layer.
		 * If there is no tile in the given location or if the position is outside the layer
		 * then null is returned.
		 */
		public function getTile(x:int, y:int) : TMXTile {
			if (x < 0 || x >= width || y < 0 || y >= height)
				return null;
			return _tiles[y][x];
		}
		
		/**
		 * Assign a tile to the given location within the layer.
		 */
		public function setTile(x:uint, y:uint, tile:TMXTile) : void {
			if (x >= width || y >= height)
				throw new RangeError("location is outside of the layer.");
			_tiles[y][x] = tile;
		}
		
		/**
		 * Assign a tile to the given location using a global tile ID.
		 * <p>
		 * 	The layer must be inside a TMX for this to work, or else a ReferenceError
		 *  will occur. This is because the GIDs come from the list of all tilesets
		 *  contained within the TMX.
		 * </p>
		 * <p>
		 * 	If the GID given is not available from any tileset within the current TMX,
		 *  the tile will become null.
		 * </p>
		 */
		public function setTileByGid(x:uint, y:uint, gid:uint) : void {
			if (tmx === null)
				throw new ReferenceError("The tile layer is not inside a TMX.");
			var tile : TMXTile = tmx.tilesets.getByGid(gid);
			setTile(x, y, tile);
		}
		
		// TODO: getCellsWithTile(tile) --> [[x,y], ...]
		// (Return a list of all coordinates containing a certain cell)
		
		// TODO: getCellsWithProperties([pname, ...]) --> [[x,y], ...]
		// (Return a list of all coordinates containing cells that have given properties)
		
		// TODO: getCellsWithPropertyValues({pname:pvalue, ...}) --> [[x,y], ...]
		// (Return a list of all coordinates containing cells that have given properties
		// with given values)
		
		/**
		 * Change the size of the layer.
		 * <p>
		 * 	If a dimension is increased, the new cells along that dimension will be
		 *  filled with the given filler tile. If a dimension is decreased, the conents
		 *  of cells along that dimension will be permanently lost.
		 * </p>
		 * <p>
		 * 	Remember that the size of a layer should always match the size of its containing TMX.
		 * </p>
		 */ 
		public function resize(newWidth : uint, newHeight : uint, filler : TMXTile = null) : void {
			// Remove excess rows
			while (_tiles.length > newHeight) {
				_tiles.pop();
			}
			
			// Add missing rows
			while (_tiles.length < newHeight) {
				_tiles.push(new Vector.<TMXTile>);
			}
			
			for each (var rowVec : Vector.<TMXTile> in _tiles) {
				// Remove excess columns
				while (rowVec.length > newWidth) {
					rowVec.pop();
				}
				
				// Add missing columns
				while (rowVec.length < newWidth) {
					rowVec.push(filler);
				}
			}
			
			// Save the size
			_width = newWidth;
			_height = newHeight;
		}
	}

}