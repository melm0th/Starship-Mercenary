local M = {}

function angleBetweenWithSrcLocalToContent ( srcObj, dstObj )
		srcObjContentX, srcObjContentY = srcObj:localToContent( 0, 0 )
        local xDist = dstObj.x-srcObjContentX ; local yDist = dstObj.y-srcObjContentY
        local angleBetween = math.deg( math.atan( yDist/xDist ) )
        if ( srcObjContentX < dstObj.x ) then angleBetween = angleBetween+90 else angleBetween = angleBetween-90 end
        return angleBetween
end
M.angleBetweenWithSrcLocalToContent = angleBetweenWithSrcLocalToContent

function angleBetween ( srcObj, dstObj )
        local xDist = dstObj.x-srcObj.x ; local yDist = dstObj.y-srcObj.y
        local angleBetween = math.deg( math.atan( yDist/xDist ) )
        if ( srcObj.x < dstObj.x ) then angleBetween = angleBetween+90 else angleBetween = angleBetween-90 end
        return angleBetween
end
M.angleBetween = angleBetween

local function distanceBetween( point1, point2 )
        local xfactor = point2.x-point1.x ; local yfactor = point2.y-point1.y
        local distanceBetween = math.sqrt((xfactor*xfactor) + (yfactor*yfactor))
        return distanceBetween
end
M.distanceBetween = distanceBetween

return M