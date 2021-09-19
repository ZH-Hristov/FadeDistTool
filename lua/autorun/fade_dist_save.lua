duplicator.RegisterEntityModifier( "fadedisttoolsave", function(ply, ent, data) 
	local fademindist, fademaxdist, smoothfade = data.fmind, data.fmaxd, data.smoothfade
	if ent then
		ent:SetKeyValue("fademindist", fademindist)
		ent:SetKeyValue("fademaxdist", fademaxdist)
		if data.smoothfade then
			ent:SetRenderMode( RENDERMODE_TRANSALPHA )
		end
	end
end)