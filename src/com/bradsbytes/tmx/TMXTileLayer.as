package com.bradsbytes.tmx
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
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
		
		/**
		 * Draws a portion of the layer onto a given BitmapData object.
		 * 
		 * <p>The layer must be inside a TMX for this to work.</p>
		 * 
		 * <p>The sourceRect parameter only specifies the area of the layer that will be drawn. It
		 * does NOT specify the exact area of the destination bitmap data that will be affected. That
		 * will depend on which cells within the layer intersect the given source rectangle. Even if
		 * a cell is only partially inside the rectangle, the whole tile for that cell will be drawn.
		 * As a result, the area of the destination bitmap that is affected by the draw will often
		 * be larger than the given source rectangle. This behavior is intentional as it decreases
		 * the complexity of drawing calculations and allows for oversized tiles to be drawn easily.</p>
		 * <p>Note that the drawing method currently assumes that the TMX is in orthogonal orientation,
		 * regardless of what the TMX's XML actually says. No support for other orientations is currently
		 * being planned.</p>
		 * 
		 * @param dest The destination bitmap data onto which the layer will be drawn.
		 * @param destPoint The position within the destination bitmap to draw the bitmap data.
		 * @param sourceRect The source area of the layer to draw measured in pixels.
		 */
		public function draw(dest : BitmapData, destPoint : Point, sourceRect : Rectangle) : void {
			
			// Do not draw if there is no TMX.
			if (tmx === null)
				throw new ReferenceError("The layer cannot be drawn because it is not inside a TMX.");
			
			// Cache some unchanging values
			var cellW : int = tmx.tileWidth;
			var cellH : int = tmx.tileHeight;
				
			// Convert the given pixel coordinates into grid locations.
			var gridLeft : int = sourceRect.left / cellW;
			var gridTop : int = sourceRect.top / cellH;
			var gridRight : int = Math.ceil(sourceRect.right / cellW);
			var gridBottom : int = Math.ceil(sourceRect.bottom / cellH);
			
			// Flip edges if necessary.
			var tmpEdge : int;
			if (gridLeft > gridRight) {
				tmpEdge = gridLeft;
				gridLeft = gridRight
				gridRight = tmpEdge;
			}
			if (gridTop > gridBottom) {
				tmpEdge = gridTop;
				gridTop = gridBottom;
				gridBottom = tmpEdge;
			}
			
			// Bound the edges.
			gridLeft = Math.max(Math.min(width - 1, gridLeft), 0);
			gridTop = Math.max(Math.min(height - 1, gridTop), 0);
			gridRight = Math.max(Math.min(width - 1, gridRight), 0);
			gridBottom = Math.max(Math.min(height - 1, gridBottom), 0);
			
			// Get the size of the drawn area.
			var gridW : int = gridRight - gridLeft + 1;
			var gridH : int = gridBottom - gridTop + 1;
			
			// Determine the pixel offsets caused by the source rectangle-to-cell intersections
			var deltaX : int = sourceRect.left - (gridLeft * cellW);
			var deltaY : int = sourceRect.top - (gridTop * cellH);
			
			// Used to position tiles when draw() method is used
			var mat : Matrix = new Matrix;
			
			// Draw the cells one by one.
			for (var row : uint = 0; row < gridH; row++) {
				for (var col : uint = 0; col < gridW; col++) {
					var tile : TMXTile = getTile(col + gridLeft, row + gridTop);
					// Don't draw if the cell is empty.
					if (tile !== null)
						tile.draw(
							dest,
							new Point(
								destPoint.x + (col * cellW) - deltaX,
								destPoint.y + (row * cellH) - deltaY
							)
						);
				}
			}
		}
	}

}