TOOL.Category = "Render"
TOOL.Name = "Fade Distance"

TOOL.ClientConVar["fademindist"] = 0
TOOL.ClientConVar["fademaxdist"] = 1024
TOOL.ClientConVar["smoothfade"] = 1
TOOL.ClientConVar["applytosame"] = 0
function TOOL:LeftClick( trace )
	if trace.Hit and trace.Entity then
		local ent = trace.Entity
		if ent:GetClass() == "prop_effect" then
			ent = ent:GetChildren()[1]
		end
		local fademindist, fademaxdist = self:GetClientNumber("fademindist"), self:GetClientNumber("fademaxdist", 1024)
		ent:SetKeyValue("fademindist", fademindist)
		ent:SetKeyValue("fademaxdist", fademaxdist)
		if tobool(self:GetClientNumber("smoothfade")) and ent:GetRenderMode() == RENDERMODE_NORMAL then
			ent:SetRenderMode( RENDERMODE_TRANSALPHA )
		elseif !tobool(self:GetClientNumber("smoothfade"))  and ent:GetRenderMode() == RENDERMODE_TRANSALPHA then
			ent:SetRenderMode( RENDERMODE_NORMAL )
		end
		local data = {}
		data.fmind = fademindist
		data.fmaxd = fademaxdist
		data.smoothfade = tobool(self:GetClientNumber("smoothfade"))
		duplicator.StoreEntityModifier(ent, "fadedisttoolsave", data)
		
		if self:GetClientNumber("applytosame") == 1 then
			local entClass = ent:GetClass()
			local entModel = ent:GetModel()
			
			for _, v in ipairs(ents.FindByModel(entModel)) do
				if v:GetClass() == entClass then
					v:SetKeyValue("fademindist", fademindist)
					v:SetKeyValue("fademaxdist", fademaxdist)
					if tobool(self:GetClientNumber("smoothfade")) and v:GetRenderMode() == RENDERMODE_NORMAL then
						v:SetRenderMode( RENDERMODE_TRANSALPHA )
					elseif !tobool(self:GetClientNumber("smoothfade"))  and v:GetRenderMode() == RENDERMODE_TRANSALPHA then
						v:SetRenderMode( RENDERMODE_NORMAL )
					end
					duplicator.StoreEntityModifier(v, "fadedisttoolsave", data)
				end
			end
		end
		
		return true
	end
end

function TOOL:RightClick( trace )
	if trace.Hit and trace.Entity then
		local ent = trace.Entity
		if ent:GetClass() == "prop_effect" then
			ent = ent:GetChildren()[1]
		end
		local fademindist, fademaxdist = ent:GetKeyValues()["fademindist"], ent:GetKeyValues()[("fademaxdist")]
		fademindist, fademaxdist = tonumber(fademindist), tonumber(fademaxdist)
		self:GetOwner():ConCommand( "fadedist_fademindist "..fademindist)
		self:GetOwner():ConCommand( "fadedist_fademaxdist "..fademaxdist)
		return true
	end
end

function TOOL:Reload( trace )
	if trace.Hit and trace.Entity then
		local ent = trace.Entity
		if ent:GetClass() == "prop_effect" then
			ent = ent:GetChildren()[1]
		end
		ent:SetKeyValue("fademindist", -1)
		ent:SetKeyValue("fademaxdist", 0)
		ent:SetRenderMode( RENDERMODE_NORMAL )
		duplicator.ClearEntityModifier(ent, "fadedisttoolsave")
		return true
	end
end

if CLIENT then
	
	TOOL.Information = {

		{ name = "info", stage = 1 },
		{ name = "left" },
		{ name = "right" },
		{ name = "reload" }

	}

	language.Add("tool.fadedist.name", "Fade Distance Tool")
	language.Add("tool.fadedist.desc", "Set an entity's fade distance")
	language.Add("tool.fadedist.left", "Set fade distance")
	language.Add("tool.fadedist.right", "Get fade distance")
	language.Add("tool.fadedist.reload", "Remove fade")
	language.Add("tool.fadedist.fademindist", "Minimum Fade Distance")
	language.Add("tool.fadedist.fademaxdist", "Maximum Fade Distance")
	language.Add("tool.fadedist.smoothfade", "Enable Smooth Fade?")
	language.Add("tool.fadedist.applytosame", "Apply to all entities with same model and class?")
	
	function TOOL.BuildCPanel( panel )
		panel:NumSlider( "#tool.fadedist.fademindist", "fadedist_fademindist", 0, 30000, 0 )
		panel:NumSlider( "#tool.fadedist.fademaxdist", "fadedist_fademaxdist", 1, 30000, 0 )
		panel:CheckBox( "#tool.fadedist.smoothfade",  "fadedist_smoothfade")
		panel:CheckBox( "#tool.fadedist.applytosame", "fadedist_applytosame" )
	end
	
end