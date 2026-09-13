if CLIENT then
	EVENT.icon = Material("vgui/ttt/vskin/events/deci_test")
	EVENT.title = "ttt2_label_decipherer_event_title"
	
	function EVENT:GetText()
		return {
			{
				string = "ttt2_label_decipherer_event",
				params = {
					decipherer = self.event.decipherer,
					deciphererSID = self.event.deciphererSID,
					victim = self.event.victim,
					victimSID = self.event.victimSID,
					role = roles.GetByIndex(self.event.role).name
				},
                translateParams = true,
			},
		}
	end
end

if SERVER then
	function EVENT:Trigger(deciPly, victimPly)
		self:AddAffectedPlayers({deciPly:SteamID64(), victimPly:SteamID64()}, {deciPly:Nick(), victimPly:Nick()})
		
		return self:Add({
			decipherer = deciPly:Nick(),
			deciphererSID = deciPly:SteamID64(),
			victim = victimPly:Nick(),
			victimSID = victimPly:SteamID64(),
			role = victimPly:GetSubRole()
		})
	end
end

function EVENT:Serialize()
	return self.event.decipherer .. " has learned that " .. self.event.victim .. " is a " .. self.event.role .. " using a Minitester."
end
