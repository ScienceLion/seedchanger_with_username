dofile("data/scripts/lib/mod_settings.lua")

function mod_setting_change_callback( mod_id, gui, in_main_menu, setting, old_value, new_value  )
	if(tonumber(new_value) > 4294967295)then
		ModSettingSetNextValue( mod_setting_get_id(mod_id,setting), "4294967295", false )
		ModSettingSet(mod_setting_get_id(mod_id,setting), "4294967295")
	end
end


local mod_id = "seed_changer" -- This should match the name of your mod's folder.
mod_settings_version = 1 -- This is a magic global that can be used to migrate settings to new mod versions. call mod_settings_get_version() before mod_settings_update() to get the old value. 
mod_settings = 
{
	{
		id = "fixed_seed",
		ui_name = "Fixed world seed",
		ui_description = "Force the game to always start with the seed you set below",
		value_default = true,
		scope = MOD_SETTING_SCOPE_RUNTIME,
	},
	{
		id = "seed",
		ui_name = "World seed",
		ui_description = "The world seed you want to use.",
		value_default = "",
		scope = MOD_SETTING_SCOPE_RUNTIME,
		text_max_length = 10,
		allowed_characters = "0123456789",
		change_fn = mod_setting_change_callback,
	},
	{
		id = "nameseed",
		ui_name = "World seed from name",
		ui_description = "Use text to create a unique seed.",
		value_default = "",
		scope = MOD_SETTING_SCOPE_RUNTIME,
		text_max_length = 30,
		allowed_characters = "0123456789_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
	},
	{
		id = "guiSetting",
		ui_name = "Keep seed displayed",
		ui_description = "Keep the seed displayed after a minute.",
		value_default = false,
		scope = MOD_SETTING_SCOPE_RUNTIME,
	},
	{
		id = "guiHeight",
		ui_name = "Display height",
		ui_description = "Number of pixels from the top to display seed.",
		value_default = "40",
		scope = MOD_SETTING_SCOPE_RUNTIME,
		text_max_length = 3,
		allowed_characters = "0123456789",
	},
}

-- This function is called to ensure the correct setting values are visible to the game. your mod's settings don't work if you don't have a function like this defined in settings.lua.
function ModSettingsUpdate( init_scope )
	local old_version = mod_settings_get_version( mod_id ) -- This can be used to migrate some settings between mod versions.
	mod_settings_update( mod_id, mod_settings, init_scope )
end

-- This function should return the number of visible setting UI elements. 
-- Your mod's settings wont be visible in the mod settings menu if this function isn't defined correctly.
-- If your mod changes the displayed settings dynamically, you might need to implement custom logic for this function.
function ModSettingsGuiCount()
	return mod_settings_gui_count( mod_id, mod_settings )
end

-- This function is called to display the settings UI for this mod. your mod's settings wont be visible in the mod settings menu if this function isn't defined correctly.
function ModSettingsGui( gui, in_main_menu )
	mod_settings_gui( mod_id, mod_settings, gui, in_main_menu )
end
