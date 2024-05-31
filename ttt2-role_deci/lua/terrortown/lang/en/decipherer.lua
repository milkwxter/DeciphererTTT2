local L = LANG.GetLanguageTableReference("en")

-- GENERAL ROLE LANGUAGE STRINGS
L[DECIPHERER.name] = "Decipherer"
L["info_popup_" .. DECIPHERER.name] = [[You are the Decipherer! Learn what team your fellow terrorists belong to.]]
L["body_found_" .. DECIPHERER.abbr] = "They were a Decipherer."
L["search_role_" .. DECIPHERER.abbr] = "This person was a Decipherer!"
L["target_" .. DECIPHERER.name] = "Decipherer"
L["ttt2_desc_" .. DECIPHERER.name] = [[The Decipherer needs to use his Decipering Tool to learn the team of fellow terrorists.]]
L["credit_" .. DECIPHERER.abbr .. "_all"] = "Decipherer, you have been awarded {num} equipment credit(s) for your performance."

-- STATUS LANGUAGE STRINGS
L["lang_deci_status_charging"] = "Minitester charging cooldown"
L["lang_deci_status_charging_desc"] = "You cannot decipher roles until your minitester is charged again."
L["lang_deci_status_timer"] = "Minitester results incoming"
L["lang_deci_status_timer_desc"] = "When this timer hits 0, you will find out the player's role."

-- WEAPON LANGUAGE STRINGS
L["lang_deci_weapon_error"] = "ERROR! Your Minitester is still recharging."