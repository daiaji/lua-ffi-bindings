--[[
Custom require loader for FFI bindings to handle platform-specific paths.
e.g. require 'ffi.req' 'Windows.sdk.kernel32' 
     -> tries ffi.Windows.x64.Windows.sdk.kernel32
     -> tries ffi.Windows.Windows.sdk.kernel32
     -> tries ffi.Windows.sdk.kernel32
--]]
local ffi = require 'ffi'
local assert = require 'ext.assert'

return function(req)
	-- [DEBUG] Trace FFI loading
	-- io.write("[FFI] Req: " .. req .. " ... ")
	-- io.stdout:flush()

	assert.type(req, 'string')
	local errs = {}
	
	-- Prioritize specific to generic paths
	local search_paths = {
		ffi.os..'.'..ffi.arch..'.'..req, -- e.g. ffi.Windows.x64.Name
		ffi.os..'.'..req,                -- e.g. ffi.Windows.Name
		ffi.arch..'.'..req,              -- e.g. ffi.x64.Name
		req,                             -- e.g. Name (or ffi.Name if caller included it)
	}

	for _, search in ipairs(search_paths) do
		-- Force 'ffi.' prefix if not present, assuming bindings are in 'ffi' folder
		local mod_name = search
		if not mod_name:match("^ffi%.") then
			mod_name = 'ffi.' .. mod_name
		end

		local found, result = xpcall(function()
			return require(mod_name)
		end, function(err)
			return err..'\n'..debug.traceback()
		end)

		if found then
			-- print("OK (" .. mod_name .. ")")
			return result
		else
			local err_msg = tostring(result)
			if not err_msg:find("not found") and not err_msg:find("no field package.preload") then
				print("\n[FFI] CRITICAL ERROR in " .. mod_name .. ":\n" .. err_msg)
				error("FFI Binding Error in '"..mod_name.."':\n"..err_msg)
			end
			table.insert(errs, "Failed " .. mod_name .. ": " .. err_msg)
		end
	end
	
	print("\n[FFI] FAILED to load " .. req)
	error("Could not load FFI binding '"..req.."'. Attempts:\n"..table.concat(errs, '\n'))
end